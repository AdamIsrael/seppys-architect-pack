require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_snow_dune.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"sap_snowhill_med",
	"sap_snowhill_low",
	"turf_snowfall",
}

local function dig_up_full(inst, chopper)
	inst:Remove()
	SpawnPrefab("sap_snowhill_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_med(inst, chopper)
	inst:Remove()
	SpawnPrefab("sap_snowhill_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_low(inst, chopper)
	SpawnPrefab("turf_snowfall").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function fullfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("kyno_snow_dune")
	inst.AnimState:SetBuild("kyno_snow_dune")
	inst.AnimState:PlayAnimation("full")
	
	inst:AddTag("structure")
	inst:AddTag("snowpile")
	
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
	inst.components.workable:SetOnWorkCallback(dig_up_full)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

local function medfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("kyno_snow_dune")
	inst.AnimState:SetBuild("kyno_snow_dune")
	inst.AnimState:PlayAnimation("med")
	
	inst:AddTag("structure")
	inst:AddTag("snowpile")
	
	inst:SetPrefabNameOverride("sap_snowhill")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_med)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

local function lowfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("kyno_snow_dune")
	inst.AnimState:SetBuild("kyno_snow_dune")
	inst.AnimState:PlayAnimation("low")
	
	inst:AddTag("structure")
	inst:AddTag("snowpile")
	
	inst:SetPrefabNameOverride("sap_snowhill")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_low)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

return Prefab("sap_snowhill", fullfn, assets, prefabs),
Prefab("sap_snowhill_med", medfn, assets, prefabs),
Prefab("sap_snowhill_low", lowfn, assets, prefabs),
MakePlacer("sap_snowhill_placer", "kyno_snow_dune", "kyno_snow_dune", "full")