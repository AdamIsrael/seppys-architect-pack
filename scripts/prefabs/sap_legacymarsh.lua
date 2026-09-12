require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_legacymarsh.zip"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst:Remove()
	inst.components.lootdropper:DropLoot()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("grass.png")
	
	inst.AnimState:SetBank("kyno_legacymarsh")
	inst.AnimState:SetBuild("kyno_legacymarsh")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("legacy_marsh")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	MakeSmallPropagator(inst)
	
	return inst
end

return Prefab("sap_legacymarsh", fn, assets, prefabs),
MakePlacer("sap_legacymarsh_placer", "kyno_legacymarsh", "kyno_legacymarsh", "idle")
