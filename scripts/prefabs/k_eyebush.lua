require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/eyebush.zip"),
	Asset("ANIM", "anim/eyebush_prism_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"feather_crow",
	"feather_robin",
	"dug_berrybush2",
}

local function dug_up(inst, worker)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("feather_crow")
	inst.components.lootdropper:SpawnLootPrefab("dug_berrybush2")
end

local function dug_up_prismatic(inst, worker)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("feather_crow")
	inst.components.lootdropper:SpawnLootPrefab("feather_robin")
	inst.components.lootdropper:SpawnLootPrefab("dug_berrybush2")
end

local function dug_up_burnt(inst, worker)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("ash")
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
end

local function dug_up_withered(inst, worker)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("feather_crow")
	inst.components.lootdropper:SpawnLootPrefab("dug_sapling")
end

local function OnBurnt(inst)
	inst:DoTaskInTime( 0.5,
		function()
		    if inst.components.burnable then
			    inst.components.burnable:Extinguish()
			end
			inst:RemoveComponent("burnable")
			inst:RemoveComponent("propagator")

			inst.components.lootdropper:SetLoot({})
			
			if inst.components.workable then
				inst.components.workable:SetWorkLeft(1)
				inst.components.workable:SetOnWorkCallback(nil)
				inst.components.workable:SetOnFinishCallback(dug_up_burnt)
			end
		end)
    
	inst.AnimState:PlayAnimation("burnt")
    inst.AnimState:SetRayTestOnBB(true)
    inst:AddTag("burnt")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.burnt then
		OnBurnt(inst)
	end
end

local function onnear(inst)
	if not inst:HasTag("burnt") or inst:HasTag("fire") then
		inst.AnimState:PlayAnimation("sleep_pst")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function onfar(inst)
	if not inst:HasTag("burnt") or inst:HasTag("fire") then
		inst.AnimState:PlayAnimation("sleep_pre")
		inst.AnimState:PushAnimation("sleep_loop", true)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .3)

	inst.AnimState:SetBank("eyebush")
	inst.AnimState:SetBuild("eyebush")
	inst.AnimState:PlayAnimation("sleep_loop", true)
	
	inst:AddTag("plant")
	inst:AddTag("eyebush")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dug_up)
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)

    MakeLargeBurnable(inst)
	MakeLargePropagator(inst)
	
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

	inst.OnSave = onsave
	inst.OnLoad = onload

	return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .3)

	inst.AnimState:SetBank("eyebush")
	inst.AnimState:SetBuild("eyebush_prism_build")
	inst.AnimState:PlayAnimation("sleep_loop", true)
	
	inst:AddTag("plant")
	inst:AddTag("eyebush_prism")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dug_up_prismatic)
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)

    MakeLargeBurnable(inst)
	MakeLargePropagator(inst)
	
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

	inst.OnSave = onsave
	inst.OnLoad = onload

	return inst
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .3)

	inst.AnimState:SetBank("eyebush")
	inst.AnimState:SetBuild("eyebush")
	inst.AnimState:PlayAnimation("idle_withered", true)
	
	inst:AddTag("plant")
	inst:AddTag("eyebush")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dug_up_withered)

    MakeLargeBurnable(inst)
	MakeLargePropagator(inst)
	
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

	inst.OnSave = onsave
	inst.OnLoad = onload

	return inst
end

local function fn4()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .3)

	inst.AnimState:SetBank("eyebush")
	inst.AnimState:SetBuild("eyebush")
	inst.AnimState:PlayAnimation("dead", true)
	
	inst:AddTag("plant")
	inst:AddTag("eyebush")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(dug_up_withered)

    MakeLargeBurnable(inst)
	MakeLargePropagator(inst)
	
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

	inst.OnSave = onsave
	inst.OnLoad = onload

	return inst
end

return Prefab("kyno_eyebush", fn, assets, prefabs),
Prefab("kyno_eyebush_prismatic", fn2, assets, prefabs),
Prefab("kyno_eyebush_withered", fn3, assets, prefabs),
Prefab("kyno_eyebush_dead", fn4, assets, prefabs),
MakePlacer("kyno_eyebush_placer", "eyebush", "eyebush", "sleep_loop"),
MakePlacer("kyno_eyebush_prismatic_placer", "eyebush", "eyebush_prism_build", "sleep_loop"),
MakePlacer("kyno_eyebush_withered_placer", "eyebush", "eyebush", "idle_withered"),
MakePlacer("kyno_eyebush_dead_placer", "eyebush", "eyebush", "dead")