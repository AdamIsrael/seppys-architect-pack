name = "Seppy's Architect Pack"
version = "2.0.0"

description = [[
🛈 This is a fork of the discontinued mod "The Architect Pack", which attempts to maintain the original mod's content and functionality while fixing bugs and compatibility with new versions of Don't Starve Together and other mods.

󰀂 This mod contains huge amount of decorative structures for Base Building. Design and shape the world as you please!

󰀅 Also includes tons of special structures, items and easter eggs, go find em' all. They might be right under your nose!

󰀏 Includes contents from: Shipwrecked, Hamlet, The Forge, The Gorge and exclusive contents!

󰀖 Credits on the mod page!
󰀌 Mod Version: 2.0.0

󰀧 Changelog:
- Version 2.0.0: Added compatibility with other mods and fixed bugs, especially with other mods containing a large number of audio assets that could cause the game to crash.
- Version 1.0.0: Initial release.

Links:
- Home page: [url=https://github.com/AdamIsrael/seppys-architect-pack]Github[/url]
- Bug Reports: [url=https://github.com/AdamIsrael/seppys-architect-pack/issues]Issues[/url]

]]

author = "Adam Israel"
api_version = 10

dst_compatible = true
all_clients_require_mod = true
client_only_mod = false

server_filter_tags = {"TBS", "TAP", "SAP", "Decorations", "Base Building", "Mega Base"}

icon_atlas = "ModiconTAP.xml"
icon = "ModiconTAP.tex"

local emptyoptions = {{description = "", data = false}}
local function Title(title, hover)
	return
	{
		name = title,
		hover = hover,
		options = {{description = "", data = 0}},
		default = 0,
	}
end

configuration_options =
{
	Title("Modes", "Choose the mode the mod will work."),
	{
        name = "TAP_BUILDING_MIGRATOR",
        label = "Multi-Shard Mode",
        hover = "Choose if the mod can use Multi-Shard links.",
        options =
        {
            {description = "No",
			hover = "Some structures WILL NOT have support for Multi-Shard.",
			data = 0},
            {description = "Yes",
			hover = "Some structures WILL have support for Multi-Shard.",
			data = 1},
        },
        default = 0,
    },
	{
        name = "TAP_PLACING_METHOD",
        label = "Placer Mode",
        hover = "Choose the placer method for structures.",
        options =
        {
            {description = "Classic",
			hover = "The original placer method, nothing changed.",
			data = 0},
            {description = "Closer",
			hover = "Structures can be placed super close.",
			data = 1},
        },
        default = 0,
    },
	{
        name = "TAP_STATUES_PLACER",
        label = "Statues Placer Mode",
        hover = "Choose the placer method for statues (May conflict with similar mods).",
        options =
        {
            {description = "Classic",
			hover = "The original placer method, nothing changed.",
			data = 0},
            {description = "On Grid",
			hover = "Statues will be placed in a grid.",
			data = 1},
        },
        default = 0,
    },
	Title("Tweaks", "Note: Some options below may affect your gameplay if enabled."),
	{
		name = "TAP_LOAD_AUDIO",
		label = "Load Audio Assets",
		hover = "Enable/disable audio for this mod. Disable if using Island Adventures or similarly large mods to prevent FMOD crashes.",
		options =
		{
			{description = "Enabled",
			hover = "Load all audio files. May crash with Island Adventures or other large mods.",
			data = true},
			{description = "Disabled",
			hover = "Skip audio loading. Structures will be silent but the game won't crash.",
			data = false},
		},
		default = true,
	},
    {
        name = "TAP_FOOD_FRESH",
        label = "Keep Food on Crock Pot",
        hover = "Finished cooked food will not turn to spoiled food before harvested from crock pot.",
        options =
        {
            {description = "No",
		hover = "Food WILL spoil if you leave them on crock pot.",
		data = 0},
            {description = "Yes",
		hover = "Food WILL NOT spoil if you leave them on crock pot.",
		data = 1},
        },
        default = 0,
    },
	{
		name = "TAP_TWEAK_RECIPES",
		label = "Tweaked Recipes",
		hover = "Some recipes from the game will be tweaked for building means.",
		options =
		{
			{description = "No",
			hover = "Default recipes from Don't Starve Together.",
			data = 0},
			{description = "Yes",
			hover = "Tweak turfs, gates, fences and wall recipes.",
			data = 1},
		},
		default = 0,
	},
	{
		name = "TAP_HAMLET_YOTP",
		label = "Pig Fiesta Decorations",
		hover = "Some Hamlet Structures will have Pig Fiesta decorations!",
		options =
		{
			{description = "No",
			hover = "Structures from Hamlet WILL NOT have Aporkalypse Festival decorations.",
			data = 0},
			{description = "Yes",
			hover = "Structures from Hamlet WILL have Aporkalypse Festival decorations.",
			data = 1},
		},
		default = 0,
	},
	{
		name = "TAP_TREE_CYCLE",
		label = "Tree Cycle",
		hover = "Choose if trees can cycle again when reach the final stage.",
		options =
		{
			{description = "No",
			hover = "Trees will not cycle again when reach the final stage.",
			data = 0},
			{description = "Yes",
			hover = "Trees will cycle again when reach the final stage.",
			data = 1},
		},
		default = 1,
	},
	{
		name = "TAP_BIRD_PERISH",
		label = "Immortal Birds",
		hover = "Choose if birds can last forever or not.",
		options =
		{
			{description = "No",
			hover = "Birds will perish and die. (Happy Woodie noises!)",
			data = 0},
			{description = "Yes",
			hover = "Birds will live forever. (Angry Woodie noises)",
			data = 1},
		},
		default = 0,
	},
	Title("End Table", "Options for the End Table."),
	{
        name = "TAP_ENDTABLE_LIGHT",
        label = "Infinite Light",
        hover = "Choose if End Tables can have infinite light or not.",
        options =
        {
            {description = "No",
			hover = "Light Bulbs and Glow Berries WILL NOT last forever.",
			data = 0},
            {description = "Yes",
			hover = "Light Bulbs and Glow Berries WILL last forever.",
			data = 1},
        },
        default = 0,
    },
    {
        name = "TAP_ENDTABLE_DECOR",
        label = "Infinite Flower",
        hover = "Choose if End Tables can have infinite flowers or not.",
        options =
        {
            {description = "No",
			hover = "Flowers WILL NOT last forever.",
			data = 0},
            {description = "Yes",
			hover = "Flowers WILL last forever.",
			data = 1},
        },
        default = 0,
    },
	Title("Infinite Light", "Options for the Glowcap, Mushlight and Festive Tree."),
	{
        name = "TAP_WINTER_TREE",
        label = "Festive Tree",
		hover = "Choose if Festive Tree can have infinite light or not.",
        options =
        {
            {description = "No",
			hover = "Festive Light WILL NOT last forever inside Festive Tree.",
			data = 0},
            {description = "Yes",
			hover = "Festive Light WILL last forever inside Festive Tree.",
			data = 1},
        },
        default = 0,
    },
    {
        name = "TAP_GLOWCAP",
        label = "Glowcap",
        hover = "Choose if Glowcap can have infinite light or not.",
        options =
        {
            {description = "No",
			hover = "Light Bulbs, Festive Lights, etc. WILL NOT last forever inside Glowcap.",
			data = 0},
            {description = "Yes",
			hover = "Light Bulbs, Festive Lights, etc. WILL last forever inside Glowcap.",
			data = 1},
        },
        default = 0,
    },
    {
        name = "TAP_MUSHLIGHT",
        label = "Mushlight",
        hover = "Choose if Mushlight can have infinite light or not.",
        options =
        {
            {description = "No",
			hover = "Light Bulbs, Festive Lights, etc. WILL NOT last forever inside Mushlight.",
			data = 0},
            {description = "Yes",
			hover = "Light Bulbs, Festive Lights, etc. WILL last forever inside Mushlight.",
			data = 1},
        },
        default = 0,
    },
	Title("Extras", "Note: Some options below may affect your gameplay if enabled."),
	{
		name = "TAP_VANITY",
		label = "Vanity Items",
		hover = "Enable vanity items to increase your decoration power!",
		options =
		{
			{description = "No",
			hover = "Disable vanity items such as oincs, relics etc.",
			data = 0},
			{description = "Yes",
			hover = "Enable vanity items such as oincs, relics etc.",
			data = 1},
		},
		default = 0,
	},
	{
		name = "TAP_SPECIAL_BIRDS",
		label = "Special Birds",
		hover = "Enable special birds to land on different turfs.",
		options =
		{
			{description = "No",
			hover = "Disable special birds landing on turfs.",
			data = 0},
			{description = "Yes",
			hover = "Enable special birds landing on turfs.",
			data = 1},
		},
		default = 1,
	},
	{
		name = "TAP_PACKIM",
		label = "Packim Baggims",
		hover = "Enables Packim Baggims as special drop of Malbatross.",
		options =
		{
			{description = "No (0% Chance)",
			hover = "Default Malbatross loot.",
			data = 0.00},
			{description = "10% Chance",
			hover = "10% Drop rate from Malbatross.",
			data = 0.10},
			{description = "20% Chance",
			hover = "20% Drop rate from Malbatross.",
			data = 0.20},
			{description = "30% Chance",
			hover = "30% Drop rate from Malbatross.",
			data = 0.30},
			{description = "40% Chance",
			hover = "40% Drop rate from Malbatross.",
			data = 0.40},
			{description = "50% Chance",
			hover = "50% Drop rate from Malbatross.",
			data = 0.50},
			{description = "60% Chance",
			hover = "60% Drop rate from Malbatross.",
			data = 0.60},
			{description = "70% Chance",
			hover = "70% Drop rate from Malbatross.",
			data = 0.70},
			{description = "80% Chance",
			hover = "80% Drop rate from Malbatross.",
			data = 0.80},
			{description = "90% Chance",
			hover = "90% Drop rate from Malbatross.",
			data = 0.90},
			{description = "Yes (100% Chance)",
			hover = "100% Drop rate from Malbatross.",
			data = 1.00},
		},
		default = 0.00,
	},
	{
		name = "TAP_ROBIN",
		label = "Ro Bin",
		hover = "Enables Ro Bin as special drop of Ancient Guardian.",
		options =
		{
			{description = "No (0% Chance)",
			hover = "Default Ancient Guardian loot.",
			data = 0.00},
			{description = "10% Chance",
			hover = "10% Drop rate from Ancient Guardian.",
			data = 0.10},
			{description = "20% Chance",
			hover = "20% Drop rate from Ancient Guardian.",
			data = 0.20},
			{description = "30% Chance",
			hover = "30% Drop rate from Ancient Guardian.",
			data = 0.30},
			{description = "40% Chance",
			hover = "40% Drop rate from Ancient Guardian.",
			data = 0.40},
			{description = "50% Chance",
			hover = "50% Drop rate from Ancient Guardian.",
			data = 0.50},
			{description = "60% Chance",
			hover = "60% Drop rate from Ancient Guardian.",
			data = 0.60},
			{description = "70% Chance",
			hover = "70% Drop rate from Ancient Guardian.",
			data = 0.70},
			{description = "80% Chance",
			hover = "80% Drop rate from Ancient Guardian.",
			data = 0.80},
			{description = "90% Chance",
			hover = "90% Drop rate from Ancient Guardian.",
			data = 0.90},
			{description = "Yes (100% Chance)",
			hover = "100% Drop rate from Ancient Guardian.",
			data = 1.00},
		},
		default = 0.00,
	},
	--[[
	{
		name = "TAP_OXFLUTE",
		label = "Dripple Pipes",
		hover = "Enables Dripple Pipes as special drop of Crab King.",
		options =
		{
			{description = "No (0% Chance)",
			hover = "Default Crab King loot.",
			data = 0.00},
			{description = "10% Chance",
			hover = "10% Drop rate from Crab King.",
			data = 0.10},
			{description = "20% Chance",
			hover = "20% Drop rate from Crab King.",
			data = 0.20},
			{description = "30% Chance",
			hover = "30% Drop rate from Crab King.",
			data = 0.30},
			{description = "40% Chance",
			hover = "40% Drop rate from Crab King.",
			data = 0.40},
			{description = "50% Chance",
			hover = "50% Drop rate from Crab King.",
			data = 0.50},
			{description = "60% Chance",
			hover = "60% Drop rate from Crab King.",
			data = 0.60},
			{description = "70% Chance",
			hover = "70% Drop rate from Crab King.",
			data = 0.70},
			{description = "80% Chance",
			hover = "80% Drop rate from Crab King.",
			data = 0.80},
			{description = "90% Chance",
			hover = "90% Drop rate from Crab King.",
			data = 0.90},
			{description = "Yes (100% Chance)",
			hover = "100% Drop rate from Crab King.",
			data = 1.00},
		},
		default = 0.00,
	},
	{
		name = "TAP_CC",
		label = "Colour Cubes",
		hover = "Enables Filters for each season.",
		options =
		{
			{description = "No",
			hover = "Default colors of Don't Starve Together.",
			data =   0},
			{description = "Hamlet",
			hover = "Colors from Hamlet DLC. | Temperate | Humid | Lush | Barren",
			data =   1},
			{description = "Shipwrecked",
			hover = "Colors from Shipwrecked DLC. | Mild | Hurricane | Monsoon | Dry",
			data =   2},
			{description = "Glermz Edition",
			hover = "Colors of Glermz's choices. | Mild | Winter | Spring | Lush",
			data = 3},
			{description = "Thalz Edition",
			hover=  "Colors of Thalz's choices. | Autumn | Humid | Lush | Dry",
			data = 4},
			{description = "Soko Edition",
			hover=  "Colors of Sokoteur's choices. | Mild | Hurricane | Lush | Barren",
			data = 5},
			{description = "The Forge",
			hover = "Colors from The Forge Event. | Lava Arena",
			data = 6},
			{description = "The Gorge",
			hover = "Colors from The Gorge Event. | Quagmire",
			data = 7},
		},
		default = 0,
	},
	]]--
}
