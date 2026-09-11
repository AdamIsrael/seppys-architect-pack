require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/alterguardian_spawn_death.zip"),
}

local function onfinish(inst, worker)
	SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 2)
	
	inst.AnimState:SetBank("alterguardian_spawn_death")
    inst.AnimState:SetBuild("alterguardian_spawn_death")
	inst.AnimState:PlayAnimation("phase1_death_idle")
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ALTERGUARDIAN_PHASE3DEAD"
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	return inst
end

local function fn2()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 2)
	
	inst.AnimState:SetBank("alterguardian_spawn_death")
    inst.AnimState:SetBuild("alterguardian_spawn_death")
	inst.AnimState:PlayAnimation("phase2_death_idle")
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ALTERGUARDIAN_PHASE3DEAD"
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	return inst
end

local function fn3()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 2)
	
	inst.AnimState:SetBank("alterguardian_spawn_death")
    inst.AnimState:SetBuild("alterguardian_spawn_death")
	inst.AnimState:PlayAnimation("phase3_death_idle")
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ALTERGUARDIAN_PHASE3DEAD"
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	return inst
end

local function fn4()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 2)
	
	inst.AnimState:SetBank("alterguardian_spawn_death")
    inst.AnimState:SetBuild("alterguardian_spawn_death")
	inst.AnimState:PlayAnimation("phase3_death_loop", true)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ALTERGUARDIAN_PHASE3DEADORB"
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	return inst
end

return Prefab("sap_defeated_cc1", fn, assets),
Prefab("sap_defeated_cc2", fn2, assets),
Prefab("sap_defeated_cc3", fn3, assets),
Prefab("sap_defeated_cc4", fn4, assets),
MakePlacer("sap_defeated_cc1_placer", "alterguardian_spawn_death", "alterguardian_spawn_death", "phase1_death_idle"),
MakePlacer("sap_defeated_cc2_placer", "alterguardian_spawn_death", "alterguardian_spawn_death", "phase2_death_idle"),
MakePlacer("sap_defeated_cc3_placer", "alterguardian_spawn_death", "alterguardian_spawn_death", "phase3_death_idle"),
MakePlacer("sap_defeated_cc4_placer", "alterguardian_spawn_death", "alterguardian_spawn_death", "phase3_death_loop")