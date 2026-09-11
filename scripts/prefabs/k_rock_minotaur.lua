require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/rock_ruins.zip"),
}

local prefabs =
{
	"collapse_big",
	"collapse_small"
}

local function OnFinishBig(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst.AnimState:PlayAnimation("break_big")
	
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:ListenForEvent("animover", function() inst:Remove() end)
end

local function OnFinishSmall(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst.AnimState:PlayAnimation("break_small")
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:ListenForEvent("animover", function() inst:Remove() end)
end

local function makerock(bank, build, anim)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("rock.png")
	
	inst.AnimState:SetBank(bank)
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation(anim, true)
	
	MakeObstaclePhysics(inst, 1)
		
	inst:AddTag("structure")
	inst:AddTag("boulder")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
		
	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(3)

	return inst
end

local function fn1()
    local inst = makerock("rock_ruins", "rock_ruins", "full1")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.components.workable:SetOnFinishCallback(OnFinishBig)
   
    return inst
end

local function fn2()
    local inst = makerock("rock_ruins", "rock_ruins", "full2")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.components.workable:SetOnFinishCallback(OnFinishBig)
   
    return inst
end

local function fn3()
    local inst = makerock("rock_ruins", "rock_ruins", "full3")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.components.workable:SetOnFinishCallback(OnFinishSmall)
   
    return inst
end

local function fn4()
    local inst = makerock("rock_ruins", "rock_ruins", "full4")

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst.components.workable:SetOnFinishCallback(OnFinishSmall)
   
    return inst
end

return Prefab("sap_rock_minotaur1", fn1, assets, prefabs),
Prefab("sap_rock_minotaur2", fn2, assets, prefabs),
Prefab("sap_rock_minotaur3", fn3, assets, prefabs),
Prefab("sap_rock_minotaur4", fn4, assets, prefabs),
MakePlacer("sap_rock_minotaur1_placer", "rock_ruins", "rock_ruins", "full1"),
MakePlacer("sap_rock_minotaur2_placer", "rock_ruins", "rock_ruins", "full2"),
MakePlacer("sap_rock_minotaur3_placer", "rock_ruins", "rock_ruins", "full3"),
MakePlacer("sap_rock_minotaur4_placer", "rock_ruins", "rock_ruins", "full4")
