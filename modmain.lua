-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath

-- Mod Dependencies.
local tapmodimports = 
{
	"tap_assets",
	"tap_prefabs",
	"tap_strings",
	"tap_strings_extras",
	"tap_loadingtips",
	"tap_postinits",
	"tap_combat_postinits",
	"tap_combat_replica_postinits",
	"tap_containers",
	"tap_endtable",
	"tap_lights",
	"tap_icons",
	"tap_recipes",
	"tap_tuning",
}

for _, v in pairs(tapmodimports) do
	modimport("tap_init/"..v)
end

-- Env.
modimport("tap_init/libs/env")

-- Fix For Inventory Icons.
local atlas = (src and src.components.inventoryitem and src.components.inventoryitem.atlasname and resolvefilepath(src.components.inventoryitem.atlasname) ) or "images/inventoryimages.xml"

-- Custom deploy for Sand Bags.
local _CanDeploySandbagAtPoint = Map.CanDeploySandbagAtPoint
function Map:CanDeploySandbagAtPoint(pt, inst, ...)
	for i, v in ipairs(TheSim:FindEntities(pt.x, 0, pt.z, 2, {"kyno_sandbagsmall_item"})) do
        if v ~= inst and
            v.entity:IsVisible() and
            v.components.placer == nil and
            v.entity:GetParent() == nil then
			local opt = v:GetPosition()
			if math.abs(math.abs(opt.x) - math.abs(pt.x)) < 1 and math.abs(math.abs(opt.z) - math.abs(pt.z)) < 1 then
				return false
			end
        end
    end
    return _CanDeploySandbagAtPoint(self, pt, inst, ...)
end

-- Placer Methods.
local PLACING_METHOD = GetModConfigData("TAP_PLACING_METHOD")
if PLACING_METHOD == 1 then
	for _,v in pairs(_G.AllRecipes) do
		v.min_spacing = 0
	end
end