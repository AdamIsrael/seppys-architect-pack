local assets=
{
	Asset("ANIM", "anim/doydoy_nest.zip"),
}

local prefabs = 
{
	"sap_doydoyegg_cooked",
	"spoiled_food",
}

local function eggfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("doydoy_nest")
	inst.AnimState:SetBuild("doydoy_nest")
	inst.AnimState:PlayAnimation("idle_egg")

	inst:AddTag("cattoy")
	inst:AddTag("meat")
	inst:AddTag("cookable")
	inst:AddTag("DD_FOOD")
	inst:AddTag("sap_doydoyegg")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 3
	inst.components.edible.hungervalue = 25
	inst.components.edible.sanityvalue = 0
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "sap_doydoyegg"

	inst:AddComponent("cookable")
	inst.components.cookable.product = "sap_doydoyegg_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function cookedfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("doydoy_nest")
	inst.AnimState:SetBuild("doydoy_nest")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("cattoy")
	inst:AddTag("meat")
	inst:AddTag("DD_FOOD")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("bait")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

   	inst:AddComponent("edible")
	inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = 37.5
	inst.components.edible.sanityvalue = 0
	inst.components.edible.foodtype = FOODTYPE.MEAT
	inst.components.edible.ismeat = true

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "sap_doydoyegg_cooked"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab("sap_doydoyegg", eggfn, assets, prefabs),
Prefab("sap_doydoyegg_cooked", cookedfn, assets, prefabs) 