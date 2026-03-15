require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_aspargos.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
    "asparagus",
}

local function onpicked(inst)
    -- inst.components.lootdropper:SpawnLootPrefab("asparagus")
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(1.2,1.2,1.2)

    inst.AnimState:SetBank("kyno_aspargos")
    inst.AnimState:SetBuild("kyno_aspargos")
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
    inst.components.pickable:SetUp("asparagus")
    inst.components.pickable.onpickedfn = onpicked

    inst.components.pickable.quickpick = true

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

local function asparagusplacetestfn(inst)
	inst.AnimState:SetScale(1.2,1.2,1.2)
end

return Prefab("sap_asparagus_planted", fn, assets),
MakePlacer("sap_asparagus_planted_placer", "kyno_aspargos", "kyno_aspargos", "planted", false, nil, nil, nil, nil, nil, asparagusplacetestfn)