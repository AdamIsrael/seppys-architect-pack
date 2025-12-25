require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/statue_maxwell.zip"),
    Asset("ANIM", "anim/statue_maxwell_build.zip"),
    Asset("ANIM", "anim/statue_maxwell_vine_build.zip"),
    
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

local function OnWork(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PlayAnimation("hit_low")
        inst.AnimState:PushAnimation("idle_low")
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PlayAnimation("hit_med")
        inst.AnimState:PushAnimation("idle_med")
    else
        inst.AnimState:PlayAnimation("hit_full")
        inst.AnimState:PushAnimation("idle_full")
    end
end

local function OnBuilt(inst)
	inst.AnimState:PushAnimation("idle_full")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue.png")

    MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("statue_maxwell")
    inst.AnimState:SetBuild("statue_maxwell_build")
    inst.AnimState:PlayAnimation("idle_full")
	
	inst.entity:AddTag("maxwell")
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")
	
	inst:SetPrefabNameOverride("statuemaxwell")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "STATUEMAXWELL"
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

    return inst
end

local function rosefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statue.png")

    MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("statue_maxwell")
    inst.AnimState:SetBuild("statue_maxwell_build")
	inst.AnimState:AddOverrideBuild("statue_maxwell_vine_build")
    inst.AnimState:PlayAnimation("idle_full")
	
	inst.entity:AddTag("maxwell")
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")
	
	-- inst:SetPrefabNameOverride("statuemaxwell")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "STATUEMAXWELL"
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

    return inst
end

local function RosePlacerPostinit(inst)
	inst.AnimState:AddOverrideBuild("statue_maxwell_vine_build")
end

return Prefab("kyno_statuemaxwell", fn, assets, prefabs),
Prefab("kyno_statuemaxwell_rose", rosefn, assets, prefabs),
MakePlacer("kyno_statuemaxwell_placer", "statue_maxwell", "statue_maxwell_build", "idle_full"),
MakePlacer("kyno_statuemaxwell_rose_placer", "statue_maxwell", "statue_maxwell_build", "idle_full", false, nil, nil, nil, nil, nil, RosePlacerPostinit)