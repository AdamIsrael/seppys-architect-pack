require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_driftwood_arrowsign_post.zip"),
    Asset("ANIM", "anim/kyno_driftwood_arrowsign_panel.zip"),
    Asset("ANIM", "anim/ui_board_driftwood_5x3.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "collapse_small",
    "kyno_driftwood_arrowsign_panel",
}

local function OnHammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
	
    inst.components.lootdropper:DropLoot()
	
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function OnHit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
    end
end

local function OnSave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function OnLoadPostPass(inst, newents, data)
    if inst.components.savedrotation then
        local savedrotation = data ~= nil and data.savedrotation ~= nil and data.savedrotation.rotation or 0
        inst.components.savedrotation:ApplyPostPassRotation(savedrotation)
    end
end

local function OnBuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/sign_craft")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_driftwood_sign.tex")

    MakeObstaclePhysics(inst, .2)
	inst.Transform:SetEightFaced()

    inst.AnimState:SetBank("sign_arrow_post")
    inst.AnimState:SetBuild("kyno_driftwood_arrowsign_post")
    inst.AnimState:PlayAnimation("idle")

    MakeSnowCoveredPristine(inst)

    inst:AddTag("structure")
    inst:AddTag("sign")
    inst:AddTag("directionsign")
    inst:AddTag("_writeable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:RemoveTag("_writeable")

	inst:AddComponent("inspectable")
    inst:AddComponent("writeable")
    inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(4)

	inst:ListenForEvent("onbuilt", OnBuilt)

	MakeSnowCovered(inst)
	MakeHauntableWork(inst)
    MakeSmallBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)
	
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

local function panelfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Transform:SetEightFaced()

    inst.AnimState:SetBank("sign_arrow_panel")
    inst.AnimState:SetBuild("kyno_driftwood_arrowsign_panel")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sign")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("writeable")
    inst:AddComponent("lootdropper")
    inst:AddComponent("savedrotation")

    MakeSnowCovered(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("kyno_driftwood_arrowsign", fn, assets, prefabs),
Prefab("kyno_driftwood_arrowsign_panel", panelfn, assets, prefabs),
MakePlacer("kyno_driftwood_arrowsign_placer", "sign_arrow_post", "kyno_driftwood_arrowsign_post", "idle", nil, nil, nil, nil, -90, "eight"),
MakePlacer("kyno_driftwood_arrowsign_panel_placer", "sign_arrow_panel", "kyno_driftwood_arrowsign_panel", "idle", nil, nil, nil, nil, -90, "eight")