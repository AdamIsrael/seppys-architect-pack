require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/carnivalgame_herding_station.zip"),
	Asset("ANIM", "anim/carnivalgame_herding_floor.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function TurnOn(inst)
	inst.Light:Enable(true)
	inst.AnimState:PlayAnimation("turn_on")
	inst.AnimState:PushAnimation("on")
	inst.SoundEmitter:PlaySound("summerevent/carnival_games/herding_station/turn_on")
	inst:DoTaskInTime(18*FRAMES, function() inst.SoundEmitter:PlaySound("summerevent/carnival_games/herding_station/LP", "on_loop") end)
	inst.on = true
end

local function TurnOff(inst)
	inst.Light:Enable(false)
	inst.AnimState:PlayAnimation("turn_off")
	inst.AnimState:PushAnimation("idle_off")
	inst.SoundEmitter:KillSound("on_loop")
	inst.SoundEmitter:PlaySound("summerevent/carnival_games/herding_station/endbell")
	inst:DoTaskInTime(10*FRAMES, function() inst.SoundEmitter:PlaySound("summerevent/carnival_games/herding_station/turn_off") end)
	inst.on = false
end

local function GetStatus(inst, viewer)
	if inst.on then
		return "ON"
	else
		return "OFF"
	end
end

local function OnSave(inst, data)
    local refs = {}
    return refs
end

local function OnLoad(inst, data)
end

local function CanInteract(inst)
	if inst.components.machine.ison then
		return false
	end
	return true
end

local function onhit(inst, worker)
	if inst.on then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("on", true)
	else
		inst.AnimState:PlayAnimation("hit_off")
		inst.AnimState:PushAnimation("idle_off", true)
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle_off", true)
	inst.SoundEmitter:PlaySound("summerevent/carnival_games/herding_station/place")
end

local function machinefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(0.9)
    inst.Light:SetRadius(.7)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 150/255)
	inst.on = false
	
    MakeObstaclePhysics(inst, .5)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("carnivalgame_herding_station.png")
	
    inst.AnimState:SetBank("carnivalgame_herding_station")
    inst.AnimState:SetBuild("carnivalgame_herding_station")
    inst.AnimState:PlayAnimation("idle_off")
    
	inst:AddTag("structure")
	inst:AddTag("sap_carnival")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CARNIVALGAME_HERDING_STATION"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeSnowCovered(inst)
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	inst.on = false
	inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
	
    return inst
end

local function floorfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetBank("carnivalgame_herding_floor")
	inst.AnimState:SetBuild("carnivalgame_herding_floor")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(-2)
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("structure")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)

	inst:ListenForEvent("onbuilt", function() inst.AnimState:PlayAnimation("place") inst.AnimState:PushAnimation("idle", false) end)

	return inst
end

local function floorfn2()
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetBank("carnivalgame_herding_floor")
	inst.AnimState:SetBuild("carnivalgame_herding_floor")
	inst.AnimState:PlayAnimation("ring")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(-2)
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("structure")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)

	inst:ListenForEvent("onbuilt", function() inst.AnimState:PlayAnimation("place_ring") inst.AnimState:PushAnimation("ring", false) end)

	return inst
end

return Prefab("sap_carnival_herding_station", machinefn, assets),
Prefab("sap_carnival_herding_floor", floorfn, assets),
Prefab("sap_carnival_herding_floor2", floorfn2, assets),
MakePlacer("sap_carnival_herding_station_placer", "carnivalgame_herding_station", "carnivalgame_herding_station", "idle_off"),
MakePlacer("sap_carnival_herding_floor_placer", "carnivalgame_herding_floor", "carnivalgame_herding_floor", "idle", true, nil, nil, nil, 90, nil),
MakePlacer("sap_carnival_herding_floor2_placer", "carnivalgame_herding_floor", "carnivalgame_herding_floor", "ring", true, nil, nil, nil, 90, nil)