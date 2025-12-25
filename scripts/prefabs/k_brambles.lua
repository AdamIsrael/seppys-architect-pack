require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/bramble.zip"),
	Asset("ANIM", "anim/bramble1_build.zip"),
	Asset("ANIM","anim/bramble_core.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}
--[[
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
end

local function onhealthchange(inst)
	if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("wither")
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
		clearobstacle(inst)
	end
end

local function keeptargetfn()
    return false
end

local function onload(inst)
    if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("wither")
        clearobstacle(inst)
    end
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end
]]--
local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
end

local function onhammered(inst)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function bramble1fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_bramblebush.tex")
	
	inst.Transform:SetTwoFaced()
	local rotation = math.random()*360
    inst.Transform:SetRotation(rotation)
	
	inst.AnimState:SetBank("bramble_1")
	inst.AnimState:SetBuild("bramble1_build")
	inst.AnimState:PlayAnimation("idle")
	
	MakeObstaclePhysics(inst, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
	--[[
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	]]--
	inst:AddTag("structure")
	inst:AddTag("brambles")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	--[[
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(100)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = false
	inst.components.health.canheal = false

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	]]--
	inst:AddComponent("savedrotation")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	-- inst.OnLoad = onload
	MakeSnowCovered(inst, .01)
	
	return inst
end

local function bramble2fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_bramblebush.tex")
	
	inst.Transform:SetTwoFaced()
	local rotation = math.random()*360
    inst.Transform:SetRotation(rotation)
	
	inst.AnimState:SetBank("bramble_2")
	inst.AnimState:SetBuild("bramble1_build")
	inst.AnimState:PlayAnimation("idle")
	
	MakeObstaclePhysics(inst, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
	--[[
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	]]--
	inst:AddTag("structure")
	inst:AddTag("brambles")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	--[[
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(100)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = false
	inst.components.health.canheal = false

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	]]--
	inst:AddComponent("savedrotation")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	-- inst.OnLoad = onload
	MakeSnowCovered(inst, .01)
	
	return inst
end

local function bramble3fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_bramblebush.tex")
	
	inst.Transform:SetTwoFaced()
	local rotation = math.random()*360
    inst.Transform:SetRotation(rotation)
	
	inst.AnimState:SetBank("bramble_3")
	inst.AnimState:SetBuild("bramble1_build")
	inst.AnimState:PlayAnimation("idle")
	
	MakeObstaclePhysics(inst, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
	--[[
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	]]--
	inst:AddTag("structure")
	inst:AddTag("brambles")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	--[[
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(100)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = false
	inst.components.health.canheal = false

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	]]--
	inst:AddComponent("savedrotation")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	-- inst.OnLoad = onload
	MakeSnowCovered(inst, .01)
	
	return inst
end

local function bramblecorefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_bramblecore.tex")
	
	inst.AnimState:SetBank("bramble_core")
	inst.AnimState:SetBuild("bramble_core")
	inst.AnimState:PlayAnimation("idle")
	
	MakeObstaclePhysics(inst, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
	--[[
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	]]--
	inst:AddTag("structure")
	inst:AddTag("brambles")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	--[[
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(200)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = false
	inst.components.health.canheal = false

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	]]--
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	-- inst.OnLoad = onload
	MakeSnowCovered(inst, .01)
	
	return inst
end

return Prefab("kyno_bramble1", bramble1fn, assets, prefabs),
MakePlacer("kyno_bramble1_placer", "bramble_1", "bramble1_build", "idle", false, nil, nil, nil, 90, nil),

Prefab("kyno_bramble2", bramble2fn, assets, prefabs),
MakePlacer("kyno_bramble2_placer", "bramble_2", "bramble1_build", "idle", false, nil, nil, nil, 90, nil),

Prefab("kyno_bramble3", bramble3fn, assets, prefabs),
MakePlacer("kyno_bramble3_placer", "bramble_3", "bramble1_build", "idle", false, nil, nil, nil, 90, nil),

Prefab("kyno_bramblecore", bramblecorefn, assets, prefabs),
MakePlacer("kyno_bramblecore_placer", "bramble_core", "bramble_core", "idle")