require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/sculpture_hound.zip"),
	Asset("ANIM", "anim/sculpture_hound_moonrock_build.zip"),
	
	Asset("ANIM", "anim/sculpture_werepig.zip"),
	Asset("ANIM", "anim/sculpture_werepig_moonrock_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs = {}

local function onwork1(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("atk", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("atk", true)
	else
		inst.AnimState:PlayAnimation("atk", true)
	end
end

local function onwork2(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("atk2", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("atk2", true)
	else
		inst.AnimState:PlayAnimation("atk2", true)
	end
end

local function onwork3(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("death", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("death", true)
	else
		inst.AnimState:PlayAnimation("death", true)
	end
end

local function onwork4(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("death2", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("death2", true)
	else
		inst.AnimState:PlayAnimation("death2", true)
	end
end

local function onwork5(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("howl", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("howl", true)
	else
		inst.AnimState:PlayAnimation("howl", true)
	end
end

local function onwork6(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("howl2", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("howl2", true)
	else
		inst.AnimState:PlayAnimation("howl2", true)
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function hound1fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	inst.AnimState:SetBank("sculpture_hound")
	inst.AnimState:SetBuild("sculpture_hound_moonrock_build")
	inst.AnimState:PlayAnimation("atk", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("moon_gargoyle")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("savedrotation")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOONROCK_PIECES"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork1)
	inst.components.workable:SetOnFinishCallback(onfinish)

	return inst
end

local function hound2fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	inst.AnimState:SetBank("sculpture_hound")
	inst.AnimState:SetBuild("sculpture_hound_moonrock_build")
	inst.AnimState:PlayAnimation("atk2", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("moon_gargoyle")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOONROCK_PIECES"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork2)
	inst.components.workable:SetOnFinishCallback(onfinish)

	return inst
end

local function hound3fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	inst.AnimState:SetBank("sculpture_hound")
	inst.AnimState:SetBuild("sculpture_hound_moonrock_build")
	inst.AnimState:PlayAnimation("death", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("moon_gargoyle")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("savedrotation")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOONROCK_PIECES"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork3)
	inst.components.workable:SetOnFinishCallback(onfinish)

	return inst
end

local function hound4fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	inst.AnimState:SetBank("sculpture_hound")
	inst.AnimState:SetBuild("sculpture_hound_moonrock_build")
	inst.AnimState:PlayAnimation("death2", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("moon_gargoyle")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOONROCK_PIECES"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork4)
	inst.components.workable:SetOnFinishCallback(onfinish)

	return inst
end

local function pig1fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	inst.AnimState:SetBank("sculpture_werepig")
	inst.AnimState:SetBuild("sculpture_werepig_moonrock_build")
	inst.AnimState:PlayAnimation("atk", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("moon_gargoyle")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOONROCK_PIECES"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork1)
	inst.components.workable:SetOnFinishCallback(onfinish)

	return inst
end

local function pig2fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	inst.AnimState:SetBank("sculpture_werepig")
	inst.AnimState:SetBuild("sculpture_werepig_moonrock_build")
	inst.AnimState:PlayAnimation("atk2", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("moon_gargoyle")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOONROCK_PIECES"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork2)
	inst.components.workable:SetOnFinishCallback(onfinish)

	return inst
end

local function pig3fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	inst.AnimState:SetBank("sculpture_werepig")
	inst.AnimState:SetBuild("sculpture_werepig_moonrock_build")
	inst.AnimState:PlayAnimation("death", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("moon_gargoyle")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOONROCK_PIECES"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork3)
	inst.components.workable:SetOnFinishCallback(onfinish)

	return inst
end

local function pig4fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	inst.AnimState:SetBank("sculpture_werepig")
	inst.AnimState:SetBuild("sculpture_werepig_moonrock_build")
	inst.AnimState:PlayAnimation("death2", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("moon_gargoyle")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOONROCK_PIECES"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork4)
	inst.components.workable:SetOnFinishCallback(onfinish)

	return inst
end

local function pig5fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	inst.AnimState:SetBank("sculpture_werepig")
	inst.AnimState:SetBuild("sculpture_werepig_moonrock_build")
	inst.AnimState:PlayAnimation("howl", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("moon_gargoyle")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("savedrotation")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOONROCK_PIECES"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork5)
	inst.components.workable:SetOnFinishCallback(onfinish)

	return inst
end

local function pig6fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	inst.AnimState:SetBank("sculpture_werepig")
	inst.AnimState:SetBuild("sculpture_werepig_moonrock_build")
	inst.AnimState:PlayAnimation("howl2", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("moon_gargoyle")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOONROCK_PIECES"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork6)
	inst.components.workable:SetOnFinishCallback(onfinish)

	return inst
end

return Prefab("kyno_hound_gargoyle_1", hound1fn, assets, prefabs),
Prefab("kyno_hound_gargoyle_2", hound2fn, assets, prefabs),
Prefab("kyno_hound_gargoyle_3", hound3fn, assets, prefabs),
Prefab("kyno_hound_gargoyle_4", hound4fn, assets, prefabs),
Prefab("kyno_werepig_gargoyle_1", pig1fn, assets, prefabs),
Prefab("kyno_werepig_gargoyle_2", pig2fn, assets, prefabs),
Prefab("kyno_werepig_gargoyle_3", pig3fn, assets, prefabs),
Prefab("kyno_werepig_gargoyle_4", pig4fn, assets, prefabs),
Prefab("kyno_werepig_gargoyle_5", pig5fn, assets, prefabs),
Prefab("kyno_werepig_gargoyle_6", pig6fn, assets, prefabs),
MakePlacer("kyno_hound_gargoyle_1_placer", "sculpture_hound", "sculpture_hound_moonrock_build", "atk"),
MakePlacer("kyno_hound_gargoyle_2_placer", "sculpture_hound", "sculpture_hound_moonrock_build", "atk2"),
MakePlacer("kyno_hound_gargoyle_3_placer", "sculpture_hound", "sculpture_hound_moonrock_build", "death"),
MakePlacer("kyno_hound_gargoyle_4_placer", "sculpture_hound", "sculpture_hound_moonrock_build", "death2"),
MakePlacer("kyno_werepig_gargoyle_1_placer", "sculpture_werepig", "sculpture_werepig_moonrock_build", "atk"),
MakePlacer("kyno_werepig_gargoyle_2_placer", "sculpture_werepig", "sculpture_werepig_moonrock_build", "atk2"),
MakePlacer("kyno_werepig_gargoyle_3_placer", "sculpture_werepig", "sculpture_werepig_moonrock_build", "death"),
MakePlacer("kyno_werepig_gargoyle_4_placer", "sculpture_werepig", "sculpture_werepig_moonrock_build", "death2"),
MakePlacer("kyno_werepig_gargoyle_5_placer", "sculpture_werepig", "sculpture_werepig_moonrock_build", "howl"),
MakePlacer("kyno_werepig_gargoyle_6_placer", "sculpture_werepig", "sculpture_werepig_moonrock_build", "howl2")