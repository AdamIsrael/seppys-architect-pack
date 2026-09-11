require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/watercress.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "succulent_picked",
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
	
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_watercress.tex")

    inst.AnimState:SetBank("watercress")
    inst.AnimState:SetBuild("watercress")
    inst.AnimState:PlayAnimation("idle_plant", true)
    inst.AnimState:SetRayTestOnBB(true)
	
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("succulent_picked")
    inst.components.pickable.onpickedfn = onpicked

    inst.components.pickable.quickpick = false

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

local function watercressplacer(inst)
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
end

return Prefab("sap_watercress_planted", fn, assets),
MakePlacer("sap_watercress_planted_placer", "watercress", "watercress", "idle_plant", false, nil, nil, nil, nil, nil, watercressplacer)