require("tilemanager")

-- Common Dependencies.
local _G 				= GLOBAL
local GROUND 			= _G.GROUND

local Asset = _G.Asset
Assets = {
	Asset("ANIM", "anim/kyno_turfs_other.zip"),
}

-- Turfs sounds and other things.
local run_carpet 		= "dontstarve/movement/run_carpet"
local run_grass 		= "dontstarve/movement/run_grass"
local run_marble 		= "dontstarve/movement/run_marble"
local run_sand 			= "dontstarve/movement/run_sand"
local run_tallgrass 	= "dontstarve/movement/run_tallgrass"
local run_wood 			= "dontstarve/movement/run_wood"
local run_marsh 		= "dontstarve/movement/run_marsh"
local run_dirt			= "dontstarve/movement/run_dirt"
local run_beach			= "turnoftides/movement/run_pebblebeach"
local run_rock          = "dontstarve/movement/run_rock"
local run_docks         = "monkeyisland/dock/run_dock"
local run_meteor        = "turnoftides/movement/run_meteor"
local run_wagdock       = "dontstarve/movement/run_wagdock"

local walk_carpet 		= "dontstarve/movement/walk_carpet"
local walk_grass 		= "dontstarve/movement/walk_grass"
local walk_marble 		= "dontstarve/movement/walk_marble"
local walk_sand 		= "dontstarve/movement/walk_sand"
local walk_tallgrass 	= "dontstarve/movement/walk_tallgrass"
local walk_wood 		= "dontstarve/movement/walk_wood"
local walk_marsh 		= "dontstarve/movement/walk_marsh"
local walk_dirt			= "dontstarve/movement/walk_dirt"
local walk_beach		= "turnoftides/movement/run_pebblebeach"
local walk_rock         = "dontstarve/movement/walk_rock"
local walk_docks        = "monkeyisland/dock/walk_dock"
local walk_meteor       = "turnoftides/movement/run_meteor"
local walk_wagdock      = "dontstarve/movement/walk_wagdock"

local run_snow 			= "dontstarve/movement/run_snow"
local run_mud           = "dontstarve/movement/run_mud"
local flashpoint		= flashpoint_modifier

-- The turfs.
AddTile("SAP_SWIRLGRASS", "LAND",
	{
		ground_name 	= "Swirl Grass",
		old_static_id 	= 61,
	},
	{
		name			= "deciduous",
		noise_texture	= "levels/textures/other/noise_swirl.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_swirl.tex",
	},
	{
		name			= "swirlgrass",
		anim			= "swirlgrass",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_SWIRLGRASSMONO", "LAND",
	{
		ground_name 	= "Swirl Grass Mono",
		old_static_id 	= 62,
	},
	{
		name			= "deciduous",
		noise_texture	= "levels/textures/other/noise_swirl_mono.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_swirl_mono.tex",
	},
	{
		name			= "swirlgrassmono",
		anim			= "swirlgrassmono",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_COPACABANA", "LAND",
	{
		ground_name 	= "Copacabana",
		old_static_id 	= 63,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/other/noise_copacabana.tex",
		runsound 		= run_marble,
        walksound 		= walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_copacabana.tex",
	},
	{
		name			= "copacabana",
		anim			= "copacabana",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "rock",
	}
)

AddTile("SAP_STICKY", "LAND",
	{
		ground_name 	= "Honey Sticky",
		old_static_id 	= 64,
	},
	{
		name 			= "snowfall",
		noise_texture 	= "levels/textures/other/noise_sticky.tex",
		runsound 		= run_marsh,
		walksound 		= walk_marsh,
		snowsound 		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name			= "map_edge",
		noise_texture 	= "levels/textures/other/mini_noise_sticky",
	},
	{
		name			= "sticky",
		anim			= "sticky",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "squidgy",
	}
)

AddTile("SAP_SNOWFALL", "LAND",
	{
		ground_name 	= "Snowfall",
		old_static_id 	= 66,
	},
	{
		name			= "snowfall",
		noise_texture	= "levels/textures/other/noise_snowfall.tex",
		runsound 		= run_beach,
        walksound 		= walk_beach,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_snowfall.tex",
	},
	{
		name			= "snowfall",
		anim			= "snowfall",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "grainy",
	}
)

AddTile("SAP_MODERN_COBBLESTONES", "LAND",
	{
		ground_name 	= "Modern Cobblestones",
		old_static_id 	= 67,
	},
	{
		name			= "farmsoil",
		noise_texture	= "levels/textures/other/Ground_noise_modern.tex",
		runsound 		= run_dirt,
        walksound 		= walk_dirt,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		roadways        = true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_moderncobblestones.tex",
	},
	{
		name			= "modern_cobblestones",
		anim			= "modern_cobblestones",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "rock",
	}
)

AddTile("SAP_PINKSTONE", "LAND",
	{
		ground_name 	= "Pink Stone",
		old_static_id 	= 68,
	},
	{
		name			= "cave",
		noise_texture	= "levels/textures/events/quagmire_parkstone_noise.tex",
		runsound 		= run_dirt,
        walksound 		= walk_dirt,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		roadways        = true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/events/quagmire_parkstone_mini.tex",
	},
	{
		name			= "pinkstone",
		anim			= "pinkstone",
		bank_build		= "kyno_turfs_events",
		pickupsound     = "rock",
	}
)
--[[
AddTile("STONECITY", "LAND",
	{
		ground_name 	= "City Stone",
		old_static_id 	= GROUND.QUAGMIRE_CITYSTONE,
	},
	{
		name			= "cave",
		noise_texture	= "levels/textures/events/quagmire_citystone_noise.tex",
		runsound 		= run_dirt,
        walksound 		= walk_dirt,
		snowsound		= run_snow,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/events/quagmire_citystone_mini.tex",
	},
	{
		name			= "stonecity",
		anim			= "stonecity",
		bank_build		= "kyno_turfs_events",
	}
)
]]--
AddTile("SAP_BEACH", "LAND",
	{
		ground_name 	= "Beach",
		old_static_id 	= 70,
	},
	{
		name			= "beach",
		noise_texture	= "levels/textures/shipwrecked/Ground_noise_sand.tex",
		runsound 		= run_beach,
        walksound 		= walk_beach,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/shipwrecked/mini_beach_noise.tex",
	},
	{
		name			= "beach",
		anim			= "beach",
		bank_build		= "kyno_turfs_shipwrecked",
		pickupsound     = "grainy",
	}
)

AddTile("SAP_VOLCANO_ROCK", "LAND",
	{
		ground_name 	= "Volcano Rock",
		old_static_id 	= 71,
	},
	{
		name			= "volcano",
		noise_texture	= "levels/textures/shipwrecked/ground_volcano_noise.tex",
		runsound 		= run_dirt,
        walksound 		= walk_dirt,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/shipwrecked/mini_ground_volcano_noise.tex",
	},
	{
		name			= "volcano_rock",
		anim			= "volcano_rock",
		bank_build		= "kyno_turfs_shipwrecked",
		pickupsound     = "rock",
	}
)

AddTile("SAP_TIDALMARSH", "LAND",
	{
		ground_name 	= "Tidal Marsh",
		old_static_id 	= 72,
	},
	{
		name			= "tidalmarsh",
		noise_texture	= "levels/textures/shipwrecked/Ground_noise_tidalmarsh.tex",
		runsound 		= run_marsh,
        walksound 		= walk_marsh,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/shipwrecked/mini_tidalmarsh_noise.tex",
	},
	{
		name			= "tidalmarsh",
		anim			= "tidalmarsh",
		bank_build		= "kyno_turfs_shipwrecked",
		pickupsound     = "squidgy",
	}
)

AddTile("SAP_MEADOW", "LAND",
	{
		ground_name 	= "Meadow",
		old_static_id 	= 73,
	},
	{
		name			= "jungle",
		noise_texture	= "levels/textures/shipwrecked/Ground_noise_savannah_detail.tex",
		runsound 		= run_tallgrass,
        walksound 		= walk_tallgrass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/shipwrecked/mini_savannah_noise.tex",
	},
	{
		name			= "meadow",
		anim			= "meadow",
		bank_build		= "kyno_turfs_shipwrecked",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_JUNGLE", "LAND",
	{
		ground_name 	= "Jungle",
		old_static_id 	= 74,
	},
	{
		name			= "jungle",
		noise_texture	= "levels/textures/shipwrecked/Ground_noise_jungle.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/shipwrecked/mini_jungle_noise.tex",
	},
	{
		name			= "jungle",
		anim			= "jungle",
		bank_build		= "kyno_turfs_shipwrecked",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_VOLCANO", "LAND",
	{
		ground_name 	= "Volcano",
		old_static_id 	= 75,
	},
	{
		name			= "cave",
		noise_texture	= "levels/textures/shipwrecked/ground_lava_rock.tex",
		runsound 		= run_dirt,
        walksound 		= walk_dirt,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/shipwrecked/mini_ground_lava_rock.tex",
	},
	{
		name			= "volcano",
		anim			= "volcano",
		bank_build		= "kyno_turfs_shipwrecked",
		pickupsound     = "rock",
	}
)

AddTile("SAP_ASH", "LAND",
	{
		ground_name 	= "Ash",
		old_static_id 	= 76,
	},
	{
		name			= "cave",
		noise_texture	= "levels/textures/shipwrecked/ground_ash.tex",
		runsound 		= run_dirt,
        walksound 		= walk_dirt,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/shipwrecked/mini_ash.tex",
	},
	{
		name			= "ash",
		anim			= "ash",
		bank_build		= "kyno_turfs_shipwrecked",
		pickupsound     = "grainy",
	}
)

AddTile("SAP_MAGMAFIELD", "LAND",
	{
		ground_name 	= "Magmafield",
		old_static_id 	= 77,
	},
	{
		name			= "cave",
		noise_texture	= "levels/textures/shipwrecked/Ground_noise_magmafield.tex",
		runsound 		= run_dirt,
        walksound 		= walk_dirt,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/shipwrecked/mini_magmafield_noise.tex",
	},
	{
		name			= "magmafield",
		anim			= "magmafield",
		bank_build		= "kyno_turfs_shipwrecked",
		pickupsound     = "rock",
	}
)

AddTile("SAP_SNAKESKINFLOOR", "LAND",
	{
		ground_name 	= "Snakeskin Floor",
		old_static_id 	= 78,
	},
	{
		name			= "carpet",
		noise_texture	= "levels/textures/shipwrecked/noise_snakeskinfloor.tex",
		runsound 		= run_carpet,
        walksound 		= walk_carpet,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		flooring		= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/shipwrecked/noise_snakeskinfloor.tex",
	},
	{
		name			= "snakeskinfloor",
		anim			= "snakeskinfloor",
		bank_build		= "kyno_turfs_shipwrecked",
		pickupsound     = "cloth",
	}
)

AddTile("SAP_COBBLEROAD", "LAND",
	{
		ground_name 	= "Cobbleroad",
		old_static_id 	= 79,
	},
	{
		name			= "stoneroad",
		noise_texture	= "levels/textures/hamlet/Ground_noise_cobbleroad.tex",
		runsound        = run_marble,
		walksound       = walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		roadways        = true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_brickroad_noise.tex",
	},
	{
		name			= "cobbleroad",
		anim			= "cobbleroad",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "rock",
	}
)

AddTile("SAP_PIGRUINS", "LAND",
	{
		ground_name 	= "Pig Ruins",
		old_static_id 	= 80,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/hamlet/ground_ruins_slab.tex",
		runsound        = run_dirt,
		walksound       = walk_dirt,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_ruins_slab.tex",
	},
	{
		name			= "pigruins",
		anim			= "pigruins",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "rock",
	}
)

AddTile("SAP_FIELDS", "LAND",
	{
		ground_name 	= "Fields",
		old_static_id 	= 81,
	},
	{
		name			= "jungle",
		noise_texture	= "levels/textures/hamlet/noise_farmland.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_noise_farmland.tex",
	},
	{
		name			= "fields",
		anim			= "fields",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_FOUNDATION", "LAND",
	{
		ground_name 	= "Foundation",
		old_static_id 	= 82,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/hamlet/noise_ruinsbrick_scaled.tex",
		runsound 		= run_marble,
        walksound 		= walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_fanstone_noise.tex",
	},
	{
		name			= "foundation",
		anim			= "foundation",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "rock",
	}
)

AddTile("SAP_LAWN", "LAND",
	{
		ground_name 	= "Lawn",
		old_static_id 	= 83,
	},
	{
		name			= "pebble",
		noise_texture	= "levels/textures/hamlet/ground_noise_checkeredlawn.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_grasslawn_noise.tex",
	},
	{
		name			= "lawn",
		anim			= "lawn",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_RAINFOREST", "LAND",
	{
		ground_name 	= "Rainforest",
		old_static_id 	= 84,
	},
	{
		name			= "rain_forest",
		noise_texture	= "levels/textures/hamlet/Ground_noise_rainforest.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_noise_rainforest.tex",
	},
	{
		name			= "rainforest",
		anim			= "rainforest",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_PLAINS", "LAND",
	{
		ground_name 	= "Plains",
		old_static_id 	= 85,
	},
	{
		name			= "jungle",
		noise_texture	= "levels/textures/hamlet/Ground_plains.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_plains_noise.tex",
	},
	{
		name			= "plains",
		anim			= "plains",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_DEEPJUNGLE", "LAND",
	{
		ground_name 	= "Deep Jungle",
		old_static_id 	= 86,
	},
	{
		name			= "jungle_deep",
		noise_texture	= "levels/textures/hamlet/Ground_noise_jungle_deep.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_noise_jungle_deep.tex",
	},
	{
		name			= "deepjungle",
		anim			= "deepjungle",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "vegetation_firm",
	}
)

AddTile("SAP_BOG", "LAND",
	{
		ground_name 	= "Bog",
		old_static_id 	= 87,
	},
	{
		name			= "cave",
		noise_texture	= "levels/textures/hamlet/Ground_bog.tex",
		runsound 		= run_sand,
        walksound 		= walk_sand,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_noise_bog.tex",
	},
	{
		name			= "bog",
		anim			= "bog",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "vegetation_firm",
	}
)

AddTile("SAP_MOSSY_BLOSSOM", "LAND",
	{
		ground_name 	= "Mossy Blossom",
		old_static_id 	= 88,
	},
	{
		name			= "desert_dirt",
		noise_texture	= "levels/textures/hamlet/noise_mossy_blossom.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_noise_mossy_blossom.tex",
	},
	{
		name			= "mossy_blossom",
		anim			= "mossy_blossom",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "vegetation_firm",
	}
)

AddTile("SAP_GASJUNGLE", "LAND",
	{
		ground_name 	= "Gas Jungle",
		old_static_id 	= 89,
	},
	{
		name			= "jungle_deep",
		noise_texture	= "levels/textures/hamlet/Ground_noise_gasbiome.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_gasbiome_noise.tex",
	},
	{
		name			= "gasjungle",
		anim			= "gasjungle",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "vegetation_firm",
	}
)

--[[
AddTile("PINKPARK", "LAND",
	{
		ground_name 	= "Pink Park",
		old_static_id 	= GROUND.QUAGMIRE_PARKFIELD,
	},
	{
		name			= "deciduous",
		noise_texture	= "levels/textures/events/quagmire_parkfield_noise.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/events/quagmire_parkfield_mini.tex",
	},
	{
		name			= "pinkpark",
		anim			= "pinkpark",
		bank_build		= "kyno_turfs_events",
	}
)
]]--
AddTile("SAP_GREYFOREST", "LAND",
	{
		ground_name 	= "Grey Forest",
		old_static_id 	= 92,
	},
	{
		name			= "grass3",
		noise_texture	= "levels/textures/events/quagmire_gateway_noise.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/events/quagmire_gateway_mini.tex",
	},
	{
		name			= "greyforest",
		anim			= "greyforest",
		bank_build		= "kyno_turfs_events",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_BROWNCARPET", "LAND",
	{
		ground_name 	= "Brown Carpet",
		old_static_id 	= 93,
	},
	{
		name			= "farmsoil",
		noise_texture	= "levels/textures/events/quagmire_soil_noise.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/events/quagmire_soil_mini.tex",
	},
	{
		name			= "browncarpet",
		anim			= "browncarpet",
		bank_build		= "kyno_turfs_events",
		pickupsound     = "grainy",
	}
)

AddTile("SAP_FORGEROCK", "LAND",
	{
		ground_name 	= "Forge Rock",
		old_static_id 	= 94,
	},
	{
		name			= "forge_trim_ms",
		noise_texture	= "levels/textures/events/forge_trim_noise.tex",
		runsound 		= run_dirt,
        walksound 		= walk_dirt,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/events/forge_trim_mini.tex",
	},
	{
		name			= "forgerock",
		anim			= "forgerock",
		bank_build		= "kyno_turfs_events",
		pickupsound     = "rock",
	}
)

AddTile("SAP_FORGEROAD", "LAND",
	{
		ground_name 	= "Forge Road",
		old_static_id 	= 95,
	},
	{
		name			= "forge_floor_ms",
		noise_texture	= "levels/textures/events/forge_floor_noise.tex",
		runsound        = run_dirt,
		walksound       = walk_dirt,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		roadways        = true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/events/forge_floor_mini.tex",
	},
	{
		name			= "forgeroad",
		anim			= "forgeroad",
		bank_build		= "kyno_turfs_events",
		pickupsound     = "rock",
	}
)

AddTile("SAP_ANTCAVE", "LAND",
	{
		ground_name 	= "Ant Cave",
		old_static_id 	= 96,
	},
	{
		name			= "cave",
		noise_texture	= "levels/textures/hamlet/antcave_noise.tex",
		runsound        = run_dirt,
		walksound       = walk_dirt,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/antcave_mini.tex",
	},
	{
		name			= "antcave",
		anim			= "antcave",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "rock",
	}
)

AddTile("SAP_BATCAVE", "LAND",
	{
		ground_name 	= "Bat Cave",
		old_static_id 	= 97,
	},
	{
		name			= "cave",
		noise_texture	= "levels/textures/hamlet/batcave_noise.tex",
		runsound        = run_dirt,
		walksound       = walk_dirt,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/batcave_mini.tex",
	},
	{
		name			= "batcave",
		anim			= "batcave",
		bank_build		= "kyno_turfs_hamlet",
		pickupsound     = "rock",
	}
)

AddTile("SAP_LEGACYRAINFOREST", "LAND",
	{
		ground_name 	= "Legacy Rain Forest",
		old_static_id 	= 98,
	},
	{
		name			= "rain_forest",
		noise_texture	= "levels/textures/hamlet/Ground_noise_rainforest2.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_noise_rainforest.tex",
	},
	{
		name			= "legacyrainforest",
		anim			= "legacyrainforest",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_LEGACYDEEPJUNGLE", "LAND",
	{
		ground_name 	= "Legacy Deep Jungle",
		old_static_id 	= 99,
	},
	{
		name			= "jungle_deep",
		noise_texture	= "levels/textures/hamlet/Ground_noise_jungle_deep2.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_noise_jungle_deep.tex",
	},
	{
		name			= "legacydeepjungle",
		anim			= "legacydeepjungle",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_LEGACYBOG", "LAND",
	{
		ground_name 	= "Legacy Bog",
		old_static_id 	= 100,
	},
	{
		name			= "cave",
		noise_texture	= "levels/textures/hamlet/mini_noise_bog2.tex",
		runsound		= run_sand,
		walksound		= walk_sand,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_noise_bog2.tex",
	},
	{
		name			= "legacybog",
		anim			= "legacybog",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "vegetation_firm",
	}
)

AddTile("SAP_GREENMARSH", "LAND",
	{
		ground_name 	= "Green Marsh",
		old_static_id 	= 101,
	},
	{
		name			= "tidalmarsh",
		noise_texture	= "levels/textures/hamlet/Ground_noise_greenswamp.tex",
		runsound		= run_marsh,
		walksound		= walk_marsh,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/hamlet/mini_noise_greenswamp.tex",
	},
	{
		name			= "greenmarsh",
		anim			= "greenmarsh",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "squidgy",
	}
)

AddTile("SAP_IVYGRASS", "LAND",
	{
		ground_name 	= "Ivy Grass",
		old_static_id 	= 102,
	},
	{
		name			= "rain_forest",
		noise_texture	= "levels/textures/other/noise_ivy.tex",
		runsound		= run_grass,
		walksound		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_ivy.tex",
	},
	{
		name			= "ivygrass",
		anim			= "ivygrass",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "vegetation_grassy",
	}
)

AddTile("SAP_LEAKPROOFCARPET", "LAND",
	{
		ground_name 	= "Leakproof Carpet",
		old_static_id 	= 103,
	},
	{
		name			= "carpet",
		noise_texture	= "levels/textures/other/noise_leakproofcarpet.tex",
		runsound 		= run_carpet,
        walksound 		= walk_carpet,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		flooring		= true,
		flashpoint 		= 250,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_leakproofcarpet.tex",
	},
	{
		name			= "leakproofcarpet",
		anim			= "leakproofcarpet",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "cloth",
	}
)

AddTile("SAP_WOODPANEL", "LAND",
	{
		ground_name 	= "Wood Panel",
		old_static_id 	= 104,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/interior/shop_floor_woodpanel.tex",
		runsound 		= run_wood,
        walksound 		= walk_wood,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_woodpanel.tex",
	},
	{
		name			= "woodpanel",
		anim			= "woodpanel",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "wood",
	}
)

AddTile("SAP_MARBLETILE", "LAND",
	{
		ground_name 	= "Marble Tile",
		old_static_id 	= 105,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/interior/shop_floor_marble.tex",
		runsound 		= run_marble,
        walksound 		= walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_marble.tex",
	},
	{
		name			= "marbletile",
		anim			= "marbletile",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "rock",
	}
)

AddTile("SAP_CHESS", "LAND",
	{
		ground_name 	= "Chess",
		old_static_id 	= 106,
	},
	{
		name			= "pebble",
		noise_texture	= "levels/textures/interior/shop_floor_checker.tex",
		runsound 		= run_marble,
        walksound 		= walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		roadways        = true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_checker.tex",
	},
	{
		name			= "chess",
		anim			= "chess",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "rock",
	}
)

AddTile("SAP_SLATE", "LAND",
	{
		ground_name 	= "Slate",
		old_static_id 	= 107,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/interior/shop_floor_slate.tex",
		runsound 		= run_marble,
        walksound 		= walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_slate.tex",
	},
	{
		name			= "slate",
		anim			= "slate",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "rock",
	}
)

AddTile("SAP_METALSHEET", "LAND",
	{
		ground_name 	= "Metal Sheet",
		old_static_id 	= 108,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/interior/shop_floor_sheetmetal.tex",
		runsound 		= run_marble,
        walksound 		= walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_sheetmetal.tex",
	},
	{
		name			= "metalsheet",
		anim			= "metalsheet",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "metal",
	}
)

AddTile("SAP_GARDEN", "LAND",
	{
		ground_name 	= "Garden",
		old_static_id 	= 109,
	},
	{
		name			= "cave",
		noise_texture	= "levels/textures/interior/shop_floor_gardenstone.tex",
		runsound 		= run_grass,
        walksound 		= walk_grass,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= false,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_gardenstone.tex",
	},
	{
		name			= "garden",
		anim			= "garden",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "vegetation_firm",
	}
)

AddTile("SAP_GEOMETRIC", "LAND",
	{
		ground_name 	= "Geometric",
		old_static_id 	= 110,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/interior/shop_floor_geometric.tex",
		runsound 		= run_marble,
        walksound 		= walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_geometric.tex",
	},
	{
		name			= "geometric",
		anim			= "geometric",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "rock",
	}
)

AddTile("SAP_SHAGCARPET", "LAND",
	{
		ground_name 	= "Shag Carpet",
		old_static_id 	= 111,
	},
	{
		name			= "carpet",
		noise_texture	= "levels/textures/interior/shop_floor_carpet.tex",
		runsound 		= run_carpet,
        walksound 		= walk_carpet,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		flooring		= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_carpet.tex",
	},
	{
		name			= "shagcarpet",
		anim			= "shagcarpet",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "cloth",
	}
)

AddTile("SAP_TRANSITIONAL", "LAND",
	{
		ground_name 	= "Transitional",
		old_static_id 	= 112,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/interior/shop_floor_transitional.tex",
		runsound 		= run_wood,
        walksound 		= walk_wood,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_transitional.tex",
	},
	{
		name			= "transitional",
		anim			= "transitional",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "wood",
	}
)

AddTile("SAP_HERRING", "LAND",
	{
		ground_name 	= "HERRING",
		old_static_id 	= 113,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/interior/shop_floor_herringbone.tex",
		runsound 		= run_marble,
        walksound 		= walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		roadways        = true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_herringbone.tex",
	},
	{
		name			= "herring",
		anim			= "herring",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "rock",
	}
)

AddTile("SAP_HEXAGON", "LAND",
	{
		ground_name 	= "Hexagon",
		old_static_id 	= 114,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/interior/shop_floor_hexagon.tex",
		runsound 		= run_marble,
        walksound 		= walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_hexagon.tex",
	},
	{
		name			= "hexagon",
		anim			= "hexagon",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "rock",
	}
)

AddTile("SAP_HOOF", "LAND",
	{
		ground_name 	= "Hoof",
		old_static_id 	= 115,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/interior/shop_floor_hoof_curvy.tex",
		runsound 		= run_marble,
        walksound 		= walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_hoof_curvy.tex",
	},
	{
		name			= "hoof",
		anim			= "hoof",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "rock",
	}
)

AddTile("SAP_OCTAGON", "LAND",
	{
		ground_name 	= "Octagon",
		old_static_id 	= 116,
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/interior/shop_floor_octagon.tex",
		runsound 		= run_marble,
        walksound 		= walk_marble,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/interior/mini_shop_floor_octagon.tex",
	},
	{
		name			= "octagon",
		anim			= "octagon",
		bank_build		= "kyno_turfs_interior",
		pickupsound     = "rock",
	}
)

AddTile("SAP_REDCARPET", "LAND",
	{
		ground_name 	= "Red Carpet",
		old_static_id 	= 117,
	},
	{
		name			= "carpet",
		noise_texture	= "levels/textures/other/noise_redcarpet.tex",
		runsound 		= run_carpet,
        walksound 		= walk_carpet,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		flooring		= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_redcarpet.tex",
	},
	{
		name			= "redcarpet",
		anim			= "redcarpet",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "cloth",
	}
)

AddTile("SAP_PINKCARPET", "LAND",
	{
		ground_name 	= "Pink Carpet",
		old_static_id 	= 118,
	},
	{
		name			= "carpet",
		noise_texture	= "levels/textures/other/noise_pinkcarpet.tex",
		runsound 		= run_carpet,
        walksound 		= walk_carpet,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		flooring		= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_pinkcarpet.tex",
	},
	{
		name			= "pinkcarpet",
		anim			= "pinkcarpet",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "cloth",
	}
)

AddTile("SAP_CYANCARPET", "LAND",
	{
		ground_name 	= "Cyan Carpet",
	},
	{
		name			= "carpet",
		noise_texture	= "levels/textures/other/noise_cyancarpet.tex",
		runsound 		= run_carpet,
        walksound 		= walk_carpet,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		flooring		= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_cyancarpet.tex",
	},
	{
		name			= "cyancarpet",
		anim			= "cyancarpet",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "cloth",
	}
)

AddTile("SAP_WHITECARPET", "LAND",
	{
		ground_name 	= "White Carpet",
	},
	{
		name			= "carpet",
		noise_texture	= "levels/textures/other/noise_whitecarpet.tex",
		runsound 		= run_carpet,
        walksound 		= walk_carpet,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		flooring		= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_whitecarpet.tex",
	},
	{
		name			= "whitecarpet",
		anim			= "whitecarpet",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "cloth",
	}
)

AddTile("SAP_YELLOWCARPET", "LAND",
	{
		ground_name 	= "Yellow Carpet",
	},
	{
		name			= "carpet",
		noise_texture	= "levels/textures/other/noise_yellowcarpet.tex",
		runsound 		= run_carpet,
        walksound 		= walk_carpet,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		flooring		= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_yellowcarpet.tex",
	},
	{
		name			= "yellowcarpet",
		anim			= "yellowcarpet",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "cloth",
	}
)

AddTile("SAP_GREENCARPET", "LAND",
	{
		ground_name 	= "Pink Carpet",
	},
	{
		name			= "carpet",
		noise_texture	= "levels/textures/other/noise_greencarpet.tex",
		runsound 		= run_carpet,
        walksound 		= walk_carpet,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		flooring		= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_greencarpet.tex",
	},
	{
		name			= "greencarpet",
		anim			= "greencarpet",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "cloth",
	}
)

AddTile("SAP_ORANGECARPET", "LAND",
	{
		ground_name 	= "Orange Carpet",
	},
	{
		name			= "carpet",
		noise_texture	= "levels/textures/other/noise_orangecarpet.tex",
		runsound 		= run_carpet,
        walksound 		= walk_carpet,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		flooring		= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_orangecarpet.tex",
	},
	{
		name			= "orangecarpet",
		anim			= "orangecarpet",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "cloth",
	}
)

AddTile("SAP_BLUEYELLOW", "LAND",
	{
		ground_name 	= "Blue Yellow Carpet",
	},
	{
		name			= "carpet",
		noise_texture	= "levels/textures/other/noise_blueyellow.tex",
		runsound 		= run_carpet,
        walksound 		= walk_carpet,
		snowsound		= run_snow,
		mudsound        = run_mud,
		hard			= true,
		flooring		= true,
	},
	{
		name 			= "map_edge",
		noise_texture	= "levels/textures/other/mini_noise_blueyellow.tex",
	},
	{
		name			= "blueyellow",
		anim			= "blueyellow",
		bank_build		= "kyno_turfs_other",
		pickupsound     = "cloth",
	}
)

AddTile("SAP_DRIFTWOODFLOOR", "LAND",
	{
		ground_name     = "Driftwood Flooring",
	},
	{
		name            = "blocky",
		noise_texture   = "levels/textures/other/noise_driftwood.tex",
		runsound        = run_wood,
		walksound       = walk_wood,
		snowsound       = run_snow,
		mudsound        = run_mud,
		hard            = true,
		flooring        = true,
	},
	{
		name            = "map_edge",
		noise_texture   = "levels/textures/other/mini_noise_driftwood.tex",
	},
	{
		name            = "driftwoodfloor",
		anim            = "driftwoodfloor",
		bank_build      = "kyno_turfs_other",
		pickupsound     = "wood",
	}
)

AddTile("SAP_LUNARRIFT", "LAND",
	{
		ground_name     = "Lunar Rift Ground",
	},
	{
		name            = "meteor",
		noise_texture   = "levels/textures/ground_noise_lunarrift.tex",
		runsound        = run_meteor,
		walksound       = walk_meteor,
		snowsound       = run_snow,
		mudsound        = run_mud,
		hard            = true,
	},
	{
		name            = "map_edge",
		noise_texture   = "levels/textures/Ground_noise_lunarrift_mini.tex",
	},
	{
		name            = "lunarrift",
		anim            = "lunarrift",
		bank_build      = "kyno_turfs_other",
		pickupsound     = "rock",
	}
)

AddTile("SAP_VAULTMOSSY", 	"LAND",
	{
		ground_name		= "Mossy Sanctum Stonework",
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/Ground_noise_vault.tex",
		runsound		= run_marble,
		walksound		= walk_marble,
		snowsound		= run_snow,
		mudsound		= run_mud,
		hard			= true,
	},
	{
		name			= "map_edge",
		noise_texture	= "levels/textures/Ground_noise_vault_clean_mini.tex",
	},
	{
		name			= "vaultmossy",
		anim			= "vaultmossy",
		bank_build		= "kyno_turfs_ruins",
		pickupsound		= "rock",
	}
)

AddTile("SAP_WAGSTAFF", 	"LAND",
	{
		ground_name		= "Wagstaff Floor Replica",
	},
	{
		name			= "blocky",
		noise_texture	= "levels/textures/ground_noise_wagstaff_floor.tex",
		runsound		= run_wagdock,
		walksound		= walk_wagdock,
		snowsound		= run_wagdock,
		mudsound		= run_wagdock,
		hard			= true,
	},
	{
		name			= "map_edge",
		noise_texture	= "levels/textures/mini_woodfloor_noise.tex",
	},
	{
		name			= "wagstaff",
		anim			= "idle",
		bank_build		= "wagpunk_floor_kit",
		pickupsound		= "rock",
	}
)

--[[
AddTile("DRIFTWOODDOCKS", "LAND",
	{
		ground_name     = "Driftwood Docks",
	},
	{
		name            = "blocky",
		noise_texture   = "levels/textures/other/noise_driftwooddocks2.tex",
		runsound        = run_docks,
		walksound       = walk_docks,
		snowsound       = run_snow,
		mudsound        = run_mud,
		cannotbedug     = true,
		hard            = true,
		flooring        = true,
	},
	{
		name            = "map_edge",
		noise_texture   = "levels/textures/other/mini_noise_driftwood.tex",
	}
)

-- I have no clue why this isn't working. Maybe I'm being too dumb to understand it.
-- Leave docks with default falloff until I figure this out.
TileGroups.DriftwoodDockTiles = TileGroupManager:AddTileGroup()
TileGroupManager:AddValidTile(TileGroups.DriftwoodDockTiles, WORLD_TILES.DRIFTWOODDOCKS)
TileGroupManager:SetIsTransparentOceanTileGroup(TileGroups.DriftwoodDockTiles)

AddFalloffTexture(4,
	{
        name                          = "driftwood_docks_falloff",
        noise_texture                 = "images/square.tex",
        should_have_falloff           = TileGroups.DriftwoodDockTiles,
        should_have_falloff_result    = true,
        neighbor_needs_falloff        = TileGroups.TransparentOceanTiles,
        neighbor_needs_falloff_result = true
    }
)
]]--

-- Hierarchy of the turfs.
ChangeTileRenderOrder(WORLD_TILES.SAP_PINKSTONE, 			WORLD_TILES.ROAD, 				true)
ChangeTileRenderOrder(WORLD_TILES.SAP_BEACH, 				WORLD_TILES.SAP_PINKSTONE, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_VOLCANO_ROCK, 		WORLD_TILES.SAP_BEACH, 				true)
ChangeTileRenderOrder(WORLD_TILES.SAP_TIDALMARSH, 			WORLD_TILES.MARSH, 				true)
ChangeTileRenderOrder(WORLD_TILES.SAP_GREENMARSH, 			WORLD_TILES.SAP_TIDALMARSH, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_MEADOW, 				WORLD_TILES.DIRT, 				true)
ChangeTileRenderOrder(WORLD_TILES.SAP_JUNGLE, 				WORLD_TILES.SAP_MEADOW, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_VOLCANO, 				WORLD_TILES.DESERT_DIRT, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_ASH, 					WORLD_TILES.SAP_VOLCANO, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_MAGMAFIELD, 			WORLD_TILES.SAP_ASH, 				true)
ChangeTileRenderOrder(WORLD_TILES.SAP_ANTCAVE, 				WORLD_TILES.SAP_MAGMAFIELD, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_BATCAVE, 				WORLD_TILES.SAP_ANTCAVE, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_COPACABANA, 			WORLD_TILES.SAP_BATCAVE, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_LEGACYBOG, 			WORLD_TILES.SAP_COPACABANA, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_BOG, 					WORLD_TILES.SAP_LEGACYBOG, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_PLAINS, 				WORLD_TILES.SAP_BOG, 				true)
ChangeTileRenderOrder(WORLD_TILES.SAP_LEGACYRAINFOREST, 	WORLD_TILES.SAP_PLAINS, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_LEGACYDEEPJUNGLE, 	WORLD_TILES.SAP_LEGACYRAINFOREST,	true)
ChangeTileRenderOrder(WORLD_TILES.SAP_RAINFOREST, 			WORLD_TILES.SAP_LEGACYDEEPJUNGLE, 	true)
ChangeTileRenderOrder(WORLD_TILES.SAP_DEEPJUNGLE, 			WORLD_TILES.SAP_RAINFOREST, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_GASJUNGLE, 			WORLD_TILES.SAP_DEEPJUNGLE, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_FIELDS, 				WORLD_TILES.SAP_GASJUNGLE, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_IVYGRASS, 			WORLD_TILES.SAP_FIELDS, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_SWIRLGRASS, 			WORLD_TILES.SAP_IVYGRASS, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_SWIRLGRASSMONO, 		WORLD_TILES.SAP_SWIRLGRASS, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_GREYFOREST, 			WORLD_TILES.SAP_SWIRLGRASSMONO, 	true)
ChangeTileRenderOrder(WORLD_TILES.SAP_MOSSY_BLOSSOM, 		WORLD_TILES.SAP_GREYFOREST, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_PIGRUINS, 			WORLD_TILES.SAP_MOSSY_BLOSSOM, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_FOUNDATION, 			WORLD_TILES.SAP_PIGRUINS, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_WOODPANEL, 			WORLD_TILES.SAP_FOUNDATION, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_MARBLETILE, 			WORLD_TILES.SAP_WOODPANEL, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_CHESS, 				WORLD_TILES.SAP_MARBLETILE, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_SLATE, 				WORLD_TILES.SAP_CHESS, 				true)
ChangeTileRenderOrder(WORLD_TILES.SAP_METALSHEET, 			WORLD_TILES.SAP_SLATE, 				true)
ChangeTileRenderOrder(WORLD_TILES.SAP_GARDEN, 				WORLD_TILES.SAP_METALSHEET, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_GEOMETRIC, 			WORLD_TILES.SAP_GARDEN, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_TRANSITIONAL, 		WORLD_TILES.SAP_GEOMETRIC, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_HERRING, 				WORLD_TILES.SAP_TRANSITIONAL, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_HEXAGON, 				WORLD_TILES.SAP_HERRING, 	 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_HOOF, 				WORLD_TILES.SAP_HEXAGON, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_OCTAGON, 				WORLD_TILES.SAP_HOOF, 				true)
ChangeTileRenderOrder(WORLD_TILES.SAP_SHAGCARPET, 			WORLD_TILES.SAP_OCTAGON, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_STICKY, 				WORLD_TILES.SAP_SHAGCARPET, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_SNOWFALL, 			WORLD_TILES.SAP_STICKY, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_DRIFTWOODFLOOR,       WORLD_TILES.SCALE,              true)
ChangeTileRenderOrder(WORLD_TILES.SAP_LUNARRIFT,            WORLD_TILES.METEOR,             true)
ChangeTileRenderOrder(WORLD_TILES.SAP_VAULTMOSSY,	        WORLD_TILES.VAULT,              true)
ChangeTileRenderOrder(WORLD_TILES.SAP_WAGSTAFF,             WORLD_TILES.SAP_DRIFTWOODFLOOR,     true)
ChangeTileRenderOrder(WORLD_TILES.SAP_REDCARPET, 			WORLD_TILES.CARPET, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_PINKCARPET,			WORLD_TILES.SAP_REDCARPET,			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_CYANCARPET,			WORLD_TILES.SAP_PINKCARPET,			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_WHITECARPET,			WORLD_TILES.SAP_CYANCARPET,			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_YELLOWCARPET,			WORLD_TILES.SAP_WHITECARPET,		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_GREENCARPET,			WORLD_TILES.SAP_YELLOWCARPET,		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_LEAKPROOFCARPET, 		WORLD_TILES.SAP_GREENCARPET, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_ORANGECARPET,			WORLD_TILES.SAP_LEAKPROOFCARPET, 	true)
ChangeTileRenderOrder(WORLD_TILES.SAP_BLUEYELLOW,			WORLD_TILES.SAP_ORANGECARPET,		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_SNAKESKINFLOOR, 		WORLD_TILES.SAP_BLUEYELLOW, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_LAWN, 				WORLD_TILES.SAP_SNAKESKINFLOOR,     true)
ChangeTileRenderOrder(WORLD_TILES.SAP_BROWNCARPET, 			WORLD_TILES.SAP_LAWN, 				true)
ChangeTileRenderOrder(WORLD_TILES.SAP_FORGEROAD, 			WORLD_TILES.SAP_BROWNCARPET, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_COBBLEROAD, 			WORLD_TILES.SAP_FORGEROAD, 			true)
ChangeTileRenderOrder(WORLD_TILES.SAP_MODERN_COBBLESTONES, 	WORLD_TILES.SAP_COBBLEROAD, 		true)
ChangeTileRenderOrder(WORLD_TILES.SAP_FORGEROCK, 			WORLD_TILES.UNDERROCK, 			true)

local GROUND_TURFS =
{
	[WORLD_TILES.QUAGMIRE_PARKFIELD] = "turf_pinkpark",
	[WORLD_TILES.QUAGMIRE_CITYSTONE] = "turf_stonecity",
}

require("worldtiledefs").turf[WORLD_TILES.QUAGMIRE_PARKFIELD] =
{
	name = "pinkpark",
	bank_build = "kyno_turfs_events",
	anim = "pinkpark",
	pickupsound = "vegetation_grassy",
}

require("worldtiledefs").turf[WORLD_TILES.QUAGMIRE_CITYSTONE] =
{
	name = "stonecity",
	bank_build = "kyno_turfs_events",
	anim = "stonecity",
	pickupsound = "rock",
	hard = true,
	roadways = true,
}
