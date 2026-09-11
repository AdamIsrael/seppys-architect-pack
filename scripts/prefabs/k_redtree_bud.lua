require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_redtree_bud.zip"),
	
	Asset("ANIM", "anim/dust_fx.zip"),
	Asset("SOUND", "sound/forest.fsb"),
}

local prefabs =
{
	"log",
	"burr",
	"charcoal",
}

local function chop_down_burnt_tree(inst, chopper)
    inst:RemoveComponent("workable")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")          
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	inst.AnimState:PlayAnimation("chop_burnt_short")
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
    
	inst.AnimState:PlayAnimation("burnt_short", true)
	
    inst.AnimState:SetRayTestOnBB(true);
    inst:AddTag("burnt")
end

local function ondug(inst, worker)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("log")
end

local function makestump(inst, instant)
    inst:RemoveComponent("workable")
    RemovePhysicsColliders(inst)
    if instant then
    	inst.AnimState:PlayAnimation("stump_short")
    else
    	inst.AnimState:PushAnimation("stump_short")	
    end
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(ondug)
    inst.components.workable:SetWorkLeft(1)    
    inst:AddTag("stump")
end

local function onworked(inst, chopper, workleft)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")          
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")          
	end
	
	inst.AnimState:PlayAnimation("chop_bud")
	inst.AnimState:PushAnimation("sway1_loop_bud", true)
end

local function onworkfinish(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local hispos = Vector3(chopper.Transform:GetWorldPosition())
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

    if he_right then
        inst.AnimState:PlayAnimation("fallleft_bud")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation("fallright_bud")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

    makestump(inst)
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

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .75)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_redtree.tex")

	inst.AnimState:SetBank("kyno_redtree_bud")
	inst.AnimState:SetBuild("kyno_redtree_bud")
	inst.AnimState:PlayAnimation("sway1_loop_bud", true)
	
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(5)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetOnFinishCallback(onworkfinish)

    MakeLargeBurnable(inst)
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(OnBurnt)
    MakeLargePropagator(inst)

	inst.OnSave = onsave
	inst.OnLoad = onload

	return inst
end

return Prefab("sap_redtree_bud", fn, assets, prefabs),
MakePlacer("sap_redtree_bud_placer", "kyno_redtree_bud", "kyno_redtree_bud", "sway1_loop_bud")