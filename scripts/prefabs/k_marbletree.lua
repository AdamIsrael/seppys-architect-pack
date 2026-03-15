local assets =
{
    Asset("ANIM", "anim/marble_trees.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "marble",
    "rock_break_fx",
}

local function onwork1(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLETREE_MINE / 3 then
        inst.AnimState:PlayAnimation("low_1")
    elseif workleft < TUNING.MARBLETREE_MINE * 2 / 3 then
        inst.AnimState:PlayAnimation("med_1")
    else
        inst.AnimState:PlayAnimation("full_1")
    end
end

local function onwork2(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLETREE_MINE / 3 then
        inst.AnimState:PlayAnimation("low_2")
    elseif workleft < TUNING.MARBLETREE_MINE * 2 / 3 then
        inst.AnimState:PlayAnimation("med_2")
    else
        inst.AnimState:PlayAnimation("full_2")
    end
end

local function onwork3(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLETREE_MINE / 3 then
        inst.AnimState:PlayAnimation("low_3")
    elseif workleft < TUNING.MARBLETREE_MINE * 2 / 3 then
        inst.AnimState:PlayAnimation("med_3")
    else
        inst.AnimState:PlayAnimation("full_3")
    end
end

local function onwork4(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLETREE_MINE / 3 then
        inst.AnimState:PlayAnimation("low_4")
    elseif workleft < TUNING.MARBLETREE_MINE * 2 / 3 then
        inst.AnimState:PlayAnimation("med_4")
    else
        inst.AnimState:PlayAnimation("full_4")
    end
end

local function tree1fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("marbletree.png")

    MakeObstaclePhysics(inst, 0.1)
	MakeSnowCoveredPristine(inst)

    inst.AnimState:SetBank("marble_trees")
    inst.AnimState:SetBuild("marble_trees")
    inst.AnimState:PlayAnimation("full_1")
	
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")
	
	inst:SetPrefabNameOverride("marbletree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork1)
	
	MakeSnowCovered(inst)

    return inst
end

local function tree2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("marbletree.png")

    MakeObstaclePhysics(inst, 0.1)
	MakeSnowCoveredPristine(inst)

    inst.AnimState:SetBank("marble_trees")
    inst.AnimState:SetBuild("marble_trees")
    inst.AnimState:PlayAnimation("full_2")
	
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")
	
	inst:SetPrefabNameOverride("marbletree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork2)
	
	MakeSnowCovered(inst)

    return inst
end

local function tree3fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("marbletree.png")

    MakeObstaclePhysics(inst, 0.1)
	MakeSnowCoveredPristine(inst)

    inst.AnimState:SetBank("marble_trees")
    inst.AnimState:SetBuild("marble_trees")
    inst.AnimState:PlayAnimation("full_3")
	
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")
	
	inst:SetPrefabNameOverride("marbletree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork3)
	
	MakeSnowCovered(inst)

    return inst
end

local function tree4fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("marbletree.png")

    MakeObstaclePhysics(inst, 0.1)
	MakeSnowCoveredPristine(inst)

    inst.AnimState:SetBank("marble_trees")
    inst.AnimState:SetBuild("marble_trees")
    inst.AnimState:PlayAnimation("full_4")
	
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")
	
	inst:SetPrefabNameOverride("marbletree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork4)
	
	MakeSnowCovered(inst)

    return inst
end

return Prefab("sap_marbletree_1", tree1fn, assets, prefabs),
Prefab("sap_marbletree_2", tree2fn, assets, prefabs),
Prefab("sap_marbletree_3", tree3fn, assets, prefabs),
Prefab("sap_marbletree_4", tree4fn, assets, prefabs)