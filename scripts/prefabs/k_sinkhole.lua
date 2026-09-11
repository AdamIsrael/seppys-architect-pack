require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/cave_entrance.zip"),
	Asset("ANIM", "anim/kyno_cavehole.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

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
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("open")
    inst.AnimState:PushAnimation("open")
end

local function onhit_closed(inst, worker)
    inst.AnimState:PlayAnimation("no_access")
    inst.AnimState:PushAnimation("no_access")
end

local function onhit_vip(inst, worker)
    inst.AnimState:PlayAnimation("over_capacity")
    inst.AnimState:PushAnimation("over_capacity")
end

local function onhit_hole(inst, worker)
    inst.AnimState:PlayAnimation("idle_open")
    inst.AnimState:PushAnimation("idle_open")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cave_open.png")
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("cave_entrance")
    inst.AnimState:SetBuild("cave_entrance")
    inst.AnimState:PlayAnimation("open")
    
	inst:AddTag("structure")
	inst:AddTag("entrance")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CAVE_ENTRANCE"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function closedfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cave_no_access.png")
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("cave_entrance")
    inst.AnimState:SetBuild("cave_entrance")
    inst.AnimState:PlayAnimation("no_access")
    
	inst:AddTag("structure")
	inst:AddTag("entrance_closed")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CAVE_ENTRANCE"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function vipfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cave_overcapacity.png")
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("cave_entrance")
    inst.AnimState:SetBuild("cave_entrance")
    inst.AnimState:PlayAnimation("over_capacity")
    
	inst:AddTag("structure")
	inst:AddTag("entrance_over_capacity")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CAVE_ENTRANCE"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_vip)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function holefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cave_hole.png")
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("kyno_cavehole")
    inst.AnimState:SetBuild("kyno_cavehole")
    inst.AnimState:PlayAnimation("idle_open")
    
	inst:AddTag("structure")
	inst:AddTag("entrance_hole")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CAVE_ENTRANCE"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_hole)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_sinkhole", fn, assets),
Prefab("sap_sinkhole_closed", closedfn, assets),
Prefab("sap_sinkhole_vip", vipfn, assets),
Prefab("sap_cavehole", holefn, assets),
MakePlacer("sap_sinkhole_placer", "cave_entrance", "cave_entrance", "open"),
MakePlacer("sap_sinkhole_closed_placer", "cave_entrance", "cave_entrance", "no_access"),
MakePlacer("sap_sinkhole_vip_placer", "cave_entrance", "cave_entrance", "over_capacity"),
MakePlacer("sap_cavehole_placer", "kyno_cavehole", "kyno_cavehole", "idle_open")