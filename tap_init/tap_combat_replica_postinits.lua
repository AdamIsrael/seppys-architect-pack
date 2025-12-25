-- Fix for the Elephant Cactus.
-- Source: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795

local Combat = require("components/combat_replica")

local _IsValidTarget = Combat.IsValidTarget
function Combat:IsValidTarget(target, ...)
    local isvalidtarget = _IsValidTarget(self, target, ...)
    if isvalidtarget then
        for i, v in ipairs(self.notags or {}) do
            if target:HasTag(v) then
                return false
            end
        end
        return isvalidtarget
    end
    return false
end

local _CanAttack = Combat.CanAttack
function Combat:CanAttack(target, ...)
    local canattack, idk = _CanAttack(self, target, ...)
    if canattack then
        for i, v in ipairs(self.notags or {}) do
            if target:HasTag(v) then
                return false, nil
            end
        end
        return canattack, idk
    end
    return canattack, idk
end

local _CanBeAttacked = Combat.CanBeAttacked
function Combat:CanBeAttacked(attacker, ...)
    if self.canbeattackedfn and not self.canbeattackedfn(self.inst, attacker) then
        return false
    end
    return _CanBeAttacked(self, attacker, ...)
end