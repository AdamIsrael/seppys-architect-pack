require "behaviours/wander"
require "behaviours/follow"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/findlight"
require "behaviours/panic"
require "behaviours/chattynode"
require "behaviours/leash"

local MIN_FOLLOW_DIST = 2
local TARGET_FOLLOW_DIST = 5
local MAX_FOLLOW_DIST = 9
local MAX_WANDER_DIST = 10
local LEASH_RETURN_DIST = 10
local LEASH_MAX_DIST = 30
local GO_HOME_DIST = 30
local START_FACE_DIST = 4
local KEEP_FACE_DIST = 8
local START_RUN_DIST = 3
local STOP_RUN_DIST = 5
local MAX_CHASE_TIME = 10  
local MAX_CHASE_DIST = 30 
local SEE_LIGHT_DIST = 20
local TRADE_DIST = 20
local SEE_TREE_DIST = 15
local SEE_TARGET_DIST = 20
local SEE_FOOD_DIST = 5
local SEE_MONEY_DIST = 6
local KEEP_CHOPPING_DIST = 10
local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8
local STOP_CHASE_CHAT = 35
local FAR_ENOUGH = 40
local BIG_NUMBER = 9999
local SEE_BURNING_HOME_DIST_SQ = 20*20
local COMFORT_LIGHT_LEVEL = 0.3

local function getSpeechType(inst, speech)
    local line = speech.DEFAULT
    return line
end

local function getString(speech)
    if type(speech) == "table" then
        return speech[math.random(#speech)]
    else
        return speech
    end
end

local function GetFaceTargetFn(inst)
    if inst.components.follower.leader then
        return inst.components.follower.leader
    end
    local target = GetClosestInstWithTag("player", inst, START_FACE_DIST)
    if target and not target:HasTag("notarget") then    
        return target
    end
end

local function KeepFaceTargetFn(inst, target)
    if inst.components.follower.leader then
        return inst.components.follower.leader == target
    end

    local keep_face = inst:IsNear(target, KEEP_FACE_DIST) and not target:HasTag("notarget")

    if not keep_face then
        inst.alerted = false
    end

    return keep_face
end

local function ShouldRunAway(inst, target)
    return not inst.components.trader:IsTryingToTradeWithMe(target)
end

local function GetTraderFn(inst)
    return FindEntity(inst, TRADE_DIST, function(target) return inst.components.trader:IsTryingToTradeWithMe(target) end, {"player"})
end

local function KeepTraderFn(inst, target)
    return inst.components.trader:IsTryingToTradeWithMe(target)
end

local function GreetAction(inst)
    if GetClosestInstWithTag("player", inst, START_FACE_DIST) then
        inst.sg:GoToState("alert")
        return true
    end
end

local function FindFoodAction(inst)
    local target = nil

	if inst.sg:HasStateTag("busy") or inst:HasTag("shopkeep") then
		return
	end
    
    if inst.components.inventory and inst.components.eater then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end
    
    local time_since_eat = inst.components.eater:TimeSinceLastEating()
    local noveggie = time_since_eat and time_since_eat < TUNING.PIG_MIN_POOP_PERIOD*4
    
    if not target and (not time_since_eat or time_since_eat > TUNING.PIG_MIN_POOP_PERIOD*2) then
        target = FindEntity(inst, SEE_FOOD_DIST, function(item)
				if item:GetTimeAlive() < 8 then return false end
				if item.prefab == "mandrake" then return false end
				if noveggie and item.components.edible and item.components.edible.foodtype ~= "MEAT" then
					return false
				end
				if not item:IsOnValidGround() then
					return false
				end
				return inst.components.eater:CanEat(item) 
			end)
    end
    if target then
        return BufferedAction(inst, target, ACTIONS.EAT)
    end

    if not target and (not time_since_eat or time_since_eat > TUNING.PIG_MIN_POOP_PERIOD*2) then
        target = FindEntity(inst, SEE_FOOD_DIST, 
            function(item) 
                if not item.components.shelf then return false end
                if not item.components.shelf.itemonshelf or not item.components.shelf.cantakeitem then return false end
                if noveggie and item.components.shelf.itemonshelf.components.edible and item.components.shelf.itemonshelf.components.edible.foodtype ~= "MEAT" then
                    return false
                end
                if not item:IsOnValidGround() then
                    return false
                end
                return inst.components.eater:CanEat(item.components.shelf.itemonshelf) 
            end)
    end

    if target then
        return BufferedAction(inst, target, ACTIONS.TAKEITEM)
    end
end

local function HasValidHome(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home ~= nil
        and home:IsValid()
        and not (home.components.burnable ~= nil and home.components.burnable:IsBurning())
        and not home:HasTag("burnt")
end

local function HasValidHome(inst)
    local home = inst.components.homeseeker ~= nil and inst.components.homeseeker.home or nil
    return home ~= nil
        and home:IsValid()
        and not (home.components.burnable ~= nil and home.components.burnable:IsBurning())
        and not home:HasTag("burnt")
end

local function GoHomeAction(inst)
    if
        HasValidHome(inst) and
        not inst.components.combat.target then
            return BufferedAction(inst, inst.components.homeseeker.home, ACTIONS.GOHOME)
    end
end

local function GetLeader(inst)
    return inst.components.follower.leader 
end

local function GetHomePos(inst)
    return HasValidHome(inst) and inst.components.homeseeker:GetHomePos()
end

local function GetNoLeaderHomePos(inst)
    return GetHomePos(inst)
end

local LIGHTSOURCE_TAGS = {"lightsource"}
local function GetNearestLightPos(inst)
    local light = GetClosestInstWithTag(LIGHTSOURCE_TAGS, inst, SEE_LIGHT_DIST)
    if light then
        return Vector3(light.Transform:GetWorldPosition())
    end
    return nil
end

local function GetNearestLightRadius(inst)
    local light = GetClosestInstWithTag(LIGHTSOURCE_TAGS, inst, SEE_LIGHT_DIST)
    if light then
        return light.Light:GetCalculatedRadius()
    end
    return 1
end

local function shouldPanic(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, 20, {"hostile"},{"city_pig"},{"LIMBO"}) 
    if #ents > 0 then
        dumptable(ents,1,1,1)
        return true
    end
        
    if inst.components.combat.target then
        local threat = inst.components.combat.target
        if threat then
            local myPos = Vector3(inst.Transform:GetWorldPosition())
            local threatPos = Vector3(threat.Transform:GetWorldPosition())
            local dist = distsq(threatPos, myPos)
            if dist < FAR_ENOUGH*FAR_ENOUGH then
                if dist > STOP_RUN_AWAY_DIST*STOP_RUN_AWAY_DIST then
                    return true
                end
            else
                inst.components.combat:GiveUp()
            end
        end
    end
    return false
end

local function shouldpanicwithspeech(inst)
    if shouldPanic(inst) then
        if math.random()<0.01 then                            
            local speechset = getSpeechType(inst,STRINGS.CITY_PIG_TALK_FLEE)
            local str = speechset[math.random(#speechset)]
            inst.components.talker:Say(str)               
        end
        return true
    end
end

local function SafeLightDist(inst, target)
    return (target:HasTag("player") or target:HasTag("playerlight")
            or (target.inventoryitem and target.inventoryitem:GetGrandOwner() and target.inventoryitem:GetGrandOwner():HasTag("player")))
        and 4
        or target.Light:GetCalculatedRadius() / 3
end

local function IsHomeOnFire(inst)
    return inst.components.homeseeker
        and inst.components.homeseeker.home
        and inst.components.homeseeker.home.components.burnable
        and inst.components.homeseeker.home.components.burnable:IsBurning()
        and inst:GetDistanceSqToInst(inst.components.homeseeker.home) < SEE_BURNING_HOME_DIST_SQ
end

local function inCityLimits(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, FAR_ENOUGH, {"citypossession"}, {"city_pig"}) 
    if #ents > 0 then
        return true
    end
    if inst.components.combat.target then

        local speechset = getSpeechType(inst,STRINGS.CITY_PIG_TALK_STAYOUT)
        local str = speechset[math.random(#speechset)]
        inst.components.talker:Say(str)

        inst.components.combat:GiveUp()
    end
    return false
end

function getfacespeech(inst)
	local speech = getSpeechType(inst, STRINGS.CITY_PIG_TALK_LOOKATWILSON)
	if ThePlayer and ThePlayer:HasTag("pigroyalty") then
		speech =  STRINGS.CITY_PIG_TALK_LOOKATWILSON.ROYALTY
	end
	return speech
end

local PigManCityBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

function PigManCityBrain:OnStart()
    local day = WhileNode( function() return TheWorld.state.isday end, "IsDay",
        PriorityNode{
            ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_FIND_MEAT),
                DoAction(self.inst, FindFoodAction )),
				
            Leash(self.inst, GetNoLeaderHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
			
            IfNode(function() return not self.inst.alerted and not self.inst.daily_gifting end, "greet",
                ChattyNode(self.inst, getfacespeech(self.inst),
                    FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn))),
					
            Wander(self.inst, GetNoLeaderHomePos, MAX_WANDER_DIST)
        },.5)
    local night = WhileNode( function() return TheWorld.state.isnight or TheWorld.state.isdusk end, "IsNight",
        PriorityNode{
			ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_GO_HOME),
                WhileNode( function() return not TheWorld.state.iscaveday or not self.inst:IsInLight() end, "Cave nightness",
                    DoAction(self.inst, GoHomeAction, "go home", true ))),
		
            ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_RUN_FROM_SPIDER),
                RunAway(self.inst, "spider", 4, 8)),
				
            ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_FIND_MEAT),
                DoAction(self.inst, FindFoodAction )),
					
			WhileNode(function() return TheWorld.state.isnight or TheWorld.state.isdusk and self.inst:IsLightGreaterThan(COMFORT_LIGHT_LEVEL) end, "IsInLight",
                Wander(self.inst, GetNearestLightPos, GetNearestLightRadius, {
                    minwalktime = 0.6,
                    randwalktime = 0.2,
                    minwaittime = 5,
                    randwaittime = 5
                })
            ),
            WhileNode(function() GetNearestLightPos(self.inst) end, "NeedLight",
                ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_FIND_LIGHT),
                    FindLight(self.inst, SEE_LIGHT_DIST, SafeLightDist))),
            
			ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_PANIC),
				Panic(self.inst)),
        },1)

    local root = 
        PriorityNode(
        {
            WhileNode(function() return self.inst.components.health.takingfiredamage end, "OnFire",
				ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_PANICFIRE),
					Panic(self.inst))),

            ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_FOLLOWWILSON), 
                Follow(self.inst, GetLeader, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST)),
            IfNode(function() return GetLeader(self.inst) end, "has leader",
                ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_FOLLOWWILSON),
                    FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn ))),

            ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_FLEE),
                WhileNode(function() return shouldpanicwithspeech(self.inst) end, "Threat Panic",
                    Panic(self.inst) )),

            ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_FLEE),
                WhileNode( function() return (self.inst.components.combat.target and not self.inst:HasTag("guard")) end, "Dodge",
                    RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST) )),                                

            ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_FLEE),
                RunAway(self.inst, function(guy) return guy:HasTag("pig") and guy.components.combat and guy.components.combat.target == self.inst end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST )),

            ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_ATTEMPT_TRADE),
                FaceEntity(self.inst, GetTraderFn, KeepTraderFn)),
				
			WhileNode(function() return IsHomeOnFire(self.inst) end, "OnFire",
				ChattyNode(self.inst, getSpeechType(self.inst, STRINGS.CITY_PIG_TALK_PANICFIRE),
					Panic(self.inst))),
            day,
            night
        }, .5)
    
    self.bt = BT(self.inst, root) 
end

return PigManCityBrain