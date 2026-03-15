#!/usr/bin/env python3
"""
Pass 2: Fix remaining kyno_ references missed by the context-aware rename.

Handles:
- AddPrototyperDef("kyno_...")
- SortAfter("kyno_...", ...) and SortAfter(..., "kyno_...")
- Prefab name strings in table literals (e.g. "kyno_mast_01" in a list)
- Loot table entries
- Any other bare "kyno_" prefab name references

Strategy: In files that should have ALL kyno_ prefab refs renamed,
replace remaining "kyno_ strings EXCEPT known DO-NOT-RENAME patterns.
"""

import re
import sys
from pathlib import Path

MOD_ROOT = Path(__file__).parent.parent

# Patterns that indicate a kyno_ string should NOT be renamed
DO_NOT_RENAME_LINE_PATTERNS = [
    r'SetBank\s*\(',
    r'SetBuild\s*\(',
    r'bank_build\s*=',
    r'Asset\s*\(\s*"ANIM"',
    r'Asset\s*\(\s*"ATLAS"',
    r'Asset\s*\(\s*"IMAGE"',
    r'SetIcon\s*\(',
    r'icon_image\s*=',
    r'image\s*=',
    r'atlas\s*=',
    r'\.tex"',           # any .tex reference is an atlas element
    r'\.zip"',           # any .zip reference is a file path
    r'\.xml"',           # any .xml reference is a file path
]


def should_skip_line(line):
    """Check if this line contains a DO-NOT-RENAME context for kyno_."""
    stripped = line.lstrip()
    if stripped.startswith("--"):
        return True
    for pattern in DO_NOT_RENAME_LINE_PATTERNS:
        if re.search(pattern, line):
            return True
    return False


def rename_kyno_in_line(line):
    """Replace all "kyno_ prefab references in a line, preserving non-prefab refs."""
    if should_skip_line(line):
        return line

    # Replace "kyno_ at string boundaries (inside quotes)
    line = re.sub(r'"kyno_([^"]*)"', lambda m: '"sap_' + m.group(1) + '"', line)

    # Replace bare kyno_ table keys (e.g., params.kyno_something)
    line = re.sub(r'(params\.)kyno_', r'\1sap_', line)

    return line


def process_file(filepath, dry_run=False):
    """Process a file, renaming remaining kyno_ prefab refs."""
    try:
        content = filepath.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return 0

    lines = content.split("\n")
    new_lines = []
    changes = 0

    for line in lines:
        new_line = rename_kyno_in_line(line)
        if new_line != line:
            changes += 1
        new_lines.append(new_line)

    if changes > 0:
        new_content = "\n".join(new_lines)
        if dry_run:
            print(f"  WOULD MODIFY: {filepath.relative_to(MOD_ROOT)} ({changes} lines)")
        else:
            filepath.write_text(new_content, encoding="utf-8")
            print(f"  MODIFIED: {filepath.relative_to(MOD_ROOT)} ({changes} lines)")

    return changes


def main():
    dry_run = "--dry-run" in sys.argv

    if dry_run:
        print("PASS 2 DRY RUN")
    else:
        print("PASS 2: Fixing remaining kyno_ references")

    total = 0

    # Files that need pass 2
    files = [
        MOD_ROOT / "tap_init" / "tap_recipes.lua",
        MOD_ROOT / "tap_init" / "tap_postinits.lua",
        MOD_ROOT / "tap_init" / "tap_combat_postinits.lua",
        MOD_ROOT / "tap_init" / "tap_combat_replica_postinits.lua",
        MOD_ROOT / "tap_init" / "tap_icons.lua",
        MOD_ROOT / "tap_init" / "tap_containers.lua",
        MOD_ROOT / "tap_init" / "tap_lights.lua",
        MOD_ROOT / "tap_init" / "tap_endtable.lua",
        MOD_ROOT / "tap_init" / "tap_tuning.lua",
        MOD_ROOT / "tap_init" / "tap_loadingtips.lua",
    ]

    # Also process all prefab files and component files
    for d in [MOD_ROOT / "scripts" / "prefabs",
              MOD_ROOT / "scripts" / "components",
              MOD_ROOT / "scripts" / "stategraphs",
              MOD_ROOT / "tap_init" / "libs"]:
        if d.exists():
            files.extend(sorted(d.glob("*.lua")))

    files.append(MOD_ROOT / "scripts" / "writeables.lua")
    files.append(MOD_ROOT / "modmain.lua")

    for f in files:
        if f.exists():
            total += process_file(f, dry_run)

    print(f"\nPass 2 {'would change' if dry_run else 'changed'}: {total} lines")


if __name__ == "__main__":
    main()
