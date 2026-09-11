require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/poison_hole.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs = {}

local function fartover(inst)
	inst.AnimState:PlayAnimation("boil_start", false)
	inst.AnimState:PushAnimation("boil_loop", true)
	inst.farting = false
end

local function fart(inst, victim)
	if not inst.farting then
		inst.farting = true
		inst.AnimState:PlayAnimation("pop_pre", false)
		inst.AnimState:PushAnimation("pop", false)

		inst:ListenForEvent("animqueueover", fartover)
	end
end

local function steam(inst)
	if not inst.farting then
		inst.farting = true
		inst.AnimState:PlayAnimation("pop_pre", false)
		inst.AnimState:PushAnimation("pop", false)
	end
end

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("poop")
	inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
	inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
	inst:Remove()
end

local function OnWake(inst)
	if inst.steamtask then
		inst.steamtask:Cancel()
		inst.steamtask = nil
	end
	inst.steamtask = inst:DoPeriodicTask(3+(math.random()*2), fart)
end

local function OnSleep(inst)
	if inst.steamtask then
		inst.steamtask:Cancel()
		inst.steamtask = nil
	end
end

local function OnPoisonAttackFn(inst, victim)
	fart(inst, victim)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("poison_hole")
	inst.AnimState:SetBuild("poison_hole")
	inst.AnimState:PlayAnimation("boil_loop", true)
	
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("poison")
	inst:AddTag("trytonguebuthole")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst.OnEntityWake = OnWake
	inst.OnEntitySleep = OnSleep

	return inst
end

return Prefab("kyno_poisonhole", fn, assets, prefabs),
MakePlacer("kyno_poisonhole_placer", "poison_hole", "poison_hole", "boil_loop")
