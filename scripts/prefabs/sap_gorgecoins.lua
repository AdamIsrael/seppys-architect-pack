local assets =
{
	Asset("ANIM", "anim/quagmire_coins.zip"),
}

local prefabs =
{
    "sap_gorgecoin_fx",
}

local fx_front = 1

local fx_defs = {
	light = { { 0, 0, 0 } },
}
	
local function MakeCoin(id, hasfx)
	local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("quagmire_coins")
	inst.AnimState:SetBuild("quagmire_coins")
	inst.AnimState:PlayAnimation("idle")
	if id > 1 then
		inst.AnimState:OverrideSymbol("coin01", "quagmire_coins", "coin0"..tostring(id))
		inst.AnimState:OverrideSymbol("coin_shad1", "quagmire_coins", "coin_shad"..tostring(id))
	end
	
	inst:AddTag("gorge_coin")
	inst:AddTag("cattoy")
	inst:AddTag("molebait")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	if id == 4 then
	local decor_items = fx_defs
		inst.decor = {}
		for item_name, data in pairs(decor_items) do
			for l, offset in pairs(data) do
				local item_inst = SpawnPrefab("sap_gorgecoin_fx")
				item_inst.AnimState:PushAnimation("opal_loop", true)
				item_inst.entity:SetParent(inst.entity)
				item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
				table.insert(inst.decor, item_inst)
			end
		end
	end
	
	inst:AddComponent("bait")
	
	inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 1
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "quagmire_coin1"
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 3
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
		return inst
    end
	
	return Prefab("sap_gorgecoin"..id, fn, assets, hasfx and prefabs or nil)
end

local function fxfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("quagmire_coins")
    inst.AnimState:SetBuild("quagmire_coins")
    inst.AnimState:PlayAnimation("opal_loop", true)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

return MakeCoin(1),
MakeCoin(2),
MakeCoin(3),
MakeCoin(4, true),
Prefab("sap_gorgecoin_fx", fxfn, assets, prefabs)