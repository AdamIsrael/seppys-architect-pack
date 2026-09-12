require "prefabutil"
require "recipe"
require "modutil"

local assets =
{
	Asset("ANIM", "anim/researchlab5.zip"),
}

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		if inst.components.prototyper and inst.components.prototyper.on then
            inst.AnimState:PushAnimation("proximity_loop", true)
        else
            inst.AnimState:PushAnimation("idle", true)
        end
	end
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
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
			inst.AnimState:PushAnimation("idle", true)
		end
	end)
	
	inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl2_place")
	
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
            inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl2_idle_LP", "idlesound")
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
		inst.AnimState:PushAnimation("use")
		if inst.components.prototyper and inst.components.prototyper.on then
			inst.AnimState:PushAnimation("proximity_loop", true)
		else
			inst.AnimState:PushAnimation("idle", true)
		end
		
		if not inst.SoundEmitter:PlayingSound("sound") then
            inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl2_run", "sound")
        end
		
		inst:DoTaskInTime(0.6, function()
			inst.SoundEmitter:KillSound("sound")
			inst.SoundEmitter:PlaySound("dontstarve/common/researchmachine_lvl2_ding")
		end)
	end
end
	
local function MakePrototyper(inst)
	if not inst.components.prototyper and inst.is_already_built ~= nil and not inst:HasTag("burnt") then
		if not inst:HasTag("prototyper") then
			inst:AddTag("prototyper")
		end
		inst:AddComponent("prototyper")
		inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.ALCHEMYMACHINE
		inst.components.prototyper.onturnoff = leaving_festivizer
		inst.components.prototyper.onturnon = entering_festivizer
		inst.components.prototyper.onactivate = onactivate
	end
end

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.SEASTACK_MINE)
    end
end

local function Labfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    -- MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_sealab.tex")
	minimap:SetPriority(5)
	
    inst.AnimState:SetBank("researchlab5")
    inst.AnimState:SetBuild("researchlab5")
    inst.AnimState:PlayAnimation("idle")
    
	-- inst:SetPhysicsRadiusOverride(.4)
	-- MakeWaterObstaclePhysics(inst, .4, .4, .4)
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("prototyper")
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddTag("prototyper")
	
	inst._activetask = nil
	inst.is_already_built = true -- this is for spawned prototypers or prototypers after load
	inst.makeprototyper = MakePrototyper
	inst.entering_festive_zone = entering_festivizer
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	-- inst:ListenForEvent("on_collide", OnCollide)
	
	MakeHauntableWork(inst)
	inst:DoTaskInTime(0, MakePrototyper)
	
    return inst
end

return Prefab("sap_sealab", Labfn, assets),
MakePlacer("sap_sealab_placer", "researchlab5", "researchlab5", "placer")