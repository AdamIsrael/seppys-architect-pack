require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/lantern_fly.zip"),	
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("ice")
	inst.components.lootdropper:SpawnLootPrefab("butterfly")
	inst.AnimState:PlayAnimation("cocoon_idle_pst")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("cocoon_idle_loop")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(0.75,0.75,0.75)
	
	inst.AnimState:SetBank("lantern_fly")
	inst.AnimState:SetBuild("lantern_fly")
	inst.AnimState:PlayAnimation("cocoon_idle_loop")
	
	inst:AddTag("structure")
	inst:AddTag("buriedtreasure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function cocoonplacetestfn(inst)
	inst.AnimState:SetScale(0.75,0.75,0.75)
end

return Prefab("kyno_cocoon", fn, assets, prefabs),
MakePlacer("kyno_cocoon_placer", "lantern_fly", "lantern_fly", "cocoon_idle_loop", false, nil, nil, nil, nil, nil, cocoonplacetestfn)