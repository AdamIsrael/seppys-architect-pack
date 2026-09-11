require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/koalefant_actions.zip"),
	Asset("ANIM", "anim/koalefant_summer_build.zip"),
	Asset("ANIM", "anim/koalefant_winter_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"collapse_big",
}

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()	
	
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		
	inst:Remove()
end

local function OnHit(inst, worker)
	inst.AnimState:PlayAnimation("carcass4_shake")
end

local function OnBuilt(inst)
    inst.AnimState:PushAnimation("carcass4")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 0.75, 1)
	inst.DynamicShadow:SetSize(4.5, 2)

	inst.Transform:SetSixFaced()

	inst.AnimState:SetBank("koalefant")
	inst.AnimState:SetBuild("koalefant_summer_build")
	inst.AnimState:PlayAnimation("carcass4")

	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("koalefant_carcass")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	MakeHauntableWork(inst)

	return inst
end

return Prefab("sap_carcass_koalefant", fn, assets, prefabs),
MakePlacer("sap_carcass_koalefant_placer", "koalefant", "koalefant_summer_build", "carcass4")
