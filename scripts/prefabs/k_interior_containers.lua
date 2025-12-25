require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/containers.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function common(burnable, save_rotation)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("containers")
    inst.AnimState:SetBuild("containers")
    
	inst:AddTag("structure")
	inst:AddTag("containers_decor")
	inst:AddTag("rotatableobject")
	
	if save_rotation then
		inst.Transform:SetTwoFaced()
	end
	
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
	
	if save_rotation then
		inst:AddComponent("savedrotation")
	end
	
	if burnable then
		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
	end
	
	MakeHauntableWork(inst)
	
    return inst
end

local function box1()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("1")
    return inst
end

local function box2()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("10")
    return inst
end

local function box3()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("11")
    return inst
end

local function box4()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("12")
    return inst
end

local function box5()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("13")
    return inst
end

local function box6()
    local inst = common(false, true)
    inst.AnimState:PlayAnimation("14")
    return inst
end

local function box7()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("15")
    return inst
end

local function box8()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("16")
    return inst
end

local function box9()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("2")
    return inst
end

local function box10()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("3")
    return inst
end

local function box11()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("4")
    return inst
end

local function box12()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("5")
    return inst
end

local function box13()
    local inst = common(false, true)
    inst.AnimState:PlayAnimation("6")
    return inst
end

local function box14()
    local inst = common(false, true)
    inst.AnimState:PlayAnimation("7")
    return inst
end

local function box15()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("8")
    return inst
end

local function box16()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("9")
    return inst
end

return Prefab("kyno_containers_box1", box1, assets),
Prefab("kyno_containers_box2", box2, assets),
Prefab("kyno_containers_box3", box3, assets),
Prefab("kyno_containers_box4", box4, assets),
Prefab("kyno_containers_box5", box5, assets),
Prefab("kyno_containers_box6", box6, assets),
Prefab("kyno_containers_box7", box7, assets),
Prefab("kyno_containers_box8", box8, assets),
Prefab("kyno_containers_box9", box9, assets),
Prefab("kyno_containers_box10", box10, assets),
Prefab("kyno_containers_box11", box11, assets),
Prefab("kyno_containers_box12", box12, assets),
Prefab("kyno_containers_box13", box13, assets),
Prefab("kyno_containers_box14", box14, assets),
Prefab("kyno_containers_box15", box15, assets),
Prefab("kyno_containers_box16", box16, assets),
MakePlacer("kyno_containers_box1_placer", "containers", "containers", "1"),
MakePlacer("kyno_containers_box2_placer", "containers", "containers", "10"),
MakePlacer("kyno_containers_box3_placer", "containers", "containers", "11"),
MakePlacer("kyno_containers_box4_placer", "containers", "containers", "12"),
MakePlacer("kyno_containers_box5_placer", "containers", "containers", "13"),
MakePlacer("kyno_containers_box6_placer", "containers", "containers", "14"),
MakePlacer("kyno_containers_box7_placer", "containers", "containers", "15"),
MakePlacer("kyno_containers_box8_placer", "containers", "containers", "16"),
MakePlacer("kyno_containers_box9_placer", "containers", "containers", "2"),
MakePlacer("kyno_containers_box10_placer", "containers", "containers", "3"),
MakePlacer("kyno_containers_box11_placer", "containers", "containers", "4"),
MakePlacer("kyno_containers_box12_placer", "containers", "containers", "5"),
MakePlacer("kyno_containers_box13_placer", "containers", "containers", "6"),
MakePlacer("kyno_containers_box14_placer", "containers", "containers", "7"),
MakePlacer("kyno_containers_box15_placer", "containers", "containers", "8"),
MakePlacer("kyno_containers_box16_placer", "containers", "containers", "9")