require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/python_test.zip"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("boneshard")
	inst.components.lootdropper:SpawnLootPrefab("boneshard")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("death_underground")
	inst.AnimState:PushAnimation("death_idle", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetScale(1.5, 1.5, 1.5)
	
	inst.AnimState:SetBank("giant_snake")
	inst.AnimState:SetBuild("python_test")
	inst.AnimState:PlayAnimation("death_idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("pugalisk_bones")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function corpseplacetestfn(inst)
	inst.AnimState:SetScale(1.5, 1.5, 1.5)
end

return Prefab("sap_pugaliskcorpse", fn, assets, prefabs),
MakePlacer("sap_pugaliskcorpse_placer", "giant_snake", "python_test", "death_idle", false, nil, nil, nil, nil, nil, corpseplacetestfn)
