local assets =
{
    Asset("ANIM", "anim/packim_fishbone.zip"),
}

local SPAWN_DIST = 30

local function OpenEye(inst)
    if not inst.isOpenEye then
        inst.isOpenEye = true
        inst.components.inventoryitem:ChangeImageName(inst.openEye)
        inst.AnimState:PlayAnimation("idle_loop", true)
    end
end

local function CloseEye(inst)
    if inst.isOpenEye then
        inst.isOpenEye = nil
        inst.components.inventoryitem:ChangeImageName(inst.closedEye)
        inst.AnimState:PlayAnimation("dead", true)
    end
end

local function RefreshEye(inst)
    inst.components.inventoryitem:ChangeImageName(inst.isOpenEye and inst.openEye or inst.closedEye)
end

local function GetSpawnPoint(pt)
    local theta = math.random() * 2 * PI
    local radius = SPAWN_DIST
    local offset = FindWalkableOffset(pt, theta, radius, 12, true)
    return offset ~= nil and (pt + offset) or nil
end

local function SpawnPackim(inst)
    print("packim_fishbone - SpawnPackim")

    local pt = inst:GetPosition()
    --print("    near", pt)

    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt ~= nil then
        print("    at", spawn_pt)
        local packim = SpawnPrefab("packim")
        if packim ~= nil then
            packim.Physics:Teleport(spawn_pt:Get())
            packim:FacePoint(pt:Get())

            return packim
        end
    end
end

local StartRespawn

local function StopRespawn(inst)
    if inst.respawntask ~= nil then
        inst.respawntask:Cancel()
        inst.respawntask = nil
        inst.respawntime = nil
    end
end

local function RebindPackim(inst, chester)
    chester = chester or TheSim:FindFirstEntityWithTag("packim")
    if chester ~= nil then
        OpenEye(inst)
        inst:ListenForEvent("death", function() StartRespawn(inst, TUNING.CHESTER_RESPAWN_TIME) end, chester)

        if chester.components.follower.leader ~= inst then
            chester.components.follower:SetLeader(inst)
        end
        return true
    end
end

local function RespawnPackim(inst)
    StopRespawn(inst)
    RebindPackim(inst, TheSim:FindFirstEntityWithTag("packim") or SpawnPackim(inst))
end

StartRespawn = function(inst, time)
    StopRespawn(inst)

    time = time or 0
    inst.respawntask = inst:DoTaskInTime(time, RespawnPackim)
    inst.respawntime = GetTime() + time
    CloseEye(inst)
end

local function FixPackim(inst)
    inst.fixtask = nil
    if not RebindPackim(inst) then
        CloseEye(inst)
        
        if inst.components.inventoryitem.owner ~= nil then
            local time_remaining = inst.respawntime ~= nil and math.max(0, inst.respawntime - GetTime()) or 0
            StartRespawn(inst, time_remaining)
        end
    end
end

local function OnPutInInventory(inst)
    if inst.fixtask == nil then
        inst.fixtask = inst:DoTaskInTime(1, FixPackim)
    end
end

local function OnSave(inst, data)
    data.FishboneState = inst.FishboneState
    if inst.respawntime ~= nil then
        local time = GetTime()
        if inst.respawntime > time then
            data.respawntimeremaining = inst.respawntime - time
        end
    end
end

local function OnLoad(inst, data)
    if data == nil then
        return
    end
    if data.respawntimeremaining ~= nil then
        inst.respawntime = data.respawntimeremaining + GetTime()
    else
        OpenEye(inst)
    end
end

local function GetStatus(inst)
    return inst.respawntask ~= nil and "WAITING" or nil
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "small", 0.05)

    inst:AddTag("packim_fishbone")
    inst:AddTag("irreplaceable")
    inst:AddTag("nonpotatable")

    inst.AnimState:SetBank("fishbone")
    inst.AnimState:SetBuild("packim_fishbone")
    inst.AnimState:PlayAnimation("dead", true)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.FishboneState = "NORMAL"
    inst.openEye = "packim_fishbone"
    inst.closedEye = "packim_fishbone_dead"
    inst.isOpenEye = nil

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
    inst.components.inventoryitem:ChangeImageName(inst.closedEye)
    inst.components.inventoryitem:SetSinks(false)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable:RecordViews()

    inst:AddComponent("leader")

    MakeHauntableLaunch(inst)

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave

    inst.fixtask = inst:DoTaskInTime(1, FixPackim)

    return inst
end

return Prefab("packim_fishbone", fn, assets)