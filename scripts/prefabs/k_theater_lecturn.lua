require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/charlie_lectern.zip"),
}

local prefabs =
{
    "collapse_small",
}

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function OnHit(inst, worker)
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stagehand/hit")
end

local function OnBuilt(inst)
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stagehand/hit")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("charlie_lectern.png")
	
	MakeObstaclePhysics(inst, .2)

    inst.AnimState:SetBank("charlie_lectern")
    inst.AnimState:SetBuild("charlie_lectern")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")

	MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CHARLIE_LECTURN"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeSnowCovered(inst)
    MakeHauntableWork(inst)

    return inst
end

return Prefab("sap_theater_lecturn", fn, assets, prefabs),
MakePlacer("sap_theater_lecturn_placer", "charlie_lectern", "charlie_lectern", "idle")