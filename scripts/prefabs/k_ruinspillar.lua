require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/interior_wall_decals_ruins.zip"),
	Asset("ANIM", "anim/interior_wall_decals_ruins_blue.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"sap_pillar_front_broken",
	"sap_pillar_front_blue_broken",
}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("pillar_front_break_2")
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("pillar_front_break_1", true)
	else
		inst.AnimState:PlayAnimation("pillar_front", true)
	end
end

local function onwork_pillar(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("pillar_front_broken")
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("pillar_front_broken", true)
	else
		inst.AnimState:PlayAnimation("pillar_front_broken", true)
	end
end

local function onfinish(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	inst.AnimState:PushAnimation("pillar_front_crumble")
	SpawnPrefab("sap_pillar_front_broken").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onfinish_blue(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	inst.AnimState:PushAnimation("pillar_front_crumble")
	SpawnPrefab("sap_pillar_front_blue_broken").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onfinish_pillar(inst, worker)
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function pillarfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetEightFaced()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_pillar.tex")
	
	inst.AnimState:SetBank("interior_wall_decals_ruins")
	inst.AnimState:SetBuild("interior_wall_decals_ruins")
	inst.AnimState:PlayAnimation("pillar_front", true)
	
	MakeObstaclePhysics(inst, 0.5)
	
	inst:AddTag("structure")
	inst:AddTag("pillar_pigruins")
	
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
	
	return inst
end

local function pillarbluefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetEightFaced()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_pillar.tex")
	
	inst.AnimState:SetBank("interior_wall_decals_ruins")
	inst.AnimState:SetBuild("interior_wall_decals_ruins_blue")
	inst.AnimState:PlayAnimation("pillar_front", true)
	
	MakeObstaclePhysics(inst, 0.5)
	
	inst:AddTag("structure")
	inst:AddTag("pillar_pigruins")
	
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
	inst.components.workable:SetOnFinishCallback(onfinish_blue)
	
	return inst
end

local function brokenfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_pillar.tex")
	
	inst.AnimState:SetBank("interior_wall_decals_ruins")
	inst.AnimState:SetBuild("interior_wall_decals_ruins")
	inst.AnimState:PlayAnimation("pillar_front_broken", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("pillar_pigruins_broken")
	
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

local function brokenbluefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_pillar.tex")
	
	inst.AnimState:SetBank("interior_wall_decals_ruins")
	inst.AnimState:SetBuild("interior_wall_decals_ruins_blue")
	inst.AnimState:PlayAnimation("pillar_front_broken", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("pillar_pigruins_broken")
	
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

return Prefab("sap_pillar_front", pillarfn, assets, prefabs),
Prefab("sap_pillar_front_broken", brokenfn, assets, prefabs),
MakePlacer("sap_pillar_front_placer", "interior_wall_decals_ruins", "interior_wall_decals_ruins", "pillar_front"),

Prefab("sap_pillar_front_blue", pillarbluefn, assets, prefabs),
Prefab("sap_pillar_front_blue_broken", brokenbluefn, assets, prefabs),
MakePlacer("sap_pillar_front_blue_placer", "interior_wall_decals_ruins", "interior_wall_decals_ruins_blue", "pillar_front")