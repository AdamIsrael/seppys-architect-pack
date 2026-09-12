require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/interior_wall_decals_millinery.zip"),
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

local function OnGetItemFromPlayer(inst, giver, item)
    if item.components.fueled then
        item.components.fueled:DoDelta(TUNING.SEWINGKIT_REPAIR_VALUE)
        giver.components.inventory:GiveItem(item)
    end

	-- inst.SoundEmitter:PlaySound("dontstarve/HUD/repair_clothing")
end

local function AcceptTest(inst, item, giver)
    return item:HasTag("needssewing")
end

local function common(burnable, save_rotation, radius_long, shadow, sewing_machine)
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
		MakeObstaclePhysics(inst, 1.5)
	else
		MakeObstaclePhysics(inst, .6)
	end

    inst.AnimState:SetBank("wall_decals_millinery")
    inst.AnimState:SetBuild("interior_wall_decals_millinery")

	inst:AddTag("structure")
	inst:AddTag("millinery_decor")
	inst:AddTag("rotatableobject")

	if sewing_machine then
		inst:AddTag("trader")
	end

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

	if sewing_machine then
		inst:AddComponent("trader")
		inst.components.trader.deleteitemonaccept = false
		inst.components.trader:SetAcceptTest(AcceptTest)
		inst.components.trader.onaccept = OnGetItemFromPlayer
	end

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

local function hatbox1()
    local inst = common(true, true, false, false, false)
    inst.AnimState:PlayAnimation("hatbox1")
    return inst
end

local function hatbox2()
    local inst = common(true, true, false, false, false)
    inst.AnimState:PlayAnimation("hatbox2")
    return inst
end

local function sewingmachine()
    local inst = common(false, true, true, false, true)
    inst.AnimState:PlayAnimation("sewingmachine")
    return inst
end

local function worktable()
    local inst = common(true, true, true, false, false)
    inst.AnimState:PlayAnimation("worktable")
    return inst
end

return Prefab("sap_millinery_hatbox1", hatbox1, assets),
Prefab("sap_millinery_hatbox2", hatbox2, assets),
Prefab("sap_millinery_sewingmachine", sewingmachine, assets),
Prefab("sap_millinery_worktable", worktable, assets),
MakePlacer("sap_millinery_hatbox1_placer", "wall_decals_millinery", "interior_wall_decals_millinery", "hatbox1"),
MakePlacer("sap_millinery_hatbox2_placer", "wall_decals_millinery", "interior_wall_decals_millinery", "hatbox2"),
MakePlacer("sap_millinery_sewingmachine_placer", "wall_decals_millinery", "interior_wall_decals_millinery", "sewingmachine"),
MakePlacer("sap_millinery_worktable_placer", "wall_decals_millinery", "interior_wall_decals_millinery", "worktable")