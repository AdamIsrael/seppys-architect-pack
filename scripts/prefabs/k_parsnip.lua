require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_parsnip_giant.zip"),
	Asset("ANIM", "anim/kyno_parsnip.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"carrot",
}

local function onworked(inst, chopper, workleft)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")          
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	end
end

local function onworkfinish(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	inst.components.lootdropper:DropLoot()
	inst:DoPeriodicTask(0.2, function() inst:Remove() end)
end

local function onpicked(inst)
	inst:Remove()
end

local function parsnips()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_parsnips.tex")
	
	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("kyno_parsnip_giant")
	inst.AnimState:SetBuild("kyno_parsnip_giant")
	inst.AnimState:PlayAnimation("parsnips", true)
	
	inst:AddTag("structure")
	inst:AddTag("parsnip")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetOnFinishCallback(onworkfinish)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
	
	return inst
end

local function giant1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_parsnips.tex")

	inst.AnimState:SetBank("kyno_parsnip_giant")
	inst.AnimState:SetBuild("kyno_parsnip_giant")
	inst.AnimState:PlayAnimation("idle1")
	
	inst:AddTag("structure")
	inst:AddTag("parsnip")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetOnFinishCallback(onworkfinish)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
	
	return inst
end

local function giant2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_parsnips.tex")

	inst.AnimState:SetBank("kyno_parsnip_giant")
	inst.AnimState:SetBuild("kyno_parsnip_giant")
	inst.AnimState:PlayAnimation("idle2")
	
	inst:AddTag("structure")
	inst:AddTag("parsnip")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetOnFinishCallback(onworkfinish)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
	
	return inst
end

local function giant3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_parsnips.tex")

	inst.AnimState:SetBank("kyno_parsnip_giant")
	inst.AnimState:SetBuild("kyno_parsnip_giant")
	inst.AnimState:PlayAnimation("idle3")
	
	inst:AddTag("structure")
	inst:AddTag("parsnip")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetOnFinishCallback(onworkfinish)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
	
	return inst
end

local function giant4()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_parsnips.tex")

	inst.AnimState:SetBank("kyno_parsnip_giant")
	inst.AnimState:SetBuild("kyno_parsnip_giant")
	inst.AnimState:PlayAnimation("idle4")
	
	inst:AddTag("structure")
	inst:AddTag("parsnip")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetOnFinishCallback(onworkfinish)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
	
	return inst
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("kyno_parsnip")
    inst.AnimState:SetBuild("kyno_parsnip")
    inst.AnimState:PlayAnimation("planted")
    inst.AnimState:SetRayTestOnBB(true)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("carrot")
    inst.components.pickable.onpickedfn = onpicked
    inst.components.pickable.quickpick = true
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab("sap_parsnips", parsnips, assets, prefabs),
-- Prefab("kyno_parsnip_giant1", giant1, assets, prefabs),
-- Prefab("kyno_parsnip_giant2", giant2, assets, prefabs),
-- Prefab("kyno_parsnip_giant3", giant3, assets, prefabs),
-- Prefab("kyno_parsnip_giant4", giant4, assets, prefabs),
Prefab("sap_parsnip_planted", fn, assets, prefabs),
MakePlacer("sap_parsnips_placer", "kyno_parsnip_giant", "kyno_parsnip_giant", "parsnips"),
-- MakePlacer("kyno_parsnip_giant1_placer", "kyno_parsnip_giant", "kyno_parsnip_giant", "idle1"),
-- MakePlacer("kyno_parsnip_giant2_placer", "kyno_parsnip_giant", "kyno_parsnip_giant", "idle2"),
-- MakePlacer("kyno_parsnip_giant3_placer", "kyno_parsnip_giant", "kyno_parsnip_giant", "idle3"),
-- MakePlacer("kyno_parsnip_giant4_placer", "kyno_parsnip_giant", "kyno_parsnip_giant", "idle4"),
MakePlacer("sap_parsnip_planted_placer", "kyno_parsnip", "kyno_parsnip", "planted")