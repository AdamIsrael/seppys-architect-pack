local assets =
{
    Asset("ANIM", "anim/earring.zip"),
}

local prefabs = {}

local function Sparkle(inst)
if inst:HasTag("earring") then
	inst:DoTaskInTime(5+math.random()*5, function() Sparkle(inst) end)
		inst.AnimState:PlayAnimation("sparkle")
		inst.AnimState:PushAnimation("idle")
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(1.5, 1.5, 1.5)

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst)

	inst.AnimState:SetBank("earring")
	inst.AnimState:SetBuild("earring")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("molebait")
	inst:AddTag("cattoy")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "sap_earring"
	inst.components.inventoryitem:ChangeImageName("sap_earring")

	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 3
	inst.components.tradable.rocktribute = math.ceil(inst.components.tradable.goldvalue / 3)

	MakeHauntableLaunchAndSmash(inst)
	Sparkle(inst)
	
	return inst
end

return Prefab("sap_earring", fn, assets, prefabs)
