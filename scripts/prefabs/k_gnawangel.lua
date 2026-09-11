require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_cemetery.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit_worshipper(inst, worker)
    inst.AnimState:PlayAnimation("angel2")
    inst.AnimState:PushAnimation("angel2")
end

local function onhit_worshipper2(inst, worker)
    inst.AnimState:PlayAnimation("angel")
    inst.AnimState:PushAnimation("angel")
end

local function onbuilt_worshipper(inst)
    inst.AnimState:PushAnimation("angel2")
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
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_worshipper.tex")
	
    MakeObstaclePhysics(inst, .2)
	
    inst.AnimState:SetBank("quagmire_cemetery")
    inst.AnimState:SetBuild("quagmire_cemetery")
    inst.AnimState:PlayAnimation("angel2")
    
	inst:AddTag("structure")
	inst:AddTag("cemetery_worshipper")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_PARK_ANGEL"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_worshipper)
	
	inst:ListenForEvent("onbuilt", onbuilt_worshipper)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_worshipper", fn, assets),
MakePlacer("sap_worshipper_placer", "quagmire_cemetery", "quagmire_cemetery", "angel2")