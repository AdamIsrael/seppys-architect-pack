-- Fix for the Elephant Cactus.
-- Source: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795

local unpack = unpack
local Combat = require("components/combat")

local _CanAttack = Combat.CanAttack
function Combat:CanAttack(target, ...)
    local rets = {_CanAttack(self, target, ...)}
    if rets[1] then
        for i, v in ipairs(self.notags or {}) do
            if target:HasTag(v) then
                rets[1] = false
                break
            end
        end
    end
    return unpack(rets)
end

local function onnotags(self, notags)
    self.inst.replica.combat.notags = notags
end

AddComponentPostInit("combat", function(cmp)
    addsetter(cmp, "notags", onnotags)
end)