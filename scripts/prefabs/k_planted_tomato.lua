require "prefabutil"

local assets_soil =
{
    Asset("ANIM", "anim/quagmire_soil.zip"),
}

local PRODUCT_VALUES =
{
    ["tomato"] =
    {
        raw = {},
        cooked = {},
        leaf = 2,
        bulb = 2,
    },
}

local VARIATIONS = 3

local function SetLeafVariation(inst, leafvariation)
    for i = 1, VARIATIONS do
        if i ~= leafvariation then
            inst.AnimState:Hide("crop_leaf"..tostring(i))
        end
    end
end

local function SetBulbVariation(inst, bulbvariation)
    for i = 1, VARIATIONS do
        if i ~= bulbvariation then
            inst.AnimState:Hide("crop_bulb"..tostring(i))
        end
    end
end

local function onpicked(inst)
	inst:Remove()
end

local function MakePlanted(product, bulbvariation)
    local assets =
    {
        Asset("ANIM", "anim/quagmire_crop_"..product..".zip"),
        Asset("ANIM", "anim/quagmire_soil.zip"),
    }

    local prefabs =
    {
        "kyno_soil",
        "kyno_planted_soil_front",
        "kyno_planted_soil_back",
        "kyno_"..product.."_leaf",
        "kyno_"..product,
        "spoiled_food",
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("quagmire_soil")
        inst.AnimState:SetBuild("quagmire_crop_"..product)
        inst.AnimState:PlayAnimation("crop_full", true)
        inst.AnimState:SetRayTestOnBB(true)

        SetLeafVariation(inst, nil)
        SetBulbVariation(inst, bulbvariation)
        inst.AnimState:Hide("soil_back")
        inst.AnimState:Hide("soil_front")
		inst.AnimState:Show("crop_bulb2")
		inst.AnimState:Show("crop_leaf2")
        inst.AnimState:Hide("mouseover")
        inst.AnimState:OverrideSymbol("mouseover", "quagmire_soil", "mouseover")

        inst:AddTag("plantedsoil")
        inst:AddTag("kyno_fertilizable")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end
		
		inst.frontfx = inst:SpawnChild("kyno_planted_soil_front")
		inst.frontfx2 = inst:SpawnChild("kyno_planted_soil_back")
		
		inst:AddComponent("inspectable")
		inst:AddComponent("lootdropper")
	
		inst:AddComponent("pickable")
		inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
		inst.components.pickable:SetUp("tomato")
		inst.components.pickable.onpickedfn = onpicked
		inst.components.pickable.quickpick = false

		inst:AddComponent("hauntable")
		inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        return inst
    end

    return Prefab("kyno_"..product.."_planted", fn, assets, prefabs)
end

local function OnLeafReplicated(inst)
    local parent = inst.entity:GetParent()
    if parent ~= nil and (parent.prefab == inst.prefab:sub(1, -6)"kyno_".."_planted") then
        parent.highlightchildren = { inst }
    end
end

local function MakeLeaf(product, leafvariation)
    local assets =
    {
        Asset("ANIM", "anim/quagmire_crop_"..product..".zip"),
        Asset("ANIM", "anim/quagmire_soil.zip"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("quagmire_soil")
        inst.AnimState:SetBuild("quagmire_crop_"..product)
        inst.AnimState:PlayAnimation("grow_small")
        inst.AnimState:SetFinalOffset(3)

        SetLeafVariation(inst, leafvariation)
        SetBulbVariation(inst, nil)
        inst.AnimState:Hide("soil_back")
        inst.AnimState:Hide("soil_front")

        inst:AddTag("FX")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            inst.OnEntityReplicated = OnLeafReplicated

            return inst
        end

        inst.persists = false

        return inst
    end

    return Prefab("kyno_"..product.."_leaf", fn, assets)
end

local function MakeSoilFn(front, back)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("quagmire_soil")
        inst.AnimState:SetBuild("quagmire_soil")
        inst.AnimState:PlayAnimation("crop_full")
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
        if front then
            inst.AnimState:SetFinalOffset(3)
        end

        SetLeafVariation(inst, nil)
        SetBulbVariation(inst, nil)
        inst.AnimState:Hide("mouseover")
        inst.AnimState:Hide(front and "soil_back" or "soil_front")

        inst:AddTag("DECOR")
        inst:AddTag("NOCLICK")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end
end

local ret =
{
   Prefab("kyno_planted_soil_front", MakeSoilFn(true, false), assets_soil),
    Prefab("kyno_planted_soil_back", MakeSoilFn(false, true), assets_soil),
}

local planted_prefabs = {}
for k, v in pairs(PRODUCT_VALUES) do
    table.insert(planted_prefabs, "kyno_"..k.."_planted")
    table.insert(ret, MakePlanted(k, v.bulb))
    table.insert(ret, MakeLeaf(k, v.leaf))
end
planted_prefabs = nil

return unpack(ret)