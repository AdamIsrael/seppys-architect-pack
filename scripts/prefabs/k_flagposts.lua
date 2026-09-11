require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_flag_post.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetScale(.7, .7, .7)
	
    inst.AnimState:SetBank("kyno_flag_post")
    inst.AnimState:SetBuild("kyno_flag_post")
    inst.AnimState:PlayAnimation("duster", false)
    
	inst:AddTag("structure")
	inst:AddTag("flagpost")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_FLAGPOST"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function fn2()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetScale(.7, .7, .7)
	
    inst.AnimState:SetBank("kyno_flag_post")
    inst.AnimState:SetBuild("kyno_flag_post")
    inst.AnimState:PlayAnimation("perdy", false)
    
	inst:AddTag("structure")
	inst:AddTag("flagpost")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_FLAGPOST"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function fn3()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetScale(.7, .7, .7)
	
    inst.AnimState:SetBank("kyno_flag_post")
    inst.AnimState:SetBuild("kyno_flag_post")
    inst.AnimState:PlayAnimation("royal", false)
    
	inst:AddTag("structure")
	inst:AddTag("flagpost")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_FLAGPOST"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function fn4()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetScale(.7, .7, .7)
	
    inst.AnimState:SetBank("kyno_flag_post")
    inst.AnimState:SetBuild("kyno_flag_post")
    inst.AnimState:PlayAnimation("wilson", false)
    
	inst:AddTag("structure")
	inst:AddTag("flagpost")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_FLAGPOST"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function fn5()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetScale(.7, .7, .7)
	
    inst.AnimState:SetBank("kyno_flag_post")
    inst.AnimState:SetBuild("kyno_flag_post")
    inst.AnimState:PlayAnimation("hand", false)
    
	inst:AddTag("structure")
	inst:AddTag("flagpost")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_FLAGPOST"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function flagpostplacerfn(inst)
	inst.AnimState:SetScale(.7, .7, .7)
end

return Prefab("sap_flagpost1", fn, assets),
Prefab("sap_flagpost2", fn2, assets),
Prefab("sap_flagpost3", fn3, assets),
Prefab("sap_flagpost4", fn4, assets),
Prefab("sap_flagpost5", fn5, assets),
MakePlacer("sap_flagpost1_placer", "kyno_flag_post", "kyno_flag_post", "duster", false, nil, nil, nil, nil, nil, flagpostplacerfn),
MakePlacer("sap_flagpost2_placer", "kyno_flag_post", "kyno_flag_post", "perdy", false, nil, nil, nil, nil, nil, flagpostplacerfn),
MakePlacer("sap_flagpost3_placer", "kyno_flag_post", "kyno_flag_post", "royal", false, nil, nil, nil, nil, nil, flagpostplacerfn),
MakePlacer("sap_flagpost4_placer", "kyno_flag_post", "kyno_flag_post", "wilson", false, nil, nil, nil, nil, nil, flagpostplacerfn),
MakePlacer("sap_flagpost5_placer", "kyno_flag_post", "kyno_flag_post", "hand", false, nil, nil, nil, nil, nil, flagpostplacerfn)