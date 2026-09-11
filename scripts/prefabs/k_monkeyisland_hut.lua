require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/monkeyhut.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
    "powder_monkey",
    "collapse_big",
    "boards",
    "rocks",
	"cave_banana",
}

local loot =
{
    "boards",
    "rocks",
	"cave_banana",
}

local function OnHammered(inst, worker)
	inst:RemoveComponent("childspawner")

    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
	
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
	
    inst:Remove()
end

local function OnHit(inst, worker)
    if not inst:HasTag("burnt") then
        if inst.components.childspawner ~= nil then
            inst.components.childspawner:ReleaseAllChildren(worker)
        end
        inst.AnimState:PlayAnimation("hit")
        if inst._lightson then
            inst.AnimState:PushAnimation("windowlight_idle")
            if inst._window ~= nil then
                inst._window.AnimState:PlayAnimation("glow_hit")
                inst._window.AnimState:PushAnimation("glow")
            end
        else
            inst.AnimState:PushAnimation("idle")
        end
    end
end

local function StartSpawning(inst)
    if not TheWorld.state.iswinter and inst.components.childspawner ~= nil and not inst:HasTag("burnt") then
        inst.components.childspawner:StartSpawning()
    end
end

local function StopSpawning(inst)
    if inst.components.childspawner ~= nil and not inst:HasTag("burnt") then
        inst.components.childspawner:StopSpawning()
    end
end

local function GiveGear(child, gear_prefab)
    local gear = SpawnPrefab(gear_prefab)
    gear:AddTag("personal_possession")
    child.components.inventory:GiveItem(gear)
    child.components.inventory:Equip(gear)
end

local function OnSpawned(inst, child)
    if not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
        if TheWorld.state.isnight and
                child.components.combat.target == nil and
                inst.components.childspawner ~= nil and
                inst.components.childspawner:CountChildrenOutside() >= 1 then
            StopSpawning(inst)
        end
    end

    GiveGear(child, "cutless")
    if math.random() < 0.3 then
        GiveGear(child, "monkey_smallhat")
    end

    local cx, cy, cz = child.Transform:GetWorldPosition()
    local platform_at_spot = TheWorld.Map:GetPlatformAtPoint(cx, cy, cz)
    if platform_at_spot == nil and not child:IsOnValidGround() then
        SpawnPrefab("splash_sink").Transform:SetPosition(cx, cy, cz)

        child:Remove()
    end
end

local function OnGoHome(inst, child)
    if not inst:HasTag("burnt") then

        if TheWorld.components.piratespawner then
            TheWorld.components.piratespawner:StashLoot(child)
        end

        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")

        if inst.components.childspawner ~= nil and
            inst.components.childspawner:CountChildrenOutside() < 1 then
            StartSpawning(inst)
        end
    end
end

local function OnSave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function OnIgnite(inst)
    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren()
    end
end

local function OnBurnt(inst)
    inst.AnimState:PlayAnimation("burnt")

    inst:RemoveTag("shelter")

    if inst._window ~= nil then
        inst._window:Remove()
        inst._window = nil
    end
end

local function LightsOff(inst)
    if not inst:HasTag("burnt") and inst._lightson then
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("idle", true)
        inst.AnimState:SetLightOverride(0)
        inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lightoff")

        inst._lightson = false
        if inst._window ~= nil then
            inst._window:Hide()
        end
    end
end

local function LightsOn(inst)
    if not inst:HasTag("burnt") and not inst._lightson then
        inst.Light:Enable(true)
        inst.AnimState:PlayAnimation("windowlight_idle", true)
        inst.AnimState:SetLightOverride(0.2)
        inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lighton")

        inst._lightson = true
        if inst._window ~= nil then
            inst._window:Show()
        end
    end
end

local function GetStatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
	or nil
end

local function OnIsNight(inst, isnight)
    if isnight then
        StopSpawning(inst)

        inst:DoTaskInTime(2*math.random() + 1, LightsOn)
    else
        if not inst:HasTag("burnt") then
            StartSpawning(inst)

            inst:DoTaskInTime(2*math.random() + 1, LightsOff)
        end
    end
end

local HAUNT_TARGET_MUST_TAGS = { "character" }
local HAUNT_TARGET_CANT_TAGS = { "powder_monkey", "playerghost", "INLIMBO" }
local function OnHaunt(inst)
    if inst.components.childspawner == nil or
        not inst.components.childspawner:CanSpawn() or
        math.random() > TUNING.HAUNT_CHANCE_HALF then
        return false
    end

    local target = FindEntity(inst, 25, nil, HAUNT_TARGET_MUST_TAGS, HAUNT_TARGET_CANT_TAGS)
    if target == nil then
        return false
    end

    onhit(inst, target)
    return true
end

local function MakeWindow()
    local inst = CreateEntity("MonkeyHut.MakeWindow")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:SetBank("monkeyhut")
    inst.AnimState:SetBuild("monkeyhut")
    inst.AnimState:PlayAnimation("glow")
    inst.AnimState:SetLightOverride(0.6)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetFinalOffset(1)

    inst:Hide()

    return inst
end

local function OnUpdateWindow(window, hut)
    if hut:HasTag("burnt") then
        hut._window = nil
        window:Remove()
    elseif hut.Light:IsEnabled() and hut.AnimState:IsCurrentAnimation("windowlight_idle") then
        if not window._shown then
            window._shown = true
            window:Show()
        end
    elseif window._shown then
        window._shown = false
        window:Hide()
    end
end

local function GoHomeValidate(inst)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        return false
    end
    if inst:HasTag("burnt") then
        return false
    end
    return true
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("monkeyhut.png")

    MakeObstaclePhysics(inst, 0.25)

    inst.AnimState:SetBank("monkeyhut")
    inst.AnimState:SetBuild("monkeyhut")
    inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("shelter")
    inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("monkeyhut")
	
	MakeSnowCoveredPristine(inst)

    if not TheNet:IsDedicated() then
        inst._window = MakeWindow()
        inst._window.entity:SetParent(inst.entity)
        if not TheWorld.ismastersim then
            inst._window:DoPeriodicTask(FRAMES, OnUpdateWindow, nil, inst)
        end
    end

    inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "powder_monkey"
    inst.components.childspawner:SetSpawnedFn(OnSpawned)
    inst.components.childspawner.gohomevalidatefn = GoHomeValidate
    inst.components.childspawner:SetGoHomeFn(OnGoHome)
    inst.components.childspawner:SetRegenPeriod(TUNING.MONKEYHUT_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.MONKEYHUT_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(TUNING.MONKEYHUT_MONKEYS)
    inst.components.childspawner:SetMaxEmergencyChildren(TUNING.MONKEYHUT_EMERGENCY_MONKEYS)
    inst.components.childspawner:SetEmergencyRadius(TUNING.MONKEYHUT_EMERGENCY_RADIUS)
    inst.components.childspawner.canemergencyspawn = TUNING.MONKEYHUT_ENABLED
    inst.components.childspawner.emergencychildname = "powder_monkey"

    inst:WatchWorldState("isnight", OnIsNight)

    StartSpawning(inst)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)
	
    inst:ListenForEvent("onignite", OnIgnite)
    inst:ListenForEvent("burntup", OnBurnt)

    MakeSnowCovered(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function fn_empty()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("monkeyhut.png")

    MakeObstaclePhysics(inst, 0.25)

    inst.AnimState:SetBank("monkeyhut")
    inst.AnimState:SetBuild("monkeyhut")
    inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("shelter")
    inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("monkeyhut")
	
	MakeSnowCoveredPristine(inst)

    if not TheNet:IsDedicated() then
        inst._window = MakeWindow()
        inst._window.entity:SetParent(inst.entity)
        if not TheWorld.ismastersim then
            inst._window:DoPeriodicTask(FRAMES, OnUpdateWindow, nil, inst)
        end
    end

    inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = GetStatus

    inst:WatchWorldState("isnight", OnIsNight)

    MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)
	
    inst:ListenForEvent("onignite", OnIgnite)
    inst:ListenForEvent("burntup", OnBurnt)

    MakeSnowCovered(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("sap_monkeyisland_hut", fn, assets, prefabs),
Prefab("sap_monkeyisland_hut_empty", fn_empty, assets, prefabs),
MakePlacer("sap_monkeyisland_hut_placer", "monkeyhut", "monkeyhut", "idle"),
MakePlacer("sap_monkeyisland_hut_empty_placer", "monkeyhut", "monkeyhut", "idle")