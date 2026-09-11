require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/cave_entrance.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"rock_break_fx"
}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("low", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("med", true)
	else
		inst.AnimState:PlayAnimation("idle_closed", true)
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)
	SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("idle_closed")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cave_closed.png")
	
	inst.AnimState:SetBank("cave_entrance")
	inst.AnimState:SetBuild("cave_entrance")
	inst.AnimState:PlayAnimation("idle_closed", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.inspectable.nameoverride = "CAVE_ENTRANCE"
	
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

return Prefab("kyno_rock_sinkhole", fn, assets, prefabs),
MakePlacer("kyno_rock_sinkhole_placer", "cave_entrance", "cave_entrance", "idle_closed")