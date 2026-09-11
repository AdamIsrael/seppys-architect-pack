require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/boat_propelomatic.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"collapse_small"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst)
	inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
end

local function TurnOn(inst)
	inst.AnimState:PlayAnimation("on_pre")
	inst.AnimState:PushAnimation("on_loop", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/fan/on_LP", "firesuppressor_idle")
end

local function TurnOff(inst)
	inst.AnimState:PlayAnimation("cooldown_pre")
	inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:KillSound("on_LP")
	inst.SoundEmitter:KillSound("firesuppressor_idle")
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

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_propelomatic.tex")

    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("propelomatic")
    inst.AnimState:SetBuild("boat_propelomatic")
	inst.AnimState:PlayAnimation("idle", true)
    
	inst:AddTag("structure")
	
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
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
	inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
	
    return inst
end

return Prefab("sap_propelomatic", fn, assets, prefabs),
MakePlacer("sap_propelomatic_placer", "propelomatic", "boat_propelomatic", "idle")
