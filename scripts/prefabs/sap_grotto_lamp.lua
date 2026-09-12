require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_grottolamp.zip"),
}

local prefabs =
{
	"collapse_small"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    local rotation = inst.Transform:GetRotation()
    inst.Transform:SetRotation((rotation + 180) % 360)
end

local function TurnOn(inst)
	inst.Light:Enable(true)
	inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
	inst.on = true
end

local function TurnOff(inst)
	inst.Light:Enable(false)
	inst.AnimState:PushAnimation("idle_off", true)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_off")
	inst.on = false
end

local function GetStatus(inst, viewer)
	if inst.on then
		return "ON"
	else
		return "OFF"
	end
end

local function OnSave(inst, data)
    local refs = {}
    return refs
end

local function OnLoad(inst, data)
end

local function CanInteract(inst)
	if inst.components.machine.ison then
		return false
	end
	return true
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(0.6)
    inst.Light:SetRadius(2.5)
    inst.Light:Enable(false)
    inst.Light:SetColour(237/255, 237/255, 209/255)
	inst.on = false

    MakeObstaclePhysics(inst, .4)
	inst.Transform:SetTwoFaced()
	
    inst.AnimState:SetBank("kyno_grottolamp")
    inst.AnimState:SetBuild("kyno_grottolamp")
	inst.AnimState:PlayAnimation("idle_off", true)
    
	inst:AddTag("structure")
	inst:AddTag("grotto_structure")
	inst:AddTag("rotatableobject")
	
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
	-- inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("savedrotation")
	
	MakeHauntableWork(inst)
	
	inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
	
    return inst
end

return Prefab("sap_grottolamp", fn, assets, prefabs),
MakePlacer("sap_grottolamp_placer", "kyno_grottolamp", "kyno_grottolamp", "idle_off")
