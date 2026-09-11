require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/interior_wall_decals_batcave.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs = {}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("bat_burrow", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("bat_burrow", true)
	else
		inst.AnimState:PlayAnimation("bat_burrow", true)
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("bat_burrow")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.AnimState:SetScale(0.90,0.90,0.90)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_bat.tex")
	
	inst.AnimState:SetBank("interior_wall_decals_cave")
	inst.AnimState:SetBuild("interior_wall_decals_batcave")
	inst.AnimState:PlayAnimation("bat_burrow", true)
	
	MakeObstaclePhysics(inst, 2.2)
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	inst:AddTag("bathole")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
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

return Prefab("kyno_bathole", fn, assets, prefabs),
MakePlacer("kyno_bathole_placer", "interior_wall_decals_cave", "interior_wall_decals_batcave", "bat_burrow")