require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/interior_table.zip"),
	
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

local function common(burnable, save_rotation, radius_long)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	
	inst.DynamicShadow:SetSize(2.5, 1.5)

	if radius_long then
		MakeObstaclePhysics(inst, 1.2)
	else
		MakeObstaclePhysics(inst, .5)
	end
	
    inst.AnimState:SetBank("interior_table")
    inst.AnimState:SetBuild("interior_table")
    
	inst:AddTag("structure")
	inst:AddTag("housetables")
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

local function banker()
    local inst = common(true, true, true)
    inst.AnimState:PlayAnimation("table_banker")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
	inst.DynamicShadow:SetSize(3.5, 1.5)
    return inst
end

local function chess()
    local inst = common(true, true, false)
    inst.AnimState:PlayAnimation("table_chess")
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
    return inst
end

local function crate()
    local inst = common(true, true, false)
    inst.AnimState:PlayAnimation("table_crate")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function diy()
    local inst = common(true, true, false)
    inst.AnimState:PlayAnimation("table_diy")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function raw()
    local inst = common(true, true, false)
    inst.AnimState:PlayAnimation("table_raw")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function round()
    local inst = common(true, true, false)
    inst.AnimState:PlayAnimation("table_round")
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
    return inst
end

local function chessplacefn(inst)
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
end

local function tableplacefn(inst)
	inst.AnimState:SetScale(1.3, 1.3, 1.3)
end

return Prefab("sap_tables_banker", banker, assets),
Prefab("sap_tables_chess", chess, assets),
Prefab("sap_tables_crate", crate, assets),
Prefab("sap_tables_diy", diy, assets),
Prefab("sap_tables_raw", raw, assets),
Prefab("sap_tables_round", round, assets),
MakePlacer("sap_tables_banker_placer", "interior_table", "interior_table", "table_banker", nil, nil, nil, nil, nil, nil, tableplacefn),
MakePlacer("sap_tables_chess_placer", "interior_table", "interior_table", "table_chess", nil, nil, nil, nil, nil, nil, chessplacefn),
MakePlacer("sap_tables_crate_placer", "interior_table", "interior_table", "table_crate", nil, nil, nil, nil, nil, nil, tableplacefn),
MakePlacer("sap_tables_diy_placer", "interior_table", "interior_table", "table_diy", nil, nil, nil, nil, nil, nil, tableplacefn),
MakePlacer("sap_tables_raw_placer", "interior_table", "interior_table", "table_raw", nil, nil, nil, nil, nil, nil, tableplacefn),
MakePlacer("sap_tables_round_placer", "interior_table", "interior_table", "table_round", nil, nil, nil, nil, nil, nil, tableplacefn)