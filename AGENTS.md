# Agent Guidelines for Seppy's Architect Pack

This document provides coding guidelines for AI agents working in this Don't Starve Together mod codebase.

## Project Overview

**Type:** Don't Starve Together Lua Mod  
**Name:** Seppy's Architect Pack (fork of "The Architect Pack" v4.6-B)  
**Purpose:** Adds 680+ decorative structures and content from Shipwrecked, Hamlet, The Forge, and The Gorge DLCs  
**Language:** Lua (DST mod API)  
**Version:** 2.0.0

## Directory Structure

```
seppy_architect_pack/
├── modmain.lua              # Main entry point (58 lines)
├── modinfo.lua              # Mod metadata and configuration (435 lines)
├── modworldgenmain.lua      # World generation and tile definitions (1000+ lines)
├── anim/                    # Animation files (.zip format, 748 files)
├── images/                  # Textures and atlases (inventoryimages/, minimapimages/, tabimages/)
├── levels/                  # Tile definitions and textures
├── scripts/                 # Game logic
│   ├── brains/             # AI behavior (14 files)
│   ├── components/         # Component systems (4 custom components)
│   ├── prefabs/            # Entity definitions (683 prefab files!)
│   ├── stategraphs/        # State machines (21 files)
│   └── writeables.lua      # Writable item configurations
├── sound/                   # Audio files (FSB/FEV format, stored in Git LFS)
└── tap_init/               # Mod initialization modules (17 files)
    ├── libs/               # Utility libraries (7 files)
    ├── tap_assets.lua      # Asset loading
    ├── tap_recipes.lua     # Crafting recipes (446KB)
    ├── tap_strings.lua     # Localization (1.4MB)
    ├── tap_tuning.lua      # Game balance values
    └── tap_postinits.lua   # Prefab modifications
```

## Build/Test Commands

**This mod has no build system.** Files are loaded directly by DST's mod system.

### Testing
- Launch Don't Starve Together
- Enable "Seppy's Architect Pack" in the Mods menu
- Create a new world or load existing save
- Test in-game using console: `c_spawn("sap_prefabname")`
- Check logs: `%USERPROFILE%\Documents\Klei\DoNotStarveTogether\client_log.txt` (Windows)
- Check logs: `~/.klei/DoNotStarveTogether/client_log.txt` (Linux/Mac)

### Debugging
- Enable DST Developer Tools (mod or `-dev` launch flag)
- Use `print()` statements - output goes to `client_log.txt`
- Use `TheNet:Announce()` for in-game messages
- Console commands: `c_select()`, `c_spawn()`, `c_give()`, `c_godmode()`

## Code Style Guidelines

### Import Pattern
Always access game globals through `GLOBAL` reference:

```lua
local _G = GLOBAL
local require = _G.require
local resolvefilepath = _G.resolvefilepath
local STRINGS = _G.STRINGS
local TUNING = _G.TUNING
local Prefab = _G.Prefab
local CreateEntity = _G.CreateEntity
```

**Why:** Mods run in isolated environments; `_G` accesses the game's global namespace.

### Naming Conventions

- **Global constants:** `UPPERCASE_WITH_UNDERSCORES` (e.g., `TUNING.SAP_FISH_LARGE_HEALTH`)
- **Local variables:** `lowercase_with_underscores` (e.g., `run_carpet`, `walk_grass`)
- **Functions:** `PascalCase` for constructors (e.g., `CreateEntity`), `camelCase` for methods
- **Prefab names:** Use `sap_` prefix consistently (e.g., `sap_bonfire`, `sap_dragoonden`)
- **Prefab files:** Use `sap_*.lua` naming (e.g., `sap_bonfire.lua`). Heap of Foods names its files `k_*.lua`, and Lua caches modules by path, so a shared file name makes one mod silently register the other's prefabs. The only exceptions are files deliberately named after a vanilla prefab in order to override it
- **Private functions:** Prefix with underscore (e.g., `_CanDeploySandbagAtPoint`)
- **Anim bank and build names:** Keep the `kyno_` spelling on existing art. Those names are baked into the binary `.zip` files and were deliberately left out of the `sap_` rename
- **Files:** `lowercase_with_underscores.lua`

### Formatting

- **Indentation:** Use tabs (not spaces) for consistency with existing code
- **Line length:** No strict limit, but keep reasonable (80-120 chars preferred)
- **Whitespace:** Use blank lines to separate logical sections
- **Trailing commas:** Do not use in tables (inconsistent with existing code)
- **String quotes:** Prefer double quotes for strings

### Type Annotations

Lua is dynamically typed. Use comments for clarity:

```lua
-- @param inst EntityScript The entity instance
-- @param data table Saved component data
-- @return boolean Whether operation succeeded
function Shelfer:OnLoad(data)
    -- implementation
end
```

### Module Loading

Use `modimport()` for mod-specific files:

```lua
-- In modmain.lua
modimport("tap_init/tap_assets")
modimport("tap_init/tap_prefabs")
```

Use `require()` for library files:

```lua
local env = require("tap_init/libs/env")
local upvaluehacker = require("tap_init/libs/upvaluehacker")
```

### Error Handling

- Use assertions for preconditions: `assert(inst ~= nil, "inst cannot be nil")`
- Check existence before operations: `if inst.components.freezable then ... end`
- Network boundary checks: `if not TheWorld.ismastersim then return inst end`
- Validate function parameters at entry points
- Handle nil cases explicitly

### Prefab Structure

Follow this standard pattern for all prefabs:

```lua
local assets = {
    Asset("ANIM", "anim/sap_example.zip"),
    Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
    Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function fn()
    local inst = CreateEntity()
    
    -- Add entity components
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
    -- Configure appearance
    inst.AnimState:SetBank("sap_example")
    inst.AnimState:SetBuild("sap_example")
    inst.AnimState:PlayAnimation("idle")
    
    -- Add tags for behavior
    inst:AddTag("structure")
    
    -- Network boundary (client-side ends here)
    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
    
    -- Server-side components only
    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
    inst:AddComponent("workable")
    
    return inst
end

return Prefab("sap_example", fn, assets),
       MakePlacer("sap_example_placer", "sap_example", "sap_example", "idle")
```

### Component Pattern

```lua
local ComponentName = Class(function(self, inst)
    self.inst = inst
    self.property = default_value
end)

function ComponentName:OnSave()
    return {
        property = self.property
    }
end

function ComponentName:OnLoad(data)
    if data then
        self.property = data.property or default_value
    end
end

return ComponentName
```

### String Localization

Provide strings for all characters (12+):

```lua
STRINGS.NAMES.SAP_EXAMPLE = "Example Item"
STRINGS.RECIPE_DESC.SAP_EXAMPLE = "An example item."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SAP_EXAMPLE = "It's an example."
STRINGS.CHARACTERS.WILLOW.DESCRIBE.SAP_EXAMPLE = "Willow's opinion."
-- ... for all characters: WOLFGANG, WENDY, WX78, WICKERBOTTOM, WOODIE, WAXWELL, 
-- WATHGRITHR, WEBBER, WINONA, WARLY, WORTOX, WORMWOOD, WURT, WALTER, WANDA
```

## Common Patterns

### PostInit Hooks

Modify existing prefabs safely:

```lua
AddPrefabPostInit("sap_coconut", function(inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end
    
    inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
    inst.components.perishable:StartPerishing()
end)
```

### Configuration Options

Access mod config in `modmain.lua`:

```lua
local PLACING_METHOD = GetModConfigData("TAP_PLACING_METHOD")
if PLACING_METHOD == 1 then
    -- Apply configuration
end
```

## Important Notes

1. **Network Separation:** Always check `TheWorld.ismastersim` before server-side code
2. **Prefab Prefix:** Use `sap_` prefix for all new custom prefabs to avoid conflicts
3. **Asset Loading:** Declare all assets in prefab's `assets` table for proper loading
4. **Git LFS:** Audio files (*.fsb) are stored in Git LFS - don't commit large binaries directly
5. **Performance:** This mod has 683 prefabs - be mindful of memory and load times
6. **Character Strings:** Always provide dialogue for all 17 DST characters
7. **Tags:** Use appropriate tags (`structure`, `shelter`, etc.) for game mechanics

## File Locations

- **Add new prefabs:** `scripts/prefabs/sap_newitem.lua`
- **Add recipes:** `tap_init/tap_recipes.lua`
- **Add strings:** `tap_init/tap_strings.lua`
- **Add assets:** `tap_init/tap_assets.lua`
- **Modify existing:** `tap_init/tap_postinits.lua`
- **Add tuning values:** `tap_init/tap_tuning.lua`

## Reference Files

Study these files to understand patterns:
- `scripts/prefabs/k_bonfire.lua` - Simple structure example
- `scripts/prefabs/k_dragoonden.lua` - Complex structure with AI
- `scripts/components/shelfer.lua` - Component example
- `scripts/stategraphs/SGthumper.lua` - State machine example
- `tap_init/tap_postinits.lua` - PostInit hooks example
- `tap_init/tap_legacy_migration.lua` - Backward compatibility system
