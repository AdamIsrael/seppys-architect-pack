require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/unbuilt_house.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("unbuilt")
	inst.AnimState:PushAnimation("unbuilt")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("pighouse.png")
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("unbuilt_house")
    inst.AnimState:SetBuild("unbuilt_house")
    inst.AnimState:PlayAnimation("unbuilt")
    
	inst:AddTag("structure")
	inst:AddTag("broken_house")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "PIGHOUSE"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_unbuilthouse", fn, assets),
MakePlacer("sap_unbuilthouse_placer", "unbuilt_house", "unbuilt_house", "unbuilt")