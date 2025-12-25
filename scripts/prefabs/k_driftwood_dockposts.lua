require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_driftwood_dockposts.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
}

local prefabs =
{
    "collapse_small",
	"driftwood_log",
}


local function OnHammered(inst, worker)
    inst.components.lootdropper:DropLoot()

    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")

    inst:Remove()
end

local function SetPostArt(inst, id)
    if inst._post_id == nil or (id ~= nil and inst._post_id ~= id) then
        inst._post_id = id or tostring(math.random(1, 3))
        inst.AnimState:PlayAnimation("idle"..inst._post_id)
    end
end

local function OnSave(inst, data)
    data.post_id = inst._post_id
end

local function OnLoad(inst, data)
    SetPostArt(inst, (data ~= nil and data.post_id) or nil)
end

local function place(inst)
    inst.SoundEmitter:PlaySound("monkeyisland/dock/post_place")
    
    inst.AnimState:PlayAnimation("place"..inst._post_id)
    inst.AnimState:PushAnimation("idle"..inst._post_id)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    inst.AnimState:SetBank("kyno_driftwood_dockposts")
    inst.AnimState:SetBuild("kyno_driftwood_dockposts")
    inst.AnimState:PlayAnimation("idle1")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"driftwood_log"})

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetWorkLeft(3)

	
    if not POPULATING then
        SetPostArt(inst)
    end

    inst.place = place
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function OnDeploy(inst, pt, deployer)
    local prop = SpawnPrefab("kyno_driftwood_dockposts")
    if prop ~= nil then
        prop.Transform:SetPosition(pt.x,pt.y,pt.z)
        prop:place()
        inst:Remove()
    end
end

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", 0.2, 0.75)

    inst.AnimState:SetBank("kyno_driftwood_dockposts")
    inst.AnimState:SetBuild("kyno_driftwood_dockposts")
    inst.AnimState:PlayAnimation("item")
    
    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "DOCK_WOODPOSTS_ITEM"

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_driftwood_dockposts_item"

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = OnDeploy
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)
    inst.components.deployable:SetDeployMode(DEPLOYMODE.DEFAULT)

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab("kyno_driftwood_dockposts", fn, assets, prefabs),
Prefab("kyno_driftwood_dockposts_item", itemfn, assets, prefabs),	
MakePlacer("kyno_driftwood_dockposts_item_placer", "kyno_driftwood_dockposts", "kyno_driftwood_dockposts", "idle1")