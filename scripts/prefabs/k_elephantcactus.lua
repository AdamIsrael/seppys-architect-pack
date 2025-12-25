local brain = require("brains/elephantcactusbrain")

local assets =
{
	Asset("ANIM", "anim/cactus_volcano.zip"),

	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),

	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),

	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs =
{
	"blowdart_pipe",
	"twigs",
}

local function makeemptyfn(inst)
	local active = SpawnPrefab("kyno_elephantcactus_active")
	active.Physics:Teleport(inst.Transform:GetWorldPosition())

	if inst.components.pickable and inst.components.pickable.withered then
		active.sg:GoToState("grow_spike")
	end

	inst:Remove()
end

local function makebarrenfn(inst)
	if inst.components.pickable and inst.components.pickable.withered then
		if not inst.components.pickable.hasbeenpicked then
			inst.AnimState:PlayAnimation("full_to_dead")
			inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/full_to_dead")
		else
			inst.AnimState:PlayAnimation("empty_to_dead")
			inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/volcano_cactus/empty_to_dead")
		end
		inst.AnimState:PushAnimation("idle_dead")
	else
		inst.AnimState:PlayAnimation("idle_dead")
	end
end

local function pickanim(inst)
	if inst.components.pickable then
		if inst.components.pickable:CanBePicked() then
			return "idle_spike"
		else
			if inst.components.pickable:IsBarren() then
				return "idle_dead"
			else
				return "idle"
			end
		end
	end

	return "idle"
end

local function shake(inst)
	if inst.components.pickable and inst.components.pickable:CanBePicked() then
		inst.AnimState:PlayAnimation("shake")
	else
		inst.AnimState:PlayAnimation("shake_empty")
	end
	inst.AnimState:PushAnimation(pickanim(inst), false)
end

local function onpickedfn(inst, picker)
	if inst.components.pickable then
		inst.AnimState:PlayAnimation("chopped")

		if inst.components.pickable:IsBarren() then
			inst.AnimState:PushAnimation("idle_dead")
		else
			inst.AnimState:PushAnimation("idle")
		end
	end
	if picker.components.combat then
		picker.components.combat:GetAttacked(inst, TUNING.MARSHBUSH_DAMAGE)
		picker:PushEvent("thorns")
	end
end

local function getregentimefn(inst)
    if inst.components.pickable then
        local num_cycles_passed = math.max(0, inst.components.pickable.max_cycles - (inst.components.pickable.cycles_left or inst.components.pickable.max_cycles))
        return TUNING.BERRY_REGROW_TIME
            + TUNING.BERRY_REGROW_INCREASE * num_cycles_passed
            + TUNING.BERRY_REGROW_VARIANCE * math.random()
    else
        return TUNING.BERRY_REGROW_TIME
    end
end

local function makefullfn(inst)
	inst.AnimState:PlayAnimation(pickanim(inst))

    inst:ListenForEvent("animover", function(inst)
        local active = SpawnPrefab("kyno_elephantcactus_active")
        if active then
            active.Physics:Teleport(inst.Transform:GetWorldPosition())
            inst:Remove()
        end
    end)
end

local function dig_up(inst, chopper)
	inst:Remove()
end

local function dig_up_replica(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("dug_marsh_bush")
	inst.components.lootdropper:SpawnLootPrefab("houndstooth")
	inst.components.lootdropper:SpawnLootPrefab("houndstooth")
	inst:Remove()
end

local RETARGET_CANT_TAGS = {"FX", "NOCLICK", "INLIMBO", "CLASSIFIED", "elephantcactus", "bramble_resistant", "wall", "alignwall", "plantkin"}
local function retargetfn(inst)
    local newtarget = FindEntity(inst, 4, function(guy)	
		return guy.components.health and not guy.components.health:IsDead() 
	end, nil, RETARGET_CANT_TAGS)

    return newtarget
end

local function shouldKeepTarget(inst, target)
	if target and target:IsValid() and
		(target.components.health and not target.components.health:IsDead()) then
		local distsq = target:GetDistanceSqToInst(inst)
		return distsq < 4 * 4
	else
		return false
	end
end

local function ontransplantfn(inst)
    inst.AnimState:PlayAnimation("idle_dead")
    inst.components.pickable:MakeBarren()
end

local function onseasonchange(inst)
    if TheWorld.state.issummer then
        local active = SpawnPrefab("kyno_elephantcactus_active")
        if active then
            active.Physics:Teleport(inst.Transform:GetWorldPosition())
            inst:Remove()
        end
    end
end

local function onseasonchange_active(inst)
	if not inst.prevseason then
		inst.prevseason = TheWorld.state.season
		return
	end

	if TheWorld.state.isautumn and inst.prevseason == SEASONS.AUTUMN then
		local dormant = SpawnPrefab("kyno_elephantcactus")
		if dormant then
			dormant.Physics:Teleport(inst.Transform:GetWorldPosition())
			inst:Remove()
            return
		end
	end

	inst.prevseason = TheWorld.state.season
end

local function OnLoad(inst, data)
    onseasonchange(inst)
end

local function OnLoadActive(inst, data)
	onseasonchange_active(inst)
	inst.has_spike = data.has_spike
end

local function OnSaveActive(inst, data)
	data.has_spike = inst.has_spike
end

local function OnHaunt(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        shake(inst)
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_COOLDOWN_TINY
        return true
    end
    return false
end

local function fn()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_elephantcactus.tex")

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("cactus_volcano")
    inst.AnimState:SetBuild("cactus_volcano")
    inst.AnimState:PlayAnimation("idle_spike", true)
    inst.AnimState:SetTime(math.random()*2)

	inst:AddTag("thorny")
	inst:AddTag("elephantcactus")
	inst:AddTag("scarytoprey")

    --witherable (from witherable component) added to pristine state for optimization
    inst:AddTag("witherable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    AddHauntableCustomReaction(inst, OnHaunt, false, false, true)

    inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")

    if not GetGameModeProperty("disable_transplanting") then
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(dig_up_replica)
        inst.components.workable:SetWorkLeft(1)
    end

	return inst
end

local function ontimerdone(inst, data)
	if data.name == "SPIKE" then
		inst.has_spike = true
		inst:PushEvent("growspike")
	end
end

local function OnBlocked(owner, data)
	if data ~= nil and data.attacker ~= nil and data.attacker.components.health ~= nil and not data.attacker.components.health:IsDead()
    and data.attacker.components.combat ~= nil and data.stimuli ~= "thorns" and not data.attacker:HasTag("thorny")
    and ((data.damage and data.damage > 0) or (data.attacker.components.combat and data.attacker.components.combat.defaultdamage > 0))
    and (data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil))
    and not (data.attacker.sg ~= nil and data.attacker.sg:HasStateTag("dead")) then
        data.attacker.components.combat:GetAttacked(owner, 30/2, nil, "thorns")
        owner.SoundEmitter:PlaySound("dontstarve_DLC002/common/armour/cactus")
    end
end

local function activefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_elephantcactus.tex")

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("cactus_volcano")
    inst.AnimState:SetBuild("cactus_volcano")
    inst.AnimState:PlayAnimation("idle_spike", true)
    inst.AnimState:SetTime(2)

	inst:AddTag("thorny")
	inst:AddTag("elephantcactus")

    inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	if not TheWorld.ismastersim then
        function inst.OnEntityReplicated(inst)
            inst.replica.combat.notags = {"elephantcactus", "bramble_resistant", "wall", "alignwall", "plantkin"}
        end
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(650)
	inst.components.health:StartRegen(100, 8)

	inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(30)
    inst.components.combat:SetAttackPeriod(1)
	inst.components.combat:SetRange(5)
	inst.components.combat:SetRetargetFunction(1, retargetfn)
	inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
    inst.components.combat:SetAreaDamage(3, 1.0)
	inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/volcano_cactus/hit")
    inst.components.combat.notags = {"elephantcactus", "bramble_resistant", "wall", "alignwall", "plantkin"}

	inst:AddComponent("timer")
	
	inst.has_spike = true
	
	MakeLargeFreezableCharacter(inst)
	
	inst:ListenForEvent("timerdone", ontimerdone)
	inst:ListenForEvent("blocked", OnBlocked)
	inst:ListenForEvent("attacked", OnBlocked)

	inst:SetBrain(brain)
	inst:SetStateGraph("SGelephantcactus")
	inst.sg:GoToState("grow_spike")

	inst.OnLoad = OnLoadActive
	inst.OnSave = OnSaveActive

	return inst
end

local function stumpfn()
    local inst = CreateEntity()
    inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()

    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_elephantcactus.tex")

    inst.AnimState:SetBank("cactus_volcano")
    inst.AnimState:SetBuild("cactus_volcano")
    inst.AnimState:PlayAnimation("idle_underground")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")

    if not GetGameModeProperty("disable_transplanting") then
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.DIG)
        inst.components.workable:SetOnFinishCallback(dig_up)
        inst.components.workable:SetWorkLeft(1)
    end

	inst:AddComponent("inspectable")

    -- inst:WatchWorldState("season", function(inst, season) onseasonchange(inst) end)

    inst.OnLoad = OnLoad

	return inst
end

-- you can find dug_elephantcactus in plantables.lua
return Prefab("kyno_elephantcactus", fn, assets, prefabs),
Prefab("kyno_elephantcactus_active", activefn, assets, prefabs),
Prefab("kyno_elephantcactus_stump", stumpfn, assets, prefabs),
MakePlacer("kyno_elephantcactus_placer", "cactus_volcano", "cactus_volcano", "idle_spike"),
MakePlacer("kyno_elephantcactus_active_placer", "cactus_volcano", "cactus_volcano", "idle_spike"),
MakePlacer("kyno_elephantcactus_stump_placer", "cactus_volcano", "cactus_volcano", "idle_spike")