local trace = function() end

local assets=
{
	Asset("ANIM", "anim/dragonfly_fx.zip"),
	Asset("ANIM", "anim/dragoon_build.zip"),
	Asset("ANIM", "anim/dragoon_basic.zip"),
	Asset("ANIM", "anim/dragoon_actions.zip"),
}

local prefabs =
{
	"monstermeat",
	"redgem",
	-- "dragonfly_fx",
	-- "kyno_firesplash_fx",
	-- "kyno_firering_fx",
	"sap_dragoonfire",
	"sap_dragoonspit2",
	-- "kyno_dragoon_charge_fx", -- undefined prefab (not implemented, already commented out in SGdragoon.lua)
}

local brain = require "brains/dragoonbrain"

local WAKE_TO_FOLLOW_DISTANCE = 8
local SHARE_TARGET_DIST = 10

local NO_TAGS = {"FX", "NOCLICK","DECOR","INLIMBO"}

local function ShouldWakeUp(inst)
	return DefaultWakeTest(inst)
end

local function ShouldSleep(inst)
	return DefaultSleepTest(inst)
end

local function OnNewTarget(inst, data)
	if inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end

local function retargetfn(inst)
	local dist = 8
	local notags = {"FX", "NOCLICK", "INLIMBO", "wall", "alignwall", "dragoon"}
	return FindEntity(inst, dist, function(guy)
		return  inst.components.combat:CanTarget(guy)
	end, nil, notags)
end

local function KeepTarget(inst, target)
	return inst.components.combat:CanTarget(target) and inst:GetDistanceSqToInst(target) <= (TUNING.DRAGOON_KEEP_TARGET_DIST*TUNING.DRAGOON_KEEP_TARGET_DIST)
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("dragoon") and not dude.components.health:IsDead() end, 5)
end

local function OnAttackOther(inst, data)
	inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude:HasTag("dragoon") and not dude.components.health:IsDead() end, 5)
end

local function GetReturnPos(inst)
	local rad = 2
	local pos = inst:GetPosition()
	trace("GetReturnPos", inst, pos)
	local angle = math.random()*2*PI
	pos = pos + Point(rad*math.cos(angle), 0, -rad*math.sin(angle))
	trace("    ", pos)
	return pos:Get()
end

local function DoReturn(inst)
	if inst.components.homeseeker and inst.components.homeseeker:HasHome()  then
		inst.components.homeseeker.home.components.childspawner:GoHome(inst)
	end
end

local function OnNight(inst)
	if inst:IsAsleep() then
		DoReturn(inst)
	end
end

local function OnEntitySleep(inst, isday)
	if not isday then
		DoReturn(inst)
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(3, 1.25)

	MakeCharacterPhysics(inst, 10, .5)

	inst.Transform:SetFourFaced()
	inst.AnimState:SetScale(1.3, 1.3, 1.3)

	inst.last_spit_time = nil
	inst.last_target_spit_time = nil
	inst.spit_interval = math.random(20,30)
	inst.num_targets_vomited = 0

	inst.AnimState:SetBank("dragoon")
	inst.AnimState:SetBuild("dragoon_build")
	inst.AnimState:PlayAnimation("idle_loop")
	inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("scarytoprey")
	inst:AddTag("monster")
	inst:AddTag("hostile")
	inst:AddTag("lavaspitter")
	inst:AddTag("dragoon")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
        return inst
	end

	inst:AddComponent("inspectable")

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.walkspeed = 3
	inst.components.locomotor.runspeed = 15

	inst:SetBrain(brain)
	inst:SetStateGraph("SGdragoon")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(350)
	inst.components.health.fire_damage_scale = 0

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(25)
	inst.components.combat:SetAttackPeriod(1)
	inst.components.combat:SetRetargetFunction(1, retargetfn)
	-- inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/dragoon/hit")
	inst.components.combat:SetRange(2,2)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddChanceLoot("monstermeat", 1.00)
	inst.components.lootdropper:AddChanceLoot("redgem", .2)

	inst:AddComponent("sleeper")
	inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
	inst.components.sleeper:SetSleepTest(ShouldSleep)
	inst.components.sleeper:SetWakeTest(ShouldWakeUp)

	inst.OnEntitySleep = OnEntitySleep

	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onattackother", OnAttackOther)
	inst:ListenForEvent("newcombattarget", OnNewTarget)

	inst:WatchWorldState("isdusk", function() OnNight(inst) end, TheWorld)
	inst:WatchWorldState("isnight", function() OnNight(inst) end, TheWorld)

	MakeMediumFreezableCharacter(inst, "hound_body")
	MakeLargePropagator(inst)
	inst.components.propagator.decayrate = 0

	return inst
end

return Prefab("sap_dragoon", fn, assets, prefabs)