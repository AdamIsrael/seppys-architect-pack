require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/interior_wall_decals_deli.zip"),
	
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
		MakeObstaclePhysics(inst, .5)
	end
	
    inst.AnimState:SetBank("wall_decals_deli")
    inst.AnimState:SetBuild("interior_wall_decals_deli")
    
	inst:AddTag("structure")
	inst:AddTag("deli_decor")
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

local function stackside()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("stack_sidewall")
    return inst
end

local function stackfront()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("stack_front")
    return inst
end

return Prefab("kyno_deli_stackside", stackside, assets),
Prefab("kyno_deli_stackfront", stackfront, assets),
MakePlacer("kyno_deli_stackside_placer", "wall_decals_deli", "interior_wall_decals_deli", "stack_sidewall"),
MakePlacer("kyno_deli_stackfront_placer", "wall_decals_deli", "interior_wall_decals_deli", "stack_front")