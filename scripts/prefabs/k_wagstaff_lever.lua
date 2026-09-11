require("prefabutil")

local assets = 
{
    Asset("ANIM", "anim/wagpunk_lever.zip"),
}

local function OnActivate(inst, doer)
    inst:RetractLever()
    return true
end

local function ExtendLever(inst)
    if inst.extended then
        return
    end
	
    inst.extended = true
    inst:RemoveTag("NOCLICK")

    inst.components.activatable.inactive = true
    ChangeToObstaclePhysics(inst)
	
    if inst:IsAsleep() then
        inst.AnimState:PlayAnimation("idle")
    else
        inst.AnimState:PlayAnimation("deactivated")
        inst.AnimState:PushAnimation("idle", true)
        inst.SoundEmitter:PlaySound("rifts5/wagpunk_fence/lever_activate")
    end
end

local function RetractLever(inst)
    if not inst.extended then
        return
    end
	
    inst.extended = false
    inst:AddTag("NOCLICK")

    inst.components.activatable.inactive = false
	
    RemovePhysicsColliders(inst)
	
    if inst:IsAsleep() then
        inst.AnimState:PlayAnimation("idle_close")
    else
        inst.AnimState:PlayAnimation("activate")
        inst.AnimState:PushAnimation("idle_close", true)
        inst.SoundEmitter:PlaySound("rifts5/wagpunk_fence/lever_deactivate")
    end
end

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.4)

    inst.AnimState:SetBank("wagpunk_lever")
    inst.AnimState:SetBuild("wagpunk_lever")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("wagpunk_lever")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.standingaction = true
    inst.components.activatable.inactive = false
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)

    inst.extended = false
    inst.ExtendLever = ExtendLever
    inst.RetractLever = RetractLever

    return inst
end

return Prefab("sap_wagpunk_lever", fn, assets),
MakePlacer("sap_wagpunk_lever_placer", "wagpunk_lever", "wagpunk_lever", "idle")