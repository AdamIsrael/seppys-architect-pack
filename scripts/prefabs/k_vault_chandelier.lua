require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/chandelier_vault.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()

	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("fallen")
end

local function brokenfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 0.75)

	inst.AnimState:SetBank("chandelier_vault")
	inst.AnimState:SetBuild("chandelier_vault")
	inst.AnimState:PlayAnimation("fallen")
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("vault_chandelier_broken")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)

	return inst
end

return Prefab("sap_vault_chandelier_broken", brokenfn, assets),
MakePlacer("sap_vault_chandelier_broken_placer", "chandelier_vault", "chandelier_vault", "fallen")