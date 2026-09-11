require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_snowman.zip"),
}

local prefabs =
{
    "tophat",
	"ice",
	"carrot",
}

local function OnIsPathFindingDirty(inst)    
    local wall_x, wall_y, wall_z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:GetPlatformAtPoint(wall_x, wall_z) == nil then        
        if inst._ispathfinding:value() then
            if inst._pfpos == nil then
                inst._pfpos = Point(wall_x, wall_y, wall_z)
                TheWorld.Pathfinder:AddWall(wall_x, wall_y, wall_z)
            end
        elseif inst._pfpos ~= nil then
            TheWorld.Pathfinder:RemoveWall(wall_x, wall_y, wall_z)
            inst._pfpos = nil
        end
    end
end

local function InitializePathFinding(inst)
    inst:ListenForEvent("onispathfindingdirty", OnIsPathFindingDirty)
    OnIsPathFindingDirty(inst)
end

local function makeobstacle(inst)
    inst.Physics:SetActive(true)
    inst._ispathfinding:set(true)
end

local function clearobstacle(inst)
    inst.Physics:SetActive(false)
    inst._ispathfinding:set(false)
	inst:DoTaskInTime(1, function() inst:Remove() end)
end

local function onhealthchange(inst)
	if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("death", true)
		inst:DoTaskInTime(1, function()
		clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
		end)
	end
end

local function keeptargetfn()
    return false
end

local function onload(inst)
    if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("death", true)
		inst:DoTaskInTime(3, function()
        clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
		end)
    end
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end

local function onhit(inst, iswinter)
	local healthpercent = inst.components.health:GetPercent()
	if healthpercent > 0 and TheWorld.state.iswinter then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle_loop", true)
	else
		inst.AnimState:PushAnimation("idle_pile", true)
	end
end

local function onnear(inst, iswinter)
	if TheWorld.state.iswinter then
		inst.AnimState:PlayAnimation("taunt")
		inst.AnimState:PushAnimation("idle_loop", true)
	else
		inst.AnimState:PushAnimation("idle_pile", true)
	end
end

local function onfar(inst)
	-- inst.AnimState:PlayAnimation("idle_loop", true)
end

local function WakeUp(inst, iswinter)
    if TheWorld.state.iswinter then
        inst.AnimState:PlayAnimation("transform")
		inst.AnimState:PushAnimation("idle_loop", true)
		inst:AddTag("snowman_1")
		inst:RemoveTag("snowman_2")
    else
        inst.AnimState:PlayAnimation("death")
		inst.AnimState:PushAnimation("idle_pile", true)
		inst:AddTag("snowman_2")
		inst:RemoveTag("snowman_1")
		inst.hibernate = true
    end
end

local function OnSave(inst, data)
	if inst.hibernate then
		data.hibernate = true
	end
end

local function OnLoad(inst, data)
	if data and data.hibernate then
		inst.hibernate = true
		inst.AnimState:PlayAnimation("idle_pile")
		inst:RemoveTag("snowman_1")
		inst:AddTag("snowman_2")
	end
end

local function onbuilt(inst)
    WakeUp(inst)
end

local function rename(inst)
    inst.components.named:PickNewName()
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_snowman.tex")
	
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("kyno_snowman")
	inst.AnimState:SetBuild("kyno_snowman") 
	inst.AnimState:PlayAnimation("idle_loop", true)
	
	MakeObstaclePhysics(inst, 1)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("snowman_1")
	inst:AddTag("legacy_content")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(200)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false
	inst.components.health.redirect = nodebrisdmg

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(5, 7)
    inst.components.playerprox:SetOnPlayerNear(onnear)
	inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Tinder Snowflake", "Olaf", "Snowman", "Frosty Snowman" }
    inst.components.named:PickNewName()
    inst:DoPeriodicTask(5, rename)
	
	inst:AddComponent("savedrotation")
	
	inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
	
	inst:DoTaskInTime(1/30, function()
	inst:WatchWorldState("iswinter", WakeUp)
    WakeUp(inst, TheWorld.state.iswinter)
	end)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

return Prefab("sap_snowman", fn, assets, prefabs),
MakePlacer("sap_snowman_placer", "kyno_snowman", "kyno_snowman", "idle_loop", false, nil, nil, nil, 90, nil)