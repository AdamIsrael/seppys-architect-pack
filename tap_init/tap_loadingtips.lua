-- Common Dependencies.
local _G 			= GLOBAL
local require 		= _G.require
local STRINGS       = _G.STRINGS

-- New Loading Tips and Lore.
local TIPS_LORE 	= LOADING_SCREEN_LORE_TIPS
local TIPS_SURVIVAL = LOADING_SCREEN_SURVIVAL_TIPS
local TIPS_TAP 		= STRINGS.UI.LOADING_SCREEN_OTHER_TIPS
local WEIGHT_START  = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_START
local WEIGHT_END    = _G.LOADING_SCREEN_TIP_CATEGORY_WEIGHTS_END

-- Our Tips.
AddLoadingTip(TIPS_TAP, "TIPS_TAP_ORIGIN", 		"Originally, The Architect Pack was a collection of mods downloadable in Steam Workshop separately.")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_GLERMZ", 		"Glermz is who idealized The Architect Pack as a mod that would include every single structure of Don't Starve universe.")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_PACKIM", 		"You can get Packim Baggims from Malbatross as a reward for defeating him, if you have the option enabled in the mod configuration.")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_ROBIN",  		"You can get Ro Bin from Ancient Guardian as a reward for defeating him, if you have the option enabled in the mod configuration.")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_SLOTM",  		"\"The Slot Machine is hiding something, I can tell!\" -W")
-- AddLoadingTip(TIPS_TAP, "TIPS_TAP_BPMOBS", 		"Some mobs drops special blueprints to unlock unique structures!")
-- AddLoadingTip(TIPS_TAP, "TIPS_TAP_ORGIN2", 		"The very first version of The Architect Pack was called \"The Gorge Stuff\".")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_PARROT", 		"The parrots have some interesting dialogues if you stand near them.")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_OGAIT",  		"Ogait has died 4.294.967.295 times playing The Architect Pack.")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_MYMODS", 		"The Architect Pack is more enjoyable for playing when paired with Heap Of Foods and Apparels Overload mods.")
-- AddLoadingTip(TIPS_TAP, "TIPS_TAP_LIVNIG", 		"There's a small chance for the Totally Normal Tree drops a Root Trunk blueprint when chopped.")
-- AddLoadingTip(TIPS_TAP, "TIPS_TAP_TRASH",  		"\"The Ominous Carving seems to act like a trash can. Maybe I can get rid of some useless things now.\" -W")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_BIRTHDAY",  	"The Architect Pack's birthday is November 3rd!")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_LAUNCH", 		"The Architect Pack was officially launched to the public in NexusMods on November 3rd, 2020.")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_LAUNCH2",		"The Architect Pack was officially launched to the public in Steam Workshop on March 18th, 2021.")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_SPRINKLER", 	"Tired of watering crops manually? Build yourself a Garden Sprinkler!")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_THUMPER",		"The Thumper can be used to farm an enormous amount of resources in a single shot!")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_DOYDOY", 		"\"Doydoys eats almost everything! Yesterday I left some food in the Crock Pot, and when I returned, the food was gone!\" -W")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_ELEPHANT",	"Elephant Cactus can be a great defense against Hound Waves, even with some Giants!")
AddLoadingTip(TIPS_TAP, "TIPS_TAP_ELEPHANT2", 	"The legends says that a normal Elephant Cactus Replica can turn into a living being during the summer, but it's just a legend...")

AddLoadingTip(TIPS_TAP, "TIPS_SAP_LAUNCH",		"Seppy's Architect Pack was officially launched to the public in Steam Workshop on December 25th, 2025.")

-- We want that our custom tips appears more often.
SetLoadingTipCategoryWeights(WEIGHT_START, {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})
SetLoadingTipCategoryWeights(WEIGHT_END,   {OTHER = 4, CONTROLS = 1, SURVIVAL = 1, LORE = 1, LOADING_SCREEN = 1})
