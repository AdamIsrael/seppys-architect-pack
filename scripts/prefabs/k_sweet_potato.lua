require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/sweet_potato.zip"),
}

local prefabs =
{
    "potato",
}

local function onpicked(inst)
    -- inst.components.lootdropper:SpawnLootPrefab("potato")
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("sweet_potato")
    inst.AnimState:SetBuild("sweet_potato")
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
    inst.components.pickable:SetUp("potato")
    inst.components.pickable.onpickedfn = onpicked

    inst.components.pickable.quickpick = true

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

return Prefab("sap_sweet_potato_planted", fn, assets),
MakePlacer("sap_sweet_potato_planted_placer", "sweet_potato", "sweet_potato", "planted")