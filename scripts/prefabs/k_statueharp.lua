require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/statue_small.zip"),
    Asset("ANIM", "anim/statue_small_harp_build.zip"),
	Asset("ANIM", "anim/statue_small_harp_vine_build.zip"),
    
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

local function OnWorked(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    else
        inst.AnimState:PlayAnimation((workleft < TUNING.MARBLEPILLAR_MINE / 3 and "low") or
		(workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 and "med") or "full")
    end
end

local function OnWorkLoad(inst)
    OnWorked(inst, nil, inst.components.workable.workleft)
end

local function fn()
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
    inst.AnimState:OverrideSymbol("swap_statue", "statue_small_harp_build", "swap_statue")
    inst.AnimState:PlayAnimation("full")
	
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")
	
	inst:SetPrefabNameOverride("statueharp")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "STATUEHARP"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
    inst.components.workable:SetOnWorkCallback(OnWorked)
    inst.components.workable:SetOnLoadFn(OnWorkLoad)
    inst.components.workable.savestate = true

    MakeHauntableWork(inst)

    return inst
end

local function rosefn()
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
    inst.AnimState:OverrideSymbol("swap_statue", "statue_small_harp_build", "swap_statue")
	inst.AnimState:AddOverrideBuild("statue_small_harp_vine_build")
    inst.AnimState:PlayAnimation("full")
	
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")
	
	-- inst:SetPrefabNameOverride("statueharp")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "STATUEHARP"
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
    inst.components.workable:SetOnWorkCallback(OnWorked)
    inst.components.workable:SetOnLoadFn(OnWorkLoad)
    inst.components.workable.savestate = true

    MakeHauntableWork(inst)

    return inst
end

local function RosePlacerPostinit(inst)
	inst.AnimState:AddOverrideBuild("statue_small_harp_vine_build")
end

return Prefab("sap_statueharp", fn, assets, prefabs),
Prefab("sap_statueharp_rose", rosefn, assets, prefabs),
MakePlacer("sap_statueharp_placer", "statue_small", "statue_small_harp_build", "full"),
MakePlacer("sap_statueharp_rose_placer", "statue_small", "statue_small_harp_build", "full", false, nil, nil, nil, nil, nil, RosePlacerPostinit)