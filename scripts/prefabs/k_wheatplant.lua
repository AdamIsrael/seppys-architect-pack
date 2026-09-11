require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/grass.zip"),
    Asset("ANIM", "anim/grass1.zip"),
	Asset("ANIM", "anim/kyno_wheat2.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("dug_grass")
	inst.components.lootdropper:SpawnLootPrefab("seeds")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("idle", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_wheatplant.tex")
	
	inst.AnimState:SetBank("kyno_wheat2")
	inst.AnimState:SetBuild("kyno_wheat2")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.AnimState:SetTime(math.random() * 2)
	local color = 0.75 + math.random() * 0.25
	inst.AnimState:SetMultColour(color, color, color, 1)
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "GRASS"
	
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

return Prefab("sap_wheatplant", fn, assets, prefabs),
MakePlacer("sap_wheatplant_placer", "kyno_wheat2", "kyno_wheat2", "idle")
