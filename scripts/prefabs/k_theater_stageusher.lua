require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/stagehand.zip"),
	Asset("ANIM", "anim/stagehand_sts.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function OnHit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stagehand/hit")
end

local function DoPeek(inst)
	inst:DoTaskInTime(5 + math.random() * 5, function() DoPeek(inst) end)
	if math.random() <0.5 then
		inst.AnimState:PlayAnimation("peeking_idle_loop_01")
	else
		inst.AnimState:PlayAnimation("peeking_idle_loop_02")
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stagehand/hit")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
    MakeObstaclePhysics(inst, .5)
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(2.5, 1.5)
	
    inst.AnimState:SetBank("stagehand")
    inst.AnimState:SetBuild("stagehand_sts")
    inst.AnimState:PlayAnimation("idle")
	
	inst.AnimState:OverrideSymbol("dark_spew", "stagehand", "dark_spew")
    inst.AnimState:OverrideSymbol("fx", "stagehand", "fx")
    inst.AnimState:OverrideSymbol("stagehand_fingers", "stagehand", "stagehand_fingers")
    
	inst:AddTag("structure")

	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_CONTRARREGRA"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetWorkLeft(6)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
    MakeSnowCovered(inst)
	
	-- DoPeek(inst)
	
    return inst
end

return Prefab("kyno_theater_stageusher", fn, assets, prefabs),
MakePlacer("kyno_theater_stageusher_placer", "stagehand", "stagehand_sts", "idle")