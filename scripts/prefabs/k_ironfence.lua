require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_park_fence.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit_short(inst, worker)
    inst.AnimState:PlayAnimation("idle_short")
    inst.AnimState:PushAnimation("idle_short")
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle")
end

local function onbuilt_short(inst)
    inst.AnimState:PushAnimation("idle_short")
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .2)
	inst.Physics:SetDontRemoveOnSleep(true)
	
    inst.AnimState:SetBank("quagmire_park_fence")
    inst.AnimState:SetBuild("quagmire_park_fence")
    inst.AnimState:PlayAnimation("idle_short")
    
	inst:AddTag("structure")
	inst:AddTag("wall")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_PARKSPIKE"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_short)
	
	inst:ListenForEvent("onbuilt", onbuilt_short)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function tallfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .2)
	
    inst.AnimState:SetBank("quagmire_park_fence")
    inst.AnimState:SetBuild("quagmire_park_fence")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("wall")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_PARKSPIKE"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("kyno_ironfencesmall", fn, assets),
Prefab("kyno_ironfencetall", tallfn, assets),
MakePlacer("kyno_ironfencesmall_placer", "quagmire_park_fence", "quagmire_park_fence", "idle_short"),
MakePlacer("kyno_ironfencetall_placer", "quagmire_park_fence", "quagmire_park_fence", "idle")