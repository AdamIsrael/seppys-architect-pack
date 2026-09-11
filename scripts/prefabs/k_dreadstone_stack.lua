require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/nightmare_crack_upper.zip"),
}

local prefabs =
{
	"rock_break_fx",
}

local function OnWorked(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("idle_open_rift", true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(0.75, 0.75)

    inst.AnimState:SetBank("nightmare_crack_upper")
    inst.AnimState:SetBuild("nightmare_crack_upper")
	inst.AnimState:PlayAnimation("idle_open_rift", true)

    inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("DREADSTONE_STACK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_fissure_open_LP", "loop")
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "DREADSTONE_STACK"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(6)
	inst.components.workable:SetOnFinishCallback(OnWorked)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

    return inst
end

return Prefab("sap_dreadstone_stack", fn, assets, prefabs),
MakePlacer("sap_dreadstone_stack_placer", "nightmare_crack_upper", "nightmare_crack_upper", "idle_open_rift")