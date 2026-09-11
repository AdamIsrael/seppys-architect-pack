require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/tree_leaf_monster.zip"),
	Asset("ANIM", "anim/tree_leaf_poison_build.zip"),
	Asset("ANIM", "anim/tree_leaf_trunk_build.zip"),
	
	Asset("SOUND", "sound/forest.fsb"),
    Asset("SOUND", "sound/deciduous.fsb"),
}

local prefabs =
{
	"livinglog",
	"acorn",
	"sap_poisontree_stump",
}

local function chop_down_burnt_tree(inst, chopper)
    inst:RemoveComponent("workable")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	inst.AnimState:PlayAnimation("chop_burnt_tall")
    RemovePhysicsColliders(inst)
	inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
end

local function OnBurnt(inst)
	inst:DoTaskInTime( 0.5,
		function()
		    if inst.components.burnable then
			    inst.components.burnable:Extinguish()
			end
			inst:RemoveComponent("burnable")
			inst:RemoveComponent("propagator")

			inst.components.lootdropper:SetLoot({})
			
			if inst.components.workable then
				inst.components.workable:SetWorkLeft(1)
				inst.components.workable:SetOnWorkCallback(nil)
				inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree)
			end
		end)
    
	inst.AnimState:PlayAnimation("burnt_tall", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/living_jungle_tree/burn")
	
    inst.AnimState:SetRayTestOnBB(true);
    inst:AddTag("burnt")
	inst.MiniMapEntity:SetIcon("tree_leaf_burnt.png")
end

local function ondug(inst, worker)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("livinglog")
end

local function onworked(inst, chopper, workleft)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")          
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	end
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/deciduous/hurt_chop")
	inst.AnimState:PlayAnimation("chop_tall_monster")
	inst.AnimState:PushAnimation("idle_loop_agro", true)
end

local function onworkfinish(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local hispos = Vector3(chopper.Transform:GetWorldPosition())
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

    inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/deciduous/death")

    if he_right then
        inst.AnimState:PlayAnimation("fallleft_tall_monster")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation("fallright_tall_monster")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end
	inst:Remove()
    SpawnPrefab("sap_poisontree_stump").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onsave(inst, data)
	if inst:HasTag("stump") then
		data.stump = true
	end

    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.stump then
		makestump(inst, true)
	end

	if data and data.burnt then
		OnBurnt(inst)
	end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("transform_in")
	inst.AnimState:PushAnimation("idle_loop_agro", true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .25)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("tree_leaf.png")

	inst.AnimState:SetBank("tree_leaf_monster")
	inst.AnimState:SetBuild("tree_leaf_poison_build")
	inst.AnimState:AddOverrideBuild("tree_leaf_trunk_build")
	inst.AnimState:PlayAnimation("idle_loop_agro", true)
	
	inst:AddTag("plant")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("deciduoustree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(15)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetOnFinishCallback(onworkfinish)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)

	MakeSnowCovered(inst, .01)
	MakeHauntableWork(inst)

	return inst
end

local function stumpfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("tree_leaf_stump.png")

	inst.AnimState:SetBank("tree_leaf_monster")
	inst.AnimState:SetBuild("tree_leaf_poison_build")
	inst.AnimState:PlayAnimation("stump_tall_monster", true)
	
	inst:AddTag("plant")
	inst:AddTag("stump")
	inst:AddTag("workable")
	
	inst:SetPrefabNameOverride("deciduoustree")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(ondug)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeSnowCovered(inst, .01)
	MakeHauntableWork(inst)

	return inst
end

local function poisonplacetestfn(inst)
	inst.AnimState:AddOverrideBuild("tree_leaf_trunk_build")
end

return Prefab("sap_poisontree", fn, assets, prefabs),
Prefab("sap_poisontree_stump", stumpfn, assets, prefabs),
MakePlacer("sap_poisontree_placer", "tree_leaf_monster", "tree_leaf_poison_build", "idle_loop_agro", false, nil, nil, nil, nil, nil, poisonplacetestfn)