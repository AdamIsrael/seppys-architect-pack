require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/hat_kyno_adai_pumpkin.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
	inst:Remove()
end

local function onignite(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/livinglog_burn")
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("anim", false)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(1.5, 1.5, 1.5) -- For decoration.
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("kyno_adai_pumpkinhat")
    inst.AnimState:SetBuild("hat_kyno_adai_pumpkin")
    inst.AnimState:PlayAnimation("anim", false)
    
	inst:AddTag("structure")
	inst:AddTag("jackohead")
	
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
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	inst:ListenForEvent("onignite", onignite)
	
	MakeHauntableWork(inst)
	MakeMediumBurnable(inst)
    MakeMediumPropagator(inst)
	
    return inst
end

local function pumpkinheadplacerfn(inst)
	inst.AnimState:SetScale(1.5, 1.5, 1.5)
end

return Prefab("sap_pumpkinhead", fn, assets),
MakePlacer("sap_pumpkinhead_placer", "sap_adai_pumpkinhat", "hat_kyno_adai_pumpkin", "anim", false, nil, nil, nil, nil, nil, pumpkinheadplacerfn)