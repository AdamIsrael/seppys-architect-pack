local assets =
{
    -- Asset("ANIM", "anim/statue_small.zip"),
	Asset("ANIM", "anim/kyno_statueangel_build.zip"),
    
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
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PlayAnimation("low")
        inst.AnimState:PushAnimation("low")
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PlayAnimation("med")
        inst.AnimState:PushAnimation("med")
    else
        inst.AnimState:PlayAnimation("full")
        inst.AnimState:PushAnimation("full")
    end
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("full")
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

    inst.AnimState:SetBank("kyno_statueangel")
    inst.AnimState:SetBuild("kyno_statueangel_build")
    inst.AnimState:PlayAnimation("full", false)
	
	inst.entity:AddTag("angel")
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "STATUEHARP"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("sap_statueangel", fn, assets, prefabs),
MakePlacer("sap_statueangel_placer", "kyno_statueangel", "kyno_statueangel_build", "full")