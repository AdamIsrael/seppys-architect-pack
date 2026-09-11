require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_parrot_boat.zip"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle", true)
end

local function onhit_empty(inst, worker)
	inst.AnimState:PlayAnimation("misc")
	inst.AnimState:PushAnimation("misc")
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle", true)
end

local function onbuilt_empty(inst)
    inst.AnimState:PushAnimation("misc")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_shipmast.tex")
	
    inst.AnimState:SetBank("kyno_parrot_boat")
    inst.AnimState:SetBuild("kyno_parrot_boat")
    inst.AnimState:PlayAnimation("idle", true)
    
	inst:AddTag("structure")
	inst:AddTag("wollythebird")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
    return inst
end

local function emptyfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_shipmast.tex")
	
    inst.AnimState:SetBank("kyno_parrot_boat")
    inst.AnimState:SetBuild("kyno_parrot_boat")
    inst.AnimState:PlayAnimation("misc")
    
	inst:AddTag("structure")
	inst:AddTag("wollythebird")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_empty)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt_empty)
	
	MakeHauntableWork(inst)
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
    return inst
end

return Prefab("sap_parrot_boat", fn, assets),
Prefab("sap_boat_empty", emptyfn, assets),
MakePlacer("sap_parrot_boat_placer", "kyno_parrot_boat", "kyno_parrot_boat", "idle"),
MakePlacer("sap_boat_empty_placer", "kyno_parrot_boat", "kyno_parrot_boat", "misc")