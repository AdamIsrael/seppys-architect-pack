require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/legacy_statue_ruins.zip"),
    Asset("ANIM", "anim/statue_ruins_gem.zip"),
}

local prefabs =
{
	"statue_transition",
	"statue_transition_2"
}

SetSharedLootTable("sap_bluegem",
{
    {"thulecite",     1.00},
    {"thulecite",     1.00},
	{"bluegem",		  1.00},
	{"nightmarefuel", 1.00},
})

SetSharedLootTable("sap_redgem",
{
    {"thulecite",     1.00},
    {"thulecite",     1.00},
	{"redgem",		  1.00},
	{"nightmarefuel", 1.00},
})

SetSharedLootTable("sap_purplegem",
{
    {"thulecite",     1.00},
    {"thulecite",     1.00},
	{"purplegem",	  1.00},
})

SetSharedLootTable("sap_orangegem",
{
    {"thulecite",     1.00},
    {"thulecite",     1.00},
	{"orangegem",     1.00},
	{"nightmarefuel", 1.00},
})

SetSharedLootTable("sap_yellowgem",
{
    {"thulecite",     1.00},
    {"thulecite",     1.00},
	{"yellowgem",     1.00},
	{"nightmarefuel", 1.00},
})

SetSharedLootTable("sap_greengem",
{
    {"thulecite",     1.00},
    {"thulecite",     1.00},
	{"greengem",	  1.00},
	{"nightmarefuel", 1.00},
})

local MAX_LIGHT_ON_FRAME = 15
local MAX_LIGHT_OFF_FRAME = 30

local function OnUpdateLight(inst, dframes)
    local frame = inst._lightframe:value() + dframes
    if frame >= inst._lightmaxframe then
        inst._lightframe:set_local(inst._lightmaxframe)
        inst._lighttask:Cancel()
        inst._lighttask = nil
    else
        inst._lightframe:set_local(frame)
    end

    local k = frame / inst._lightmaxframe
    inst.Light:SetRadius(inst._lightradius1:value() * k + inst._lightradius0:value() * (1 - k))

    if TheWorld.ismastersim then
        inst.Light:Enable(inst._lightradius1:value() > 0 or frame < inst._lightmaxframe)
    end
end

local function OnLightDirty(inst)
    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    inst._lightmaxframe = inst._lightradius1:value() > 0 and MAX_LIGHT_ON_FRAME or MAX_LIGHT_OFF_FRAME
    OnUpdateLight(inst, 0)
end

local function DoFx(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")

    local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("statue_transition_2")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
        fx.Transform:SetScale(1, 2, 1)
    end
    fx = SpawnPrefab("statue_transition")
    if fx ~= nil then
        fx.Transform:SetPosition(x, y, z)
        fx.Transform:SetScale(1, 1.5, 1)
    end
end

local function fade_to(inst, rad, instant)
    rad = rad or 0
    if inst._lightradius1:value() ~= rad then
        local k = inst._lightframe:value() / inst._lightmaxframe
        local radius = inst._lightradius1:value() * k + inst._lightradius0:value() * (1 - k)
        local minradius0 = math.min(inst._lightradius0:value(), inst._lightradius1:value())
        local maxradius0 = math.max(inst._lightradius0:value(), inst._lightradius1:value())
        if radius > rad then
            inst._lightradius0:set(radius > minradius0 and maxradius0 or minradius0)
        else
            inst._lightradius0:set(radius < maxradius0 and minradius0 or maxradius0)
        end
        local maxframe = rad > 0 and MAX_LIGHT_ON_FRAME or MAX_LIGHT_OFF_FRAME
        inst._lightradius1:set(rad)
        inst._lightframe:set(
            instant and
            (rad > 0 and MAX_LIGHT_ON_FRAME or MAX_LIGHT_OFF_FRAME) or
            math.max(0, math.floor((radius - inst._lightradius0:value()) / (rad - inst._lightradius0:value()) * maxframe + .5))
        )
        OnLightDirty(inst)
    end
end

local function ShowWorkState(inst, worker, workleft)
    --NOTE: worker is nil when called from ShowPhaseState
    inst.AnimState:PlayAnimation(
        (   (workleft < TUNING.MARBLEPILLAR_MINE / 3 and "hit_low") or
            (workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "hit_med") or
            "idle_full"
        )..(inst._suffix or ""),
        true
    )
end

local function OnWorkFinished(inst)--, worker)
    inst.components.lootdropper:DropLoot(inst:GetPosition())

    local fx = SpawnAt("collapse_small", inst)
    fx:SetMaterial("rock")

    if TheWorld.state.isnightmarewild and math.random() <= .3 then
        SpawnAt(math.random() < .5 and "nightmarebeak" or "crawlingnightmare", inst)
    end

    inst:Remove()
end

local function ShowPhaseState(inst, phase, instant)
    inst._phasetask = nil

    if phase == "wild" then
        fade_to(inst, 4, instant)

        if inst._suffix == nil then
            inst._suffix = "_night"
            if not instant then
                DoFx(inst)
            end
        end

        inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    else
        fade_to(inst, (phase == "warn" or phase == "dawn") and 2 or 0, instant)

        if inst._suffix ~= nil then
            inst._suffix = nil
            if not instant then
                DoFx(inst)
            end
        end

        inst.AnimState:ClearBloomEffectHandle()
    end

    ShowWorkState(inst, nil, inst.components.workable.workleft)
end

local function OnNightmarePhaseChanged(inst, phase, instant)
    if inst._phasetask ~= nil then
        inst._phasetask:Cancel()
    end
    if instant or inst:IsAsleep() then
        ShowPhaseState(inst, phase, true)
    else
        inst._phasetask = inst:DoTaskInTime(math.random() * 2, ShowPhaseState, phase)
    end
end

local function OnEntitySleep(inst)
    if inst.small then
        inst.SoundEmitter:KillSound("hoverloop")
    end
    if inst._phasetask ~= nil then
        inst._phasetask:Cancel()
        ShowPhaseState(inst, TheWorld.state.nightmarephase, true)
    end
end

local function OnEntityWake(inst)
    if --[[inst.small and]] not inst.SoundEmitter:PlayingSound("hoverloop") then
        inst.SoundEmitter:PlaySound("dontstarve/common/floating_statue_hum", "hoverloop")
    end
end

local function bluefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetRadius(0)
    inst.Light:SetIntensity(.9)
    inst.Light:SetFalloff(.9)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_ruins.png")
	
	MakeObstaclePhysics(inst, 0.66)
	
	inst.AnimState:SetBank("lsr")
	inst.AnimState:SetBuild("legacy_statue_ruins")
	inst.AnimState:PlayAnimation("idle_full", true)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "bluegem")
	
	inst:AddTag("structure")
	inst:AddTag("statue")
	inst:AddTag("rotatableobject")
	
	inst:SetPrefabNameOverride("ancient_statue")
	
	inst._lightframe = net_smallbyte(inst.GUID, "ruins_statue._lightframe", "lightdirty")
    inst._lightradius0 = net_tinybyte(inst.GUID, "ruins_statue._lightradius0", "lightdirty")
    inst._lightradius1 = net_tinybyte(inst.GUID, "ruins_statue._lightradius1", "lightdirty")
    inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
    inst._lightframe:set(inst._lightmaxframe)
    inst._lighttask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)

        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
    inst.components.workable:SetOnWorkCallback(ShowWorkState)
    inst.components.workable:SetOnFinishCallback(OnWorkFinished)
	
	inst.OnEntitySleep = OnEntitySleep
	
	inst:WatchWorldState("nightmarephase", OnNightmarePhaseChanged)
    OnNightmarePhaseChanged(inst, TheWorld.state.nightmarephase, true)

	return inst
end

local function redfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetRadius(0)
    inst.Light:SetIntensity(.9)
    inst.Light:SetFalloff(.9)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_ruins.png")
	
	MakeObstaclePhysics(inst, 0.66)
	
	inst.AnimState:SetBank("lsr")
	inst.AnimState:SetBuild("legacy_statue_ruins")
	inst.AnimState:PlayAnimation("idle_full", true)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "redgem")
	
	inst:AddTag("structure")
	inst:AddTag("statue")
	inst:AddTag("rotatableobject")
	
	inst:SetPrefabNameOverride("ancient_statue")
	
	inst._lightframe = net_smallbyte(inst.GUID, "ruins_statue._lightframe", "lightdirty")
    inst._lightradius0 = net_tinybyte(inst.GUID, "ruins_statue._lightradius0", "lightdirty")
    inst._lightradius1 = net_tinybyte(inst.GUID, "ruins_statue._lightradius1", "lightdirty")
    inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
    inst._lightframe:set(inst._lightmaxframe)
    inst._lighttask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)

        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
    inst.components.workable:SetOnWorkCallback(ShowWorkState)
    inst.components.workable:SetOnFinishCallback(OnWorkFinished)
	
	inst.OnEntitySleep = OnEntitySleep
	
	inst:WatchWorldState("nightmarephase", OnNightmarePhaseChanged)
    OnNightmarePhaseChanged(inst, TheWorld.state.nightmarephase, true)

	return inst
end

local function purplefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetRadius(0)
    inst.Light:SetIntensity(.9)
    inst.Light:SetFalloff(.9)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_ruins.png")
	
	MakeObstaclePhysics(inst, 0.66)
	
	inst.AnimState:SetBank("lsr")
	inst.AnimState:SetBuild("legacy_statue_ruins")
	inst.AnimState:PlayAnimation("idle_full", true)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "purplegem")
	
	inst:AddTag("structure")
	inst:AddTag("statue")
	inst:AddTag("rotatableobject")
	
	inst:SetPrefabNameOverride("ancient_statue")
	
	inst._lightframe = net_smallbyte(inst.GUID, "ruins_statue._lightframe", "lightdirty")
    inst._lightradius0 = net_tinybyte(inst.GUID, "ruins_statue._lightradius0", "lightdirty")
    inst._lightradius1 = net_tinybyte(inst.GUID, "ruins_statue._lightradius1", "lightdirty")
    inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
    inst._lightframe:set(inst._lightmaxframe)
    inst._lighttask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)

        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
    inst.components.workable:SetOnWorkCallback(ShowWorkState)
    inst.components.workable:SetOnFinishCallback(OnWorkFinished)
	
	inst.OnEntitySleep = OnEntitySleep
	
	inst:WatchWorldState("nightmarephase", OnNightmarePhaseChanged)
    OnNightmarePhaseChanged(inst, TheWorld.state.nightmarephase, true)

	return inst
end

local function orangefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetRadius(0)
    inst.Light:SetIntensity(.9)
    inst.Light:SetFalloff(.9)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_ruins.png")
	
	MakeObstaclePhysics(inst, 0.66)
	
	inst.AnimState:SetBank("lsr")
	inst.AnimState:SetBuild("legacy_statue_ruins")
	inst.AnimState:PlayAnimation("idle_full", true)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "orangegem")
	
	inst:AddTag("structure")
	inst:AddTag("statue")
	inst:AddTag("rotatableobject")
	
	inst:SetPrefabNameOverride("ancient_statue")
	
	inst._lightframe = net_smallbyte(inst.GUID, "ruins_statue._lightframe", "lightdirty")
    inst._lightradius0 = net_tinybyte(inst.GUID, "ruins_statue._lightradius0", "lightdirty")
    inst._lightradius1 = net_tinybyte(inst.GUID, "ruins_statue._lightradius1", "lightdirty")
    inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
    inst._lightframe:set(inst._lightmaxframe)
    inst._lighttask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)

        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
    inst.components.workable:SetOnWorkCallback(ShowWorkState)
    inst.components.workable:SetOnFinishCallback(OnWorkFinished)
	
	inst.OnEntitySleep = OnEntitySleep
	
	inst:WatchWorldState("nightmarephase", OnNightmarePhaseChanged)
    OnNightmarePhaseChanged(inst, TheWorld.state.nightmarephase, true)

	return inst
end

local function yellowfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetRadius(0)
    inst.Light:SetIntensity(.9)
    inst.Light:SetFalloff(.9)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_ruins.png")
	
	MakeObstaclePhysics(inst, 0.66)
	
	inst.AnimState:SetBank("lsr")
	inst.AnimState:SetBuild("legacy_statue_ruins")
	inst.AnimState:PlayAnimation("idle_full", true)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "yellowgem")
	
	inst:AddTag("structure")
	inst:AddTag("statue")
	inst:AddTag("rotatableobject")
	
	inst:SetPrefabNameOverride("ancient_statue")
	
	inst._lightframe = net_smallbyte(inst.GUID, "ruins_statue._lightframe", "lightdirty")
    inst._lightradius0 = net_tinybyte(inst.GUID, "ruins_statue._lightradius0", "lightdirty")
    inst._lightradius1 = net_tinybyte(inst.GUID, "ruins_statue._lightradius1", "lightdirty")
    inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
    inst._lightframe:set(inst._lightmaxframe)
    inst._lighttask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)

        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
    inst.components.workable:SetOnWorkCallback(ShowWorkState)
    inst.components.workable:SetOnFinishCallback(OnWorkFinished)
	
	inst.OnEntitySleep = OnEntitySleep
	
	inst:WatchWorldState("nightmarephase", OnNightmarePhaseChanged)
    OnNightmarePhaseChanged(inst, TheWorld.state.nightmarephase, true)

	return inst
end

local function greenfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetRadius(0)
    inst.Light:SetIntensity(.9)
    inst.Light:SetFalloff(.9)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_ruins.png")
	
	MakeObstaclePhysics(inst, 0.66)
	
	inst.AnimState:SetBank("lsr")
	inst.AnimState:SetBuild("legacy_statue_ruins")
	inst.AnimState:PlayAnimation("idle_full", true)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "greengem")
	
	inst:AddTag("structure")
	inst:AddTag("statue")
	inst:AddTag("rotatableobject")
	
	inst:SetPrefabNameOverride("ancient_statue")
	
	inst._lightframe = net_smallbyte(inst.GUID, "ruins_statue._lightframe", "lightdirty")
    inst._lightradius0 = net_tinybyte(inst.GUID, "ruins_statue._lightradius0", "lightdirty")
    inst._lightradius1 = net_tinybyte(inst.GUID, "ruins_statue._lightradius1", "lightdirty")
    inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
    inst._lightframe:set(inst._lightmaxframe)
    inst._lighttask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)

        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
    inst.components.workable:SetOnWorkCallback(ShowWorkState)
    inst.components.workable:SetOnFinishCallback(OnWorkFinished)
	
	inst.OnEntitySleep = OnEntitySleep
	
	inst:WatchWorldState("nightmarephase", OnNightmarePhaseChanged)
    OnNightmarePhaseChanged(inst, TheWorld.state.nightmarephase, true)

	return inst
end

local function nogemfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.75, .81, .75)
	
	inst.Light:SetRadius(0)
    inst.Light:SetIntensity(.9)
    inst.Light:SetFalloff(.9)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_ruins.png")
	
	MakeObstaclePhysics(inst, 0.66)
	
	inst.AnimState:SetBank("lsr")
	inst.AnimState:SetBuild("legacy_statue_ruins")
	inst.AnimState:PlayAnimation("idle_full", true)
	inst.AnimState:Hide("gem")
	
	inst:AddTag("structure")
	inst:AddTag("statue")
	inst:AddTag("rotatableobject")
	
	inst:SetPrefabNameOverride("ancient_statue")
	
	inst._lightframe = net_smallbyte(inst.GUID, "ruins_statue._lightframe", "lightdirty")
    inst._lightradius0 = net_tinybyte(inst.GUID, "ruins_statue._lightradius0", "lightdirty")
    inst._lightradius1 = net_tinybyte(inst.GUID, "ruins_statue._lightradius1", "lightdirty")
    inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
    inst._lightframe:set(inst._lightmaxframe)
    inst._lighttask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)

        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
    inst.components.workable:SetOnWorkCallback(ShowWorkState)
    inst.components.workable:SetOnFinishCallback(OnWorkFinished)
	
	inst.OnEntitySleep = OnEntitySleep
	
	inst:WatchWorldState("nightmarephase", OnNightmarePhaseChanged)
    OnNightmarePhaseChanged(inst, TheWorld.state.nightmarephase, true)

	return inst
end

local function bluegemtest(inst)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "bluegem")
end

local function redgemtest(inst)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "redgem")
end

local function purplegemtest(inst)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "purplegem")
end

local function orangegemtest(inst)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "orangegem")
end

local function yellowgemtest(inst)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "yellowgem")
end

local function greengemtest(inst)
	inst.AnimState:OverrideSymbol("swap_gem", "statue_ruins_gem", "greengem")
end

local function nogemtest(inst)
	inst.AnimState:Hide("gem")
	inst.AnimState:SetScale(.75, .81, .75)
end

return Prefab("sap_lsr_bluegem", bluefn, assets, prefabs),
Prefab("sap_lsr_redgem", redfn, assets, prefabs),
Prefab("sap_lsr_purplegem", purplefn, assets, prefabs),
Prefab("sap_lsr_orangegem", orangefn, assets, prefabs),
Prefab("sap_lsr_yellowgem", yellowfn, assets, prefabs),
Prefab("sap_lsr_greengem", greenfn, assets, prefabs),
Prefab("sap_lsr_nogem", nogemfn, assets, prefabs),
MakePlacer("sap_lsr_bluegem_placer", "lsr", "legacy_statue_ruins", "idle_full", false, nil, nil, nil, nil, nil, bluegemtest),
MakePlacer("sap_lsr_redgem_placer", "lsr", "legacy_statue_ruins", "idle_full", false, nil, nil, nil, nil, nil, redgemtest),
MakePlacer("sap_lsr_purplegem_placer", "lsr", "legacy_statue_ruins", "idle_full", false, nil, nil, nil, nil, nil, purplegemtest),
MakePlacer("sap_lsr_orangegem_placer", "lsr", "legacy_statue_ruins", "idle_full", false, nil, nil, nil, nil, nil, orangegemtest),
MakePlacer("sap_lsr_yellowgem_placer", "lsr", "legacy_statue_ruins", "idle_full", false, nil, nil, nil, nil, nil, yellowgemtest),
MakePlacer("sap_lsr_greengem_placer", "lsr", "legacy_statue_ruins", "idle_full", false, nil, nil, nil, nil, nil, greengemtest),
MakePlacer("sap_lsr_nogem_placer", "lsr", "legacy_statue_ruins", "idle_full", false, nil, nil, nil, nil, nil, nogemtest)
