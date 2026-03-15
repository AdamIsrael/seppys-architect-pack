require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/pig_house_sale.zip"),
    Asset("ANIM", "anim/player_small_house1.zip"),
    Asset("ANIM", "anim/player_large_house1.zip"),

    Asset("ANIM", "anim/player_large_house1_manor_build.zip"),
    Asset("ANIM", "anim/player_large_house1_villa_build.zip"),
    Asset("ANIM", "anim/player_small_house1_cottage_build.zip"),
    Asset("ANIM", "anim/player_small_house1_tudor_build.zip"),
    Asset("ANIM", "anim/player_small_house1_gothic_build.zip"),
    Asset("ANIM", "anim/player_small_house1_brick_build.zip"),
    Asset("ANIM", "anim/player_small_house1_turret_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
	"collapse_big"
}

local SCALEBUILD = {}
SCALEBUILD["player_large_house1_manor_build"] = true
SCALEBUILD["player_large_house1_villa_build"] = true
SCALEBUILD["player_small_house1_cottage_build"] = true
SCALEBUILD["player_small_house1_tudor_build"] = true
SCALEBUILD["player_small_house1_gothic_build"] = true
SCALEBUILD["player_small_house1_brick_build"] = true
SCALEBUILD["player_small_house1_turret_build"] = true

local SETBANK = {}
SETBANK["player_large_house1_manor_build"] = "player_large_house1"
SETBANK["player_large_house1_villa_build"] = "player_large_house1"
SETBANK["player_small_house1_cottage_build"] = "player_small_house1"
SETBANK["player_small_house1_tudor_build"] = "player_small_house1"
SETBANK["player_small_house1_gothic_build"] = "player_small_house1"
SETBANK["player_small_house1_brick_build"] = "player_small_house1"
SETBANK["player_small_house1_turret_build"] = "player_small_house1"

local house_builds = {
   "player_large_house1_manor_build",
   "player_large_house1_villa_build",
   "player_small_house1_cottage_build",
   "player_small_house1_tudor_build",
   "player_small_house1_gothic_build",
   "player_small_house1_brick_build",
   "player_small_house1_turret_build",
}

local function setScale(inst,build)
    if SCALEBUILD[build] then
        inst.AnimState:SetScale(0.75,0.75,0.75)
	end
end

local function getScale(inst,build)
    if SCALEBUILD[build] then
        return {0.75,0.75,0.75}
	end
end

local function LightsOn(inst, isdusk)
    if not inst:HasTag("burnt") and isdusk then
        inst.Light:Enable(true)
        inst.AnimState:PlayAnimation("lit", true)
        inst.lightson = true
    end
end

local function LightsOff(inst, isday)
    if not inst:HasTag("burnt") and isday then
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("idle", true)
        inst.lightson = false
    end
end

local function onfar(inst)
end

local function getstatus(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    elseif inst.unboarded then
        return "SOLD"
    end
end

local function onnear(inst)
end

local function onwere(child)
    if child.parent and not child.parent:HasTag("burnt") then
        child.parent.SoundEmitter:KillSound("pigsound")
    end
end

local function onnormal(child)
    if child.parent and not child.parent:HasTag("burnt") then
        child.parent.SoundEmitter:KillSound("pigsound")
    end
end

local function onoccupied(inst, child)
    if not inst:HasTag("burnt") then
        if inst.doortask then
            inst.doortask:Cancel()
            inst.doortask = nil
        end
        inst.doortask = inst:DoTaskInTime(1, function() LightsOn(inst) end)
    	if child then
    	    inst:ListenForEvent("transformwere", onwere, child)
    	    inst:ListenForEvent("transformnormal", onnormal, child)
    	end
    end
end

local function onburntup(inst)
    if inst.doortask ~= nil then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    if inst.inittask ~= nil then
        inst.inittask:Cancel()
        inst.inittask = nil
    end
    if inst._window ~= nil then
        inst._window:Remove()
        inst._window = nil
    end
    if inst._windowsnow ~= nil then
        inst._windowsnow:Remove()
        inst._windowsnow = nil
    end
end

local function onignite(inst)
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        inst.components.spawner:ReleaseChild()
    end
end

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
    	inst.AnimState:PlayAnimation("hit")
    	inst.AnimState:PushAnimation("idle")
    end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")
end

local function setcolor(inst,num)
    if not num then
        num = math.random()
    end
    local color = 0.5 + num * 0.5
    inst.AnimState:SetMultColour(color, color, color, 1)
    return num
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
    data.build = inst.build
    data.animset = inst.animset
    data.colornum = inst.colornum
end

local function onload(inst, data)
    if data then
        if data.build then
            inst.build = data.build
            inst.AnimState:SetBuild(inst.build) 
            setScale(inst,inst.build)
        end
        if data.animset then
            inst.animset = data.animset
            inst.AnimState:SetBank( inst.animset )
        end    
        if data.colornum then
            inst.colornum = setcolor(inst, data.colornum)
        end
        if data.burnt then
            inst.components.burnable.onburnt(inst)
        end
    end
end

local function Slantyfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_playerhouse.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetScale(0.75,0.75,0.75)
	inst.AnimState:SetBank("pig_house_sale")
	inst.AnimState:SetBuild("pig_house_sale")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("boards")
	
	MakeObstaclePhysics(inst, 1)
	inst.unboarded = true
	
	inst:AddTag("structure")
	inst:AddTag("playerhouse")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
    inst.OnSave = onsave 
    inst.OnLoad = onload

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function Manorfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_playerhouse_manor.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(4)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetScale(0.75,0.75,0.75)
	inst.AnimState:SetBank("playerhouse_large")
	inst.AnimState:SetBuild("player_large_house1_manor_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("boards")
	
	MakeObstaclePhysics(inst, 1)
	inst.unboarded = true
	
	inst:AddTag("structure")
	inst:AddTag("playerhouse")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"cutstone", "boards", "goldnugget", "goldnugget"})
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
    inst.OnSave = onsave 
    inst.OnLoad = onload

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:WatchWorldState("isday", LightsOff)
    LightsOff(inst, TheWorld.state.isday)

    inst:WatchWorldState("isdusk", LightsOn)
    LightsOn(inst, TheWorld.state.isdusk)

	return inst
end

local function Villafn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_playerhouse_villa.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(4)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetScale(0.75,0.75,0.75)
	inst.AnimState:SetBank("playerhouse_large")
	inst.AnimState:SetBuild("player_large_house1_villa_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("boards")
	
	MakeObstaclePhysics(inst, 1)
	inst.unboarded = true

	inst:AddTag("structure")
	inst:AddTag("playerhouse")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"cutstone", "boards", "goldnugget", "goldnugget"})
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
    inst.OnSave = onsave 
    inst.OnLoad = onload

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:WatchWorldState("isday", LightsOff)
    LightsOff(inst, TheWorld.state.isday)

    inst:WatchWorldState("isdusk", LightsOn)
    LightsOn(inst, TheWorld.state.isdusk)

	return inst
end

local function Cottagefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_playerhouse_cottage.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(4)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetScale(0.75,0.75,0.75)
	inst.AnimState:SetBank("playerhouse_small")
	inst.AnimState:SetBuild("player_small_house1_cottage_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("boards")
	
	MakeObstaclePhysics(inst, 1)
	inst.unboarded = true

	inst:AddTag("structure")
	inst:AddTag("playerhouse")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"cutstone", "boards", "goldnugget", "goldnugget"})
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
    inst.OnSave = onsave 
    inst.OnLoad = onload

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:WatchWorldState("isday", LightsOff)
    LightsOff(inst, TheWorld.state.isday)

    inst:WatchWorldState("isdusk", LightsOn)
    LightsOn(inst, TheWorld.state.isdusk)

	return inst
end

local function Tudorfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_playerhouse_tudor.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(4)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetScale(0.75,0.75,0.75)
	inst.AnimState:SetBank("playerhouse_small")
	inst.AnimState:SetBuild("player_small_house1_tudor_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("boards")
	
	MakeObstaclePhysics(inst, 1)
	inst.unboarded = true

	inst:AddTag("structure")
	inst:AddTag("playerhouse")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"cutstone", "boards", "goldnugget", "goldnugget"})
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
    inst.OnSave = onsave 
    inst.OnLoad = onload

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:WatchWorldState("isday", LightsOff)
    LightsOff(inst, TheWorld.state.isday)

    inst:WatchWorldState("isdusk", LightsOn)
    LightsOn(inst, TheWorld.state.isdusk)

	return inst
end

local function Gothicfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_playerhouse_gothic.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(4)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetScale(0.75,0.75,0.75)
	inst.AnimState:SetBank("playerhouse_small")
	inst.AnimState:SetBuild("player_small_house1_gothic_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("boards")
	
	MakeObstaclePhysics(inst, 1)
	inst.unboarded = true

	inst:AddTag("structure")
	inst:AddTag("playerhouse")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"cutstone", "boards", "goldnugget", "goldnugget"})
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
    inst.OnSave = onsave 
    inst.OnLoad = onload

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:WatchWorldState("isday", LightsOff)
    LightsOff(inst, TheWorld.state.isday)

    inst:WatchWorldState("isdusk", LightsOn)
    LightsOn(inst, TheWorld.state.isdusk)

	return inst
end

local function Brickfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_playerhouse_brick.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(4)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetScale(0.75,0.75,0.75)
	inst.AnimState:SetBank("playerhouse_small")
	inst.AnimState:SetBuild("player_small_house1_brick_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("boards")
	
	MakeObstaclePhysics(inst, 1)
	inst.unboarded = true

	inst:AddTag("structure")
	inst:AddTag("playerhouse")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"cutstone", "boards", "goldnugget", "goldnugget"})
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
    inst.OnSave = onsave 
    inst.OnLoad = onload

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:WatchWorldState("isday", LightsOff)
    LightsOff(inst, TheWorld.state.isday)

    inst:WatchWorldState("isdusk", LightsOn)
    LightsOn(inst, TheWorld.state.isdusk)

	return inst
end

local function Turretfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_playerhouse_turret.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(4)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetScale(0.75,0.75,0.75)
	inst.AnimState:SetBank("playerhouse_small")
	inst.AnimState:SetBuild("player_small_house1_turret_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("boards")
	
	MakeObstaclePhysics(inst, 1)
	inst.unboarded = true

	inst:AddTag("structure")
	inst:AddTag("playerhouse")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"cutstone", "boards", "goldnugget", "goldnugget"})
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	
    inst.OnSave = onsave 
    inst.OnLoad = onload

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:WatchWorldState("isday", LightsOff)
    LightsOff(inst, TheWorld.state.isday)

    inst:WatchWorldState("isdusk", LightsOn)
    LightsOn(inst, TheWorld.state.isdusk)

	return inst
end

local function commonplacefn(inst)
	inst.AnimState:Hide("SNOW")
	inst.AnimState:Hide("boards")
	inst.AnimState:SetScale(0.75,0.75,0.75)
end

local function playerhouseplacetestfn(inst)
    inst.AnimState:Hide("SNOW")
	inst.AnimState:Hide("boards")
	inst.AnimState:SetScale(0.75,0.75,0.75)
	inst.ApplySkin = function(inst, skin)
		if skin == "sap_playerhouse1" then
			inst.AnimState:SetBank("playerhouse_small")
			inst.AnimState:SetBuild("player_small_house1_cottage_build")
		elseif skin == "sap_playerhouse2" then
			inst.AnimState:SetBank("playerhouse_small")
			inst.AnimState:SetBuild("player_small_house1_tudor_build")
		elseif skin == "sap_playerhouse3" then
			inst.AnimState:SetBank("playerhouse_small")
			inst.AnimState:SetBuild("player_small_house1_gothic_build")
		elseif skin == "sap_playerhouse4" then
			inst.AnimState:SetBank("playerhouse_small")
			inst.AnimState:SetBuild("player_small_house1_brick_build")
		elseif skin == "sap_playerhouse5" then
			inst.AnimState:SetBank("playerhouse_small")
			inst.AnimState:SetBuild("player_small_house1_turret_build")
		elseif skin == "sap_playerhouse6" then
			inst.AnimState:SetBank("playerhouse_large")
			inst.AnimState:SetBuild("player_large_house1_manor_build")
		elseif skin == "sap_playerhouse7" then
			inst.AnimState:SetBank("playerhouse_large")
			inst.AnimState:SetBuild("player_large_house1_villa_build")
		end
	end
    return true
end

return Prefab("sap_playerhouse", Slantyfn, assets, prefabs),
Prefab("sap_playerhouse1", Cottagefn, assets, prefabs),
Prefab("sap_playerhouse2", Tudorfn, assets, prefabs),
Prefab("sap_playerhouse3", Gothicfn, assets, prefabs),
Prefab("sap_playerhouse4", Brickfn, assets, prefabs),
Prefab("sap_playerhouse5", Turretfn, assets, prefabs),
Prefab("sap_playerhouse6", Manorfn, assets, prefabs),
Prefab("sap_playerhouse7", Villafn, assets, prefabs),
MakePlacer("sap_playerhouse_placer", "pig_house_sale", "pig_house_sale", "idle", false, nil, nil, nil, nil, nil, playerhouseplacetestfn),
MakePlacer("sap_playerhouse1_placer", "playerhouse_small", "player_small_house1_cottage_build", "idle", false, nil, nil, nil, nil, nil, commonplacefn),
MakePlacer("sap_playerhouse2_placer", "playerhouse_small", "player_small_house1_tudor_build", "idle", false, nil, nil, nil, nil, nil, commonplacefn),
MakePlacer("sap_playerhouse3_placer", "playerhouse_small", "player_small_house1_gothic_build", "idle", false, nil, nil, nil, nil, nil, commonplacefn),
MakePlacer("sap_playerhouse4_placer", "playerhouse_small", "player_small_house1_brick_build", "idle", false, nil, nil, nil, nil, nil, commonplacefn),
MakePlacer("sap_playerhouse5_placer", "playerhouse_small", "player_small_house1_turret_build", "idle", false, nil, nil, nil, nil, nil, commonplacefn),
MakePlacer("sap_playerhouse6_placer", "playerhouse_large", "player_large_house1_manor_build", "idle", false, nil, nil, nil, nil, nil, commonplacefn),
MakePlacer("sap_playerhouse7_placer", "playerhouse_large", "player_large_house1_villa_build", "idle", false, nil, nil, nil, nil, nil, commonplacefn)
--[[
CreateModPrefabSkin("sap_playerhouse1",
	{
		assets = {
			Asset("ANIM", "anim/player_small_house1.zip"),
			Asset("ANIM", "anim/player_small_house1_cottage_build.zip"),
		},
		base_prefab = "sap_playerhouse",
		fn = Cottagefn,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "player_small_house1_cottage_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("sap_playerhouse2",
	{
		assets = {
			Asset("ANIM", "anim/player_small_house1.zip"),
			Asset("ANIM", "anim/player_small_house1_tudor_build.zip"),
		},
		base_prefab = "sap_playerhouse",
		fn = Tudorfn,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "player_small_house1_tudor_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("sap_playerhouse3",
	{
		assets = {
			Asset("ANIM", "anim/player_small_house1.zip"),
			Asset("ANIM", "anim/player_small_house1_gothic_build.zip"),
		},
		base_prefab = "sap_playerhouse",
		fn = Gothicfn,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "player_small_house1_gothic_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("sap_playerhouse4",
	{
		assets = {
			Asset("ANIM", "anim/player_small_house1.zip"),
			Asset("ANIM", "anim/player_small_house1_brick_build.zip"),
		},
		base_prefab = "sap_playerhouse",
		fn = Brickfn,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "player_small_house1_brick_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("sap_playerhouse5",
	{
		assets = {
			Asset("ANIM", "anim/player_small_house1.zip"),
			Asset("ANIM", "anim/player_small_house1_turret_build.zip"),
		},
		base_prefab = "sap_playerhouse",
		fn = Turretfn,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "player_small_house1_turret_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("sap_playerhouse6",
	{
		assets = {
			Asset("ANIM", "anim/player_large_house1.zip"),
			Asset("ANIM", "anim/player_large_house1_manor_build.zip"),
		},
		base_prefab = "sap_playerhouse",
		fn = Manorfn,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "player_large_house1_manor_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("sap_playerhouse7",
	{
		assets = {
			Asset("ANIM", "anim/player_large_house1.zip"),
			Asset("ANIM", "anim/player_large_house1_villa_build.zip"),
		},
		base_prefab = "sap_playerhouse",
		fn = Villafn,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "player_large_house1_villa_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	})
]]--