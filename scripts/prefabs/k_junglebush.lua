require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/jungle_bush.zip"),
	Asset("ANIM", "anim/junglevines.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "berries",
	"dug_sapling",
	"rope",
}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("berries")
	inst.components.lootdropper:SpawnLootPrefab("dug_sapling")
	inst:Remove()
end

local function dig_up_vines(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("berries")
	inst.components.lootdropper:SpawnLootPrefab("rope")
	inst:Remove()
end

local function dig_up_burnt(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("berries")
	inst:Remove()
end

local function OnBurnt(inst)
	inst:DoTaskInTime(0.5, function() if inst.components.burnable then inst.components.burnable:Extinguish() end
		inst:RemoveComponent("burnable")
		inst:RemoveComponent("propagator")
	
		inst.components.lootdropper:SetLoot({"charcoal"})
			
		if inst.components.workable then
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnFinishCallback(dig_up_burnt)
		end
	end)
    
	inst.AnimState:PlayAnimation("burnt", true)
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

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_junglebush.tex")
	
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
	
	inst.AnimState:SetBank("jungle_bush")
	inst.AnimState:SetBuild("jungle_bush")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("plant")
	
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
	
	MakeLargeBurnable(inst)
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(OnBurnt)
    MakeLargePropagator(inst)

	inst.OnSave = onsave
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function vinesfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("marsh_bush")
	inst.AnimState:SetBuild("junglevines")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("plant")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_vines)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeLargeBurnable(inst)
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(OnBurnt)
    MakeLargePropagator(inst)

	inst.OnSave = onsave
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function redbushplacer(inst)
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
end

return Prefab("kyno_junglebush", fn, assets, prefabs),
Prefab("kyno_junglevines", vinesfn, assets, prefabs),
MakePlacer("kyno_junglebush_placer", "jungle_bush", "jungle_bush", "idle", false, nil, nil, nil, nil, nil, redbushplacer),
MakePlacer("kyno_junglevines_placer", "marsh_bush", "junglevines", "idle", true)