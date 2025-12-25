local assets =
{ 
    Asset("ANIM", "anim/lobster_claw.zip"),

    Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
}

local function fn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("lobster_claw")
	inst.AnimState:SetBuild("lobster_claw")
	inst.AnimState:PlayAnimation("idle")
				
	if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

	inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "kyno_lobster_claw"

    return inst
end

return Prefab("kyno_lobster_claw", fn, assets, prefabs)