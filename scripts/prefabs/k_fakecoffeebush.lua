require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/coffeebush.zip"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("poop")
	inst.components.lootdropper:SpawnLootPrefab("dug_berrybush")
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_fake_coffeebush.tex")
	
	inst.AnimState:SetBank("coffeebush")
	inst.AnimState:SetBuild("coffeebush")
	inst.AnimState:PlayAnimation("berriesmost", true)
	
	MakeObstaclePhysics(inst, .1)
	
	inst:AddTag("structure")
	inst:AddTag("fake_coffeebush")
	
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

	return inst
end

return Prefab("sap_fakecoffeebush", fn, assets, prefabs),
MakePlacer("sap_fakecoffeebush_placer", "coffeebush", "coffeebush", "berriesmost")
