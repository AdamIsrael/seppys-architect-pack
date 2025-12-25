require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/interior_floor_decor.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
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
		MakeObstaclePhysics(inst, 1)
	else
		MakeObstaclePhysics(inst, .6)
	end
	
    inst.AnimState:SetBank("interior_floor_decor")
    inst.AnimState:SetBuild("interior_floor_decor")
    
	inst:AddTag("structure")
	inst:AddTag("interior_floor_decor")
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

local function baskets()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("baskets")
    return inst
end

local function bin()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("bin")
    return inst
end

local function cans()
    local inst = common(false, true, false, false)
    inst.AnimState:PlayAnimation("cans")
    return inst
end

local function display()
    local inst = common(false, true, false, false)
    inst.AnimState:PlayAnimation("displaytower")
    return inst
end

local function endtable()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("endtable")
    return inst
end

local function parts()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("glasstop_table_parts")
    return inst
end

local function rollholder()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("rollholder")
    return inst
end

local function rollholderfront()
    local inst = common(true, true, true, false)
    inst.AnimState:PlayAnimation("rollholder_front")
    return inst
end

local function vase()
    local inst = common(false, true, false, false)
    inst.AnimState:PlayAnimation("snakebasket")
    return inst
end

local function urn()
    local inst = common(false, true, false, false)
    inst.AnimState:PlayAnimation("urn")
    return inst
end

local function vasemarble()
    local inst = common(false, true, false, false)
    inst.AnimState:PlayAnimation("vase")
    return inst
end

local function wired()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("wired")
    return inst
end

return Prefab("kyno_interior_baskets", baskets, assets),
Prefab("kyno_interior_bin", bin, assets),
Prefab("kyno_interior_cans", cans, assets),
Prefab("kyno_interior_display", display, assets),
Prefab("kyno_interior_endtable", endtable, assets),
Prefab("kyno_interior_parts", parts, assets),
Prefab("kyno_interior_rollholder", rollholder, assets),
Prefab("kyno_interior_rollholderfront", rollholderfront, assets),
Prefab("kyno_interior_vase", vase, assets),
Prefab("kyno_interior_urn", urn, assets),
Prefab("kyno_interior_vasemarble", vasemarble, assets),
Prefab("kyno_interior_wired", wired, assets),
MakePlacer("kyno_interior_baskets_placer", "interior_floor_decor", "interior_floor_decor", "baskets"),
MakePlacer("kyno_interior_bin_placer", "interior_floor_decor", "interior_floor_decor", "bin"),
MakePlacer("kyno_interior_cans_placer", "interior_floor_decor", "interior_floor_decor", "cans"),
MakePlacer("kyno_interior_display_placer", "interior_floor_decor", "interior_floor_decor", "displaytower"),
MakePlacer("kyno_interior_endtable_placer", "interior_floor_decor", "interior_floor_decor", "endtable"),
MakePlacer("kyno_interior_parts_placer", "interior_floor_decor", "interior_floor_decor", "glasstop_table_parts"),
MakePlacer("kyno_interior_rollholder_placer", "interior_floor_decor", "interior_floor_decor", "rollholder"),
MakePlacer("kyno_interior_rollholderfront_placer", "interior_floor_decor", "interior_floor_decor", "rollholder_front"),
MakePlacer("kyno_interior_vase_placer", "interior_floor_decor", "interior_floor_decor", "snakebasket"),
MakePlacer("kyno_interior_urn_placer", "interior_floor_decor", "interior_floor_decor", "urn"),
MakePlacer("kyno_interior_vasemarble_placer", "interior_floor_decor", "interior_floor_decor", "vase"),
MakePlacer("kyno_interior_wired_placer", "interior_floor_decor", "interior_floor_decor", "wired")