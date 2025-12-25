require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/ruins_giant_head.zip"),
	Asset("ANIM", "anim/statue_pig_ruins_pig.zip"),
	Asset("ANIM", "anim/statue_pig_ruins_ant.zip"),
	Asset("ANIM", "anim/statue_pig_ruins_idol.zip"),
	Asset("ANIM", "anim/statue_pig_ruins_plaque.zip"),
	Asset("ANIM", "anim/statue_pig_ruins_mushroom.zip"),
	Asset("ANIM", "anim/statue_pig_ruins_idol_blue.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("med", true)
		inst.norelic = true
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("extract_success", true)
		inst.norelic = true
	else
		inst.AnimState:PlayAnimation("full", true)
		inst.norelic = false
	end
end

local function onwork_relics(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("med", true)
		inst:RemoveTag("statue_is_full")
		inst.norelic = true
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("extract_success", true)
		inst:RemoveTag("statue_is_full")
		inst.norelic = true
	else
		inst.AnimState:PlayAnimation("full", true)
		inst:AddTag("statue_is_full")
		inst.norelic = false
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("full")
end

local function shine(inst)
if inst:HasTag("statue_is_full") then
	inst:DoTaskInTime(4+math.random()*5, function() shine(inst) end)
		inst.AnimState:PlayAnimation("sparkle")
		inst.AnimState:PushAnimation("full")
	end
end

local function onsave(inst, data)
	if inst.norelic then
		data.norelic = true
	end
end

local function onload(inst, data)
	if data and data.norelic then
		inst.norelic = true
		inst.AnimState:PlayAnimation("extract_success")
	end
end

local function headfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_head.tex")
	
	inst.AnimState:SetBank("pig_ruins_head")
	inst.AnimState:SetBuild("ruins_giant_head")
	inst.AnimState:PlayAnimation("full", true)
	
	local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)  
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

local function pigfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_pig.tex")
	
	inst.AnimState:SetBank("statue_pig_ruins_pig")
	inst.AnimState:SetBuild("statue_pig_ruins_pig")
	inst.AnimState:PlayAnimation("full", true)
	
	local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)  
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	inst:AddTag("statue_is_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork_relics)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	shine(inst)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

local function antfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_ant.tex")
	
	inst.AnimState:SetBank("statue_pig_ruins_ant")
	inst.AnimState:SetBuild("statue_pig_ruins_ant")
	inst.AnimState:PlayAnimation("full", true)
	
	local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)  
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	inst:AddTag("statue_is_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork_relics)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	shine(inst)

	inst.OnSave = onsave 
    inst.OnLoad = onload
	
	return inst
end

local function idolfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_idol.tex")
	
	inst.AnimState:SetBank("statue_pig_ruins_idol")
	inst.AnimState:SetBuild("statue_pig_ruins_idol")
	inst.AnimState:PlayAnimation("full", true)
	
	local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)  
	
	MakeObstaclePhysics(inst, 0.75)
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

local function plaquefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_plaque.tex")
	
	inst.AnimState:SetBank("statue_pig_ruins_plaque")
	inst.AnimState:SetBuild("statue_pig_ruins_plaque")
	inst.AnimState:PlayAnimation("full", true)
	
	local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)  
	
	MakeObstaclePhysics(inst, 0.75)
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

local function trufflefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_truffle.tex")
	
	inst.AnimState:SetBank("statue_pig_ruins_mushroom")
	inst.AnimState:SetBuild("statue_pig_ruins_mushroom")
	inst.AnimState:PlayAnimation("full", true)
	
	local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)  
	
	MakeObstaclePhysics(inst, 0.75)
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	inst:AddTag("statue_is_full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork_relics)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)

	shine(inst)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload
	
	return inst
end

local function sowfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_sow.tex")
	
	inst.AnimState:SetBank("statue_pig_ruins_idol_blue")
	inst.AnimState:SetBuild("statue_pig_ruins_idol_blue")
	inst.AnimState:PlayAnimation("full", true)
	
	local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)  
	
	MakeObstaclePhysics(inst, 0.75)
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload
	
	return inst
end

return Prefab("kyno_ruins_head", headfn, assets, prefabs),
MakePlacer("kyno_ruins_head_placer", "pig_ruins_head", "ruins_giant_head", "full"),

Prefab("kyno_ruins_pigstatue", pigfn, assets, prefabs),
MakePlacer("kyno_ruins_pigstatue_placer", "statue_pig_ruins_pig", "statue_pig_ruins_pig", "full"),

Prefab("kyno_ruins_antstatue", antfn, assets, prefabs),
MakePlacer("kyno_ruins_antstatue_placer", "statue_pig_ruins_ant", "statue_pig_ruins_ant", "full"),

Prefab("kyno_ruins_idolstatue", idolfn, assets, prefabs),
MakePlacer("kyno_ruins_idolstatue_placer", "statue_pig_ruins_idol", "statue_pig_ruins_idol", "full"),

Prefab("kyno_ruins_plaquestatue", plaquefn, assets, prefabs),
MakePlacer("kyno_ruins_plaquestatue_placer", "statue_pig_ruins_plaque", "statue_pig_ruins_plaque", "full"),

Prefab("kyno_ruins_trufflestatue", trufflefn, assets, prefabs),
MakePlacer("kyno_ruins_trufflestatue_placer", "statue_pig_ruins_mushroom", "statue_pig_ruins_mushroom", "full"),

Prefab("kyno_ruins_sowstatue", sowfn, assets, prefabs),
MakePlacer("kyno_ruins_sowstatue_placer", "statue_pig_ruins_idol_blue", "statue_pig_ruins_idol_blue", "full")