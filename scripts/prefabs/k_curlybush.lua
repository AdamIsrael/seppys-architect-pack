require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/marsh_bush.zip"),
	Asset("ANIM", "anim/curly_bush_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "berries",
	"dug_marsh_bush",
}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("berries")
	inst.components.lootdropper:SpawnLootPrefab("dug_marsh_bush")
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
	minimap:SetIcon("kyno_curlybush.tex")
	
	inst.AnimState:SetBank("marsh_bush")
	inst.AnimState:SetBuild("curly_bush_build")
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

return Prefab("sap_curlybush", fn, assets, prefabs),
MakePlacer("sap_curlybush_placer", "marsh_bush", "curly_bush_build", "idle")