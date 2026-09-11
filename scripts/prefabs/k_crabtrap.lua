require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_crab_trap.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("broken")
    inst.AnimState:PushAnimation("broken", true)
	inst:RemoveTag("crabtrap")
	inst:AddTag("trapbroken")
	inst.broken = true
end

local function DoCrab(inst)
if inst:HasTag("crabtrap") and not inst:HasTag("trapbroken") then
	inst:DoTaskInTime(8+math.random()*5, function() DoCrab(inst) end)
		inst.AnimState:PlayAnimation("trap_loop")
		inst.AnimState:PushAnimation("idle")
	end
end

local function onsave(inst, data)
	if inst.broken then
		data.broken = true
	end
end

local function onload(inst, data)
	if data and data.broken then
		inst.broken = true
		inst.AnimState:PlayAnimation("broken")
		inst:RemoveTag("crabtrap")
		inst:AddTag("trapbroken")
	end
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("birdtrap.png")
	
    inst.AnimState:SetBank("quagmire_crab_trap")
    inst.AnimState:SetBuild("quagmire_crab_trap")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("crabtrap")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_CRABTRAP"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable.savestate = true
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
	DoCrab(inst)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload
	
    return inst
end

return Prefab("sap_crabtrap", fn, assets),
MakePlacer("sap_crabtrap_placer", "quagmire_crab_trap", "quagmire_crab_trap", "idle")