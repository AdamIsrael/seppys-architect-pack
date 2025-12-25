require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/fountain_pillar.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"kyno_teeteringpillar_collapsed",
}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("pillar_collapse")
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("pillar", true)
	else
		inst.AnimState:PlayAnimation("pillar", true)
	end
end

local function onwork_pillar(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("pillar_collapsed")
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("pillar_collapsed", true)
	else
		inst.AnimState:PlayAnimation("pillar_collapsed", true)
	end
end

local function onfinish(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	-- inst.AnimState:PushAnimation("pillar_collapsed")
	SpawnPrefab("kyno_teeteringpillar_collapsed").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onfinish_pillar(inst, worker)
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
	
	inst.Transform:SetEightFaced()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_pillar.tex")
	
	inst.AnimState:SetBank("fountain_pillar")
	inst.AnimState:SetBuild("fountain_pillar")
	inst.AnimState:PlayAnimation("pillar", true)
	
	MakeObstaclePhysics(inst, 0.5)
	
	inst:AddTag("structure")
	inst:AddTag("pillar_fountain")
	
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
	
	inst:AddComponent("savedrotation")

	return inst
end

local function collapsedfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("pig_ruins_pillar.png")
	
	inst.AnimState:SetBank("fountain_pillar")
	inst.AnimState:SetBuild("fountain_pillar")
	inst.AnimState:PlayAnimation("pillar_collapsed", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("pillar_fountain")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork_pillar)
	inst.components.workable:SetOnFinishCallback(onfinish_pillar)

	return inst
end

return Prefab("kyno_teeteringpillar", fn, assets, prefabs),
Prefab("kyno_teeteringpillar_collapsed", collapsedfn, assets, prefabs),
MakePlacer("kyno_teeteringpillar_placer", "fountain_pillar", "fountain_pillar", "pillar", true, nil, nil, nil, 90, nil)