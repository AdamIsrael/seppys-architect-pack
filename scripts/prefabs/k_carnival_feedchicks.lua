require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/carnivalgame_feedchicks_station.zip"),
	Asset("ANIM", "anim/carnivalgame_feedchicks_floor.zip"),
	Asset("ANIM", "anim/carnivalgame_feedchicks_bird.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
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
	inst.AnimState:PushAnimation("idle_on")
	inst.SoundEmitter:PlaySound("summerevent/carnival_games/feedchicks/station/turnon")
	inst.on = true
end

local function TurnOff(inst)
	inst.Light:Enable(false)
	inst.AnimState:PlayAnimation("turn_off")
	inst.AnimState:PushAnimation("idle_off")
	inst.SoundEmitter:KillSound("on_loop")
	inst.SoundEmitter:PlaySound("summerevent/carnival_games/feedchicks/station/turnoff")
	inst.SoundEmitter:PlaySound("summerevent/carnival_games/feedchicks/station/endbell")
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
		inst.AnimState:PlayAnimation("hit_on")
		inst.AnimState:PushAnimation("idle_on", true)
	else
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle_off", true)
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle_off", true)
	inst.SoundEmitter:PlaySound("summerevent/carnival_games/feedchicks/station/place")
end

local function onfar(inst)
	inst.AnimState:PlayAnimation("hungry_pst")
	inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:KillSound("hungry")
	-- inst:AddTag("bird_wants_to_peek")
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("hungry_pre")
	inst.AnimState:PushAnimation("hungry_loop", true)
	inst.SoundEmitter:PlaySound("summerevent/carnival_games/feedchicks/bird/hungry_LP", "hungry")
	-- inst:RemoveTag("bird_wants_to_peek")
end

local function Peek(inst)
if inst:HasTag("bird_wants_to_peek") then
	inst:DoTaskInTime(4+math.random()*5, function() Peek(inst) end)
		inst.AnimState:PlayAnimation("idle2")
		inst.AnimState:PushAnimation("idle", true)
	end
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
	minimap:SetIcon("carnivalgame_feedchicks_station.png")
	
    inst.AnimState:SetBank("carnivalgame_feedchicks_station")
    inst.AnimState:SetBuild("carnivalgame_feedchicks_station")
    inst.AnimState:PlayAnimation("idle_off")
    
	inst:AddTag("structure")
	inst:AddTag("kyno_carnival")
	
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
	inst.components.inspectable.nameoverride = "CARNIVALGAME_FEEDCHICKS_STATION"
	
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

	inst.AnimState:SetBank("carnivalgame_feedchicks_floor")
	inst.AnimState:SetBuild("carnivalgame_feedchicks_floor")
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

local function birdfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, .5)

    inst.AnimState:SetBank("carnivalgame_feedchicks_bird")
    inst.AnimState:SetBuild("carnivalgame_feedchicks_bird")
    inst.AnimState:PlayAnimation("hungry_loop", true)

	inst:AddTag("structure")
	inst:AddTag("kyno_carnival")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CROW"
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3, 6)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	-- Peek(inst)
	
    return inst
end

return Prefab("kyno_carnival_feedchicks_station", machinefn, assets),
Prefab("kyno_carnival_feedchicks_floor", floorfn, assets),
Prefab("kyno_carnival_feedchicks_bird", birdfn, assets),
MakePlacer("kyno_carnival_feedchicks_station_placer", "carnivalgame_feedchicks_station", "carnivalgame_feedchicks_station", "idle_off"),
MakePlacer("kyno_carnival_feedchicks_floor_placer", "carnivalgame_feedchicks_floor", "carnivalgame_feedchicks_floor", "idle", true, nil, nil, nil, 90, nil),
MakePlacer("kyno_carnival_feedchicks_bird_placer", "carnivalgame_feedchicks_bird", "carnivalgame_feedchicks_bird", "hungry_loop")