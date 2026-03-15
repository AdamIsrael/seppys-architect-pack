require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/vault_table_round.zip"),
	Asset("ANIM", "anim/vault_chair_stool.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local function table_AbleToAcceptDecor(inst, item, giver)
	return item ~= nil
end

local function table_OnDecorGiven(inst, item, giver)
	if item then
		inst.SoundEmitter:PlaySound("wintersfeast2019/winters_feast/table/food")
		if item.Physics then
			item.Physics:SetActive(false)
		end
		if item.Follower then
			item.Follower:FollowSymbol(inst.GUID, "swap_object")
		end
	end
end

local function table_OnDecorTaken(inst, item)
	if item then
		if item.Physics then
			item.Physics:SetActive(true)
		end

		if item.Follower then
			item.Follower:StopFollowing()
		end
	end
end

local function stool_GetStatus(inst)
	return inst.components.sittable:IsOccupied() and "OCCUPIED" or nil
end

local function stool_DescriptionFn(inst)
	inst.components.inspectable.nameoverride = inst.components.sittable:IsOccupied() and "stone_chair" or "relic"
end

local function onhit(inst)
	inst.AnimState:PlayAnimation("hit")
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()

	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
end

local function fn_table(clean)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst:SetDeploySmartRadius(0.875)
	MakeObstaclePhysics(inst, 0.7)

	inst.AnimState:SetBank("vault_table_round")
	inst.AnimState:SetBuild("vault_table_round")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(-1)

	if clean then
		inst.AnimState:Hide("MOSS1")
		inst.AnimState:Hide("MOSS2")
	end

	inst:AddTag("structure")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "relic"

	inst:AddComponent("furnituredecortaker")
	inst.components.furnituredecortaker.abletoaccepttest = table_AbleToAcceptDecor
	inst.components.furnituredecortaker.ondecorgiven = table_OnDecorGiven
	inst.components.furnituredecortaker.ondecortaken = table_OnDecorTaken
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	return inst
end

local function fn_stool(clean)
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst:SetDeploySmartRadius(0.875)
	MakeObstaclePhysics(inst, 0.25)

	inst.AnimState:SetBank("vault_chair_stool")
	inst.AnimState:SetBuild("vault_chair_stool")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(-1)
	
	inst:AddTag("structure")
	inst:AddTag("faced_chair")
	inst:AddTag("rotatableobject")
	
	if clean then
		for i = 1, 3 do
			inst.AnimState:Hide("MOSS"..tostring(i))
		end
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst.components.inspectable.descriptionfn = stool_DescriptionFn

	inst:AddComponent("sittable")

	inst:AddComponent("savedrotation")
	inst.components.savedrotation.dodelayedpostpassapply = true
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	return inst
end

local function table1()
	return fn_table(true)
end

local function table2()
	return fn_table(false)
end

local function stool1()
	return fn_stool(true)
end

local function stool2()
	return fn_stool(false)
end

return Prefab("sap_vault_table1", table1, assets),
MakePlacer("sap_vault_table1_placer", "vault_table_round", "vault_table_round", "idle"),

Prefab("sap_vault_table2", table2, assets),
MakePlacer("sap_vault_table2_placer", "vault_table_round", "vault_table_round", "idle"),

Prefab("sap_vault_stool1", stool1, assets),
MakePlacer("sap_vault_stool1_placer", "vault_chair_stool", "vault_chair_stool", "idle"),

Prefab("sap_vault_stool2", stool2, assets),
MakePlacer("sap_vault_stool2_placer", "vault_chair_stool", "vault_chair_stool", "idle")