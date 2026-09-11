local brain = require("brains/wargfantbrain")

local assets =
{
	Asset("ANIM", "anim/kyno_adai_wargfant.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"kyno_wargfant"
}

local sounds =
{
    idle = "dontstarve_DLC001/creatures/vargr/idle",
    howl = "dontstarve_DLC001/creatures/vargr/howl",
    hit = "dontstarve_DLC001/creatures/vargr/hit",
    attack = "dontstarve_DLC001/creatures/vargr/attack",
    death = "dontstarve_DLC001/creatures/vargr/death",
    sleep = "dontstarve_DLC001/creatures/vargr/sleep",
}

SetSharedLootTable('kyno_wargfant',
{
    {'monstermeat',             1.00},
	{'monstermeat',             1.00},
	{'monstermeat',             1.00},
	{'monstermeat',             1.00},
	{'monstermeat',             1.00},
	{'monstermeat',             1.00},
    {'monstermeat',             0.50},

    {'houndstooth',             1.00},
    {'houndstooth',             1.00},
    {'houndstooth',             1.00},
	
	{'trunk_summer',            1.00},
})

local RETARGET_MUST_TAGS = { "character" }
local RETARGET_CANT_TAGS = { "wall", "warg", "wargfant", "hound", "spidermonkey", "leif", "hallowed_merm" }
local function RetargetFn(inst)
    return not (inst.sg:HasStateTag("hidden") or inst.sg:HasStateTag("statue"))
	and FindEntity(
		inst,
		TUNING.WARG_TARGETRANGE,
		function(guy)
			return inst.components.combat:CanTarget(guy)
		end,
		inst.sg:HasStateTag("intro_state") and RETARGET_MUST_TAGS or nil,
		RETARGET_CANT_TAGS
		)
	or nil
end

local function KeepTargetFn(inst, target)
    return target ~= nil
	and not (inst.sg:HasStateTag("hidden") or inst.sg:HasStateTag("statue"))
	and inst:IsNear(target, 40)
	and inst.components.combat:CanTarget(target)
	and not target.components.health:IsDead()
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, TUNING.WARG_MAXHELPERS,
	function(dude)
		return not (dude.components.health ~= nil and dude.components.health:IsDead())
		and (dude:HasTag("hound") or dude:HasTag("warg"))
		and data.attacker ~= (dude.components.follower ~= nil and dude.components.follower.leader or nil)
	end, TUNING.WARG_TARGETRANGE)
end

local function onbuilt(inst)
	SpawnPrefab("kyno_wargfant").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function builderfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()

	inst.DynamicShadow:SetSize(2.5, 1.5)
	inst.Transform:SetSixFaced()

	MakeCharacterPhysics(inst, 1000, 1)

	inst.AnimState:SetBank("wargfant_actions")
	inst.AnimState:SetBuild("kyno_adai_wargfant")
	inst.AnimState:PlayAnimation("idle_loop", true)

	inst:AddTag("hallowed")
	inst:AddTag("monster")
	inst:AddTag("warg")
	inst:AddTag("wargfant")
	inst:AddTag("scarytoprey")
	inst:AddTag("houndfriend")
	inst:AddTag("largecreature")
	
	inst:SetPrefabNameOverride("kyno_wargfant")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("leader")
	inst:AddComponent("knownlocations")
	inst:AddComponent("drownable")
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	inst:AddComponent("sleeper")

	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 3
	inst.components.locomotor.runspeed = 5.5
	-- inst.components.locomotor:SetShouldRun(true)

	inst:AddComponent("periodicspawner")
    inst.components.periodicspawner:SetPrefab("poop")
    inst.components.periodicspawner:SetRandomTimes(200, 400)
    inst.components.periodicspawner:SetDensityInRange(20, 2)
    inst.components.periodicspawner:SetMinimumSpacing(15)
    inst.components.periodicspawner:Start()

	inst:AddComponent("combat")
	inst.components.combat:SetHurtSound("dontstarve_DLC001/creatures/vargr/hit")
	inst.components.combat:SetDefaultDamage(60)
	inst.components.combat:SetRange(4)
	inst.components.combat:SetAttackPeriod(4)
	inst.components.combat:SetRetargetFunction(1, RetargetFn)
	inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	inst:ListenForEvent("attacked", OnAttacked)

	inst.sounds = sounds

	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(600)

	inst:SetStateGraph("SGwarg")
	inst:SetBrain(brain)

	MakeLargeBurnableCharacter(inst, "swap_fire")
	MakeLargeFreezableCharacter(inst)
	MakeHauntableGoToState(inst, "howl", TUNING.HAUNT_CHANCE_OCCASIONAL, TUNING.HAUNT_COOLDOWN_MEDIUM, TUNING.HAUNT_CHANCE_LARGE)
	
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function fn()
	local inst = builderfn()
	
	inst:SetPrefabNameOverride("kyno_wargfant")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("herdmember")
    inst.components.herdmember:SetHerdPrefab("kyno_wargfant_herd")
	
	inst.components.lootdropper:SetChanceLootTable('kyno_wargfant')
	
	return inst
end

return Prefab("kyno_wargfant_builder", builderfn, assets, prefabs),
Prefab("kyno_wargfant", fn, assets, prefabs),
MakePlacer("kyno_wargfant_builder_placer", "wargfant_actions", "kyno_adai_wargfant", "idle_loop")