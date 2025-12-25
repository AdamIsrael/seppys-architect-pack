-- Original code by DarkXero, I just edited it to suit my needs :P ---
local TECH = GLOBAL.TECH

TECH.NONE.BARQUINHO = 0

TECH.BARQUINHO_ONE = { BARQUINHO = 1 }
TECH.BARQUINHO_TWO = { BARQUINHO = 2 }

for k,v in pairs(GLOBAL.TUNING.PROTOTYPER_TREES) do
    v.BARQUINHO = 0
end

--We define what a "BARQUINHO" prototyping machine grants us access to:
GLOBAL.TUNING.PROTOTYPER_TREES.BARQUINHO = {
	SCIENCE = 0, 
	MAGIC = 1, -- magic level 1 doesn't practically exist, but for some reason mod won't work without it
	ANCIENT = 0, 
	SHADOW = 0, 
	CARTOGRAPHY= 0, 
	SCULPTING = 0, 
	ORPHANAGE = 0, 
	GABENCRAFTER = 0, 
	CELESTIAL = 0,
	MOON_ALTAR = 0,
	SEAFARING = 0,
	PERDOFFERING = 0,
	WARGOFFERING = 0,
	PIGOFFERING = 0,
	CARRATOFFERING = 0,
	MADSCIENCE = 0,
	FOODPROCESSING = 0,
	FISHING = 0,
	WINTERSFEASTCOOKING = 0,
	BARQUINHO = 1,
}
	
-- Tell the game to not ignore the level
AddComponentPostInit("builder", function(self)
	self.gabencrafter_bonus = 0
	local _KR = self.KnowsRecipe
	self.KnowsRecipe = function(self, recname)
		local recipe = GetValidRecipe(recname)
		local ret = _KR(self, recname)
		if recipe and recipe.level.BARQUINHO then
			return (ret and recipe.level.BARQUINHO <= self.gabencrafter_bonus) or self.freebuildmode or table.contains(self.recipes, recname)
		end
		return ret
	end
	local _ETT = self.EvaluateTechTrees
	self.EvaluateTechTrees = function(self)
		_ETT(self)
		if self.current_prototyper == nil then
			self.accessible_tech_trees.BARQUINHO = 0
			if self.inst.barquinholevel then
				self.inst.barquinholevel:set(0)
			end
		end
	end
end)

-- Now... this is host side, now we hack clients

AddPlayerPostInit(function(inst)
	inst.barquinholevel = GLOBAL.net_tinybyte(inst.GUID, "p.glevel", "gleveldirty") -- 0..7
	inst.barquinholevel:set_local(0)
end)

local b_rep = GLOBAL.require("components/builder_replica")
local _SetTechTrees = b_rep.SetTechTrees
b_rep.SetTechTrees = function(self, techlevels)
	_SetTechTrees(self, techlevels)
	if self.inst.barquinholevel then
		self.inst.barquinholevel:set(techlevels.BARQUINHO or 0)
	end
end

local R_KR = b_rep.KnowsRecipe
b_rep.KnowsRecipe = function(self, recipename)
	if self.inst.components.builder == nil and self.classified ~= nil then
		local recipe = GetValidRecipe(recipename)
		local ret = R_KR(self, recipename)
		if recipe and recipe.level.BARQUINHO then
			return (ret and recipe.level.BARQUINHO <= self.inst.barquinholevel:value()) 
				or self.classified.isfreebuildmode:value() or (self.classified.recipes[recipename] ~= nil and self.classified.recipes[recipename]:value())
		end
		return ret
	end
	return R_KR(self, recipename)
end
