require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/thorn_bush.zip"),
	Asset("ANIM", "anim/thorn_bush_guard_build.zip"),
	Asset("ANIM", "anim/thorn_bush_mothermighty_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs = 
{
	"ash",
}

local function dig_up(inst, chopper)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function dig_up_burnt(inst, chopper)
	inst:RemoveComponent("workable")
	RemovePhysicsColliders(inst)
	inst.components.lootdropper:SpawnLootPrefab("ash")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("regain")
	inst.AnimState:PushAnimation("idle", true)
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
				inst.components.workable:SetOnFinishCallback(dig_up_burnt)
				inst.components.workable:SetWorkLeft(1)
			end
		end)
    
	inst.AnimState:PlayAnimation("burnt", true)
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

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.6, .6, .6)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_thornbush1.tex")
	
	MakeObstaclePhysics(inst, .2)
	
	inst.AnimState:SetBank("thorn_bush")
	inst.AnimState:SetBuild("thorn_bush")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("thorny")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeMediumBurnable(inst)
	inst.components.burnable:SetOnBurntFn(OnBurnt)
    MakeLargePropagator(inst)
	
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
	
	inst.AnimState:SetScale(.6, .6, .6)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_thornbush2.tex")
	
	MakeObstaclePhysics(inst, .2)
	
	inst.AnimState:SetBank("thorn_bush")
	inst.AnimState:SetBuild("thorn_bush_guard_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("thorny")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeMediumBurnable(inst)
	inst.components.burnable:SetOnBurntFn(OnBurnt)
    MakeLargePropagator(inst)
	
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
	
	inst.AnimState:SetScale(.6, .6, .6)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_thornbush1.tex")
	
	MakeObstaclePhysics(inst, .2)
	
	inst.AnimState:SetBank("thorn_bush")
	inst.AnimState:SetBuild("thorn_bush_mothermighty_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("thorny")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeMediumBurnable(inst)
	inst.components.burnable:SetOnBurntFn(OnBurnt)
    MakeLargePropagator(inst)
	
	inst.OnSave = onsave
	inst.OnLoad = onload

	return inst
end

local function thornbushplacer(inst)
	inst.AnimState:SetScale(.6, .6, .6)
end

return Prefab("sap_thornbush1", fn, assets, prefabs),
Prefab("sap_thornbush2", fn2, assets, prefabs),
Prefab("sap_thornbush3", fn3, assets, prefabs),
MakePlacer("sap_thornbush1_placer", "thorn_bush", "thorn_bush", "idle", false, nil, nil, nil, nil, nil, thornbushplacer),
MakePlacer("sap_thornbush2_placer", "thorn_bush", "thorn_bush_guard_build", "idle", false, nil, nil, nil, nil, nil, thornbushplacer),
MakePlacer("sap_thornbush3_placer", "thorn_bush", "thorn_bush_mothermighty_build", "idle", false, nil, nil, nil, nil, nil, thornbushplacer)