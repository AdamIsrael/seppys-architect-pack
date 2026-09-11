require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_driftwood_winterometer.zip"),
}

local prefabs =
{
    "collapse_small",
}

local function DoCheckTemp(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:SetPercent("meter", 1 - math.clamp(TheWorld.state.temperature, 0, TUNING.OVERHEAT_TEMP) / TUNING.OVERHEAT_TEMP)
    end
end

local function StartCheckTemp(inst)
    if inst.task == nil and not inst:HasTag("burnt") then
        inst.task = inst:DoPeriodicTask(1, DoCheckTemp, 0)
    end
end

local function OnHammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
	
    inst.components.lootdropper:DropLoot()
	
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function OnHit(inst)
    if not inst:HasTag("burnt") then
        if inst.task ~= nil then
            inst.task:Cancel()
            inst.task = nil
        end
        inst.AnimState:PlayAnimation("hit")
    end
end

local function OnBuilt(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    inst.AnimState:PlayAnimation("place")
    inst.SoundEmitter:PlaySound("dontstarve/common/winter_meter_craft")
end

local function MakeBurnt(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_driftwood_winterometer.tex")

    MakeObstaclePhysics(inst, .4)

    inst.AnimState:SetBank("winter_meter")
    inst.AnimState:SetBuild("kyno_driftwood_winterometer")
    inst.AnimState:SetPercent("meter", 0)

    inst:AddTag("structure")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "WINTEROMETER"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(4)

    inst:ListenForEvent("onbuilt", OnBuilt)
    inst:ListenForEvent("animover", StartCheckTemp)
	inst:ListenForEvent("burntup", MakeBurnt)
	
	StartCheckTemp(inst)

	MakeSnowCovered(inst)
    MakeSmallBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)
	MakeHauntableWork(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("sap_driftwood_winterometer", fn, assets, prefabs),
MakePlacer("sap_driftwood_winterometer_placer", "winter_meter", "sap_driftwood_winterometer", "idle")