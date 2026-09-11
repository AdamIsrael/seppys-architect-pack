local assets =
{
	Asset("ANIM", "anim/pig_coin.zip"),
	Asset("ANIM", "anim/pig_coin_silver.zip"),
	Asset("ANIM", "anim/pig_coin_jade.zip"),
}

local prefabs = {}
	
local function shine(inst)
    inst.task = nil
	inst.AnimState:PlayAnimation("sparkle")
	inst.AnimState:PushAnimation("idle")
    if inst.entity:IsAwake() then
        inst:DoTaskInTime(4+math.random()*5, function() shine(inst) end)
    end
end	

local function onwake(inst)
    inst.task = inst:DoTaskInTime(4+math.random()*5, function() shine(inst) end)
end

local function toground(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/coins/1")
end

local function topocket(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/coins/1")
end
	
local function oinc1fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("coin")
    inst.AnimState:SetBuild("pig_coin")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")    

    inst:AddTag("cattoy")
	inst:AddTag("coin")
	inst:AddTag("oinc")
	inst:AddTag("molebait")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 1
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	-- inst.components.inventoryitem:SetOnDroppedFn(toground)
    inst.components.inventoryitem:SetOnPutInInventoryFn(topocket)
	-- inst.components.inventoryitem:SetOnPickupFn(topocket)
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst.OnEntityWake = onwake

	return inst
end 

local function oinc10fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("coin")
    inst.AnimState:SetBuild("pig_coin_silver")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")    

    inst:AddTag("cattoy")
	inst:AddTag("coin")
	inst:AddTag("oinc")
	inst:AddTag("molebait")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 1
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	-- inst.components.inventoryitem:SetOnDroppedFn(toground)
    inst.components.inventoryitem:SetOnPutInInventoryFn(topocket)
	-- inst.components.inventoryitem:SetOnPickupFn(topocket)
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst.OnEntityWake = onwake

	return inst
end 

local function oinc100fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("coin")
    inst.AnimState:SetBuild("pig_coin_jade")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")    

    inst:AddTag("cattoy")
	inst:AddTag("coin")
	inst:AddTag("oinc")
	inst:AddTag("molebait")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 1
	
	inst:AddComponent("inspectable")
	inst:AddComponent("bait")
	
	inst:AddComponent("tradable")
	inst.components.tradable.goldvalue = 1

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	-- inst.components.inventoryitem:SetOnDroppedFn(toground)
    inst.components.inventoryitem:SetOnPutInInventoryFn(topocket)
	-- inst.components.inventoryitem:SetOnPickupFn(topocket)
	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst.OnEntityWake = onwake

	return inst
end 

return Prefab("sap_oinc1", oinc1fn, assets, prefabs),
Prefab("sap_oinc10", oinc10fn, assets, prefabs),
Prefab("sap_oinc100", oinc100fn, assets, prefabs)
