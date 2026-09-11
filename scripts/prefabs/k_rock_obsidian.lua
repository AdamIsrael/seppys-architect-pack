require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/rock_obsidian.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"rock_break_fx"
}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("low")
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("med")
	else
		inst.AnimState:PlayAnimation("full")
	end
end

local function onfinish_obsidian(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst.components.lootdropper:DropLoot(pt)
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("full")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_obsidian.tex")
	
	inst.AnimState:SetBank("rock_obsidian")
	inst.AnimState:SetBuild("rock_obsidian")
	inst.AnimState:PlayAnimation("full")
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish_obsidian)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("kyno_rock_obsidian", fn, assets, prefabs),
MakePlacer("kyno_rock_obsidian_placer", "rock_obsidian", "rock_obsidian", "full")