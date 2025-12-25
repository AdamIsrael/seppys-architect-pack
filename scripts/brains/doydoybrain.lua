require "behaviours/runaway"
require "behaviours/wander"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/minperiod"

local TIME_BETWEEN_EATING = 2

local SEE_FOOD_DIST = 15
local SEE_STRUCTURE_DIST = 30

local BASE_TAGS = {"structure"}
local FOOD_TAGS = {"edible", "preparedfood", "spicedfood"}
local STEAL_TAGS = {"structure"}
local NO_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "AQUATIC", "DD_FOOD"}

local MAX_CHASE_TIME = 20
local MAX_WANDER_DIST = 16
local MAX_CHASEAWAY_DIST = 32
local START_FACE_DIST = 6
local KEEP_FACE_DIST = 8
local WARN_BEFORE_ATTACK_TIME = 2
local DOYDOY_MATING_DANCE_DIST = 3 

local VALID_FOODS = 
{
	"berries",
	"berries_juicy",
	"cave_banana",
	"carrot",
	"blue_cap",
	"green_cap",
	"carrot_planted",
	"mandrake_planted",
	"seeds",
}

local function ItemIsInList(item, list)
	for k,v in pairs(list) do
		if v == item or k == item then
			return true
		end
	end
end

local function EatFoodAction(inst)  --Look for food to eat

	local target = FindEntity(inst, SEE_FOOD_DIST, function(item, i)
            return i.components.eater:CanEat(item) and
                item.components.edible and
                not (item.components.inventoryitem and item.components.inventoryitem:IsHeld()) and
                item:IsOnPassablePoint() and
                item:GetCurrentPlatform() == i:GetCurrentPlatform()
        end)
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem:IsHeld()) end
        return act
    end   

	if target then
		local action = BufferedAction(inst,target,ACTIONS.PICKUP)
		return action 
	end
end

local function StealFoodAction(inst) --Look for things to take food from (EatFoodAction handles picking up/ eating)

	-- Food On Ground > Pots = Farms = Drying Racks > Plants

	local target = nil

	if inst.sg:HasStateTag("busy") or 
	(inst.components.inventory and inst.components.inventory:IsFull()) then
		return
	end

	local pt = inst:GetPosition()
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, SEE_STRUCTURE_DIST, nil, NO_TAGS) 
	--Look for crop/ cookpots/ drying rack, harvest them.
	if not target then
		for k,item in pairs(ents) do
			if (item.components.stewer and item.components.stewer:IsDone()) then
				target = item
			end
		end
	end

	if target then
		return BufferedAction(inst, target, ACTIONS.HARVEST)
		-- return BufferedAction(inst, target,ACTIONS.EAT)
	end

	--Berrybushes, carrots etc.
	if not target then
		for k,item in pairs(ents) do
			if item.components.pickable and 
			item.components.pickable.caninteractwith and 
			item.components.pickable:CanBePicked() and
			ItemIsInList(item.components.pickable.product, VALID_FOODS) then
			-- ItemIsInList(VALID_FOODS, item.components.pickable.product) then
				target = item
				break
			end
		end
	end

	if target then
		return BufferedAction(inst, target, ACTIONS.PICK)
	end
end

local function CanMate(doy)
	if doy == nil then
		return false
	end

	if doy.components.inventoryitem and doy.components.inventoryitem:IsHeld() then	
		return false
	end

	if doy:IsAsleep() then
		return false
	end

	if doy.components.sleeper:IsAsleep() then
		return false
	end

	return true
end

local function MateAction(inst)
	if CanMate(inst) and inst:HasTag("d_male") then
	local mate = GetClosestInstWithTag("d_female", inst, 4)
	if not mate then return false end
		if mate and mate.components.inventoryitem and mate.components.inventoryitem:IsHeld() then return false end		
		local pt = inst:GetPosition()
		local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, SEE_STRUCTURE_DIST, {"d_female"}) 
		for k,item in pairs(ents) do
			if CanMate(item) then
                inst.sg:GoToState("mate")
			end
		end
	end
end

local DoydoyBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function DoydoyBrain:OnStart()
	
	local eatnode =
	PriorityNode(
	{
		DoAction(self.inst, StealFoodAction),
	}, 2)

	local root =
	PriorityNode(
	{
		DoAction(self.inst, function() return MateAction(self.inst) end, "Mate", true),
		WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
		-- DoAction(self.inst, EatFoodAction), 
		-- MinPeriod(self.inst, math.random(4,6), true, eatnode),
		Wander(self.inst, nil, 15),
	},1)
	
	self.bt = BT(self.inst, root) 
		
end

return DoydoyBrain
