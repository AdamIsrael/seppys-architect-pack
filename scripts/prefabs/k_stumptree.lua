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
	
	Asset("ANIM", "anim/mushroom_tree_small.zip"),
	
	Asset("ANIM", "anim/mushroom_tree_med.zip"),
	
	Asset("ANIM", "anim/mushroom_tree_tall.zip"),
	
	Asset("ANIM", "anim/mutatedmushroom_tree_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("SOUND", "sound/forest.fsb"),
	Asset("SOUND", "sound/deciduous.fsb"),
}

local prefabs =
{
	"log",
}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("log")
	inst:Remove()
end

local function shortfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("evergreen_stump.png")

	inst.AnimState:SetBank("evergreen_short")
	inst.AnimState:SetBuild("evergreen_new")
	inst.AnimState:PlayAnimation("stump_short", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("evergreen")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function normalfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("evergreen_stump.png")

	inst.AnimState:SetBank("evergreen_short")
	inst.AnimState:SetBuild("evergreen_new")
	inst.AnimState:PlayAnimation("stump_normal", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("evergreen")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function tallfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("evergreen_stump.png")

	inst.AnimState:SetBank("evergreen_short")
	inst.AnimState:SetBuild("evergreen_new")
	inst.AnimState:PlayAnimation("stump_tall", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("evergreen")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function short_deciduousfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("tree_leaf_stump.png")

	inst.AnimState:SetBank("tree_leaf")
	inst.AnimState:SetBuild("tree_leaf_trunk_build")
	inst.AnimState:PlayAnimation("stump_short", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("deciduoustree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function normal_deciduousfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("tree_leaf_stump.png")

	inst.AnimState:SetBank("tree_leaf")
	inst.AnimState:SetBuild("tree_leaf_trunk_build")
	inst.AnimState:PlayAnimation("stump_normal", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("deciduoustree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function tall_deciduousfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("tree_leaf_stump.png")

	inst.AnimState:SetBank("tree_leaf")
	inst.AnimState:SetBuild("tree_leaf_trunk_build")
	inst.AnimState:PlayAnimation("stump_tall", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("deciduoustree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function short_twiggyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("twiggy_stump.png")

	inst.AnimState:SetBank("twiggy")
	inst.AnimState:SetBuild("twiggy_build")
	inst.AnimState:PlayAnimation("stump_short", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("twiggytree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function normal_twiggyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("twiggy_stump.png")

	inst.AnimState:SetBank("twiggy")
	inst.AnimState:SetBuild("twiggy_build")
	inst.AnimState:PlayAnimation("stump_normal", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("twiggytree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function tall_twiggyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("twiggy_stump.png")

	inst.AnimState:SetBank("twiggy")
	inst.AnimState:SetBuild("twiggy_build")
	inst.AnimState:PlayAnimation("stump_tall", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("twiggytree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function old_twiggyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("twiggy_stump.png")

	inst.AnimState:SetBank("twiggy")
	inst.AnimState:SetBuild("twiggy_build")
	inst.AnimState:PlayAnimation("stump_old", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("twiggytree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function short_moonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("moon_tree_stump.png")

	inst.AnimState:SetBank("moon_tree")
	inst.AnimState:SetBuild("moon_tree")
	inst.AnimState:PlayAnimation("stump_short", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("moon_tree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function normal_moonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("moon_tree_stump.png")

	inst.AnimState:SetBank("moon_tree")
	inst.AnimState:SetBuild("moon_tree")
	inst.AnimState:PlayAnimation("stump_normal", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("moon_tree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function tall_moonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("moon_tree_stump.png")

	inst.AnimState:SetBank("moon_tree")
	inst.AnimState:SetBuild("moon_tree")
	inst.AnimState:PlayAnimation("stump_tall", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("moon_tree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function tall_marshfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("marshtree_stump.png")

	inst.AnimState:SetBank("marsh_tree")
	inst.AnimState:SetBuild("tree_marsh")
	inst.AnimState:PlayAnimation("stump", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("marsh_tree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function red_mush()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("mushroom_tree_stump.png")

	inst.AnimState:SetBank("mushroom_tree_med")
	inst.AnimState:SetBuild("mushroom_tree_med")
	inst.AnimState:PlayAnimation("idle_stump", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("mushtree_medium")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function green_mush()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("mushroom_tree_stump.png")

	inst.AnimState:SetBank("mushroom_tree_small")
	inst.AnimState:SetBuild("mushroom_tree_small")
	inst.AnimState:PlayAnimation("idle_stump", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("mushtree_small")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function blue_mush()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("mushroom_tree_stump.png")

	inst.AnimState:SetBank("mushroom_tree")
	inst.AnimState:SetBuild("mushroom_tree_tall")
	inst.AnimState:PlayAnimation("idle_stump", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("mushtree_tall")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

local function moon_mush()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("mushroom_tree_stump.png")

	inst.AnimState:SetBank("mushroom_tree")
	inst.AnimState:SetBuild("mutatedmushroom_tree_build")
	inst.AnimState:PlayAnimation("idle_stump", true)
	
	inst:AddTag("stump_tree")
	inst:AddTag("structure")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("mushtree_moon")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dig_up)
	
	return inst
end

return Prefab("sap_stump_short", shortfn, assets, prefabs),
MakePlacer("sap_stump_short_placer", "evergreen_short", "evergreen_new", "stump_short"),
Prefab("sap_stump_normal", normalfn, assets, prefabs),
MakePlacer("sap_stump_normal_placer", "evergreen_short", "evergreen_new", "stump_normal"),
Prefab("sap_stump_tall", tallfn, assets, prefabs),
MakePlacer("sap_stump_tall_placer", "evergreen_short", "evergreen_new", "stump_tall"),

Prefab("sap_stump2_short", short_deciduousfn, assets, prefabs),
MakePlacer("sap_stump2_short_placer", "tree_leaf", "tree_leaf_trunk_build", "stump_short"),
Prefab("sap_stump2_normal", normal_deciduousfn, assets, prefabs),
MakePlacer("sap_stump2_normal_placer", "tree_leaf", "tree_leaf_trunk_build", "stump_normal"),
Prefab("sap_stump2_tall", tall_deciduousfn, assets, prefabs),
MakePlacer("sap_stump2_tall_placer", "tree_leaf", "tree_leaf_trunk_build", "stump_tall"),

Prefab("sap_stump3_short", short_twiggyfn, assets, prefabs),
MakePlacer("sap_stump3_short_placer", "twiggy", "twiggy_build", "stump_short"),
Prefab("sap_stump3_normal", normal_twiggyfn, assets, prefabs),
MakePlacer("sap_stump3_normal_placer", "twiggy", "twiggy_build", "stump_normal"),
Prefab("sap_stump3_tall", tall_twiggyfn, assets, prefabs),
MakePlacer("sap_stump3_tall_placer", "twiggy", "twiggy_build", "stump_tall"),
Prefab("sap_stump3_old", old_twiggyfn, assets, prefabs),
MakePlacer("sap_stump3_old_placer", "twiggy", "twiggy_build", "stump_old"),

Prefab("sap_stump4_short", short_moonfn, assets, prefabs),
MakePlacer("sap_stump4_short_placer", "moon_tree", "moon_tree", "stump_short"),
Prefab("sap_stump4_normal", normal_moonfn, assets, prefabs),
MakePlacer("sap_stump4_normal_placer", "moon_tree", "moon_tree", "stump_normal"),
Prefab("sap_stump4_tall", tall_moonfn, assets, prefabs),
MakePlacer("sap_stump4_tall_placer", "moon_tree", "moon_tree", "stump_tall"),

Prefab("sap_stump5", tall_marshfn, assets, prefabs),
MakePlacer("sap_stump5_placer", "marsh_tree", "tree_marsh", "stump"),

Prefab("sap_stump6", red_mush, assets, prefabs),
MakePlacer("sap_stump6_placer", "mushroom_tree_med", "mushroom_tree_med", "idle_stump"),

Prefab("sap_stump7", green_mush, assets, prefabs),
MakePlacer("sap_stump7_placer", "mushroom_tree_small", "mushroom_tree_small", "idle_stump"),

Prefab("sap_stump8", blue_mush, assets, prefabs),
MakePlacer("sap_stump8_placer", "mushroom_tree", "mushroom_tree_tall", "idle_stump"),

Prefab("sap_stump9", moon_mush, assets, prefabs),
MakePlacer("sap_stump9_placer", "mushroom_tree", "mutatedmushroom_tree_build", "idle_stump")