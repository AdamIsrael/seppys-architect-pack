require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/interior_wall_decals_florist.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
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

local function common(burnable, save_rotation, radius_long, shadow)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	
	if shadow then
		inst.DynamicShadow:SetSize(2.5, 1.5)
	end

	if radius_long then
		MakeObstaclePhysics(inst, 2)
	else
		MakeObstaclePhysics(inst, .6)
	end
	
    inst.AnimState:SetBank("interior_wall_decals_florist")
    inst.AnimState:SetBuild("interior_wall_decals_florist")
    
	inst:AddTag("structure")
	inst:AddTag("florist_decor")
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

local function latticefront()
    local inst = common(true, true, true, false)
    inst.AnimState:PlayAnimation("lattice_front")
    return inst
end

local function latticeside()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("lattice_sidewall")
    return inst
end

local function pillarfront()
	local inst = common(true, true, false, false)
	inst.AnimState:PlayAnimation("pillar_front")
	return inst
end

local function pillarside()
	local inst = common(true, true, false, false)
	inst.AnimState:PlayAnimation("pillar_sidewall")
	return inst
end

local function tiered()
	local inst = common(true, true, false, false)
	inst.AnimState:PlayAnimation("tiered_trough")
	return inst
end

return Prefab("sap_florist_latticefront", latticefront, assets),
Prefab("sap_florist_latticeside", latticeside, assets),
Prefab("sap_florist_pillarfront", pillarfront, assets),
Prefab("sap_florist_pillarside", pillarside, assets),
Prefab("sap_florist_tiered", tiered, assets),
MakePlacer("sap_florist_latticefront_placer", "interior_wall_decals_florist", "interior_wall_decals_florist", "lattice_front"),
MakePlacer("sap_florist_latticeside_placer", "interior_wall_decals_florist", "interior_wall_decals_florist", "lattice_sidewall"),
MakePlacer("sap_florist_pillarfront_placer", "interior_wall_decals_florist", "interior_wall_decals_florist", "pillar_front"),
MakePlacer("sap_florist_pillarside_placer", "interior_wall_decals_florist", "interior_wall_decals_florist", "pillar_sidewall"),
MakePlacer("sap_florist_tiered_placer", "interior_wall_decals_florist", "interior_wall_decals_florist", "tiered_trough")