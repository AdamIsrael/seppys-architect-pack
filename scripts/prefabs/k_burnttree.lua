require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/evergreen_new.zip"), 
    Asset("ANIM", "anim/evergreen_new_2.zip"), 
    Asset("ANIM", "anim/evergreen_tall_old.zip"),
    Asset("ANIM", "anim/evergreen_short_normal.zip"),
	
	Asset("ANIM", "anim/tree_leaf_short.zip"),
	Asset("ANIM", "anim/tree_leaf_normal.zip"),
    Asset("ANIM", "anim/tree_leaf_tall.zip"),
	Asset("ANIM", "anim/tree_leaf_trunk_build.zip"),
	
	Asset("ANIM", "anim/twiggy_build.zip"),
    Asset("ANIM", "anim/twiggy_short_normal.zip"),
    Asset("ANIM", "anim/twiggy_tall_old.zip"),
	
	Asset("ANIM", "anim/moon_tree.zip"),
	
	Asset("ANIM", "anim/tree_marsh.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("SOUND", "sound/forest.fsb"),
	Asset("SOUND", "sound/deciduous.fsb"),
}

local prefabs =
{
	"charcoal",
}

local function chop_burnt(inst, chopper)
    inst:RemoveComponent("workable")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	inst.AnimState:PlayAnimation("burnt_chop")
    RemovePhysicsColliders(inst)
	inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
	-- inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
end

local function chop_burnt_short(inst, chopper)
    inst:RemoveComponent("workable")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	inst.AnimState:PlayAnimation("chop_burnt_short")
    RemovePhysicsColliders(inst)
	inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
	-- inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
end

local function chop_burnt_normal(inst, chopper)
    inst:RemoveComponent("workable")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	inst.AnimState:PlayAnimation("chop_burnt_normal")
    RemovePhysicsColliders(inst)
	inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
	-- inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
end

local function chop_burnt_tall(inst, chopper)
    inst:RemoveComponent("workable")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	inst.AnimState:PlayAnimation("chop_burnt_tall")
    RemovePhysicsColliders(inst)
	inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
	-- inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
end

local function shortfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("evergreen_burnt.png")

	inst.AnimState:SetBank("evergreen_short")
	inst.AnimState:SetBuild("evergreen_new")
	inst.AnimState:PlayAnimation("burnt_short", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("evergreen")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_short)

	MakeSnowCovered(inst, .01)
	
	return inst
end

local function normalfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("evergreen_burnt.png")

	inst.AnimState:SetBank("evergreen_short")
	inst.AnimState:SetBuild("evergreen_new")
	inst.AnimState:PlayAnimation("burnt_normal", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("evergreen")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_normal)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeSnowCovered(inst, .01)

	return inst
end

local function tallfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("evergreen_burnt.png")

	inst.AnimState:SetBank("evergreen_short")
	inst.AnimState:SetBuild("evergreen_new")
	inst.AnimState:PlayAnimation("burnt_tall", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("evergreen")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_tall)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeSnowCovered(inst, .01)
	
	return inst
end

local function short_deciduousfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("tree_leaf_burnt.png")

	inst.AnimState:SetBank("tree_leaf")
	inst.AnimState:SetBuild("tree_leaf_trunk_build")
	inst.AnimState:PlayAnimation("burnt_short", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("deciduoustree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_short)

	MakeSnowCovered(inst, .01)
	
	return inst
end

local function normal_deciduousfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("tree_leaf_burnt.png")

	inst.AnimState:SetBank("tree_leaf")
	inst.AnimState:SetBuild("tree_leaf_trunk_build")
	inst.AnimState:PlayAnimation("burnt_normal", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("deciduoustree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_normal)

	MakeSnowCovered(inst, .01)
	
	return inst
end

local function tall_deciduousfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("tree_leaf_burnt.png")

	inst.AnimState:SetBank("tree_leaf")
	inst.AnimState:SetBuild("tree_leaf_trunk_build")
	inst.AnimState:PlayAnimation("burnt_tall", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("deciduoustree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_tall)

	MakeSnowCovered(inst, .01)
	
	return inst
end

local function short_twiggyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("twiggy_burnt.png")

	inst.AnimState:SetBank("twiggy")
	inst.AnimState:SetBuild("twiggy_build")
	inst.AnimState:PlayAnimation("burnt_short", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "TWIGGY_SHORT"
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_short)

	MakeSnowCovered(inst, .01)
	
	return inst
end

local function normal_twiggyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("twiggy_burnt.png")

	inst.AnimState:SetBank("twiggy")
	inst.AnimState:SetBuild("twiggy_build")
	inst.AnimState:PlayAnimation("burnt_normal", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "TWIGGY_NORMAL"
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_normal)

	MakeSnowCovered(inst, .01)
	
	return inst
end

local function tall_twiggyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("twiggy_burnt.png")

	inst.AnimState:SetBank("twiggy")
	inst.AnimState:SetBuild("twiggy_build")
	inst.AnimState:PlayAnimation("burnt_tall", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "TWIGGY_TALL"
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_tall)

	MakeSnowCovered(inst, .01)
	
	return inst
end

local function short_moonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("moon_tree_burnt.png")

	inst.AnimState:SetBank("moon_tree")
	inst.AnimState:SetBuild("moon_tree")
	inst.AnimState:PlayAnimation("burnt_short", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOON_TREE_SHORT"
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_short)

	MakeSnowCovered(inst, .01)
	
	return inst
end

local function normal_moonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("moon_tree_burnt.png")

	inst.AnimState:SetBank("moon_tree")
	inst.AnimState:SetBuild("moon_tree")
	inst.AnimState:PlayAnimation("burnt_normal", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOON_TREE_NORMAL"
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_normal)

	MakeSnowCovered(inst, .01)
	
	return inst
end

local function tall_moonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("moon_tree_burnt.png")

	inst.AnimState:SetBank("moon_tree")
	inst.AnimState:SetBuild("moon_tree")
	inst.AnimState:PlayAnimation("burnt_tall", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOON_TREE_TALL"
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt_tall)

	MakeSnowCovered(inst, .01)
	
	return inst
end

local function tall_marshfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("marshtree_burnt.png")

	inst.AnimState:SetBank("marsh_tree")
	inst.AnimState:SetBuild("tree_marsh")
	inst.AnimState:PlayAnimation("burnt_idle", true)
	
	inst:AddTag("burnt_tree")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MARSH_TREE"
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(chop_burnt)

	MakeSnowCovered(inst, .01)
	
	return inst
end

return Prefab("kyno_burnttree_short", shortfn, assets, prefabs),
MakePlacer("kyno_burnttree_short_placer", "evergreen_short", "evergreen_new", "burnt_short"),
Prefab("kyno_burnttree_normal", normalfn, assets, prefabs),
MakePlacer("kyno_burnttree_normal_placer", "evergreen_short", "evergreen_new", "burnt_normal"),
Prefab("kyno_burnttree_tall", tallfn, assets, prefabs),
MakePlacer("kyno_burnttree_tall_placer", "evergreen_short", "evergreen_new", "burnt_tall"),

Prefab("kyno_burnttree2_short", short_deciduousfn, assets, prefabs),
MakePlacer("kyno_burnttree2_short_placer", "tree_leaf", "tree_leaf_trunk_build", "burnt_short"),
Prefab("kyno_burnttree2_normal", normal_deciduousfn, assets, prefabs),
MakePlacer("kyno_burnttree2_normal_placer", "tree_leaf", "tree_leaf_trunk_build", "burnt_normal"),
Prefab("kyno_burnttree2_tall", tall_deciduousfn, assets, prefabs),
MakePlacer("kyno_burnttree2_tall_placer", "tree_leaf", "tree_leaf_trunk_build", "burnt_tall"),

Prefab("kyno_burnttree3_short", short_twiggyfn, assets, prefabs),
MakePlacer("kyno_burnttree3_short_placer", "twiggy", "twiggy_build", "burnt_short"),
Prefab("kyno_burnttree3_normal", normal_twiggyfn, assets, prefabs),
MakePlacer("kyno_burnttree3_normal_placer", "twiggy", "twiggy_build", "burnt_normal"),
Prefab("kyno_burnttree3_tall", tall_twiggyfn, assets, prefabs),
MakePlacer("kyno_burnttree3_tall_placer", "twiggy", "twiggy_build", "burnt_tall"),

Prefab("kyno_burnttree4_short", short_moonfn, assets, prefabs),
MakePlacer("kyno_burnttree4_short_placer", "moon_tree", "moon_tree", "burnt_short"),
Prefab("kyno_burnttree4_normal", normal_moonfn, assets, prefabs),
MakePlacer("kyno_burnttree4_normal_placer", "moon_tree", "moon_tree", "burnt_normal"),
Prefab("kyno_burnttree4_tall", tall_moonfn, assets, prefabs),
MakePlacer("kyno_burnttree4_tall_placer", "moon_tree", "moon_tree", "burnt_tall"),

Prefab("kyno_burnttree5", tall_marshfn, assets, prefabs),
MakePlacer("kyno_burnttree5_placer", "marsh_tree", "tree_marsh", "burnt_idle")