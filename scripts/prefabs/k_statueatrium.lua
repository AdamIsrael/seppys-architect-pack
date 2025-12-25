local assets =
{
    Asset("ANIM", "anim/atrium_statue.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "collapse_small",
    "thulecite",
    "thulecite_pieces",
    "statue_transition",
    "statue_transition_2",
}

SetSharedLootTable("atrium_statue_loot",
{
    {"thulecite",        1.00},
    {"thulecite",        0.25},
    {"thulecite_pieces", 1.00},
    {"thulecite_pieces", 1.00},
    {"thulecite_pieces", 0.50},
    {"thulecite_pieces", 0.50},
})

local function OnWorked(inst, worker, workleft)
    inst.AnimState:PlayAnimation(
        (   (workleft < TUNING.MARBLEPILLAR_MINE / 3 and ("idle_low")) or
            (workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and ("idle_med")) or
            ("idle_full")
        ),
        true)
end

local function OnWorkFinished(inst)
    inst.components.lootdropper:DropLoot()

    local fx = SpawnAt("collapse_small", inst)
    fx:SetMaterial("rock")

    SpawnAt(math.random() < .5 and "nightmarebeak" or "crawlingnightmare", inst)

    inst:Remove()
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

local function ShowPhaseState(inst, phase, instant)
    inst._phasetask = nil

    if (inst._suffix == "_night") ~= (phase == "wild") then
        inst._suffix = (phase == "wild") and "_night" or ""
        if not instant then
            DoFx(inst)
        end
    end

    OnWorked(inst, nil, inst.components.workable ~= nil and inst.components.workable.workleft or TUNING.MARBLEPILLAR_MINE)
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
    if inst._phasetask ~= nil then
        inst._phasetask:Cancel()
        ShowPhaseState(inst, TheWorld.state.nightmarephase, true)
    end
end

local function MakeStatue(name, rotate)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
		
		local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon("atrium_statue.png")

        MakeObstaclePhysics(inst, .45)

        inst.AnimState:SetBank("atrium_statue")
        inst.AnimState:SetBuild("atrium_statue")
        inst.AnimState:PlayAnimation("idle_full")

        if rotate then
            inst.Transform:SetTwoFaced()
        end
		
        if name ~= "statueatrium" then
            inst:SetPrefabNameOverride("atrium_statue")
        end
		
		inst:AddTag("rotatableobject")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
		inst:AddComponent("lootdropper")

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
        inst.components.workable:SetOnWorkCallback(OnWorked)
        inst.components.workable:SetOnFinishCallback(OnWorkFinished)

        if rotate then
            inst:AddComponent("savedrotation")
        end

        inst:WatchWorldState("nightmarephase", OnNightmarePhaseChanged)
        OnNightmarePhaseChanged(inst, TheWorld.state.nightmarephase, true)
		
		inst.OnEntitySleep = OnEntitySleep
        inst._suffix = ""

        return inst
    end

    return Prefab(name, fn, assets)
end

return MakeStatue("kyno_statueatrium", true),
MakePlacer("kyno_statueatrium_placer", "atrium_statue", "atrium_statue", "idle_full", false, nil, nil, nil, 90, nil)