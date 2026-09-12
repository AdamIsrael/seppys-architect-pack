require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_skullstick.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .4)
	
    inst.AnimState:SetBank("kyno_skullstick")
    inst.AnimState:SetBuild("kyno_skullstick")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("head_on_stick")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SKELETON"
	
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

local function lawnplacer(inst)
	inst.AnimState:SetScale(.4, .4, .4)
end

return Prefab("sap_skullstick", fn, assets),
MakePlacer("sap_skullstick_placer", "kyno_skullstick", "kyno_skullstick", "idle") --, false, nil, nil, nil, nil, nil, lawnplacer)