local assets =
{
    Asset("ANIM", "anim/statue_small_type1_build.zip"), -- muse 1
    Asset("ANIM", "anim/statue_small_type2_build.zip"), -- muse 2
    Asset("ANIM", "anim/statue_small_type3_build.zip"), -- urn
    Asset("ANIM", "anim/statue_small_type4_build.zip"), -- pawn
    
	Asset("ANIM", "anim/statue_small.zip"),
	Asset("ANIM", "anim/sculpture_pawn.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
    "marble",
    "rock_break_fx",
}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("low", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("med", true)
	else
		inst.AnimState:PlayAnimation("full", true)
	end
end

local function onwork2(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("low", false)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("med", false)
	else
		inst.AnimState:PlayAnimation("full")
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)
	local pos = inst:GetPosition()
	SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("full")
end

local function type1fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_small.png")

    MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("statue_small")
    inst.AnimState:SetBuild("statue_small")
	inst.AnimState:OverrideSymbol("swap_statue", "statue_small_type1_build", "swap_statue")
    inst.AnimState:PlayAnimation("full")
	
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
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

local function type2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_small.png")

    MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("statue_small")
    inst.AnimState:SetBuild("statue_small")
	inst.AnimState:OverrideSymbol("swap_statue", "statue_small_type2_build", "swap_statue")
    inst.AnimState:PlayAnimation("full")
	
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
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

local function type3fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_small.png")

    MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("statue_small")
    inst.AnimState:SetBuild("statue_small")
	inst.AnimState:OverrideSymbol("swap_statue", "statue_small_type3_build", "swap_statue")
    inst.AnimState:PlayAnimation("full")
	
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
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

local function type4fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_small.png")

    MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("statue_small")
    inst.AnimState:SetBuild("statue_small")
	inst.AnimState:OverrideSymbol("swap_statue", "statue_small_type4_build", "swap_statue")
    inst.AnimState:PlayAnimation("full")
	
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
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

local function type5fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue_small.png")

    MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("pawn")
    inst.AnimState:SetBuild("sculpture_pawn")
    inst.AnimState:PlayAnimation("full")
	
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
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork2)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("kyno_statue_marble", type1fn, assets, prefabs),
Prefab("kyno_statue_marble_muse", type2fn, assets, prefabs),
Prefab("kyno_statue_marble_urn", type3fn, assets, prefabs),
Prefab("kyno_statue_marble_pawn", type4fn, assets, prefabs),
Prefab("kyno_statue_marble_pawn2", type5fn, assets, prefabs),
MakePlacer("kyno_statue_marble_placer", "statue_small", "statue_small_type1_build", "full"),
MakePlacer("kyno_statue_marble_muse_placer", "statue_small", "statue_small_type2_build", "full"),
MakePlacer("kyno_statue_marble_urn_placer", "statue_small", "statue_small_type3_build", "full"),
MakePlacer("kyno_statue_marble_pawn_placer", "statue_small", "statue_small_type4_build", "full"),
MakePlacer("kyno_statue_marble_pawn2_placer", "pawn", "sculpture_pawn", "full")