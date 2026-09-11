-- .luacheckrc
globals = {
    "GLOBAL",
    "TheSim",
    "TheWorld",
    "ThePlayer",
    "modname",
    "modimport",
    "AddClassPostConstruct",
    "AddComponentPostConstruct",
    -- Add other common DST functions as needed
    "AddPrefabPostInit",
    "AddRecipe2",
    "GetModConfigData",
}
ignore = {
    "611",
    "631", -- Optional: Ignore line length limits
}
