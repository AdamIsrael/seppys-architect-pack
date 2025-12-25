require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/interior_floorlamp.zip"),
	Asset("ANIM", "anim/interior_floor_decor.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
    local rotation = inst.Transform:GetRotation()
    inst.Transform:SetRotation((rotation + 180) % 360)
end

local function TurnOn(inst)
	inst.Light:Enable(true)
	inst.AnimState:Show("lantern_overlay")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_on")
	inst.on = true
end

local function TurnOff(inst)
	inst.Light:Enable(false)
	inst.AnimState:Hide("lantern_overlay")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/lantern_off")
	inst.on = false
end

local function GetStatus(inst, viewer)
	if inst.on then
		return "ON"
	else
		return "OFF"
	end
end

local function OnSave(inst, data)
    local refs = {}
    return refs
end

local function OnLoad(inst, data)
end

local function CanInteract(inst)
	if inst.components.machine.ison then
		return false
	end
	return true
end

local function common(burnable, save_rotation)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(0.6)
    inst.Light:SetRadius(12)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 150/255)
	inst.on = false

    MakeObstaclePhysics(inst, .4)
	
    inst.AnimState:SetBank("interior_floorlamp")
    inst.AnimState:SetBuild("interior_floorlamp")
	inst.AnimState:Hide("lantern_overlay")
    
	inst:AddTag("structure")
	inst:AddTag("groundlamp")
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
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5
	
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
	
	inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
	
    return inst
end

local function festive(burnable, save_rotation)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(0.6)
    inst.Light:SetRadius(2.5)
    inst.Light:Enable(true)
    inst.Light:SetColour(180/255, 195/255, 150/255)
	inst.on = true

    MakeObstaclePhysics(inst, 1.2)
	
    inst.AnimState:SetBank("interior_floorlamp")
    inst.AnimState:SetBuild("interior_floorlamp")
    
	inst:AddTag("structure")
	inst:AddTag("groundlamp")
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
	
	inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
	
    return inst
end

local function special(burnable, save_rotation)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(0.6)
    inst.Light:SetRadius(12)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 150/255)
	inst.on = false

    MakeObstaclePhysics(inst, .4)
	
    inst.AnimState:SetBank("interior_floor_decor")
    inst.AnimState:SetBuild("interior_floor_decor")
	inst.AnimState:Hide("lantern_overlay")
    
	inst:AddTag("structure")
	inst:AddTag("groundlamp")
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
	
	inst:AddComponent("machine")
	inst.components.machine.turnonfn = TurnOn
	inst.components.machine.turnofffn = TurnOff
	inst.components.machine.caninteractfn = CanInteract
	inst.components.machine.cooldowntime = 0.5
	
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
	
	inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
	
    return inst
end

local function festivetree()
    local inst = festive(false, true)
    inst.AnimState:PlayAnimation("festivetree_idle", true)
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("winter_tree.png")
	inst.AnimState:Hide("lantern_overlay")
    return inst
end

local function dualembroidered()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_2embroidered")
    return inst
end

local function dualfringes()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_2fringes")
    return inst
end

local function dualupturn()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_2upturns")
    return inst
end

local function adjustable()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_adjustable")
    return inst
end

local function bellshade()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_bellshade")
    return inst
end

local function candelabra()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_candelabra")
    return inst
end

local function ceramic()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_ceramic")
    return inst
end

local function crystals()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_crystals")
    return inst
end

local function downbridge()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_downbridge")
    return inst
end

local function edison()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_edison")
    return inst
end

local function elizabethan()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_elizabethan")
    return inst
end

local function fringe()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_fringe")
    return inst
end

local function glass()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_glass")
    return inst
end

local function gothic()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_gothic")
    return inst
end

local function orb()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_orb")
    return inst
end

local function rightangles()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_rightangles")
    return inst
end

local function spool()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_spool")
    return inst
end

local function stainglass()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_stainglass")
    return inst
end

local function upturn()
	local inst = common(false, true)
    inst.AnimState:PlayAnimation("floorlamp_upturn")
    return inst
end

local function fancy()
	local inst = special(false, true)
    inst.AnimState:PlayAnimation("lamp")
    return inst
end

local function lampplacefn(inst)
	inst.AnimState:Hide("lantern_overlay")
end

return Prefab("kyno_lamps_festivetree", festivetree, assets),
Prefab("kyno_lamps_dualembroidered", dualembroidered, assets),
Prefab("kyno_lamps_dualfringes", dualfringes, assets),
Prefab("kyno_lamps_dualupturns", dualupturn, assets),
Prefab("kyno_lamps_adjustable", adjustable, assets),
Prefab("kyno_lamps_bellshade", bellshade, assets),
Prefab("kyno_lamps_candelabra", candelabra, assets),
Prefab("kyno_lamps_ceramic", ceramic, assets),
Prefab("kyno_lamps_crystals", crystals, assets),
Prefab("kyno_lamps_downbridge", downbridge, assets),
Prefab("kyno_lamps_edison", edison, assets),
Prefab("kyno_lamps_elizabethan", elizabethan, assets),
Prefab("kyno_lamps_fringe", fringe, assets),
Prefab("kyno_lamps_glass", glass, assets),
Prefab("kyno_lamps_gothic", gothic, assets),
Prefab("kyno_lamps_orb", orb, assets),
Prefab("kyno_lamps_rightangles", rightangles, assets),
Prefab("kyno_lamps_spool", spool, assets),
Prefab("kyno_lamps_stainglass", stainglass, assets),
Prefab("kyno_lamps_upturn", upturn, assets),
Prefab("kyno_lamps_fancy", fancy, assets),
MakePlacer("kyno_lamps_festivetree_placer", "interior_floorlamp", "interior_floorlamp", "festivetree_idle", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_dualembroidered_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_2embroidered", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_dualfringes_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_2fringes", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_dualupturns_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_2upturns", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_adjustable_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_adjustable", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_bellshade_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_bellshade", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_candelabra_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_candelabra", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_ceramic_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_ceramic", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_crystals_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_crystals", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_downbridge_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_downbridge", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_edison_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_edison", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_elizabethan_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_elizabethan", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_fringe_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_fringe", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_glass_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_glass", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_gothic_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_gothic", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_orb_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_orb", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_rightangles_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_rightangles", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_spool_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_spool", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_stainglass_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_stainglass", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_upturn_placer", "interior_floorlamp", "interior_floorlamp", "floorlamp_upturn", nil, nil, nil, nil, nil, "two", lampplacefn),
MakePlacer("kyno_lamps_fancy_placer", "interior_floor_decor", "interior_floor_decor", "lamp", nil, nil, nil, nil, nil, "two", lampplacefn)