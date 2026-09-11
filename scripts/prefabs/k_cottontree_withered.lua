require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/quagmire_sapbucket.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_short.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_normal.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_tall.zip"),
    Asset("ANIM", "anim/quagmire_tree_cotton_build.zip"),
    Asset("ANIM", "anim/quagmire_tree_cotton_trunk_build.zip"),
}

local prefabs =
{
	"log",
	"ash",
}

local function setupstump(inst)
    SpawnPrefab("sap_cottontree2_stump").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function stump_dug(inst)
    inst.components.lootdropper:SpawnLootPrefab("log")
    inst:Remove()
end

local function tree_chopped(inst, chopper)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end

    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
	
    local pt = Vector3(inst.Transform:GetWorldPosition())
	local hispos = Vector3(chopper.Transform:GetWorldPosition())
	local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

	if he_right then
		inst.AnimState:PlayAnimation("fallleft")
		inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
	else
		inst.AnimState:PlayAnimation("fallright")
		inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
	end
	
    inst:ListenForEvent("animover", setupstump)
end

local function tree_chop(inst, chopper)
    inst.AnimState:PlayAnimation("chop")
	inst.AnimState:PushAnimation("sway2_loop", true)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end
end

local s = .85

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quagmire_sugarwoodtree.png")

    MakeObstaclePhysics(inst, .25)

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:OverrideSymbol("leaf_overlay", "quagmire_tree_cotton_build", "leaf_withered_overlay")
	inst.AnimState:OverrideSymbol("swap_leaves", "quagmire_tree_cotton_build", "swap_leaves_withered")
	inst.AnimState:OverrideSymbol("trunk", "quagmire_tree_cotton_trunk_build", "trunk_holes")
    inst.AnimState:PlayAnimation("sway1_loop", true)
	
	inst.AnimState:Hide("sap")
	inst.AnimState:Hide("swap_tapper")
	
	inst:AddTag("tree")
    inst:AddTag("shelter")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(15)
    inst.components.workable:SetOnFinishCallback(tree_chopped)
    inst.components.workable:SetOnWorkCallback(tree_chop)

    return inst
end

local function stump_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(s, s, s)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("quagmire_sugarwoodtree.png")

    inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:OverrideSymbol("trunk", "quagmire_tree_cotton_trunk_build", "trunk_holes")
	inst.AnimState:PlayAnimation("stump")
	
	inst:AddTag("plant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnWorkCallback(stump_dug)

    return inst
end

local function cottontree2placetestfn(inst)
	inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
	inst.AnimState:OverrideSymbol("leaf_overlay", "quagmire_tree_cotton_build", "leaf_withered_overlay")
	inst.AnimState:OverrideSymbol("swap_leaves", "quagmire_tree_cotton_build", "swap_leaves_withered")
	inst.AnimState:OverrideSymbol("trunk", "quagmire_tree_cotton_trunk_build", "trunk_holes")
	
	inst.AnimState:Hide("swap_tapper")
    inst.AnimState:Hide("sap")
	
	inst.AnimState:SetScale(.85, .85, .85)
end

return Prefab("sap_cottontree2", fn, assets, prefabs),
Prefab("sap_cottontree2_stump", stump_fn, assets, prefabs),
MakePlacer("sap_cottontree2_placer", "quagmire_tree_cotton_tall", "quagmire_tree_cotton_build", "sway1_loop", false, nil, nil, nil, nil, nil, cottontree2placetestfn)