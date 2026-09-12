require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/geyser.zip"),
}

local prefabs = {}

local function StartBurning(inst)
	inst.AnimState:PlayAnimation("active_pre")
	inst.AnimState:PushAnimation("active_loop")
    inst.Light:Enable(true)
	inst:AddComponent("cooker")
end

local function StopBurning(inst)
	inst.AnimState:PlayAnimation("active_pst")
	inst.AnimState:PushAnimation("idle_dormant")
	inst.Light:Enable(false)
	inst:RemoveComponent("cooker")
end

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:SpawnLootPrefab("redgem")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("active_pre")
	inst.AnimState:PushAnimation("active_loop", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.entity:AddLight()
	inst.Light:Enable(false)
	inst.Light:SetColour(223/255,246/255,255/255)
    inst.Light:SetIntensity(.75)
    inst.Light:SetFalloff(0.5)
	inst.Light:SetRadius(1)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_krissure.tex")
	
	inst.AnimState:SetBank("geyser")
	inst.AnimState:SetBuild("geyser")
	inst.AnimState:PlayAnimation("idle_dormant", true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	-- MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("cooker")
	inst:AddTag("structure")
	inst:AddTag("geyser")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/flamegeyser_open") 
	
	inst.no_wet_prefix = true
	
	inst:AddComponent("heater")
    inst.components.heater.heat = 100
	
	inst:AddComponent("propagator")
    inst.components.propagator.damages = true
    inst.components.propagator.propagaterange = 2
    inst.components.propagator.damagerange = 2
    inst.components.propagator:StartSpreading()
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	--[[
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6)
    inst.components.playerprox:SetOnPlayerNear(StartBurning)
    inst.components.playerprox:SetOnPlayerFar(StopBurning)
	]]--
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	MakeSmallPropagator(inst)	
	
	return inst
end

local function fn2()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.entity:AddLight()
	inst.Light:Enable(true)
	inst.Light:SetColour(223/255,246/255,255/255)
    inst.Light:SetIntensity(.8)
    inst.Light:SetFalloff(.33)
	inst.Light:SetRadius(3)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_krissure.tex")
	
	inst.AnimState:SetBank("geyser")
	inst.AnimState:SetBuild("geyser")
	inst.AnimState:PlayAnimation("active_loop", true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	-- MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("cooker")
	inst:AddTag("structure")
	inst:AddTag("geyser")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/flamegeyser_lp") 
	
	inst.no_wet_prefix = true
	
	inst:AddComponent("heater")
    inst.components.heater.heat = 100
	
	inst:AddComponent("propagator")
    inst.components.propagator.damages = true
    inst.components.propagator.propagaterange = 2
    inst.components.propagator.damagerange = 2
    inst.components.propagator:StartSpreading()
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	--[[
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6)
    inst.components.playerprox:SetOnPlayerNear(StartBurning)
    inst.components.playerprox:SetOnPlayerFar(StopBurning)
	]]--
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	MakeSmallPropagator(inst)	
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

return Prefab("sap_geyser", fn, assets, prefabs),
Prefab("sap_geyser_active", fn2, assets, prefabs),
MakePlacer("sap_geyser_placer", "geyser", "geyser", "idle_dormant"),
MakePlacer("sap_geyser_active_placer", "geyser", "geyser", "active_loop")
