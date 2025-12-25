local assets =
{
    Asset("ANIM", "anim/critterlab.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function blink(inst)
    inst.AnimState:PlayAnimation("proximity_loop"..math.random(4))
	inst.idletask = inst:DoTaskInTime(math.random() + 1.0, blink)
end

local function onturnoff(inst)
	if inst.idletask ~= nil then
		inst.idletask:Cancel()
		inst.idletask = nil
	end
    inst.AnimState:PushAnimation("idle", false)
	inst.SoundEmitter:KillSound("loop")
end

local function onturnon(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/together/critter_lab/idle", "loop")
	blink(inst)
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function rename(inst)
    inst.components.named:PickNewName()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("critterlab.png")
	minimap:SetPriority(5)

    inst.AnimState:SetBank("critterlab")
    inst.AnimState:SetBuild("critterlab")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("critterlab")
	inst:AddTag("structure")
    inst:AddTag("antlion_sinkhole_blocker")

    --prototyper (from prototyper component) added to pristine state for optimization
    inst:AddTag("prototyper")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CRITTERLAB"
	
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = onturnon
    inst.components.prototyper.onturnoff = onturnoff
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.CRITTERLAB

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Devil's Den", "Demons Crew", "Rock Den", "Waste Your Food Here" }
    inst.components.named:PickNewName()
    inst:DoPeriodicTask(5, rename)
	
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("kyno_critterlab", fn, assets, prefabs),
MakePlacer("kyno_critterlab_placer", "critterlab", "critterlab", "idle")