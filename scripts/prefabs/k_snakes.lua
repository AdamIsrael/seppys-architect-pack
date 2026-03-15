local assets =
{
	Asset("ANIM", "anim/snake_build.zip"),
	Asset("ANIM", "anim/snake_yellow_build.zip"),
	Asset("ANIM", "anim/snake_basic.zip"),
	Asset("ANIM", "anim/snake_water.zip"),
	Asset("ANIM", "anim/snake_scaly_build.zip"),
	Asset("ANIM", "anim/dragonfly_fx.zip"),

	Asset("SOUND", "sound/hound.fsb"),
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs =
{
	"monstermeat",
	"ash",
	"charcoal",
	"firesplash_fx",
	"firering_fx",
	-- "dragonfly_fx",
}

local sounds = {
	default = {
		idle = "dontstarve_DLC002/creatures/snake/idle",
		pre_attack = "dontstarve_DLC002/creatures/snake/pre-attack",
		attack = "dontstarve_DLC002/creatures/snake/attack",
		hurt = "dontstarve_DLC002/creatures/snake/hurt",
		taunt = "dontstarve_DLC002/creatures/snake/taunt",
		death = "dontstarve_DLC002/creatures/snake/death",
		sleep = "dontstarve_DLC002/creatures/snake/sleep",
		move = "dontstarve_DLC002/creatures/snake/move",
	},
	amphibious = {
		idle = "dontstarve_DLC002/creatures/snake/idle",
		pre_attack = "dontstarve_DLC002/creatures/snake/pre-attack",
		attack = "dontstarve_DLC002/creatures/snake/attack",
		hurt = "dontstarve_DLC002/creatures/snake/hurt",
		taunt = "dontstarve_DLC002/creatures/snake/taunt",
		death = "dontstarve_DLC002/creatures/snake/death",
		sleep = "dontstarve_DLC002/creatures/snake/sleep",
		move = "dontstarve_DLC002/creatures/snake/move",
	},
}

local brain = require "brains/snakebrain"

local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30
local SNAKE_KEEP_TARGET_DIST = 15

local NO_TAGS = {"FX", "NOCLICK","DECOR","INLIMBO"}

local function ShouldWakeUp(inst, isnight)
	return isnight
	or (inst.components.combat and inst.components.combat.target)
	or (inst.components.homeseeker and inst.components.homeseeker:HasHome())
	or (inst.components.burnable and inst.components.burnable:IsBurning())
	or (inst.components.follower and inst.components.follower.leader)
end

local function ShouldSleep(inst, isday)
	return isday
	and not (inst.components.combat and inst.components.combat.target)
	and not (inst.components.homeseeker and inst.components.homeseeker:HasHome())
	and not (inst.components.burnable and inst.components.burnable:IsBurning())
	and not (inst.components.follower and inst.components.follower.leader)
end

local function OnNewTarget(inst, data)
	if inst.components.sleeper:IsAsleep() then
		inst.components.sleeper:WakeUp()
	end
end


local function retargetfn(inst)
	local dist = 8
	local notags = {"FX", "NOCLICK","INLIMBO", "wall", "snake", "structure", "aquatic"}
	return FindEntity(inst, dist, function(guy)
		return  inst.components.combat:CanTarget(guy)
	end, nil, notags)
end

local function KeepTarget(inst, target)
	return inst.components.combat:CanTarget(target) and not target:HasTag("aquatic")
end

local function OnAttacked(inst, data)
	inst.components.combat:SetTarget(data.attacker)
	inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("snake")and not dude.components.health:IsDead() end, 5)
end

local function OnAttackOther(inst, data)
	inst.components.combat:ShareTarget(data.target, SHARE_TARGET_DIST, function(dude) return dude:HasTag("snake") and not dude.components.health:IsDead() end, 5)
end

local function DoReturn(inst)
	if inst.components.homeseeker then
		inst.components.homeseeker:ForceGoHome()
	end
end

local function OnEntitySleep(inst, isday)
end

local function OnEntityWake(inst)
end

local function OnSave(inst, data)
end

local function OnLoad(inst, data)
end

local function SanityAura(inst, observer)
    if observer.prefab == "webber" then
        return 0
    end

    return -TUNING.SANITYAURA_SMALL
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
	MakeCharacterPhysics(inst, 10, .5)

	inst.AnimState:SetBank("snake")
	inst.AnimState:SetBuild("snake_build")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("scarytoprey")
	inst:AddTag("monster")
	inst:AddTag("hostile")
	inst:AddTag("snake")
	inst:AddTag("animal")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
        return inst
	end

	inst:AddComponent("knownlocations")
	inst:AddComponent("follower")
	inst:AddComponent("inspectable")

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.runspeed = 3

	inst:SetBrain(brain)
	inst:SetStateGraph("SGsnake")

	inst:AddComponent("eater")
	inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.MEAT, FOODTYPE.GOODIES })
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater:SetCanEatRaw()
	inst.components.eater.strongstomach = true

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(200)

	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(10)
	inst.components.combat:SetAttackPeriod(3)
	inst.components.combat:SetRetargetFunction(3, retargetfn)
	inst.components.combat:SetKeepTargetFunction(KeepTarget)
	inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/snake/hurt")
	inst.components.combat:SetRange(2,3)

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:AddRandomLoot("monstermeat", 1.00)
	inst.components.lootdropper:AddRandomLoot("monstermeat", 0.50)
	inst.components.lootdropper.numrandomloot = math.random(0,1)

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = SanityAura

	inst:AddComponent("sleeper")
	inst.components.sleeper:SetNocturnal(true)
	inst:ListenForEvent("newcombattarget", OnNewTarget)

	inst.OnEntitySleep = OnEntitySleep
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad
	inst.OnEntityWake = OnEntityWake
	inst.OnEntitySleep = OnEntitySleep

	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onattackother", OnAttackOther)

	return inst
end

local function commonfn()
	local inst = fn()

	if not TheWorld.ismastersim then
        return inst
	end

	MakeMediumBurnableCharacter(inst, "hound_body")
	inst.sounds = sounds.default
	return inst
end

local function poisonfn()
	local inst = fn()

	inst.AnimState:SetBuild("snake_yellow_build")

	inst:AddTag("poisonous")

	if not TheWorld.ismastersim then
        return inst
	end

	inst.sounds = sounds.default
	MakeMediumBurnableCharacter(inst, "hound_body")

	return inst
end

local function amphibiousfn()
	local inst = fn()

	inst.AnimState:SetBuild("snake_scaly_build")

	inst:AddTag("amphibious")

	if not TheWorld.ismastersim then
        return inst
	end

	inst.sounds = sounds.amphibious
	MakeMediumBurnableCharacter(inst, "hound_body")

	return inst
end

return Prefab("sap_cobra", commonfn, assets, prefabs),
Prefab("sap_cobra_poison", poisonfn, assets, prefabs),
Prefab("sap_cobra_amphibious", amphibiousfn, assets, prefabs)