require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/x_marks_spot_bandit.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("feather_crow")
	inst.components.lootdropper:SpawnLootPrefab("feather_crow")
	inst.components.lootdropper:SpawnLootPrefab("goldnugget")
	inst.components.lootdropper:SpawnLootPrefab("goldnugget")
	inst:Remove()
end

local function blink(inst)
if inst:HasTag("bandit_blink") then
	inst:DoTaskInTime(4+math.random()*5, function() blink(inst) end)
		inst.AnimState:PlayAnimation("blink")
		inst.AnimState:PushAnimation("idle")
	end
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("idle")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_xpsot.tex")
	
	inst.AnimState:SetBank("x_marks_spot_bandit")
	inst.AnimState:SetBuild("x_marks_spot_bandit")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("structure")
	inst:AddTag("buriedtreasure")
	inst:AddTag("bandittreasure")
	inst:AddTag("bandit_blink")
	
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
	
	blink(inst)

	return inst
end

return Prefab("sap_bandittreasure", fn, assets, prefabs),
MakePlacer("sap_bandittreasure_placer", "x_marks_spot_bandit", "x_marks_spot_bandit", "idle")
