require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/altar_glasspiece.zip"),
	Asset("ANIM", "anim/altar_idolpiece.zip"),
	Asset("ANIM", "anim/altar_seedpiece.zip"),
}

local prefabs =
{
    "moonrocknugget",
	"rocks",
    "rock_break_fx",
}

local function onwork(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
		inst:RemoveTag("statue_full")
		inst:RemoveTag("statue_med")
		inst:RemoveTag("statue_low")
		inst.med = false
		inst.low = false
		inst.full = false
        inst:Remove()
    elseif workleft < TUNING.MOONALTAR_ROCKS_MINE / 3 then
        inst.AnimState:PlayAnimation("low")
        inst.AnimState:PushAnimation("low")
		inst:RemoveTag("statue_full")
		inst:RemoveTag("statue_med")
		inst:AddTag("statue_low")
		inst.med = false
		inst.low = true
		inst.full = false
    elseif workleft < TUNING.MOONALTAR_ROCKS_MINE * 2 / 3 then
        inst.AnimState:PlayAnimation("med")
        inst.AnimState:PushAnimation("med")
		inst:RemoveTag("statue_full")
		inst:AddTag("statue_med")
		inst.med = true
		inst.low = false
		inst.full = false
    else
        inst.AnimState:PlayAnimation("full")
        inst.AnimState:PushAnimation("full")
		inst:AddTag("statue_full")
		inst.med = false
		inst.low = false
		inst.full = true
    end
end

local function onsave(inst, data)
	if inst.full then
		data.full = true
	end
	if inst.med then
		data.med = true
	end
	if inst.low then
		data.low = true
	end
end

local function onload(inst, data)
	if data and data.full then
		inst.full = true
		inst.AnimState:PlayAnimation("full")
	end
	if data and data.med then
		inst.med = true
		inst.AnimState:PlayAnimation("med")
	end
	if data and data.low then
		inst.low = true
		inst.AnimState:PlayAnimation("low")
	end
end

local function glassfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("moon_altar_glass_rock.png")

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("altar_glasspiece")
    inst.AnimState:SetBuild("altar_glasspiece")
    inst.AnimState:PlayAnimation("full")
	
	inst.entity:AddTag("celestial_altar_rock")
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")

	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOON_ALTAR_ROCK_GLASS"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MOONALTAR_ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable.savestate = true
	
	MakeSnowCovered(inst)
	
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
	minimap:SetIcon("moon_altar_idol_rock.png")

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("altar_idolpiece")
    inst.AnimState:SetBuild("altar_idolpiece")
    inst.AnimState:PlayAnimation("full")
	
	inst.entity:AddTag("celestial_altar_rock")
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")

	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOON_ALTAR_ROCK_IDOL"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MOONALTAR_ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable.savestate = true
	
	MakeSnowCovered(inst)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end

local function seedfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("moon_altar_seed_rock.png")

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("altar_seedpiece")
    inst.AnimState:SetBuild("altar_seedpiece")
    inst.AnimState:PlayAnimation("full")
	
	inst.entity:AddTag("celestial_altar_rock")
	inst.entity:AddTag("statue")
	inst.entity:AddTag("structure")

	MakeSnowCoveredPristine(inst)
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOON_ALTAR_ROCK_SEED"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MOONALTAR_ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable.savestate = true
	
	MakeSnowCovered(inst)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end

return Prefab("sap_invitingformation1", glassfn, assets, prefabs),
Prefab("sap_invitingformation2", idolfn, assets, prefabs),
Prefab("sap_invitingformation3", seedfn, assets, prefabs),
MakePlacer("sap_invitingformation1_placer", "altar_glasspiece", "altar_glasspiece", "full"),
MakePlacer("sap_invitingformation2_placer", "altar_idolpiece", "altar_idolpiece", "full"),
MakePlacer("sap_invitingformation3_placer", "altar_seedpiece", "altar_seedpiece", "full")