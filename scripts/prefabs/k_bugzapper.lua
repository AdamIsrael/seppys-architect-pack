require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/bugzapper.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function DoEffect(inst)
	local fx = SpawnPrefab("moose_nest_fx_idle")
	fx.Transform:SetScale(.5, .5, .5)
	local pos = inst:GetPosition()
	fx.Transform:SetPosition(pos.x, 0.1, pos.z)
end

local function TurnOn(inst)
	inst.AnimState:PushAnimation("idle_on", true)
	inst:DoTaskInTime(10+math.random()*5, function() DoEffect(inst) end)
end

local function TurnOff(inst)
	inst.AnimState:PushAnimation("idle_off")
end

local function CanInteract(inst)
	if inst.components.machine.ison then
		return false
	end
	return true
end

local function GetStatus(inst, viewer)
	if inst.on then
		return "ON"
	else
		return "OFF"
	end
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle_off")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(2, 2, 2)
	
    MakeObstaclePhysics(inst, .5)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_bugzapper.tex")
	
    inst.AnimState:SetBank("bugzapper")
    inst.AnimState:SetBuild("bugzapper")
    inst.AnimState:PlayAnimation("idle_off")
    
	inst:AddTag("structure")
	inst:AddTag("zapper")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function zapperplacer(inst)
	inst.AnimState:SetScale(2, 2, 2)
end

return Prefab("sap_bugzapper", fn, assets),
MakePlacer("sap_bugzapper_placer", "bugzapper", "bugzapper", "idle_off", false, nil, nil, nil, nil, nil, zapperplacer)