require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/bee_queen_hive.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"honey_splash"
}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("honey")
	inst.components.lootdropper:SpawnLootPrefab("honey")
	inst:Remove()
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hive_hit")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("large_hit")
    inst.AnimState:PushAnimation("large", true)
	SpawnPrefab("honey_splash").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hive_hit")
end

local function onhit_medium(inst, worker)
    inst.AnimState:PlayAnimation("medium_hit")
    inst.AnimState:PushAnimation("medium", true)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hive_hit")
end

local function onhit_small(inst, worker)
    inst.AnimState:PlayAnimation("small_hit")
    inst.AnimState:PushAnimation("small", true)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/bee_queen/hive_hit")
end

local function honeypatchfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("beequeenhive.png")
	
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("bee_queen_hive")
	inst.AnimState:SetBuild("bee_queen_hive")
	inst.AnimState:PlayAnimation("hole_idle")
	
	inst:AddTag("structure")
	inst:AddTag("blocker")
	inst:AddTag("antlion_sinkhole_blocker")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "BEEQUEENHIVE"
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	return inst
end

local function largefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("beequeenhivegrown.png")
	
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
	MakeObstaclePhysics(inst, 1.9)
	
	inst.AnimState:SetBank("bee_queen_hive")
	inst.AnimState:SetBuild("bee_queen_hive")
	inst.AnimState:PlayAnimation("large")
	
	inst:AddTag("structure")
	inst:AddTag("blocker")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("_named")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "BEEQUEENHIVEGROWN"
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(12)
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Gigantic Beehive" }
    inst.components.named:PickNewName()

	return inst
end

local function mediumfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("beequeenhivegrown.png")
	
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
	MakeObstaclePhysics(inst, 1.5)
	
	inst.AnimState:SetBank("bee_queen_hive")
	inst.AnimState:SetBuild("bee_queen_hive")
	inst.AnimState:PlayAnimation("medium")
	inst.AnimState:Hide("honey0")
    inst.AnimState:Hide("honey1")
    inst.AnimState:Hide("honey2")
	
	inst:AddTag("structure")
	inst:AddTag("blocker")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("_named")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "BEEQUEENHIVEGROWN"
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit_medium)
	inst.components.workable:SetWorkLeft(6)
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Gigantic Beehive" }
    inst.components.named:PickNewName()

	return inst
end

local function smallfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("beequeenhivegrown.png")
	
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
	MakeObstaclePhysics(inst, .9)
	
	inst.AnimState:SetBank("bee_queen_hive")
	inst.AnimState:SetBuild("bee_queen_hive")
	inst.AnimState:PlayAnimation("small")
	inst.AnimState:Hide("honey0")
    inst.AnimState:Hide("honey1")
    inst.AnimState:Hide("honey2")
	
	inst:AddTag("structure")
	inst:AddTag("blocker")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("_named")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "BEEQUEENHIVEGROWN"
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit_small)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Gigantic Beehive" }
    inst.components.named:PickNewName()

	return inst
end

local function giantbeehiveplacetestfn(inst)
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
end

return Prefab("sap_honeypatch", honeypatchfn, assets, prefabs),
Prefab("sap_giantbeehive", largefn, assets, prefabs),
Prefab("sap_giantbeehive_medium", mediumfn, assets, prefabs),
Prefab("sap_giantbeehive_small", smallfn, assets, prefabs),
MakePlacer("sap_honeypatch_placer", "bee_queen_hive", "bee_queen_hive", "hole_idle", false, nil, nil, nil, nil, nil, giantbeehiveplacetestfn),
MakePlacer("sap_giantbeehive_placer", "bee_queen_hive", "bee_queen_hive", "large", false, nil, nil, nil, nil, nil, giantbeehiveplacetestfn),
MakePlacer("sap_giantbeehive_medium_placer", "bee_queen_hive", "bee_queen_hive", "medium", false, nil, nil, nil, nil, nil, giantbeehiveplacetestfn),
MakePlacer("sap_giantbeehive_small_placer", "bee_queen_hive", "bee_queen_hive", "small", false, nil, nil, nil, nil, nil, giantbeehiveplacetestfn)
