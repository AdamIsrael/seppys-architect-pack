require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/shadow_portal.zip"),
	
	Asset("SOUNDPACKAGE", "sound/shadwell_sfx.fev"),
	Asset("SOUND", "sound/shadwell_sfx.fsb"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle_off")
end

local function TurnOn(inst)
	inst.AnimState:PlayAnimation("activate")
	inst.AnimState:PushAnimation("idle_loop_on", true)
	inst.SoundEmitter:PlaySound("shadwell_sfx/examples/portal", "portal_loop")
end

local function TurnOff(inst)
	inst.AnimState:PlayAnimation("idle_off", true)
    inst.SoundEmitter:KillSound("portal_loop")
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

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("shadow_portal")
    inst.AnimState:SetBuild("shadow_portal")
    inst.AnimState:PlayAnimation("idle_off")
	inst.on = false
    
	inst:AddTag("structure")
	inst:AddTag("portal_shadow")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Shadow Portal" }
    inst.components.named:PickNewName()
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_shadowportal", fn, assets),
MakePlacer("sap_shadowportal_placer", "shadow_portal", "shadow_portal", "idle_off")