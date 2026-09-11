require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/lavaarena_portal.zip"),
	Asset("ANIM", "anim/lavaarena_keyhole.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"collapse_small"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function CreateDropShadow(parent)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --[[Non-networked entity]]

    inst.AnimState:SetBuild("lavaarena_portal")
    inst.AnimState:SetBank("lavaarena_portal")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)
    inst.AnimState:OverrideSymbol("lavaarena_portal01", "lavaarena_portal", "shadow")

    inst.Transform:SetEightFaced()

    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")

    inst.presists = false
    inst.entity:SetParent(parent.entity)

    return inst
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_lavagateway.tex")
	
    inst.AnimState:SetBank("lavaarena_portal")
    inst.AnimState:SetBuild("lavaarena_portal")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
    inst.AnimState:SetFinalOffset(2)
	
	inst.Transform:SetEightFaced()
    
	inst:AddTag("structure")
	inst:AddTag("notarget")
	inst:AddTag("the_forge_gateway")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
		
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "LAVAARENA_PORTAL"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("savedrotation")
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
	CreateDropShadow(inst)
	
    return inst
end

local function keyholefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("lavaarena_keyhole")
    inst.AnimState:SetBank("lavaarena_keyhole")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:Hide("key")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)

    inst.Transform:SetEightFaced()
    inst.Transform:SetScale(1.1, 1.1, 1.1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "LAVAARENA_KEYHOLE"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("savedrotation")
	
	MakeHauntableWork(inst)

    return inst
end

local function anchorplacetestfn(inst)
	inst.AnimState:Hide("key")
end

return Prefab("kyno_lavagateway", fn, assets, prefabs),
Prefab("kyno_anchorgateway", keyholefn, assets, prefabs),
MakePlacer("kyno_lavagateway_placer", "lavaarena_portal", "lavaarena_portal", "idle", true, nil, nil, nil, 90, nil),
MakePlacer("kyno_anchorgateway_placer", "lavaarena_keyhole", "lavaarena_keyhole", "idle", true, nil, nil, nil, 90, nil, anchorplacetestfn)