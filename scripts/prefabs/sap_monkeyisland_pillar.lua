require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/pillar_monkey.zip"),
}

local set_moveanim_trigger = nil

local function queue_moveanim_task(inst)
    inst._moveanim_task = inst:DoTaskInTime(15 + 10 * math.random(), set_moveanim_trigger)
end

set_moveanim_trigger = function(inst)
    inst._moveanim_trigger = true
    queue_moveanim_task(inst)
end

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function OnAnimOver(inst)
    local idlename = "idle"..inst.pillar_id

    if inst._moveanim_trigger then
        inst.AnimState:PlayAnimation(idlename.."_move")
        inst._moveanim_trigger = false
    else
        inst.AnimState:PlayAnimation(idlename)
    end
end

local function SetPillarType(inst, index)
    if inst.pillar_id == nil or (index ~= nil and inst.pillar_id ~= index) then
        inst.pillar_id = index or tostring(math.random(1, 4))
        inst.AnimState:PlayAnimation("idle"..inst.pillar_id)
        inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
    end
end

local function OnSave(inst, data)
    data.pillar_id = inst.pillar_id
end

local function OnLoad(inst, data)
    SetPillarType(inst, (data ~= nil and data.pillar_id) or nil)
end

local function OnEntitySleep(inst)
    if inst._moveanim_task ~= nil then
        inst._moveanim_task:Cancel()
        inst._moveanim_task = nil
    end
end

local function OnEntityWake(inst)
    if inst._moveanim_task == nil then
        queue_moveanim_task(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetIntensity(0.6)
    inst.Light:SetRadius(2.5)
    inst.Light:SetFalloff(0.8)
    inst.Light:SetColour(125/255, 125/255, 125/255)
    inst.Light:Enable(true)

    MakeObstaclePhysics(inst, 0.6, 24)

    inst.AnimState:SetBank ("pillar_monkey")
    inst.AnimState:SetBuild("pillar_monkey")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(0.25)
	
	MakeSnowCoveredPristine(inst)
	
	inst:SetPrefabNameOverride("monkeypillar")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst._moveanim_trigger = false
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MONKEYPILLAR"

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    if not POPULATING then
		SetPillarType(inst)
    end
    
	queue_moveanim_task(inst)
	
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake
	
	inst:ListenForEvent("animover", OnAnimOver)
	MakeSnowCovered(inst)

    return inst
end

return Prefab("sap_monkeyisland_pillar", fn, assets),
MakePlacer("sap_monkeyisland_pillar_placer", "pillar_monkey", "pillar_monkey", "idle1")