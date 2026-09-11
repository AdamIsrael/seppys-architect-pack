require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/altar_pillar.zip"),
}

local prefabs = {}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("idle", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("idle", true)
	else
		inst.AnimState:PlayAnimation("idle", true)
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("altar_pillar")
	inst.AnimState:SetBuild("altar_pillar")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("pillar")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onfinish)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetWorkLeft(3)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("sap_altar_pillar", fn, assets, prefabs),
MakePlacer("sap_altar_pillar_placer", "altar_pillar", "altar_pillar", "idle")
