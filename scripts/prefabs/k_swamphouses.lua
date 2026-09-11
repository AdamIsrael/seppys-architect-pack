require "prefabutil"

local assets =
{ 
	-- Animations now loaded globally in tap_assets.lua to prevent orphaned resources.
    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
    "merm",
    "collapse_big",
	"sap_swampmermhouserubble",
	"sap_swampmermhouserubble2",
	"sap_pigworn",
    "boards",
    "rocks",
    "pondfish",
}

local loot =
{
    "boards",
    "rocks",
    "pondfish",
}

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst:RemoveComponent("childspawner")
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
	SpawnPrefab("sap_swampmermhouserubble2").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.childspawner ~= nil then
            inst.components.childspawner:ReleaseAllChildren(worker)
        end
        inst.AnimState:PlayAnimation("weremerm")
        inst.AnimState:PushAnimation("weremerm")
    end
end

local function StartSpawning(inst)
    if not inst:HasTag("burnt") and
        not TheWorld.state.iswinter and
        inst.components.childspawner ~= nil then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if not inst:HasTag("burnt") and inst.components.childspawner ~= nil then
        inst.components.childspawner:StopSpawning()
    end
end

local function OnSpawned(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
        if TheWorld.state.isday and
            inst.components.childspawner ~= nil and
            inst.components.childspawner:CountChildrenOutside() >= 1 and
            child.components.combat.target == nil then
            StopSpawning(inst)
        end
    end
end

local function OnGoHome(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
        if inst.components.childspawner ~= nil and
            inst.components.childspawner:CountChildrenOutside() < 1 then
            StartSpawning(inst)
        end
    end
end

local function OnIsDay(inst, isday)
    if isday then
        StopSpawning(inst)
    elseif not inst:HasTag("burnt") then
        if not TheWorld.state.iswinter then
            inst.components.childspawner:ReleaseAllChildren()
        end
        StartSpawning(inst)
    end
end

local function OnHaunt(inst)
    if inst.components.childspawner == nil or
        not inst.components.childspawner:CanSpawn() or
        math.random() > TUNING.HAUNT_CHANCE_HALF then
        return false
    end

    local target = FindEntity(inst, 25, nil, { "character" }, { "merm", "playerghost", "INLIMBO" })
    if target == nil then
        return false
    end

    onhit(inst, target)
    return true
end

local function onhammered_rubble(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhammered_rubble2(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_swampmermhouserubble2").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onhit_rubble(inst, worker)
    inst.AnimState:PlayAnimation("rubble")
    inst.AnimState:PushAnimation("rubble")
end

local function onhit_rundown(inst, worker)
    inst.AnimState:PlayAnimation("rundown")
    inst.AnimState:PushAnimation("rundown")
end

local function onbuilt(inst)
	inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/hut/place")
    inst.AnimState:PushAnimation("weremerm")
end

local function onbuilt_rundown(inst)
	inst.SoundEmitter:PlaySound("dontstarve/characters/wurt/merm/hut/place")
    inst.AnimState:PushAnimation("rundown")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_swamphouse_merm.tex")

    inst.AnimState:SetBank("kyno_swamphouses")
    inst.AnimState:SetBuild("kyno_swamphouses")
    inst.AnimState:PlayAnimation("weremerm")
	
	MakeObstaclePhysics(inst, 1)

	inst:AddTag("structure")	
	inst:AddTag("gorge_structure")
	
	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SWAMPIG_HOUSE"
	
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "merm"
	inst.components.childspawner:SetSpawnedFn(OnSpawned)
	inst.components.childspawner:SetGoHomeFn(OnGoHome)
	inst.components.childspawner:SetRegenPeriod(TUNING.TOTAL_DAY_TIME * 4)
    inst.components.childspawner:SetSpawnPeriod(10)
    inst.components.childspawner:SetMaxChildren(TUNING.MERMHOUSE_MERMS)
    inst.components.childspawner:SetMaxEmergencyChildren(TUNING.MERMHOUSE_EMERGENCY_MERMS)
	inst.components.childspawner.emergencychildname = "merm"
	inst.components.childspawner:SetEmergencyRadius(TUNING.MERMHOUSE_EMERGENCY_RADIUS)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	inst.components.hauntable:SetOnHauntFn(OnHaunt)

	inst:WatchWorldState("isday", OnIsDay)
	StartSpawning(inst)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	MakeSnowCovered(inst)

    return inst
end

local function rubblefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_swamphouse_rubble.tex")

    inst.AnimState:SetBank("kyno_swamphouses")
    inst.AnimState:SetBuild("kyno_swamphouses")
    inst.AnimState:PlayAnimation("rubble")
	
	MakeObstaclePhysics(inst, 1)

	inst:AddTag("structure")	
	inst:AddTag("gorge_structure")
	
	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SWAMPIG_HOUSE_RUBBLE"
	
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered_rubble)
    inst.components.workable:SetOnWorkCallback(onhit_rubble)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeSnowCovered(inst)

    return inst
end

local function rubble2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_swamphouse_rubble.tex")

    inst.AnimState:SetBank("kyno_swamphouses")
    inst.AnimState:SetBuild("kyno_swamphouses")
    inst.AnimState:PlayAnimation("rubble")
	
	MakeObstaclePhysics(inst, 1)

	inst:AddTag("structure")	
	inst:AddTag("gorge_structure")
	
	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SWAMPIG_HOUSE_RUBBLE"
	
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered_rubble)
    inst.components.workable:SetOnWorkCallback(onhit_rubble)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeSnowCovered(inst)

    return inst
end

local pig_front = 1

local pig_defs = {
	pig = { { -1.28, 0, 2.14 } },
}

local function wornfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_swamphouse_pig.tex")
	
    inst.AnimState:SetBank("kyno_swamphouses")
    inst.AnimState:SetBuild("kyno_swamphouses")
    inst.AnimState:PlayAnimation("rundown")
	
	MakeObstaclePhysics(inst, 1)

	inst:AddTag("structure")	
	inst:AddTag("gorge_structure")
	
	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SWAMPIG_HOUSE"
	
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered_rubble2)
    inst.components.workable:SetOnWorkCallback(onhit_rundown)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt_rundown)
	MakeSnowCovered(inst)

    return inst
end

local function pigfn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()
	inst.DynamicShadow:SetSize(1.5, .75)

    inst.AnimState:SetBank("pigman")
    inst.AnimState:SetBuild("quagmire_swampig_build")
    inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:Hide("hat")
	
	MakeObstaclePhysics(inst, 1)

	inst:AddTag("structure")	
	inst:AddTag("gorge_pig")
	
	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SWAMPIG"
	
    inst:AddComponent("lootdropper")

    return inst
end


return Prefab("sap_swampmermhouse", fn, assets, prefabs),
Prefab("sap_swampmermhouserubble", rubblefn, assets, prefabs),
Prefab("sap_swampmermhouserubble2", rubble2fn, assets, prefabs),
Prefab("sap_swamppighouse", wornfn, assets, prefabs),
Prefab("sap_pigworn", pigfn, assets, prefabs),
MakePlacer("sap_swampmermhouse_placer", "kyno_swamphouses", "kyno_swamphouses", "weremerm"),
MakePlacer("sap_swampmermhouserubble_placer", "kyno_swamphouses", "kyno_swamphouses", "rubble"),
MakePlacer("sap_swamppighouse_placer", "kyno_swamphouses", "kyno_swamphouses", "rundown")