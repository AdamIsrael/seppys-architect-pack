require "prefabutil"

local assets = 
{
    Asset("ANIM", "anim/portal_debris.zip"),
}

local prefabs =
{
    "cutstone",
    "gears",
    "trinket_6",
}

local function OnHammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")

    inst:Remove()
end

local function OnHit(inst, worker)
    inst.AnimState:PlayAnimation("hit" .. inst.debris_id)
    inst.AnimState:PushAnimation("idle" .. inst.debris_id)
end

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("portal_debris")
    inst.AnimState:SetBuild("portal_debris")
	inst.AnimState:PlayAnimation("idle1", true)
	
	inst:SetPrefabNameOverride("monkeyisland_portal_debris")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.debris_id = "1"
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MONKEYISLAND_PORTAL_DEBRIS"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("portal_debris")
    inst.AnimState:SetBuild("portal_debris")
	inst.AnimState:PlayAnimation("idle2", true)
	
	inst:SetPrefabNameOverride("monkeyisland_portal_debris")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.debris_id = "2"
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MONKEYISLAND_PORTAL_DEBRIS"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)

    return inst
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("portal_debris")
    inst.AnimState:SetBuild("portal_debris")
	inst.AnimState:PlayAnimation("idle3", true)
	
	inst:SetPrefabNameOverride("monkeyisland_portal_debris")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.debris_id = "3"
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MONKEYISLAND_PORTAL_DEBRIS"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)

    return inst
end

return Prefab("sap_monkeyisland_debris1", fn1, assets, prefabs),
Prefab("sap_monkeyisland_debris2", fn2, assets, prefabs),
Prefab("sap_monkeyisland_debris3", fn3, assets, prefabs),
MakePlacer("sap_monkeyisland_debris1_placer", "portal_debris", "portal_debris", "idle1"),
MakePlacer("sap_monkeyisland_debris2_placer", "portal_debris", "portal_debris", "idle2"),
MakePlacer("sap_monkeyisland_debris3_placer", "portal_debris", "portal_debris", "idle3")
