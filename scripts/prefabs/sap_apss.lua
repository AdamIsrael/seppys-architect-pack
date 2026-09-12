require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/crafting_table.zip"),
}

local prefabs =
{
	"sap_ancient_altar_broken",
    "thulecite",
    "collapse_small",
    "collapse_big",
}

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

    if inst._islighton:value() then
        inst.Light:SetRadius(3 * k)
    else
        inst.Light:SetRadius(3 * (1 - k))
    end

    if TheWorld.ismastersim then
        inst.Light:Enable(inst._islighton:value() or frame < inst._lightmaxframe)
        if not inst._islighton:value() then
            inst.SoundEmitter:KillSound("idlesound")
        end
    end
end

local function OnLightDirty(inst)
    if inst._lighttask == nil then
        inst._lighttask = inst:DoPeriodicTask(FRAMES, OnUpdateLight, nil, 1)
    end
    inst._lightmaxframe = inst._islighton:value() and MAX_LIGHT_ON_FRAME or MAX_LIGHT_OFF_FRAME
    OnUpdateLight(inst, 0)
end

local function common_fn(anim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("tab_crafting_table.png")
	minimap:SetPriority(5)
	
    MakeObstaclePhysics(inst, 0.8, 1.2)

    inst.AnimState:SetBank("crafting_table")
    inst.AnimState:SetBuild("crafting_table")
    inst.AnimState:PlayAnimation(anim)

    inst.Light:Enable(false)
    inst.Light:SetRadius(0)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(1, 1, 1)
    inst.Light:EnableClientModulation(true)

    inst:AddTag("altar")
    inst:AddTag("structure")
    inst:AddTag("stone")
    inst:AddTag("prototyper")

    inst:SetPrefabNameOverride("ancient_altar")

    inst._lightframe = net_smallbyte(inst.GUID, "ancient_altar._lightframe", "lightdirty")
    inst._islighton = net_bool(inst.GUID, "ancient_altar._islighton", "lightdirty")
    inst._lightmaxframe = MAX_LIGHT_OFF_FRAME
    inst._lightframe:set(inst._lightmaxframe)
    inst._lighttask = nil

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("lightdirty", OnLightDirty)
        return inst
    end

    inst._activecount = 0

    inst:AddComponent("inspectable")
    inst:AddComponent("prototyper")
    inst:AddComponent("workable")

    MakeHauntableWork(inst)

    return inst
end

local function complete_onturnon(inst)
    if inst.AnimState:IsCurrentAnimation("proximity_loop") then
        inst.AnimState:PushAnimation("proximity_loop", true)
    else
        inst.AnimState:PlayAnimation("proximity_loop", true)
    end
    if not inst.SoundEmitter:PlayingSound("idlesound") then
        inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_LP", "idlesound")
    end
    if not inst._islighton:value() then
        inst._islighton:set(true)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_OFF_FRAME) * MAX_LIGHT_ON_FRAME + .5))
        OnLightDirty(inst)
    end
end

local function complete_onturnoff(inst)
    inst.AnimState:PushAnimation("idle_full")
    if inst._islighton:value() then
        inst._islighton:set(false)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_ON_FRAME) * MAX_LIGHT_OFF_FRAME + .5))
        OnLightDirty(inst)
    end
end

local function complete_doonact(inst)
    if inst._activecount > 1 then
        inst._activecount = inst._activecount - 1
    else
        inst._activecount = 0
        inst.SoundEmitter:KillSound("sound")
    end
    inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl3_ding")
end

local function complete_onactivate(inst)
    inst.AnimState:PlayAnimation("use")
    inst.AnimState:PushAnimation("proximity_loop", true)
    inst._activecount = inst._activecount + 1

    if not inst.SoundEmitter:PlayingSound("sound") then
        inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_craft", "sound")
    end
    inst:DoTaskInTime(1.5, complete_doonact)
end

local function complete_onhammered(inst, worker)
    local pos = inst:GetPosition()
    local broken = SpawnPrefab("sap_ancient_altar_broken")
    broken.Transform:SetPosition(pos:Get())
    broken.components.workable:SetWorkLeft(TUNING.ANCIENT_ALTAR_BROKEN_WORK)
    SpawnPrefab("collapse_small").Transform:SetPosition(pos:Get())
    inst:PushEvent("onprefabswaped", {newobj = broken})
    inst:Remove()
end

local function complete_fn()
    local inst = common_fn("idle_full")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ANCIENTALTAR_HIGH
    inst.components.prototyper.onturnon = complete_onturnon
    inst.components.prototyper.onturnoff = complete_onturnoff
    inst.components.prototyper.onactivate = complete_onactivate

    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(TUNING.ANCIENT_ALTAR_COMPLETE_WORK)
    inst.components.workable:SetMaxWork(TUNING.ANCIENT_ALTAR_COMPLETE_WORK)
    inst.components.workable:SetOnFinishCallback(complete_onhammered)

    return inst
end

local function broken_onturnon(inst)
    if not inst.SoundEmitter:PlayingSound("idlesound") then
        inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_LP", "idlesound")
    end
    if not inst._islighton:value() then
        inst._islighton:set(true)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_OFF_FRAME) * MAX_LIGHT_ON_FRAME + .5))
        OnLightDirty(inst)
    end
end

local function broken_onturnoff(inst)
    if inst._islighton:value() then
        inst._islighton:set(false)
        inst._lightframe:set(math.floor((1 - inst._lightframe:value() / MAX_LIGHT_ON_FRAME) * MAX_LIGHT_OFF_FRAME + .5))
        OnLightDirty(inst)
    end
end

local function broken_doonact(inst)
    if inst._activecount > 1 then
        inst._activecount = inst._activecount - 1
    else
        inst._activecount = 0
        inst.SoundEmitter:KillSound("sound")
    end

    inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl3_ding")
    SpawnPrefab("sanity_lower").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function broken_onactivate(inst)
    inst.AnimState:PlayAnimation("hit_broken")
    inst.AnimState:PushAnimation("idle_broken")
    inst._activecount = inst._activecount + 1

    if not inst.SoundEmitter:PlayingSound("sound") then
        inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_craft", "sound")
    end
    inst:DoTaskInTime(1.5, broken_doonact)
end

local function broken_onrepaired(inst, doer, repair_item)
    if inst.components.workable.workleft < inst.components.workable.maxwork then
        inst.AnimState:PlayAnimation("hit_broken")
        inst.SoundEmitter:PlaySound("dontstarve/common/ancienttable_repair")
    else
        local pos = inst:GetPosition()
        local altar = SpawnPrefab("sap_ancient_altar")
        altar.Transform:SetPosition(pos:Get())
        altar.SoundEmitter:PlaySound("dontstarve/common/ancienttable_activate")
        SpawnPrefab("collapse_big").Transform:SetPosition(pos:Get())
        inst:PushEvent("onprefabswaped", {newobj = altar})
        inst:Remove()
    end
end

local function broken_onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local pos = inst:GetPosition()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(pos:Get())
    fx:SetMaterial("stone")
    inst:Remove()
end

local function broken_onworked(inst, worker, workleft)
    inst.AnimState:PlayAnimation("hit_broken")
    local pos = inst:GetPosition()
end

local function broken_fn()
    local inst = common_fn("idle_broken")

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("repairable")
    inst.components.repairable.repairmaterial = MATERIALS.THULECITE
    inst.components.repairable.onrepaired = broken_onrepaired

    inst:AddComponent("lootdropper")
    -- inst.components.lootdropper:SetChanceLootTable("ancient_altar")

	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ANCIENTALTAR_LOW
    inst.components.prototyper.onturnon = broken_onturnon
    inst.components.prototyper.onturnoff = broken_onturnoff
    inst.components.prototyper.onactivate = broken_onactivate

    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetMaxWork(TUNING.ANCIENT_ALTAR_BROKEN_WORK+1) -- the last point repairs it to a full altar
    inst.components.workable:SetOnFinishCallback(broken_onhammered)
    inst.components.workable:SetOnWorkCallback(broken_onworked)
    inst.components.workable.savestate = true

    return inst
end

return Prefab("sap_ancient_altar", complete_fn, assets, prefabs),
Prefab("sap_ancient_altar_broken", broken_fn, assets, prefabs),
MakePlacer("sap_ancient_altar_broken_placer", "crafting_table", "crafting_table", "idle_broken")