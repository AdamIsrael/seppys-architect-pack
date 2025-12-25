require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/kyno_frozenfurnace.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "collapse_big",
}

local function getstatus(inst)
    return "HIGH"
end

local function onworkfinished(inst)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onworked(inst)
    if inst._task2 ~= nil then
        inst._task2:Cancel()
        inst._task2 = nil

        inst.SoundEmitter:PlaySound("dontstarve/common/together/dragonfly_furnace/fire_LP", "loop")

        if inst._task1 ~= nil then
            inst._task1:Cancel()
            inst._task1 = nil
        end
    end
    inst.AnimState:PlayAnimation("hi_hit")
    inst.AnimState:PushAnimation("hi")
end

local function BuiltTimeLine1(inst)
    inst._task1 = nil
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local function BuiltTimeLine2(inst)
    inst._task2 = nil
    inst.SoundEmitter:PlaySound("dontstarve/common/together/dragonfly_furnace/light")
    inst.SoundEmitter:PlaySound("dontstarve/common/together/dragonfly_furnace/fire_LP", "loop")
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("hi_pre", false)
    inst.AnimState:PushAnimation("hi")
    inst.SoundEmitter:KillSound("loop")
    inst.SoundEmitter:PlaySound("dontstarve/common/together/dragonfly_furnace/place")
    if inst._task2 ~= nil then
        inst._task2:Cancel()
        if inst._task1 ~= nil then
            inst._task1:Cancel()
        end
    end
    inst._task1 = inst:DoTaskInTime(30 * FRAMES, BuiltTimeLine1)
    inst._task2 = inst:DoTaskInTime(40 * FRAMES, BuiltTimeLine2)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:Enable(true)
    inst.Light:SetRadius(1.0)
    inst.Light:SetFalloff(.9)
    inst.Light:SetIntensity(0.5)
    inst.Light:SetColour(0/255, 180/255, 255/255)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("dragonfly_furnace.png")
	
	MakeObstaclePhysics(inst, .5)

    inst.AnimState:SetBank("kyno_frozenfurnace")
    inst.AnimState:SetBuild("kyno_frozenfurnace")
    inst.AnimState:PlayAnimation("hi", true)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(0.4)

    inst:AddTag("structure")
    inst:AddTag("wildfireprotected")
    inst:AddTag("HASHEATER")

    inst.SoundEmitter:PlaySound("dontstarve/common/together/dragonfly_furnace/fire_LP", "loop")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("heater")
    inst.components.heater.heat = -115
	inst.components.heater:SetThermics(false, true)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(6)
    inst.components.workable:SetOnFinishCallback(onworkfinished)
    inst.components.workable:SetOnWorkCallback(onworked)
	
    MakeHauntableWork(inst)
    inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("kyno_frozenfurnace", fn, assets, prefabs),
MakePlacer("kyno_frozenfurnace_placer", "kyno_frozenfurnace", "kyno_frozenfurnace", "idle")