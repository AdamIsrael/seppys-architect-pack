local assets=
{
	Asset("ANIM", "anim/ox_flute.zip"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local function OnFinished(inst)
    inst:Remove()
end

local function OnFlutePlayed(inst, musician, instrument)
	TheWorld:PushEvent("ms_forceprecipitation")
end

local function OnHearFlute(inst, musician, instrument)
	if inst.components.farmplanttendable ~= nil then
		inst.components.farmplanttendable:TendTo(musician)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
    MakeInventoryFloatable(inst, "small", 0.05, 0.8)
    
    inst.AnimState:SetBank("ox_flute")
    inst.AnimState:SetBuild("ox_flute")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:OverrideSymbol("pan_flute01", "ox_flute01", "pan_flute01")
	
	inst.flutebuild = "ox_flute"
    inst.flutesymbol = "ox_flute01"
	
	inst:AddTag("flute")
	inst:AddTag("flute_rain")
	inst:AddTag("tool")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
    
    inst:AddComponent("inspectable")
	
    inst:AddComponent("instrument")
	inst.components.instrument.range = TUNING.PANFLUTE_SLEEPRANGE
    inst.components.instrument:SetOnPlayedFn(OnFlutePlayed)
	inst.components.instrument:SetOnHeardFn(OnHearFlute)
    inst.components.instrument.sound_noloop = "dontstarve_DLC002/common/ox_flute"    
    
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(5)
    inst.components.finiteuses:SetUses(5)
    inst.components.finiteuses:SetOnFinished(OnFinished)
    inst.components.finiteuses:SetConsumption(ACTIONS.PLAY, 1)
        
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	
	MakeHauntableLaunch(inst)

    inst:ListenForEvent("floater_startfloating", function(inst) inst.AnimState:PlayAnimation("idle_water") end)
    inst:ListenForEvent("floater_stopfloating", function(inst) inst.AnimState:PlayAnimation("idle") end)
    
    return inst
end

return Prefab("sap_ox_flute", fn, assets)