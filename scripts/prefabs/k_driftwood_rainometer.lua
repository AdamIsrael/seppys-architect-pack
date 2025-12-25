require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_driftwood_rainometer.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "collapse_small",
}

local function DoCheckRain(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:SetPercent("meter", TheWorld.state.pop)
    end
end

local function StartCheckRain(inst)
    if inst.task == nil and not inst:HasTag("burnt") then
        inst.task = inst:DoPeriodicTask(1, DoCheckRain, 0)
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
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    inst.AnimState:PlayAnimation("hit")
end

local function OnBuilt(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
    inst.AnimState:PlayAnimation("place")
    inst.SoundEmitter:PlaySound("dontstarve/common/rain_meter_craft")
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
	minimap:SetIcon("kyno_driftwood_rainometer.tex")

    MakeObstaclePhysics(inst, .4)

    inst.AnimState:SetBank("rain_meter")
    inst.AnimState:SetBuild("kyno_driftwood_rainometer")
    inst.AnimState:SetPercent("meter", 0)
	
	inst:AddTag("structure")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "RAINOMETER"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(4)

    inst:ListenForEvent("onbuilt", OnBuilt)
    inst:ListenForEvent("animover", StartCheckRain)
	inst:ListenForEvent("burntup", MakeBurnt)

    StartCheckRain(inst)
	
	MakeSnowCovered(inst)
    MakeMediumBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)
	MakeHauntableWork(inst)

	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("kyno_driftwood_rainometer", fn, assets, prefabs),
MakePlacer("kyno_driftwood_rainometer_placer", "rain_meter", "kyno_driftwood_rainometer", "idle")