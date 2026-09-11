require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_truffles.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("blue_cap")
	inst.components.lootdropper:SpawnLootPrefab("blue_cap")
	inst.components.lootdropper:SpawnLootPrefab("green_cap")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(2, 2, 2)
	
	inst.AnimState:SetBank("kyno_truffles")
	inst.AnimState:SetBuild("kyno_truffles")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("truffles")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "RED_CAP"
	
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

local function truffleplacetestfn(inst)
	inst.AnimState:SetScale(2, 2, 2)
end

return Prefab("sap_truffles", fn, assets, prefabs),
MakePlacer("sap_truffles_placer", "kyno_truffles", "kyno_truffles", "idle", false, nil, nil, nil, nil, nil, truffleplacetestfn)
