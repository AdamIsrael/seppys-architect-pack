-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath
local STRINGS			= _G.STRINGS
local ACTIONS 			= _G.ACTIONS
local ActionHandler		= _G.ActionHandler
local SpawnPrefab		= _G.SpawnPrefab
local shelfer 			= require("components/shelfer")
local TechTree 			= require("techtree")
local KENV 				= env

modimport("tap_init/libs/env")

-- Actions for the Shelves.
AddAction("GIVESHELF", STRINGS.ACTIONS.GIVESHELF, function(act)
	if act.invobject.components.inventoryitem then
			act.target.components.shelfer:AcceptGift(act.doer, act.invobject)
		return true
	end 
end)

ACTIONS.GIVESHELF.priority = 5
ACTIONS.GIVESHELF.distance = 1
ACTIONS.GIVESHELF.mount_valid = true

AddAction("PICKUPSHELF", STRINGS.ACTIONS.PICKUPSHELF, function(act)
	if act.target and act.target.components.inventoryitem and act.target.components.shelfer then
		local item  = act.target.components.shelfer:GetGift()
		if item then
			if item.components.perishable then 
				item.components.perishable:StartPerishing()
			end
			
			act.target = act.target.components.shelfer:GiveGift()	
		end
	end
        
	act.doer.components.inventory:GiveItem(act.target, nil, act.target:GetPosition())
	return true
end)

ACTIONS.PICKUPSHELF.priority = 5
ACTIONS.PICKUPSHELF.distance = 1
ACTIONS.PICKUPSHELF.mount_valid = true

local oldPICKUPfn = ACTIONS.PICKUP.fn
function ACTIONS.PICKUP.fn(act, ...)
    if act.target and act.target.components.inventoryitem and act.target.components.shelfer then
		local item = act.target.components.shelfer:GetGift()
		if item then
			if item.components.perishable then 
				item.components.perishable:StartPerishing()
			end
			
			act.target = act.target.components.shelfer:GiveGift()	
		end
        
		act.doer.components.inventory:GiveItem(act.target, nil, act.target:GetPosition())
		return true
    else
        return oldPICKUPfn(act, ...)
    end
end

AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) 
    if not right then
		if target:HasTag("SHELVES_SLOT") then
			table.insert(actions, ACTIONS.GIVESHELF)        
		end 	
	end
end)

AddStategraphActionHandler("wilson",        _G.ActionHandler(_G.ACTIONS.GIVESHELF,   "give"))
AddStategraphActionHandler("wilson_client", _G.ActionHandler(_G.ACTIONS.GIVESHELF,   "give"))
AddStategraphActionHandler("wilson",        _G.ActionHandler(_G.ACTIONS.PICKUPSHELF, "give"))
AddStategraphActionHandler("wilson_client", _G.ActionHandler(_G.ACTIONS.PICKUPSHELF, "give"))

--[[
local GIVESHELF = _G.Action({priority = 10, distance = 1, mount_valid = true})
GIVESHELF.str = "Store"
GIVESHELF.id = "GIVESHELF"
GIVESHELF.fn = function(act)
	if act.invobject.components.inventoryitem then
			act.target.components.shelfer:AcceptGift(act.doer, act.invobject)
		return true
	end 
end
AddAction(GIVESHELF)

AddComponentAction("USEITEM", "inventoryitem", function(inst, doer, target, actions, right) 
    if not right then
    if target:HasTag("SHELVES_SLOT") then -- target.components.shelfer and target.components.shelfer:CanAccept(inst, doer ) then        
			table.insert(actions, ACTIONS.GIVESHELF)        
		end 	
	end
end)

local PICKUP = _G.Action({priority = 1, distance = 2, mount_valid = true})
PICKUP.str = (_G.STRINGS.ACTIONS.PICKUP)
PICKUP.id = "PICKUP"
PICKUP.fn = function(act)
	if act.target and act.target.components.inventoryitem and act.target.components.shelfer then
		local item  = act.target.components.shelfer:GetGift()
		if item then
		item:AddTag("cost_one_oinc")
		if act.target.components.shelfer.shelf and not act.target.components.shelfer.shelf:HasTag("playercrafted") then
			if act.doer.components.shopper and act.doer.components.shopper:IsWatching(item) then 
				if act.doer.components.shopper:CanPayFor(item) then 
					act.doer.components.shopper:PayFor(item)
				else 			
					return false, "CANTPAY"
				end
			else
				if act.target.components.shelfer.shelf and act.target.components.shelfer.shelf.curse then
					act.target.components.shelfer.shelf.curse(act.target)
				end						
			end
		end
		item:RemoveTag("cost_one_oinc")
		if item.components.perishable then item.components.perishable:StartPerishing() end		
		act.target = act.target.components.shelfer:GiveGift()	
		end
	end

    if act.doer.components.inventory ~= nil and
        act.target ~= nil and
        act.target.components.inventoryitem ~= nil and
        (act.target.components.inventoryitem.canbepickedup or
        (act.target.components.inventoryitem.canbepickedupalive and not act.doer:HasTag("player"))) and
        not (act.target:IsInLimbo() or
            (act.target.components.burnable ~= nil and act.target.components.burnable:IsBurning()) or
            (act.target.components.projectile ~= nil and act.target.components.projectile:IsThrown())) then

        if act.doer.components.itemtyperestrictions ~= nil and not act.doer.components.itemtyperestrictions:IsAllowed(act.target) then
            return false, "restriction"
        elseif act.target.components.container ~= nil and act.target.components.container:IsOpen() and not act.target.components.container:IsOpenedBy(act.doer) then
            return false, "inuse"
        end

        act.doer:PushEvent("onpickupitem", { item = act.target })

        if act.target.components.equippable ~= nil and not act.target.components.equippable:IsRestricted(act.doer) then
            local equip = act.doer.components.inventory:GetEquippedItem(act.target.components.equippable.equipslot)
            if equip ~= nil and not act.target.components.inventoryitem.cangoincontainer then
                if equip.components.inventoryitem ~= nil and equip.components.inventoryitem.cangoincontainer then
                    act.doer.components.inventory:GiveItem(act.doer.components.inventory:Unequip(act.target.components.equippable.equipslot))
                else
                    act.doer.components.inventory:DropItem(equip)
                end
                act.doer.components.inventory:Equip(act.target)
                return true
            elseif act.doer:HasTag("player") then
                if equip == nil or act.doer.components.inventory:GetNumSlots() <= 0 then
                    act.doer.components.inventory:Equip(act.target)
                    return true
                elseif _G.GetGameModeProperty("non_item_equips") then
                    act.doer.components.inventory:DropItem(equip)
                    act.doer.components.inventory:Equip(act.target)
                    return true
                end
            end
        end

        act.doer.components.inventory:GiveItem(act.target, nil, act.target:GetPosition())
        return true
    end
end
AddAction(PICKUP)

AddStategraphActionHandler("wilson", _G.ActionHandler(_G.ACTIONS.GIVESHELF, "give"))
AddStategraphActionHandler("wilson_client", _G.ActionHandler(_G.ACTIONS.GIVESHELF, "give"))
]]--