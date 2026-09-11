local assets =
{
    Asset("ANIM", "anim/chandelier_archives.zip"),
	Asset("ANIM", "anim/kyno_chandelier_archives.zip"),
    Asset("ANIM", "anim/chandelier_fire.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs = 
{
    "chandelier_fire",
    "chandelier_sfx",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("ground_idle", true)
end

local function onhit_chandelier(inst, worker)
	inst.AnimState:PlayAnimation("idle")
end

local function OnEntityWake(inst)
    inst.SoundEmitter:PlaySound("dontstarve/AMB/caves/forest_spot", "loop")
end

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("loop")
end

local ON = 1
local OFF = 2

local light_params =
{
    on =
    {
        radius = 5,
        intensity = .6,
        falloff = .6,
        colour = { 131/255, 194/255, 255/255 },
        time = 3,
    },

    off =
    {
        radius = 0,
        intensity = 0,
        falloff = 1,
        colour = { 0, 0, 0 },
        time = 3,
    },
}

local FLAMEDATA = {
    "flame1",
    "flame2",
    "flame3",
    "flame4",
}

local light_phases = {}
for k, v in pairs(light_params) do
    table.insert(light_phases, k)
    v.id = #light_phases
    v.tint = { v.colour[1] * .5, v.colour[2] * .5, v.colour[3] * .5, 0 }
end

local function firesound(inst, setting)
    if inst.sfxprop then
        if setting > 0 then
            if not inst.sfxprop.SoundEmitter:PlayingSound("firesfx") then
                inst.sfxprop.SoundEmitter:PlaySound("grotto/common/chandelier_LP", "firesfx")
            end
            inst.sfxprop.SoundEmitter:SetParameter("firesfx", "intensity", setting)
        else
            inst.sfxprop.SoundEmitter:KillSound("firesfx")
        end
    end
end

local function pushparams(inst, params)
    inst.Light:SetRadius(params.radius * inst.widthscale)
    inst.Light:SetIntensity(params.intensity)
    inst.Light:SetFalloff(params.falloff)
    inst.Light:SetColour(unpack(params.colour))

    if TheWorld.ismastersim then
        if params.intensity > 0 then
            inst.Light:Enable(true)
        else
            inst.Light:Enable(false)
        end
        firesound(inst, params.intensity)
    end
end

local function copyparams(dest, src)
    for k, v in pairs(src) do
        if type(v) == "table" then
            dest[k] = dest[k] or {}
            copyparams(dest[k], v)
        else
            dest[k] = v
        end
    end
end

local function lerpparams(pout, pstart, pend, lerpk)
    for k, v in pairs(pend) do
        if type(v) == "table" then
            lerpparams(pout[k], pstart[k], v, lerpk)
        else
            pout[k] = pstart[k] * (1 - lerpk) + v * lerpk
        end
    end
end

local function OnUpdateLight(inst, dt)
    inst._currentlight.time = inst._currentlight.time + dt
    if inst._currentlight.time >= inst._endlight.time then
        inst._currentlight.time = inst._endlight.time
        inst._lighttask:Cancel()
        inst._lighttask = nil
    end

    lerpparams(inst._currentlight, inst._startlight, inst._endlight, inst._endlight.time > 0 and inst._currentlight.time / inst._endlight.time or 1)
    pushparams(inst, inst._currentlight)
    inst.AnimState:SetLightOverride(Remap(inst._currentlight.intensity, light_params.off.intensity,light_params.on.intensity, 0,1))
    for k, v in pairs(FLAMEDATA) do
        if inst[v] then
            local val = Remap(inst._currentlight.intensity, light_params.off.intensity,light_params.on.intensity, 0,1)
            inst[v].AnimState:SetLightOverride(val)
            inst[v].Transform:SetScale(val,val,val)
            if inst._currentlight.intensity == 0 and val == 0 then
                inst[v]:Remove()
                inst[v] = nil
            end
        else
            if inst._currentlight.intensity > 0 then
                local fx = SpawnPrefab("chandelier_fire")
                inst:AddChild(fx)
                fx.entity:AddFollower()
                fx.Follower:FollowSymbol(inst.GUID, v,0,0,0)
                inst[v] = fx
                fx.Transform:SetScale(0,0,0)
            end
        end
    end
end

local function OnLightPhaseDirty(inst)
    local phase = light_phases[inst._lightphase:value()]
    if phase ~= nil then
        local params = light_params[phase]
        if params ~= nil and params ~= inst._endlight then
            copyparams(inst._startlight, inst._currentlight)
            inst._currentlight.time = 0
            inst._startlight.time = 0
            inst._endlight = params
            if inst._lighttask == nil then
                inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, FRAMES)
            end
        end
    end
end

local function OnSpawnTask(inst, cavephase)
    inst._spawntask = nil
    if cavephase == "day" then
        inst.components.hideout:StartSpawning()
    else
        inst.components.hideout:StopSpawning()
    end
end

local function updatelight(inst)
    if inst:HasTag("chandelier_ison") then
        if inst._lightphase:value() ~= ON then
            inst._lightphase:set(ON)
            OnLightPhaseDirty(inst)
        end
    else
        if inst._lightphase:value() ~= OFF then
            inst._lightphase:set(OFF)
            OnLightPhaseDirty(inst)
        end
    end
end

local function OnInit(inst)
    if TheWorld.ismastersim then
        local params = light_params["off"]
        if params ~= nil then
            inst._lightphase:set(params.id)
        end
    else
        inst:ListenForEvent("lightphasedirty", OnLightPhaseDirty)
    end

    local phase = light_phases[inst._lightphase:value()]
    if phase ~= nil then
        local params = light_params[phase]
        if params ~= nil and params ~= inst._endlight then
            copyparams(inst._currentlight, params)
            inst._endlight = params
            if inst._lighttask ~= nil then
                inst._lighttask:Cancel()
                inst._lighttask = nil
            end
            pushparams(inst, inst._currentlight)
        end
    end

    inst.sfxprop = SpawnPrefab("chandelier_sfx")
    local x,y,z = inst.Transform:GetWorldPosition()
    inst.sfxprop.Transform:SetPosition(x,8,z)
end

local function TurnOn(inst)
	inst:AddTag("chandelier_ison")
	inst:DoTaskInTime(1, function() updatelight(inst) end)
	inst.on = true
end

local function TurnOff(inst)
	inst:RemoveTag("chandelier_ison")
	inst:DoTaskInTime(1, function() updatelight(inst) end)
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()    
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("chandelier_archives")
    inst.AnimState:SetBuild("chandelier_archives")
    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst.AnimState:SetTime(math.random() * 2)
	inst.Light:EnableClientModulation(true)
    
    inst:AddTag("structure")
	inst:AddTag("NOBLOCK")
	
	inst.widthscale = 1
    inst._endlight = light_params.off
    inst._startlight = {}
    inst._currentlight = {}
    copyparams(inst._startlight, inst._endlight)
    copyparams(inst._currentlight, inst._endlight)
    pushparams(inst, inst._currentlight)

    inst._lightphase = net_tinybyte(inst.GUID, "archive_chandelier._lightphase", "lightphasedirty")
    inst._lightphase:set(inst._currentlight.id)
    inst._lighttask = nil

    inst:DoTaskInTime(0, OnInit)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_chandelier)
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake
	
	inst.OnSave = OnSave 
    inst.OnLoad = OnLoad

    return inst
end

local function groundfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("kyno_chandelier_archives")
    inst.AnimState:SetBuild("kyno_chandelier_archives")
    inst.AnimState:PlayAnimation("ground_idle")
    
	inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_ARCHIVE_CHANDELIER"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_archive_chandelier", fn, assets, prefabs),
Prefab("sap_archive_chandelier_ground", groundfn, assets, prefabs),
MakePlacer("sap_archive_chandelier_placer", "chandelier_archives", "chandelier_archives", "idle"),
MakePlacer("sap_archive_chandelier_ground_placer", "chandelier_archives", "chandelier_archives", "ground_idle")