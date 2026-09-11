require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/lightning_rod.zip"),
    Asset("ANIM", "anim/lightning_rod_fx.zip"),
	Asset("ANIM", "anim/lightning_catcher.zip"),
}

local prefabs =
{
    "lightning_rod_fx",
    "collapse_small",
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onfinished(inst, worker)
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")
    inst:Remove()
end

local function onhit(inst, worker)
	if inst:HasTag("bottle_charged") then
		inst.AnimState:PlayAnimation("idle_full")
		inst.AnimState:PushAnimation("idle_full", true)
	else
		inst.AnimState:PlayAnimation("idle_empty")
		inst.AnimState:PushAnimation("idle_empty", true)
	end
end

local function DoEffect(inst)
	local fx = SpawnPrefab("moose_nest_fx_idle")
	fx.Transform:SetScale(.5, .5, .5)
	local pos = inst:GetPosition()
		fx.Transform:SetPosition(pos.x, 0.1, pos.z)
	if inst.fx_task then
		inst.fx_task:Cancel()
		inst.fx_task = nil
	end
	inst.fx_task = inst:DoTaskInTime(math.random() * 10, DoEffect)
end

local function onbuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/lightning_rod_craft")
end

local function UseAsBattery(inst, user)
    inst.components.finiteuses:Use(1)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState() 
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(2, 2, 2)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_lightningcatcher.tex")
	
	MakeObstaclePhysics(inst, .5)

    inst.Light:Enable(true)
    inst.Light:SetRadius(1.5)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(0/255, 180/255, 255/255)

    inst:AddTag("structure")
	inst:AddTag("lightningcatcher")

    inst.AnimState:SetBank("lightning_catcher")
    inst.AnimState:SetBuild("lightning_catcher")
    inst.AnimState:PlayAnimation("idle_full", true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("battery")
    inst.components.battery.onused = UseAsBattery
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished(onfinished)
	inst.components.finiteuses:SetMaxUses(100)
    inst.components.finiteuses:SetUses(100)

    inst:ListenForEvent("onbuilt", onbuilt)
    MakeHauntableWork(inst)
	
	DoEffect(inst)

    return inst
end

local function catcherplacerfn(inst)
	inst.AnimState:SetScale(2, 2, 2)
end

return Prefab("sap_lightning_catcher", fn, assets, prefabs),
MakePlacer("sap_lightning_catcher_placer", "lightning_catcher", "lightning_catcher", "idle_full", false, nil, nil, nil, nil, nil, catcherplacerfn)