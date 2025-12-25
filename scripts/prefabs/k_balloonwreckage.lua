require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/balloon_wreckage.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs = 
{
	"kyno_balloon_fx",
}

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
	inst.components.lootdropper:DropLoot()
	if inst.components.container then inst.components.container:DropEverything() end
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit_balloon(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("balloon")
		inst.AnimState:PushAnimation("balloon", true)
	end
end

local function onhit_basket(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("basket")
		inst.AnimState:PushAnimation("basket", true)
	end
end

local function onhit_flags(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("flags")
		inst.AnimState:PushAnimation("flags", true)
	end
end

local function onhit_sandbag(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("sandbag")
		inst.AnimState:PushAnimation("sandbag", true)
	end
end

local function onhit_suitcase(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("suitcase")
		inst.AnimState:PushAnimation("suitcase", true)
	end
end

local function onhit_trunk(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("trunk")
		inst.AnimState:PushAnimation("trunk", true)
	end
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end
end

local function onload(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
	end
end

local function balloonfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("balloon_wreckage")
	inst.AnimState:SetBuild("balloon_wreckage")
	inst.AnimState:PlayAnimation("balloon", true)
	
	MakeObstaclePhysics(inst, .75)
	
	inst:AddTag("structure")
	inst:AddTag("wreck")
	
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
	inst.components.workable:SetOnWorkCallback(onhit_balloon)
	inst.components.workable:SetWorkLeft(1)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

local function fxfn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
    
    inst.AnimState:SetBank("balloon_wreckage")
    inst.AnimState:SetBuild("balloon_wreckage")
    inst.AnimState:PlayAnimation("ground_scrape_decal")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3) 
	
    inst.persists = false
	
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(1)

    return inst
end

local function basketfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_balloon_wreck.tex")

	
	inst.AnimState:SetBank("balloon_wreckage")
	inst.AnimState:SetBuild("balloon_wreckage")
	inst.AnimState:PlayAnimation("basket", true)
	
	MakeObstaclePhysics(inst, .75)
	
	inst:AddTag("structure")
	inst:AddTag("wreck")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
	inst.towerprefab =  SpawnPrefab("kyno_balloon_fx")
	inst.towerprefab.entity:SetParent(inst.entity)
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_basket)
	inst.components.workable:SetWorkLeft(1)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload
	
	inst:DoTaskInTime(FRAMES * 1, createExtras)

	return inst
end

local function flagsfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("balloon_wreckage")
	inst.AnimState:SetBuild("balloon_wreckage")
	inst.AnimState:PlayAnimation("flags", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3) 
	
	MakeObstaclePhysics(inst, .75)
	
	inst:AddTag("structure")
	inst:AddTag("wreck")
	
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
	inst.components.workable:SetOnWorkCallback(onhit_flags)
	inst.components.workable:SetWorkLeft(1)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

local function bagsandfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("balloon_wreckage")
	inst.AnimState:SetBuild("balloon_wreckage")
	inst.AnimState:PlayAnimation("sandbag", true)
	
	MakeObstaclePhysics(inst, .75)
	
	inst:AddTag("structure")
	inst:AddTag("wreck")
	
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
	inst.components.workable:SetOnWorkCallback(onhit_sandbag)
	inst.components.workable:SetWorkLeft(1)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

local function suitcasefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("balloon_wreckage")
	inst.AnimState:SetBuild("balloon_wreckage")
	inst.AnimState:PlayAnimation("suitcase", true)
	
	MakeObstaclePhysics(inst, .75)
	
	inst:AddTag("structure")
	inst:AddTag("wreck")
	
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
	inst.components.workable:SetOnWorkCallback(onhit_suitcase)
	inst.components.workable:SetWorkLeft(1)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

local function trunkfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("balloon_wreckage")
	inst.AnimState:SetBuild("balloon_wreckage")
	inst.AnimState:PlayAnimation("trunk", true)
	
	MakeObstaclePhysics(inst, .75)
	
	inst:AddTag("structure")
	inst:AddTag("wreck")
	
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
	inst.components.workable:SetOnWorkCallback(onhit_trunk)
	inst.components.workable:SetWorkLeft(1)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

return Prefab("kyno_balloon_wreck", balloonfn, assets, prefabs),
MakePlacer("kyno_balloon_wreck_placer", "balloon_wreckage", "balloon_wreckage", "balloon"),

Prefab("kyno_basket_wreck", basketfn, assets, prefabs),
MakePlacer("kyno_basket_wreck_placer", "balloon_wreckage", "balloon_wreckage", "basket"),

Prefab("kyno_sandbag_wreck", bagsandfn, assets, prefabs),
MakePlacer("kyno_sandbag_wreck_placer", "balloon_wreckage", "balloon_wreckage", "sandbag"),

Prefab("kyno_flags_wreck", flagsfn, assets, prefabs),
MakePlacer("kyno_flags_wreck_placer", "balloon_wreckage", "balloon_wreckage", "flags"),

Prefab("kyno_suitcase_wreck", suitcasefn, assets, prefabs),
MakePlacer("kyno_suitcase_wreck_placer", "balloon_wreckage", "balloon_wreckage", "suitcase"),

Prefab("kyno_trunk_wreck", trunkfn, assets, prefabs),
MakePlacer("kyno_trunk_wreck_placer", "balloon_wreckage", "balloon_wreckage", "trunk"),

Prefab("kyno_balloon_fx", fxfn, assets, prefabs)