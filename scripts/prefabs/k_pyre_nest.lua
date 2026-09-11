require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/pyre_nest.zip"),
}

local prefabs = 
{
	"tallbirdegg",
}

local function onmakeempty(inst)
	inst.AnimState:PlayAnimation("full")
	inst:RemoveTag("pyre_egg")
	
	inst.components.trader.enabled = true
end

local function onpicked(inst, picker)
	onmakeempty(inst)
end

local function onregrow(inst)
	inst.AnimState:PlayAnimation("egg")
	inst:AddTag("pyre_egg")
	
	inst.components.trader.enabled = false
end

local function onhammered_full(inst)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
	SpawnPrefab("sap_pyrenest_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onhammered_med(inst)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
	SpawnPrefab("sap_pyrenest_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onhammered_low(inst)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
	SpawnPrefab("sap_pyrenest_out").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onhammered_out(inst)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		if inst:HasTag("pyre_egg") then
			inst.AnimState:PlayAnimation("egg")
			inst.AnimState:PushAnimation("egg")
		else
			inst.AnimState:PlayAnimation("full")
			inst.AnimState:PushAnimation("full")
		end
	end
end

local function itemtest(inst, item)
	return not inst.components.pickable:CanBePicked() and item:HasTag("pyre_egg")
end

local function itemget(inst, giver, item)
	inst.components.pickable:Regen()
	item:Remove()
end

local function OnBuilt(inst)
	onpicked(inst)
	inst.components.pickable:MakeEmpty()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pyrenest.tex")
	
	inst.AnimState:SetBank("pyre_nest")
	inst.AnimState:SetBuild("pyre_nest")
	inst.AnimState:PlayAnimation("full", true)
	
	inst:AddTag("pyrenest")
	inst:AddTag("structure")
	inst:AddTag("pyre_egg")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log", "log", "twigs", "twigs"})
	
	inst:AddComponent("pickable")
	inst.components.pickable:SetUp("tallbirdegg")
	inst.components.pickable:SetOnPickedFn(onpicked)
	inst.components.pickable:SetOnRegenFn(onregrow)
	inst.components.pickable:SetMakeEmptyFn(onmakeempty)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_full)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(itemtest)
	inst.components.trader.onaccept = itemget
	inst.components.trader.enabled = false

	inst:ListenForEvent("onbuilt", OnBuilt)
	
	MakeLargeBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

local function fn2()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pyrenest.tex")
	
	inst.AnimState:SetBank("pyre_nest")
	inst.AnimState:SetBuild("pyre_nest")
	inst.AnimState:PlayAnimation("3", true)
	
	inst:AddTag("pyrenest")
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_pyrenest")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_med)
	inst.components.workable:SetWorkLeft(1)
	
	MakeLargeBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

local function fn3()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pyrenest.tex")
	
	inst.AnimState:SetBank("pyre_nest")
	inst.AnimState:SetBuild("pyre_nest")
	inst.AnimState:PlayAnimation("2", true)
	
	inst:AddTag("pyrenest")
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_pyrenest")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_low)
	inst.components.workable:SetWorkLeft(1)
	
	MakeLargeBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

local function fn4()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pyrenest.tex")
	
	inst.AnimState:SetBank("pyre_nest")
	inst.AnimState:SetBuild("pyre_nest")
	inst.AnimState:PlayAnimation("1", true)
	
	inst:AddTag("pyrenest")
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("sap_pyrenest")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_out)
	inst.components.workable:SetWorkLeft(1)
	
	MakeLargeBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

return Prefab("sap_pyrenest", fn, assets, prefabs),
Prefab("sap_pyrenest_med", fn2, assets, prefabs),
Prefab("sap_pyrenest_low", fn3, assets, prefabs),
Prefab("sap_pyrenest_out", fn4, assets, prefabs),
MakePlacer("sap_pyrenest_placer", "pyre_nest", "pyre_nest", "egg")