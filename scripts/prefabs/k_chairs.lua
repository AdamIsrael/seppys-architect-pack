require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/interior_chair.zip"),
	Asset("ANIM", "anim/interior_floor_decor.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function onhit(inst, worker)
    local rotation = inst.Transform:GetRotation()
    inst.Transform:SetRotation((rotation + 180) % 360)
end

local function common(burnable, radius_long, save_rotation)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    if radius_long then
		MakeObstaclePhysics(inst, 1)
	else
		MakeObstaclePhysics(inst, .4)
	end
	
    inst.AnimState:SetBank("interior_chair")
    inst.AnimState:SetBuild("interior_chair")
	inst.AnimState:SetFinalOffset(-1)
    
	inst:AddTag("structure")
	inst:AddTag("plantholder")
	
	if save_rotation then
		inst.Transform:SetTwoFaced()
	end
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	inst:AddComponent("sittable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	-- inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	if save_rotation then
		inst:AddComponent("savedrotation")
	end
	
	MakeHauntableWork(inst)
	
	if burnable then
		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
	end
	
    return inst
end

local function special(burnable, radius_long, save_rotation)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    if radius_long then
		MakeObstaclePhysics(inst, 1)
	else
		MakeObstaclePhysics(inst, .4)
	end
	
    inst.AnimState:SetBank("interior_floor_decor")
    inst.AnimState:SetBuild("interior_floor_decor")
    
	inst:AddTag("structure")
	inst:AddTag("chairs")
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
	inst:AddComponent("sittable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	-- inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	if save_rotation then
		inst:AddComponent("savedrotation")
	end
	
	MakeHauntableWork(inst)
	
	if burnable then
		MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
	end
	
    return inst
end

local function bench()
    local inst = common(true, true, true)
    inst.AnimState:PlayAnimation("chair_bench")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function classic()
    local inst = common(false, false, true)
    inst.AnimState:PlayAnimation("chair_classic")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function corner()
    local inst = common(true, false, true)
    inst.AnimState:PlayAnimation("chair_corner")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function footrest()
    local inst = common(true, false, true)
    inst.AnimState:PlayAnimation("chair_footrest")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function horned()
    local inst = common(true, false, true)
    inst.AnimState:PlayAnimation("chair_horned")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function lounge()
    local inst = common(true, false, true)
    inst.AnimState:PlayAnimation("chair_lounge")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function massager()
    local inst = common(true, false, true)
    inst.AnimState:PlayAnimation("chair_massager")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function ottoman()
    local inst = common(true, false, true)
    inst.AnimState:PlayAnimation("chair_ottoman")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function rocking()
    local inst = common(true, false, true)
    inst.AnimState:PlayAnimation("chair_rocking")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function stuffed()
    local inst = common(true, false, true)
    inst.AnimState:PlayAnimation("chair_stuffed")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function chaise()
	local inst = special(false, true, true)
	inst.AnimState:PlayAnimation("chaise")
	return inst
end

local function chairsplacefn(inst)
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
end

return Prefab("kyno_chair_bench", bench, assets),
Prefab("kyno_chair_classic", classic, assets),
Prefab("kyno_chair_corner", corner, assets),
Prefab("kyno_chair_footrest", footrest, assets),
Prefab("kyno_chair_horned", horned, assets),
Prefab("kyno_chair_lounge", lounge, assets),
Prefab("kyno_chair_massager", massager, assets),
Prefab("kyno_chair_ottoman", ottoman, assets),
Prefab("kyno_chair_rocking", rocking, assets),
Prefab("kyno_chair_stuffed", stuffed, assets),
Prefab("kyno_chair_chaise", chaise, assets),
MakePlacer("kyno_chair_bench_placer", "interior_chair", "interior_chair", "chair_bench", nil, nil, nil, nil, nil, "two", chairsplacefn),
MakePlacer("kyno_chair_classic_placer", "interior_chair", "interior_chair", "chair_classic", nil, nil, nil, nil, nil, "two", chairsplacefn),
MakePlacer("kyno_chair_corner_placer", "interior_chair", "interior_chair", "chair_corner", nil, nil, nil, nil, nil, "two", chairsplacefn),
MakePlacer("kyno_chair_footrest_placer", "interior_chair", "interior_chair", "chair_footrest", nil, nil, nil, nil, nil, "two", chairsplacefn),
MakePlacer("kyno_chair_horned_placer", "interior_chair", "interior_chair", "chair_horned", nil, nil, nil, nil, nil, "two", chairsplacefn),
MakePlacer("kyno_chair_lounge_placer", "interior_chair", "interior_chair", "chair_lounge", nil, nil, nil, nil, nil, "two", chairsplacefn),
MakePlacer("kyno_chair_massager_placer", "interior_chair", "interior_chair", "chair_massager", nil, nil, nil, nil, nil, "two", chairsplacefn),
MakePlacer("kyno_chair_ottoman_placer", "interior_chair", "interior_chair", "chair_ottoman", nil, nil, nil, nil, nil, "two", chairsplacefn),
MakePlacer("kyno_chair_rocking_placer", "interior_chair", "interior_chair", "chair_rocking", nil, nil, nil, nil, nil, "two", chairsplacefn),
MakePlacer("kyno_chair_stuffed_placer", "interior_chair", "interior_chair", "chair_stuffed", nil, nil, nil, nil, nil, "two", chairsplacefn),
MakePlacer("kyno_chair_chaise_placer", "interior_floor_decor", "interior_floor_decor", "chaise", nil, nil, nil, nil, nil, "two", chairsplacefn)