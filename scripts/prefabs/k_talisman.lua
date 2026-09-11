require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/townportaltalisman.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("active_rise")
	inst.AnimState:PushAnimation("active_loop", true)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("townportaltalisman")
    inst.AnimState:SetBuild("townportaltalisman")
    inst.AnimState:PlayAnimation("active_loop", true)
    
	inst:AddTag("structure")
	inst:AddTag("townportaltalisman")
	
	inst:SetPrefabNameOverride("townportaltalisman")
	inst.SoundEmitter:PlaySound("dontstarve/common/together/town_portal/talisman_active", "active")
	
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

return Prefab("sap_talisman", fn, assets),
MakePlacer("sap_talisman_placer", "townportaltalisman", "townportaltalisman", "active_loop")