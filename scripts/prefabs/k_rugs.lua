require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/rugs.zip"),
	Asset("ANIM", "anim/pig_shop_doormats.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
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
    inst.Transform:SetRotation((rotation + 90) % 360)
end

local function common(burnable, save_rotation)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("rugs")
    inst.AnimState:SetBuild("rugs")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
    
	inst:AddTag("structure")
	inst:AddTag("rugs")
	inst:AddTag("NOBLOCK")
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

local function common2(burnable, save_rotation)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
	
    inst.AnimState:SetBank("pig_shop_doormats")
    inst.AnimState:SetBuild("pig_shop_doormats")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
    
	inst:AddTag("structure")
	inst:AddTag("rugs")
	inst:AddTag("NOBLOCK")
	inst:AddTag("rotatableobject")
	
	if save_rotation then
		inst.Transform:SetFourFaced()
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

local function circle()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("half_circle")
    return inst
end

local function beard()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_beard")
    return inst
end

local function braid()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_braid")
    return inst
end

local function catcoon()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_catcoon")
    return inst
end

local function crime()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_crime")
    return inst
end

local function fur()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_fur")
    return inst
end

local function hedgehog()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_hedgehog")
    return inst
end

local function hoofprints()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_hoofprints")
    return inst
end

local function leather()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_leather")
    return inst
end

local function metal()
    local inst = common(false, true)
    inst.AnimState:PlayAnimation("rug_metal")
    return inst
end

local function moth()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_moth_eaten")
    return inst
end

local function nailbed()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_nailbed")
    return inst
end

local function octagon()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_octagon")
    return inst
end

local function oval()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_oval")
    return inst
end

local function porcupuss()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_porcupuss")
    return inst
end

local function rectangle()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_rectangle")
    return inst
end

local function round()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_round")
    return inst
end

local function rubbermat()
    local inst = common(false, true)
    inst.AnimState:PlayAnimation("rug_rubbermat")
    return inst
end

local function square()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_square")
    return inst
end

local function swirl()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_swirl")
    return inst
end

local function throneroom()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_throneroom")
    return inst
end

local function tiles()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_tiles")
    return inst
end

local function web()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_web")
    return inst
end

local function wormhole()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_wormhole")
    return inst
end

local function worn()
    local inst = common(true, true)
    inst.AnimState:PlayAnimation("rug_worn")
    return inst
end

local function antiquities()
    local inst = common2(true, true)
    inst.AnimState:PlayAnimation("idle_antiquities")
    return inst
end

local function bank()
    local inst = common2(true, true)
    inst.AnimState:PlayAnimation("idle_bank")
    return inst
end

local function deli()
    local inst = common2(true, true)
    inst.AnimState:PlayAnimation("idle_deli")
    return inst
end

local function flag()
    local inst = common2(true, true)
    inst.AnimState:PlayAnimation("idle_flag")
    return inst
end

local function florist()
    local inst = common2(true, true)
    inst.AnimState:PlayAnimation("idle_florist")
    return inst
end

local function general()
    local inst = common2(true, true)
    inst.AnimState:PlayAnimation("idle_general")
    return inst
end

local function gift()
    local inst = common2(true, true)
    inst.AnimState:PlayAnimation("idle_giftshop")
    return inst
end

local function hoofspa()
    local inst = common2(true, true)
    inst.AnimState:PlayAnimation("idle_hoofspa")
    return inst
end

local function old()
    local inst = common2(true, true)
    inst.AnimState:PlayAnimation("idle_old")
    return inst
end

local function produce()
    local inst = common2(true, true)
    inst.AnimState:PlayAnimation("idle_produce")
    return inst
end

local function tinker()
    local inst = common2(true, true)
    inst.AnimState:PlayAnimation("idle_tinker")
    return inst
end

local function rugplacefn(inst)
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
end

return Prefab("sap_rugs_circle", circle, assets),
Prefab("sap_rugs_beard", beard, assets),
Prefab("sap_rugs_braid", braid, assets),
Prefab("sap_rugs_catcoon", catcoon, assets),
Prefab("sap_rugs_crime", crime, assets),
Prefab("sap_rugs_fur", fur, assets),
Prefab("sap_rugs_hedgehog", hedgehog, assets),
Prefab("sap_rugs_hoofprints", hoofprints, assets),
Prefab("sap_rugs_leather", leather, assets),
Prefab("sap_rugs_metal", metal, assets),
Prefab("sap_rugs_moth", moth, assets),
Prefab("sap_rugs_nailbed", nailbed, assets),
Prefab("sap_rugs_octagon", octagon, assets),
Prefab("sap_rugs_oval", oval, assets),
Prefab("sap_rugs_porcupuss", porcupuss, assets),
Prefab("sap_rugs_rectangle", rectangle, assets),
Prefab("sap_rugs_round", round, assets),
Prefab("sap_rugs_rubbermat", rubbermat, assets),
Prefab("sap_rugs_square", square, assets),
Prefab("sap_rugs_swirl", swirl, assets),
Prefab("sap_rugs_throneroom", throneroom, assets),
Prefab("sap_rugs_tiles", tiles, assets),
Prefab("sap_rugs_web", web, assets),
Prefab("sap_rugs_wormhole", wormhole, assets),
Prefab("sap_rugs_worn", worn, assets),
Prefab("sap_rugs_antiquities", antiquities, assets),
Prefab("sap_rugs_bank", bank, assets),
Prefab("sap_rugs_deli", deli, assets),
Prefab("sap_rugs_flag", flag, assets),
Prefab("sap_rugs_florist", florist, assets),
Prefab("sap_rugs_general", general, assets),
Prefab("sap_rugs_gift", gift, assets),
Prefab("sap_rugs_hoofspa", hoofspa, assets),
Prefab("sap_rugs_old", old, assets),
Prefab("sap_rugs_produce", produce, assets),
Prefab("sap_rugs_tinker", tinker, assets),
MakePlacer("sap_rugs_circle_placer", "rugs", "rugs", "half_circle", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_beard_placer", "rugs", "rugs", "rug_beard", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_braid_placer", "rugs", "rugs", "rug_braid", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_catcoon_placer", "rugs", "rugs", "rug_catcoon", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_crime_placer", "rugs", "rugs", "rug_crime", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_fur_placer", "rugs", "rugs", "rug_fur", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_hedgehog_placer", "rugs", "rugs", "rug_hedgehog", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_hoofprints_placer", "rugs", "rugs", "rug_hoofprints", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_leather_placer", "rugs", "rugs", "rug_leather", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_metal_placer", "rugs", "rugs", "rug_metal", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_moth_placer", "rugs", "rugs", "rug_moth_eaten", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_nailbed_placer", "rugs", "rugs", "rug_nailbed", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_octagon_placer", "rugs", "rugs", "rug_octagon", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_oval_placer", "rugs", "rugs", "rug_oval", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_porcupuss_placer", "rugs", "rugs", "rug_porcupuss", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_rectangle_placer", "rugs", "rugs", "rug_rectangle", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_round_placer", "rugs", "rugs", "rug_round", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_rubbermat_placer", "rugs", "rugs", "rug_rubbermat", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_square_placer", "rugs", "rugs", "rug_square", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_swirl_placer", "rugs", "rugs", "rug_swirl", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_throneroom_placer", "rugs", "rugs", "rug_throneroom", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_tiles_placer", "rugs", "rugs", "rug_tiles", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_web_placer", "rugs", "rugs", "rug_web", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_wormhole_placer", "rugs", "rugs", "rug_wormhole", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_worn_placer", "rugs", "rugs", "rug_worn", true, nil, nil, nil, nil, 90),
MakePlacer("sap_rugs_antiquities_placer", "pig_shop_doormats", "pig_shop_doormats", "idle_antiquities", true, nil, nil, nil, nil, 90, rugplacefn),
MakePlacer("sap_rugs_bank_placer", "pig_shop_doormats", "pig_shop_doormats", "idle_bank", true, nil, nil, nil, nil, 90, rugplacefn),
MakePlacer("sap_rugs_deli_placer", "pig_shop_doormats", "pig_shop_doormats", "idle_deli", true, nil, nil, nil, nil, 90, rugplacefn),
MakePlacer("sap_rugs_flag_placer", "pig_shop_doormats", "pig_shop_doormats", "idle_flag", true, nil, nil, nil, nil, 90, rugplacefn),
MakePlacer("sap_rugs_florist_placer", "pig_shop_doormats", "pig_shop_doormats", "idle_florist", true, nil, nil, nil, nil, 90, rugplacefn),
MakePlacer("sap_rugs_general_placer", "pig_shop_doormats", "pig_shop_doormats", "idle_general", true, nil, nil, nil, nil, 90, rugplacefn),
MakePlacer("sap_rugs_gift_placer", "pig_shop_doormats", "pig_shop_doormats", "idle_giftshop", true, nil, nil, nil, nil, 90, rugplacefn),
MakePlacer("sap_rugs_hoofspa_placer", "pig_shop_doormats", "pig_shop_doormats", "idle_hoofspa", true, nil, nil, nil, nil, 90, rugplacefn),
MakePlacer("sap_rugs_old_placer", "pig_shop_doormats", "pig_shop_doormats", "idle_old", true, nil, nil, nil, nil, 90, rugplacefn),
MakePlacer("sap_rugs_produce_placer", "pig_shop_doormats", "pig_shop_doormats", "idle_produce", true, nil, nil, nil, nil, 90, rugplacefn),
MakePlacer("sap_rugs_tinker_placer", "pig_shop_doormats", "pig_shop_doormats", "idle_tinker", true, nil, nil, nil, nil, 90, rugplacefn)