require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/lava_pool.zip"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:SpawnLootPrefab("ash")
	inst.components.lootdropper:SpawnLootPrefab("ash")
	inst.components.lootdropper:SpawnLootPrefab("rocks")
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.entity:AddLight()
	inst.Light:Enable(true)
	inst.Light:SetColour(223/255,246/255,255/255)
    inst.Light:Enable(true)
    inst.Light:SetIntensity(.75)
    inst.Light:SetFalloff(0.5)
	inst.Light:SetRadius(1)
	
	inst.AnimState:SetBank("lava_pool")
	inst.AnimState:SetBuild("lava_pool")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.Transform:SetFourFaced()
	
	MakeObstaclePhysics(inst, .6)
	
	inst:AddTag("cooker")
	inst:AddTag("structure")
	inst:AddTag("lavapool")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.no_wet_prefix = true
	
	inst:AddComponent("cooker")
	
	inst:AddComponent("heater")
    inst.components.heater.heat = 100
	
	inst:AddComponent("burnable")
    inst.components.burnable:AddBurnFX("campfirefire", Vector3(0,0,0))
    -- inst.components.burnable:MakeNotWildfireStarter()
	
	inst:AddComponent("propagator")
    inst.components.propagator.damages = true
    inst.components.propagator.propagaterange = 3
    inst.components.propagator.damagerange = 3
    inst.components.propagator:StartSpreading()
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	MakeSmallPropagator(inst)	
	
	return inst
end

return Prefab("sap_lavapool", fn, assets, prefabs),
MakePlacer("sap_lavapool_placer", "lava_pool", "lava_pool", "idle_loop")
