require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_rock1.zip"),
	Asset("ANIM", "anim/quagmire_rock2.zip"),
	Asset("ANIM", "anim/quagmire_rock3.zip"),
	Asset("ANIM", "anim/quagmire_rock4.zip"),
	Asset("ANIM", "anim/quagmire_rock5.zip"),
	Asset("ANIM", "anim/quagmire_rock6.zip"),
}

local prefabs =
{
	"collapse_small",
	"sap_quagmire_rock1_low",
	"sap_quagmire_rock1_med",
	"sap_quagmire_rock2_low",
	"sap_quagmire_rock2_med",
	"sap_quagmire_rock3_low",
	"sap_quagmire_rock3_med",
	"sap_quagmire_rock4_low",
	"sap_quagmire_rock4_med",
	"sap_quagmire_rock5_low",
	"sap_quagmire_rock5_med",
	"sap_quagmire_rock6_low",
	"sap_quagmire_rock6_med"
}

local function rock1_onhammered_full(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock1_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function rock1_onhammered_med(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock1_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onhammered_low(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function rock1_full()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock1")
	inst.AnimState:SetBuild("quagmire_rock1")
	inst.AnimState:PlayAnimation("full", true)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock1_onhammered_full)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock1_med()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock1")
	inst.AnimState:SetBuild("quagmire_rock1")
	inst.AnimState:PlayAnimation("med", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock1_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK1_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock1_onhammered_med)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock1_low()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock1")
	inst.AnimState:SetBuild("quagmire_rock1")
	inst.AnimState:PlayAnimation("low", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock1_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK1_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_low)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock2_onhammered_full(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock2_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function rock2_onhammered_med(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock2_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function rock2_full()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("quagmire_rock2")
	inst.AnimState:SetBuild("quagmire_rock2")
	inst.AnimState:PlayAnimation("full", true)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock2_onhammered_full)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock2_med()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("quagmire_rock2")
	inst.AnimState:SetBuild("quagmire_rock2")
	inst.AnimState:PlayAnimation("med", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock2_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK2_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock2_onhammered_med)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock2_low()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("quagmire_rock2")
	inst.AnimState:SetBuild("quagmire_rock2")
	inst.AnimState:PlayAnimation("low", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock2_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK2_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_low)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock3_onhammered_full(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock3_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function rock3_onhammered_med(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock3_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function rock3_full()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("quagmire_rock3")
	inst.AnimState:SetBuild("quagmire_rock3")
	inst.AnimState:PlayAnimation("full", true)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock3_onhammered_full)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock3_med()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("quagmire_rock3")
	inst.AnimState:SetBuild("quagmire_rock3")
	inst.AnimState:PlayAnimation("med", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock3_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK3_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock3_onhammered_med)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock3_low()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("quagmire_rock3")
	inst.AnimState:SetBuild("quagmire_rock3")
	inst.AnimState:PlayAnimation("low", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock3_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK3_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_low)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock4_onhammered_full(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock4_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function rock4_onhammered_med(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock4_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function rock4_full()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock4")
	inst.AnimState:SetBuild("quagmire_rock4")
	inst.AnimState:PlayAnimation("full", true)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock4_onhammered_full)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock4_med()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock4")
	inst.AnimState:SetBuild("quagmire_rock4")
	inst.AnimState:PlayAnimation("med", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock4_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK4_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock4_onhammered_med)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock4_low()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock4")
	inst.AnimState:SetBuild("quagmire_rock4")
	inst.AnimState:PlayAnimation("low", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock4_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK4_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_low)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock5_onhammered_full(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock5_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function rock5_onhammered_med(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock5_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function rock5_full()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock5")
	inst.AnimState:SetBuild("quagmire_rock5")
	inst.AnimState:PlayAnimation("full", true)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock5_onhammered_full)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock5_med()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock5")
	inst.AnimState:SetBuild("quagmire_rock5")
	inst.AnimState:PlayAnimation("med", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock5_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK5_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock5_onhammered_med)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock5_low()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock5")
	inst.AnimState:SetBuild("quagmire_rock5")
	inst.AnimState:PlayAnimation("low", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock5_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK5_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_low)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock6_onhammered_full(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock6_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function rock6_onhammered_med(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	SpawnPrefab("sap_quagmire_rock6_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function rock6_full()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock6")
	inst.AnimState:SetBuild("quagmire_rock6")
	inst.AnimState:PlayAnimation("full", true)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock6_onhammered_full)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock6_med()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock6")
	inst.AnimState:SetBuild("quagmire_rock6")
	inst.AnimState:PlayAnimation("med", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock6_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK6_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(rock6_onhammered_med)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

local function rock6_low()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst.AnimState:SetBank("quagmire_rock6")
	inst.AnimState:SetBuild("quagmire_rock6")
	inst.AnimState:PlayAnimation("low", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_quagmire_rock6_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_QUAGMIRE_ROCK6_FULL"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_low)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

return Prefab("sap_quagmire_rock1_full", rock1_full, assets, prefabs),
Prefab("sap_quagmire_rock1_med", rock1_med, assets, prefabs),
Prefab("sap_quagmire_rock1_low", rock1_low, assets, prefabs),

Prefab("sap_quagmire_rock2_full", rock2_full, assets, prefabs),
Prefab("sap_quagmire_rock2_med", rock2_med, assets, prefabs),
Prefab("sap_quagmire_rock2_low", rock2_low, assets, prefabs),

Prefab("sap_quagmire_rock3_full", rock3_full, assets, prefabs),
Prefab("sap_quagmire_rock3_med", rock3_med, assets, prefabs),
Prefab("sap_quagmire_rock3_low", rock3_low, assets, prefabs),

Prefab("sap_quagmire_rock4_full", rock4_full, assets, prefabs),
Prefab("sap_quagmire_rock4_med", rock4_med, assets, prefabs),
Prefab("sap_quagmire_rock4_low", rock4_low, assets, prefabs),

Prefab("sap_quagmire_rock5_full", rock5_full, assets, prefabs),
Prefab("sap_quagmire_rock5_med", rock5_med, assets, prefabs),
Prefab("sap_quagmire_rock5_low", rock5_low, assets, prefabs),

Prefab("sap_quagmire_rock6_full", rock6_full, assets, prefabs),
Prefab("sap_quagmire_rock6_med", rock6_med, assets, prefabs),
Prefab("sap_quagmire_rock6_low", rock6_low, assets, prefabs),

MakePlacer("sap_quagmire_rock1_full_placer", "quagmire_rock1", "quagmire_rock1", "full"),
MakePlacer("sap_quagmire_rock2_full_placer", "quagmire_rock2", "quagmire_rock2", "full"),
MakePlacer("sap_quagmire_rock3_full_placer", "quagmire_rock3", "quagmire_rock3", "full"),
MakePlacer("sap_quagmire_rock4_full_placer", "quagmire_rock4", "quagmire_rock4", "full"),
MakePlacer("sap_quagmire_rock5_full_placer", "quagmire_rock5", "quagmire_rock5", "full"),
MakePlacer("sap_quagmire_rock6_full_placer", "quagmire_rock6", "quagmire_rock6", "full")
