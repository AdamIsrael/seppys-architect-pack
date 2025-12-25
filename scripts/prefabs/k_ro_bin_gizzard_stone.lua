local assets=
{
    Asset("ANIM", "anim/ro_bin_gem.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
}

local SPAWN_DIST = 30

local function RoBinDead(inst)
	inst.components.inventoryitem:ChangeImageName(inst.closedEye)
end

local function RoBinLive(inst)
	inst.components.inventoryitem:ChangeImageName(inst.openEye)
end

local function NoHoles(pt)
    return not TheWorld.Map:IsPointNearHole(pt)
end

local function GetSpawnPoint(pt)
	local offset = FindWalkableOffset(pt, math.random() * 2 * PI, SPAWN_DIST, 12, true, true, NoHoles)
    if offset ~= nil then
        offset.x = offset.x + pt.x
        offset.z = offset.z + pt.z
        return offset
    end
end

local function SpawnRoBin(inst)
    local pt = inst:GetPosition()
    local spawn_pt = GetSpawnPoint(pt)
    if spawn_pt ~= nil then
        local ro_bin = SpawnPrefab("ro_bin")
        if ro_bin ~= nil then
            ro_bin.Physics:Teleport(spawn_pt:Get())
            ro_bin:FacePoint(pt:Get())
            return ro_bin
        end
    end
end

local StartRespawn 

local function StopRespawn(inst)
    if inst.respawntask then
        inst.respawntask:Cancel()
        inst.respawntask = nil
        inst.respawntime = nil
    end
end

local function RebindRoBin(inst, ro_bin)
    ro_bin = ro_bin or TheSim:FindFirstEntityWithTag("ro_bin")
    if ro_bin then
		RoBinLive(inst)
		inst:ListenForEvent("death", function() StartRespawn(inst, TUNING.CHESTER_RESPAWN_TIME) end, ro_bin)

        if ro_bin.components.follower.leader ~= inst then
            ro_bin.components.follower:SetLeader(inst)
        end
        return true
    end
end

local function RespawnRoBin(inst)
    StopRespawn(inst)
    RebindRoBin(inst, TheSim:FindFirstEntityWithTag("ro_bin") or SpawnRoBin(inst))
end

function StartRespawn(inst, time)
    StopRespawn(inst)

    local time = time or 0
    inst.respawntask = inst:DoTaskInTime(time, RespawnRoBin)
    inst.respawntime = GetTime() + time
    if time > 0 then
        RoBinDead(inst)
    end
end

local function FixRoBin(inst)
	inst.fixtask = nil
	if not RebindRoBin(inst) then
        RoBinDead(inst)
		if inst.components.inventoryitem.owner then
            local time_remaining = inst.respawntime ~= nil and math.max(0, inst.respawntime - GetTime()) or 0
			StartRespawn(inst, time_remaining)
		end
	end
end

local function OnPutInInventory(inst)
	if not inst.fixtask then
		inst.fixtask = inst:DoTaskInTime(1, FixRoBin)
	end
end

local function OnSave(inst, data)
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
        if data.respawntimeremaining > 0 then
            RoBinDead(inst, true)
        end
    end
end

local function GetStatus(inst)
    return inst.respawntask ~= nil and "WAITING" or nil
end

local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
		
    MakeInventoryPhysics(inst)

    inst:AddTag("ro_bin_gizzard_stone") 
    inst:AddTag("irreplaceable")
	inst:AddTag("nonpotatable")

    inst.AnimState:SetBank("ro_bin_gem")
    inst.AnimState:SetBuild("ro_bin_gem")
    inst.AnimState:PlayAnimation("idle_loop", true)

	if CurrentRelease.GreaterOrEqualTo("R08_ROT_TURNOFTIDES") then
		MakeInventoryFloatable(inst)
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.openEye = "ro_bin_gizzard_stone"
    inst.closedEye = "ro_bin_gizzard_stone_closed"
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)
    -- inst.components.inventoryitem.imagename = "ro_bin_gizzard_stone"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

	if not CurrentRelease.GreaterOrEqualTo("R08_ROT_TURNOFTIDES") then
		MakeInventoryFloatable(inst, "idle_water", "idle_loop")
	end

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus
    inst.components.inspectable:RecordViews()

    inst:AddComponent("leader")

    MakeHauntableLaunch(inst)

    inst.OnLoad = OnLoad
    inst.OnSave = OnSave

	inst.fixtask = inst:DoTaskInTime(1, FixRoBin)

    inst:DoPeriodicTask(3 + math.random(), function(inst)
        -- We somehow got a ro bin without a gizzard stone. Kill it! Kill it with fire!
        if not TheSim:FindFirstEntityWithTag("ro_bin") then
        inst.AnimState:PlayAnimation("dead", true)
	else
		inst.AnimState:PlayAnimation("idle_loop", true)
        end
    end)

    return inst
end

return Prefab("ro_bin_gizzard_stone", fn, assets)