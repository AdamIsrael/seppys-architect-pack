local assets =
{
    Asset("ANIM", "anim/antlion_sinkhole.zip"),
}

local prefabs =
{
    "sinkhole_spawn_fx_1",
    "sinkhole_spawn_fx_2",
    "sinkhole_spawn_fx_3",
    "mining_ice_fx",
    "mining_fx",
    "mining_moonglass_fx",
}

local function dig_up(inst, chopper)
	inst:Remove()
	inst.components.lootdropper:DropLoot()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Transform:SetEightFaced()
	inst:SetDeployExtraSpacing(4)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("sinkhole.png")

    inst.AnimState:SetBank("sinkhole")
    inst.AnimState:SetBuild("antlion_sinkhole")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)

    inst:AddTag("antlion_sinkhole")
    inst:AddTag("antlion_sinkhole_blocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("unevenground")
    inst.components.unevenground.radius = TUNING.ANTLION_SINKHOLE.UNEVENGROUND_RADIUS
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

    return inst
end

return Prefab("sap_antlionsinkhole", fn, assets, prefabs),
MakePlacer("sap_antlionsinkhole_placer", "sinkhole", "antlion_sinkhole", "idle", true, nil, nil, nil, 90, nil)