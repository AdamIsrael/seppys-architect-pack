local assets =
{
    Asset("ANIM", "anim/crater.zip"), 
}

local prefabs =
{
    "moonrocknugget",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function commonfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("crater")
    inst.AnimState:SetBuild("crater")

	inst:AddTag("structure")
    inst:AddTag("crater")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "HOTSPRING"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

    return inst
end

local function fn1()
    local inst = commonfn()
	
	MakeObstaclePhysics(inst, 1)
    inst.AnimState:PlayAnimation("f1")
	
    return inst
end

local function fn2()
    local inst = commonfn()
	
	MakeObstaclePhysics(inst, 1)
    inst.AnimState:PlayAnimation("f2")
	
    return inst
end

local function fn3()
    local inst = commonfn()
	
	MakeObstaclePhysics(inst, .2)
    inst.AnimState:PlayAnimation("f3")
	
    return inst
end

local function fn4()
    local inst = commonfn()
	
	MakeObstaclePhysics(inst, .3)
    inst.AnimState:PlayAnimation("f4")
	
    return inst
end

local function fn5()
    local inst = commonfn()
	
	MakeObstaclePhysics(inst, .2)
    inst.AnimState:PlayAnimation("f5")
	
    return inst
end

local function fn6()
    local inst = commonfn()
	
	MakeObstaclePhysics(inst, .2)
    inst.AnimState:PlayAnimation("f6")
	
    return inst
end

local function fn7()
    local inst = commonfn()
	
	MakeObstaclePhysics(inst, .3)
    inst.AnimState:PlayAnimation("f7")
	
    return inst
end

return Prefab("sap_mooncrater_1", fn1, assets, prefabs),
Prefab("sap_mooncrater_2", fn2, assets, prefabs),
Prefab("sap_mooncrater_3", fn3, assets, prefabs),
Prefab("sap_mooncrater_4", fn4, assets, prefabs),
Prefab("sap_mooncrater_5", fn5, assets, prefabs),
Prefab("sap_mooncrater_6", fn6, assets, prefabs),
Prefab("sap_mooncrater_7", fn7, assets, prefabs),
MakePlacer("sap_mooncrater_1_placer", "crater", "crater", "f1"),
MakePlacer("sap_mooncrater_2_placer", "crater", "crater", "f2"),
MakePlacer("sap_mooncrater_3_placer", "crater", "crater", "f3"),
MakePlacer("sap_mooncrater_4_placer", "crater", "crater", "f4"),
MakePlacer("sap_mooncrater_5_placer", "crater", "crater", "f5"),
MakePlacer("sap_mooncrater_6_placer", "crater", "crater", "f6"),
MakePlacer("sap_mooncrater_7_placer", "crater", "crater", "f7")