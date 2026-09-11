# Don't Starve Together - Prefab Rename Test Checklist

This checklist covers the `kyno_` to `sap_` prefab rename that resolves name
collisions with the **Heap of Foods** mod, plus the legacy alias layer that
keeps existing saves working.

All prefab names below are verified against the registrations in
`scripts/prefabs/`. Old `kyno_` names appear only in the legacy alias tests,
where they are expected to still work.

## Pre-Testing Checklist

- [ ] **Branch**: confirm you are on the rename branch and it is rebased on `main`
- [ ] **Clean tree**: `git status` reports no uncommitted changes
- [ ] **Syntax**: every Lua file parses (`luajit -b <file> /dev/null`)
- [ ] **No stale names**: no active `Prefab("kyno_` registration outside the legacy compat files

## Core Functionality Tests

### 1. Game Launch & Mod Loading
- [ ] Launch Don't Starve Together
- [ ] Navigate to Mods menu
- [ ] Enable "Seppy's Architect Pack" mod
- [ ] Click "Apply" and wait for game to reload
- [ ] **Expected**: Mod loads without errors
- [ ] **Look for**: No "Could not preload undefined prefab" warnings in log

### 2. Create New World
- [ ] Click "Play" → "Host Game"
- [ ] Select any world preset (default is fine)
- [ ] Click "Generate World"
- [ ] Wait for world generation to complete
- [ ] **Expected**: World generates successfully
- [ ] **Expected**: Game loads into world without crashing
- [ ] **Look for**: No client crash during loading

### 3. Load a Pre-Rename Save
This is the most important regression test. A save made before the rename
stores the old `kyno_` names.

- [ ] Load a save created with an older version of the mod
- [ ] **Expected**: World loads successfully
- [ ] **Expected**: All existing mod structures are still present and in place
- [ ] **Expected**: No "Could not preload undefined prefab" entries for `kyno_` names
- [ ] **Expected**: Structures can still be hammered, picked, and interacted with

### 4. Spawn Test - Structures With No Dependencies
Open the console (backtick or tilde key) and run:

```lua
c_spawn("sap_altar_pillar")
c_spawn("sap_bambootree")
c_spawn("sap_peekhen")
c_spawn("sap_hound_gargoyle_1")
c_spawn("sap_archive_statue1")
```

- [ ] All items spawn successfully
- [ ] No Lua errors in console
- [ ] Items are visible and functional

### 5. Spawn Test - Structures That Spawn Other Prefabs
These declare dependency lists, so they exercise the renamed names inside
those lists:

```lua
c_spawn("sap_musselfarm")
c_spawn("sap_antcache")
c_spawn("sap_archive_centipede")
c_spawn("sap_giantbeehive")
c_spawn("sap_cookingspit")
```

- [ ] All items spawn successfully
- [ ] Items can be interacted with (hammered, examined, etc.)
- [ ] When destroyed, proper debris spawns (e.g., `collapse_small` fx)

### 6. Spawn Test - Previously Disabled Prefab Files
These eleven files were commented out of `tap_init/tap_prefabs.lua` because
they collided with Heap of Foods. The rename lets them stay enabled, so each
one needs a spawn check:

```lua
c_spawn("sap_antchest")
c_spawn("sap_garden_sprinkler")
c_spawn("sap_koi")
c_spawn("sap_jellyfish")
c_spawn("sap_lotus_flower")
c_spawn("sap_musselfarm")
c_spawn("sap_raindrop")
c_spawn("sap_sporecap")
c_spawn("sap_truffles")
c_spawn("sap_water_spray")
```

- [ ] All ten spawn successfully
- [ ] No Lua errors in console
- [ ] Each looks correct (right art, not a placeholder)

### 7. Legacy Alias Test
Old names are registered as aliases that spawn the new prefab. With **only
this mod enabled**, every old name should still work:

```lua
c_spawn("kyno_altar_pillar")
c_spawn("kyno_bambootree")
c_spawn("kyno_musselfarm")
c_spawn("kyno_giantbeehive")
c_spawn("kyno_peekhen")
```

- [ ] Each command spawns the matching `sap_` prefab
- [ ] No Lua errors in console
- [ ] **Note**: the alias loop skips any name another mod already claims, so
      with Heap of Foods enabled some `kyno_` names will belong to that mod
      instead. That is intended behaviour, not a failure.

### 8. Crafting & Placement Tests
- [ ] Open crafting menu
- [ ] Search for mod items in various tabs
- [ ] Craft at least 3 different mod structures
- [ ] Place them in the world
- [ ] **Expected**: Placers work correctly, and the placer art matches the structure
- [ ] **Expected**: Structures build successfully

### 9. Log File Verification
Check the client log file for issues.

**Location:**
- Windows: `%USERPROFILE%\Documents\Klei\DoNotStarveTogether\client_log.txt`
- Mac: `~/Documents/Klei/DoNotStarveTogether/client_log.txt`
- Linux: `~/.klei/DoNotStarveTogether/client_log.txt`

The same directory holds `master_server_log.txt` and `caves_server_log.txt`,
which are the ones to read when a problem only shows up on a hosted world.

- [ ] Open `client_log.txt`
- [ ] Search for "Could not preload undefined prefab"
  - [ ] **Expected**: No `sap_` prefab appears in these warnings
  - [ ] **Expected**: No `kyno_` prefab appears either, since the aliases cover them
- [ ] Search for "Error" or "error"
  - [ ] **Expected**: No errors related to Seppy's Architect Pack
- [ ] Check end of log file
  - [ ] **Expected**: No crash or abrupt termination

## Heap of Foods Compatibility

### 10. Both Mods Enabled
The whole point of the rename. Test this even if you skip everything else.

- [ ] Enable both Seppy's Architect Pack and Heap of Foods
- [ ] Generate a new world
- [ ] **Expected**: Both mods load, neither is disabled by the game
- [ ] **Expected**: No "prefab already exists" or duplicate registration errors
- [ ] Spawn one item from each of the previously colliding areas:

```lua
c_spawn("sap_koi")
c_spawn("sap_truffles")
c_spawn("sap_lotus_flower")
c_spawn("sap_sporecap")
```

- [ ] All spawn as this mod's versions, with this mod's art
- [ ] Heap of Foods items still craft and spawn normally
- [ ] **Look for**: any item whose art or name looks like it came from the wrong mod

### 11. Unprefixed Prefab Names
Some prefabs in this mod are registered without the `sap_` prefix and were not
touched by the rename, so they remain a possible collision surface. Birds are
the largest group.

```lua
c_spawn("pigeon")
c_spawn("seagull")
c_spawn("toucan")
c_spawn("parrot")
```

- [ ] With only this mod enabled, each spawns correctly
- [ ] With Heap of Foods also enabled, check the log for duplicate registration warnings
- [ ] **Note**: if a conflict shows up here, the fix is a rename of these names, not of `sap_` ones

## Advanced Tests

### 12. Stress Test - Mass Spawning
```lua
for i = 1, 10 do c_spawn("sap_musselfarm") end
for i = 1, 10 do c_spawn("sap_altar_pillar") end
for i = 1, 10 do c_spawn("sap_archive_statue1") end
```

- [ ] All items spawn without crash
- [ ] Game remains stable
- [ ] No memory leaks or performance issues

### 13. Save & Reload Test
- [ ] Save the game (ESC → Save)
- [ ] Exit to main menu
- [ ] Load the saved game
- [ ] **Expected**: All mod structures still present
- [ ] **Expected**: No errors on reload
- [ ] **Expected**: Structures spawned through a `kyno_` alias survive as their `sap_` prefab

### 14. Compatibility Test
If you have other mods enabled:
- [ ] Test with 2-3 other popular mods enabled
- [ ] Create new world with multiple mods
- [ ] **Expected**: No mod conflicts
- [ ] **Expected**: All mods load successfully

### 15. Multiplayer Test (Optional but Recommended)
- [ ] Host a multiplayer game with the mod
- [ ] Have a friend join
- [ ] Both players spawn mod items
- [ ] **Expected**: No desyncs or crashes
- [ ] **Expected**: All players see the same items

## Performance Verification

### 16. Loading Time Comparison
- [ ] Note game loading time (from launch to main menu)
- [ ] Note world loading time (from "Generating World" to in-game)
- [ ] **Expected**: Similar to before. The alias layer registers roughly 1450
      extra prefab names at load, so watch for a noticeable startup delay
- [ ] **Expected**: No significant performance degradation

### 17. In-Game Performance
- [ ] Check FPS (F1 key to show stats)
- [ ] Walk around world with mod structures
- [ ] **Expected**: Stable FPS
- [ ] **Expected**: No lag when near mod structures

## Specific Prefab Categories to Test

### Fish and Fishable Structures
The fish farm, salt pond, and tidal pools had their dependency lists emptied
and restored, so they are worth a targeted check:

```lua
c_spawn("sap_fishfarm")
c_spawn("sap_saltpond")
c_spawn("sap_tidalpool_big")
```

- [ ] Fish farm breeds and yields `sap_koi` when picked
- [ ] Salt pond can be fished for `sap_salmonfish`
- [ ] Tidal pool can be fished for `sap_tropicalfish`
- [ ] Fish appear with correct art, not as invisible or placeholder entities

### Effects Prefabs
```lua
c_spawn("sap_balloon_fx")
c_spawn("sap_whalebubbles_fx")
c_spawn("sap_moonglass_tile_fx")
```

- [ ] Visual effects display correctly
- [ ] No missing animation errors

## Bug Regression Tests

### 18. Check for New Issues
- [ ] No new "Could not preload" warnings appear
- [ ] No new Lua errors introduced
- [ ] All previously working features still work
- [ ] No broken textures or models

## Final Verification

### 19. Clean Logs Test
- [ ] Delete `client_log.txt`
- [ ] Launch game fresh
- [ ] Enable mod
- [ ] Create new world
- [ ] Play for 5-10 minutes
- [ ] Exit game
- [ ] Review new `client_log.txt`
- [ ] **Expected**: Clean log with no prefab errors

## Sign-Off

After completing all tests:

- [ ] **All critical tests passed** (Tests 1-10)
- [ ] **No crashes or errors encountered**
- [ ] **Mod is fully functional**
- [ ] **Pre-rename saves still load**
- [ ] **Ready to merge**

---

## If Issues Found

If any test fails:

1. **Note the specific test that failed**
2. **Copy any error messages from logs**
3. **Note the specific prefab or structure involved**
4. **Check whether the name is in `tap_init/tap_legacy_map.lua`**
5. **Report back with details**

## Quick Smoke Test (Minimum Required)

If you're short on time, at minimum test these:

1. ✅ Game launches with mod enabled
2. ✅ New world creates successfully
3. ✅ `c_spawn("sap_musselfarm")`, `c_spawn("sap_koi")`, `c_spawn("sap_truffles")` all work
4. ✅ `c_spawn("kyno_musselfarm")` still works through the alias layer
5. ✅ A pre-rename save still loads with its structures intact
6. ✅ Both this mod and Heap of Foods load together without errors
