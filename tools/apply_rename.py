#!/usr/bin/env python3
"""
Apply the kyno_ -> sap_ rename across the codebase.

Context-aware: renames prefab identity references but preserves
animation bank/build references that are baked into binary .zip files.

RENAME contexts (prefab identity):
  - Prefab("kyno_...", ...)           -> first arg only
  - MakePlacer("kyno_..._placer", ...) -> first arg only
  - SpawnPrefab("kyno_...")
  - AddPrefabPostInit("kyno_...", ...)
  - AddRecipe2("kyno_...", ...)
  - recipe.product == "kyno_..."
  - STRINGS.NAMES.KYNO_...  / STRINGS paths with KYNO_
  - AddTag/HasTag/RemoveTag("kyno_...")
  - Ingredient("kyno_...", ...)
  - placer = "kyno_..._placer"
  - product references in recipe tables

DO NOT RENAME contexts (animation binary references):
  - SetBank("kyno_...")
  - SetBuild("kyno_...")
  - bank_build = "kyno_..."
  - MakePlacer 2nd arg (bank) and 3rd arg (build)
  - Asset("ANIM", "anim/kyno_...") -- keep for now (Phase 6)
  - SetIcon("kyno_...") -- references compiled atlas
  - image = "kyno_..." in recipe defs -- references atlas element names
  - atlas element names in XML -- references compiled .tex

Usage:
  python3 tools/apply_rename.py --dry-run    # Preview changes
  python3 tools/apply_rename.py              # Apply changes
"""

import json
import os
import re
import sys
from pathlib import Path

MOD_ROOT = Path(__file__).parent.parent

# Contexts where kyno_ should NOT be renamed (animation/atlas binary refs)
# These patterns match the function/assignment that precedes the kyno_ string
DO_NOT_RENAME_PATTERNS = [
    # SetBank("kyno_...") and SetBuild("kyno_...")
    r'SetBank\(\s*"kyno_',
    r'SetBuild\(\s*"kyno_',
    # bank_build = "kyno_..."
    r'bank_build\s*=\s*"kyno_',
    # Asset("ANIM", "anim/kyno_...") - keep paths tied to zip filenames
    r'Asset\(\s*"ANIM"\s*,\s*"anim/kyno_',
    # SetIcon("kyno_...") - references compiled atlas elements
    r'SetIcon\(\s*"kyno_',
    # image = "kyno_..." in recipe definitions - atlas element refs
    r'image\s*=\s*"kyno_',
    # atlas references
    r'atlas\s*=\s*"[^"]*kyno_',
    # Animation file paths in Asset declarations
    r'Asset\(\s*"ATLAS"\s*,\s*"[^"]*kyno_',
    r'Asset\(\s*"IMAGE"\s*,\s*"[^"]*kyno_',
]

# MakePlacer needs special handling: rename 1st arg, keep 2nd (bank) and 3rd (build)
MAKEPLACER_PATTERN = re.compile(
    r'(MakePlacer\(\s*")(kyno_[^"]+)("'  # 1st arg - placer name (RENAME)
    r'(?:\s*,\s*")'                        # comma
    r')([^"]*)'                            # 2nd arg - bank (KEEP)
    r'("(?:\s*,\s*")'                      # comma
    r')([^"]*)'                            # 3rd arg - build (KEEP)
    r'(")',                                # close
    re.DOTALL
)


def kyno_to_sap(name):
    """Convert kyno_ prefix to sap_."""
    if name.startswith("kyno_"):
        return "sap_" + name[5:]
    return name


def KYNO_to_SAP(name):
    """Convert KYNO_ prefix to SAP_."""
    if name.startswith("KYNO_"):
        return "SAP_" + name[5:]
    return name


def is_do_not_rename_context(line, match_start):
    """Check if a kyno_ match at match_start is in a DO NOT RENAME context."""
    # Look at the text before the match on the same line
    prefix = line[:match_start]
    for pattern in DO_NOT_RENAME_PATTERNS:
        if re.search(pattern + r'$', prefix + '"kyno_'):
            return True
    return False


def process_makeplacer_line(line):
    """Handle MakePlacer specially: rename 1st arg, keep 2nd and 3rd."""
    def replacer(m):
        prefix = m.group(1)         # MakePlacer("
        placer_name = m.group(2)    # kyno_..._placer (RENAME)
        mid1 = m.group(3)           # ", "
        bank = m.group(4)           # bank name (KEEP)
        mid2 = m.group(5)           # ", "
        build = m.group(6)          # build name (KEEP)
        suffix = m.group(7)         # "
        new_placer = kyno_to_sap(placer_name)
        return f'{prefix}{new_placer}{mid1}{bank}{mid2}{build}{suffix}'

    return MAKEPLACER_PATTERN.sub(replacer, line)


def process_lua_file(filepath, dry_run=False):
    """Process a single .lua file with context-aware renaming."""
    try:
        content = filepath.read_text(encoding="utf-8", errors="replace")
    except Exception as e:
        print(f"  ERROR reading {filepath}: {e}")
        return 0

    original = content
    lines = content.split("\n")
    new_lines = []
    changes = 0

    for line_num, line in enumerate(lines, 1):
        original_line = line

        # Skip comment-only lines
        stripped = line.lstrip()
        if stripped.startswith("--"):
            new_lines.append(line)
            continue

        # Step 1: Handle MakePlacer specially (before general replacement)
        if "MakePlacer" in line and "kyno_" in line:
            line = process_makeplacer_line(line)

        # Step 2: Handle Prefab() first arg
        # Prefab("kyno_...", fn, assets)
        line = re.sub(
            r'(Prefab\(\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 3: Handle SpawnPrefab("kyno_...")
        line = re.sub(
            r'(SpawnPrefab\(\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 4: Handle AddPrefabPostInit("kyno_...", ...)
        line = re.sub(
            r'(AddPrefabPostInit\(\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 5: Handle AddRecipe2("kyno_...", ...)
        line = re.sub(
            r'(AddRecipe2\(\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 6: Handle recipe.product == "kyno_..."
        line = re.sub(
            r'(recipe\.product\s*==\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 7: Handle Ingredient("kyno_...", ...)
        line = re.sub(
            r'(Ingredient\(\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 8: Handle AddTag/HasTag/RemoveTag("kyno_...")
        line = re.sub(
            r'((?:AddTag|HasTag|RemoveTag)\(\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 9: Handle placer = "kyno_..._placer" in recipe defs
        line = re.sub(
            r'(placer\s*=\s*")(kyno_[^"]+_placer)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 10: Handle product = "kyno_..." in recipe defs
        line = re.sub(
            r'(product\s*=\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 11: Handle STRINGS path keys .KYNO_ and ["KYNO_"]
        # e.g. STRINGS.NAMES.KYNO_BONFIRE or STRINGS.RECIPE_DESC["KYNO_BONFIRE"]
        line = re.sub(
            r'\.KYNO_([A-Z0-9_]+)',
            lambda m: '.SAP_' + m.group(1),
            line
        )
        line = re.sub(
            r'(\[")KYNO_([A-Z0-9_]+)("\])',
            lambda m: m.group(1) + 'SAP_' + m.group(2) + m.group(3),
            line
        )

        # Step 12: Handle SKIN_NAMES and other lowercase kyno_ in strings tables
        # skin_names use lowercase: kyno_bonfire = "Bonfire"
        # But only in tap_strings*.lua context - this is handled by the
        # STRINGS.NAMES pattern above for uppercase

        # Step 13: Handle prefab name references in loot tables
        # inst.components.lootdropper:AddChanceLoot("kyno_...", 0.5)
        line = re.sub(
            r'(AddChanceLoot\(\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )
        line = re.sub(
            r'(AddLoot\(\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 14: Handle FindEntities tag filters with kyno_
        # Already covered by AddTag/HasTag patterns for {"kyno_..."} table entries
        line = re.sub(
            r'(\{\s*")(kyno_[^"]+)("\s*\})',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 15: Handle container/writeable keys
        # params.kyno_something or ["kyno_something"]
        line = re.sub(
            r'(params\.)(kyno_[a-z0-9_]+)',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)),
            line
        )

        # Step 16: Handle inst.prefab == "kyno_..."
        line = re.sub(
            r'(\.prefab\s*==\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        # Step 17: Handle TheSim:FindFirstEntityWithTag("kyno_...")
        line = re.sub(
            r'(FindFirstEntityWithTag\(\s*")(kyno_[^"]+)(")',
            lambda m: m.group(1) + kyno_to_sap(m.group(2)) + m.group(3),
            line
        )

        if line != original_line:
            changes += 1

        new_lines.append(line)

    if changes > 0:
        new_content = "\n".join(new_lines)
        if dry_run:
            print(f"  WOULD MODIFY: {filepath.relative_to(MOD_ROOT)} ({changes} lines)")
        else:
            filepath.write_text(new_content, encoding="utf-8")
            print(f"  MODIFIED: {filepath.relative_to(MOD_ROOT)} ({changes} lines)")

    return changes


def process_strings_file(filepath, dry_run=False):
    """Process tap_strings.lua and tap_strings_extras.lua.

    These files have a different pattern: they define STRINGS table entries
    using KYNO_ as part of the key path AND sometimes as lowercase kyno_
    for skin names.
    """
    try:
        content = filepath.read_text(encoding="utf-8", errors="replace")
    except Exception as e:
        print(f"  ERROR reading {filepath}: {e}")
        return 0

    original = content

    # Rename KYNO_ to SAP_ in STRINGS paths
    # Patterns like: STRINGS.NAMES.KYNO_BONFIRE
    #                STRINGS.RECIPE_DESC.KYNO_BONFIRE
    #                STRINGS.CHARACTERS.GENERIC.DESCRIBE.KYNO_BONFIRE
    content = re.sub(r'\.KYNO_([A-Z0-9_]+)', r'.SAP_\1', content)
    content = re.sub(r'(\[")KYNO_([A-Z0-9_]+)("\])', r'\1SAP_\2\3', content)

    # Rename lowercase kyno_ prefab name references in skin name tables
    # e.g. kyno_bonfire = "Bonfire" -> sap_bonfire = "Bonfire"
    content = re.sub(
        r'^(\s*)(kyno_)([a-z0-9_]+)(\s*=)',
        r'\1sap_\3\4',
        content,
        flags=re.MULTILINE
    )

    if content != original:
        changes = sum(1 for a, b in zip(original.split('\n'), content.split('\n')) if a != b)
        if dry_run:
            print(f"  WOULD MODIFY: {filepath.relative_to(MOD_ROOT)} ({changes} lines)")
        else:
            filepath.write_text(content, encoding="utf-8")
            print(f"  MODIFIED: {filepath.relative_to(MOD_ROOT)} ({changes} lines)")
        return changes

    return 0


def process_writeables(filepath, dry_run=False):
    """Process scripts/writeables.lua - rename prefab-name keys."""
    try:
        content = filepath.read_text(encoding="utf-8", errors="replace")
    except Exception as e:
        print(f"  ERROR reading {filepath}: {e}")
        return 0

    original = content

    # Writeable kind registrations: makealiases["kyno_..."] or similar table keys
    content = re.sub(
        r'(\["|params\.)kyno_([a-z0-9_]+)',
        lambda m: m.group(1) + 'sap_' + m.group(2),
        content
    )

    if content != original:
        changes = sum(1 for a, b in zip(original.split('\n'), content.split('\n')) if a != b)
        if dry_run:
            print(f"  WOULD MODIFY: {filepath.relative_to(MOD_ROOT)} ({changes} lines)")
        else:
            filepath.write_text(content, encoding="utf-8")
            print(f"  MODIFIED: {filepath.relative_to(MOD_ROOT)} ({changes} lines)")
        return changes

    return 0


def process_modmain(filepath, dry_run=False):
    """Process modmain.lua - rename tag references and prefab refs."""
    return process_lua_file(filepath, dry_run)


def process_modworldgenmain(filepath, dry_run=False):
    """Process modworldgenmain.lua - DO NOT touch bank_build values."""
    # The general lua processor already skips bank_build via its
    # context-aware handling, but modworldgenmain has no Prefab() calls.
    # Nothing to rename here since bank_build values must stay kyno_.
    return 0


def main():
    dry_run = "--dry-run" in sys.argv

    if dry_run:
        print("=" * 60)
        print("DRY RUN - No files will be modified")
        print("=" * 60)
    else:
        print("=" * 60)
        print("APPLYING kyno_ -> sap_ RENAME")
        print("=" * 60)

    total_changes = 0

    # Phase 1: Prefab definitions
    print("\n--- Phase 1: Prefab definitions (scripts/prefabs/) ---")
    prefabs_dir = MOD_ROOT / "scripts" / "prefabs"
    if prefabs_dir.exists():
        for lua_file in sorted(prefabs_dir.glob("*.lua")):
            total_changes += process_lua_file(lua_file, dry_run)

    # Phase 2: Recipe definitions
    print("\n--- Phase 2: Recipes (tap_init/tap_recipes.lua) ---")
    recipes = MOD_ROOT / "tap_init" / "tap_recipes.lua"
    if recipes.exists():
        total_changes += process_lua_file(recipes, dry_run)

    # Phase 3: String definitions
    print("\n--- Phase 3: Strings ---")
    for name in ["tap_strings.lua", "tap_strings_extras.lua"]:
        filepath = MOD_ROOT / "tap_init" / name
        if filepath.exists():
            total_changes += process_strings_file(filepath, dry_run)

    # Phase 4: Support files
    print("\n--- Phase 4: Support files ---")

    # tap_init files
    for name in [
        "tap_postinits.lua",
        "tap_combat_postinits.lua",
        "tap_combat_replica_postinits.lua",
        "tap_containers.lua",
        "tap_icons.lua",
        "tap_lights.lua",
        "tap_endtable.lua",
        "tap_tuning.lua",
        "tap_loadingtips.lua",
    ]:
        filepath = MOD_ROOT / "tap_init" / name
        if filepath.exists():
            total_changes += process_lua_file(filepath, dry_run)

    # Component overrides
    components_dir = MOD_ROOT / "scripts" / "components"
    if components_dir.exists():
        for lua_file in sorted(components_dir.glob("*.lua")):
            total_changes += process_lua_file(lua_file, dry_run)

    # Stategraphs
    sg_dir = MOD_ROOT / "scripts" / "stategraphs"
    if sg_dir.exists():
        for lua_file in sorted(sg_dir.glob("*.lua")):
            total_changes += process_lua_file(lua_file, dry_run)

    # Writeables
    writeables = MOD_ROOT / "scripts" / "writeables.lua"
    if writeables.exists():
        total_changes += process_writeables(writeables, dry_run)

    # Libs
    libs_dir = MOD_ROOT / "tap_init" / "libs"
    if libs_dir.exists():
        for lua_file in sorted(libs_dir.glob("*.lua")):
            total_changes += process_lua_file(lua_file, dry_run)

    # modmain.lua
    print("\n--- modmain.lua ---")
    modmain = MOD_ROOT / "modmain.lua"
    if modmain.exists():
        total_changes += process_modmain(modmain, dry_run)

    # modworldgenmain.lua - skip (bank_build values must stay)
    print("\n--- modworldgenmain.lua (skipped - bank_build values are binary refs) ---")

    # Summary
    print("\n" + "=" * 60)
    if dry_run:
        print(f"DRY RUN COMPLETE: {total_changes} lines would be changed")
        print("Run without --dry-run to apply changes")
    else:
        print(f"RENAME COMPLETE: {total_changes} lines changed")
    print("=" * 60)


if __name__ == "__main__":
    main()
