require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/ruins_rubble.zip"),
}

local prefabs =
{
	"sap_brokenbits_full",
	"sap_brokenbits_med",
	"sap_brokenbits_low",
}

local function onhammered_full(inst, worker)
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_pot_bigger")
	inst:Remove()
	SpawnPrefab("sap_brokenbits_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onhammered_med(inst, worker)
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_pot_bigger")
	inst:Remove()
	SpawnPrefab("sap_brokenbits_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onhammered_low(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_pot_bigger")
	inst:Remove()
end

local function fullfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("relic.png")
	
	inst.AnimState:SetBank("rubble")
	inst.AnimState:SetBuild("ruins_rubble")
	inst.AnimState:PlayAnimation("full", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("brokenrelic")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_full)
	inst.components.workable:SetWorkLeft(1)
	
	MakeSnowCovered(inst, .01)

	return inst
end

local function medfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("relic.png")
	
	inst.AnimState:SetBank("rubble")
	inst.AnimState:SetBuild("ruins_rubble")
	inst.AnimState:PlayAnimation("med", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("brokenrelic")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_med)
	inst.components.workable:SetWorkLeft(1)
	
	MakeSnowCovered(inst, .01)

	return inst
end

local function lowfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("relic.png")
	
	inst.AnimState:SetBank("rubble")
	inst.AnimState:SetBuild("ruins_rubble")
	inst.AnimState:PlayAnimation("low", true)
	
	MakeObstaclePhysics(inst, .25)
	
	inst:AddTag("structure")
	inst:AddTag("brokenrelic")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_low)
	inst.components.workable:SetWorkLeft(1)
	
	MakeSnowCovered(inst, .01)

	return inst
end

return Prefab("sap_brokenbits_full", fullfn, assets, prefabs),
Prefab("sap_brokenbits_med", medfn, assets, prefabs),
Prefab("sap_brokenbits_low", lowfn, assets, prefabs),
MakePlacer("sap_brokenbits_full_placer", "rubble", "ruins_rubble", "full"),
MakePlacer("sap_brokenbits_med_placer", "rubble", "ruins_rubble", "med"),
MakePlacer("sap_brokenbits_low_placer", "rubble", "ruins_rubble", "low")