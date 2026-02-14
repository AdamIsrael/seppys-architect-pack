# Don't Starve Together - Prefab Fix Test Checklist

## Pre-Testing Checklist

- [ ] **Backup verification**: Confirm git shows 216 modified files
- [ ] **Code review**: Spot-check 3-5 random files to ensure fixes look correct
- [ ] **No uncommitted changes**: Verify working directory is clean except for these 216 files

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

### 3. Join Existing World
- [ ] If you have an existing save with the mod:
  - [ ] Load the save game
  - [ ] **Expected**: World loads successfully
  - [ ] **Expected**: All existing mod structures still present
  - [ ] **Expected**: No crashes or missing prefabs

### 4. Spawn Test - Empty Prefabs Category
Test structures that had empty `{}` prefabs:

Open console (` key or ~ key) and test these commands:
```lua
c_spawn("kyno_altar_pillar")
c_spawn("kyno_bambootree")
c_spawn("kyno_birds")
c_spawn("kyno_gargoyles")
c_spawn("kyno_peekhen")
```

- [ ] All items spawn successfully
- [ ] No Lua errors in console
- [ ] Items are visible and functional

### 5. Spawn Test - Populated Prefabs Category
Test structures that had spawned prefabs defined:

```lua
c_spawn("kyno_musselfarm")
c_spawn("kyno_antcache")
c_spawn("kyno_archive_centipede")
c_spawn("kyno_giantbeehive")
c_spawn("kyno_cookingspit")
```

- [ ] All items spawn successfully
- [ ] Items can be interacted with (hammered, examined, etc.)
- [ ] When destroyed, proper debris spawns (e.g., collapse_small fx)

### 6. Crafting & Placement Tests
- [ ] Open crafting menu
- [ ] Search for mod items in various tabs
- [ ] Craft at least 3 different mod structures
- [ ] Place them in the world
- [ ] **Expected**: Placers work correctly
- [ ] **Expected**: Structures build successfully

### 7. Log File Verification
Check client log file for issues:

**Location:** 
- Windows: `%USERPROFILE%\Documents\Klei\DoNotStarveTogether\client_log.txt`
- Mac: `~/.klei/DoNotStarveTogether/client_log.txt`
- Linux: `~/.klei/DoNotStarveTogether/client_log.txt`

- [ ] Open client_log.txt
- [ ] Search for "Could not preload undefined prefab"
  - [ ] **Expected**: Should only find prefabs from OTHER mods (if any)
  - [ ] **Expected**: No "kyno_mussel", "chandelier_fire", "chandelier_sfx" errors
- [ ] Search for "Error" or "error"
  - [ ] **Expected**: No errors related to Seppy's Architect Pack
- [ ] Check end of log file
  - [ ] **Expected**: No crash or abrupt termination

### 8. Multiplayer Test (Optional but Recommended)
- [ ] Host a multiplayer game with the mod
- [ ] Have a friend join
- [ ] Both players spawn mod items
- [ ] **Expected**: No desyncs or crashes
- [ ] **Expected**: All players see the same items

## Advanced Tests

### 9. Stress Test - Mass Spawning
```lua
-- Spawn many structures at once
for i=1,10 do c_spawn("kyno_musselfarm") end
for i=1,10 do c_spawn("kyno_altar_pillar") end
for i=1,10 do c_spawn("kyno_archive_structures") end
```

- [ ] All items spawn without crash
- [ ] Game remains stable
- [ ] No memory leaks or performance issues

### 10. Save & Reload Test
- [ ] Save the game (ESC → Save)
- [ ] Exit to main menu
- [ ] Load the saved game
- [ ] **Expected**: All mod structures still present
- [ ] **Expected**: No errors on reload

### 11. Compatibility Test
If you have other mods enabled:
- [ ] Test with 2-3 other popular mods enabled
- [ ] Create new world with multiple mods
- [ ] **Expected**: No mod conflicts
- [ ] **Expected**: All mods load successfully

## Performance Verification

### 12. Loading Time Comparison
- [ ] Note game loading time (from launch to main menu)
- [ ] Note world loading time (from "Generating World" to in-game)
- [ ] **Expected**: Similar or slightly faster than before
- [ ] **Expected**: No significant performance degradation

### 13. In-Game Performance
- [ ] Check FPS (F1 key to show stats)
- [ ] Walk around world with mod structures
- [ ] **Expected**: Stable FPS
- [ ] **Expected**: No lag when near mod structures

## Specific Prefab Categories to Test

### Previously Problematic Prefabs
These were showing "undefined prefab" warnings:

```lua
-- Test the specific ones that were failing:
c_spawn("kyno_musselfarm")  -- Was spawning undefined "kyno_mussel"
```

- [ ] Mussel farm spawns correctly
- [ ] No "kyno_mussel" undefined error
- [ ] Structure functions as expected

### Animation-Based Prefabs
```lua
c_spawn("kyno_deer_fx_fire")
c_spawn("kyno_deer_fx_ice")
```

- [ ] Visual effects display correctly
- [ ] Spawned child prefabs appear (fire bursts, ice flakes, etc.)
- [ ] No missing animation errors

## Bug Regression Tests

### 14. Check for New Issues
- [ ] No new "Could not preload" warnings appear
- [ ] No new Lua errors introduced
- [ ] All previously working features still work
- [ ] No broken textures or models

## Final Verification

### 15. Clean Logs Test
- [ ] Delete client_log.txt
- [ ] Launch game fresh
- [ ] Enable mod
- [ ] Create new world
- [ ] Play for 5-10 minutes
- [ ] Exit game
- [ ] Review new client_log.txt
- [ ] **Expected**: Clean log with no prefab errors

## Sign-Off

After completing all tests:

- [ ] **All critical tests passed** (Tests 1-7)
- [ ] **No crashes or errors encountered**
- [ ] **Mod is fully functional**
- [ ] **Ready to commit changes**

---

## If Issues Found

If any test fails:

1. **Note the specific test that failed**
2. **Copy any error messages from logs**
3. **Note the specific prefab or structure involved**
4. **Check if issue exists in other files**
5. **Report back with details**

## Quick Smoke Test (Minimum Required)

If you're short on time, at minimum test these:

1. ✅ Game launches with mod enabled
2. ✅ New world creates successfully
3. ✅ Spawn 5 different structures with `c_spawn()`
4. ✅ Check client_log.txt for "Could not preload undefined prefab"
5. ✅ No crashes during 5 minute gameplay session

