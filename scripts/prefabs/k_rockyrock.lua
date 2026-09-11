require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/rocky.zip"),
}

local prefabs =
{
	"rock_break_fx"
}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("hide_loop")
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("hide_loop")
	else
		inst.AnimState:PlayAnimation("hide_loop")
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst.components.lootdropper:DropLoot(pt)
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("hide_loop")
	inst.AnimState:PushAnimation("hide_loop")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("rock_flintless.png")
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("rocky")
	inst.AnimState:SetBuild("rocky")
	inst.AnimState:PlayAnimation("hide_loop")
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCKY"
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("sap_rockyrock", fn, assets, prefabs),
MakePlacer("sap_rockyrock_placer", "rocky", "rocky", "hide_loop")
