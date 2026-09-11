require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/doydoy_nest.zip"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs = 
{
	"sap_doydoy",
	"sap_doydoy_baby",
	"sap_doydoyegg",
	"goose_feather",
}

local function onmakeempty(inst)
	inst.AnimState:PlayAnimation("idle_nest_empty")
	inst:RemoveTag("fullnest")
	
	inst.components.trader.enabled = true
	inst.components.childspawner.noregen = true
	inst.components.childspawner:StopSpawning()
end

local function onpicked(inst, picker)
	onmakeempty(inst)
end

local function onregrow(inst)
	inst.AnimState:PlayAnimation("idle_nest")
	inst:AddTag("fullnest")
	
	inst.components.trader.enabled = false
	inst.components.childspawner.noregen = false
	inst.components.childspawner:StartSpawning(960)
end

local function onvacate(inst, child)
	if inst.components.pickable then
		inst.components.pickable:MakeEmpty()
		child.sg:GoToState("hatch")
	end
	inst:Remove()
end

local function onhammered(inst)
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
		if inst:HasTag("fullnest") then
			inst.AnimState:PlayAnimation("hit_nest")
			inst.AnimState:PushAnimation("idle_nest")
		else
			inst.AnimState:PlayAnimation("hit_nest_empty")
			inst.AnimState:PushAnimation("idle_nest_empty")
		end
	end
end

local function itemtest(inst, item)
	return not inst.components.pickable:CanBePicked() and item:HasTag("sap_doydoyegg")
end

local function itemget(inst, giver, item)
	inst.components.pickable:Regen()
	item:Remove()
end

local function OnBuilt(inst)
	onregrow(inst)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_doydoynest.tex")
	
	inst.AnimState:SetBank("doydoy_nest")
	inst.AnimState:SetBuild("doydoy_nest")
	inst.AnimState:PlayAnimation("idle_nest", true)
	
	MakeObstaclePhysics(inst, 0.25)
	
	inst:AddTag("doydoy")
	inst:AddTag("doydoynest")
	inst:AddTag("structure")
	inst:AddTag("fullnest")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"cutgrass", "twigs", "twigs", "goose_feather"})
	
	inst:AddComponent("pickable")
	inst.components.pickable:SetUp("sap_doydoyegg")
	inst.components.pickable:SetOnPickedFn(onpicked)
	inst.components.pickable:SetOnRegenFn(onregrow)
	inst.components.pickable:SetMakeEmptyFn(onmakeempty)
	
	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "sap_doydoy_baby"
	inst.components.childspawner.spawnoffscreen = true
	inst.components.childspawner:SetRegenPeriod(10000)
	inst.components.childspawner:StopRegen()
	inst.components.childspawner:SetSpawnPeriod(960)
	inst.components.childspawner:SetSpawnedFn(onvacate)
	inst.components.childspawner:SetMaxChildren(1)
	inst.components.childspawner:StartSpawning(960)
	inst.components.childspawner.nooffset = true
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(itemtest)
	inst.components.trader.onaccept = itemget
	inst.components.trader.enabled = false

	inst:ListenForEvent("onbuilt", OnBuilt)
	
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

return Prefab("sap_doydoy_nest2", fn, assets, prefabs),
MakePlacer("sap_doydoy_nest2_placer", "doydoy_nest", "doydoy_nest", "idle_nest")