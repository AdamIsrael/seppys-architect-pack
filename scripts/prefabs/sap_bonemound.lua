require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/hound_base.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("death")
    inst.AnimState:PushAnimation("death")
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("death")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("hound_mound.png")
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("houndbase")
    inst.AnimState:SetBuild("hound_base")
    inst.AnimState:PlayAnimation("death")
    
	inst:AddTag("structure")
	inst:AddTag("bone")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	-- inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/mound_LP", "loop")
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "HOUNDMOUND"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_bonemound", fn, assets),
MakePlacer("sap_bonemound_placer", "houndbase", "hound_base", "death")