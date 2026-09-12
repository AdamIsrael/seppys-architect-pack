require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/radish.zip"),
}

local prefabs =
{
    "pepper",
}

local function onpicked(inst)
    -- inst.components.lootdropper:SpawnLootPrefab("pepper")
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	-- inst.AnimState:SetScale(1.2,1.2,1.2)

    inst.AnimState:SetBank("radish")
    inst.AnimState:SetBuild("radish")
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
    inst.components.pickable:SetUp("pepper")
    inst.components.pickable.onpickedfn = onpicked

    inst.components.pickable.quickpick = true

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

return Prefab("sap_radish_planted", fn, assets),
MakePlacer("sap_radish_planted_placer", "radish", "radish", "planted")