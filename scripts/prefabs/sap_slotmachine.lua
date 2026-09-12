require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/slot_machine.zip"),
}

local prefabs = 
{
	"cutstone",
}

local function TurnOn(inst)
	inst.sg:GoToState("spinning")
	if math.random()<0.1 then
		local stone = SpawnPrefab("cutstone")
		local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0,2,0)
		stone.Transform:SetPosition(pt:Get())
		local down = TheCamera:GetDownVec()
		local angle = math.atan2(down.z, down.x) + (math.random()*60)*DEGREES
		local sp = 3 + math.random()
		stone.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
	end
end

local function TurnOff(inst)
	--inst.sg:GoToState("idle")
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

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("hit")
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle")
end

local function CalcSanityAura(inst, observer)
	return -(TUNING.SANITYAURA_MED*(2))
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_slotmachine.tex")
	
	inst.AnimState:SetBank("slot_machine")
	inst.AnimState:SetBuild("slot_machine")
	inst.AnimState:PlayAnimation("idle")
	
	MakeObstaclePhysics(inst, 0.8, 1.2)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	-- inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 1.0

	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:SetStateGraph("SGslotmachine")

	return inst
end

return Prefab("sap_slotmachine", fn, assets, prefabs),
MakePlacer("sap_slotmachine_placer", "slot_machine", "slot_machine", "idle")  