require("tilemanager")

-- Common Dependencies.
local _G 				= GLOBAL
local GROUND 			= _G.GROUND

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
AddTile("SWIRLGRASS", "LAND", 
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

AddTile("SWIRLGRASSMONO", "LAND", 
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

AddTile("COPACABANA", "LAND", 
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

AddTile("STICKY", "LAND",
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

AddTile("SNOWFALL", "LAND", 
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

AddTile("MODERN_COBBLESTONES", "LAND", 
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

AddTile("PINKSTONE", "LAND", 
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
AddTile("BEACH", "LAND", 
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

AddTile("VOLCANO_ROCK", "LAND", 
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

AddTile("TIDALMARSH", "LAND", 
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

AddTile("MEADOW", "LAND", 
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

AddTile("JUNGLE", "LAND", 
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

AddTile("VOLCANO", "LAND", 
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

AddTile("ASH", "LAND", 
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

AddTile("MAGMAFIELD", "LAND", 
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

AddTile("SNAKESKINFLOOR", "LAND", 
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

AddTile("COBBLEROAD", "LAND", 
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

AddTile("PIGRUINS", "LAND", 
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

AddTile("FIELDS", "LAND", 
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

AddTile("FOUNDATION", "LAND", 
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

AddTile("LAWN", "LAND", 
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

AddTile("RAINFOREST", "LAND", 
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

AddTile("PLAINS", "LAND", 
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
	
AddTile("DEEPJUNGLE", "LAND", 
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

AddTile("BOG", "LAND", 
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

AddTile("MOSSY_BLOSSOM", "LAND", 
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
	
AddTile("GASJUNGLE", "LAND", 
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
AddTile("GREYFOREST", "LAND", 
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

AddTile("BROWNCARPET", "LAND", 
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

AddTile("FORGEROCK", "LAND", 
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

AddTile("FORGEROAD", "LAND", 
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

AddTile("ANTCAVE", "LAND", 
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

AddTile("BATCAVE", "LAND", 
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

AddTile("LEGACYRAINFOREST", "LAND", 
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

AddTile("LEGACYDEEPJUNGLE", "LAND", 
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

AddTile("LEGACYBOG", "LAND", 
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

AddTile("GREENMARSH", "LAND", 
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

AddTile("IVYGRASS", "LAND", 
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

AddTile("LEAKPROOFCARPET", "LAND", 
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

AddTile("WOODPANEL", "LAND", 
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

AddTile("MARBLETILE", "LAND", 
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

AddTile("CHESS", "LAND", 
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

AddTile("SLATE", "LAND", 
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

AddTile("METALSHEET", "LAND", 
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

AddTile("GARDEN", "LAND", 
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

AddTile("GEOMETRIC", "LAND", 
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

AddTile("SHAGCARPET", "LAND", 
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

AddTile("TRANSITIONAL", "LAND", 
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

AddTile("HERRING", "LAND", 
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

AddTile("HEXAGON", "LAND", 
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

AddTile("HOOF", "LAND", 
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

AddTile("OCTAGON", "LAND", 
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

AddTile("REDCARPET", "LAND", 
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

AddTile("PINKCARPET", "LAND", 
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
	
AddTile("CYANCARPET", "LAND", 
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

AddTile("WHITECARPET", "LAND", 
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

AddTile("YELLOWCARPET", "LAND", 
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

AddTile("GREENCARPET", "LAND", 
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

AddTile("ORANGECARPET", "LAND", 
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

AddTile("BLUEYELLOW", "LAND", 
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

AddTile("DRIFTWOODFLOOR", "LAND",
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

AddTile("LUNARRIFT", "LAND",
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

AddTile("VAULTMOSSY", 	"LAND",
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

AddTile("WAGSTAFF", 	"LAND",
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
ChangeTileRenderOrder(WORLD_TILES.PINKSTONE, 			WORLD_TILES.ROAD, 				true)
ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_CITYSTONE, 	WORLD_TILES.PINKSTONE, 			true)
ChangeTileRenderOrder(WORLD_TILES.BEACH, 				WORLD_TILES.QUAGMIRE_CITYSTONE, true)
ChangeTileRenderOrder(WORLD_TILES.VOLCANO_ROCK, 		WORLD_TILES.BEACH, 				true)
ChangeTileRenderOrder(WORLD_TILES.TIDALMARSH, 			WORLD_TILES.MARSH, 				true)
ChangeTileRenderOrder(WORLD_TILES.GREENMARSH, 			WORLD_TILES.TIDALMARSH, 		true)
ChangeTileRenderOrder(WORLD_TILES.MEADOW, 				WORLD_TILES.DIRT, 				true)
ChangeTileRenderOrder(WORLD_TILES.JUNGLE, 				WORLD_TILES.MEADOW, 			true)
ChangeTileRenderOrder(WORLD_TILES.VOLCANO, 				WORLD_TILES.DESERT_DIRT, 		true)
ChangeTileRenderOrder(WORLD_TILES.ASH, 					WORLD_TILES.VOLCANO, 			true)
ChangeTileRenderOrder(WORLD_TILES.MAGMAFIELD, 			WORLD_TILES.ASH, 				true)
ChangeTileRenderOrder(WORLD_TILES.ANTCAVE, 				WORLD_TILES.MAGMAFIELD, 		true)
ChangeTileRenderOrder(WORLD_TILES.BATCAVE, 				WORLD_TILES.ANTCAVE, 			true)
ChangeTileRenderOrder(WORLD_TILES.COPACABANA, 			WORLD_TILES.BATCAVE, 			true)
ChangeTileRenderOrder(WORLD_TILES.LEGACYBOG, 			WORLD_TILES.COPACABANA, 		true)
ChangeTileRenderOrder(WORLD_TILES.BOG, 					WORLD_TILES.LEGACYBOG, 			true)
ChangeTileRenderOrder(WORLD_TILES.PLAINS, 				WORLD_TILES.BOG, 				true)
ChangeTileRenderOrder(WORLD_TILES.LEGACYRAINFOREST, 	WORLD_TILES.PLAINS, 			true)
ChangeTileRenderOrder(WORLD_TILES.LEGACYDEEPJUNGLE, 	WORLD_TILES.LEGACYRAINFOREST,	true)
ChangeTileRenderOrder(WORLD_TILES.RAINFOREST, 			WORLD_TILES.LEGACYDEEPJUNGLE, 	true)
ChangeTileRenderOrder(WORLD_TILES.DEEPJUNGLE, 			WORLD_TILES.RAINFOREST, 		true)
ChangeTileRenderOrder(WORLD_TILES.GASJUNGLE, 			WORLD_TILES.DEEPJUNGLE, 		true)
ChangeTileRenderOrder(WORLD_TILES.FIELDS, 				WORLD_TILES.GASJUNGLE, 			true)
ChangeTileRenderOrder(WORLD_TILES.IVYGRASS, 			WORLD_TILES.FIELDS, 			true)
ChangeTileRenderOrder(WORLD_TILES.SWIRLGRASS, 			WORLD_TILES.IVYGRASS, 			true)
ChangeTileRenderOrder(WORLD_TILES.SWIRLGRASSMONO, 		WORLD_TILES.SWIRLGRASS, 		true)
ChangeTileRenderOrder(WORLD_TILES.QUAGMIRE_PARKFIELD, 	WORLD_TILES.SWIRLGRASSMONO, 	true)
ChangeTileRenderOrder(WORLD_TILES.GREYFOREST, 			WORLD_TILES.QUAGMIRE_PARKFIELD, true)
ChangeTileRenderOrder(WORLD_TILES.MOSSY_BLOSSOM, 		WORLD_TILES.GREYFOREST, 		true)
ChangeTileRenderOrder(WORLD_TILES.PIGRUINS, 			WORLD_TILES.MOSSY_BLOSSOM, 		true)
ChangeTileRenderOrder(WORLD_TILES.FOUNDATION, 			WORLD_TILES.PIGRUINS, 			true)
ChangeTileRenderOrder(WORLD_TILES.WOODPANEL, 			WORLD_TILES.FOUNDATION, 		true)
ChangeTileRenderOrder(WORLD_TILES.MARBLETILE, 			WORLD_TILES.WOODPANEL, 			true)
ChangeTileRenderOrder(WORLD_TILES.CHESS, 				WORLD_TILES.MARBLETILE, 		true)
ChangeTileRenderOrder(WORLD_TILES.SLATE, 				WORLD_TILES.CHESS, 				true)
ChangeTileRenderOrder(WORLD_TILES.METALSHEET, 			WORLD_TILES.SLATE, 				true)
ChangeTileRenderOrder(WORLD_TILES.GARDEN, 				WORLD_TILES.METALSHEET, 		true)
ChangeTileRenderOrder(WORLD_TILES.GEOMETRIC, 			WORLD_TILES.GARDEN, 			true)
ChangeTileRenderOrder(WORLD_TILES.TRANSITIONAL, 		WORLD_TILES.GEOMETRIC, 			true)
ChangeTileRenderOrder(WORLD_TILES.HERRING, 				WORLD_TILES.TRANSITIONAL, 		true)
ChangeTileRenderOrder(WORLD_TILES.HEXAGON, 				WORLD_TILES.HERRING, 	 		true)
ChangeTileRenderOrder(WORLD_TILES.HOOF, 				WORLD_TILES.HEXAGON, 			true)
ChangeTileRenderOrder(WORLD_TILES.OCTAGON, 				WORLD_TILES.HOOF, 				true)
ChangeTileRenderOrder(WORLD_TILES.SHAGCARPET, 			WORLD_TILES.OCTAGON, 			true)
ChangeTileRenderOrder(WORLD_TILES.STICKY, 				WORLD_TILES.SHAGCARPET, 		true)
ChangeTileRenderOrder(WORLD_TILES.SNOWFALL, 			WORLD_TILES.STICKY, 			true)
ChangeTileRenderOrder(WORLD_TILES.DRIFTWOODFLOOR,       WORLD_TILES.SCALE,              true)
ChangeTileRenderOrder(WORLD_TILES.LUNARRIFT,            WORLD_TILES.METEOR,             true)
ChangeTileRenderOrder(WORLD_TILES.VAULTMOSSY,	        WORLD_TILES.VAULT,              true)
ChangeTileRenderOrder(WORLD_TILES.WAGSTAFF,             WORLD_TILES.DRIFTWOODFLOOR,     true)
ChangeTileRenderOrder(WORLD_TILES.REDCARPET, 			WORLD_TILES.CARPET, 			true)
ChangeTileRenderOrder(WORLD_TILES.PINKCARPET,			WORLD_TILES.REDCARPET,			true)
ChangeTileRenderOrder(WORLD_TILES.CYANCARPET,			WORLD_TILES.PINKCARPET,			true)
ChangeTileRenderOrder(WORLD_TILES.WHITECARPET,			WORLD_TILES.CYANCARPET,			true)
ChangeTileRenderOrder(WORLD_TILES.YELLOWCARPET,			WORLD_TILES.WHITECARPET,		true)
ChangeTileRenderOrder(WORLD_TILES.GREENCARPET,			WORLD_TILES.YELLOWCARPET,		true)
ChangeTileRenderOrder(WORLD_TILES.LEAKPROOFCARPET, 		WORLD_TILES.GREENCARPET, 		true)
ChangeTileRenderOrder(WORLD_TILES.ORANGECARPET,			WORLD_TILES.LEAKPROOFCARPET, 	true)
ChangeTileRenderOrder(WORLD_TILES.BLUEYELLOW,			WORLD_TILES.ORANGECARPET,		true)
ChangeTileRenderOrder(WORLD_TILES.SNAKESKINFLOOR, 		WORLD_TILES.BLUEYELLOW, 		true)
ChangeTileRenderOrder(WORLD_TILES.LAWN, 				WORLD_TILES.SNAKESKINFLOOR,     true)
ChangeTileRenderOrder(WORLD_TILES.BROWNCARPET, 			WORLD_TILES.LAWN, 				true)
ChangeTileRenderOrder(WORLD_TILES.FORGEROAD, 			WORLD_TILES.BROWNCARPET, 		true)
ChangeTileRenderOrder(WORLD_TILES.COBBLEROAD, 			WORLD_TILES.FORGEROAD, 			true)
ChangeTileRenderOrder(WORLD_TILES.MODERN_COBBLESTONES, 	WORLD_TILES.COBBLEROAD, 		true)
ChangeTileRenderOrder(WORLD_TILES.FORGEROCK, 			WORLD_TILES.UNDERROCK, 			true)

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