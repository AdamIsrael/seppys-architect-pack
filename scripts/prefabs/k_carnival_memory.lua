require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/carnivalgame_memory_card.zip"),
	Asset("ANIM", "anim/carnivalgame_memory_station.zip"),
	Asset("ANIM", "anim/carnivalgame_memory_floor.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function TurnOnBad(inst)
	inst.AnimState:PlayAnimation("turn_on")
	inst:ListenForEvent("animover", function() inst.AnimState:PlayAnimation("on") end)
	inst:ListenForEvent("animover", function() inst.AnimState:PlayAnimation("reveal_bad_pre") end)
	inst:ListenForEvent("animover", function() inst.AnimState:PlayAnimation("reveal_bad_loop", true) end)
	-- inst.AnimState:PlayAnimation("on")
	-- inst.AnimState:PlayAnimation("reveal_bad_pre")
	-- inst.AnimState:PushAnimation("reveal_bad_loop", true)
	inst.on = true
end

local function TurnOnGood(inst)
	inst.AnimState:PlayAnimation("turn_on")
	inst:ListenForEvent("animover", function() inst.AnimState:PlayAnimation("on") end)
	inst:ListenForEvent("animover", function() inst.AnimState:PlayAnimation("reveal_good_pre") end)
	inst:ListenForEvent("animover", function() inst.AnimState:PlayAnimation("reveal_good_loop", true) end)
	-- inst.AnimState:PlayAnimation("on")
	-- inst.AnimState:PlayAnimation("reveal_good_pre")
	-- inst.AnimState:PushAnimation("reveal_good_loop", true)
	inst.on = true
end

local function TurnOffBad(inst)
	inst.AnimState:PlayAnimation("reveal_bad_pst")
	inst:ListenForEvent("animover", function() inst.AnimState:PlayAnimation("turn_off") end)
	inst:ListenForEvent("animover", function() inst.AnimState:PlayAnimation("off", true) end)
	-- inst.AnimState:PlayAnimation("turn_off")
	-- inst.AnimState:PushAnimation("off", true)
	inst.on = false
end

local function TurnOffGood(inst)
	inst.AnimState:PlayAnimation("reveal_good_pst")
	inst:ListenForEvent("animover", function() inst.AnimState:PlayAnimation("turf_off") end)
	inst:ListenForEvent("animover", function() inst.AnimState:PlayAnimation("off", true) end)
	-- inst.AnimState:PlayAnimation("turn_off")
	-- inst.AnimState:PushAnimation("off", true)
	inst.on = false
end

local function TurnOn(inst)
	inst.Light:Enable(true)
	inst.AnimState:PlayAnimation("turn_on")
	inst.AnimState:PushAnimation("idle_on")
	inst.SoundEmitter:PlaySound("summerevent/carnival_games/memory/LP", "loop")
	inst.on = true
end

local function TurnOff(inst)
	inst.Light:Enable(false)
	inst.AnimState:PlayAnimation("turn_off")
	inst.AnimState:PushAnimation("idle_off")
	inst.SoundEmitter:KillSound("loop")
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

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("off", true)
end

local function OnBuilt2(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle_off", true)
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

local function badfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("carnivalgame_memory_card")
    inst.AnimState:SetBuild("carnivalgame_memory_card")
    inst.AnimState:PlayAnimation("off")
    
	inst:AddTag("structure")
	inst:AddTag("sap_carnival")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOnBad
	inst.components.machine.turnofffn = TurnOffBad
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CARNIVALGAME_MEMORY_CARD"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
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

local function goodfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("carnivalgame_memory_card")
    inst.AnimState:SetBuild("carnivalgame_memory_card")
    inst.AnimState:PlayAnimation("off")
    
	inst:AddTag("structure")
	inst:AddTag("sap_carnival")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOnGood
	inst.components.machine.turnofffn = TurnOffGood
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CARNIVALGAME_MEMORY_CARD"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
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
	minimap:SetIcon("carnivalgame_memory_station.png")
	
    inst.AnimState:SetBank("carnivalgame_memory_station")
    inst.AnimState:SetBuild("carnivalgame_memory_station")
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
	inst.components.inspectable.nameoverride = "CARNIVALGAME_MEMORY_STATION"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeSnowCovered(inst)
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", OnBuilt2)
	
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

	inst.AnimState:SetBank("carnivalgame_memory_floor")
	inst.AnimState:SetBuild("carnivalgame_memory_floor")
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

return Prefab("sap_carnival_memory_bad", badfn, assets),
Prefab("sap_carnival_memory_good", goodfn, assets),
Prefab("sap_carnival_memory_station", machinefn, assets),
Prefab("sap_carnival_memory_floor", floorfn, assets),
MakePlacer("sap_carnival_memory_bad_placer", "carnivalgame_memory_card", "carnivalgame_memory_card", "off"),
MakePlacer("sap_carnival_memory_good_placer", "carnivalgame_memory_card", "carnivalgame_memory_card", "off"),
MakePlacer("sap_carnival_memory_station_placer", "carnivalgame_memory_station", "carnivalgame_memory_station", "idle_off"),
MakePlacer("sap_carnival_memory_floor_placer", "carnivalgame_memory_floor", "carnivalgame_memory_floor", "idle", true, nil, nil, nil, 90, nil)