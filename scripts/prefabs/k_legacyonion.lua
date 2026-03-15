require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/legacyonion.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "onion",
}

local function onpicked(inst)
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.8, .8, .8)

    inst.AnimState:SetBank("legacyonion")
    inst.AnimState:SetBuild("legacyonion")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("onion")
    inst.components.pickable.onpickedfn = onpicked

    inst.components.pickable.quickpick = true

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

local function onionplacer(inst)
	inst.AnimState:SetScale(.8, .8, .8)
end

return Prefab("sap_legacyonion_planted", fn, assets),
MakePlacer("sap_legacyonion_planted_placer", "legacyonion", "legacyonion", "planted", false, nil, nil, nil, nil, nil, onionplacer)