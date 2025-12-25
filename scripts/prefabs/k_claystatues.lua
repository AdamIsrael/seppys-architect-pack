require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/claywarg.zip"),
	Asset("ANIM", "anim/clayhound.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("statue_pre")
	inst.AnimState:PushAnimation("statue", true)
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/together/claywarg/idle")
end

local function onbuilt_hound(inst)
	inst.AnimState:PlayAnimation("statue_pre")
	inst.AnimState:PushAnimation("idle_statue", true)
	-- inst.SoundEmitter:PlaySound("dontstarve/creatures/together/clayhound/pant")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("claywarg")
    inst.AnimState:SetBuild("claywarg")
    inst.AnimState:PlayAnimation("statue")
    
	inst:AddTag("structure")
	inst:AddTag("clay_statue")
	
	inst:SetPrefabNameOverride("claywarg")
	
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
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function houndfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("clayhound")
    inst.AnimState:SetBuild("clayhound")
    inst.AnimState:PlayAnimation("idle_statue")
    
	inst:AddTag("structure")
	inst:AddTag("clay_statue")
	
	inst:SetPrefabNameOverride("clayhound")
	
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
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt_hound)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("kyno_claywarg", fn, assets),
Prefab("kyno_clayhound", houndfn, assets),
MakePlacer("kyno_claywarg_placer", "claywarg", "claywarg", "statue"),
MakePlacer("kyno_clayhound_placer", "clayhound", "clayhound", "idle_statue")