require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/foot_build.zip"),
	Asset("ANIM", "anim/foot_basic.zip"),
	Asset("ANIM", "anim/foot_print.zip"),
	Asset("ANIM", "anim/foot_shadow.zip"),
	Asset("ANIM", "anim/kyno_foot.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "sap_biigfoot_footprint",
	"sap_biigfoot_footshadow",
	"groundpound_fx",
    "groundpoundring_fx",
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
	inst:DoTaskInTime(2, function() inst:Remove() end)
end

local function onhealthchange(inst)
	if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("idle", true)
		clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
	end
end

local function keeptargetfn()
    return false
end

local function onload(inst)
    if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("idle", true)
        clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
    end
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end

local function onhit(inst)
	local healthpercent = inst.components.health:GetPercent()
        if healthpercent > 0 then
		inst.AnimState:PlayAnimation("idle", true)
	end
end

local function onbuilt(inst)	
	inst:DoTaskInTime(10, function(inst) end)
	inst.AnimState:PlayAnimation("stomp")
	inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/glommer/foot_ground")
end

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("turf_desertdirt")
	inst.components.lootdropper:SpawnLootPrefab("turf_desertdirt")
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("foot")
	inst.AnimState:SetBuild("foot_build") 
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 3)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("biigfoot")
	
	inst:SetPrefabNameOverride("bigfoot")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(100)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	
	inst:AddComponent("savedrotation")
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

local function footfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("kyno_foot")
	inst.AnimState:SetBuild("kyno_foot") 
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	inst.AnimState:SetFinalOffset(1)
	
	inst:AddTag("structure")
	inst:AddTag("biigfoot_footprint")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("savedrotation")
	
	return inst
end

local function shadowfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(2, 2, 2)
	
	inst.AnimState:SetBank("foot_shadow")
	inst.AnimState:SetBuild("foot_shadow") 
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	
	inst.persists = false
	
	inst:AddTag("structure")
	inst:AddTag("biigfoot_footprint")
	inst:AddTag("FX")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")	
	
	return inst
end

return Prefab("sap_biigfoot", fn, assets, prefabs),
Prefab("sap_biigfoot_footprint", footfn, assets, prefabs),
Prefab("sap_biigfoot_footshadow", shadowfn, assets, prefabs),
MakePlacer("sap_biigfoot_placer", "foot", "foot_build", "idle", false, nil, nil, nil, 90, nil),
MakePlacer("sap_biigfoot_footprint_placer", "kyno_foot", "kyno_foot", "idle", true, nil, nil, nil, 90, nil)