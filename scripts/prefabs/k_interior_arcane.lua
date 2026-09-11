require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/interior_wall_decals_arcane.zip"),
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
		MakeObstaclePhysics(inst, 2)
	else
		MakeObstaclePhysics(inst, .5)
	end
	
    inst.AnimState:SetBank("wall_decals_arcane")
    inst.AnimState:SetBuild("interior_wall_decals_arcane")
    
	inst:AddTag("structure")
	inst:AddTag("arcane_decor")
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

local function bookcase()
    local inst = common(true, true, true, false)
    inst.AnimState:PlayAnimation("bookcase_backwall")
    return inst
end

local function chest_closed()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("chest_closed")
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("treasurechest.png")
    return inst
end

local function chest_open()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("chest_open")
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("treasurechest.png")
    return inst
end

local function containers()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("containers")
    return inst
end

local function tablemagic()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("table")
	MakeObstaclePhysics(inst, 1)
    return inst
end

local function tabledistillery()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("table_distillery")
	MakeObstaclePhysics(inst, 1)
    return inst
end

return Prefab("sap_arcane_bookcase", bookcase, assets),
Prefab("sap_arcane_chestclosed", chest_closed, assets),
Prefab("sap_arcane_chestopen", chest_open, assets),
Prefab("sap_arcane_containers", containers, assets),
Prefab("sap_arcane_tablemagic", tablemagic, assets),
Prefab("sap_arcane_tabledistillery", tabledistillery, assets),
MakePlacer("sap_arcane_bookcase_placer", "wall_decals_arcane", "interior_wall_decals_arcane", "bookcase_backwall"),
MakePlacer("sap_arcane_chestclosed_placer", "wall_decals_arcane", "interior_wall_decals_arcane", "chest_closed"),
MakePlacer("sap_arcane_chestopen_placer", "wall_decals_arcane", "interior_wall_decals_arcane", "chest_open"),
MakePlacer("sap_arcane_containers_placer", "wall_decals_arcane", "interior_wall_decals_arcane", "containers"),
MakePlacer("sap_arcane_tablemagic_placer", "wall_decals_arcane", "interior_wall_decals_arcane", "table"),
MakePlacer("sap_arcane_tabledistillery_placer", "wall_decals_arcane", "interior_wall_decals_arcane", "table_distillery")