require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/metal_spider.zip"),
    Asset("ANIM", "anim/metal_claw.zip"),
    Asset("ANIM", "anim/metal_leg.zip"),
    Asset("ANIM", "anim/metal_head.zip"),
	
	Asset("ANIM", "anim/metal_hulk_build.zip"),
	Asset("ANIM", "anim/metal_hulk_basic.zip"),
    Asset("ANIM", "anim/metal_hulk_attacks.zip"),
    Asset("ANIM", "anim/metal_hulk_actions.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("dormant_hit")
end

local function onhit_large(inst, worker)
	inst.AnimState:PlayAnimation("idle")
end

local function spiderfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_ironhulk_spider.tex")
	
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(6, 2)
	
	inst.AnimState:SetBank("metal_spider")
	inst.AnimState:SetBuild("metal_spider")
	inst.AnimState:PlayAnimation("mossy_full", true)
	
	MakeObstaclePhysics(inst, 2)
	
	inst:AddTag("structure")
	inst:AddTag("ironhulk")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)

	return inst
end

local function legfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetSixFaced()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_ironhulk_leg.tex")
	
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(3, 2)
	
	inst.AnimState:SetBank("metal_leg")
	inst.AnimState:SetBuild("metal_leg")
	inst.AnimState:PlayAnimation("mossy_full", true)
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst:AddTag("structure")
	inst:AddTag("ironhulk")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)

	return inst
end

local function headfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetSixFaced()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_ironhulk_head.tex")
	
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(4, 2)
	
	inst.AnimState:SetBank("metal_head")
	inst.AnimState:SetBuild("metal_head")
	inst.AnimState:PlayAnimation("mossy_full", true)
	
	MakeObstaclePhysics(inst, 2)
	
	inst:AddTag("structure")
	inst:AddTag("ironhulk")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)

	return inst
end

local function clawfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetSixFaced()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_ironhulk_claw.tex")
	
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(3, 2)
	
	inst.AnimState:SetBank("metal_claw")
	inst.AnimState:SetBuild("metal_claw")
	inst.AnimState:PlayAnimation("mossy_full", true)
	
	MakeObstaclePhysics(inst, 1.2)
	
	inst:AddTag("structure")
	inst:AddTag("ironhulk")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)

	return inst
end

local function largefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetSixFaced()
	
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(6, 3.5)
	
	inst.AnimState:SetBank("metal_hulk")
	inst.AnimState:SetBuild("metal_hulk_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 2.5)
	
	inst:AddTag("ancient_hulk") 
    inst:AddTag("structure")   
    inst:AddTag("mech")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_large)
	inst.components.workable:SetWorkLeft(5)
	
	inst:AddComponent("savedrotation")

	return inst
end

return Prefab("kyno_ironhulk_spider", spiderfn, assets, prefabs),
MakePlacer("kyno_ironhulk_spider_placer", "metal_spider", "metal_spider", "mossy_full"),

Prefab("kyno_ironhulk_leg", legfn, assets, prefabs),
MakePlacer("kyno_ironhulk_leg_placer", "metal_leg", "metal_leg", "full"),

Prefab("kyno_ironhulk_head", headfn, assets, prefabs),
MakePlacer("kyno_ironhulk_head_placer", "metal_head", "metal_head", "full"),

Prefab("kyno_ironhulk_claw", clawfn, assets, prefabs),
MakePlacer("kyno_ironhulk_claw_placer", "metal_claw", "metal_claw", "mossy_full"),

Prefab("kyno_ironhulk_large", largefn, assets, prefabs),
MakePlacer("kyno_ironhulk_large_placer", "metal_hulk", "metal_hulk_build", "idle", false, nil, nil, nil, 60, nil)