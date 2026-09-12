require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/jamesbucket.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
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
	
    MakeObstaclePhysics(inst, .3)
	
	inst.AnimState:SetScale(1.1, 1.1, 1.1)
	
    inst.AnimState:SetBank("jamesbucket")
    inst.AnimState:SetBuild("jamesbucket")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("bucket")
	inst:AddTag("jamesbucket")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Bucket", "James Bucket", "Bucket James", "The Bucket" }
    inst.components.named:PickNewName()
    inst:DoPeriodicTask(5, rename)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function bucketplacetestfn(inst)
	inst.AnimState:SetScale(1.1, 1.1, 1.1)
end

return Prefab("sap_bucket", fn, assets),
MakePlacer("sap_bucket_placer", "jamesbucket", "jamesbucket", "idle", false, nil, nil, nil, nil, nil, bucketplacetestfn)