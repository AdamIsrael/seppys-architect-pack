require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/interior_wall_decals_accademia.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("SOUNDPACKAGE", "sound/tap_sounds.fev"),
	Asset("SOUND", "sound/tap_sounds.fsb"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    local rotation = inst.Transform:GetRotation()
    inst.Transform:SetRotation((rotation + 180) % 360)
end

local function OnBuiltAnvil(inst)
	inst.SoundEmitter:PlaySound("tap_sounds/anvil/anvil_place")
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
		MakeObstaclePhysics(inst, .5)
	end
	
    inst.AnimState:SetBank("wall_decals_accademia")
    inst.AnimState:SetBuild("interior_wall_decals_accademia")
    
	inst:AddTag("structure")
	inst:AddTag("accademia_decor")
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

local s = .90
local s1 = 1.1
local s2 = 1.2

local function anvil()
    local inst = common(false, true, false, true)
    inst.AnimState:PlayAnimation("anvil")
	inst.AnimState:SetScale(s1, s1, s1)
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:ListenForEvent("onbuilt", OnBuiltAnvil)
    return inst
end

local function pottingwheel()
    local inst = common(true, true, false, true)
    inst.AnimState:PlayAnimation("pottingwheel")
	inst.AnimState:SetScale(s, s, s)
    return inst
end

local function pottingwheelurn()
    local inst = common(true, true, false, true)
    inst.AnimState:PlayAnimation("pottingwheel_urn")
	inst.AnimState:SetScale(s, s, s)
    return inst
end

local function pottingwheelclay()
    local inst = common(true, true, false, true)
    inst.AnimState:PlayAnimation("pottingwheel_wetclay")
	inst.AnimState:SetScale(s, s, s)
    return inst
end

local function pottingwheelwip()
    local inst = common(true, true, false, true)
    inst.AnimState:PlayAnimation("pottingwheel_wip")
	inst.AnimState:SetScale(s, s, s)
    return inst
end

local function vase()
    local inst = common(false, true, false, false)
    inst.AnimState:PlayAnimation("sculpture_vase")
	inst.AnimState:SetScale(s2, s2, s2)
    return inst
end

local function stoneblock()
    local inst = common(false, true, false, false)
    inst.AnimState:PlayAnimation("stoneblock")
	inst.AnimState:SetScale(s2, s2, s2)
    return inst
end

local function woodtable()
    local inst = common(true, true, false, true)
    inst.AnimState:PlayAnimation("table")
	inst.AnimState:SetScale(s, s, s)
    return inst
end

local function booktable()
    local inst = common(true, true, false, true)
    inst.AnimState:PlayAnimation("table_books")
	inst.AnimState:SetScale(s, s, s)
    return inst
end

local function wiptable()
    local inst = common(true, true, false, true)
    inst.AnimState:PlayAnimation("table_wip")
	inst.AnimState:SetScale(s, s, s)
    return inst
end

local function velvetback()
    local inst = common(false, true, true, false)
    inst.AnimState:PlayAnimation("velvetrope_backwall")
	inst.AnimState:SetScale(s1, s1, s1)
    return inst
end

local function velvetside()
    local inst = common(false, true, true, false)
    inst.AnimState:PlayAnimation("velvetrope_sidewall")
	inst.AnimState:SetScale(s1, s1, s1)
    return inst
end

local function accademiaplacefn(inst)
	inst.AnimState:SetScale(s, s, s)
end

local function accademiaplacefn1(inst)
	inst.AnimState:SetScale(s1, s1, s1)
end

local function accademiaplacefn2(inst)
	inst.AnimState:SetScale(s2, s2, s2)
end

return Prefab("kyno_accademia_anvil", anvil, assets),
Prefab("kyno_accademia_pottingwheel", pottingwheel, assets),
Prefab("kyno_accademia_pottingwheelurn", pottingwheelurn, assets),
Prefab("kyno_accademia_pottingwheelclay", pottingwheelclay, assets),
Prefab("kyno_accademia_pottingwheelwip", pottingwheelwip, assets),
Prefab("kyno_accademia_vase", vase, assets),
Prefab("kyno_accademia_stoneblock", stoneblock, assets),
Prefab("kyno_accademia_woodtable", woodtable, assets),
Prefab("kyno_accademia_booktable", booktable, assets),
Prefab("kyno_accademia_wiptable", wiptable, assets),
Prefab("kyno_accademia_velvetback", velvetback, assets),
Prefab("kyno_accademia_velvetside", velvetside, assets),
MakePlacer("kyno_accademia_anvil_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "anvil", nil, nil, nil, nil, nil, "two", accademiaplacefn1),
MakePlacer("kyno_accademia_pottingwheel_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "pottingwheel", nil, nil, nil, nil, nil, "two", accademiaplacefn),
MakePlacer("kyno_accademia_pottingwheelurn_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "pottingwheel_urn", nil, nil, nil, nil, nil, "two", accademiaplacefn),
MakePlacer("kyno_accademia_pottingwheelclay_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "pottingwheel_wetclay", nil, nil, nil, nil, nil, "two", accademiaplacefn),
MakePlacer("kyno_accademia_pottingwheelwip_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "pottingwheel_wip", nil, nil, nil, nil, nil, "two", accademiaplacefn),
MakePlacer("kyno_accademia_vase_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "sculpture_vase", nil, nil, nil, nil, nil, "two", accademiaplacefn2),
MakePlacer("kyno_accademia_stoneblock_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "stoneblock", nil, nil, nil, nil, nil, "two", accademiaplacefn2),
MakePlacer("kyno_accademia_woodtable_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "table", nil, nil, nil, nil, nil, "two", accademiaplacefn),
MakePlacer("kyno_accademia_booktable_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "table_books", nil, nil, nil, nil, nil, "two", accademiaplacefn),
MakePlacer("kyno_accademia_wiptable_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "table_wip", nil, nil, nil, nil, nil, "two", accademiaplacefn),
MakePlacer("kyno_accademia_velvetback_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "velvetrope_backwall", nil, nil, nil, nil, nil, "two", accademiaplacefn1),
MakePlacer("kyno_accademia_velvetside_placer", "wall_decals_accademia", "interior_wall_decals_accademia", "velvetrope_sidewall", nil, nil, nil, nil, nil, "two", accademiaplacefn1)