-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local TECH 				= _G.TECH
local Ingredient 		= _G.Ingredient
local RECIPETABS 		= _G.RECIPETABS
local Recipe2 			= _G.Recipe2
local resolvefilepath 	= _G.resolvefilepath
local AllRecipes 		= _G.AllRecipes
local TechTree 			= require("techtree")
local RecipeFilter		= require("recipes_filter")

-- For sorting recipe.
-- Source: https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
local function SortRecipe(a, b, filter_name, offset)
    local filter = _G.CRAFTING_FILTERS[filter_name]
    if filter and filter.recipes then
        for sortvalue, product in ipairs(filter.recipes) do
            if product == a then
                table.remove(filter.recipes, sortvalue)
                break
            end
        end

        local target_position = #filter.recipes + 1
        for sortvalue, product in ipairs(filter.recipes) do
            if product == b then
                target_position = sortvalue + offset
                break
            end
        end

        table.insert(filter.recipes, target_position, a)
    end
end

local function SortBefore(a, b, filter_name)
    SortRecipe(a, b, filter_name, 0)
end

local function SortAfter(a, b, filter_name)
    SortRecipe(a, b, filter_name, 1)
end

-- Custom TechTree for The Terraformer.
table.insert(TechTree.AVAILABLE_TECH, "TURFMAKER")

TechTree.Create = function(t)
	t = t or {}
	for i, v in ipairs(TechTree.AVAILABLE_TECH) do
	    t[v] = t[v] or 0
	end
	return t
end

_G.TECH.NONE.TURFMAKER 	= 0
_G.TECH.TURFMAKER_ONE 	= { TURFMAKER = 1 }
_G.TECH.TURFMAKER_TWO 	= { TURFMAKER = 2 }

for k,v in pairs(TUNING.PROTOTYPER_TREES) do
    v.TURFMAKER = 0
end

TUNING.PROTOTYPER_TREES.TURFMAKER_ONE = TechTree.Create({
    TURFMAKER 	= 1,
})
TUNING.PROTOTYPER_TREES.TURFMAKER_TWO = TechTree.Create({
	TURFMAKER 	= 2,
})

for i, v in pairs(_G.AllRecipes) do
	if v.level.TURFMAKER 	== nil then
		v.level.TURFMAKER 	= 0
	end
end

local _IsMarshLand = AllRecipes["mermhouse_crafted"].testfn
local function IsTidalMarshLand(pt, rot, ...)
    return _G.TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z) == WORLD_TILES.TIDALMARSH
    or _IsMarshLand(pt, rot, ...)
end

AllRecipes["mermhouse_crafted"].testfn = IsTidalMarshLand
AllRecipes["mermthrone_construction"].testfn = IsTidalMarshLand
AllRecipes["mermwatchtower"].testfn = IsTidalMarshLand
AllRecipes["offering_pot"].testfn = IsTidalMarshLand
AllRecipes["offering_pot_upgraded"].testfn = IsTidalMarshLand
AllRecipes["merm_toolshed"].testfn = IsTidalMarshLand
AllRecipes["merm_toolshed_upgraded"].testfn = IsTidalMarshLand
AllRecipes["merm_armory"].testfn = IsTidalMarshLand
AllRecipes["merm_armory_upgraded"].testfn = IsTidalMarshLand

-- Custom Prototyper and Recipe Filters.
AddPrototyperDef("kyno_terraformer",
	{
		icon_atlas 			= "images/tabimages/tap_tabimages.xml",
		icon_image 			= "kyno_tab_turfs.tex",
		is_crafting_station = false,
		action_str 			= "TERRAFORMER",
		filter_text 		= "Supplementary Turfs",
	}
)

AddPrototyperDef("kyno_ancient_altar_broken", 
	{ 
		icon_atlas 			= "images/crafting_menu_icons.xml", 
		icon_image 			= "station_crafting_table.tex", 
		is_crafting_station = true,
		filter_text 		= _G.STRINGS.UI.CRAFTING_STATION_FILTERS.ANCIENT,
	}
)

AddPrototyperDef("kyno_ancient_altar", 
	{ 
		icon_atlas 			= "images/crafting_menu_icons.xml", 
		icon_image 			= "station_crafting_table.tex", 
		is_crafting_station = true,
		filter_text 		= _G.STRINGS.UI.CRAFTING_STATION_FILTERS.ANCIENT,
	}
)

AddPrototyperDef("kyno_critterlab", 
	{ 
		icon_atlas 			= "images/crafting_menu_icons.xml", 
		icon_image 			= "station_orphanage.tex", 
		is_crafting_station = true,
		action_str          = "CRITTERS",
		filter_text 		= _G.STRINGS.UI.CRAFTING_STATION_FILTERS.ORPHANAGE,
	}
)

AddPrototyperDef("kyno_wagpunk_workstation",
	{
		icon_atlas          = "images/crafting_menu_icons.xml",
		icon_image          = "station_wagpunk_workstation.tex",
		is_crafting_station = true,
		filter_text         = _G.STRINGS.UI.CRAFTING_STATION_FILTERS.WAGPUNK_WORKSTATION,
	}
)

AddRecipeFilter({name = "TAP_HAMLET", 		atlas =  "images/tabimages/tap_tabimages.xml", image = "kyno_tab_hamlet.tex"		})
AddRecipeFilter({name = "TAP_SHIPWRECKED", 	atlas =  "images/tabimages/tap_tabimages.xml", image = "kyno_tab_shipwrecked.tex"	})
AddRecipeFilter({name = "TAP_SURFACE", 		atlas =  "images/tabimages/tap_tabimages.xml", image = "kyno_tab_surface.tex"		})
AddRecipeFilter({name = "TAP_CAVES", 		atlas =  "images/tabimages/tap_tabimages.xml", image = "kyno_tab_caves.tex"			})
AddRecipeFilter({name = "TAP_FORGE", 		atlas =  "images/tabimages/tap_tabimages.xml", image = "kyno_tab_forge.tex"			})
AddRecipeFilter({name = "TAP_GORGE", 		atlas =  "images/tabimages/tap_tabimages.xml", image = "kyno_tab_gorge.tex"			})
AddRecipeFilter({name = "TAP_INTERIOR", 	atlas =  "images/tabimages/tap_tabimages.xml", image = "kyno_tab_interior.tex"		})
AddRecipeFilter({name = "TAP_LEGACY", 		atlas =  "images/tabimages/tap_tabimages.xml", image = "kyno_tab_legacy.tex"		})
AddRecipeFilter({name = "TAP_TURFS", 	    atlas =  "images/tabimages/tap_tabimages.xml", image = "kyno_tab_turfs.tex"			})
-- AddRecipeFilter({name = "TAP_PAINTING", 	atlas =  "images/tabimages/tap_tabimages.xml", image = "kyno_tab_painting.tex"		})

-- Atlas Dependencies for the recipes.
local TapBuildingAtlas  = "images/inventoryimages/tap_buildingimages.xml"
local TapBuildingAtlas2 = "images/inventoryimages/tap_buildingimages2.xml"
local TapInventoryAtlas = "images/inventoryimages/tap_inventoryimages.xml"

local TapDefaultAtlas 	= "images/inventoryimages.xml"
local TapDefaultAtlas1  = "images/inventoryimages1.xml"
local TapDefaultAtlas2 	= "images/inventoryimages2.xml"
local TapDefaultAtlas3 	= "images/inventoryimages3.xml"

-- Tweaked recipes for base building.
local TWEAK_RECIPES 	= GetModConfigData("TAP_TWEAK_RECIPES")
if TWEAK_RECIPES 		== 1 then
	local GateTweak 	= Recipe2("fence_gate_item", 	{Ingredient("boards", 1), 	Ingredient("rope",  1)}, 	TECH.SCIENCE_TWO,	{numtogive = 2})
	local FenceTweak 	= Recipe2("fence_item", 		{Ingredient("twigs", 2), 	Ingredient("rope",  1)}, 	TECH.SCIENCE_ONE,	{numtogive = 8})
	local HayTweak 		= Recipe2("wall_hay_item", 		{Ingredient("cutgrass", 2), Ingredient("twigs", 2)},	TECH.SCIENCE_ONE,	{numtogive = 8})
	local WoodTweak 	= Recipe2("wall_wood_item", 	{Ingredient("boards", 2),	Ingredient("rope",  1)},	TECH.SCIENCE_ONE,	{numtogive = 8})
	local StoneTweak 	= Recipe2("wall_stone_item", 	{Ingredient("cutstone", 2)},							TECH.SCIENCE_TWO,	{numtogive = 8})
	local MoonTweak 	= Recipe2("wall_moonrock_item",	{Ingredient("moonrocknugget", 2)},						TECH.SCIENCE_TWO,	{numtogive = 8})
	local OldBook 		= AddRecipe2("book_gardening", 	{Ingredient("papyrus", 2), 	Ingredient("seeds", 1), Ingredient("poop", 1)}, TECH.NONE, {builder_tag = "bookbuilder"}, {"CHARACTER"})
end

-- Recipes that don't belong to any Mod Category.
local KynPropSign		= AddRecipe2("kyno_propsign", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		nounlock 		= false,
		numtogive		= 1,
		atlas 			= TapBuildingAtlas,
		image 			= "kyno_propsign.tex",
	},
	{"WEAPONS"}
)

local KynDiviningRod 	= AddRecipe2("diviningrod", {Ingredient("twigs", 1), Ingredient("nightmarefuel", 5), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		nounlock 		= false,
		numtogive 		= 1,
		atlas       	= TapDefaultAtlas,
		image			= "diviningrod.tex",
	},
	{"TOOLS"}
)

local KynRack 			= AddRecipe2("kyno_meatrack_hermit_blueprint", {Ingredient("messagebottleempty", 3)}, TECH.HERMITCRABSHOP_SEVEN,
	{
		nounlock 		= true,
		numtogive   	= 1,
		sg_state    	= "give",
		product     	= "kyno_meatrack_hermit_blueprint",
		atlas       	= TapDefaultAtlas,
		image			= "blueprint_rare.tex",
	},
	{"CRAFTING_STATION"}
)

local KynBox 			= AddRecipe2("kyno_beebox_hermit_blueprint", {Ingredient("messagebottleempty", 3)}, TECH.HERMITCRABSHOP_SEVEN,
	{
		nounlock 		= true,
		numtogive   	= 1,
		sg_state    	= "give",
		product     	= "kyno_beebox_hermit_blueprint",
		atlas       	= TapDefaultAtlas,
		image			= "blueprint_rare.tex",
	},
	{"CRAFTING_STATION"}
)

local KynHouse 			= AddRecipe2("kyno_hermithouse1_blueprint", {Ingredient("messagebottleempty", 3)}, TECH.HERMITCRABSHOP_SEVEN,
	{
		nounlock 		= true,
		numtogive   	= 1,
		sg_state    	= "give",
		product     	= "kyno_hermithouse1_blueprint",
		atlas       	= TapDefaultAtlas,
		image			= "blueprint_rare.tex",
	},
	{"CRAFTING_STATION"}
)

local KynHouse2 		= AddRecipe2("kyno_hermithouse2_blueprint", {Ingredient("messagebottleempty", 3)}, TECH.HERMITCRABSHOP_SEVEN,
	{
		nounlock 		= true,
		numtogive   	= 1,
		sg_state    	= "give",
		product     	= "kyno_hermithouse2_blueprint",
		atlas       	= TapDefaultAtlas,
		image			= "blueprint_rare.tex",
	},
	{"CRAFTING_STATION"}
)

local KynHouse3 		= AddRecipe2("kyno_hermithouse3_blueprint", {Ingredient("messagebottleempty", 3)}, TECH.HERMITCRABSHOP_SEVEN,
	{
		nounlock 		= true,
		numtogive   	= 1,
		sg_state    	= "give",
		product     	= "kyno_hermithouse3_blueprint",
		atlas       	= TapDefaultAtlas,
		image			= "blueprint_rare.tex",
	},
	{"CRAFTING_STATION"}
)

local KynHouse4 		= AddRecipe2("kyno_hermithouse4_blueprint", {Ingredient("messagebottleempty", 3)}, TECH.HERMITCRABSHOP_SEVEN,
	{
		nounlock 		= true,
		numtogive   	= 1,
		sg_state    	= "give",
		product     	= "kyno_hermithouse4_blueprint",
		atlas       	= TapDefaultAtlas,
		image			= "blueprint_rare.tex",
	},
	{"CRAFTING_STATION"}
)

local KynPearl 			= AddRecipe2("hermit_pearl", {Ingredient("opalpreciousgem", 1), Ingredient("barnacle", 2)}, TECH.HERMITCRABSHOP_SEVEN,
	{
		nounlock 		= true,
		numtogive   	= 1,
		sg_state    	= "give",
		product     	= "hermit_pearl",
		atlas       	= TapDefaultAtlas1,
		image			= "hermit_pearl.tex",
	},
	{"CRAFTING_STATION"}
)

--[[
local KynFridge 		= AddRecipe2("kyno_wigfridge", {Ingredient("cutstone", 1), Ingredient("gears", 1), Ingredient("meat", 2)}, TECH.LOST,
	{
		placer 			= "kyno_wigfridge_placer",
		min_spacing 	= 0,
		atlas 			= TapBuildingAtlas2,
		image 			= "kyno_wigfridge.tex",
	},
	{"COOKING", "CONTAINERS"}
)
SortAfter("kyno_wigfridge", "icebox", "COOKING")
SortAfter("kyno_wigfridge", "icebox", "CONTAINERS")
]]--

local KynFurnace 		= AddRecipe2("kyno_frozenfurnace", {Ingredient("bluegem", 2), Ingredient("ice", 10), Ingredient("dragon_scales", 1)}, TECH.LOST,
	{
		placer			= "kyno_frozenfurnace_placer",
		min_spacing 	= 0,
		atlas 			= TapBuildingAtlas,
		image			= "kyno_frozenfurnace.tex",
	},
	{"STRUCTURES", "SUMMER", "LIGHT"}
)
SortAfter("kyno_frozenfurnace", "dragonflyfurnace", "STRUCTURES")
SortAfter("kyno_frozenfurnace", "dragonflyfurnace", "SUMMER")
SortAfter("kyno_frozenfurnace", "dragonflyfurnace", "LIGHT")

local KynFurnace2 		= AddRecipe2("saladfurnace", {Ingredient("greengem", 2), Ingredient("ratatouille", 10), Ingredient("dragon_scales", 1)}, TECH.LOST,
	{
		placer			= "kyno_frozenfurnace_placer",
		min_spacing 	= 0,
		atlas 			= TapBuildingAtlas,
		image			= "kyno_saladfurnace.tex",
	},
	{"STRUCTURES", "COOKING", "WINTER", "LIGHT"}
)
SortAfter("saladfurnace", "kyno_frozenfurnace", "STRUCTURES")
SortAfter("saladfurnace", "kyno_frozenfurnace", "LIGHT")
SortAfter("saladfurnace", "dragonflyfurnace", "COOKING")
SortAfter("saladfurnace", "dragonflyfurnace", "WINTER")

local KynPumpkinHead 	= AddRecipe2("kyno_pumpkinhead", {Ingredient("pumpkin", 1), Ingredient("axe", 0)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pumpkinhead_placer",
		min_spacing 	= 0,
		atlas 			= TapBuildingAtlas,
		image			= "kyno_pumpkinhead.tex",
	},
	{"DECOR", "STRUCTURES"}
)
SortAfter("kyno_pumpkinhead", "trophyscale_oversizedveggies", "DECOR")
SortAfter("kyno_pumpkinhead", "endtable", "STRUCTURES")

local KynHallowedPumpkin = AddRecipe2("kyno_adai_hallowedpumpkin", {Ingredient("pumpkin", 2), Ingredient("axe", 0)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_adai_hallowedpumpkin_placer",
		min_spacing 	= 0,
		atlas 			= TapBuildingAtlas2,
		image			= "kyno_adai_hallowedpumpkin.tex",
	},
	{"DECOR", "STRUCTURES"}
)
SortAfter("kyno_adai_hallowedpumpkin", "kyno_pumpkinhead", "DECOR")
SortAfter("kyno_adai_hallowedpumpkin", "kyno_pumpkinhead", "STRUCTURES")

local KynMast1 			= AddRecipe2("kyno_mast_item_01", {Ingredient("driftwood_log", 3), Ingredient("rope", 3), Ingredient("malbatross_feathered_weave", 4)}, TECH.SEAFARING_ONE,
	{
		nounlock 		= false,
		numtogive 		= 1,
		atlas       	= TapBuildingAtlas,
		image			= "kyno_mast_01.tex",
	},
	{"SEAFARING"}
)
SortAfter("kyno_mast_item_01", "mast_malbatross_item", "SEAFARING")

local KynMast2 			= AddRecipe2("kyno_mast_item_02", {Ingredient("driftwood_log", 3), Ingredient("rope", 3), Ingredient("malbatross_feathered_weave", 4)}, TECH.SEAFARING_ONE,
	{
		nounlock 		= false,
		numtogive 		= 1,
		atlas       	= TapBuildingAtlas,
		image			= "kyno_mast_02.tex",
	},
	{"SEAFARING"}
)
SortAfter("kyno_mast_item_02", "kyno_mast_item_01", "SEAFARING")

local KynMast3 			= AddRecipe2("kyno_mast_item_03", {Ingredient("driftwood_log", 3), Ingredient("rope", 3), Ingredient("malbatross_feathered_weave", 4)}, TECH.SEAFARING_ONE,
	{
		nounlock 		= false,
		numtogive 		= 1,
		atlas       	= TapBuildingAtlas,
		image			= "kyno_mast_03.tex",
	},
	{"SEAFARING"}
)
SortAfter("kyno_mast_item_03", "kyno_mast_item_02", "SEAFARING")

local KynMast4 			= AddRecipe2("kyno_mast_item_04", {Ingredient("driftwood_log", 3), Ingredient("rope", 3), Ingredient("malbatross_feathered_weave", 4)}, TECH.SEAFARING_ONE,
	{
		nounlock 		= false,
		numtogive 		= 1,
		atlas       	= TapBuildingAtlas,
		image			= "kyno_mast_04.tex",
	},
	{"SEAFARING"}
)
SortAfter("kyno_mast_item_04", "kyno_mast_item_03", "SEAFARING")

local KynMast5 			= AddRecipe2("kyno_mast_item_05", {Ingredient("driftwood_log", 3), Ingredient("rope", 3), Ingredient("malbatross_feathered_weave", 4)}, TECH.SEAFARING_ONE,
	{
		nounlock 		= false,
		numtogive 		= 1,
		atlas       	= TapBuildingAtlas,
		image			= "kyno_mast_05.tex",
	},
	{"SEAFARING"}
)
SortAfter("kyno_mast_item_05", "kyno_mast_item_04", "SEAFARING")

local KynMast6 			= AddRecipe2("kyno_mast_item_06", {Ingredient("driftwood_log", 3), Ingredient("rope", 3), Ingredient("malbatross_feathered_weave", 4)}, TECH.SEAFARING_ONE,
	{
		nounlock 		= false,
		numtogive 		= 1,
		atlas       	= TapBuildingAtlas,
		image			= "kyno_mast_06.tex",
	},
	{"SEAFARING"}
)
SortAfter("kyno_mast_item_06", "kyno_mast_item_05", "SEAFARING")

local KynMast7 			= AddRecipe2("kyno_mast_item_07", {Ingredient("driftwood_log", 3), Ingredient("rope", 3), Ingredient("malbatross_feathered_weave", 4)}, TECH.SEAFARING_ONE,
	{
		nounlock 		= false,
		numtogive 		= 1,
		atlas       	= TapBuildingAtlas,
		image			= "kyno_mast_07.tex",
	},
	{"SEAFARING"}
)
SortAfter("kyno_mast_item_07", "kyno_mast_item_06", "SEAFARING")

local KynMast8 			= AddRecipe2("kyno_mast_item_08", {Ingredient("driftwood_log", 3), Ingredient("rope", 3), Ingredient("malbatross_feathered_weave", 4)}, TECH.SEAFARING_ONE,
	{
		nounlock 		= false,
		numtogive 		= 1,
		atlas       	= TapBuildingAtlas,
		image			= "kyno_mast_08.tex",
	},
	{"SEAFARING"}
)
SortAfter("kyno_mast_item_08", "kyno_mast_item_07", "SEAFARING")

local KynMast9 			= AddRecipe2("kyno_mast_item_09", {Ingredient("driftwood_log", 3), Ingredient("rope", 3), Ingredient("malbatross_feathered_weave", 4)}, TECH.SEAFARING_ONE,
	{
		nounlock 		= false,
		numtogive 		= 1,
		atlas       	= TapBuildingAtlas,
		image			= "kyno_mast_09.tex",
	},
	{"SEAFARING"}
)
SortAfter("kyno_mast_item_09", "kyno_mast_item_08", "SEAFARING")

--[[
local KynLobster 		= AddRecipe2("kyno_lobster_home", {Ingredient("kyno_lobster_claw", 2, "images/inventoryimages/tap_inventoryimages.xml"), Ingredient("pickaxe", 1), Ingredient("cutstone", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lobster_home_placer",
		min_spacing 	= 0,
		atlas 			= TapBuildingAtlas,
		image			= "kyno_lobsterhouse.tex",
	},
	{"STRUCTURES"}
)
SortAfter("kyno_lobster_home", "rabbithouse", "STRUCTURES")
]]--

local KynStand 			= AddRecipe2("kyno_birdstand", {Ingredient("log", 6), Ingredient("papyrus", 2), Ingredient("seeds", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_birdstand_placer",
		min_spacing 	= 0,
		atlas 			= TapBuildingAtlas,
		image			= "kyno_birdstand.tex",
	},
	{"GARDENING"}
)
SortAfter("kyno_birdstand", "birdcage", "GARDENING")

local KynSprinkler 		= AddRecipe2("kyno_garden_sprinkler", {Ingredient("gears", 3), Ingredient("ice", 15), Ingredient("trinket_6", 3)}, TECH.LOST,
	{
		placer			= "kyno_garden_sprinkler_placer",
		min_spacing 	= 0,
		atlas 			= TapBuildingAtlas,
		image			= "kyno_garden_sprinkler.tex",
	},
	{"GARDENING", "STRUCTURES"}
)
SortAfter("kyno_garden_sprinkler", "firesuppressor", "STRUCTURES")
SortAfter("kyno_garden_sprinkler", "compostwrap", "GARDENING")

local OldFarm1 			= AddRecipe2("slow_farmplot", {Ingredient("cutgrass", 8), Ingredient("poop", 4), Ingredient("log", 4)}, TECH.SCIENCE_ONE,
	{
		placer			= "slow_farmplot_placer",
		min_spacing 	= 0,
		atlas 			= TapDefaultAtlas,
		image			= "slow_farmplot.tex",
	},
	{"GARDENING"}
)

local OldFarm2 			= AddRecipe2("fast_farmplot", {Ingredient("cutgrass", 10), Ingredient("poop", 6), Ingredient("rocks", 4)}, TECH.SCIENCE_ONE,
	{
		placer			= "fast_farmplot_placer",
		min_spacing 	= 0,
		atlas 			= TapDefaultAtlas,
		image			= "fast_farmplot.tex",
	},
	{"GARDENING"}
)

--[[
local TrueSaltLick		= AddRecipe2("kyno_truesaltlick", {Ingredient("boards", 2), Ingredient("saltrock", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_truesaltlick_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_truesaltlick.tex",
	},
	{"STRUCTURES", "RIDING"}
)
SortAfter("kyno_truesaltlick", "saltlick", "STRUCTURES")
SortAfter("kyno_truesaltlick", "saltlick", "RIDING")
]]--

local KynHydroFarm1 	= AddRecipe2("kyno_slow_hydrofarmplot", {Ingredient("kelp", 3), Ingredient("poop", 4), Ingredient("log", 4)}, TECH.SCIENCE_ONE,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_slow_hydrofarmplot_placer",
		min_spacing 	= 0,
		build_distance	= 30,
		atlas 			= TapBuildingAtlas,
		image			= "kyno_slow_hydrofarmplot.tex",
	},
	{"GARDENING"}
)

local KynHydroFarm2 	= AddRecipe2("kyno_fast_hydrofarmplot", {Ingredient("kelp", 6), Ingredient("poop", 6), Ingredient("rocks", 4)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_fast_hydrofarmplot_placer",
		min_spacing 	= 0,
		build_distance	= 30,
		atlas 			= TapBuildingAtlas,
		image			= "kyno_fast_hydrofarmplot.tex",
	},
	{"GARDENING"}
)

local KynRod 			= AddRecipe2("kyno_lightninggoatrod", {Ingredient("lightninggoathorn", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lightninggoatrod_placer",
		min_spacing 	= 0,
		atlas 			= TapBuildingAtlas,
		image			= "kyno_lightninggoatrod.tex",
	},
	{"RAIN", "STRUCTURES"}
)
SortAfter("kyno_lightninggoatrod", "lightning_rod", "STRUCTURES")
SortAfter("kyno_lightninggoatrod", "lightning_rod", "RAIN")

--[[
local KynDummy 			= AddRecipe2("kyno_dummytarget", {Ingredient("boards", 4), Ingredient("rope", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_dummytarget_placer",
		min_spacing 	= 0,
		atlas 			= TapBuildingAtlas,
		image			= "kyno_dummytarget.tex",
	},
	{"STRUCTURES"}
)
SortAfter("kyno_dummytarget", "resurrectionstatue", "STRUCTURES")
]]--

local KynNet 			= AddRecipe2("kyno_boatnet", {Ingredient("silk", 3), Ingredient("rope", 1)}, TECH.SEAFARING_ONE,
	{
		placer			= "kyno_boatnet_placer",
		min_spacing 	= 0,
		atlas 			= TapBuildingAtlas,
		image			= "kyno_boatnet.tex",
	},
	{"SEAFARING"}
)
SortAfter("kyno_boatnet", "winch", "SEAFARING")

local KynTerraformer	= AddRecipe2("kyno_terraformer", {Ingredient("moonrocknugget", 1), Ingredient("cutstone", 3), Ingredient("pitchfork", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_terraformer_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_terraformer.tex",
	},
	{"PROTOTYPERS", "DECOR", "STRUCTURES"}
)
SortAfter("kyno_terraformer", "turfcraftingstation", "PROTOTYPERS")
SortAfter("kyno_terraformer", "turfcraftingstation", "DECOR")
SortAfter("kyno_terraformer", "turfcraftingstation", "STRUCTURES")

--[[
local KynDock           = AddRecipe2("kyno_driftwood_dock_kit", {Ingredient("kyno_driftwood_boards", 4, TapInventoryAtlas), Ingredient("cutstone", 1), Ingredient("stinger", 2), Ingredient("palmcone_scale", 1)}, TECH.LOST,
	{
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "kyno_driftwood_dock_kit.tex",
	},
	{"DECOR", "SEAFARING", "STRUCTURES"}
)
SortAfter("kyno_driftwood_dock_kit", "dock_kit", "DECOR")
SortAfter("kyno_driftwood_dock_kit", "dock_kit", "SEAFARING")
SortAfter("kyno_driftwood_dock_kit", "dock_kit", "STRUCTURES")
]]--

local KynDockPilling    = AddRecipe2("kyno_driftwood_dockposts_item", {Ingredient("driftwood_log", 2)}, TECH.SCIENCE_TWO,
	{
		atlas			= TapInventoryAtlas,
		image			= "kyno_driftwood_dockposts_item.tex",
	},
	{"DECOR", "SEAFARING"}
)
SortAfter("kyno_driftwood_dockposts_item", "dock_woodposts_item", "DECOR")
SortAfter("kyno_driftwood_dockposts_item", "dock_woodposts_item", "SEAFARING")

local KynDriftWall      = AddRecipe2("wall_driftwood_item", {Ingredient("kyno_driftwood_boards", 2, TapInventoryAtlas), Ingredient("rope", 1)}, TECH.SCIENCE_ONE,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_driftwood_item.tex",
	},
	{"DECOR", "STRUCTURES"}
)
SortAfter("wall_driftwood_item", "wall_wood_item", "DECOR")
SortAfter("wall_driftwood_item", "wall_wood_item", "STRUCTURES")

local KynDriftFence     = AddRecipe2("kyno_driftwood_fence_item", {Ingredient("twigs", 3), Ingredient("rope", 1)}, TECH.SCIENCE_ONE,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "kyno_driftwood_fence_item.tex",
	},
	{"DECOR", "STRUCTURES"}
)
SortAfter("kyno_driftwood_fence_item", "fence_item", "DECOR")
SortAfter("kyno_driftwood_fence_item", "fence_item", "STRUCTURES")

local KynDriftGate      = AddRecipe2("kyno_driftwood_gate_item", {Ingredient("kyno_driftwood_boards", 2, TapInventoryAtlas), Ingredient("rope", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 2,
		atlas			= TapInventoryAtlas,
		image			= "kyno_driftwood_gate_item.tex",
	},
	{"DECOR", "STRUCTURES"}
)
SortAfter("kyno_driftwood_gate_item", "fence_gate_item", "DECOR")
SortAfter("kyno_driftwood_gate_item", "fence_gate_item", "STRUCTURES")

local KynDriftChest     = AddRecipe2("kyno_driftwood_chest", {Ingredient("kyno_driftwood_boards", 3, TapInventoryAtlas)}, TECH.SCIENCE_ONE,
	{
		placer			= "kyno_driftwood_chest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_driftwood_chest.tex",
	},
	{"CONTAINERS", "STRUCTURES"}
)
SortAfter("kyno_driftwood_chest", "treasurechest", "CONTAINERS")
SortAfter("kyno_driftwood_chest", "treasurechest", "STRUCTURES")

local KynWardrobe       = AddRecipe2("kyno_driftwood_wardrobe", {Ingredient("kyno_driftwood_boards", 4, TapInventoryAtlas), Ingredient("cutgrass", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_driftwood_wardrobe_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_driftwood_wardrobe.tex",
	},
	{"DECOR"}
)
SortAfter("kyno_driftwood_wardrobe", "wardrobe", "DECOR")

local KynDriftSign1     = AddRecipe2("kyno_driftwood_homesign", {Ingredient("kyno_driftwood_boards", 1, TapInventoryAtlas)}, TECH.SCIENCE_ONE,
	{
		placer			= "kyno_driftwood_homesign_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_driftwood_homesign.tex",
	},
	{"DECOR", "STRUCTURES"}
)
SortAfter("kyno_driftwood_homesign", "homesign", "DECOR")
SortAfter("kyno_driftwood_homesign", "homesign", "STRUCTURES")

local KynDriftSign2     = AddRecipe2("kyno_driftwood_arrowsign", {Ingredient("kyno_driftwood_boards", 1, TapInventoryAtlas)}, TECH.SCIENCE_ONE,
	{
		placer			= "kyno_driftwood_arrowsign_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_driftwood_arrowsign.tex",
	},
	{"DECOR", "STRUCTURES"}
)
SortAfter("kyno_driftwood_arrowsign", "arrowsign_post", "DECOR")
SortAfter("kyno_driftwood_arrowsign", "arrowsign_post", "STRUCTURES")

local KynDriftPigHouse  = AddRecipe2("kyno_driftwood_pighouse", {Ingredient("kyno_driftwood_boards", 4, TapInventoryAtlas), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_driftwood_pighouse_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_driftwood_pighouse.tex",
	},
	{"STRUCTURES"}
)
SortAfter("kyno_driftwood_pighouse", "pighouse", "STRUCTURES")

local KynWinterometer   = AddRecipe2("kyno_driftwood_winterometer", {Ingredient("kyno_driftwood_boards", 2, TapInventoryAtlas), Ingredient("goldnugget", 2)}, TECH.SCIENCE_ONE,
	{
		placer			= "kyno_driftwood_winterometer_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_driftwood_winterometer.tex",
	},
	{"STRUCTURES", "WINTER", "SUMMER"}
)
SortAfter("kyno_driftwood_winterometer", "winterometer", "STRUCTURES")
SortAfter("kyno_driftwood_winterometer", "winterometer", "WINTER")
SortAfter("kyno_driftwood_winterometer", "winterometer", "SUMMER")

local KynRainometer     = AddRecipe2("kyno_driftwood_rainometer", {Ingredient("kyno_driftwood_boards", 2, TapInventoryAtlas), Ingredient("goldnugget", 2), Ingredient("rope", 2)}, TECH.SCIENCE_ONE,
	{
		placer			= "kyno_driftwood_rainometer_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_driftwood_rainometer.tex",
	},
	{"STRUCTURES", "SUMMER", "RAIN"}
)
SortAfter("kyno_driftwood_rainometer", "rainometer", "STRUCTURES")
SortAfter("kyno_driftwood_rainometer", "rainometer", "SUMMER")
SortAfter("kyno_driftwood_rainometer", "rainometer", "RAIN")

-- Shipwrecked Category.
AddRecipe2("kyno_sw_prototyper", {Ingredient("boards", 2), Ingredient("pondfish", 2)}, TECH.SCIENCE_TWO,
	{
		placer 			= "kyno_sw_prototyper_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sw_prototyper.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_wormhole_sw", {Ingredient("turf_beach", 1, TapInventoryAtlas), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wormhole_sw_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wormhole_sw.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_rock_limpet", {Ingredient("rocks", 2), Ingredient("nitre", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock_limpet_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_rock_limpet.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_vinebush", {Ingredient("dug_marsh_bush", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vinebush_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_dug_vinebush.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_snakeden", {Ingredient("dug_marsh_bush", 1), Ingredient("monstermeat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_snakeden_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_snakeden.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_bambootree", {Ingredient("dug_sapling", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bambootree_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_dug_bambootree.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_grass_green", {Ingredient("dug_grass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grass_green_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_dug_grassgreen.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("jungletreeseed", {Ingredient("pinecone", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive       = 2,
		atlas           = TapBuildingAtlas,
		image           = "kyno_jungletreeseed.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_coconut", {Ingredient("acorn", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 2,
		atlas           = TapBuildingAtlas,
		image           = "kyno_coconut.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_sweet_potato_planted", {Ingredient("potato", 1, TapBuildingAtlas2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sweet_potato_planted_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_sweetpotato.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_sandhill", {Ingredient("turf_beach", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sandhill_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_sandpile.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_crabhole", {Ingredient("rabbit", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_crabhole_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_crabhole.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_shiftingsands", {Ingredient("turf_beach", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shiftingsands_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_shiftingsands.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("seashell", {Ingredient("flint", 1), Ingredient("nitre", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive       = 1,
		atlas           = TapBuildingAtlas,
		image           = "kyno_seashell.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_surfboard", {Ingredient("boards", 1), Ingredient("seashell", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_surfboard_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_surfboard.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_parrot_boat", {Ingredient("boards", 1), Ingredient("robin", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_parrot_boat_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_parrot_boat.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_boat_empty", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_boat_empty_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_boat_empty.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_shipmast", {Ingredient("boards", 1), Ingredient("robin", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shipmast_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_shipmast.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_debris_1", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_debris_1_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_debris_1.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_debris_2", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_debris_2_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_debris_2.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_debris_3", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_debris_3_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_debris_3.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_crate", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_crate_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_crate.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_living_jungletree", {Ingredient("livinglog", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_living_jungletree_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_living_jungletree.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_magmarock", {Ingredient("rocks", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_magmarock_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_magmarock.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_magmarock_gold", {Ingredient("rocks", 2), Ingredient("flint", 2), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_magmarock_gold_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_magmarock_gold.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_primeape_barrel", {Ingredient("cave_banana", 2), Ingredient("poop", 2), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_primeape_barrel_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_primeapehouse.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_sharkittenden", {Ingredient("turf_beach", 4, TapInventoryAtlas), Ingredient("spoiled_fish", 4), Ingredient("spoiled_fish_small", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sharkittenden_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_sharkittenden.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_mermhut", {Ingredient("boards", 2), Ingredient("cutstone", 1), Ingredient("pondfish", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mermhut_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_mermhut.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_fishermermhut", {Ingredient("boards", 2), Ingredient("cutstone", 1), Ingredient("pondfish", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_fishermermhut_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_fishermermhut.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_tidalpool_small", {Ingredient("eel", 2), Ingredient("turf_mud", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tidalpool_small_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_tidalpool.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_tidalpool_medium", {Ingredient("eel", 3), Ingredient("turf_mud", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tidalpool_medium_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_tidalpool.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_tidalpool_big", {Ingredient("eel", 4), Ingredient("turf_mud", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tidalpool_big_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_tidalpool.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_poisonhole", {Ingredient("poop", 2), Ingredient("spoiled_food", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_poisonhole_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_poisonhole.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_slotmachine", {Ingredient("boards", 2), Ingredient("goldnugget", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_slotmachine_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_slotmachine.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_wildbore_house", {Ingredient("boards", 2), Ingredient("twigs", 5), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wildbore_house_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_wildborehouse.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_wildbore_head", {Ingredient("pigskin", 2), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wildbore_head_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_wildbore_head.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_chiminea", {Ingredient("cutstone", 2), Ingredient("log", 2), Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chiminea_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_chiminea.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_obsidian_firepit", {Ingredient("rocks", 12), Ingredient("redgem", 2), Ingredient("log", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_obsidian_firepit_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_obsidianfirepit.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_palmleaf_hut", {Ingredient("cutgrass", 3), Ingredient("rope", 3), Ingredient("twigs", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_palmleaf_hut_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_palmleafhut.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_doydoy_nest",{Ingredient("twigs", 8), Ingredient("goose_feather", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_doydoy_nest_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_doydoynest.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_doydoy_nest2",{Ingredient("twigs", 8), Ingredient("goose_feather", 2), Ingredient("tallbirdegg", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_doydoy_nest_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_doydoynest2.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_icemaker", {Ingredient("heatrock", 1), Ingredient("twigs", 3), Ingredient("transistor", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_icemaker_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_icemaker.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_sandcastle", { beachingredient2, Ingredient("cutgrass", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sandcastle_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_sandcastle.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_teleporter_sw", {Ingredient("boards", 1), Ingredient("cutgrass", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_teleporter_sw_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_maxwellportal_sw.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_piratihatitator", {Ingredient("tophat", 1), Ingredient("robin", 1), Ingredient("boards", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_piratihatitator_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_piratihatitator.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_buriedtreasure", {Ingredient("boneshard", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_buriedtreasure_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_buriedtreasure.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_geyser", {Ingredient("charcoal", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_geyser_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_krissure.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_geyser_active", {Ingredient("charcoal", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_geyser_active_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_krissure2.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_lavapool", {Ingredient("charcoal", 2), Ingredient("ash", 2), Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lavapool_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_lavapool.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_dragoonegg", {Ingredient("rocks", 2), Ingredient("redgem", 1), Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_dragoonegg_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_dragoonegg.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_dragoonspit", {Ingredient("charcoal", 1), Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_dragoonspit_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_dragoonspit.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_sandbagsmall_item", {Ingredient("turf_beach", 2, TapInventoryAtlas), Ingredient("rope", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive       = 6,
		atlas           = TapBuildingAtlas,
		image           = "kyno_sandbags.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("wall_limestone_item", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive 		= 8,
		atlas           = TapInventoryAtlas,
		image           = "wall_limestone_item.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("wall_enforcedlimestone_land_item", {Ingredient("cutstone", 2), Ingredient("kelp", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas           = TapInventoryAtlas,
		image           = "wall_enforcedlimestone_land_item.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_woodlegs_cage", {Ingredient("log", 2), Ingredient("rope", 2), Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_woodlegs_cage_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_woodlegscage.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_seal", {Ingredient("meat", 2), Ingredient("reviver", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_seal_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_seal.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_tartrap", {Ingredient("charcoal", 2), Ingredient("ash", 2), Ingredient("boneshard", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tartrap_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_tartrap.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_volcanostairs", {Ingredient("cutstone", 1), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_volcanostairs_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_volcanostairs.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_dragoonden", {Ingredient("cutstone", 1), Ingredient("charcoal", 2), Ingredient("redgem", 1)},  TECH.SCIENCE_TWO,
	{
		placer			= "kyno_dragoonden_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_dragoonden.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_elephantcactus_active", {Ingredient("dug_marsh_bush", 1), Ingredient("houndstooth", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_elephantcactus_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_dug_elephantcactus.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_elephantcactus", {Ingredient("dug_marsh_bush", 1), Ingredient("houndstooth", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_elephantcactus_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_dug_elephantcactus.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_fakecoffeebush", {Ingredient("ash", 1), Ingredient("dug_berrybush", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_fakecoffeebush_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_dug_fakecoffeebush.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_rock_obsidian", {Ingredient("rocks", 2), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock_obsidian_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_rock_obsidian.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_rock_charcoal", {Ingredient("charcoal", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock_charcoal_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_rock_charcoal.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_volcano_shrub", {Ingredient("twigs", 2), Ingredient("ash", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_volcano_shrub_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_volcanotree.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_altar_pillar", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_altar_pillar_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas,
		image           = "kyno_altar_pillar.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_volcano_altar", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 3), Ingredient("ash", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_volcano_altar_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_volcano_altar.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_workbench", {Ingredient("cutstone", 1), Ingredient("boards", 2), Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_workbench_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_workbench.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_bioluminescence", {Ingredient("fireflies", 1), Ingredient("blue_cap", 1)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_bioluminescence_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_waterfireflies.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("mangrovetree_short", {Ingredient("log", 4), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "mangrovetree_short_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_mangrovetree.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_wreck_1", {Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_wreck_1_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_wreck_1.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_wreck_2", {Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_wreck_2_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_wreck_2.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_wreck_3", {Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_wreck_3_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_wreck_3.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_wreck_4", {Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_wreck_4_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_wreck_4.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_seaweed", {Ingredient("kelp", 1)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_seaweed_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_seaweed.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_brain_rock", {Ingredient("rocks", 3), Ingredient("meat", 4), Ingredient(_G.CHARACTER_INGREDIENT.SANITY, 50)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_brain_rock_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_rock_brain.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("wall_enforcedlimestone_item", {Ingredient("cutstone", 2), Ingredient("kelp", 2)}, TECH.SCIENCE_TWO,
	{
	--	testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		numtogive 		= 8,
	--	build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_wall_enforcedlimestone.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_rock_coral_1", {Ingredient("rocks", 4), Ingredient("flint", 4)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_rock_coral_1_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_rock_coral1.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_rock_coral_2", {Ingredient("rocks", 4), Ingredient("flint", 4)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_rock_coral_2_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_rock_coral2.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_rock_coral_3", {Ingredient("rocks", 4), Ingredient("flint", 4)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_rock_coral_3_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_rock_coral3.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_redbarrel", {Ingredient("boards", 2), Ingredient("gunpowder", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_redbarrel_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_redbarrel.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_bermudatriangle", {Ingredient("nightmarefuel", 4), Ingredient("transistor", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_bermudatriangle_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_bermudatriangle.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_ballphinhouse", {Ingredient("cutstone", 3), Ingredient("fishmeat_small", 4), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_ballphinhouse_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_ballphinhouse.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_octopusking", {Ingredient("cutstone", 5), Ingredient("fishmeat", 10), Ingredient("goldnugget", 10)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_octopusking_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_octopusking.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_luggagechest", {Ingredient("boards", 3)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_luggagechest_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_luggagechest.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_fishinhole", {Ingredient("pondfish", 2), Ingredient("eel", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_fishinhole_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_fishinhole.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_buoy", {Ingredient("lantern", 1), Ingredient("twigs", 4), Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_buoy_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_buoy.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_sea_chiminea", {Ingredient("cutstone", 2), Ingredient("log", 2), Ingredient("transistor", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_sea_chiminea_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_seachiminea.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_seayard", {Ingredient("log", 4), Ingredient("cutstone", 6), Ingredient("kelp", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_seayard_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_seayard.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_extractor", {Ingredient("boards", 2), Ingredient("cutstone", 2), Ingredient("transistor", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_extractor_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_tarextractor.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_musselfarm", {Ingredient("boards", 1), Ingredient("twigs", 2), Ingredient("cutgrass", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_musselfarm_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_musselstick.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_fishfarm", {Ingredient("silk", 6), Ingredient("rope", 3), Ingredient("pondfish", 4)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_fishfarm_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_fishfarm.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_slow_hydrofarmmeat", {Ingredient("kelp", 4), Ingredient("poop", 4), Ingredient("rocks", 4)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_slow_hydrofarmmeat_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_slow_hydrofarmmeat.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_fast_hydrofarmmeat", {Ingredient("kelp", 10), Ingredient("poop", 6), Ingredient("rocks", 4)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_fast_hydrofarmmeat_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_fast_hydrofarmmeat.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_sealab", {Ingredient("cutstone", 4), Ingredient("transistor", 2), Ingredient("kelp", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_sealab_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_sealab.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_kraken", {Ingredient("fishmeat", 4), Ingredient("tentaclespots", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_kraken_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_kraken.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_kraken_tentacle", {Ingredient("fishmeat", 2), Ingredient("tentaclespots", 1)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_kraken_tentacle_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_kraken_tentacle.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_krakenchest", {Ingredient("boards", 4), Ingredient("boneshard", 6)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_krakenchest_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_krakenchest.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_waterchest", {Ingredient("boards", 3), Ingredient("kelp", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_waterchest_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_waterchest.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_watercrate", {Ingredient("boards", 2), Ingredient("kelp", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_watercrate_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_watercrate.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_tarpit", {Ingredient("charcoal", 2), Ingredient("ash", 2), Ingredient("boneshard", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_tarpit_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_tarpit.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_whalebubbles", {Ingredient("ice", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_whalebubbles_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_whalebubbles.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_volcano", {Ingredient("rocks", 200), Ingredient("redgem", 10), Ingredient("oceanfish_small_8_inv", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_volcano_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_volcano.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_jellyfish", {Ingredient("fishmeat_small", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_jellyfish_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas,
		image			= "kyno_jellyfish.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_jellyfish_rainbow", {Ingredient("fishmeat_small", 1), Ingredient("transistor", 1), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_jellyfish_rainbow_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas,
		image			= "kyno_jellyfish_rainbow.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_whale_blue", {Ingredient("fishmeat", 4), Ingredient("reviver", 1)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_whale_blue_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_whale_blue.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_whale_white", {Ingredient("fishmeat", 4), Ingredient("reviver", 1)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_whale_white_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_whale_white.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_wilbur_sleeping", {Ingredient("cave_banana", 2), Ingredient("reviver", 1), Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_wilbur_sleeping_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wilbur_sleeping.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_knightboat", {Ingredient("gears", 2), Ingredient("boat_item", 1)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_knightboat_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas,
		image			= "kyno_knightboat.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_bishopboat", {Ingredient("gears", 2), Ingredient("boat_item", 1), Ingredient("purplegem", 1)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_bishopboat_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bishopboat.tex",
	},
	{"TAP_SHIPWRECKED"}
)

AddRecipe2("kyno_rookboat", {Ingredient("gears", 2), Ingredient("boat_item", 1)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_rookboat_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rookboat.tex",
	},
	{"TAP_SHIPWRECKED"}
)

-- Hamlet Category.
AddRecipe2("kyno_ham_prototyper", {Ingredient("boards", 2), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ham_prototyper_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ham_prototyper.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_wormhole_ham", {Ingredient("cutstone", 1), Ingredient("pigskin", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wormhole_ham_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wormhole_ham.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_lamppost", {Ingredient("cutstone", 1), Ingredient("lantern", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamppost_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lamppost.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pighouse_farm", {Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pighouse_farm_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_farmhouse.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pighouse_city", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pighouse_city_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pighouse_city.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pighouse_city1", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pighouse_city1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pighouse_city1.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pighouse_city2", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pighouse_city2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pighouse_city4.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pighouse_city3", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pighouse_city3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pighouse_city5.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pighouse_city4", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pighouse_city4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pighouse_city2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pighouse_city5", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pighouse_city5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pighouse_city3.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_deli", {Ingredient("boards", 4), Ingredient("honeyham", 1), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_deli_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_deli.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_general", {Ingredient("boards", 4), Ingredient("axe", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_general_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_general.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_spa", {Ingredient("boards", 4), Ingredient("bandage", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_spa_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_spa.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_produce", {Ingredient("boards", 4), Ingredient("eggplant", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_produce_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_produce.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_flower", {Ingredient("boards", 4), Ingredient("petals", 12), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_flower_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_florist.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_antiquities", {Ingredient("boards", 4), Ingredient("hammer", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_antiquities_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_antiquities.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_arcane", {Ingredient("boards", 4), Ingredient("nightmarefuel", 2), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_arcane_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_arcane.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_weapons", {Ingredient("boards", 4), Ingredient("spear", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_weapons_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_weapons.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_hatshop", {Ingredient("boards", 4), Ingredient("tophat", 2), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_hatshop_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_hats.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_bank", {Ingredient("cutstone", 3), Ingredient("goldnugget", 2), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_bank_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_bank.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_tinker", {Ingredient("cutstone", 3), Ingredient("boards", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_tinker_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_tinker.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_academy", {Ingredient("cutstone", 3), Ingredient("papyrus", 2), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_academy_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigshop_academy.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_cityhall", {Ingredient("boards", 3), Ingredient("goldnugget", 4), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_cityhall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_cityhall.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigshop_mycityhall", {Ingredient("boards", 3), Ingredient("goldnugget", 4), Ingredient("silk", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigshop_mycityhall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_pigshop_cityhall.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigpalace", {Ingredient("marble", 2), Ingredient("goldnugget", 2), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigpalace_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigpalace.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigpalace2", {Ingredient("marble", 2), Ingredient("goldnugget", 2), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigpalace2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigpalace.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_playerhouse", {Ingredient("boards", 2), Ingredient("cutstone", 1), Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_playerhouse_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_playerhouse.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_playerhouse1", {Ingredient("boards", 2), Ingredient("cutstone", 1), Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_playerhouse1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_playerhouse_cottage.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_playerhouse2", {Ingredient("boards", 2), Ingredient("cutstone", 1), Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_playerhouse2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_playerhouse_tudor.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_playerhouse3", {Ingredient("boards", 2), Ingredient("cutstone", 1), Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_playerhouse3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_playerhouse_gothic.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_playerhouse4", {Ingredient("boards", 2), Ingredient("cutstone", 1), Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_playerhouse4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_playerhouse_brick.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_playerhouse5", {Ingredient("boards", 2), Ingredient("cutstone", 1), Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_playerhouse5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_playerhouse_turret.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_playerhouse6", {Ingredient("boards", 2), Ingredient("cutstone", 1), Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_playerhouse6_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_playerhouse_manor.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_playerhouse7", {Ingredient("boards", 2), Ingredient("cutstone", 1), Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_playerhouse7_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_playerhouse_villa.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigtower", {Ingredient("cutstone", 1), Ingredient("spear", 1), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigtower_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigtower.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigtower1", {Ingredient("cutstone", 1), Ingredient("spear", 1), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigtower1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigtower.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigtower2", {Ingredient("cutstone", 1), Ingredient("spear", 1), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigtower2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigtower.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigtower3", {Ingredient("cutstone", 1), Ingredient("spear", 1), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigtower3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigtower.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigtower4", {Ingredient("cutstone", 1), Ingredient("spear", 1), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigtower4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigtower.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_royalguard", {Ingredient("meat", 1), Ingredient("armorwood", 1), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_royalguard_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_royalguard.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_royalguard1", {Ingredient("meat", 1), Ingredient("armorwood", 1), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_royalguard1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_royalguard1.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_royalguard2", {Ingredient("meat", 1), Ingredient("armorwood", 1), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_royalguard2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_royalguard2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_royalguard3", {Ingredient("meat", 1), Ingredient("armorwood", 1), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_royalguard3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_royalguard3.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_royalguard4", {Ingredient("meat", 1), Ingredient("armorwood", 1), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_royalguard4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_royalguard4.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_cavecleft", {Ingredient("rocks", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_cavecleft_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_cavecleft.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigruinssmall", {Ingredient("cutstone", 1), Ingredient("cutgrass", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigruinssmall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigruinssmall.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigruins1", {Ingredient("cutstone", 1), Ingredient("cutgrass", 3), Ingredient("pigskin", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigruins1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigruins1.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigruins2", {Ingredient("cutstone", 1), Ingredient("cutgrass", 3), Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigruins2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigruins2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigruins3", {Ingredient("cutstone", 1), Ingredient("cutgrass", 3), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigruins3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigruins3.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pigruins4", {Ingredient("cutstone", 1), Ingredient("cutgrass", 3), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigruins4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigruins4.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_manthill", {Ingredient("twigs", 4), Ingredient("cutgrass", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_manthill_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_anthill.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_mantqueenhill", {Ingredient("cutstone", 1), Ingredient("rocks", 3), Ingredient("redgem", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mantqueenhill_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_antqueenhill.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_antthrone", {Ingredient("rocks", 4), Ingredient("nitre", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_antthrone_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_antthrone.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ant_queen", {Ingredient("rocks", 4), Ingredient("nitre", 4), Ingredient("reviver", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ant_queen_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_antqueen.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_antcombhome", {Ingredient("honey", 2), Ingredient("honeycomb", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_antcombhome_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_anthouse.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_antchest", {Ingredient("honeycomb", 1), Ingredient("honey", 6), Ingredient("boards", 2)}, TECH.LOST,
	{
		placer			= "kyno_antchest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_antchest_honey.tex",
	},
	{"TAP_HAMLET", "COOKING", "CONTAINERS", "STRUCTURES"}
)
SortAfter("kyno_antchest", "saltbox", "CONTAINERS")
SortAfter("kyno_antchest", "saltbox", "STRUCTURES")
SortAfter("kyno_antchest", "saltbox", "COOKING")

AddRecipe2("kyno_antcache", {Ingredient("boards", 2), Ingredient("honey", 2), Ingredient("honeycomb", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_antcache_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_antcache.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_aporkalypse_calendar", {Ingredient("cutstone", 1), Ingredient("transistor", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_aporkalypse_calendar_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_calendar.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_smashingpot", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_smashingpot_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_smashingpot.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("wall_pig_ruins_item", {Ingredient("thulecite", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_pig_ruins_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_rock_artichoke", {Ingredient("rocks", 2), Ingredient("nitre", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock_artichoke_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_artichoke.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ruins_head", {Ingredient("rocks", 2), Ingredient("nitre", 2), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruins_head_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruins_gianthead.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ruins_pigstatue", {Ingredient("rocks", 2), Ingredient("nitre", 2), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruins_pigstatue_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruins_pigstatue.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ruins_antstatue", {Ingredient("rocks", 2), Ingredient("nitre", 2), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruins_antstatue_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruins_antstatue.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ruins_idolstatue", {Ingredient("rocks", 2), Ingredient("nitre", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruins_idolstatue_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruins_idolstatue.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ruins_plaquestatue", {Ingredient("rocks", 2), Ingredient("nitre", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruins_plaquestatue_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruins_plaquestatue.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ruins_trufflestatue", {Ingredient("rocks", 2), Ingredient("nitre", 2), Ingredient("purplegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruins_trufflestatue_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruins_trufflestatue.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ruins_sowstatue", {Ingredient("rocks", 2), Ingredient("nitre", 2), Ingredient("bluegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruins_sowstatue_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruins_sowstatue.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_brazier", {Ingredient("cutstone", 1), Ingredient("charcoal", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_brazier_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_brazier.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_wishingwell", {Ingredient("cutstone", 1), Ingredient("ice", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wishingwell_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wishingwell.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_endwell", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_endwell_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_endwell.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_strikingstatue", {Ingredient("cutstone", 1), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_strikingstatue_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_dartstatue.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_speartrap", {Ingredient("spear", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_speartrap_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_speartrap.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pillar_front", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_front_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruinspillar.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pillar_front_blue", {Ingredient("cutstone", 1), Ingredient("cutlichen", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_front_blue_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruinspillarblue.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_teeteringpillar", {Ingredient("cutstone", 1), Ingredient("rocks", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_teeteringpillar_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_teeteringpillar.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pugaliskfountain", {Ingredient("cutstone", 2), Ingredient("ice", 4), Ingredient("rocks", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pugaliskfountain_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_fountainyouth.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_trapdoor", {Ingredient("cutstone", 1), Ingredient("rocks", 1), Ingredient("flint", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_trapdoor_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_trapdoor.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_pugaliskcorpse", {Ingredient("boneshard", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pugaliskcorpse_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_snakebody.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_teleporter_hamlet", {Ingredient("cutstone", 1), Ingredient("transistor", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_teleporter_hamlet_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_maxwellportal_ham.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_exoticflower", {Ingredient("petals", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_exoticflower_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_exoticflower.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_artificial_exoticflower", {Ingredient("petals", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_artificial_exoticflower_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_exoticflower2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_gardenbox_exotic1", {Ingredient("petals", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_exotic1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_exotic1.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_gardenbox_exotic2", {Ingredient("petals", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_exotic2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_exotic2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_gardenbox_exotic3", {Ingredient("petals", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_exotic3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_exotic3.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_gardenbox_exotic4", {Ingredient("petals", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_exotic4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_exotic4.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_gardenbox_exotic5", {Ingredient("petals", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_exotic5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_exotic5.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_rock_eruption", {Ingredient("rocks", 3), Ingredient("nitre", 2), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock_eruption_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_eruption.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_rockplug", {Ingredient("rocks", 3), Ingredient("nitre", 2), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rockplug_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rockplug.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_rock_batboulder", {Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock_batboulder_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_batboulder.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_antrock", {Ingredient("rocks", 2), Ingredient("nitre", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_antrock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_antrock.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_balloon_wreck", {Ingredient("silk", 1), Ingredient("rope", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_balloon_wreck_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_balloon.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_basket_wreck", {Ingredient("boards", 1), Ingredient("rope", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_basket_wreck_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_basket.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_flags_wreck", {Ingredient("papyrus", 1), Ingredient("rope", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flags_wreck_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flags.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_sandbag_wreck", { beachingredient1, Ingredient("rope", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sandbag_wreck_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bagsand.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_suitcase_wreck", {Ingredient("boards", 1), Ingredient("silk", 1), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_suitcase_wreck_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_suitcase.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_trunk_wreck", {Ingredient("boards", 1), Ingredient("silk", 1), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_trunk_wreck_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_trunk.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_grub", {Ingredient("reviver", 1), Ingredient("slurtle_shellpieces", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grub_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_grub.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_flytrap", {Ingredient("plantmeat", 2), Ingredient("houndstooth", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flytrap_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flytrap.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_chamaleon", {Ingredient("meat", 2), Ingredient("reviver", 1), Ingredient("dragon_scales", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chamaleon_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_chamaleon.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_dungball", {Ingredient("poop", 1), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_dungball_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_dungball.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_dungpile", {Ingredient("poop", 1), Ingredient("twigs", 2), Ingredient("cutgrass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_dungpile_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_dungpile.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_gnatmound", {Ingredient("rocks", 2), Ingredient("nitre", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gnatmound_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gnatmound.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_mandrakehouse", {Ingredient("mandrake", 1), Ingredient("boards", 2), Ingredient("cutgrass", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mandrakehouse_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_mandrakehouse.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_bandittreasure", {Ingredient("feather_crow", 1), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bandittreasure_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_banditcamp.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_sparkpool", {Ingredient("ice", 3), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sparkpool_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sparklingpool.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_bathole", {Ingredient("batwing", 1), Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bathole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bathole.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_batpit", {Ingredient("batwing", 1), Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_batpit_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_batpit.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_stoneslab", {Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stoneslab_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_slab.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_thundernest", {Ingredient("redgem", 1), Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_thundernest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_thundernest.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_rocnest", {Ingredient("cutgrass", 3), Ingredient("twigs", 3), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rocnest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocnest.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_house", {Ingredient("cutstone", 1), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_house_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rochouse.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_rusty_lamp", {Ingredient("lantern", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_rusty_lamp_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocrustylamp.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_tree1", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_tree1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_roctree1.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_tree2", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_tree2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_roctree2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_bush", {Ingredient("cutgrass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_bush_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocbush.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_trunk", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_trunk_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_roctrunk.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_branch1", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_branch1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocbranch1.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_branch2", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_branch2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocbranch2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_debris1", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_debris1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocstick1.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_debris2", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_debris2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocstick2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_debris3", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_debris3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocstick3.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_debris4", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_debris4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocstick4.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_egg1", {Ingredient("rocks", 1)},
 TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_egg1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocshell1.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_egg2", {Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_egg2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocshell2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_egg3", {Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_egg3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocshell3.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nest_egg4", {Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nest_egg4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocshell4.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ironhulk_spider", {Ingredient("gears", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ironhulk_spider_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hulkspider.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ironhulk_claw", {Ingredient("gears", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ironhulk_claw_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hulkclaw.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ironhulk_leg", {Ingredient("gears", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ironhulk_leg_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hulkleg.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ironhulk_head", {Ingredient("gears", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ironhulk_head_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hulkhead.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_ironhulk_large", {Ingredient("gears", 2), Ingredient("transistor", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ironhulk_large_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hulklarge.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_bramble1", {Ingredient("dug_marsh_bush", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bramble1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bramble1.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_bramble2", {Ingredient("dug_marsh_bush", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bramble2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bramble2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_bramble3", {Ingredient("dug_marsh_bush", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bramble3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bramble3.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_bramblecore", {Ingredient("dug_marsh_bush", 1), Ingredient("petals", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bramblecore_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bramblecore.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_aloe_planted", {Ingredient("corn", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_aloe_planted_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_aloed.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_asparagus_planted", {Ingredient("asparagus", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_asparagus_planted_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_asparagos.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_radish_planted", {Ingredient("pepper", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_radish_planted_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_radish.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_leafystalk", {Ingredient("log", 4), Ingredient("succulent_picked", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_leafystalk_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_leafystalk.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_vine1", {Ingredient("rope", 1), Ingredient("plantmeat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vineone_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_vine1.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_vine2", {Ingredient("rope", 1), Ingredient("cutgrass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vinetwo_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_vine2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_vine3", {Ingredient("rope", 1), Ingredient("cutgrass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vinethree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_vine3.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_cocoon", {Ingredient("lightbulb", 1), Ingredient("ice", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_cocoon_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_cocoon.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_junglefern", {Ingredient("foliage", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_junglefern_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_junglefern.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_magicflower", {Ingredient("petals", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_magicflower_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_magicflower.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_nettleplant", {Ingredient("cutlichen", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nettleplant_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_nettleplant.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_tallgrass", {Ingredient("dug_grass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tallgrass_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_dug_grassgreen.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_tallgrass_yellow", {Ingredient("dug_grass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tallgrass_yellow_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "dug_grass.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("tubertree_short", {Ingredient("log", 3), Ingredient("acorn", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tubertree_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_tubertree.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("tubertreebloom_short", {Ingredient("log", 3), Ingredient("petals", 3), Ingredient("acorn", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tubertreebloom_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_tubertreebloom.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_clawtree_sapling", {Ingredient("pinecone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_clawtree_sapling_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_clawtree_sapling.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("teatree_nut", {Ingredient("acorn", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 2,
		atlas			= TapInventoryAtlas,
		image			= "teatree_nut.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("burr", {Ingredient("twiggy_nut", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 2,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burr.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("rainforesttree_bloom_short", {Ingredient("burr", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "rainforesttree_bloom_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_treebloom.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("rainforesttree_rot_short", {Ingredient("burr", 1, TapInventoryAtlas), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "rainforesttree_rot_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_treerot.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("cocoonedtree_short", {Ingredient("burr", 1, TapInventoryAtlas), Ingredient("silk", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "cocoonedtree_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_cocoonedtree.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("spidermonkeytree_short", {Ingredient("burr", 1, TapInventoryAtlas), Ingredient("silk", 1), Ingredient("spidergland", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "spidermonkeytree_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_spidermonkeytree.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_corkchest", {Ingredient("boards", 2), Ingredient("rope", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_corkchest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_corkchest.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_rootchest", {Ingredient("boards", 3), Ingredient("nightmarefuel", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rootchest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rootchest.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_truerootchest", {Ingredient("boards", 3), Ingredient("livinglog", 3), Ingredient("nightmarefuel", 3)}, TECH.MAGIC_THREE,
	{
		placer			= "kyno_rootchest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rootchest.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_hogusporkusator", {Ingredient("boards", 4), Ingredient("pigskin", 4), Ingredient("feather_robin_winter", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_hogusporkusator_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hogusporkusator.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_sprinkler", {Ingredient("transistor", 1), Ingredient("gears", 1), Ingredient("ice", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sprinkler_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sprinkler.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_smelter", {Ingredient("cutstone", 1), Ingredient("boards", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_smelter_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_smelter.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_basefan", {Ingredient("transistor", 1), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_basefan_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_basefan.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_thumper", {Ingredient("gears", 3), Ingredient("flint", 10), Ingredient("hammer", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_thumper_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_thumper.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_telipad", {Ingredient("gears", 3), Ingredient("transistor", 2), Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_telipad_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_telipad.tex",
	},
	{"TAP_HAMLET"}
)

--[[
AddRecipe2("kyno_telebrella", {Ingredient("gears", 1), Ingredient("transistor", 2), Ingredient("umbrella", 1)}, TECH.SCIENCE_TWO,
	{
		atlas			= TapInventoryAtlas,
		image			= "kyno_telebrella.tex",
	},
	{"TAP_HAMLET"}
)
]]--

AddRecipe2("kyno_lawnornament_1", {Ingredient("cutgrass", 1), Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lawnornament_1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lawnornament_1.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_lawnornament_2", {Ingredient("cutgrass", 1), Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lawnornament_2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lawnornament_2.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_lawnornament_3", {Ingredient("cutgrass", 1), Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lawnornament_3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lawnornament_3.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_lawnornament_4", {Ingredient("cutgrass", 1), Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lawnornament_4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lawnornament_4.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_lawnornament_5", {Ingredient("cutgrass", 1), Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lawnornament_5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lawnornament_5.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_lawnornament_6", {Ingredient("dug_berrybush", 1), Ingredient("marble", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lawnornament_6_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lawnornament_6.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_lawnornament_7", {Ingredient("dug_berrybush_juicy", 1), Ingredient("marble", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lawnornament_7_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lawnornament_7.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_lawnlegacy", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lawnlegacy_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lawnlegacy.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_topiary_1", {Ingredient("cutgrass", 1), Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_topiary_1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigtopiary.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_topiary_2", {Ingredient("cutgrass", 1), Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_topiary_2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_werepigtopiary.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_topiary_3", {Ingredient("cutgrass", 1), Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_topiary_3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_beefalotopiary.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_topiary_4", {Ingredient("cutgrass", 1), Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_topiary_4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigkingtopiary.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_block_item", {Ingredient("wall_hay_item", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 6,
		atlas			= TapInventoryAtlas,
		image			= "hedge_block_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_block_aged_item", {Ingredient("wall_hay_item", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 6,
		atlas			= TapInventoryAtlas,
		image			= "hedge_block_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_cone_item", {Ingredient("wall_hay_item", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 6,
		atlas			= TapInventoryAtlas,
		image			= "hedge_cone_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_cone_aged_item", {Ingredient("wall_hay_item", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 6,
		atlas			= TapInventoryAtlas,
		image			= "hedge_cone_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_layered_item", {Ingredient("wall_hay_item", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 6,
		atlas			= TapInventoryAtlas,
		image			= "hedge_layered_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_layered_aged_item", {Ingredient("wall_hay_item", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 6,
		atlas			= TapInventoryAtlas,
		image			= "hedge_layered_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_block_pink_item", {Ingredient("foliage", 1), Ingredient("hedge_block_item", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "hedge_block_pink_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_block_pink_aged_item", {Ingredient("foliage", 2), Ingredient("hedge_block_aged_item", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "hedge_block_pink_aged_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_cone_pink_item", {Ingredient("foliage", 1), Ingredient("hedge_cone_item", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "hedge_cone_pink_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_cone_pink_aged_item", {Ingredient("foliage", 2), Ingredient("hedge_cone_aged_item", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "hedge_cone_pink_aged_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_layered_pink_item", {Ingredient("foliage", 1), Ingredient("hedge_layered_item", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "hedge_layered_pink_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("hedge_layered_pink_aged_item", {Ingredient("foliage", 2), Ingredient("hedge_layered_aged_item", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "hedge_layered_pink_aged_item.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_sea_grass", {Ingredient("dug_grass", 1), Ingredient("poop", 1)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_sea_grass_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas,
		image			= "kyno_dug_yellowgrass.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_sea_reeds", {Ingredient("cutreeds", 1), Ingredient("poop", 1)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_sea_reeds_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas,
		image			= "kyno_dug_reeds.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_whirlpool", {Ingredient("ice", 6)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_whirlpool_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_whirlpool.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_lilypad", {Ingredient("kelp", 6)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_lilypad_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lilypad.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_lotusplant", {Ingredient("kelp", 2), Ingredient("petals", 4)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_lotusplant_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lotusplant.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_watercress_planted", {Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_watercress_planted_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_watercress.tex",
	},
	{"TAP_HAMLET"}
)

AddRecipe2("kyno_seataro_planted", {Ingredient("foliage", 1)}, TECH.SCIENCE_TWO,
	{
		testfn			= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer 			= "kyno_seataro_planted_placer",
		min_spacing		= 0,
		build_distance	= 30,
		atlas			= TapBuildingAtlas,
		image			= "kyno_seataro.tex",
	},
	{"TAP_HAMLET"}
)

-- The Gorge Category.
AddRecipe2("kyno_gorge_prototyper", {Ingredient("cutstone", 1), Ingredient("meatballs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gorge_prototyper_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gnawaltar.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_queenaltar", {Ingredient("cutstone", 4), Ingredient("redgem", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_queenaltar_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_queenaltar.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_beaststatue", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_beaststatue_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_beaststatue1.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_beaststatue2", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_beaststatue2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_beaststatue2.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_bollard", {Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bollard_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bollard.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_ivy", {Ingredient("twigs", 2), Ingredient("cutgrass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ivy_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ivy.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_streetlight1", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_streetlight1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_streetlight1.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_streetlight2", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_streetlight2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_streetlight2.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_mossygateway", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mossygateway_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_mossygateway.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_sammywagon", {Ingredient("boards", 1), Ingredient("cutgrass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sammywagon_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sammywagon.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_mealingstone", {Ingredient("cutstone", 1), Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mealingstone_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_mealingstone.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_safechest", {Ingredient("cutstone", 1), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_safechest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_safe.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_drawerchest", {Ingredient("boards", 2), Ingredient("flint", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_drawerchest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_drawerchest.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_saltpond", {Ingredient("saltrock", 2), Ingredient("ice", 2), Ingredient("pondfish", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_saltpond_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_saltpond.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_saltpond_rack", {Ingredient("saltrock", 2), Ingredient("ice", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_saltpond_rack_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_saltpond_rack.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_crabtrap", {Ingredient("boards", 1), Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_crabtrap_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_crabtrap.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_gorge_debris", {Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gorge_debris_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_gorge_debris.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_rubble_carriage", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rubble_carriage_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carriage.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_rubble_bike", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rubble_bike_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bike.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_rubble_clock", {Ingredient("boards", 1), Ingredient("compass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rubble_clock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gorgeclock.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_rubble_cathedral", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rubble_cathedral_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_cathedral.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_rubble_pubdoor", {Ingredient("cutstone", 1), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rubble_pubdoor_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pubdoor.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_rubble_roof", {Ingredient("cutstone", 1), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rubble_roof_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_roof.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_rubble_clocktower", {Ingredient("cutstone", 1), Ingredient("compass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rubble_clocktower_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_clocktower.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_rubble_house", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rubble_house_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_house.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_rubble_chimney", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rubble_chimney_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_chimney1.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_rubble_chimney2", {Ingredient("cutstone", 1), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rubble_chimney2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_chimney2.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_piptoncart", {Ingredient("cutstone", 1), Ingredient("bluegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_piptoncart_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_piptoncart.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_irongate_item", {Ingredient("twigs", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 2,
		atlas			= TapInventoryAtlas,
		image			= "kyno_irongate_item.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_ironfencesmall", {Ingredient("twigs", 1), Ingredient("flint", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ironfencesmall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ironfencesmall.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_ironfencetall", {Ingredient("twigs", 1), Ingredient("flint", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ironfencetall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ironfencesmall.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_urn", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_urn_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_urn.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_worshipper", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_worshipper_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_worshipper.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_worshipper2", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_worshipper2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_worshipper2.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_stoneobelisk", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stoneobelisk_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stoneobelisk.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_birdfountain", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_birdfountain_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_birdfountain.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("cottontree_small", {Ingredient("log", 1), Ingredient("pinecone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_cottontree_small_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_cottontree.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_cottontree2", {Ingredient("log", 3), Ingredient("spoiled_food", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_cottontree2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_cottontree2.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_spottyshrub", {Ingredient("dug_berrybush2", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_spottyshrub_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_spottyshrub.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_oven", {Ingredient("cutstone", 1), Ingredient("charcoal", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_oven_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_crate_oven.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_grill_small", {Ingredient("cutstone", 1), Ingredient("twigs", 3), Ingredient("charcoal", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grill_small_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_crate_grill_small.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_grill_large", {Ingredient("cutstone", 1), Ingredient("twigs", 3), Ingredient("charcoal", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grill_large_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_crate_grill.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_pothanger_potsmall", {Ingredient("cutstone", 1), Ingredient("twigs", 3), Ingredient("charcoal", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pothanger_potsmall_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_crate_pot_hanger.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_pothanger", {Ingredient("cutstone", 1), Ingredient("twigs", 3), Ingredient("charcoal", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pothanger_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_crate_pot_hanger.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_pothanger_syrup", {Ingredient("cutstone", 1), Ingredient("twigs", 3), Ingredient("honey", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pothanger_syrup_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_crate_pot_hanger.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_mushroomstump", {Ingredient("red_cap", 1), Ingredient("green_cap", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mushroomstump_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_mushstump.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_swampmermhouserubble", {Ingredient("rocks", 2), Ingredient("log", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_swampmermhouserubble_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_swampmermhouserubble.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_swamppighouse", {Ingredient("boards", 2), Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_swamppighouse_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_swamppighouse.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_swampmermhouse", {Ingredient("boards", 2), Ingredient("cutstone", 2), Ingredient("pondfish", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_swampmermhouse_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_swampmermhouse.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_pigelder", {Ingredient("meat", 4), Ingredient("reviver", 1), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigelder_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigelder.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_potato_planted", {Ingredient("potato_seeds", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_potato_planted_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_seedpacket_2.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_turnip_planted", {Ingredient("eggplant_seeds", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_turnip_planted_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_seedpacket_5.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_carrot_planted", {Ingredient("carrot_seeds", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carrot_planted_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_seedpacket_6.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_onion_planted", {Ingredient("onion_seeds", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_onion_planted_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_seedpacket_4.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_wheat_planted", {Ingredient("cutgrass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wheat_planted_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_seedpacket_1.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_garlic_planted", {Ingredient("garlic_seeds", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_garlic_planted_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_seedpacket_7.tex",
	},
	{"TAP_GORGE"}
)

AddRecipe2("kyno_tomato_planted", {Ingredient("tomato_seeds", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tomato_planted_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_seedpacket_3.tex",
	},
	{"TAP_GORGE"}
)

-- The Forge Category.
AddRecipe2("kyno_pugna", {Ingredient("hambat", 1), Ingredient("meat", 4), Ingredient("reviver", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pugna_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pugna.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_magmagolem", {Ingredient("rocks", 2), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_magmagolem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_magmagolem.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_shieldstandard", {Ingredient("boards", 1), Ingredient("purplegem", 1), Ingredient("houndstooth", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shieldstandard_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_purplestandard.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_attackstandard", {Ingredient("boards", 1), Ingredient("redgem", 1), Ingredient("boneshard", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_attackstandard_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_redstandard.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_healstandard", {Ingredient("boards", 1), Ingredient("bluegem", 1), Ingredient("petals", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_healstandard_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bluestandard.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_bannerstandard", {Ingredient("boards", 1), Ingredient("silk", 1), Ingredient("boneshard", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bannerstandard_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_banner1.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_bannerstandard_2", {Ingredient("boards", 1), Ingredient("silk", 1), Ingredient("boneshard", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bannerstandard_2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_banner2.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_bannerstandard_3", {Ingredient("boards", 1), Ingredient("silk", 1), Ingredient("boneshard", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bannerstandard_3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_banner3.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_lavaspawner", {Ingredient("cutstone", 1), Ingredient("redgem", 1), Ingredient("boneshard", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lavaspawner_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lavaspawner.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_lavagateway", {Ingredient("cutstone", 2), Ingredient("redgem", 1), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lavagateway_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lavagateway.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_anchorgateway", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_anchorgateway_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_anchorgateway.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_forge_seat", {Ingredient("goldnugget", 1), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_forge_seat_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_forge_seat.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_moltenfence_item", {Ingredient("fence_item", 2), Ingredient("boneshard", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "kyno_moltenfence_item.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_lavahole", {Ingredient("cutstone", 1), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lavahole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lavahole.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_healflower", {Ingredient("petals", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_healflower_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_healblossom.tex",
	},
	{"TAP_FORGE"}
)

AddRecipe2("kyno_artificial_healflower", {Ingredient("petals", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_artificial_healflower_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_healblossom2.tex",
	},
	{"TAP_FORGE"}
)

-- Interior Category.
AddRecipe2("kyno_plantholder_basic", {Ingredient("log", 1), Ingredient("twigs", 2), Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_basic_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_basic.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_wip", {Ingredient("cutstone", 1), Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_wip_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_wip.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_fancy", {Ingredient("marble", 1), Ingredient("feather_crow", 1), Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_fancy_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_fancy.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_bonsai", {Ingredient("cutstone", 1), Ingredient("dug_berrybush_juicy", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_bonsai_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_bonsai.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_dishgarden", {Ingredient("cutstone", 1), Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_dishgarden_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_dishgarden.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_philodendron", {Ingredient("marble", 1), Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_philodendron_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_philodendron.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_orchid", {Ingredient("cutstone", 1), Ingredient("succulent_picked", 1), Ingredient("petals", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_orchid_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_orchid.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_draceana", {Ingredient("log", 1), Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_draceana_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_draceana.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_palm", {Ingredient("cutgrass", 1), Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_palm_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_palm.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_zz", {Ingredient("cutgrass", 1), Ingredient("twigs", 1), Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_zz_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_zz.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_fernstand", {Ingredient("goldnugget", 2), Ingredient("foliage", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_fernstand_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_fernstand.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_terrarium", {Ingredient("cutstone", 2), Ingredient("moonglass", 2), Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_terrarium_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_terrarium.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_plantpet", {Ingredient("log", 2), Ingredient("rocks", 2), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_plantpet_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_plantpet.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_traps", {Ingredient("cutstone", 1), Ingredient("houndstooth", 2), Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_traps_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_traps.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_plantholder_sadness", {Ingredient("boards", 1), Ingredient("dug_sapling", 1), Ingredient("winter_ornament_plain3", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plantholder_sadness_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_plantholder_sadtree.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_palace_plant", {Ingredient("cutstone", 1), Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_palace_plant_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_palace_plant.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_chair_classic", {Ingredient("marble", 1), Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chair_classic_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_chair_classic.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_chair_corner", {Ingredient("boards", 1), Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chair_corner_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_chair_corner.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_chair_bench", {Ingredient("boards", 1), Ingredient("silk", 2), Ingredient("turf_carpetfloor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chair_bench_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_chair_bench.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_chair_horned", {Ingredient("boards", 1), Ingredient("silk", 2), Ingredient("turf_checkerfloor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chair_horned_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_chair_horned.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_chair_footrest", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chair_footrest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_chair_footrest.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_chair_lounge", {Ingredient("boards", 1), Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chair_lounge_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_chair_lounge.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_chair_massager", {Ingredient("boards", 1), Ingredient("transistor", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chair_massager_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_chair_massager.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_chair_stuffed", {Ingredient("silk", 2), Ingredient("bluegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chair_stuffed_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_chair_stuffed.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_chair_rocking", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chair_rocking_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_chair_rocking.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_chair_ottoman", {Ingredient("boards", 1), Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chair_ottoman_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_chair_ottoman.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_chair_chaise", {Ingredient("marble", 1), Ingredient("silk", 1), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chair_chaise_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_chair_chaise.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_palace_throne", {Ingredient("goldnugget", 2), Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_palace_throne_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_palace_throne.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_round", {Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_round_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_round.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_square", {Ingredient("silk", 2), Ingredient("tentaclespots", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_square_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_square.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_oval", {Ingredient("silk", 2), Ingredient("petals", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_oval_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_oval.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_rectangle", {Ingredient("silk", 2), Ingredient("petals", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_rectangle_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_rectangle.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_fur", {Ingredient("silk", 2), Ingredient("beefalowool", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_fur_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_fur.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_hedgehog", {Ingredient("silk", 2), Ingredient("houndstooth", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_hedgehog_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_hedgehog.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_porcupuss", {Ingredient("silk", 2), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_porcupuss_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_porcopuss.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_hoofprints", {Ingredient("silk", 2), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_hoofprints_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_hoofprint.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_octagon", {Ingredient("silk", 2), Ingredient("cutgrass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_octagon_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_octagon.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_swirl", {Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_swirl_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_swirl.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_catcoon", {Ingredient("silk", 2), Ingredient("coontail", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_catcoon_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_catcoon.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_rubbermat", {Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_rubbermat_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_rubbermat.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_web", {Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_web_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_web.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_metal", {Ingredient("silk", 2), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_metal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_metal.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_wormhole", {Ingredient("silk", 2), Ingredient("meat", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_wormhole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_wormhole.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_braid", {Ingredient("silk", 2), Ingredient("blue_cap", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_braid_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_braid.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_beard", {Ingredient("silk", 2), Ingredient("beardhair", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_beard_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_beard.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_nailbed", {Ingredient("silk", 2), Ingredient("houndstooth", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_nailbed_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_nailbed.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_crime", {Ingredient("silk", 2), Ingredient("reviver", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_crime_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_crime.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_tiles", {Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_tiles_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rug_tiles.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_circle", {Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_circle_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_circle.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_moth", {Ingredient("turf_carpetfloor", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_moth_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_moth.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_leather", {Ingredient("silk", 2), Ingredient("beefalowool", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_leather_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_leather.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_throneroom", {Ingredient("silk", 2), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_throneroom_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_throneroom.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_worn", {Ingredient("turf_carpetfloor", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_worn_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_worn.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_antiquities", {Ingredient("silk", 2), Ingredient("kyno_oinc1", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_antiquities_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_antiquities.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_bank", {Ingredient("silk", 2), Ingredient("kyno_oinc100", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_bank_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_bank.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_deli", {Ingredient("silk", 2), Ingredient("hambat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_deli_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_deli.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_flag", {Ingredient("silk", 2), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_flag_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_flag.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_florist", {Ingredient("silk", 2), Ingredient("petals_evil", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_florist_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_florist.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_general", {Ingredient("silk", 2), Ingredient("shovel", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_general_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_general.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_gift", {Ingredient("silk", 2), Ingredient("cutgrass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_gift_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_gift.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_hoofspa", {Ingredient("silk", 2), Ingredient("moonglass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_hoofspa_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_hoofspa.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_old", {Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_old_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_old.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_produce", {Ingredient("silk", 2), Ingredient("carrot", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_produce_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_produce.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_rugs_tinker", {Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rugs_tinker_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rugs_tinker.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_fringe", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("silk", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_fringe_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_fringe.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_stainglass", {Ingredient("lantern", 1), Ingredient("purplegem", 1), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_stainglass_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_stainglass.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_downbridge", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("silk", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_downbridge_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_downbridge.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_dualembroidered", {Ingredient("lantern", 1), Ingredient("moonglass", 1), Ingredient("petals", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_dualembroidered_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_2embroidered.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_ceramic", {Ingredient("lantern", 1), Ingredient("marble", 1), Ingredient("petals", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_ceramic_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_ceramic.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_glass", {Ingredient("lantern", 1), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_glass_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_glass.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_dualfringes", {Ingredient("lantern", 1), Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_dualfringes_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_2fringes.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_candelabra", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("torch", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_candelabra_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_candelabra.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_elizabethan", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_elizabethan_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_elizabethan.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_gothic", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_gothic_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_gothic.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_orb", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("lightbulb", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_orb_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_orb.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_bellshade", {Ingredient("lantern", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_bellshade_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_bellshade.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_crystals", {Ingredient("lantern", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_crystals_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_crystals.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_upturn", {Ingredient("lantern", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_upturn_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_upturn.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_dualupturns", {Ingredient("lantern", 1), Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_dualupturns_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_2upturns.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_spool", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_spool_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_spool.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_edison", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_edison_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_edison.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_adjustable", {Ingredient("lantern", 1), Ingredient("cutstone", 1), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_adjustable_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_adjustable.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_rightangles", {Ingredient("lantern", 1), Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_rightangles_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_rightangles.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_fancy", {Ingredient("lantern", 1), Ingredient("marble", 1), Ingredient("petals", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_fancy_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_hoofspa.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_lamps_festivetree", {Ingredient("pinecone", 1), Ingredient("winter_ornament_light1", 1), Ingredient("winter_ornament_boss_deerclops", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lamps_festivetree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lamp_festivetree.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_tables_round", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tables_round_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_table_round.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_tables_banker", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tables_banker_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_table_banker.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_tables_diy", {Ingredient("boards", 1), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tables_diy_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_table_diy.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_tables_raw", {Ingredient("boards", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tables_raw_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_table_raw.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_tables_crate", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tables_crate_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_table_crate.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_tables_chess", {Ingredient("boards", 1), Ingredient("trinket_28", 1), Ingredient("trinket_16", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tables_chess_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_table_chess.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_woodtable", {Ingredient("boards", 1), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_wiptable_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_table.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_booktable", {Ingredient("boards", 1), Ingredient("papyrus", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_booktable_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_table_books.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_wiptable", {Ingredient("boards", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_wiptable_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_table_wip.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_cookbook_table", {Ingredient("boards", 1), Ingredient("cookbook", 1), Ingredient("featherpencil", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_cookbook_table_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_cookbook_table.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_parts", {Ingredient("boards", 1), Ingredient("moonglass", 1), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_parts_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_tableparts.tex",
	},
	{"TAP_INTERIOR"}
)

--[[
AddRecipe2("kyno_shelves_wood", {Ingredient("boards", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_wood_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_wood.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_basic", {Ingredient("boards", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_basic_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_basic.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_cinderblocks", {Ingredient("boards", 2), Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_cinderblocks_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_cinderblocks.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_marble", {Ingredient("marble", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_marble_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_marble.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_midcentury", {Ingredient("boards", 2), Ingredient("moonglass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_midcentury_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_midcentury.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_glass", {Ingredient("goldnugget", 2), Ingredient("moonglass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_glass_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_glass.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_ladder", {Ingredient("boards", 2), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_ladder_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_ladder.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_hutch", {Ingredient("boards", 2), Ingredient("succulent_picked", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_hutch_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_hutch.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_industrial", {Ingredient("boards", 3), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_industrial_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_industrial.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_adjustable", {Ingredient("boards", 1), Ingredient("cutstone", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_adjustable_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_adjustable.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_wallmount", {Ingredient("boards", 2), Ingredient("rope", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_wallmount_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_wallmount.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_aframe", {Ingredient("driftwood_log", 2), Ingredient("rope", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_aframe_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_aframe.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_crates", {Ingredient("boards", 3), Ingredient("rope", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_crates_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_crates.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_fridge", {Ingredient("goldnugget", 2), Ingredient("gears", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_fridge_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_fridge.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_floating", {Ingredient("boards", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_floating_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_floating.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_pipe", {Ingredient("cutstone", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_pipe_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_pipe.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_hattree", {Ingredient("boards", 3), Ingredient("tophat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_hattree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_hattree.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_pallet", {Ingredient("boards", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_pallet_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_shelves_pallet.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_metalcrates", {Ingredient("cutstone", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_metalcrates_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_metalcrates.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_displaycase", {Ingredient("boards", 1), Ingredient("moonglass", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_displaycase_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_displaycase2.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_displaycase_metal", {Ingredient("cutstone", 1), Ingredient("moonglass", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_displaycase_metal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_displaycase1.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_bank", {Ingredient("marble", 1), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_bank_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_bank.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_woodcrate", {Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_woodcrate_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_woodcrate.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_barrel", {Ingredient("boards", 1), Ingredient("rope", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_barrel_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_barrel.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_barreldome", {Ingredient("boards", 1), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_barreldome_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_barreldome.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_cablespool", {Ingredient("boards", 1), Ingredient("rope", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_cablespool_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_cablespool.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_cakestand", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_cakestand_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_cakestand.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_cakestanddome", {Ingredient("moonrocknugget", 1), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_cakestanddome_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_cakestanddome.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_cart", {Ingredient("boards", 1), Ingredient("minisign_item", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_cart_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_cart.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_fridge2", {Ingredient("cutstone", 1), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_fridge2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_fridge2.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_globe", {Ingredient("goldnugget", 1), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_globe_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_globe.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_ice", {Ingredient("boards", 1), Ingredient("ice", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_ice_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_ice.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_icebucket", {Ingredient("boards", 1), Ingredient("ice", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_icebucket_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_icebucket.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_mahogany", {Ingredient("boards", 1), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_mahogany_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_mahogany.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_marble2", {Ingredient("marble", 1), Ingredient("flint", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_marble2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_marble2.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_marblesilk", {Ingredient("marble", 1), Ingredient("silk", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_marblesilk_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_marblesilk.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_metal", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_metal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_metal.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_stoneslab", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_stoneslab_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_stoneslab.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_traystand", {Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_traystand_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_traystand.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_wagon", {Ingredient("boards", 1), Ingredient("minisign_item", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_wagon_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_wagon.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_yotp", {Ingredient("redgem", 1), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_yotp_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_yotp.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_yotp2", {Ingredient("redgem", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_yotp2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_yotp2.tex"
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_shelves_ruins", {Ingredient("cutstone", 1), Ingredient("flint", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shelves_ruins_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shelves_ruins.tex",
	},
	{"TAP_INTERIOR"}
)
]]--

AddRecipe2("kyno_shoptable", {Ingredient("boards", 4), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shoptable_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shoptable.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_anvil", {Ingredient("cutstone", 2), Ingredient("hammer", 0)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_anvil_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_anvil.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_stoneblock", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_stoneblock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_stoneblock.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_vase", {Ingredient("marble", 1), Ingredient("bluegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_vase_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_vase.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_pottingwheel", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_pottingwheel_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_pottingwheel.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_pottingwheelurn", {Ingredient("boards", 1), Ingredient("marble", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_pottingwheelurn_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_pottingwheel_urn.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_pottingwheelclay", {Ingredient("boards", 1), Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_pottingwheelclay_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_pottingwheel_clay.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_pottingwheelwip", {Ingredient("boards", 1), Ingredient("cutstone", 1), Ingredient("hammer", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_pottingwheelwip_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_pottingwheel_wip.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_velvetback", {Ingredient("goldnugget", 2), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_velvetback_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_velvetback.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_accademia_velvetside", {Ingredient("goldnugget", 2), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accademia_velvetside_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_accademia_velvetside.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_arcane_bookcase", {Ingredient("livinglog", 3), Ingredient("papyrus", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_arcane_bookcase_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_arcane_bookcase.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_arcane_chestclosed", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_arcane_chestclosed_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_arcane_chestclosed.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_arcane_chestopen", {Ingredient("boards", 1), Ingredient("blueprint", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_arcane_chestopen_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_arcane_chestopen.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_arcane_containers", {Ingredient("marble", 1), Ingredient("cutstone", 1), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_arcane_containers_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_arcane_containers.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_arcane_tablemagic", {Ingredient("boards", 1), Ingredient("turf_carpetfloor", 1), Ingredient("trinket_32", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_arcane_tablemagic_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_arcane_tablemagic.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_arcane_tabledistillery", {Ingredient("boards", 1), Ingredient("trinket_35", 1), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_arcane_tabledistillery_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_arcane_tabledistillery.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_deli_stackside", {Ingredient("cutgrass", 2), Ingredient("papyrus", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_deli_stackside_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_deli_stackside.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_deli_stackfront", {Ingredient("cutgrass", 2), Ingredient("papyrus", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_deli_stackfront_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_deli_stackfront.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_florist_latticefront", {Ingredient("boards", 1), Ingredient("twigs", 2), Ingredient("petals", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_florist_latticefront_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_florist_latticefront.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_florist_latticeside", {Ingredient("boards", 1), Ingredient("twigs", 2), Ingredient("petals", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_florist_latticeside_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_florist_latticeside.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_florist_pillarfront", {Ingredient("boards", 1), Ingredient("twigs", 2), Ingredient("petals", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_florist_pillarfront_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_florist_pillarfront.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_florist_pillarside", {Ingredient("boards", 1), Ingredient("twigs", 2), Ingredient("petals", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_florist_pillarside_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_florist_pillarside.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_florist_tiered", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_florist_tiered_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_florist_tiered.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_mayoroffice_bookcase", {Ingredient("boards", 2), Ingredient("papyrus", 2), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mayoroffice_bookcase_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_mayoroffice_bookcase.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_mayoroffice_desk", {Ingredient("boards", 2), Ingredient("lantern", 1), Ingredient("featherpencil", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mayoroffice_desk_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_mayoroffice_desk.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_millinery_hatbox1", {Ingredient("boards", 1), Ingredient("tophat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_millinery_hatbox1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_millinery_hatbox1.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_millinery_hatbox2", {Ingredient("boards", 1), Ingredient("winterhat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_millinery_hatbox2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_millinery_hatbox2.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_millinery_sewingmachine", {Ingredient("cutstone", 2), Ingredient("sewing_kit", 3), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_millinery_sewingmachine_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_millinery_sewingmachine.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_millinery_worktable", {Ingredient("boards", 1), Ingredient("papyrus", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_millinery_worktable_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_millinery_worktable.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_palace_pillar", {Ingredient("marble", 1), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_palace_pillar_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_palace_pillar.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_baskets", {Ingredient("boards", 1), Ingredient("cutgrass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_baskets_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_baskets.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_bin", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_bin_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_bin.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_cans", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_cans_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_cans.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_display", {Ingredient("marble", 1), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_display_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_display.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_endtable", {Ingredient("boards", 1), Ingredient("taffy", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_endtable_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_endtable.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_rollholder", {Ingredient("boards", 1), Ingredient("blueprint", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_rollholder_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_rollholder.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_rollholderfront", {Ingredient("boards", 1), Ingredient("blueprint", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_rollholderfront_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_rollholderfront.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_vase", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_vase_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_vase.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_urn", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_urn_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_urn.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_vasemarble", {Ingredient("marble", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_vasemarble_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_vasemarble.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_interior_wired", {Ingredient("fence_item", 1), Ingredient("petals", 1), Ingredient("papyrus", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_interior_wired_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_interior_wired.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box1", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box1.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box2", {Ingredient("boards", 1), Ingredient("tophat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box2.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box3", {Ingredient("boards", 1), Ingredient("winterhat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box3.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box4", {Ingredient("boards", 1), Ingredient("strawhat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box4.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box5", {Ingredient("boards", 1), Ingredient("beefalohat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box5.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box6", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box6_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box6.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box7", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box7_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box7.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box8", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box8_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box8.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box9", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box9_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box9.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box10", {Ingredient("papyrus", 1), Ingredient("rope", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box10_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box10.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box11", {Ingredient("papyrus", 1), Ingredient("rope", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box11_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box11.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box12", {Ingredient("cutgrass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box12_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box12.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box13", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box13_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box13.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box14", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box14_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box14.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box15", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box15_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box15.tex",
	},
	{"TAP_INTERIOR"}
)

AddRecipe2("kyno_containers_box16", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_containers_box16_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_containers_box16.tex",
	},
	{"TAP_INTERIOR"}
)

-- Surface Category.
AddRecipe2("dug_berrybush", {Ingredient("berries", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "dug_berrybush.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("dug_berrybush2", {Ingredient("dug_berrybush", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "dug_berrybush2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("dug_berrybush_juicy", {Ingredient("berries_juicy", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "dug_berrybush_juicy.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("dug_grass", {Ingredient("cutgrass", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "dug_grass.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("dug_sapling", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "dug_sapling.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("dug_marsh_bush", {Ingredient("dug_sapling", 1), Ingredient("houndstooth", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "dug_marsh_bush.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_reeds", {Ingredient("cutreeds", 2), Ingredient("poop", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_reeds_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_dug_reeds.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("dug_sapling_moon", {Ingredient("dug_sapling", 1), Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas1,
		image			= "dug_sapling_moon.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("dug_rock_avocado_bush", {Ingredient("rock_avocado_fruit", 3, TapBuildingAtlas2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas1,
		image			= "dug_rock_avocado_bush.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("dug_trap_starfish", {Ingredient("dug_marsh_bush", 1), Ingredient("houndstooth", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas1,
		image			= "dug_trap_starfish.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("dug_monkeytail", {Ingredient("cutreeds", 2), Ingredient("poop", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas1,
		image			= "dug_monkeytail.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("dug_bananabush", {Ingredient("cave_banana", 2), Ingredient("poop", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas1,
		image			= "dug_bananabush.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burntmarsh", {Ingredient("ash", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burntmarsh_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burntmarsh.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("red_mushroom", {Ingredient("red_cap", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_red_mushroom_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_redmush.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("green_mushroom", {Ingredient("green_cap", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_green_mushroom_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_greenmush.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("blue_mushroom", {Ingredient("blue_cap", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_blue_mushroom_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bluemush.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("flower_rose", {Ingredient("petals", 1), Ingredient("stinger", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rose_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rose.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_cactus", {Ingredient("cactus_meat", 1), Ingredient("poop", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_cactus_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_cactus.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_oasis_cactus", {Ingredient("cactus_meat", 1), Ingredient("poop", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_oasis_cactus_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_oasis_cactus.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_tumbleweed", {Ingredient("cutgrass", 1), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tumbleweed_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_tumbleweed.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("mandrake_planted", {Ingredient("mandrake", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mandrake_planted_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_mandrake_planted.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("carrot_planted", {Ingredient("carrot", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carrotplanted_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carrot_planted.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_marsh_plant", {Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_marsh_plant_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_marshplant.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("succulent_plant", {Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_succulent_plant_placer",
		min_spacing		= 0,
		atlas			= TapInventoryAtlas,
		image			= "succulent_picked.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pondrock", {Ingredient("rocks", 1), Ingredient("charcoal", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pondrock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_scorchedrock.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_farmdebris", {Ingredient("twigs", 1), Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_farmdebris_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_farmdebris.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_scorchedground", {Ingredient("ash", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_scorchedground_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_scorchedground.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree_short", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree_normal", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree_normal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree_tall", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree2_short", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree2_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree2_normal", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree2_normal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree2_tall", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree2_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree3_short", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree3_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree3_normal", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree3_normal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree3_tall", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree3_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree4_short", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree4_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree4_normal", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree4_normal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree4_tall", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree4_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_burnttree5", {Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_burnttree5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_burnttree5.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump_short", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump_short.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump_normal", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump_normal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump_normal.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump_tall", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump_tall.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump2_short", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump2_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump2_short.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump2_normal", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump2_normal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump2_normal.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump2_tall", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump2_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump2_tall.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump3_short", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump3_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump3_short.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump3_normal", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump3_normal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump3_normal.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump3_tall", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump3_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump3_tall.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump3_old", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump3_old_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump3_old.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump4_short", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump4_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump4_short.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump4_normal", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump4_normal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump4_normal.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump4_tall", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump4_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump4_tall.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_stump5", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump5.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("lumpy_sapling", {Ingredient("pinecone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lumpy_sapling_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lumpysapling.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_marsh_tree", {Ingredient("log", 3), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_marsh_tree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_marsh_tree.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("rock_petrified_tree_short", {Ingredient("rocks", 1), Ingredient("nitre", 1), Ingredient("flint", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_petrified_tree_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocktree_short.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("rock_petrified_tree_med", {Ingredient("rocks", 2), Ingredient("nitre", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_petrified_tree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocktree.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("rock_petrified_tree_tall", {Ingredient("rocks", 3), Ingredient("nitre", 3), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_petrified_tree_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocktree_tall.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("rock_petrified_tree_old", {Ingredient("rocks", 2), Ingredient("nitre", 1), Ingredient("flint", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_petrified_tree_old_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rocktree_old.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_marbletree_1", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_marbletree1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_marbletree1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_marbletree_2", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_marbletree2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_marbletree2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_marbletree_3", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_marbletree3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_marbletree3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_marbletree_4", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_marbletree4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_marbletree4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_rock_sinkhole", {Ingredient("rocks", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock_sinkhole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sinkholerock.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sinkhole", {Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sinkhole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sinkhole.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sinkhole_closed", {Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sinkhole_closed_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sinkholeclosed.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_cavehole", {Ingredient("rocks", 2), Ingredient("rope", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_cavehole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_cavehole.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_rock1", {Ingredient("rocks", 3), Ingredient("nitre", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rock1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_rock2", {Ingredient("rocks", 3), Ingredient("goldnugget", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rock2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_rock_flintless", {Ingredient("rocks", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rockflintless_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rockflintless.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_rock_ice", {Ingredient("ice", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rockice_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rockice.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_snowhill", {Ingredient("turf_snowfall", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_snowhill_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_snowpile.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_rock_moon", {Ingredient("rocks", 3), Ingredient("moonrocknugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rockmoon_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rockmoon.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonshell", {Ingredient("rocks", 3), Ingredient("moonrocknugget", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonshell_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rockmoonshell.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonglass_rock", {Ingredient("moonglass", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonglass_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonglass.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonglass_spike", {Ingredient("moonglass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonglass_spike_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonglass_spike.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonglass_meteor", {Ingredient("moonglass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonglass_meteor_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonglass_meteor.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonrock_pieces", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonrubble_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonrubble.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_hound_gargoyle_1", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_hound_gargoyle_1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonhound1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_hound_gargoyle_2", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_hound_gargoyle_2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonhound2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_hound_gargoyle_3", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_hound_gargoyle_3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonhound3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_hound_gargoyle_4", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_hound_gargoyle_4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonhound4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_werepig_gargoyle_1", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_werepig_gargoyle_1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonpig.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_werepig_gargoyle_2", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_werepig_gargoyle_2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonpig2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_werepig_gargoyle_3", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_werepig_gargoyle_3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonpig3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_werepig_gargoyle_4", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_werepig_gargoyle_4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonpig4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_werepig_gargoyle_5", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_werepig_gargoyle_5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonpig5.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_werepig_gargoyle_6", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_werepig_gargoyle_6_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonpig6.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonbase", {Ingredient("moonrocknugget", 10), Ingredient("nightmarefuel", 5), Ingredient("opalpreciousgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonbase_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonbase.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_eyeplant", {Ingredient("plantmeat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_eyeplant_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_eyeplant.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_lureplant", {Ingredient("lureplantbulb", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lureplant_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lureplant.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_contrarregra", {Ingredient("marble", 1), Ingredient("nightmarefuel", 2), Ingredient("turf_carpetfloor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_contrarregra_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_contrarregra.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pigtorch", {Ingredient("log", 2), Ingredient("poop", 2), Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigtorch_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigtorch.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_mermhouse", {Ingredient("boards", 2), Ingredient("rocks", 3), Ingredient("pondfish", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rundown_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rundown.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_walrus_camp", {Ingredient("cutstone", 1), Ingredient("walrus_tusk", 1), Ingredient("log", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_walrus_camp_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_igloo.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_rabbithole", {Ingredient("rabbit", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rabbithole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rabbithole.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_catcoonden", {Ingredient("log", 2), Ingredient("silk", 2), Ingredient("coontail", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_hollowstump_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hollowstump.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_poisontree", {Ingredient("livinglog", 2), Ingredient("nightmarefuel", 3), Ingredient("acorn", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_poisontree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_poisontree.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_houndmound", {Ingredient("houndstooth", 2), Ingredient("boneshard", 2), Ingredient("monstermeat", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_houndmound_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_houndmound.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_tallbirdnest", {Ingredient("tallbirdegg", 1), Ingredient("cutgrass", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tallbirdnest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_tallbirdnest.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_beehive", {Ingredient("honey", 2), Ingredient("honeycomb", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_beehive_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_beehive.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_wasphive", {Ingredient("honey", 2), Ingredient("honeycomb", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wasphive_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wasphive.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moose_nesting_ground", {Ingredient("twigs", 6)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nestground_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_nestground.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_goosenest", {Ingredient("cutgrass", 2), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_goosenest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_goosenest.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_goosenestegg", {Ingredient("bird_egg", 4), Ingredient("cutgrass", 4), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_goosenestegg_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_goosenestegg.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_honeypatch", {Ingredient("honey", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_honeypatch_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_honeypatch.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_giantbeehive_small", {Ingredient("honey", 2), Ingredient("honeycomb", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_giantbeehive_small_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_beehivesmall.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_giantbeehive_medium", {Ingredient("honey", 4), Ingredient("honeycomb", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_giantbeehive_medium_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_beehivemedium.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_giantbeehive", {Ingredient("honey", 6), Ingredient("honeycomb", 1), Ingredient("hivehat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_giantbeehive_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_beehivelarge.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_klausbag", {Ingredient("deer_antler1", 1), Ingredient("silk", 4), Ingredient("charcoal", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_klausbag_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_klausbag.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_klausbag_winter", {Ingredient("deer_antler3", 1), Ingredient("silk", 4), Ingredient("charcoal", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_klausbag_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_klausbag_winter.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_icegeyser", {Ingredient("ice", 2), Ingredient("bluegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_icegeyser_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_icegeyser.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_magmafield", {Ingredient("torch", 2), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_magmafield_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_magmafield.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_molehill", {Ingredient("mole", 1), Ingredient("nitre", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_molehill_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_molehill.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonspiderden", {Ingredient("spidereggsack", 1), Ingredient("moonrocknugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonspiderden_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonspiderden.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statueglommer", {Ingredient("glommerwings", 1), Ingredient("marble", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueglommer_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_glommerstatue.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuemaxwell", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuemaxwell_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemaxwell.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuemaxwell_rose", {Ingredient("marble", 2), Ingredient("petals", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuemaxwell_rose_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_statuemaxwell_rose.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statueharp", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueharp_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueharp.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statueharp_rose", {Ingredient("marble", 2), Ingredient("petals", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueharp_rose_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_statueharp_rose.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("marblepillar", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_marblepillar_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_marblepillar.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statue_marble_muse", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statue_marble_muse_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarble1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statue_marble", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statue_marble_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarble2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statue_marble_urn", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statue_marble_urn_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarble3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statue_marble_pawn", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statue_marble_pawn_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarble4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statue_marble_pawn2", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statue_marble_pawn2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_statuemarble5.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuerook", {Ingredient("marble", 3), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuerook_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuerook.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statueknight", {Ingredient("marble", 3), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueknight_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueknight.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuebishop", {Ingredient("marble", 3), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuebishop_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuebishop.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuerook_repaired", {Ingredient("marble", 3), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuerook_repaired_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuerook_fixed.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statueknight_repaired", {Ingredient("marble", 3), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueknight_repaired_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueknight_fixed.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuebishop_repaired", {Ingredient("marble", 3), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuebishop_repaired_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuebishop_fixed.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sculpture_rooknose", {Ingredient("marble", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rooknose_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "sculpture_rooknose.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sculpture_knighthead", {Ingredient("marble", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_knighthead_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "sculpture_knighthead.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sculpture_bishophead", {Ingredient("marble", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bishophead_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "sculpture_bishophead.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuemarblebroodling", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuemarblebroodling_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarblebroodling.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuemarblevargling", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuemarblevargling_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarblevargling.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuemarblekittykit", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuemarblekittykit_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarblekittykit.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuemarblegiblet", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuemarblegiblet_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarblegiblet.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuemarbleewelet", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuemarbleewelet_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarbleewelet.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuemarblehutch", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuemarblehutch_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarblehutch.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuemarblechester", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuemarblechester_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarblechester.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuemarbleglomglom", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuemarbleglomglom_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuemarbleglomglom.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuestonebroodling", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuestonebroodling_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuestonebroodling.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuestonevargling", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuestonevargling_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuestonevargling.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuestonekittykit", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuestonekittykit_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuestonekittykit.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuestonegiblet", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuestonegiblet_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuestonegiblet.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuestoneewelet", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuestoneewelet_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuestoneewelet.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuestonehutch", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuestonehutch_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuestonehutch.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuestonechester", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuestonechester_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuestonechester.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_statuestoneglomglom", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statuestoneglomglom_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statuestoneglomglom.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_antlion", {Ingredient("townportaltalisman", 2), Ingredient("meat", 2), Ingredient("antliontrinket", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_antlion_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_antlion.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_talisman", {Ingredient("townportaltalisman", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_talisman_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_talisman.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sandspike_small", {Ingredient("turf_desertdirt", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sandspike_small_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sandspike_small.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sandspike_med", {Ingredient("turf_desertdirt", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sandspike_med_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sandspike_med.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sandspike_tall", {Ingredient("turf_desertdirt", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sandspike_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sandspike_tall.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sandblock", {Ingredient("turf_desertdirt", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sandblock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sandblock.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("glassspike_short", {Ingredient("turf_desertdirt", 2), Ingredient("torch", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_glassspike_short.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("glassspike_med", {Ingredient("turf_desertdirt", 2), Ingredient("torch", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_glassspike_med.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("glassspike_tall", {Ingredient("turf_desertdirt", 2), Ingredient("torch", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_glassspike_tall.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("glassblock", {Ingredient("turf_desertdirt", 2), Ingredient("torch", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_glassblock.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_antlionsinkhole", {Ingredient("turf_desertdirt", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_antlionsinkhole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_antlionsinkhole.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_altar_glass", {Ingredient("moonrocknugget", 2), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_altar_glass_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas2,
		image			= "moon_altar_glass.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_altar_idol", {Ingredient("moonrocknugget", 2), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_altar_idol_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas2,
		image			= "moon_altar_idol.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_altar_seed", {Ingredient("moonrocknugget", 2), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_altar_seed_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas2,
		image			= "moon_altar_seed.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_altar_crown", {Ingredient("moonrocknugget", 2), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_altar_crown_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas2,
		image			= "moon_altar_crown.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_altar_ward", {Ingredient("moonrocknugget", 4), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_altar_ward_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas2,
		image			= "moon_altar_ward.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_altar_icon", {Ingredient("moonrocknugget", 4), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_altar_icon_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas2,
		image			= "moon_altar_icon.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_invitingformation1", {Ingredient("rocks", 2), Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_invitingformation1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_invitingformation1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_invitingformation2", {Ingredient("rocks", 2), Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_invitingformation2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_invitingformation2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_invitingformation3", {Ingredient("rocks", 2), Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_invitingformation3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_invitingformation3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_obelisk", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_obelisk_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_obelisk.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sanityrock", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sanityrock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_obelisksanity.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_insanityrock", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_insanityrock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_obeliskinsanity.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pigking", {Ingredient("meat", 10), Ingredient("reviver", 1), Ingredient("pigskin", 10)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigking_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigking.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pigking_elite", {Ingredient("meat", 10), Ingredient("reviver", 1), Ingredient("pigskin", 10)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigking_elite_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigking_elite.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_critterlab", {Ingredient("rocks", 3), Ingredient("cutgrass", 3), Ingredient("seeds", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_critterlab_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rockden.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pighead", {Ingredient("twigs", 2), Ingredient("pigskin", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pighead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pighead.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_mermhead", {Ingredient("twigs", 2), Ingredient("pondfish", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mermhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_mermhead.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_bunnyhead", {Ingredient("manrabbit_tail", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bunnyhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bunnyhead.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("carrat_planted", {Ingredient("carrat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carrotplanted_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carrot_planted.tex",
	},
	{"TAP_SURFACE"}
)

-- Not sure if I can use this.
--[[
AddRecipe2("kyno_garden_handcar", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1), Ingredient("boards", 1)},
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_handcar_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_handcar.xml", "kyno_garden_handcar.tex")


AddRecipe2("kyno_garden_spray", {Ingredient("lifeinjector", 1), Ingredient("poop", 2), Ingredient("seeds", 2)},
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_spray_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_spray.xml", "kyno_garden_spray.tex")


AddRecipe2("kyno_garden_blank", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1)},
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_blank_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_blank.xml", "kyno_garden_blank.tex")


AddRecipe2("kyno_garden_sunflower", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1), Ingredient("petals", 2)},
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_sunflower_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_sunflower.xml", "kyno_garden_sunflower.tex")


AddRecipe2("kyno_garden_doublesunflower", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1), Ingredient("petals", 4)},
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_doublesunflower_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_doublesunflower.xml", "kyno_garden_doublesunflower.tex")


AddRecipe2("kyno_garden_greenie", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1), Ingredient("corn", 2)},
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_greenie_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_greenie.xml", "kyno_garden_greenie.tex")


AddRecipe2("kyno_garden_frozen", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1), Ingredient("ice", 2)},
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_frozen_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_frozen.xml", "kyno_garden_frozen.tex")


AddRecipe2("kyno_garden_dragon", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1), Ingredient("dragonfruit", 2)},
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_dragon_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_dragon.xml", "kyno_garden_dragon.tex")


AddRecipe2("kyno_garden_potato", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1), potatoingredient },
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_potato_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_potato.xml", "kyno_garden_potato.tex")


AddRecipe2("kyno_garden_whiteflower", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1), Ingredient("petals", 2)},
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_whiteflower_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_whiteflower.xml", "kyno_garden_whiteflower.tex")


AddRecipe2("kyno_garden_pepper", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1), Ingredient("pepper", 2)},
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_pepper_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_pepper.xml", "kyno_garden_pepper.tex")


AddRecipe2("kyno_garden_greenflower", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1), Ingredient("succulent_picked", 2)},
kyno_surfacetab, TECH.SCIENCE_TWO, "kyno_garden_greenflower_placer", 0, nil, nil, nil, "images/inventoryimages/kyno_garden_greenflower.xml", "kyno_garden_greenflower.tex")
]]--

AddRecipe2("kyno_pottedredmushroom", {Ingredient("red_cap", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pottedredmushroom_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pottedredmushroom.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pottedgreenmushroom", {Ingredient("green_cap", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pottedgreenmushroom_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pottedgreenmushroom.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pottedbluemushroom", {Ingredient("blue_cap", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pottedbluemushroom_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pottedbluemushroom.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pottedflower", {Ingredient("petals", 1), Ingredient("slurtle_shellpieces", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pottedflower_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pottedflower.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pottedevilflower", {Ingredient("petals_evil", 1), Ingredient("slurtle_shellpieces", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pottedevilflower_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pottedevilflower.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pottedrose", {Ingredient("petals", 1), Ingredient("stinger", 1), Ingredient("marble", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pottedrose_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pottedrose.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pottedcactus", {Ingredient("cactus_meat", 1), Ingredient("stinger", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pottedcactus_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pottedcactus.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gardenbox_flower1", {Ingredient("petals", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_flower1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_flower1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gardenbox_flower2", {Ingredient("petals", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_flower2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_flower2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gardenbox_flower3", {Ingredient("petals", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_flower3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_flower3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gardenbox_rose", {Ingredient("petals", 2), Ingredient("stinger", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_rose_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_rose.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gardenbox_evil1", {Ingredient("petals_evil", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_evil1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_evil1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gardenbox_evil2", {Ingredient("petals_evil", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_evil2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_evil2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gardenbox_succulent1", {Ingredient("succulent_picked", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_succulent1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_succulent1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gardenbox_succulent2", {Ingredient("succulent_picked", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_succulent2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_succulent2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gardenbox_empty", {Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_empty_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_empty.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_farmrock", {Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_farmrock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_farmrock.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_farmrocktall", {Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_farmrocktall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_farmrocktall.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_farmrockflat", {Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_farmrockflat_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_farmrockflat.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_stick", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_stick_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_stick.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_stickleft", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_stickleft_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_stickleft.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_stickright", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_stickright_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_stickright.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_signleft", {Ingredient("minisign_item", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_signleft_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_signleft.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_fencepost", {Ingredient("fence_item", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_fencepost_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_fencepost.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_fencepostright", {Ingredient("fence_item", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_fencepostright_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_fencepostright.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_burntstick", {Ingredient("twigs", 1), Ingredient("charcoal", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_burntstick_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_burntstick.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_burntstickleft", {Ingredient("twigs", 1), Ingredient("charcoal", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_burntstickleft_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_burntstickleft.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_burntstickright", {Ingredient("twigs", 1), Ingredient("charcoal", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_burntstickright_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_burntstickright.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_burntfencepost", {Ingredient("fence_item", 1), Ingredient("charcoal", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_burntfencepost_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_burntfencepost.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_p_burntfencepostright", {Ingredient("fence_item", 1), Ingredient("charcoal", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p_burntfencepostright_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p_burntfencepostright.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_touchstone", {Ingredient("rocks", 3), Ingredient("marble", 3), Ingredient("nightmarefuel", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_touchstone_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_touchstone.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_portalstone", {Ingredient("cutstone", 2), Ingredient("nightmarefuel", 4), Ingredient("petals", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_portalstone_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_floridpostern.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_portalbuilding", {Ingredient("multiplayer_portal_moonrock_constr_plans", 1), Ingredient("nightmarefuel", 4), Ingredient("petals", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_portalbuilding_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_portalbuilding.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_celestialportal", {Ingredient("purplemooneye", 1), Ingredient("nightmarefuel", 4), Ingredient("moonrocknugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_celestialportal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_celestialportal.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_lake", {Ingredient("ice", 4), Ingredient("pondfish", 2), Ingredient("turf_desertdirt", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lake_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lake.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pond", {Ingredient("ice", 3), Ingredient("pondfish", 2), Ingredient("froglegs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pond_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pond.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pondmarsh", {Ingredient("ice", 3), Ingredient("pondfish", 2), Ingredient("mosquito", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pondmarsh_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pondmarsh.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_pondlava", {Ingredient("ice", 3), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pondlava_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pondmagma.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_hotspring", {Ingredient("moonglass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_hotspring_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hotspring.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_basalt1", {Ingredient("rocks", 3), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_basalt1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_basalt1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_basalt2", {Ingredient("rocks", 3), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_basalt2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_basalt2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_basalt4", {Ingredient("rocks", 3), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_basalt4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_basalt4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_basalt3", {Ingredient("rocks", 3), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_basalt3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_basalt3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_driftwood_small1", {Ingredient("driftwood_log", 1), Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_driftwood1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_driftwood1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_driftwood_small2", {Ingredient("driftwood_log", 1), Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_driftwood2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_driftwood2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_driftwood_tall", {Ingredient("driftwood_log", 2), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_driftwood3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_driftwood3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_houndbone", {Ingredient("boneshard", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_houndbone_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bones.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_bonemound", {Ingredient("boneshard", 1), Ingredient("houndstooth", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_houndmound_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bonemound.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_dead_sea_bones", {Ingredient("boneshard", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_seabones_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_seabones.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_skeleton", {Ingredient("boneshard", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_skeleton_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_skeleton.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_skeleton2", {Ingredient("boneshard", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_skeleton2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_skeleton2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_scorchedskeleton", {Ingredient("boneshard", 1), Ingredient("charcoal", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_scorchedskeleton_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_crispyskeleton.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carcass_koalefant", {Ingredient("boneshard", 5)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_carcass_koalefant_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_carcass_koalefant.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_mound", {Ingredient("boneshard", 1), Ingredient(_G.CHARACTER_INGREDIENT.SANITY, 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mound_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_mound.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gravestone1", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gravestone1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gravestone1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gravestone2", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gravestone2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gravestone2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gravestone3", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gravestone3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gravestone3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gravestone4", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gravestone4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gravestone4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_wormhole", {Ingredient("houndstooth", 2), Ingredient("meat", 2), Ingredient(_G.CHARACTER_INGREDIENT.SANITY, 15)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wormhole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wormhole.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_wormhole_sick", {Ingredient("houndstooth", 2), Ingredient("monstermeat", 2), Ingredient(_G.CHARACTER_INGREDIENT.SANITY, 15)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wormhole_sick_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wormhole_sick.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sunkenchest", {Ingredient("goldnugget", 2), Ingredient("slurtle_shellpieces", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sunkenchest.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sunkchest", {Ingredient("goldnugget", 8), Ingredient("slurtle_shellpieces", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sunkchest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_sunkchest2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("shell_cluster", {Ingredient("singingshell_octave3", 1, TapBuildingAtlas2), Ingredient("singingshell_octave4", 1, TapBuildingAtlas2), Ingredient("singingshell_octave5", 1, TapBuildingAtlas2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shellcluster.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("oceanfishableflotsam", {Ingredient("poop", 1), Ingredient("cutgrass", 1), Ingredient("kelp", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_oceandebris_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_oceandebris.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonfissure", {Ingredient("moonrocknugget", 1), Ingredient("nightmarefuel", 2), Ingredient(_G.CHARACTER_INGREDIENT.SANITY, 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonfissure_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonfissure.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonfissure_plugged", {Ingredient("moonrocknugget", 2), Ingredient("slurtle_shellpieces", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonfissure_plugged_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonfissure_plugged.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_meatrack_hermit", {Ingredient("twigs", 3), Ingredient("moon_tree_blossom", 2), Ingredient("rope", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_meatrack_hermit_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_meatrack_hermit.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_beebox_hermit", {Ingredient("moon_tree_blossom", 4), Ingredient("honeycomb", 1), Ingredient("bee", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_beebox_hermit_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_beebox_hermit.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_hermithouse1", {Ingredient("rocks", 3), Ingredient("log", 3), Ingredient("slurtle_shellpieces", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_hermithouse1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hermithouse1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_hermithouse2", {Ingredient("cookiecuttershell", 2), Ingredient("boards", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_hermithouse2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hermithouse2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_hermithouse3", {Ingredient("marble", 3), Ingredient("rope", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_hermithouse3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hermithouse3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_hermithouse4", {Ingredient("moonrocknugget", 3), Ingredient("cactus_flower", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_hermithouse4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_hermithouse4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_propsign_structure", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_propsign_structure_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_propsign.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gingerbreadhouse1", {Ingredient("crumbs", 5), Ingredient("wintersfeastfuel", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gingerbreadhouse1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gingerbreadhouse1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gingerbreadhouse2", {Ingredient("crumbs", 5), Ingredient("wintersfeastfuel", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gingerbreadhouse2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gingerbreadhouse2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gingerbreadhouse3", {Ingredient("crumbs", 5), Ingredient("wintersfeastfuel", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gingerbreadhouse3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gingerbreadhouse3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_gingerbreadhouse4", {Ingredient("crumbs", 5), Ingredient("wintersfeastfuel", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gingerbreadhouse4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gingerbreadhouse4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_clayhound", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_clayhound_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_clayhound.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_claywarg", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_claywarg_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_claywarg.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_silktent", {Ingredient("silk", 4), Ingredient("twigs", 4), Ingredient("rope", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_silktent_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_silktent.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_furtent", {Ingredient("beefalowool", 4), Ingredient("twigs", 4), Ingredient("rope", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_furtent_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_furtent.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_tentacletent", {Ingredient("tentaclespots", 4), Ingredient("twigs", 4), Ingredient("rope", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tentacletent_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_tentacletent.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_tikitent", {Ingredient("manrabbit_tail", 4), Ingredient("twigs", 4), Ingredient("rope", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tikitent_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_tikitent.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_accomplishment_shrine", {Ingredient("goldnugget", 5), Ingredient("cutstone", 1), Ingredient("gears", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_accomplishment_shrine_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_trophy.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_teleporter_rog", {Ingredient("boards", 1), Ingredient("cutstone", 1), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_teleporter_rog_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_maxwellportal_vanilla.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_teleporter_adventure", {Ingredient("boards", 1), Ingredient("nightmarefuel", 2), Ingredient("gears", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_teleporter_adventure_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_maxwellportal_rog.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_reed_item", {Ingredient("cutreeds", 4), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_reed_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_bone_item", {Ingredient("boneshard", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_bone_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_living_item", {Ingredient("wall_stone_item", 2), Ingredient("tentaclespots", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_living_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_mud_item", {Ingredient("wall_hay_item", 2), Ingredient("poop", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_mud_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_block_item", {Ingredient("wall_hay_item", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_block_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_block_aged_item", {Ingredient("wall_hay_item", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_block_aged_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_cone_item", {Ingredient("wall_hay_item", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_cone_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_cone_aged_item", {Ingredient("wall_hay_item", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_cone_aged_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_layered_item", {Ingredient("wall_hay_item", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_layered_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_layered_aged_item", {Ingredient("wall_hay_item", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_layered_aged_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_block_pink_item", {Ingredient("foliage", 1), Ingredient("wall_hay_item", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_block_pink_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_block_pink_aged_item", {Ingredient("foliage", 1), Ingredient("wall_hay_item", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_block_pink_aged_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_cone_pink_item", {Ingredient("foliage", 1), Ingredient("wall_hay_item", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_cone_pink_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_cone_pink_aged_item", {Ingredient("foliage", 1), Ingredient("wall_hay_item", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_cone_pink_aged_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_layered_pink_item", {Ingredient("foliage", 1), Ingredient("wall_hay_item", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_layered_pink_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("wall_hedge_layered_pink_aged_item", {Ingredient("foliage", 1), Ingredient("wall_hay_item", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_hedge_layered_pink_aged_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_biigfoot_footprint", {Ingredient("turf_mud", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_biigfoot_footprint_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_biigfoot_footprint.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_biigfoot", {Ingredient("meat", 10), Ingredient("dragon_scales", 1), Ingredient("boneshard", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_biigfoot_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_biigfoot.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_waxwelldoor", {Ingredient("boards", 2), Ingredient("cutstone", 2), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_waxwelldoor_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_waxwelldoor.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_trap_teeth_maxwell", {Ingredient("marble", 1), Ingredient("houndstooth", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_trap_teeth_maxwell_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_trapteeth.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_waxwelltorch", {Ingredient("marble", 2), Ingredient("charcoal", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_waxwelltorch_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_waxwelltorch.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_adventurelock", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_adventurelock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_adventurelock.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_waxwelllock", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 2), Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_waxwelllock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_waxwelllock.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_nightmarethrone", {Ingredient("nightmarefuel", 10), Ingredient(_G.CHARACTER_INGREDIENT.HEALTH, 50)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nightmarethrone_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_nightmarethrone.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_maxwellthrone", {Ingredient("nightmarefuel", 10), Ingredient("meat", 2), Ingredient("reviver", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_maxwellthrone_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_maxwellthrone.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moondevice_stage1", {Ingredient("cutstone", 2), Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moondevice_stage1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moondevice1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moondevice_stage2", {Ingredient("cutstone", 2), Ingredient("goldnugget", 4), Ingredient("transistor", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moondevice_stage2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moondevice2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moondevice_stage3", {Ingredient("cutstone", 2), Ingredient("goldnugget", 4), Ingredient("moonglass", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moondevice_stage3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moondevice3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_lunarextractor", {Ingredient("cutstone", 2), Ingredient("moonglass_charged", 2), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lunarextractor_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_contained.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonglass_tile", {Ingredient("moonglass_charged", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonglass_tile_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonglass_tile.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonstorm_lightning", {Ingredient("moonglass_charged", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonstorm_lightning_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonstorm_lightning.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moonstorm_lightning2", {Ingredient("moonglass_charged", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_moonstorm_lightning2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_moonstorm_lightning2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_defeated_cc1", {Ingredient("moonrocknugget", 3)}, TECH.MAGIC_THREE,
	{
		placer			= "kyno_defeated_cc1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_defeated_cc1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_defeated_cc2", {Ingredient("moonrocknugget", 3)}, TECH.MAGIC_THREE,
	{
		placer			= "kyno_defeated_cc2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_defeated_cc2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_defeated_cc4", {Ingredient("moonrocknugget", 2), Ingredient("moonglass", 2), Ingredient("alterguardianhat", 1)}, TECH.MAGIC_THREE,
	{
		placer			= "kyno_defeated_cc4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_defeated_cc4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_defeated_cc3", {Ingredient("moonrocknugget", 2), Ingredient("moonglass", 2)}, TECH.MAGIC_THREE,
	{
		placer			= "kyno_defeated_cc3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_defeated_cc3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_yotb_rug", {Ingredient("beefalowool", 2), Ingredient("silk", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_yotb_rug_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_yotb_rug.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_yotc_rug", {Ingredient("carrot", 2), Ingredient("silk", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_yotc_rug_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_yotc_rug.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_oaktree", {Ingredient("log", 3), Ingredient("acorn", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_oaktree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_oaktree.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_tree", {Ingredient("carnival_plaza_kit", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_tree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_tree.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_tree_natural", {Ingredient("acorn", 1), Ingredient("log", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_tree_natural_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_tree_natural.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_tree_noleaf", {Ingredient("acorn", 1), Ingredient("log", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_tree_noleaf_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_tree_noleaf.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_tree_floor", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_tree_floor_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_tree_floor.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_memory_station", {Ingredient("carnivalgame_memory_kit", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_memory_station_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_memory_station.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_memory_bad", {Ingredient("bird_egg", 1), Ingredient("boards", 1), Ingredient("cutgrass", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_memory_bad_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_memory_bad.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_memory_good", {Ingredient("bird_egg", 1), Ingredient("boards", 1), Ingredient("cutgrass", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_memory_good_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_memory_good.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_memory_floor", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_memory_floor_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_memory_floor.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_herding_station", {Ingredient("carnivalgame_herding_kit", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_herding_station_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_herding_station.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_herding_floor", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_herding_floor_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_herding_floor.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_herding_floor2", {Ingredient("log", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_herding_floor2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_herding_floor2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_feedchicks_station", {Ingredient("carnivalgame_feedchicks_kit", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_feedchicks_station_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_feedchicks_station.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_feedchicks_bird", {Ingredient("crow", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_feedchicks_bird_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_feedchicks_bird.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_carnival_feedchicks_floor", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_carnival_feedchicks_floor_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_carnival_feedchicks_floor.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_fig_vine", {Ingredient("cutgrass", 2), Ingredient("twigs", 2), Ingredient("fig", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_fig_vine_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_fig_vine.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_fig_vine_fallen", {Ingredient("cutgrass", 2), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_fig_vine_fallen_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_fig_vine_fallen.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_seastrider_nest", {Ingredient("silk", 4), Ingredient("cutgrass", 3), Ingredient("twigs", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_seastrider_nest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_seastrider_nest.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_monkeyisland_debris1", {Ingredient("cutstone", 1), Ingredient("gears", 1), Ingredient("trinket_6", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_monkeyisland_debris1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_monkeyisland_debris1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_monkeyisland_debris2", {Ingredient("cutstone", 1), Ingredient("gears", 1), Ingredient("trinket_6", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_monkeyisland_debris2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_monkeyisland_debris2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_monkeyisland_debris3", {Ingredient("cutstone", 1), Ingredient("gears", 1), Ingredient("trinket_6", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_monkeyisland_debris3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_monkeyisland_debris3.tex",
	},
	{"TAP_SURFACE"}
)
-- Finally using four ingredients!!
AddRecipe2("kyno_monkeyisland_hut", {Ingredient("palmcone_scale", 1), Ingredient("boards", 2), Ingredient("cutstone", 1), Ingredient("cave_banana", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_monkeyisland_hut_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_monkeyisland_hut.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_monkeyisland_hut_empty", {Ingredient("palmcone_scale", 1), Ingredient("boards", 2), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_monkeyisland_hut_empty_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_monkeyisland_hut.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_monkeyisland_pillar", {Ingredient("cutstone", 3), Ingredient("cave_banana", 2), Ingredient("lightbulb", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_monkeyisland_pillar_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_monkeyisland_pillar.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_monkeyisland_queen", {Ingredient("meat", 4), Ingredient("cave_banana", 6), Ingredient("reviver", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_monkeyisland_queen_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_monkeyisland_queen.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_monkeyisland_portal1", {Ingredient("cave_banana", 3), Ingredient("nightmarefuel", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_monkeyisland_portal1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_monkeyisland_portal1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_monkeyisland_portal2", {Ingredient("cave_banana", 3), Ingredient("nightmarefuel", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_monkeyisland_portal2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_monkeyisland_portal2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_theater_seat", {Ingredient("marble", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_theater_seat_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_theater_seat.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_theater_stage", {Ingredient("marble", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_theater_stage_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_theater_stage.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_theater_curtains", {Ingredient("marble", 2), Ingredient("petals", 2), Ingredient("stinger", 2), Ingredient("silk", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_theater_curtains_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_theater_curtains.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_theater_stageusher", {Ingredient("marble", 1), Ingredient("petals", 2), Ingredient("stinger", 2), Ingredient("turf_carpetfloor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_theater_stageusher_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_theater_stageusher.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_theater_lecturn", {Ingredient("marble", 1), Ingredient("petals", 2), Ingredient("stinger", 2), Ingredient("papyrus", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_theater_lecturn_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_theater_lecturn.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_theater_hedgehound", {Ingredient("dug_berrybush", 1), Ingredient("petals", 2), Ingredient("stinger", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_theater_hedgehound_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_theater_hedgehound.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_lunarrift_portal", {Ingredient("purebrilliance", 2), Ingredient("moonglass_charged", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lunarrift_portal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lunarrift_portal.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_lunarrift_crystal1", {Ingredient("purebrilliance", 2), Ingredient("moonglass_charged", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lunarrift_crystal1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lunarrift_crystal1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_lunarrift_crystal2", {Ingredient("purebrilliance", 1), Ingredient("moonglass_charged", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lunarrift_crystal2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_lunarrift_crystal2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_wagstaff_machinery", {Ingredient("cutstone", 1), Ingredient("transistor", 1), Ingredient("trinket_6", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wagstaff_machinery_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_wagstaff_machinery.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sharkboi_hole", {Ingredient("ice", 10), Ingredient("pondfish", 3)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_sharkboi_hole_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_sharkboi_hole.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sharkboi_icespike2", {Ingredient("ice", 3)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_sharkboi_icespike2_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_sharkboi_icespike2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_sharkboi_icespike4", {Ingredient("ice", 6)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_sharkboi_icespike4_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_sharkboi_icespike4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_junk_pile_big1", {Ingredient("wagpunk_bits", 2)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_junk_pile_big1_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_junk_pile_big1.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_junk_pile_big2", {Ingredient("wagpunk_bits", 2)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_junk_pile_big2_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_junk_pile_big2.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_junk_pile_big3", {Ingredient("wagpunk_bits", 2)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_junk_pile_big3_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_junk_pile_big3.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_junk_pile_big4", {Ingredient("wagpunk_bits", 2)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_junk_pile_big4_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_junk_pile_big4.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_junk_pile_big5", {Ingredient("wagpunk_bits", 2)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_junk_pile_big5_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_junk_pile_big5.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_junk_pile_big6", {Ingredient("wagpunk_bits", 2)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_junk_pile_big6_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_junk_pile_big6.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_junkfence_item", {Ingredient("wagpunk_bits", 2), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "kyno_junkfence_item.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_cachebox1_full", {Ingredient("wagpunk_bits", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_cachebox1_full_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_cachebox1_full.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_cachebox1_broken", {Ingredient("wagpunk_bits", 1), Ingredient("cutstone", 1), Ingredient("trinket_6", 1)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_cachebox1_broken_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_cachebox1_broken.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_cachebox2_full", {Ingredient("wagpunk_bits", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_cachebox2_full_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_cachebox2_full.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_cachebox2_broken", {Ingredient("wagpunk_bits", 1), Ingredient("cutstone", 1), Ingredient("trinket_6", 1)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_cachebox2_broken_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_cachebox2_broken.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_wagpunk_workstation", {Ingredient("wagpunk_bits", 4), Ingredient("cutstone", 2), Ingredient("trinket_6", 2)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_wagpunk_workstation_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_wagpunk_workstation.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_wagpunk_lever", {Ingredient("wagpunk_bits", 1), Ingredient("cutstone", 1), Ingredient("trinket_6", 1)}, TECH.SCIENCE_TWO,
	{
		placer          = "kyno_wagpunk_lever_placer",
		min_spacing     = 0,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_wagpunk_lever.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_saltstack", {Ingredient("rocks", 2), Ingredient("saltrock", 4)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_saltstack_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas,
		image           = "kyno_saltstack.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_wobster_den", {Ingredient("rocks", 4), Ingredient("wobster_sheller_land", 3)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_wobster_den_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_wobsterden.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_moon_wobster_den", {Ingredient("rocks", 4), Ingredient("moonglass", 2), Ingredient("wobster_moonglass_land", 3)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_moon_wobster_den_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_wobsterden_moon.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_watertree_root", {Ingredient("driftwood_log", 3)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_watertree_root_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_watertree_root.tex",
	},
	{"TAP_SURFACE"}
)

AddRecipe2("kyno_seastrider_nest_water", {Ingredient("silk", 4), Ingredient("cutgrass", 3), Ingredient("twigs", 3)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_seastrider_nest_water_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_seastrider_nest.tex",
	},
	{"TAP_SURFACE"}
)

-- The Caves Category.
AddRecipe2("cave_fern", {Ingredient("foliage", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_cavefern_placer",
		min_spacing		= 0,
		atlas			= TapDefaultAtlas,
		image			= "foliage.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("flower_withered", {Ingredient("cutgrass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flower_withered_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flowerwithered.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_plant_algae", {Ingredient("cutlichen", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_plant_algae_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_caveplant.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_gardenbox_fern1", {Ingredient("foliage", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_fern1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_fern1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_gardenbox_fern2", {Ingredient("foliage", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_fern2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_fern2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_gardenbox_fern3", {Ingredient("foliage", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_fern3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_fern3.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_gardenbox_withered", {Ingredient("cutgrass", 2), Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gardenbox_withered_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_gardenbox_withered.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_flowerlightone", {Ingredient("lightbulb", 1), Ingredient("poop", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flowerlightone_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flowerlightone.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_flowerlightspringy", {Ingredient("lightbulb", 1), Ingredient("poop", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flowerlightspringy_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flowerlightspringy.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_flowerlighttwo", {Ingredient("lightbulb", 2), Ingredient("poop", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flowerlighttwo_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flowerlighttwo.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_flowerlightthree", {Ingredient("lightbulb", 3), Ingredient("poop", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flowerlightthree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flowerlightthree.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_mushtree_medium", {Ingredient("log", 2), Ingredient("red_cap", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_redmushtree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_redmushtree.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_mushtree_small", {Ingredient("log", 2), Ingredient("green_cap", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_greenmushtree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_greenmushtree.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_mushtree_tall", {Ingredient("log", 2), Ingredient("blue_cap", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bluemushtree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bluemushtree.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_mushtree_tall_webbed", {Ingredient("log", 2), Ingredient("blue_cap", 1), Ingredient("silk", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_webbedmushtree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_webbedmushtree.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("mushtree_moon", {Ingredient("log", 2), Ingredient("moon_cap", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mushtree_moon_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_mushtree_moon.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_stump6", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump6_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump6.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_stump7", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump7_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump7.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_stump8", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump8_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump8.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_stump9", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stump9_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stump9.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_stalagmite_full", {Ingredient("rocks", 3), Ingredient("flint", 2), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stalagmitefull_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stalagmitefull.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_stalagmite_med", {Ingredient("rocks", 3), Ingredient("flint", 2), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stalagmitemed_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stalagmitemed.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_stalagmite_low", {Ingredient("rocks", 3), Ingredient("flint", 2), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stalagmitelow_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stalagmitelow.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_stalagmite_tall_full", {Ingredient("rocks", 3), Ingredient("flint", 2), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stalagmitetall_full_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stalagmitetall_full.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_stalagmite_tall_med", {Ingredient("rocks", 3), Ingredient("flint", 2), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stalagmitetall_med_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stalagmitetall_med.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_stalagmite_tall_low", {Ingredient("rocks", 3), Ingredient("flint", 2), Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stalagmitetall_low_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_stalagmitetall_low.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_rockyrock", {Ingredient("rocks", 4), Ingredient("meat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rockyrock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rockyrock.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_spiderhole", {Ingredient("rocks", 3), Ingredient("silk", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_spiderhole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_spiderhole.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_batiliskden", {Ingredient("guano", 3), Ingredient("batwing", 3), Ingredient("rocks", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_batiliskden_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_batiliskden.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pondcave", {Ingredient("ice", 4), Ingredient("eel", 2), Ingredient("cutlichen", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pondcave_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pondcave.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_nitre_formation", {Ingredient("nitre", 1)}, TECH.SCIENCE_TWO,
{
		placer			= "kyno_nitre_formation_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_nitre_formation.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_toadhole", {Ingredient("shovel", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_toadhole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_toadhole.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_toadstoolcap", {Ingredient("shroom_skin", 1), Ingredient("green_cap", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_toadstoolcap_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_toadstoolcap.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_toadstoolcap_dark", {Ingredient("shroom_skin", 1), Ingredient("green_cap", 3), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_toadstoolcap_dark_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_toadstoolcap_dark.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_sporecap", {Ingredient("green_cap", 2), Ingredient("log", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sporecap_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sporecap.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_sporecap_dark", {Ingredient("green_cap", 2), Ingredient("log", 2), Ingredient("spoiled_food", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sporecap_dark_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sporecap_dark.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_boomshroom", {Ingredient("green_cap", 2), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_boomshroom_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_boomshroom.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_boomshroom_dark", {Ingredient("blue_cap", 2), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_boomshroom_dark_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_boomshroom_dark.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_sporecloud", {Ingredient("spoiled_food", 2), Ingredient("spore_small", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sporecloud_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sporecloud.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_tentaclehole", {Ingredient("tentaclespots", 2), Ingredient("rocks", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tentaclehole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_tentaclehole.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_bigtentacle", {Ingredient("tentaclespots", 2), Ingredient("tentaclespike", 1), Ingredient("rocks", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bigtentacle_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bigtentacle.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_nightmarefissure", {Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nightmarefissure_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_nightmarefissure.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_nightmarefissure_ruins", {Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nightmarefissure_ruins_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_nightmarefissure_ruins.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_slurtlehole", {Ingredient("slurtle_shellpieces", 2), Ingredient("slurtleslime", 2), Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_slurtlehole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_slurtlehole.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_wormlight", {Ingredient("wormlight_lesser", 1), Ingredient("poop", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wormlight_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wormlight.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_wormlight_real", {Ingredient("wormlight", 1), Ingredient("poop", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wormlight_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wormlight.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_molebathill", {Ingredient("cutgrass", 3), Ingredient("poop", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_molebathill_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_molebathill.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("cavein_boulder2", {Ingredient("rocks", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		product         = "cavein_boulder",
		atlas			= TapDefaultAtlas,
		image			= "cavein_boulder.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_ruinshole", {Ingredient("shovel", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruinshole_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_caveholeitems.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_lichenplant", {Ingredient("cutlichen", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lichenplant_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lichenplant.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_cave_banana_tree", {Ingredient("cave_banana", 3), Ingredient("log", 2), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bananatree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bananatree.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_monkeybarrel", {Ingredient("cave_banana", 2), Ingredient("log", 4), Ingredient("poop", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_monkeybarrel_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_splumonkeypod.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_ruinsbowl", {Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruinsbowl_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruinsbowl.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_ruinschair", {Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruinschair_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruinschair.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_ruinschipbowl", {Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruinschipbowl_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruinschipbowl.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_ruinsplate", {Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruinsplate_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruinsplate.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_ruinstable", {Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruinstable_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruinstable.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_ruinsvase", {Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruinsvase_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruinsvase.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_sinkhole_ruins", {Ingredient("thulecite_pieces", 6)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sinkhole_ruins_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sinkhole_ruins.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_nogem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_nogem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_nogem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_bluegem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("bluegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_bluegem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_bluegem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_redgem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_redgem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_redgem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_purplegem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("purplegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_purplegem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_purplegem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_orangegem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("orangegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_orangegem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_orangegem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_yellowgem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("yellowgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_yellowgem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_yellowgem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_greengem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("greengem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_greengem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_greengem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_small_nogem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_small_nogem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_small_nogem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_small_bluegem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("bluegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_small_bluegem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_small_bluegem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_small_redgem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_small_redgem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_small_redgem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_small_purplegem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("purplegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_small_purplegem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_small_purplegem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_small_orangegem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("orangegem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_small_orangegem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_small_orangegem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_small_yellowgem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("yellowgem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_small_yellowgem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_small_yellowgem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueruins_small_greengem", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2), Ingredient("greengem", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueruins_small_greengem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueruins_small_greengem.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_ruinsnightmarelight", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 3), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruinsnightmarelight_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ruinsnightmarelight.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_brokenclockwork1", {Ingredient("gears", 1), Ingredient("trinket_6", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_brokenclockwork1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_brokenclockwork1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_brokenclockwork2", {Ingredient("gears", 1), Ingredient("trinket_6", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_brokenclockwork2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_brokenclockwork2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_brokenclockwork3", {Ingredient("gears", 1), Ingredient("trinket_6", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_brokenclockwork3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_brokenclockwork3.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_ornatechest", {Ingredient("boards", 1), Ingredient("thulecite", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ornatechest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ornatechest.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_ornatechest_large", {Ingredient("boards", 2), Ingredient("thulecite", 3)}, TECH.MAGIC_THREE,
	{
		placer			= "kyno_ornatechest_large_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ornatechest_large.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_ancient_altar_broken", {Ingredient("thulecite", 24), Ingredient("purplegem", 2), Ingredient("minotaurhorn", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ancient_altar_broken_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_apss_broken.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_stafflight", {Ingredient("yellowstaff", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_stafflight_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_endlessstafflight.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_staffcoldlight", {Ingredient("opalstaff", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_staffcoldlight_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_endlessstaffcoldlight.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_rock_minotaur1", {Ingredient("rocks", 2), Ingredient("thulecite", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock_minotaur1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rock_minotaur1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_rock_minotaur2", {Ingredient("rocks", 2), Ingredient("thulecite", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock_minotaur2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rock_minotaur2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_rock_minotaur3", {Ingredient("rocks", 2), Ingredient("thulecite", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock_minotaur3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rock_minotaur3.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_rock_minotaur4", {Ingredient("rocks", 2), Ingredient("thulecite", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rock_minotaur4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_rock_minotaur4.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_stalactite", {Ingredient("rocks", 4), Ingredient("flint", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_stalactite_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_stalactite.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_cave", {Ingredient("rocks", 4), Ingredient("flint", 4), Ingredient("nitre", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_cave_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_cave.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_flintless", {Ingredient("rocks", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_flintless_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_flintless.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_rock", {Ingredient("rocks", 4), Ingredient("flint", 4), Ingredient("nitre", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_rock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_rock.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_algae", {Ingredient("cutlichen", 4), Ingredient("slurtleslime", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_algae_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_algae.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_ruins", {Ingredient("thulecite_pieces", 4), Ingredient("thulecite", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_ruins_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_ruins.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_atrium", {Ingredient("rocks", 4), Ingredient("nightmarefuel", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_atrium_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_atrium.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_atrium_on", {Ingredient("rocks", 4), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_atrium_on_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_atrium_on.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_moon1", {Ingredient("moonglass", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_moon1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_moon1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_moon2", {Ingredient("moonglass", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_moon2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_moon2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_moon3", {Ingredient("moonglass", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_moon3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_moon3.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vitreoasis_small", {Ingredient("rocks", 5), Ingredient("moonglass", 5), Ingredient("ice", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vitreoasis_small_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_vitreoasis_small.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vitreoasis2_small", {Ingredient("rocks", 5), Ingredient("ice", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vitreoasis2_small_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_vitreoasis2_small.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vitreoasis_big", {Ingredient("rocks", 10), Ingredient("moonglass", 10), Ingredient("ice", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vitreoasis_big_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_vitreoasis_big.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vitreoasis2_big", {Ingredient("rocks", 10), Ingredient("ice", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vitreoasis2_big_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_vitreoasis2_big.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_surfacestairs", {Ingredient("rocks", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_surfacestairs_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_surfacestairs.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_surfacestairs_closed", {Ingredient("rocks", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_surfacestairs_closed_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_surfacestairs_closed.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_shadowchanneler", {Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shadowchanneler_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shadowhand.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_statueatrium", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueatrium_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueatrium.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_atriumrubble1", {Ingredient("cutstone", 1), Ingredient("thulecite_pieces", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_atriumrubble1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_atriumrubble1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_atriumrubble2", {Ingredient("cutstone", 1), Ingredient("thulecite_pieces", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_atriumrubble2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_atriumrubble2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_atriumbeacon", {Ingredient("cutstone", 1), Ingredient("thulecite", 1), Ingredient("nightmarefuel", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_atriumbeacon_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_atriumbeacon.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_atriumobelisk", {Ingredient("cutstone", 2), Ingredient("thulecite", 3), Ingredient("nightmarefuel", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_atriumobelisk_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_atriumobelisk.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_atriumfence", {Ingredient("cutstone", 1), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_atriumfence_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_atriumfence.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_atriumgateway", {Ingredient("thulecite", 5), Ingredient("nightmarefuel", 5), Ingredient("cutstone", 2)}, TECH.MAGIC_THREE,
	{
		placer			= "kyno_atriumgateway_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ancientgateway.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_atriumfloor", {Ingredient("thulecite", 2), Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_atriumfloor_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_atriumfloor.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_nightmareobelisk", {Ingredient("cutstone", 2), Ingredient("nightmarefuel", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_nightmareobelisk_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_nightmareobelisk.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_chandelier", {Ingredient("moonrocknugget", 2), Ingredient("thulecite", 2), Ingredient("torch", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_chandelier_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_chandelier.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_chandelier_ground", {Ingredient("moonrocknugget", 2), Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_chandelier_ground_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_chandelier_ground.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_centipede", {Ingredient("thulecite", 2), Ingredient("gears", 1), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_centipede_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_centipede.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_archive", {Ingredient("thulecite", 5), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_archive_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_archive.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_pillar_archive_broken", {Ingredient("thulecite", 3), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pillar_archive_broken_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pillar_archive_broken.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_statue1", {Ingredient("thulecite", 2), Ingredient("moonrocknugget", 1), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_statue1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_statue1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_statue2", {Ingredient("thulecite", 2), Ingredient("moonrocknugget", 1), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_statue2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_statue2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_statue3", {Ingredient("thulecite", 2), Ingredient("moonrocknugget", 1), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_statue3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_statue3.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_statue4", {Ingredient("thulecite", 2), Ingredient("moonrocknugget", 1), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_statue4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_statue4.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_rune1", {Ingredient("moonrocknugget", 2), Ingredient("thulecite_pieces", 2), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_rune1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_rune1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_rune2", {Ingredient("moonrocknugget", 2), Ingredient("thulecite_pieces", 2), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_rune2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_rune2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_rune3", {Ingredient("moonrocknugget", 2), Ingredient("thulecite_pieces", 2), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_rune3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_rune3.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_desk", {Ingredient("thulecite", 3), Ingredient("moonrocknugget", 3), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_desk_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_desk.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_fountain1", {Ingredient("thulecite", 2), Ingredient("moonrocknugget", 2), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_fountain1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_fountain1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_fountain2", {Ingredient("thulecite", 2), Ingredient("moonrocknugget", 2), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_fountain2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_fountain2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_fountain3", {Ingredient("thulecite", 2), Ingredient("moonrocknugget", 2), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_fountain3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_fountain3.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_fountain4", {Ingredient("thulecite", 2), Ingredient("moonrocknugget", 2), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_fountain4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_archive_fountain4.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_fountain5", {Ingredient("thulecite", 2), Ingredient("moonrocknugget", 2), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_fountain5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_archive_fountain5.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_dustmothden", {Ingredient("moonrocknugget", 2), Ingredient("thulecite_pieces", 2), Ingredient("dustmeringue", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_dustmothden_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_dustmothden.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("archive_cookpot", {Ingredient("moonrocknugget", 3), Ingredient("charcoal", 6), Ingredient("thulecite", 6)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_cookpot_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_cookpot.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_switch", {Ingredient("thulecite", 3), Ingredient("moonrocknugget", 1), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_switch_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_switch.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_portal", {Ingredient("thulecite", 3), Ingredient("moonrocknugget", 3), Ingredient("nightmarefuel", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_portal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_portal.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_orchestrina_main", {Ingredient("thulecite", 5), Ingredient("moonrocknugget", 5), Ingredient("archive_lockbox", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_orchestrina_main_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_orchestrina.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_archive_orchestrina_small", {Ingredient("thulecite", 2), Ingredient("moonrocknugget", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_archive_orchestrina_small_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_archive_orchestrina_small.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_daywalker_pillar", {Ingredient("marble", 6), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_daywalker_pillar_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_daywalker_pillar.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_daywalker_stump", {Ingredient("marble", 2), Ingredient("nightmarefuel", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_daywalker_stump_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_daywalker_stump.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_charlie_npc", {Ingredient("feather_robin", 1), Ingredient("shadowheart", 1), Ingredient("nightmarefuel", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_charlie_npc_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_charlie_npc.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_shadowrift_portal", {Ingredient("dreadstone", 2), Ingredient("horrorfuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shadowrift_portal_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_shadowrift_portal.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_dreadstone_stack", {Ingredient("dreadstone", 2), Ingredient("horrorfuel", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_dreadstone_stack_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_dreadstone_stack.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("cave_fern_withered", {Ingredient("cutgrass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_cave_fern_withered_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_cave_fern_withered.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("flower_cave_withered", {Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flower_cave_withered_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_flower_cave_withered.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("flower_cave_double_withered", {Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flower_cave_double_withered_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_flower_cave_double_withered.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("flower_cave_triple_withered", {Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flower_cave_triple_withered_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_flower_cave_triple_withered.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("cave_vent_rock", {Ingredient("rocks", 4)}, TECH.SCIENCE_TWO,
{
		placer			= "kyno_cave_vent_rock_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_cave_vent_rock.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_chasm", {Ingredient("rocks", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_chasm_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_chasm.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_chandelier_broken", {Ingredient("thulecite", 1), Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_chandelier_broken_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_chandelier_broken.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_teleporter", {Ingredient("thulecite_pieces", 2), Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_teleporter_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_teleporter.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_teleporter_construction", {Ingredient("thulecite_pieces", 2), Ingredient("moonrocknugget", 1), Ingredient("sewing_tape", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_teleporter_construction_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_teleporter_construction.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_lever", {Ingredient("thulecite", 1), Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_lever_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_lever.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_minion1", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_minion1_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_minion1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_minion2", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_minion2_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_minion2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_rune1", {Ingredient("thulecite", 1), Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_rune1_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_rune1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_rune2", {Ingredient("thulecite", 1), Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_rune2_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_rune2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_ancient1", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_ancient1_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_ancient1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_ancient2", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_ancient2_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_ancient2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_ancient3", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_ancient3_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_ancient3.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_ancient4", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_ancient4_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_ancient4.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_bug1", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_bug1_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_bug1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_bug2", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_bug2_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_bug2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_bug3", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_bug3_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_bug3.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_gate", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_gate_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_gate.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_guard1", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_guard1_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_guard1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_guard2", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_guard2_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_guard2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_guard3", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_guard3_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_guard3.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_king", {Ingredient("thulecite", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_king_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_king.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_vase1", {Ingredient("thulecite_pieces", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_vase1_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_vase1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_vase1b", {Ingredient("thulecite_pieces", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_vase1b_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_vase1b.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_vase2", {Ingredient("thulecite_pieces", 1), Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_vase2_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_vase2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_vase2b", {Ingredient("thulecite_pieces", 1), Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_vase2b_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_vase2b.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_vase3", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_vase3_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_vase3.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_statue_vase3b", {Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_statue_vase3b_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_statue_vase3b.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_table1", {Ingredient("boards", 1), Ingredient("thulecite", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_table1_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_table1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_table2", {Ingredient("boards", 1), Ingredient("thulecite", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_table2_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_table2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_stool1", {Ingredient("thulecite", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_stool1_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_stool1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_stool2", {Ingredient("thulecite", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_stool2_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_stool2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_ancienthusk1", {Ingredient("thulecite", 2), Ingredient("boneshard", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_ancienthusk1_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_ancienthusk1.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_ancienthusk2", {Ingredient("thulecite", 2), Ingredient("boneshard", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_ancienthusk2_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_ancienthusk2.tex",
	},
	{"TAP_CAVES"}
)

AddRecipe2("kyno_vault_ancienthusk3", {Ingredient("thulecite", 2), Ingredient("boneshard", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_vault_ancienthusk3_placer",
		min_spacing     = 0,
		atlas			= TapBuildingAtlas2,
		image           = "kyno_vault_ancienthusk3.tex",
	},
	{"TAP_CAVES"}
)

-- Legacy Category.
AddRecipe2("kyno_diseased_grass", {Ingredient("dug_grass", 1), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_diseased_grass_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_diseased_grass.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_diseased_sapling", {Ingredient("dug_sapling", 1), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_diseased_sapling_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_diseased_sapling.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_diseased_berrybush", {Ingredient("dug_berrybush", 1), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_diseased_berrybush_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_diseased_berrybush.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_diseased_berrybush2", {Ingredient("dug_berrybush2", 1), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_diseased_berrybush2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_diseased_berrybush2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_diseased_juicyberrybush", {Ingredient("dug_berrybush_juicy", 1), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_diseased_berrybush_juicy_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_diseased_berrybush_juicy.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_diseased_moonsapling", {Ingredient("dug_sapling_moon", 1), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_diseased_moonsapling_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_diseased_moonsapling.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_diseased_stonebush", {Ingredient("dug_rock_avocado_bush", 1), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_diseased_stonebush_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_diseased_stonebush.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_twiggyd_short", {Ingredient("log", 2), Ingredient("spoiled_food", 1), Ingredient("twiggy_nut", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_twiggyd_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_twiggyd_short.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_twiggyd_old", {Ingredient("log", 1), Ingredient("spoiled_food", 1), Ingredient("twiggy_nut", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_twiggyd_old_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_twiggyd_old.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_legacytwiggy_short", {Ingredient("log", 2), Ingredient("twiggy_nut", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_legacytwiggy_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacytwiggy.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_legacytwiggy_old", {Ingredient("log", 1), Ingredient("twiggy_nut", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_legacytwiggy_old_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacytwiggy_diseased_old.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_legacytwiggy_diseased_short", {Ingredient("log", 2), Ingredient("spoiled_food", 1), Ingredient("twiggy_nut", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_legacytwiggy_diseased_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacytwiggy_diseased.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_legacytwiggy_diseased_old", {Ingredient("log", 2), Ingredient("spoiled_food", 1), Ingredient("twiggy_nut", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_legacytwiggy_diseased_old_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacytwiggy_diseased_old.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_sinkhole_vip", {Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sinkhole_vip_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sinkholevip.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_statueangel", {Ingredient("marble", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_statueangel_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_statueangel.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_skullstick", {Ingredient("boneshard", 2), Ingredient("twigs", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_skullstick_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_skullstick.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_friendomatic", {Ingredient("boards", 2), Ingredient("nightmarefuel", 2), Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_friendomatic_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_friendomatic.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_skullchest", {Ingredient("boards", 3), Ingredient("boneshard", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_skullchest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_skullchest.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_sunkboat", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sunkboat_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sunkboat.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_sunkboat2", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_sunkboat2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_sunkboat2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_boatbarrel", {Ingredient("boards", 2), Ingredient("oar", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_boatbarrel_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_boatbarrel.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_boatbarrel2", {Ingredient("boards", 2), Ingredient("oar", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_boatbarrel2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_boatbarrel2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_propelomatic", {Ingredient("gears", 1), Ingredient("cutstone", 1), Ingredient("horn", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_propelomatic_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_propelomatic.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_legacyboulder6", {Ingredient("marble", 3), Ingredient("rocks", 2), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_legacyboulder6_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacyboulder6.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_legacyboulder3", {Ingredient("rocks", 3), Ingredient("nitre", 2), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_legacyboulder3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacyboulder3.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_legacyboulder4", {Ingredient("rocks", 3), Ingredient("nitre", 2), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_legacyboulder4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacyboulder4.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_legacyboulder5", {Ingredient("rocks", 3), Ingredient("moonrocknugget", 2), Ingredient("flint", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_legacyboulder5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacyboulder5.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_white_moonrock", {Ingredient("rocks", 3), Ingredient("moonrocknugget", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_white_moonrock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_whitemoonrock.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("wall_legacy_moonrock_item", {Ingredient("moonrocknugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapInventoryAtlas,
		image			= "wall_legacy_moonrock_item.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("wall_ice_item", {Ingredient("ice", 6)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wall_ice.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_juryriggedportal", {Ingredient("cutstone", 2), Ingredient("boards", 2), Ingredient("nightmarefuel", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_juryriggedportal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_juryrigged.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_shopkeeper1", {Ingredient("umbrella", 1), Ingredient("trunkvest_summer", 1), Ingredient("reviver", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shopkeeper1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shopkeeper1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_shopkeeper2", {Ingredient("boards", 1), Ingredient("reflectivevest", 1), Ingredient("reviver", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_shopkeeper2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shopkeeper2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_catapult_broken", {Ingredient("sewing_tape", 1), Ingredient("twigs", 3), Ingredient("rocks", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_catapult_broken_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_catapult_broken.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_homesign_old", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_homesign_old_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_homesign_old.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_bonfire", {Ingredient("log", 2), Ingredient("cutgrass", 3), Ingredient("charcoal", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bonfire_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bonfire.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_gunpowderbarrel", {Ingredient("gunpowder", 2), Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_gunpowderbarrel_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_powderbarrel.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_unbuilthouse", {Ingredient("boards", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_unbuilthouse_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_unbuilt.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_snowman", {Ingredient("ice", 4), Ingredient("carrot", 1), Ingredient("tophat", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_snowman_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_snowman.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_bucket", {Ingredient("boards", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bucket_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bucket.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_bags", {Ingredient("rope", 1), Ingredient("cutgrass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bags_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bag.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_scarecrow", {Ingredient("strawhat", 1), Ingredient("cutgrass", 3), Ingredient("twigs", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_scarecrow_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_scarecrow.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wheatplant", {Ingredient("dug_grass", 1), Ingredient("seeds", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wheatplant_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wheatplant.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_minitree", {Ingredient("log", 1), Ingredient("cutgrass", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_minitree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_minitree.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_legacymarsh", {Ingredient("dug_grass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_legacymarsh_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacymarsh.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_mudclod", {Ingredient("cutgrass", 1), Ingredient("cutreeds", 1), Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mudclod_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_mudclod.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_beefalo_vomit", {Ingredient("phlegm", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_beefalo_vomit_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_beefalo_vomit.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_treeclump", {Ingredient("log", 10), Ingredient("pinecone", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_treeclump_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_treeclump.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_driftwoodtrunk", {Ingredient("driftwood_log", 3), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_driftwoodtrunk_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_driftwoodtrunk.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_bbq", {Ingredient("log", 2), Ingredient("rocks", 12), Ingredient("meat", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bbq_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bbq.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_teslapost", {Ingredient("lantern", 1), Ingredient("gears", 1), Ingredient("transistor", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_teslapost_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_teslapost.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_lightning_catcher", {Ingredient("messagebottleempty", 1), Ingredient("lightninggoathorn", 1), Ingredient("transistor", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lightning_catcher_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lightningcatcher.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_tornadohazard", {Ingredient("goose_feather", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tornadohazard_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_tornadohazard.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_truffles", {Ingredient("blue_cap", 2), Ingredient("green_cap", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_truffles_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_truffles.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_shadowportal", {Ingredient("livinglog", 4), Ingredient("nightmarefuel", 4), Ingredient("purplegem", 1)}, TECH.MAGIC_THREE,
	{
		placer			= "kyno_shadowportal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_shadowportal.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_lunar_energy_wip", {Ingredient("moonrocknugget", 2), Ingredient(_G.CHARACTER_INGREDIENT.SANITY, 65)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lunar_energy_wip_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lunar_energy_wip.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_lunar_energy", {Ingredient("moonrocknugget", 2), Ingredient(_G.CHARACTER_INGREDIENT.SANITY, 65)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lunar_energy_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lunar_energy.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_mooncrater_1", {Ingredient("moonrocknugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mooncrater_1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_mooncrater_1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_mooncrater_2", {Ingredient("moonrocknugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mooncrater_2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_mooncrater_2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_mooncrater_3", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mooncrater_3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_mooncrater_3.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_mooncrater_4", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mooncrater_4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_mooncrater_4.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_mooncrater_5", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mooncrater_5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_mooncrater_5.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_mooncrater_6", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mooncrater_6_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_mooncrater_6.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_mooncrater_7", {Ingredient("moonrocknugget", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mooncrater_7_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_mooncrater_7.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_tumbleweed_ice", {Ingredient("ice", 3), Ingredient("twigs", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_tumbleweed_ice_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_tumbleweed_ice.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_megachest", {Ingredient("boards", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_megachest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_megachest.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_maptable", {Ingredient("log", 6), Ingredient("cutstone", 2), Ingredient("mapscroll", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_maptable_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_maptable.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_pyrenest", {Ingredient("log", 4), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pyrenest_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pyrenest.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_thornbush1", {Ingredient("dug_marsh_bush", 1), Ingredient("petals", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_thornbush1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_thornbush1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_thornbush2", {Ingredient("dug_marsh_bush", 1), Ingredient("cutgrass", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_thornbush2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_thornbush2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_thornbush3", {Ingredient("dug_marsh_bush", 1), Ingredient("petals", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_thornbush3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_thornbush3.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wx_mech", {Ingredient("gears", 3), Ingredient("transistor", 2), Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wx_mech_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wx_mech.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_flowerlight_post1", {Ingredient("lightbulb", 3), Ingredient("fertilizer", 1), Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flowerlight_post1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flowerlight_post1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_flowerlight_post2", {Ingredient("lightbulb", 3), Ingredient("fertilizer", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flowerlight_post2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flowerlight_post2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wilsonhead", {Ingredient("beardhair", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wilsonhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			=  "kyno_wilsonhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_willowhead", {Ingredient("charcoal", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_willowhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_willowhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wolfganghead", {Ingredient("meatballs", 1), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wolfganghead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wolfganghead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wendyhead", {Ingredient("petals_evil", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wendyhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wendyhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wx78head", {Ingredient("gears", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wx78head_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wx78head.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wickerbottomhead", {Ingredient("papyrus", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wickerbottomhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wickerbottomhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_woodiehead", {Ingredient("log", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_woodiehead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_woodiehead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_weshead", {Ingredient("balloons_empty", 0), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_weshead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_weshead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_waxwellhead", {Ingredient("nightmarefuel", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_waxwellhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_waxwellhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wagstaffhead", {Ingredient("transistor", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wagstaffhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wagstaffhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wathgrithrhead", {Ingredient("wathgrithrhat", 1), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wathgrithrhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wathgrithrhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_webberhead", {Ingredient("silk", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_webberhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_webberhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_walanihead", {Ingredient("surfnturf", 1), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_walanihead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_walanihead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_warlyhead", {Ingredient("garlic", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_warlyhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_warlyhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wilburhead", {Ingredient("cave_banana", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wilburhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wilburhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_woodlegshead", {Ingredient("boneshard", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_woodlegshead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_woodlegshead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wilbahead", {Ingredient("pigskin", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wilbahead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wilbahead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wormwoodhead", {Ingredient("livinglog", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wormwoodhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wormwoodhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wheelerhead", {Ingredient("compass", 1), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wheelerhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wheelerhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_winonahead", {Ingredient("sewing_tape", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_winonahead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_winonahead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wortoxhead", {Ingredient("wortox_soul", 1), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wortoxhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wortoxhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wurthead", {Ingredient("froglegs", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wurthead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wurthead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_walterhead", {Ingredient("pinecone", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_walterhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_walterhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_warbuckshead", {Ingredient("goldnugget", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_warbuckshead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_warbuckshead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wandahead", {Ingredient("thulecite_pieces", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wandahead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wandahead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wonkeyhead", {Ingredient("cave_banana", 2), Ingredient("twigs", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wonkeyhead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wonkeyhead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_mushtree_sparse_small", {Ingredient("green_cap", 2), Ingredient("log", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mushtree_sparse_small_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_mushtree_sparse_small.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_mushtree_sparse_tall", {Ingredient("blue_cap", 2), Ingredient("log", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_mushtree_sparse_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_mushtree_sparse_tall.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_lichenplant_legacy", {Ingredient("cutlichen", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lichenplant_legacy_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_lichenplant_legacy.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_barrel", {Ingredient("cave_banana", 2), Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_barrel_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_monkeybarrel.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_barrel_safe", {Ingredient("boards", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_barrel_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_monkeybarrel.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_brokenbits_full", {Ingredient("cutstone", 1), Ingredient("rocks", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_brokenbits_full_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_brokenbits.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_surfacestairs_vip", {Ingredient("rocks", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_surfacestairs_vip_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_surfacestairs_vip.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_lsr_nogem", {Ingredient("cutstone", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lsr_nogem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacyruins_nogem.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_lsr_small_nogem", {Ingredient("cutstone", 2), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_lsr_small_nogem_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacyruins_small_nogem.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("wall_legacyruins_item", {Ingredient("thulecite", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 8,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wall_legacyruins.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_atriumgateway_wip", {Ingredient("thulecite", 5), Ingredient("sewing_tape", 2), Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_atriumgateway_wip_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_ancientgateway_wip.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_parsnip_planted", {Ingredient("carrot", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_parsnip_planted_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_parsnip_planted.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_parsnips", {Ingredient("carrot", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_parsnips_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_parsnips.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_grottohouse1", {Ingredient("cutstone", 3), Ingredient("carrot", 10)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grottohouse1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_grottohouse1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_grottohouse2", {Ingredient("cutstone", 3), Ingredient("carrot", 10)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grottohouse2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_grottohouse2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_grottohouse3", {Ingredient("cutstone", 3), Ingredient("carrot", 10)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grottohouse3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_grottohouse3.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_grottolamp", {Ingredient("lightbulb", 3), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grottolamp_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_grottolamp.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_grottonest1", {Ingredient("rocks", 4), Ingredient("flint", 2), Ingredient("phlegm", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grottonest1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_grottonest1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_grottonest2", {Ingredient("rocks", 4), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grottonest2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_grottonest2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_grottopillar1", {Ingredient("rocks", 8), Ingredient("flint", 4), Ingredient("phlegm", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grottopillar1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_grottopillar1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_grottopillar2", {Ingredient("rocks", 8), Ingredient("flint", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_grottopillar2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_grottopillar2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_rubble_door", {Ingredient("cutstone", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_rubble_door_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_housedoor.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_quagmire_rock1_full", {Ingredient("cutstone", 1), Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_quagmire_rock1_full_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_quagmire_rock1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_quagmire_rock2_full", {Ingredient("cutstone", 1), Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_quagmire_rock2_full_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_quagmire_rock2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_quagmire_rock3_full", {Ingredient("cutstone", 1), Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_quagmire_rock3_full_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_quagmire_rock3.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_quagmire_rock4_full", {Ingredient("cutstone", 1), Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_quagmire_rock4_full_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_quagmire_rock4.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_quagmire_rock5_full", {Ingredient("cutstone", 1), Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_quagmire_rock5_full_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_quagmire_rock5.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_quagmire_rock6_full", {Ingredient("cutstone", 1), Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_quagmire_rock6_full_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_quagmire_rock6.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_petch_egg", {Ingredient("tallbirdegg", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_petch_egg_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_petch_egg.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_novelty_ride", {Ingredient("boards", 1), Ingredient("silk", 1), Ingredient("gears", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_novelty_ride_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_novelty_ride.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_conch", {Ingredient("slurtle_shellpieces", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_conch_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_conch.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_floatilizerbucket", {Ingredient("poop", 1), Ingredient("kelp", 1), Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_floatilizerbucket_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_floatilizerbucket.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_p2_farmrock", {Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p2_farmrock_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p2_farmrock.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_p2_farmrocktall", {Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p2_farmrocktall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p2_farmrocktall.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_p2_farmrockflat", {Ingredient("rocks", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p2_farmrockflat_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p2_farmrockflat.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_p2_stick", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p2_stick_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p2_stick.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_p2_stickleft", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p2_stickleft_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p2_stickleft.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_p2_stickright", {Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p2_stickright_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p2_stickright.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_p2_signleft", {Ingredient("minisign_item", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p2_signleft_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p2_signleft.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_p2_fencepost", {Ingredient("fence_item", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p2_fencepost_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p2_fencepost.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_p2_fencepostright", {Ingredient("fence_item", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_p2_fencepostright_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_p2_fencepostright.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_pigtown1", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigtown1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigtown1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_pigtown2", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigtown2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigtown2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_pigtown3", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pigtown3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pigtown3.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_pighouse_hamlet", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pighouse_hamlet_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_pighouse_hamlet.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_flagpost1",  {Ingredient("cutstone", 1), Ingredient("silk", 4), Ingredient("pigskin", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flagpost1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flagpost1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_flagpost2",  {Ingredient("cutstone", 1), Ingredient("silk", 4), Ingredient("drumstick", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flagpost2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flagpost2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_flagpost3",  {Ingredient("cutstone", 1), Ingredient("silk", 4), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flagpost3_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flagpost3.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_flagpost4",  {Ingredient("cutstone", 1), Ingredient("silk", 4), Ingredient("dug_grass", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flagpost4_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flagpost4.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_flagpost5",  {Ingredient("cutstone", 1), Ingredient("silk", 4), Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_flagpost5_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_flagpost_hand.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_landplot", {Ingredient("boards", 2), Ingredient("featherpencil", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_landplot_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_landplot.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_ruinsentrance_ground1", {Ingredient("cutstone", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruinsentrance_ground1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_ruinsentrance_ground1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_ruinsentrance_ground2", {Ingredient("cutstone", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruinsentrance_ground2_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_ruinsentrance_ground2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_ruinsentrance_ground3", {Ingredient("cutstone", 2), Ingredient("flint", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_ruinsentrance_ground1_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_ruinsentrance_ground3.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_quakepillar", {Ingredient("rocks", 4)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_quakepillar_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_quakepillar.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_fennel_planted", {Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_fennel_planted_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_fennel.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_legacyonion_planted", {Ingredient("onion", 1, TapBuildingAtlas2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_legacyonion_planted_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_legacyonion.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_junglefern_green", {Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_junglefern_green_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_junglefern2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_birdcage_curly", {Ingredient("feather_robin", 6), Ingredient("papyrus", 2), Ingredient("seeds", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_birdcage_curly_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_birdcage_curly.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_redfern", {Ingredient("foliage", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_redfern_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_redfern.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_curlybush", {Ingredient("berries", 2), Ingredient("dug_marsh_bush", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_curlybush_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_curlybush.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_junglevines", {Ingredient("berries", 1), Ingredient("rope", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_junglevines_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_junglevines.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_junglebush", {Ingredient("berries", 1), Ingredient("dug_sapling", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_junglebush_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_junglebush.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_redtree_bud", {Ingredient("log", 2), Ingredient("burr", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_redtree_bud_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_redtree_bud.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_redtree_normal", {Ingredient("log", 4), Ingredient("burr", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_redtree_normal_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_redtree_normal.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_redtree_tall", {Ingredient("log", 4), Ingredient("burr", 2, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_redtree_tall_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_redtree_tall.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_redtree_old", {Ingredient("log", 1), Ingredient("burr", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_redtree_old_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_redtree_old.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_eyebush", {Ingredient("feather_crow", 2), Ingredient("dug_berrybush2", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_eyebush_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_eyebush.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_eyebush_prismatic", {Ingredient("feather_crow", 2), Ingredient("feather_robin", 1), Ingredient("dug_berrybush2", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_eyebush_prismatic_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_eyebush_prismatic.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_eyebush_withered", {Ingredient("feather_crow", 2), Ingredient("dug_sapling", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_eyebush_withered_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_eyebush_withered.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_eyebush_dead", {Ingredient("feather_crow", 2), Ingredient("dug_sapling", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_eyebush_dead_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_eyebush_dead.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_clawtree2_sapling", {Ingredient("pinecone", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_clawtree2_sapling_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_red_clawtree.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("cocoonedtreelegacy_short", {Ingredient("burr", 1, TapInventoryAtlas), Ingredient("silk", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "cocoonedtreelegacy_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_cocoonedtree_legacy.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("rainforesttreelegacy_short", {Ingredient("burr", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "rainforesttreelegacy_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rainforesttree_legacy.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("rainforesttreelegacy2_short", {Ingredient("burr", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "rainforesttreelegacy2_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_rainforesttree_legacy2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("rainforesttreelegacy_bloom_short", {Ingredient("burr", 1, TapInventoryAtlas)}, TECH.SCIENCE_TWO,
	{
		placer			= "rainforesttreelegacy_bloom_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_treebloom_legacy.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("rainforesttreelegacy_rot_short", {Ingredient("burr",1 , TapInventoryAtlas), Ingredient("spoiled_food", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "rainforesttreelegacy_rot_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_treerot_legacy.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("cocoonedtreelegacy2_short", {Ingredient("burr", 1, TapInventoryAtlas), Ingredient("silk", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "cocoonedtreelegacy2_short_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_coconeedtree_legacy2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_pomegranate_tree", {Ingredient("pomegranate", 3), Ingredient("log", 2), Ingredient("twigs", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_pomegranate_tree_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_appletree.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_bugzapper", {Ingredient("mosquito", 1), Ingredient("transistor", 2), Ingredient("boards", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_bugzapper_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_bugzapper.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_cookingspit", {Ingredient("cutstone", 1), Ingredient("twigs", 3), Ingredient("charcoal", 3)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_cookingspit_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_cookingspit.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_fogbuster", {Ingredient("twigs", 1), Ingredient("charcoal", 1), Ingredient("nitre", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_fogbuster_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_fogbuster.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_compromisingstatue", {Ingredient("marble", 3), Ingredient("rocks", 3), Ingredient("nightmarefuel", 5)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_compromisingstatue_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image 			= "kyno_compromisingstatue.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_sea_cocoon", {Ingredient("rocks", 3), Ingredient("guano", 2)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_sea_cocoon_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_sea_cocoon.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_sea_cocoon_1", {Ingredient("rocks", 2), Ingredient("guano", 1)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_sea_cocoon_1_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_sea_cocoon_1.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_sea_cocoon_2", {Ingredient("rocks", 2), Ingredient("guano", 1)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_sea_cocoon_2_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_sea_cocoon_2.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_sea_cocoon_3", {Ingredient("rocks", 2), Ingredient("guano", 1)}, TECH.SCIENCE_TWO,
	{
		testfn  		= function(pt) return not _G.TheWorld.Map:IsAboveGroundAtPoint(pt:Get()) end,
		placer			= "kyno_sea_cocoon_3_placer",
		min_spacing     = 0,
		build_distance	= 30,
		atlas           = TapBuildingAtlas2,
		image           = "kyno_sea_cocoon_3.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_chicken_builder", {Ingredient("drumstick", 2), Ingredient("reviver", 1), Ingredient("goose_feather", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_chicken_builder_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_chicken.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_wargfant_builder", {Ingredient("monstermeat", 6), Ingredient("trunk_summer", 1), Ingredient("reviver", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_wargfant_builder_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_wargfant.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_snapdragon", {Ingredient("plantmeat", 2), Ingredient("dragonfruit", 1)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_snapdragon_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_snapdragon.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_zeb_builder", {Ingredient("meat", 2), Ingredient("reviver", 1), Ingredient("manrabbit_tail", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_zeb_builder_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_zeb.tex",
	},
	{"TAP_LEGACY"}
)

AddRecipe2("kyno_peekhen", {Ingredient("drumstick", 2), Ingredient("reviver", 1), Ingredient("feather_crow", 2)}, TECH.SCIENCE_TWO,
	{
		placer			= "kyno_peekhen_placer",
		min_spacing		= 0,
		atlas			= TapBuildingAtlas,
		image			= "kyno_peekhen.tex",
	},
	{"TAP_LEGACY"}
)

-- Turfs Category.
AddRecipe2("turf_magmafield", {Ingredient("turf_rocky", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_magmafield.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_volcano", {Ingredient("turf_magmafield", 2, TapInventoryAtlas)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_volcano.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_ash", {Ingredient("ash", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_ash.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_volcano_rock", {Ingredient("turf_magmafield", 2, TapInventoryAtlas), Ingredient("rocks", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_volcano_rock.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_tidalmarsh", {Ingredient("turf_mud", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_tidalmarsh.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_jungle", {Ingredient("turf_forest", 1), Ingredient("twigs", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_jungle.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_meadow", {Ingredient("turf_grass", 1), Ingredient("cutgrass", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_meadow.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_beach", {Ingredient("turf_desertdirt", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_beach.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_snakeskinfloor", {Ingredient("turf_carpetfloor", 1), Ingredient("silk", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_snakeskinfloor.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_cobbleroad", {Ingredient("cutstone", 1), Ingredient("flint", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_cobbleroad.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_foundation", {Ingredient("cutstone", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_foundation.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_lawn", {Ingredient("cutgrass", 2), Ingredient("nitre", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_lawn.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_fields", {Ingredient("turf_rainforest", 1, TapInventoryAtlas), Ingredient("ash", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_fields.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_rainforest", {Ingredient("turf_grass", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_rainforest.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_deepjungle", {Ingredient("turf_forest", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_deepjungle.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_gasjungle", {Ingredient("turf_deepjungle", 1, TapInventoryAtlas), Ingredient("spoiled_food", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_gasjungle.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_plains", {Ingredient("turf_savanna", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_plains.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_mossy_blossom", {Ingredient("turf_deciduous", 1), Ingredient("spoiled_food", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_mossy_blossom.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_bog", {Ingredient("turf_desertdirt", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_bog.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_antcave", {Ingredient("turf_mud", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_antcave.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_batcave", {Ingredient("turf_cave", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_batcave.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_pigruins", {Ingredient("cutstone", 1), Ingredient("flint", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_pigruins.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_pinkpark", {Ingredient("turf_deciduous", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_pinkpark.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_pinkstone", {Ingredient("cutstone", 1), Ingredient("flint", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_pinkstone.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_greyforest", {Ingredient("turf_forest", 1), Ingredient("twigs", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_greyforest.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_stonecity", {Ingredient("cutstone", 1), Ingredient("flint", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_stonecity.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_browncarpet", {Ingredient("poop", 2), Ingredient("seeds", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_browncarpet.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_forgerock", {Ingredient("turf_rocky", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_forgerock.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_forgeroad", {Ingredient("turf_forgerock", 1, TapInventoryAtlas), Ingredient("redgem", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_forgeroad.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_redcarpet", {Ingredient("turf_carpetfloor", 1), Ingredient("red_cap", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_redcarpet.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_pinkcarpet", {Ingredient("turf_carpetfloor", 1), Ingredient("spidergland", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_pinkcarpet.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_cyancarpet", {Ingredient("turf_carpetfloor", 1), Ingredient("cutlichen", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image		    = "turf_cyancarpet.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_whitecarpet", {Ingredient("turf_carpetfloor", 1), Ingredient("spidergland", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_whitecarpet.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_yellowcarpet", {Ingredient("turf_carpetfloor", 1), Ingredient("cutgrass", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_yellowcarpet.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_greencarpet", {Ingredient("turf_carpetfloor", 1), Ingredient("succulent_picked", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_greencarpet.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_orangecarpet", {Ingredient("turf_carpetfloor", 1), Ingredient("pumpkin", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_orangecarpet.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_blueyellow", {Ingredient("turf_carpetfloor", 1), Ingredient("cutgrass", 1), Ingredient("cutlichen", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_blueyellow.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_leakproofcarpet", {Ingredient("turf_carpetfloor", 1), Ingredient("cutlichen", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_leakproofcarpet.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_snowfall", {Ingredient("ice", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_snowfall.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_modern_cobblestones", {Ingredient("cutstone", 1), Ingredient("flint", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_modern_cobblestones.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_lunarrift", {Ingredient("purebrilliance", 1), Ingredient("moonrocknugget", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_lunarrift.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_sticky", {Ingredient("honey", 1), Ingredient("boards", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_sticky.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_copacabana", {Ingredient("charcoal", 1), Ingredient("marble", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_copacabana.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_driftwoodfloor", {Ingredient("kyno_driftwood_boards", 1, TapInventoryAtlas)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_driftwoodfloor.tex",
	},
	{"TAP_TURFS", "DECOR"}
)
SortAfter("turf_driftwoodfloor", "turf_woodfloor", "DECOR")

AddRecipe2("turf_legacyrainforest", {Ingredient("turf_rainforest", 2, TapInventoryAtlas)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_legacyrainforest.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_legacydeepjungle", {Ingredient("turf_deepjungle", 2, TapInventoryAtlas)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_legacydeepjungle.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_legacybog", {Ingredient("turf_bog", 2, TapInventoryAtlas)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_legacybog.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_greenmarsh", {Ingredient("turf_marsh", 1), Ingredient("turf_grass", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_greenmarsh.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_ivygrass", {Ingredient("turf_grass", 1), Ingredient("turf_forest", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_ivygrass.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_swirlgrass", {Ingredient("turf_forest", 1), Ingredient("cutgrass", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_swirlgrass.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_swirlgrassmono", {Ingredient("turf_grass", 1), Ingredient("twigs", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_swirlgrassmono.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("kyno_turf_webbing", {Ingredient("silk", 3)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 6,
		atlas			= TapInventoryAtlas,
		image			= "kyno_turf_webbing.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_vaultmossy", {Ingredient("thulecite_pieces", 1), Ingredient("moonrocknugget", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_vaultmossy.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_wagstaff", {Ingredient("cutstone", 1), Ingredient("wagpunk_bits", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapDefaultAtlas3,
		image			= "wagpunk_floor_kit.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_marbletile", {Ingredient("marble", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_marbletile.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_chess", {Ingredient("turf_checkerfloor", 1), Ingredient("turf_rocky", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_chess.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_slate", {Ingredient("rocks", 1), Ingredient("marble", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_slate.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_metalsheet", {Ingredient("cutstone", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_metalsheet.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_garden", {Ingredient("cutstone", 1), Ingredient("turf_grass", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_garden.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_geometric", {Ingredient("turf_checkerfloor", 1), Ingredient("blue_cap", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_geometric.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_shagcarpet", {Ingredient("turf_carpetfloor", 1), Ingredient("silk", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_shagcarpet.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_transitional", {Ingredient("turf_checkerfloor", 1), Ingredient("turf_woodfloor", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_transitional.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_woodpanel", {Ingredient("turf_woodfloor", 2)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_woodpanel.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_herring", {Ingredient("boneshard", 1), Ingredient("turf_rocky", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_herring.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_hexagon", {Ingredient("charcoal", 1), Ingredient("marble", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_hexagon.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_hoof", {Ingredient("cutstone", 1), Ingredient("pigskin", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_hoof.tex",
	},
	{"TAP_TURFS"}
)

AddRecipe2("turf_octagon", {Ingredient("charcoal", 1), Ingredient("cutstone", 1)}, TECH.TURFMAKER_ONE,
	{
		actionstr 		= "TERRAFORMER",
		numtogive		= 4,
		atlas			= TapInventoryAtlas,
		image			= "turf_octagon.tex",
	},
	{"TAP_TURFS"}
)

-- Refine / Items Category.
AddRecipe2("berries", {Ingredient("berries_juicy", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "berries.tex",
	},
	{"REFINE"}
)

AddRecipe2("berries_juicy", {Ingredient("berries", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "berries_juicy.tex",
	},
	{"REFINE"}
)

AddRecipe2("fossil_piece", {Ingredient("boneshard", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "fossil_piece.tex",
	},
	{"REFINE"}
)

AddRecipe2("bullkelp_root", {Ingredient("kelp", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas1,
		image			= "bullkelp_root.tex",
	},
	{"REFINE"}
)

AddRecipe2("succulent_picked", {Ingredient("foliage", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "succulent_picked.tex",
	},
	{"REFINE"}
)

AddRecipe2("foliage", {Ingredient("succulent_picked", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "foliage.tex",
	},
	{"REFINE"}
)

AddRecipe2("driftwood_log", {Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas1,
		image			= "driftwood_log.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_driftwood_boards", {Ingredient("driftwood_log", 4)}, TECH.SCIENCE_ONE,
	{
		atlas			= TapInventoryAtlas,
		image			= "kyno_driftwood_boards.tex",
	},
	{"REFINE"}
)
SortAfter("kyno_driftwood_boards", "driftwood_log", "REFINE")

AddRecipe2("acorn", {Ingredient("pinecone", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "acorn.tex",
	},
	{"REFINE"}
)

AddRecipe2("pinecone", {Ingredient("acorn", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "pinecone.tex",
	},
	{"REFINE"}
)

AddRecipe2("twiggy_nut", {Ingredient("pinecone", 1), Ingredient("twigs", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "twiggy_nut.tex",
	},
	{"REFINE"}
)

AddRecipe2("palmcone_seed", {Ingredient("pinecone", 1), Ingredient("acorn", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas2,
		image			= "palmcone_seed.tex",
	},
	{"REFINE"}
)

AddRecipe2("lureplantbulb", {Ingredient("plantmeat", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "lureplantbulb.tex",
	},
	{"REFINE"}
)

AddRecipe2("honeycomb", {Ingredient("honey", 5)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "honeycomb.tex",
	},
	{"REFINE"}
)

AddRecipe2("mandrake", {Ingredient("carrat", 1), Ingredient("nightmarefuel", 10)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 2,
		atlas			= TapDefaultAtlas,
		image			= "mandrake.tex",
	},
	{"REFINE"}
)

AddRecipe2("tallbirdegg", {Ingredient("bird_egg", 10)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "tallbirdegg.tex",
	},
	{"REFINE"}
)

AddRecipe2("moonbutterfly2", {Ingredient("butterfly", 1)}, TECH.SCIENCE_TWO,
	{
		product         = "moonbutterfly",
		numtogive		= 1,
		atlas			= TapDefaultAtlas2,
		image			= "moonbutterfly.tex",
	},
	{"REFINE"}
)

AddRecipe2("fireflies", {Ingredient("lightbulb", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "fireflies.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_redflies", {Ingredient("fireflies", 1), Ingredient("red_cap", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_redflies.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_orangeflies", {Ingredient("fireflies", 1), Ingredient("carrot", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_orangeflies.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_yellowflies", {Ingredient("fireflies", 1), Ingredient("potato", 1, TapBuildingAtlas2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "kyno_yellowflies.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_greenflies", {Ingredient("fireflies", 1), Ingredient("green_cap", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_greenflies.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_blueflies", {Ingredient("fireflies", 1), Ingredient("blue_cap", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_blueflies.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_cyanflies", {Ingredient("fireflies", 1), Ingredient("cutlichen", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_cyanflies.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_purpleflies", {Ingredient("fireflies", 1), Ingredient("eggplant", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_purpleflies.tex",
	},
	{"REFINE"}
)

local VANITY = GetModConfigData("TAP_VANITY")
if VANITY == 1 then
AddRecipe2("kyno_relic_1", {Ingredient("goldnugget", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_relic_1.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_relic_2", {Ingredient("goldnugget", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_relic_2.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_relic_3", {Ingredient("goldnugget", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_relic_3.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_relic_4", {Ingredient("goldnugget", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_relic_4.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_relic_5", {Ingredient("goldnugget", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_relic_5.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_pherostone", {Ingredient("goldnugget", 3), Ingredient("rocks", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_pherostone.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_oinc1", {Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_oinc1.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_oinc10", {Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_oinc10.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_oinc100", {Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_oinc100.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_gorgecoin1", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_coin1.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_gorgecoin2", {Ingredient("goldnugget", 2), Ingredient("bluegem", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_coin2.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_gorgecoin3", {Ingredient("goldnugget", 2), Ingredient("redgem", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_coin3.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_gorgecoin4", {Ingredient("goldnugget", 2), Ingredient("opalpreciousgem", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "quagmire_coin4.tex",
	},
	{"REFINE"}
)
end

AddRecipe2("trinket_1", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_1.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_2", {Ingredient("goldnugget", 6)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_2.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_3", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_3.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_4", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_4.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_5", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_5.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_6", {Ingredient("goldnugget", 5)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_6.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_7", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_7.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_8", {Ingredient("goldnugget", 8)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_8.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_9", {Ingredient("goldnugget", 7)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_9.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_10", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_10.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_11", {Ingredient("goldnugget", 5)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_11.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_12", {Ingredient("goldnugget", 8)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_12.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_13", {Ingredient("goldnugget", 5)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_13.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_14", {Ingredient("goldnugget", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_14.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_17", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_17.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_18", {Ingredient("goldnugget", 6)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_18.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_19", {Ingredient("goldnugget", 6)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_19.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_20", {Ingredient("goldnugget", 7)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_20.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_21", {Ingredient("goldnugget", 5)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_21.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_22", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_22.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_23", {Ingredient("goldnugget", 3)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_23.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_24", {Ingredient("goldnugget", 8)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_24.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_25", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_25.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_26", {Ingredient("goldnugget", 9)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_26.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_27", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_27.tex",
	},
	{"REFINE"}
)

AddRecipe2("antliontrinket", {Ingredient("goldnugget", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "antliontrinket.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_32", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_32.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_33", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_33.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_34", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_34.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_35", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_35.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_36", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_36.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_37", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_37.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_38", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_38.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_39", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_39.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_40", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_40.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_41", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_41.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_42", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_42.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_43", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_43.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_44", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_44.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_45", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_45.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_46", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "trinket_46.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_sw_13", {Ingredient("goldnugget", 6)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_sw_13.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_sw_14", {Ingredient("goldnugget", 8)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_sw_14.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_sw_15", {Ingredient("goldnugget", 6)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_sw_15.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_sw_16", {Ingredient("goldnugget", 7)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_sw_16.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_sw_17", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_sw_17.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_sw_18", {Ingredient("goldnugget", 7)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_sw_18.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_sw_19", {Ingredient("goldnugget", 6)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_sw_19.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_sw_20", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_sw_20.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_sw_21", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_sw_21.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_sw_22", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_sw_22.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_sw_23", {Ingredient("goldnugget", 10)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_sw_23.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_earring", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas,
		image			= "kyno_earring.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_ham_1", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_ham_1.tex",
	},
	{"REFINE"}
)

AddRecipe2("trinket_ham_3", {Ingredient("goldnugget", 4)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapBuildingAtlas2,
		image			= "trinket_ham_3.tex",
	},
	{"REFINE"}
)

AddRecipe2("wintersfeastfuel", {Ingredient("nightmarefuel", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas3,
		image			= "wintersfeastfuel.tex",
	},
	{"REFINE"}
)

AddRecipe2("halloween_ornament_1", {Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "halloween_ornament_1.tex",
	},
	{"REFINE"}
)

AddRecipe2("halloween_ornament_2", {Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "halloween_ornament_2.tex",
	},
	{"REFINE"}
)

AddRecipe2("halloween_ornament_3", {Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "halloween_ornament_3.tex",
	},
	{"REFINE"}
)

AddRecipe2("halloween_ornament_4", {Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "halloween_ornament_4.tex",
	},
	{"REFINE"}
)

AddRecipe2("halloween_ornament_5", {Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "halloween_ornament_5.tex",
	},
	{"REFINE"}
)

AddRecipe2("halloween_ornament_6", {Ingredient("nightmarefuel", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "halloween_ornament_6.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain1", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain1.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain2", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain2.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain3", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain3.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain4", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain4.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain5", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain5.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain6", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain6.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain7", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain7.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain8", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain8.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain9", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain9.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain10", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain10.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain11", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain11.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_plain12", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_plain12.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_fancy1", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_fancy1.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_fancy2", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_fancy2.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_fancy3", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_fancy3.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_fancy4", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_fancy4.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_fancy5", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_fancy5.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_fancy6", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_fancy6.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_fancy7", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_fancy7.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_fancy8", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_fancy8.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_festivalevents1", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_festivalevents1.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_festivalevents2", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_festivalevents2.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_festivalevents3", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_festivalevents3.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_festivalevents4", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_festivalevents4.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_festivalevents5", {Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_festivalevents5.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_light1", {Ingredient("kyno_redflies", 1, TapBuildingAtlas), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_light1.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_light2", {Ingredient("kyno_greenflies", 1, TapBuildingAtlas), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_light2.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_light3", {Ingredient("kyno_blueflies", 1, TapBuildingAtlas), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_light3.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_light4", {Ingredient("fireflies", 1), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_light4.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_light5", {Ingredient("kyno_redflies", 1, TapBuildingAtlas), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_light5.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_light6", {Ingredient("kyno_greenflies", 1, TapBuildingAtlas), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_light6.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_light7", {Ingredient("kyno_blueflies", 1, TapBuildingAtlas), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_light7.tex",
	},
	{"REFINE"}
)

AddRecipe2("winter_ornament_light8", {Ingredient("fireflies", 1), Ingredient("moonglass", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapDefaultAtlas,
		image			= "winter_ornament_light8.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wilsonskull", {Ingredient("boneshard", 1), Ingredient("beardhair", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wilsonskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_willowskull", {Ingredient("boneshard", 1), Ingredient("charcoal", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_willowskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wolfgangskull", {Ingredient("boneshard", 1), Ingredient("berries", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wolfgangskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wendyskull", {Ingredient("boneshard", 1), Ingredient("petals_evil", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wendyskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wx78skull", {Ingredient("boneshard", 1), Ingredient("trinket_6", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wx78skull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wickerbottomskull", {Ingredient("boneshard", 1), Ingredient("papyrus", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wickerbottomskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_woodieskull", {Ingredient("boneshard", 1), Ingredient("log", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_woodieskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wesskull", {Ingredient("boneshard", 1), Ingredient("waterballoon", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wesskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_waxwellskull", {Ingredient("boneshard", 1), Ingredient("nightmarefuel", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_waxwellskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_webberskull", {Ingredient("boneshard", 1), Ingredient("silk", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_webberskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wathgrithrskull", {Ingredient("boneshard", 1), Ingredient("meat", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wathgrithrskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_warlyskull", {Ingredient("boneshard", 1), Ingredient("garlic", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_warlyskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_winonaskull", {Ingredient("boneshard", 1), Ingredient("sewing_tape", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_winonaskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wormwoodskull", {Ingredient("boneshard", 1), Ingredient("livinglog", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wormwoodskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wurtskull", {Ingredient("boneshard", 1), Ingredient("froglegs", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wurtskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_walterskull", {Ingredient("boneshard", 1), Ingredient("pinecone", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_walterskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wallaceskull", {Ingredient("boneshard", 1), Ingredient("walrus_tusk", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wallaceskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wiltonskull", {Ingredient("boneshard", 1), Ingredient("houndstooth", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wiltonskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_waverlyskull", {Ingredient("boneshard", 1), Ingredient("spidergland", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_waverlyskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wandaskull", {Ingredient("boneshard", 1), Ingredient("thulecite_pieces", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wandaskull.tex",
	},
	{"REFINE"}
)

AddRecipe2("kyno_wonkeyskull", {Ingredient("boneshard", 1), Ingredient("cave_banana", 1)}, TECH.SCIENCE_TWO,
	{
		numtogive		= 1,
		atlas			= TapInventoryAtlas,
		image			= "kyno_wonkeyskull.tex",
	},
	{"REFINE"}
)