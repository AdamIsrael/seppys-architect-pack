require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_altar_statue1.zip"),
	Asset("ANIM", "anim/quagmire_altar_statue1_left.zip"),
	Asset("ANIM", "anim/quagmire_altar_statue2.zip"),
	Asset("ANIM", "anim/quagmire_altar_statue2_left.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function beast1fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_beaststatue.tex")
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("quagmire_altar_statue1")
    inst.AnimState:SetBuild("quagmire_altar_statue1")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("beaststatue")
	inst:AddTag("rotatableobject")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_ALTAR_STATUE1"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)
	
    return inst
end

local function beast1_leftfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_beaststatue.tex")
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("quagmire_altar_statue1_left")
    inst.AnimState:SetBuild("quagmire_altar_statue1_left")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("beaststatue")
	inst:AddTag("rotatableobject")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_ALTAR_STATUE1"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)
	
    return inst
end

local function beast2fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_beaststatue.tex")
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("quagmire_altar_statue2")
    inst.AnimState:SetBuild("quagmire_altar_statue2")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("beaststatue")
	inst:AddTag("rotatableobject")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_ALTAR_STATUE2"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)
	
    return inst
end

local function beast2_leftfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_beaststatue.tex")
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("quagmire_altar_statue2")
    inst.AnimState:SetBuild("quagmire_altar_statue2_left")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("beaststatue")
	inst:AddTag("rotatableobject")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_ALTAR_STATUE2"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)
	
    return inst
end

return Prefab("sap_beaststatue", beast1fn, assets),
Prefab("sap_beaststatue_left", beast1_leftfn, assets),
Prefab("sap_beaststatue2", beast2fn, assets),
Prefab("sap_beaststatue2_left", beast2_leftfn, assets),
MakePlacer("sap_beaststatue_placer", "quagmire_altar_statue1", "quagmire_altar_statue1", "idle"),
MakePlacer("sap_beaststatue_left_placer", "quagmire_altar_statue1_left", "quagmire_altar_statue1_left", "idle"),
MakePlacer("sap_beaststatue2_placer", "quagmire_altar_statue2", "quagmire_altar_statue2", "idle"),
MakePlacer("sap_beaststatue2_left_placer", "quagmire_altar_statue2", "quagmire_altar_statue2_left", "idle")