require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/kyno_adai_hallowedpumpkin.zip"),

	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),

    Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end

    local fx = SpawnAt("collapse_small", inst)
    fx:SetMaterial("straw")

    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function onbuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/plant_seeds")
end

local function onignite(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
    data.faceId = inst.faceId
end

local function onload(inst, data)
    if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
    inst.faceId = data and data.faceId or "face01"
end

local function fn_common(faceId, skinned)
    local inst = CreateEntity()

    if faceId == nil then
        faceId = "face01"
    end

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

    inst.AnimState:SetScale(1.25, 1.25, 1.25)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_adai_hallowedpumpkin.tex")

    inst.AnimState:SetBank("kyno_adai_hallowedpumpkin")
    inst.AnimState:SetBuild("kyno_adai_hallowedpumpkin")
    inst.AnimState:PlayAnimation(faceId, true)

    inst:AddTag("structure")
    inst:AddTag("hallowed")

    inst.entity:SetPristine()

    inst.faceId = faceId

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    local lootdropper = inst.components.lootdropper
    lootdropper.numrandomloot = 1
    lootdropper:AddRandomLoot("pumpkin",       0.5)
    lootdropper:AddRandomLoot("pumpkin_seeds", 0.5)
    if skinned then
        local recipeloot = lootdropper:GetRecipeLoot(AllRecipes["sap_adai_hallowedpumpkin"])
        for k,v in ipairs(recipeloot) do
            lootdropper:AddChanceLoot(v, 1)
        end
    end

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetWorkLeft(1)

    inst:ListenForEvent("onignite", onignite)
    inst:ListenForEvent("onbuilt", onbuilt)

    MakeMediumBurnable(inst)
    MakeMediumPropagator(inst)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

local function pumpkinplacer(inst)
    inst.AnimState:SetScale(1.25, 1.25, 1.25)

    inst.ApplySkin = function(inst, skin)
        local skin_prefix = "sap_adai_hallowedpumpkin"
        local skin_number = tonumber(string.sub(skin, #skin_prefix + 1))
        skin_number       = (skin_number < 10 and "0" or "") .. skin_number
        inst.AnimState:PlayAnimation("face"..skin_number, true)
    end
end

local ret = {}

-- Normal prefab
table.insert(ret, Prefab(
    "sap_adai_hallowedpumpkin",
    function() return fn_common("face01", false) end,
    assets,
    prefabs))

-- Placer
table.insert(ret, MakePlacer(
    "sap_adai_hallowedpumpkin_placer",
    "sap_adai_hallowedpumpkin",
    "sap_adai_hallowedpumpkin",
    "face01",
    false,
    nil,
    nil,
    nil,
    nil,
    nil,
    pumpkinplacer))

-- Skinned prefabs
--[[
for id = 2, 17 do
    local faceId = (id < 10) and ("face0" .. id) or ("face" .. id)

    table.insert(ret, CreateModPrefabSkin(
        "sap_adai_hallowedpumpkin" .. id,
        {
            assets =
            {
                Asset("ANIM", "anim/kyno_adai_hallowedpumpkin.zip"),
            },
            base_prefab         = "sap_adai_hallowedpumpkin",
            fn                  = function() return fn_common(faceId, true) end,
            rarity              = "Event",
            reskinable          = true,
            build_name_override = "sap_adai_hallowedpumpkin",
            type                = "item",
            skin_tags           = { },
            release_group       = 0,
        }))
end
]]--
return unpack(ret)
