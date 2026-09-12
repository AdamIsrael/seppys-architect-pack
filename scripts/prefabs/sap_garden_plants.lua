require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_garden_plants.zip"),
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

local function common(burnable, save_rotation, garden_desc, minimap_plant)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	if minimap_plant then
		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon("kyno_garden_pot.tex")
	end

	MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("kyno_garden_plants")
    inst.AnimState:SetBuild("kyno_garden_plants")
    
	inst:AddTag("structure")
	inst:AddTag("garden_plants")
	
	if save_rotation then
		inst.Transform:SetTwoFaced()
	end
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	if garden_desc then
		inst.components.inspectable.nameoverride = "KYNO_GARDEN_PLANT"
	end
	
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

local function blank()
    local inst = common(false, true, false, true)
    inst.AnimState:PlayAnimation("blank")
    return inst
end

local function sunflower()
    local inst = common(true, true, true, true)
    inst.AnimState:PlayAnimation("sunflower")
    return inst
end

local function handcar()
    local inst = common(false, true, false, false)
    inst.AnimState:PlayAnimation("handcar")
    return inst
end

local function frozen()
    local inst = common(true, true, true, true)
    inst.AnimState:PlayAnimation("frozen")
    return inst
end

local function spray()
    local inst = common(true, true, false, false)
    inst.AnimState:PlayAnimation("spray")
    return inst
end

local function dragon()
    local inst = common(true, true, true, true)
    inst.AnimState:PlayAnimation("dragon")
    return inst
end

local function potato()
    local inst = common(true, true, true, true)
    inst.AnimState:PlayAnimation("potato")
    return inst
end

local function whiteflower()
    local inst = common(true, true, true, true)
    inst.AnimState:PlayAnimation("whiteflower")
    return inst
end

local function pepper()
    local inst = common(true, true, true, true)
    inst.AnimState:PlayAnimation("pepper")
    return inst
end

local function greenflower()
    local inst = common(true, true, true, true)
    inst.AnimState:PlayAnimation("greenflower")
    return inst
end

local function doublesunflower()
    local inst = common(true, true, true, true)
    inst.AnimState:PlayAnimation("doublesunflower")
    return inst
end

local function greenie()
    local inst = common(true, true, true, true)
    inst.AnimState:PlayAnimation("greenie")
    return inst
end

return Prefab("sap_garden_blank", blank, assets),
Prefab("sap_garden_sunflower", sunflower, assets),
Prefab("sap_garden_handcar", handcar, assets),
Prefab("sap_garden_frozen", frozen, assets),
Prefab("sap_garden_spray", spray, assets),
Prefab("sap_garden_dragon", dragon, assets),
Prefab("sap_garden_potato", potato, assets),
Prefab("sap_garden_whiteflower", whiteflower, assets),
Prefab("sap_garden_pepper", pepper, assets),
Prefab("sap_garden_greenflower", greenflower, assets),
Prefab("sap_garden_doublesunflower", doublesunflower, assets),
Prefab("sap_garden_greenie", greenie, assets),
MakePlacer("sap_garden_blank_placer", "kyno_garden_plants", "kyno_garden_plants", "blank"),
MakePlacer("sap_garden_sunflower_placer", "kyno_garden_plants", "kyno_garden_plants", "sunflower"),
MakePlacer("sap_garden_handcar_placer", "kyno_garden_plants", "kyno_garden_plants", "handcar"),
MakePlacer("sap_garden_frozen_placer", "kyno_garden_plants", "kyno_garden_plants", "frozen"),
MakePlacer("sap_garden_spray_placer", "kyno_garden_plants", "kyno_garden_plants", "spray"),
MakePlacer("sap_garden_dragon_placer", "kyno_garden_plants", "kyno_garden_plants", "dragon"),
MakePlacer("sap_garden_potato_placer", "kyno_garden_plants", "kyno_garden_plants", "potato"),
MakePlacer("sap_garden_whiteflower_placer", "kyno_garden_plants", "kyno_garden_plants", "whiteflower"),
MakePlacer("sap_garden_pepper_placer", "kyno_garden_plants", "kyno_garden_plants", "pepper"),
MakePlacer("sap_garden_greenflower_placer", "kyno_garden_plants", "kyno_garden_plants", "greenflower"),
MakePlacer("sap_garden_doublesunflower_placer", "kyno_garden_plants", "kyno_garden_plants", "doublesunflower"),
MakePlacer("sap_garden_greenie_placer", "kyno_garden_plants", "kyno_garden_plants", "greenie")