require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/palmleaf_hut.zip"),
	Asset("ANIM", "anim/palmleaf_hut_shdw.zip"),
}

local prefabs =
{
	"sap_palmleaf_hut_shadow",
}

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle", true)

		if inst.shadow then
			inst.shadow.AnimState:PlayAnimation("hit")
			inst.shadow.AnimState:PushAnimation("idle", true)
		end
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)

	if inst.shadow then
		inst.shadow.AnimState:PlayAnimation("place")
		inst.shadow.AnimState:PushAnimation("idle", true)
	end
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end
end

local function onload(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
	end
end

local function onremove(inst)
	if inst.shadow then
		inst.shadow:Remove()
	end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_palmtree_hutch.tex")
	
	inst.AnimState:SetBank("hut")
	inst.AnimState:SetBuild("palmleaf_hut")
	inst.AnimState:PlayAnimation("idle", true)
	
	-- MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("shelter")
	inst:AddTag("dryshelter")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
	
	inst:AddComponent("insulator")
	inst.components.insulator:SetSummer()
    inst.components.insulator:SetInsulation(TUNING.INSULATION_SMALL)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)

	inst.shadow = SpawnPrefab("sap_palmleaf_hut_shadow")
	inst:DoTaskInTime(0, function()
	inst.shadow.Transform:SetPosition(inst:GetPosition():Get())
	end)
	
	MakeSnowCovered(inst, .01)
	
	inst:ListenForEvent("onbuilt", onbuilt)

	MakeLargeBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)

	inst.OnSave = onsave 
	inst.OnLoad = onload

	inst.OnRemoveEntity = onremove

	return inst
end

local function shadowfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	inst.AnimState:SetBank("palmleaf_hut_shdw")
	inst.AnimState:SetBuild("palmleaf_hut_shdw")
	inst.AnimState:PlayAnimation("idle")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddTag("NOCLICK")
	inst:AddTag("FX")

	inst.persists = false

	return inst
end

return Prefab("sap_palmleaf_hut", fn, assets, prefabs),
Prefab("sap_palmleaf_hut_shadow", shadowfn, assets),
MakePlacer("sap_palmleaf_hut_placer", "hut", "palmleaf_hut", "idle") 