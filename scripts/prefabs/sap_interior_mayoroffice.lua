require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/interior_wall_decals_mayorsoffice.zip"),
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
	
    inst.AnimState:SetBank("wall_decals_mayorsoffice")
    inst.AnimState:SetBuild("interior_wall_decals_mayorsoffice")
    
	inst:AddTag("structure")
	inst:AddTag("mayoroffice_decor")
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

local function special(burnable, save_rotation, radius_long, shadow)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(0.6)
    inst.Light:SetRadius(2.0)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 150/255)
	inst.on = false

    if shadow then
		inst.DynamicShadow:SetSize(2.5, 1.5)
	end

	if radius_long then
		MakeObstaclePhysics(inst, 2)
	else
		MakeObstaclePhysics(inst, .6)
	end
	
    inst.AnimState:SetBank("wall_decals_mayorsoffice")
    inst.AnimState:SetBuild("interior_wall_decals_mayorsoffice")
	inst.AnimState:Hide("lantern_overlay")
    
	inst:AddTag("structure")
	inst:AddTag("mayoroffice_decor")
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
	inst.components.workable:SetOnWorkCallback(onhit)
	
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

local function bookcase()
    local inst = common(true, true, true, false)
    inst.AnimState:PlayAnimation("bookcase_backwall")
    return inst
end

local function desk()
    local inst = special(true, true, true, true)
    inst.AnimState:PlayAnimation("desk")
    return inst
end

local function mayorofficeplacefn(inst)
	inst.AnimState:Hide("lantern_overlay")
end

return Prefab("sap_mayoroffice_bookcase", bookcase, assets),
Prefab("sap_mayoroffice_desk", desk, assets),
MakePlacer("sap_mayoroffice_bookcase_placer", "wall_decals_mayorsoffice", "interior_wall_decals_mayorsoffice", "bookcase_backwall"),
MakePlacer("sap_mayoroffice_desk_placer", "wall_decals_mayorsoffice", "interior_wall_decals_mayorsoffice", "desk", false, false, nil, nil, nil, mayorofficeplacefn)