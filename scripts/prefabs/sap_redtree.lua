require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_redtree_normal.zip"),
	Asset("ANIM", "anim/kyno_redtree_tallold.zip"),
	
	Asset("ANIM", "anim/dust_fx.zip"),
}

local prefabs =
{
	"log",
	"burr",
	"charcoal",
}

local function chop_down_burnt_tree_normal(inst, chopper)
    inst:RemoveComponent("workable")
	
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")  
	inst.AnimState:PlayAnimation("chop_burnt_normal")
    
	RemovePhysicsColliders(inst)
	
	inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
end

local function chop_down_burnt_tree_tall(inst, chopper)
    inst:RemoveComponent("workable")
	
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")  
	inst.AnimState:PlayAnimation("chop_burnt_tall")
    
	RemovePhysicsColliders(inst)
	
	inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
end

local function chop_down_burnt_tree_old(inst, chopper)
    inst:RemoveComponent("workable")
	
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")  
	inst.AnimState:PlayAnimation("chop_burnt_old")
    
	RemovePhysicsColliders(inst)
	
	inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
end

local function OnBurntNormal(inst)
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
				inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree_normal)
			end
		end)
    
	inst.AnimState:PlayAnimation("burnt_normal", true)
	
    inst.AnimState:SetRayTestOnBB(true);
    inst:AddTag("burnt")
end

local function OnBurntTall(inst)
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
				inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree_tall)
			end
		end)
    
	inst.AnimState:PlayAnimation("burnt_tall", true)
	
    inst.AnimState:SetRayTestOnBB(true);
    inst:AddTag("burnt")
end

local function OnBurntOld(inst)
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
				inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree_old)
			end
		end)
    
	inst.AnimState:PlayAnimation("burnt_old", true)
	
    inst.AnimState:SetRayTestOnBB(true);
    inst:AddTag("burnt")
end

local function ondug(inst, worker)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("log")
end

local function makestump_normal(inst, instant)
    inst:RemoveComponent("workable")
    RemovePhysicsColliders(inst)
	
    if instant then
    	inst.AnimState:PlayAnimation("stump_normal")
    else
    	inst.AnimState:PushAnimation("stump_normal")	
    end
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(ondug)
    inst.components.workable:SetWorkLeft(1)    
	
    inst:AddTag("stump")
end

local function makestump_tall(inst, instant)
    inst:RemoveComponent("workable")
    RemovePhysicsColliders(inst)
	
    if instant then
    	inst.AnimState:PlayAnimation("stump_tall")
    else
    	inst.AnimState:PushAnimation("stump_tall")	
    end
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(ondug)
    inst.components.workable:SetWorkLeft(1)    
	
    inst:AddTag("stump")
end

local function makestump_old(inst, instant)
    inst:RemoveComponent("workable")
    RemovePhysicsColliders(inst)
	
    if instant then
    	inst.AnimState:PlayAnimation("stump_old")
    else
    	inst.AnimState:PushAnimation("stump_old")	
    end
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(ondug)
    inst.components.workable:SetWorkLeft(1)    
	
    inst:AddTag("stump")
end

local function onworked_normal(inst, chopper, workleft)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")          
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	end
	
	inst.AnimState:PlayAnimation("chop_normal")
	inst.AnimState:PushAnimation("sway1_loop_normal", true)
end

local function onworked_tall(inst, chopper, workleft)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")          
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	end
	
	inst.AnimState:PlayAnimation("chop_tall")
	inst.AnimState:PushAnimation("sway1_loop_tall", true)
end

local function onworked_old(inst, chopper, workleft)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")          
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	end
	
	inst.AnimState:PlayAnimation("chop_old")
	inst.AnimState:PushAnimation("idle_old", true)
end

local function onworkfinish_normal(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local hispos = Vector3(chopper.Transform:GetWorldPosition())
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

    if he_right then
        inst.AnimState:PlayAnimation("fallleft_normal")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation("fallright_normal")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

    makestump_normal(inst)
end

local function onworkfinish_tall(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local hispos = Vector3(chopper.Transform:GetWorldPosition())
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

    if he_right then
        inst.AnimState:PlayAnimation("fallleft_tall")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation("fallright_tall")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

    makestump_tall(inst)
end

local function onworkfinish_old(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local hispos = Vector3(chopper.Transform:GetWorldPosition())
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

    if he_right then
        inst.AnimState:PlayAnimation("fallleft_old")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation("fallright_old")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

    makestump_old(inst)
end

local function onsave_normal(inst, data)
	if inst:HasTag("stump") then
		data.stump = true
	end

    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onsave_tall(inst, data)
	if inst:HasTag("stump") then
		data.stump = true
	end

    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onsave_old(inst, data)
	if inst:HasTag("stump") then
		data.stump = true
	end

    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload_normal(inst, data)
	if data and data.stump then
		makestump_normal(inst, true)
	end

	if data and data.burnt then
		OnBurntNormal(inst)
	end
end

local function onload_tall(inst, data)
	if data and data.stump then
		makestump_tall(inst, true)
	end

	if data and data.burnt then
		OnBurntTall(inst)
	end
end

local function onload_old(inst, data)
	if data and data.stump then
		makestump_old(inst, true)
	end

	if data and data.burnt then
		OnBurntOld(inst)
	end
end

local function normalfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .75)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_redtree.tex")

	inst.AnimState:SetBank("kyno_redtree_normal")
	inst.AnimState:SetBuild("kyno_redtree_normal")
	inst.AnimState:PlayAnimation("sway1_loop_normal", true)
	
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnWorkCallback(onworked_normal)
	inst.components.workable:SetOnFinishCallback(onworkfinish_normal)

    MakeLargeBurnable(inst)
	MakeSmallPropagator(inst)
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(OnBurntNormal)

	inst.OnSave = onsave_normal
	inst.OnLoad = onload_normal

	return inst
end

local function tallfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .75)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_redtree.tex")

	inst.AnimState:SetBank("kyno_redtree_tallold")
	inst.AnimState:SetBuild("kyno_redtree_tallold")
	inst.AnimState:PlayAnimation("sway1_loop_tall", true)
	
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(15)
	inst.components.workable:SetOnWorkCallback(onworked_tall)
	inst.components.workable:SetOnFinishCallback(onworkfinish_tall)

    MakeLargeBurnable(inst)
	MakeSmallPropagator(inst)
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(OnBurntTall)

	inst.OnSave = onsave_tall
	inst.OnLoad = onload_tall

	return inst
end

local function oldfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .75)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_redtree.tex")

	inst.AnimState:SetBank("kyno_redtree_tallold")
	inst.AnimState:SetBuild("kyno_redtree_tallold")
	inst.AnimState:PlayAnimation("idle_old", true)
	
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnWorkCallback(onworked_old)
	inst.components.workable:SetOnFinishCallback(onworkfinish_old)

    MakeLargeBurnable(inst)
	MakeSmallPropagator(inst)
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(OnBurntOld)

	inst.OnSave = onsave_old
	inst.OnLoad = onload_old

	return inst
end

return Prefab("sap_redtree_normal", normalfn, assets, prefabs),
Prefab("sap_redtree_tall", tallfn, assets, prefabs),
Prefab("sap_redtree_old", oldfn, assets, prefabs),
MakePlacer("sap_redtree_normal_placer", "kyno_redtree_normal", "kyno_redtree_normal", "sway1_loop_normal"),
MakePlacer("sap_redtree_tall_placer", "kyno_redtree_tallold", "kyno_redtree_tallold", "sway1_loop_tall"),
MakePlacer("sap_redtree_old_placer", "kyno_redtree_tallold", "kyno_redtree_tallold", "idle_old")