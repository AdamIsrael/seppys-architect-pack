require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_mushtree_sparse_small.zip"),
	Asset("ANIM", "anim/kyno_mushtree_sparse_tall.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs = 
{
	"log",
	"charcoal",
	"ash",
	"green_cap",
	"blue_cap",
}

local function TreeChopped(inst, chopper)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_mushroom")
    end

    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    inst.components.lootdropper:DropLoot(inst:GetPosition())
    
    inst.AnimState:PlayAnimation("wilt")
    inst:ListenForEvent("animover", inst.Remove)
end

local function TreeChop(inst, chopper)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_mushroom")
    end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle_loop", true)
	inst.SoundEmitter:PlaySound("dontstarve/cave/mushtree_tall_grow_1")
end

local function smallfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(.5)
	inst.Light:SetIntensity(.8)
	inst.Light:SetRadius(1)
	inst.Light:SetColour(146/255, 225/255, 146/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("mushroom_tree_small.png")

    MakeObstaclePhysics(inst, .25)
	
	inst.AnimState:SetScale(1.3, 1.3, 1.3)

    inst.AnimState:SetBank("kyno_mushtree_sparse_small")
    inst.AnimState:SetBuild("kyno_mushtree_sparse_small")
    inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst:AddTag("shelter")
	inst:AddTag("mushtree")
	inst:AddTag("plant")
	inst:AddTag("tree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local color = .5 + math.random() * .5
	inst.AnimState:SetMultColour(color, color, color, 1)
	inst.AnimState:SetTime(math.random() * 2)
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MUSHTREE_SMALL"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(10)
    inst.components.workable:SetOnFinishCallback(TreeChopped)
    inst.components.workable:SetOnWorkCallback(TreeChop)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)

    return inst
end

local function tallfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(.5)
	inst.Light:SetIntensity(.8)
	inst.Light:SetRadius(1.5)
	inst.Light:SetColour(111/255, 111/255, 227/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("mushroom_tree.png")

    MakeObstaclePhysics(inst, .25)
	
	inst.AnimState:SetScale(1.3, 1.3, 1.3)

    inst.AnimState:SetBank("kyno_mushtree_sparse_tall")
    inst.AnimState:SetBuild("kyno_mushtree_sparse_tall")
    inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst:AddTag("shelter")
	inst:AddTag("mushtree")
	inst:AddTag("plant")
	inst:AddTag("tree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local color = .5 + math.random() * .5
	inst.AnimState:SetMultColour(color, color, color, 1)
	inst.AnimState:SetTime(math.random() * 2)
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MUSHTREE_TALL"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(10)
    inst.components.workable:SetOnFinishCallback(TreeChopped)
    inst.components.workable:SetOnWorkCallback(TreeChop)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)

    return inst
end

return Prefab("sap_mushtree_sparse_small", smallfn, assets, prefabs),
Prefab("sap_mushtree_sparse_tall", tallfn, assets, prefabs),
MakePlacer("sap_mushtree_sparse_small_placer", "kyno_mushtree_sparse_small", "kyno_mushtree_sparse_small", "idle_loop", false, nil, nil, 1.3),
MakePlacer("sap_mushtree_sparse_tall_placer", "kyno_mushtree_sparse_tall", "kyno_mushtree_sparse_tall", "idle_loop", false, nil, nil, 1.3)