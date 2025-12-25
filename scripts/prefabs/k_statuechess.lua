local assets =
{
    Asset("ANIM", "anim/sculpture_rook.zip"),
	Asset("ANIM", "anim/kyno_sculpture_knight.zip"),
	Asset("ANIM", "anim/kyno_sculpture_bishop.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "marble",
    "rock_break_fx",
}

local function onwork(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
		inst:RemoveTag("statue_full")
		inst:RemoveTag("statue_med")
		inst:RemoveTag("statue_low")
		inst.med = false
		inst.low = false
		inst.full = false
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PlayAnimation("low")
        inst.AnimState:PushAnimation("low")
		inst:RemoveTag("statue_full")
		inst:RemoveTag("statue_med")
		inst:AddTag("statue_low")
		inst.med = false
		inst.low = true
		inst.full = false
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PlayAnimation("med")
        inst.AnimState:PushAnimation("med")
		inst:RemoveTag("statue_full")
		inst:AddTag("statue_med")
		inst.med = true
		inst.low = false
		inst.full = false
    else
        inst.AnimState:PlayAnimation("full")
        inst.AnimState:PushAnimation("full")
		inst:AddTag("statue_full")
		inst.med = false
		inst.low = false
		inst.full = true
    end
end

local function onsave(inst, data)
	if inst.full then
		data.full = true
	end
	if inst.med then
		data.med = true
	end
	if inst.low then
		data.low = true
	end
end

local function onload(inst, data)
	if data and data.full then
		inst.full = true
		inst.AnimState:PlayAnimation("full")
	end
	if data and data.med then
		inst.med = true
		inst.AnimState:PlayAnimation("med")
	end
	if data and data.low then
		inst.low = true
		inst.AnimState:PlayAnimation("low")
	end
end

local function rookfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("sculpture_rookbody_fixed.png")

    MakeObstaclePhysics(inst, 1.575)
	inst.Transform:SetFourFaced()
	inst.AnimState:SetScale(.7, .7, .7)

    inst.AnimState:SetBank("rook")
    inst.AnimState:SetBuild("sculpture_rook")
    inst.AnimState:PlayAnimation("full")
	
	inst.entity:AddTag("statuerook")
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "STATUE_MARBLE"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable.savestate = true
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end

local function knightfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("sculpture_knightbody_fixed.png")

    MakeObstaclePhysics(inst, .66)
	inst.Transform:SetFourFaced()
	inst.AnimState:SetScale(1, 1, 1)

    inst.AnimState:SetBank("kyno_knight")
    inst.AnimState:SetBuild("kyno_sculpture_knight")
    inst.AnimState:PlayAnimation("full")
	
	inst.entity:AddTag("statueknight")
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "STATUE_MARBLE"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable.savestate = true
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end

local function bishopfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("sculpture_bishopbody_fixed.png")

    MakeObstaclePhysics(inst, .70)
	inst.Transform:SetFourFaced()
	inst.AnimState:SetScale(1, 1, 1)

    inst.AnimState:SetBank("kyno_bishop")
    inst.AnimState:SetBuild("kyno_sculpture_bishop")
    inst.AnimState:PlayAnimation("full")
	
	inst.entity:AddTag("statuebishop")
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "STATUE_MARBLE"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable.savestate = true
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end

local function rookplacetestfn(inst)
	inst.AnimState:SetScale(.7, .7, .7)
end

local function knightplacetestfn(inst)
	inst.AnimState:SetScale(1, 1, 1)
end

local function bishopplacetestfn(inst)
	inst.AnimState:SetScale(1, 1, 1)
end

return Prefab("kyno_statuerook", rookfn, assets, prefabs),
Prefab("kyno_statueknight", knightfn, assets, prefabs),
Prefab("kyno_statuebishop", bishopfn, assets, prefabs),
MakePlacer("kyno_statuerook_placer", "rook", "sculpture_rook", "full", false, nil, nil, nil, nil, nil, rookplacetestfn),
MakePlacer("kyno_statueknight_placer", "kyno_knight", "kyno_sculpture_knight", "full", false, nil, nil, nil, nil, nil, knightplacetestfn),
MakePlacer("kyno_statuebishop_placer", "kyno_bishop", "kyno_sculpture_bishop", "full", false, nil, nil, nil, nil, nil, bishopplacetestfn)