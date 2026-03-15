#!/usr/bin/env python3
"""
Fix pass 2 over-renames: revert sap_ back to kyno_ where the string
references an animation build name (i.e., matches a kyno_*.zip file).

Strategy: Build a set of all kyno_ build names from anim/*.zip filenames.
For any "sap_X" string in the code that has a corresponding kyno_X.zip,
revert it to "kyno_X" UNLESS it's clearly a prefab-name-only context
(Prefab() first arg, SpawnPrefab, AddPrefabPostInit, AddRecipe2, etc.).
"""

import re
import sys
from pathlib import Path

MOD_ROOT = Path(__file__).parent.parent

# Build the set of kyno_ build names from zip filenames
def get_build_names():
    """Get all kyno_ build names from anim/*.zip files."""
    names = set()
    anim_dir = MOD_ROOT / "anim"
    for zipfile in anim_dir.glob("kyno_*.zip"):
        # kyno_bonfire.zip -> kyno_bonfire
        name = zipfile.stem
        names.add(name)
    return names

# Contexts where sap_ is correct (prefab identity)
PREFAB_CONTEXTS = [
    r'Prefab\(\s*"',
    r'SpawnPrefab\(\s*"',
    r'AddPrefabPostInit\(\s*"',
    r'AddRecipe2\(\s*"',
    r'recipe\.product\s*==\s*"',
    r'\.prefab\s*==\s*"',
    r'Ingredient\(\s*"',
    r'AddChanceLoot\(\s*"',
    r'AddLoot\(\s*"',
    r'AddTag\(\s*"',
    r'HasTag\(\s*"',
    r'RemoveTag\(\s*"',
    r'placer\s*=\s*"',
    r'product\s*=\s*"',
    r'SortAfter\(\s*"',
    r'AddPrototyperDef\(\s*"',
    r'FindFirstEntityWithTag\(\s*"',
    r'inventoryitem\.imagename\s*=\s*"',
    # MakePlacer first arg only
    r'MakePlacer\(\s*"',
    # MakeWall first arg
    r'MakeWall\(\s*"',
    r'MakeWallAnim\(\s*"',
    r'MakeInvItem\(\s*"',
    r'MakeWallPlacer\(\s*"',
    # Table entries that are prefab names (in prefabs list)
    # These are harder to distinguish - we'll handle them case by case
]


def is_prefab_context(line, match_start, match_str):
    """Check if a sap_ match is in a prefab-name context (should stay sap_)."""
    prefix = line[:match_start]

    for pattern in PREFAB_CONTEXTS:
        if re.search(pattern + re.escape(match_str) + r'$', prefix + '"' + match_str):
            return True
        # Check if the pattern ends right before our match
        if re.search(pattern + r'$', prefix + '"'):
            return True

    return False


def fix_file(filepath, build_names, dry_run=False):
    """Fix over-renamed build names in a file."""
    try:
        content = filepath.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return 0

    original = content

    # For each build name, create the sap_ equivalent and check for it
    for kyno_name in build_names:
        sap_name = "sap_" + kyno_name[5:]  # kyno_foo -> sap_foo

        if sap_name not in content:
            continue

        # Find all occurrences of sap_name in quoted strings
        # and revert those that are in build-name contexts
        lines = content.split("\n")
        new_lines = []

        for line in lines:
            if sap_name not in line:
                new_lines.append(line)
                continue

            # For MakePlacer: first arg should stay sap_, 2nd and 3rd should be kyno_
            # Pattern: MakePlacer("sap_..._placer", "sap_build", "sap_build", ...)
            # The 2nd and 3rd args are bank/build names
            mp_match = re.search(
                r'(MakePlacer\(\s*"[^"]+"\s*,\s*")' + re.escape(sap_name) + r'(")',
                line
            )
            if mp_match:
                line = line[:mp_match.start(1)] + mp_match.group(1) + kyno_name + mp_match.group(2) + line[mp_match.end(2):]
                # Check for 3rd arg too
                mp_match2 = re.search(
                    r'(MakePlacer\(\s*"[^"]+"\s*,\s*"[^"]+"\s*,\s*")' + re.escape(sap_name) + r'(")',
                    line
                )
                if mp_match2:
                    line = line[:mp_match2.start(1)] + mp_match2.group(1) + kyno_name + mp_match2.group(2) + line[mp_match2.end(2):]

            # For MakeWallPlacer: 3rd arg is anims table {wide = "sap_..."} -> kyno_
            # Also MakeWall 2nd arg, MakeInvItem 3rd arg
            # Replace wide = "sap_name" -> wide = "kyno_name"
            line = re.sub(
                r'(wide\s*=\s*")' + re.escape(sap_name) + r'(")',
                r'\g<1>' + kyno_name + r'\2',
                line
            )

            # MakeInvItem 3rd arg (animdata): MakeInvItem("name", "placement", "sap_build", ...)
            inv_match = re.search(
                r'(MakeInvItem\(\s*"[^"]+"\s*,\s*"[^"]+"\s*,\s*")' + re.escape(sap_name) + r'(")',
                line
            )
            if inv_match:
                line = line[:inv_match.start(1)] + inv_match.group(1) + kyno_name + inv_match.group(2) + line[inv_match.end(2):]

            # For makebird 4th arg (bank): already fixed manually for parrot_pirate
            # Generic: any function where sap_name appears as a bank/build arg
            # after the first arg which is the prefab name

            # SetBank and SetBuild should already be kyno_ from pass 1
            # but double check
            line = re.sub(
                r'(SetBank\(\s*")' + re.escape(sap_name) + r'(")',
                r'\g<1>' + kyno_name + r'\2',
                line
            )
            line = re.sub(
                r'(SetBuild\(\s*")' + re.escape(sap_name) + r'(")',
                r'\g<1>' + kyno_name + r'\2',
                line
            )

            new_lines.append(line)

        content = "\n".join(new_lines)

    if content != original:
        changes = sum(1 for a, b in zip(original.split('\n'), content.split('\n')) if a != b)
        if dry_run:
            print(f"  WOULD FIX: {filepath.relative_to(MOD_ROOT)} ({changes} lines)")
        else:
            filepath.write_text(content, encoding="utf-8")
            print(f"  FIXED: {filepath.relative_to(MOD_ROOT)} ({changes} lines)")
        return changes

    return 0


def main():
    dry_run = "--dry-run" in sys.argv

    build_names = get_build_names()
    print(f"Found {len(build_names)} kyno_ animation build names")

    total = 0

    # Process all lua files
    for lua_file in sorted(MOD_ROOT.rglob("*.lua")):
        # Skip tools directory
        if "tools" in lua_file.parts:
            continue
        total += fix_file(lua_file, build_names, dry_run)

    print(f"\n{'Would fix' if dry_run else 'Fixed'}: {total} lines")


if __name__ == "__main__":
    main()
