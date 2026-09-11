require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/bush_vine.zip"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("twigs")
	inst.components.lootdropper:SpawnLootPrefab("twigs")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle", true)
	inst.Physics:SetCollides(true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_vinebush.tex")
	
	inst.AnimState:SetBank("bush_vine")
	inst.AnimState:SetBuild("bush_vine")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("thorny")
	inst:AddTag("plant")
	
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
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
		
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)	
		
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("sap_vinebush", fn, assets, prefabs),
MakePlacer("sap_vinebush_placer", "bush_vine", "bush_vine", "idle")
