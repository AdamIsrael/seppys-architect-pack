require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/lava_vomit.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst:Remove()
	inst.components.lootdropper:DropLoot()
end

local INTENSITY = .7

local function fade_in(inst)
    inst.components.fader:StopAll()
    inst.Light:Enable(true)
    inst.components.fader:Fade(0, INTENSITY, 5*FRAMES, function(v) inst.Light:SetIntensity(v) end)
end

local function fade_out(inst)
    inst.components.fader:StopAll()
    inst.components.fader:Fade(INTENSITY, 0, 5*FRAMES, function(v) inst.Light:SetIntensity(v) end, function() inst.Light:Enable(false) end)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()
	
	inst.Light:SetFalloff(.5)
    inst.Light:SetIntensity(INTENSITY)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(200/255, 100/255, 170/255)
	
	inst.AnimState:SetBank("lava_vomit")
	inst.AnimState:SetBuild("lava_vomit")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	
	inst:AddTag("structure")
	inst:AddTag("vomit")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("heater")
    inst.components.heater.heat = 50
	
	inst:AddComponent("fader")
	
	inst:AddComponent("propagator")
    inst.components.propagator.damages = true
    inst.components.propagator.propagaterange = 3
    inst.components.propagator.damagerange = 3
    inst.components.propagator:StartSpreading()

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	MakeSmallPropagator(inst)
	fade_in(inst)
	
	return inst
end

return Prefab("sap_dragoonspit", fn, assets, prefabs),
MakePlacer("sap_dragoonspit_placer", "lava_vomit", "lava_vomit", "idle_loop")
