require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_cemetery.zip"),
	Asset("ANIM", "anim/quagmire_cemetery_left.zip"),
}

local prefabs =
{
	"sap_worshipper2",
	"sap_worshipper2_left",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit_worshipper(inst, worker)
    inst.AnimState:PlayAnimation("angel")
    inst.AnimState:PushAnimation("angel")
end

local function onhit_worshipper2(inst, worker)
    inst.AnimState:PlayAnimation("angel")
    inst.AnimState:PushAnimation("angel")
end

local function onbuilt_worshipper(inst)
    inst.AnimState:PushAnimation("angel")
end

local function onbuilt_worshipper2(inst)
    inst.AnimState:PushAnimation("angel")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_worshipper2.tex")
	
    MakeObstaclePhysics(inst, .2)
	
    inst.AnimState:SetBank("quagmire_cemetery")
    inst.AnimState:SetBuild("quagmire_cemetery")
    inst.AnimState:PlayAnimation("angel")
    
	inst:AddTag("structure")
	inst:AddTag("cemetery_worshipper")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_PARK_ANGEL2"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_worshipper)
	
	inst:ListenForEvent("onbuilt", onbuilt_worshipper)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function leftfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_worshipper2.tex")
	
    MakeObstaclePhysics(inst, .2)
	
    inst.AnimState:SetBank("quagmire_cemetery_left")
    inst.AnimState:SetBuild("quagmire_cemetery_left")
    inst.AnimState:PlayAnimation("angel")
    
	inst:AddTag("structure")
	inst:AddTag("cemetery_worshipper_left")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_PARK_ANGEL2"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_worshipper2)
	
	inst:ListenForEvent("onbuilt", onbuilt_worshipper2)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_worshipper2", fn, assets),
Prefab("sap_worshipper2_left", leftfn, assets),
MakePlacer("sap_worshipper2_placer", "quagmire_cemetery", "quagmire_cemetery", "angel"),
MakePlacer("sap_worshipper2_left_placer", "quagmire_cemetery_left", "quagmire_cemetery_left", "angel")