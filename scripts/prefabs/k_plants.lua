local assets =
{
    Asset("ANIM", "anim/marsh_plant.zip"),
    Asset("ANIM", "anim/pond_plant_cave.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"cutlichen",
	"succulent_picked",
}

local function onpicked(inst)
	inst:Remove()
end

local function fn1()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("marsh_plant")
	inst.AnimState:SetBuild("marsh_plant")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetRayTestOnBB(true)
		
	inst:AddTag("kyno_plant")
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("marsh_plant")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
		
	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("succulent_picked") 
	inst.components.pickable.onpickedfn = onpicked
	inst.components.pickable.quickpick = true
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableIgnite(inst)
	
	return inst
end

local function fn2()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("pond_rock")
	inst.AnimState:SetBuild("pond_plant_cave")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetRayTestOnBB(true)
		
	inst:AddTag("kyno_plant")
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("pond_algae")

	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
		
	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
	inst.components.pickable:SetUp("cutlichen") 
	inst.components.pickable.onpickedfn = onpicked
	inst.components.pickable.quickpick = true
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)
	MakeHauntableIgnite(inst)
	
	return inst
end

return Prefab("kyno_marsh_plant", fn1, assets, prefabs),
Prefab("kyno_plant_algae", fn2, assets, prefabs),
MakePlacer("kyno_marsh_plant_placer", "marsh_plant", "marsh_plant", "idle"),
MakePlacer("kyno_plant_algae_placer", "pond_rock", "pond_plant_cave", "idle")