require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/charlie_stage.zip"),
	Asset("ANIM", "anim/charlie_seat.zip"),
}

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function OnHammered2(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("charlie_stage")
    inst.AnimState:SetBuild("charlie_Stage")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetFinalOffset(1)
	
	inst:AddTag("structure")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.bgprefab = SpawnPrefab("sap_theater_stagebg")
		inst.bgprefab.entity:SetParent(inst.entity)
	end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "TURF_ROAD"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:DoTaskInTime(FRAMES * 1, createExtras)
	
	MakeHauntableWork(inst)

	return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Transform:SetRotation(90)
    inst.Transform:SetScale(0.98,0.98,0.98)

    inst.AnimState:SetBank("charlie_stage")
    inst.AnimState:SetBuild("charlie_Stage")
    inst.AnimState:PlayAnimation("lip")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetFinalOffset(0)

    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function fn3()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("charlie_seat")
    inst.AnimState:SetBuild("charlie_seat")
    inst.AnimState:PlayAnimation("test")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetFinalOffset(1)
	
	inst:AddTag("structure")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "TURF_ROAD"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered2)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

	return inst
end

return Prefab("sap_theater_stage", fn, assets),
Prefab("sap_theater_stagebg", fn2, assets),
Prefab("sap_theater_seat", fn3, assets),
MakePlacer("sap_theater_stage_placer", "charlie_stage", "charlie_Stage", "idle", true),
MakePlacer("sap_theater_seat_placer", "charlie_seat", "charlie_seat", "test")