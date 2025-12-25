require "brains/pigguardbrain"
require "brains/werepigbrain"
require "stategraphs/SGpigmancity"
require "stategraphs/SGwerepig"
local brain = require "brains/pigmancitybrain"

local assets =
{
	Asset("SOUND", "sound/pig.fsb"),
    Asset("ANIM", "anim/pig_usher.zip"),
    Asset("ANIM", "anim/pig_mayor.zip"),
    Asset("ANIM", "anim/pig_miner.zip"),
    Asset("ANIM", "anim/pig_queen.zip"),
    Asset("ANIM", "anim/pig_farmer.zip"),
    Asset("ANIM", "anim/pig_hunter.zip"),
    Asset("ANIM", "anim/pig_banker.zip"),
    Asset("ANIM", "anim/pig_florist.zip"),
    Asset("ANIM", "anim/pig_erudite.zip"),
    Asset("ANIM", "anim/pig_hatmaker.zip"),
    Asset("ANIM", "anim/pig_mechanic.zip"),
    Asset("ANIM", "anim/pig_professor.zip"),
    Asset("ANIM", "anim/pig_collector.zip"),
    Asset("ANIM", "anim/townspig_basic.zip"),
    Asset("ANIM", "anim/pig_beautician.zip"),
    Asset("ANIM", "anim/pig_royalguard.zip"),
    Asset("ANIM", "anim/pig_storeowner.zip"),
    Asset("ANIM", "anim/townspig_attacks.zip"),
    Asset("ANIM", "anim/townspig_actions.zip"),
    Asset("ANIM", "anim/pig_royalguard_2.zip"),
    Asset("ANIM", "anim/townspig_shop_wip.zip"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs =
{
    "meat",
    "poop",
    "tophat",
    "pigskin",
    "strawhat",
    "monstermeat",
}

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30
local CITY_PIG_GUARD_TARGET_DIST = 20

local function getSpeechType(inst,speech)
    local line = speech.DEFAULT

    if inst.talkertype and speech[inst.talkertype] then
        line = speech[inst.talkertype]
    end

    if type(line) == "table" then
        line = line[math.random(#line)]
    end

    return line
end

local function shopkeeper_speech(inst, speech )
    if inst:IsValid() and not inst:IsAsleep() and not inst.components.combat.target and not inst:IsInLimbo() then
        inst.sayline(inst, speech)
    end
end

local function sayline(inst, line, mood)
    inst.components.talker:Say(line, 1.5, nil, true, mood)
end

local function ontalk(inst, script, mood)
    if inst:HasTag("guard") then
        if mood and mood == "alarmed" then
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/guard_alert")
        else
            inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
        end
    else
        if inst.female then
            if mood and mood == "alarmed" then
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/scream_female")
            else
               inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_female","talk")
            end
        else
            if mood and mood == "alarmed" then
                inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/scream")
            else
    	       inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk","talk")
            end
        end
    end
end

local function ontalkfinish(inst)
	inst.SoundEmitter:KillSound("talk")
end

local function SpringMod(amt)
    if TheWorld.state.isspring then
        return amt * 1.33
    else
        return amt
    end
end

local function CalcSanityAura(inst, observer)
	if inst.components.werebeast
       and inst.components.werebeast:IsInWereState() then
		return -TUNING.SANITYAURA_LARGE
	end
	
	if inst.components.follower and inst.components.follower.leader == observer then
		return TUNING.SANITYAURA_SMALL
	end
	
	return 0
end

local function ShouldAcceptItem(inst, item)
    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        return true
    elseif inst.components.eater:CanEat(item) then
        local foodtype = item.components.edible.foodtype
        if foodtype == FOODTYPE.MEAT or foodtype == FOODTYPE.HORRIBLE then
            return inst.components.follower.leader == nil or inst.components.follower:GetLoyaltyPercent() <= TUNING.PIG_FULL_LOYALTY_PERCENT
        elseif foodtype == FOODTYPE.VEGGIE or foodtype == FOODTYPE.RAW then
            local last_eat_time = inst.components.eater:TimeSinceLastEating()
            return (last_eat_time == nil or
                    last_eat_time >= TUNING.PIG_MIN_POOP_PERIOD)
                and (inst.components.inventory == nil or
                    not inst.components.inventory:Has(item.prefab, 1))
        end
        return true
    end
end

local function OnGetItemFromPlayer(inst, giver, item)
    if item.components.edible ~= nil then
        if (    item.components.edible.foodtype == FOODTYPE.MEAT or
                item.components.edible.foodtype == FOODTYPE.HORRIBLE
            ) and
            item.components.inventoryitem ~= nil and
            (   
                item.components.inventoryitem:GetGrandOwner() == inst or
                (   not item:IsValid() and
                    inst.components.inventory:FindItem(function(obj)
                        return obj.prefab == item.prefab
                            and obj.components.stackable ~= nil
                            and obj.components.stackable:IsStack()
                    end) ~= nil)
            ) then
            if inst.components.combat:TargetIs(giver) then
                inst.components.combat:SetTarget(nil)
            elseif giver.components.leader ~= nil and not (inst:HasTag("guard") or giver:HasTag("monster") or giver:HasTag("merm")) then

				if giver.components.minigame_participator == nil then
	                giver:PushEvent("makefriend")
	                giver.components.leader:AddFollower(inst)
				end
                inst.components.follower:AddLoyaltyTime(item.components.edible:GetHunger() * TUNING.PIG_LOYALTY_PER_HUNGER)
                inst.components.follower.maxfollowtime =
                    giver:HasTag("polite")
                    and TUNING.PIG_LOYALTY_MAXTIME + TUNING.PIG_LOYALTY_POLITENESS_MAXTIME_BONUS
                    or TUNING.PIG_LOYALTY_MAXTIME
            end
        end
        if inst.components.sleeper:IsAsleep() then
            inst.components.sleeper:WakeUp()
        end
    end

    if item.components.equippable ~= nil and item.components.equippable.equipslot == EQUIPSLOTS.HEAD then
        local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if current ~= nil then
            inst.components.inventory:DropItem(current)
        end
        inst.components.inventory:Equip(item)
        inst.AnimState:Show("hat")
    end
end

local function OnRefuseItem(inst, item)
    inst.sg:GoToState("refuse")
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function OnEat(inst, food)
    if food.components.edible ~= nil then
        if food.components.edible.foodtype == FOODTYPE.VEGGIE then
            SpawnPrefab("poop").Transform:SetPosition(inst.Transform:GetWorldPosition())
        elseif food.components.edible.foodtype == FOODTYPE.MEAT and
            inst.components.werebeast ~= nil and
            not inst.components.werebeast:IsInWereState() and
            food.components.edible:GetHealth(inst) < 0 then
            inst.components.werebeast:TriggerDelta(1)
        end
    end
end

local function OnAttackedByDecidRoot(inst, attacker)
    local fn = function(dude) return dude:HasTag("pig") and not dude:HasTag("werepig") and not dude:HasTag("guard") end

    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = nil
    if TheWorld.state.isspring then
        ents = TheSim:FindEntities(x,y,z, (SHARE_TARGET_DIST * 1.33) / 2)
    else
        ents = TheSim:FindEntities(x,y,z, SHARE_TARGET_DIST / 2)
    end
    
    if ents then
        local num_helpers = 0
        for k,v in pairs(ents) do
            if v ~= inst and v.components.combat and not (v.components.health and v.components.health:IsDead()) and fn(v) then
                if v:PushEvent("suggest_tree_target", {tree=attacker}) then
                    num_helpers = num_helpers + 1
                end
            end
            if num_helpers >= MAX_TARGET_SHARES then
                break
            end     
        end
    end

end

local function OnAttacked(inst, data)
    local attacker = data.attacker
    inst:ClearBufferedAction()

	if not attacker then return end
		if attacker.prefab == "deciduous_root" and attacker.owner then 
			OnAttackedByDecidRoot(inst, attacker.owner)
    elseif attacker.prefab ~= "deciduous_root" then
			inst.components.combat:SetTarget(attacker)
        if inst:HasTag("guard") then
            if attacker:HasTag("player") then
                inst:AddTag("angry_at_player")
            end
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("pig") and (dude:HasTag("guard") or not attacker:HasTag("pig")) end, MAX_TARGET_SHARES)
        else
            if not (attacker:HasTag("pig") and attacker:HasTag("guard") ) then
                inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("pig") end, MAX_TARGET_SHARES)
            end
        end
    end
end

local builds = {"pig_build", "pigspotted_build"}
local guardbuilds = {"pig_guard_build"}

local function NormalRetargetFn(inst)
    return FindEntity(inst, CITY_PIG_GUARD_TARGET_DIST,
	function(guy)
		if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
			if guy:HasTag("player") and inst:HasTag("angry_at_player") and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) then
				inst.sayline(inst, getSpeechType(inst, STRINGS.CITY_PIG_GUARD_TALK_ANGRY_PLAYER))
			end
				
			return (guy:HasTag("monster") or guy:HasTag("merm") or (guy:HasTag("player") and inst:HasTag("angry_at_player"))  ) and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) and not 
			(inst.components.follower.leader ~= nil and guy:HasTag("abigail"))
		end
	end)
end

local function NormalKeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
	and (not target.LightWatcher or target.LightWatcher:IsInLight())
	and not (target.sg and target.sg:HasStateTag("transform") )
end

local function NormalShouldSleep(inst)
    if inst.components.follower and inst.components.follower.leader then
        local fire = FindEntity(inst, 6, function(ent)
            return ent.components.burnable
                   and ent.components.burnable:IsBurning()
        end, {"campfire"})
        return DefaultSleepTest(inst) and fire and (not inst.LightWatcher or inst.LightWatcher:IsInLight())
    else
        return DefaultSleepTest(inst)
    end
end

local function OnSave(inst, data)
	data.build = inst.build      

	data.children = {}
				
	if inst:HasTag("angry_at_player") then
		data.angryatplayer = true
	end   

	if inst.equipped then
		data.equipped = true
	end

	if data.children and #data.children > 0 then
		return data.children
	end    
end        
        
local function OnLoad(inst, data)    
	if data then                
	inst.build = data.build or builds[1]
		if data.atdesk then
			inst.sg:GoToState("desk_pre")
		end 
		
		if data.equipped then
			inst.equipped = true
			inst.equiptask:Cancel()
			inst.equiptask = nil
		end

		if data.angryatplayer then
			inst:AddTag("angry_at_player") 
		end 
	end
end           
        
local function OnLoadPostPass(inst, ents, data)
	if data then
		if data.children then                    
			for k,v in pairs(data.children) do
				local item = ents[v]            
			if item then
				if data.desk and data.desk == v then
					inst.desk = item.entity
					inst:AddComponent("homeseeker") 
					inst.components.homeseeker:SetHome(inst.desk)  
					end
				end                    
			end
		end
	end
end   

local function SetNormalPig(inst, brain_id)
    inst:RemoveTag("werepig")
    inst:RemoveTag("guard")
    
    inst.components.sleeper:SetResistance(2)

    inst.components.combat:SetDefaultDamage(TUNING.PIG_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.PIG_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
    inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED
    
    inst.components.sleeper:SetSleepTest(NormalShouldSleep)
    inst.components.sleeper:SetWakeTest(DefaultWakeTest)
    
    inst.components.lootdropper:SetLoot({})
    inst.components.lootdropper:AddRandomLoot("meat",3)
    inst.components.lootdropper:AddRandomLoot("pigskin",1)
    inst.components.lootdropper.numrandomloot = 1

    inst.components.health:SetMaxHealth(TUNING.PIG_HEALTH)
	
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
    inst.components.combat:SetTarget(nil)
    inst:ListenForEvent("suggest_tree_target", function(inst, data)
        if data and data.tree and inst:GetBufferedAction() ~= ACTIONS.CHOP then
            inst.tree_target = data.tree
        end
    end)
    
    inst.components.trader:Disable()
    inst.components.talker:StopIgnoringAll()
	
    inst:SetBrain(brain)
    inst:SetStateGraph("SGpigmancity")
end

local function makefn(name, build, fixer, guard_pig, shopkeeper, tags, sex, econprefab)
    local function make_common()
    	local inst = CreateEntity()
		
		inst.entity:AddTransform()
    	inst.entity:AddAnimState()
    	inst.entity:AddSoundEmitter()
		inst.entity:AddLightWatcher()
		inst.entity:AddNetwork()
	
		local shadow = inst.entity:AddDynamicShadow()
    	shadow:SetSize(1.5, .75)

        inst.Transform:SetFourFaced()
		MakeCharacterPhysics(inst, 50, .5)
        
        inst:AddComponent("talker")
        inst.components.talker.ontalk = ontalk
		inst.components.talker.donetalkingfn = ontalkfinish
        inst.components.talker.fontsize = 35
        inst.components.talker.font = TALKINGFONT
        inst.components.talker.offset = Vector3(0,-600,0)
        inst.talkertype = name

        inst.sayline = sayline

        inst.AnimState:SetBank("townspig")
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle_loop",true)
        inst.AnimState:Hide("hat")
        inst.AnimState:Hide("desk")
        inst.AnimState:Hide("ARM_carry")
		
		inst:AddTag("character")
        inst:AddTag("pig")
        inst:AddTag("civilized")
        inst:AddTag("scarytoprey")
        inst:AddTag("city_pig")
		inst:AddTag("_named")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end		
		
		inst:RemoveTag("_named")
		
		inst:AddComponent("health")
		inst:AddComponent("lootdropper")
        inst:AddComponent("knownlocations")
		inst:AddComponent("drownable")
		inst:AddComponent("embarker")
		
		inst:AddComponent("sleeper")
		inst.components.sleeper.watchlight = true
		
        inst:AddComponent("locomotor")
        inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED
        inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED
		inst.components.locomotor:SetAllowPlatformHopping(true)
		
        inst:AddComponent("eater")
        inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
    	inst.components.eater:SetCanEatHorrible()
		inst.components.eater:SetCanEatRaw()
        inst.components.eater.strongstomach = true
        inst.components.eater:SetOnEatFn(OnEat)
		
        inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "pig_torso"
		
		inst:AddComponent("named")
		local names = {}
        for i, name in ipairs(STRINGS.CITYPIGNAMES["UNISEX"]) do
            table.insert(names, name)
        end	
        if sex then
            if sex == "MALE" then
                inst.female = false
            else
                inst.female = true
            end
            for i,name in ipairs(STRINGS.CITYPIGNAMES[sex]) do
                table.insert(names, name)
            end
        end

        inst.components.named.possiblenames = names
        inst.components.named:PickNewName()
		
        inst:AddComponent("follower")
        inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME
		
        inst:AddComponent("inventory")
		inst.components.inventory:DisableDropOnDeath()

        inst:AddComponent("trader")
        inst.components.trader:SetAcceptTest(ShouldAcceptItem)
        inst.components.trader.onaccept = OnGetItemFromPlayer
        inst.components.trader.onrefuse = OnRefuseItem

        inst:AddComponent("sanityaura")
        inst.components.sanityaura.aurafn = CalcSanityAura
        
        -- MakeMediumBurnableCharacter(inst, "pig_torso")
		MakeMediumFreezableCharacter(inst, "pig_torso")
		MakeHauntablePanic(inst)

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = function(inst)
		if inst.components.follower.leader ~= nil then
				return "FOLLOWER"
			end
        end

        inst:ListenForEvent("attacked", OnAttacked)    
        
        SetNormalPig(inst)
		
		inst.OnSave = OnSave 
		inst.OnLoad = OnLoad

        return inst
    end
    return make_common
end

local function makepigman(name, build, fixer, guard_pig, shopkeeper, tags, sex)   
    return Prefab("kyno_".. name, makefn(name, build, fixer, guard_pig, shopkeeper, tags, sex), assets, prefabs)  
end

-- Name / Build / Fixer / Guard / Shop / Tags / Sex
return makepigman("pigman_beautician", "pig_beautician", nil, nil, nil, {"female_pig"}, "FEMALE"),
makepigman("pigman_florist", "pig_florist", nil, nil, nil, {"female_pig"}, "FEMALE"),
makepigman("pigman_erudite", "pig_erudite", nil, nil, nil, {"female_pig"}, "FEMALE"),
makepigman("pigman_hatmaker", "pig_hatmaker", nil, nil, nil, {"female_pig"}, "FEMALE"),
makepigman("pigman_storeowner", "pig_storeowner", nil, nil, nil, {"emote_nohat","female_pig"}, "FEMALE"),
makepigman("pigman_banker", "pig_banker", nil, nil, nil, {"emote_nohat","male_pig"}, "MALE"),
makepigman("pigman_collector", "pig_collector", nil, nil, nil, {"male_pig"}, "MALE"),
makepigman("pigman_hunter", "pig_hunter", nil, nil, nil, {"male_pig"}, "MALE"),
makepigman("pigman_mayor", "pig_mayor", nil,  nil, nil, {"male_pig"}, "MALE"),
makepigman("pigman_mechanic", "pig_mechanic", nil, nil, nil, {"male_pig"}, "MALE"),
makepigman("pigman_professor", "pig_professor", nil, nil, nil, {"male_pig"}, "MALE"),
makepigman("pigman_usher", "pig_usher", nil, nil, nil, {"male_pig"}, "MALE"),
makepigman("pigman_farmer", "pig_farmer", nil, nil, nil, {"male_pig"}, "MALE"),
makepigman("pigman_miner", "pig_miner", nil, nil, nil, {"male_pig"}, "MALE"),
makepigman("pigman_queen", "pig_queen", nil, nil, nil, {"pigroyalty","emote_nohat","female_pig", "FEMALE"}, "FEMALE")