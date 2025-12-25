require "tuning"

local assets = {
    Asset("ANIM", "anim/lotus.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
}

local prefabs = {
    "kyno_lotus_flower_cooked",
    "kyno_lotus_flower",
    "spoiled_food",
}

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
		
	inst.AnimState:SetBank("lotus")
	inst.AnimState:SetBuild("lotus")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("cookable")
	inst:AddTag("cattoy")
	inst:AddTag("show_spoilage")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	inst.components.edible.sanityvalue = TUNING.SANITY_TINY
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = resolvefilepath("images/inventoryimages/tap_inventoryimages.xml")

	inst:AddComponent("bait")
	inst:AddComponent("tradable")

	inst:AddComponent("cookable")
    inst.components.cookable.product = "kyno_lotus_flower_cooked"
		
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunch(inst)

	return inst
end

local function cookedfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)
		
	inst.AnimState:SetBank("lotus")
	inst.AnimState:SetBuild("lotus")
	inst.AnimState:PlayAnimation("cooked")

	inst:AddTag("cattoy")
	inst:AddTag("show_spoilage")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("inspectable")

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_TINY
	inst.components.edible.hungervalue = TUNING.CALORIES_SMALL
	inst.components.edible.sanityvalue = TUNING.SANITY_MED
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
		
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = resolvefilepath("images/inventoryimages/tap_inventoryimages.xml")

	inst:AddComponent("bait")
	inst:AddComponent("tradable")
		
	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableLaunch(inst)

	return inst
end

return Prefab("kyno_lotus_flower", fn, assets, prefabs),
Prefab("kyno_lotus_flower_cooked", cookedfn, assets, prefabs)	