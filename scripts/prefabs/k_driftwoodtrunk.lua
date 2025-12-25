require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/driftwood_normal.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"driftwood_log",
}

local function chop_down_burnt_tree(inst, chopper)
    inst:RemoveComponent("workable")
	
    inst.SoundEmitter:PlaySound("dontstarve/forest/appear_wood")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble",nil,.4)
	inst.AnimState:PlayAnimation("chop_burnt_normal")
	
    RemovePhysicsColliders(inst)
	
	inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
end

local function OnBurnt(inst)
	inst:DoTaskInTime(0.5, function()
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
    
	if inst:HasTag("stump") then
		inst.AnimState:PlayAnimation("idle_chop_burnt_normal", true)
	else	
		inst.AnimState:PlayAnimation("burnt_normal", true)
	end
	
    inst:AddTag("burnt")
end

local function ondug(inst, worker)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("driftwood_log")
end

local function makestump(inst, instant)
    inst:RemoveComponent("workable")
	
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

local function onworked(inst, chopper, workleft)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")          
	else
		inst.SoundEmitter:PlaySound("turnoftides/common/together/driftwood/chop")        
	end
	
	inst.SoundEmitter:PlaySound("turnoftides/common/together/driftwood/chop")
	inst.AnimState:PlayAnimation("chop_normal")
	inst.AnimState:PushAnimation("idle", true)
end

local function onworkfinish(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/appear_wood")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble",nil,.4)
	
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
	minimap:SetIcon("kyno_driftwoodtrunk.tex")

	inst.AnimState:SetBank("driftwood_normal")
	inst.AnimState:SetBuild("driftwood_normal")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("plant")
	inst:AddTag("tree")
	inst:AddTag("workable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "DRIFTWOOD_TREE"

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(15)
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

return Prefab("kyno_driftwoodtrunk", fn, assets, prefabs),
MakePlacer("kyno_driftwoodtrunk_placer", "driftwood_normal", "driftwood_normal", "idle")