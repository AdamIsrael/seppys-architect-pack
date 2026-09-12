require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/archive_centipede.zip"),
	Asset("ANIM", "anim/archive_centipede_build.zip"),
}

local prefabs =
{
	"collapse_small",
	"sap_archive_centipede_low",
	"sap_archive_centipede_med"
}

local function onhammered_full(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("sap_archive_centipede_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhammered_med(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("sap_archive_centipede_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhammered_low(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit_full(inst, worker)
	inst.AnimState:PlayAnimation("idle2_full")
	inst.AnimState:PushAnimation("idle_full")
end

local function onhit_med(inst, worker)
	inst.AnimState:PlayAnimation("idle2_med")
	inst.AnimState:PushAnimation("idle_med")
end

local function onhit_low(inst, worker)
	inst.AnimState:PlayAnimation("idle2_low")
	inst.AnimState:PushAnimation("idle_low")
end

local function fullfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("archive_centipede")
    inst.AnimState:SetBuild("archive_centipede_build")
    inst.AnimState:PlayAnimation("idle_full")
    
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("archive_centipede_husk")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered_full)
	inst.components.workable:SetOnWorkCallback(onhit_full)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function medfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("archive_centipede")
    inst.AnimState:SetBuild("archive_centipede_build")
    inst.AnimState:PlayAnimation("idle_med")
    
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("archive_centipede_husk")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(onhammered_med)
	inst.components.workable:SetOnWorkCallback(onhit_med)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function lowfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("archive_centipede")
    inst.AnimState:SetBuild("archive_centipede_build")
    inst.AnimState:PlayAnimation("idle_low")
    
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("archive_centipede_husk")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(onhammered_low)
	inst.components.workable:SetOnWorkCallback(onhit_low)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_archive_centipede", fullfn, assets, prefabs),
Prefab("sap_archive_centipede_med", medfn, assets, prefabs),
Prefab("sap_archive_centipede_low", lowfn, assets, prefabs),
MakePlacer("sap_archive_centipede_placer", "archive_centipede", "archive_centipede_build", "idle_full")
