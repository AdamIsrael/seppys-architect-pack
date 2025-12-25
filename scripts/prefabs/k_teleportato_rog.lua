require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/teleportato.zip"),
    Asset("ANIM", "anim/teleportato_build.zip"),
    Asset("ANIM", "anim/teleportato_adventure_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle_off")
    inst.AnimState:PushAnimation("idle_off")
end

local function DoLaugh(inst)
if inst:HasTag("teleporter_rog") then
	inst:DoTaskInTime(8+math.random()*5, function() DoLaugh(inst) end)
		inst.AnimState:PlayAnimation("laugh")
		-- inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_maxwelllaugh", "teleportato_laugh")
		inst.AnimState:PushAnimation("active_idle")
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("activate")
	inst.AnimState:PushAnimation("active_idle")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.1)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("teleportato.png")
	minimap:SetPriority(5)
	
	inst.AnimState:SetBank("teleporter")
	inst.AnimState:SetBuild("teleportato_build")
	inst.AnimState:PlayAnimation("active_idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("teleporter_rog")
	
	inst:SetPrefabNameOverride("teleportato_base")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_activeidle_LP", "teleportato_active_idle")
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

	inst:ListenForEvent("onbuilt", onbuilt)
	
	DoLaugh(inst)

	return inst
end

local function advfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.1)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("teleportato.png")
	minimap:SetPriority(5)
	
	inst.AnimState:SetBank("teleporter")
	inst.AnimState:SetBuild("teleportato_adventure_build")
	inst.AnimState:PlayAnimation("active_idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("teleporter_rog")
	inst:AddTag("teleporter_adventure")
	
	inst:SetPrefabNameOverride("teleportato_base")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_activeidle_LP", "teleportato_active_idle")
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

	inst:ListenForEvent("onbuilt", onbuilt)
	
	DoLaugh(inst)

	return inst
end

return Prefab("kyno_teleporter_rog", fn, assets, prefabs),
Prefab("kyno_teleporter_adventure", advfn, assets, prefabs),
MakePlacer("kyno_teleporter_rog_placer", "teleporter", "teleportato_build", "active_idle"),
MakePlacer("kyno_teleporter_adventure_placer", "teleporter", "teleportato_adventure_build", "active_idle")