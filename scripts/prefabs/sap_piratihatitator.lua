require "prefabutil"
require "recipe"
require "modutil"

local assets =
{
	Asset("ANIM", "anim/piratihatitator.zip"),
}

local prefabs = 
{
	"collapse_small",
}

local loot = {"charcoal"}

local function onburntup(inst)
    inst.AnimState:PlayAnimation("burnt")
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		if inst.components.prototyper and inst.components.prototyper.on then
            inst.AnimState:PushAnimation("idle", true)
        else
            inst.AnimState:PushAnimation("idle", false)
        end
	end
end

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onbuilt(inst)
	inst.is_already_built = nil
	inst._activetask = 1
	
    inst.AnimState:PlayAnimation("place")
	
	inst._activetask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), function() 
		inst._activetask = nil 
		if inst.components.prototyper and inst.components.prototyper.on then
			inst.entering_festive_zone(inst)
		else
			inst.AnimState:PushAnimation("idle", false)
		end
	end)
	
	inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl4_place")
	
	inst:DoTaskInTime(1.1, function()
		if inst then
			inst.is_already_built = true
			inst.makeprototyper(inst)
		end
	end)
	
end

local function entering_festivizer(inst)
	if inst._activetask == nil and not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("proximity_loop", true)
		
		if not inst.SoundEmitter:PlayingSound("idlesound") then
            inst.SoundEmitter:KillSound("loop")
            inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl4_idle_LP", "idlesound")
        end
	end
end

local function leaving_festivizer(inst)
	if inst._activetask == nil and not inst:HasTag("burnt") then
        inst.AnimState:PushAnimation("idle", true)
		inst.SoundEmitter:KillSound("idlesound")
        inst.SoundEmitter:KillSound("loop")
    end
end

local function onactivate(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("idle")
		inst.AnimState:PushAnimation("use")
		if inst.components.prototyper and inst.components.prototyper.on then
			inst.AnimState:PushAnimation("proximity_loop", true)
		else
			inst.AnimState:PushAnimation("idle", true)
		end
		
		if not inst.SoundEmitter:PlayingSound("sound") then
            inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl4_run", "sound")
        end
		
		inst:DoTaskInTime(0.6, function()
			inst.SoundEmitter:KillSound("sound")
			inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl4_ding")
		local function spawnrabbits(inst)
			if not inst:HasTag("burnt") and math.random() <= 0.1 then
        SpawnPrefab("rabbit").Transform:SetPosition(inst.Transform:GetWorldPosition())
    end
end
		end)
	end
end
	
local function MakePrototyper(inst)
	if not inst.components.prototyper and inst.is_already_built ~= nil and not inst:HasTag("burnt") then
		if not inst:HasTag("prototyper") then
			inst:AddTag("prototyper")
		end
		inst:AddComponent("prototyper")
		inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.PRESTIHATITATOR
		inst.components.prototyper.onturnoff = leaving_festivizer
		inst.components.prototyper.onturnon = entering_festivizer
		inst.components.prototyper.onactivate = onactivate
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .4)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_piratihatitator.tex")
	minimap:SetPriority(5)
	
    inst.AnimState:SetBank("piratihatitator")
    inst.AnimState:SetBuild("piratihatitator")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("prototyper")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst._activetask = nil
	inst.is_already_built = true -- this is for spawned prototypers or prototypers after load
	inst.makeprototyper = MakePrototyper
	inst.entering_festive_zone = entering_festivizer
	
	inst:AddTag("prototyper")
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	inst:ListenForEvent("burntup", onburntup)
	
	MakeHauntableWork(inst)
	inst:DoTaskInTime(0, MakePrototyper)
	
    return inst
end

return Prefab("sap_piratihatitator", fn, assets, prefabs),
MakePlacer("sap_piratihatitator_placer", "piratihatitator", "piratihatitator", "idle")