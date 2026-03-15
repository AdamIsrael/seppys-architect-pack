require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_banner.zip"),
	Asset("ANIM", "anim/lavaarena_battlestandard.zip"),
	Asset("ANIM", "anim/lavaarena_battlestandard_attack_build.zip"),
	Asset("ANIM", "anim/kyno_battlestandard_heal_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
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

local function onhit_banner1(inst, worker)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle")
end

local function onhit_banner2(inst, worker)
    inst.AnimState:PlayAnimation("idle2")
    inst.AnimState:PushAnimation("idle2")
end

local function onhit_banner3(inst, worker)
    inst.AnimState:PlayAnimation("idle3")
    inst.AnimState:PushAnimation("idle3")
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)
end

local function onbuilt_banner1(inst)
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle")
end

local function onbuilt_banner2(inst)
    inst.AnimState:PlayAnimation("idle2")
	inst.AnimState:PushAnimation("idle2")
end

local function onbuilt_banner3(inst)
    inst.AnimState:PlayAnimation("idle3")
	inst.AnimState:PushAnimation("idle3")
end

local function purplefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("lavaarena_battlestandard")
    inst.AnimState:SetBuild("lavaarena_battlestandard")
    inst.AnimState:PlayAnimation("idle", true)
    
	inst:AddTag("structure")
	inst:AddTag("purple_standard")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function redfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("lavaarena_battlestandard")
    inst.AnimState:SetBuild("lavaarena_battlestandard_attack_build")
    inst.AnimState:PlayAnimation("idle", true)
    
	inst:AddTag("structure")
	inst:AddTag("red_standard")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function bluefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("kyno_battlestandard")
    inst.AnimState:SetBuild("kyno_battlestandard_heal_build")
    inst.AnimState:PlayAnimation("idle", true)
    
	inst:AddTag("structure")
	inst:AddTag("blue_standard")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function banner1fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("kyno_banner")
    inst.AnimState:SetBuild("kyno_banner")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("banner_standard")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_banner1)
	
	inst:ListenForEvent("onbuilt", onbuilt_banner1)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function banner2fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("kyno_banner")
    inst.AnimState:SetBuild("kyno_banner")
    inst.AnimState:PlayAnimation("idle2")
    
	inst:AddTag("structure")
	inst:AddTag("banner_standard")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_banner2)
	
	inst:ListenForEvent("onbuilt", onbuilt_banner2)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function banner3fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("kyno_banner")
    inst.AnimState:SetBuild("kyno_banner")
    inst.AnimState:PlayAnimation("idle3")
    
	inst:AddTag("structure")
	inst:AddTag("banner_standard")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_banner3)
	
	inst:ListenForEvent("onbuilt", onbuilt_banner3)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_shieldstandard", purplefn, assets),
Prefab("sap_attackstandard", redfn, assets),
Prefab("sap_healstandard", bluefn, assets),
Prefab("sap_bannerstandard", banner1fn, assets),
Prefab("sap_bannerstandard_2", banner2fn, assets),
Prefab("sap_bannerstandard_3", banner3fn, assets),
MakePlacer("sap_shieldstandard_placer", "lavaarena_battlestandard", "lavaarena_battlestandard", "idle"),
MakePlacer("sap_attackstandard_placer", "lavaarena_battlestandard", "lavaarena_battlestandard_attack_build", "idle"),
MakePlacer("sap_healstandard_placer", "kyno_battlestandard", "kyno_battlestandard_heal_build", "idle"),
MakePlacer("sap_bannerstandard_placer", "kyno_banner", "kyno_banner", "idle"),
MakePlacer("sap_bannerstandard_2_placer", "kyno_banner", "kyno_banner", "idle2"),
MakePlacer("sap_bannerstandard_3_placer", "kyno_banner", "kyno_banner", "idle3")