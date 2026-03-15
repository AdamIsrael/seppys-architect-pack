#!/usr/bin/env python3
"""
Phase 0: Build the kyno_ -> sap_ rename mapping table.

Scans the codebase to categorize all kyno_ identifiers into:
1. PREFAB_NAMES - first arg of Prefab() and MakePlacer() calls -> RENAME
2. RECIPE_NAMES - first arg of AddRecipe2() calls -> RENAME
3. STRING_KEYS - KYNO_ keys in STRINGS table -> RENAME to SAP_
4. SPAWN_REFS - SpawnPrefab("kyno_...") calls -> RENAME
5. BUILD_NAMES - SetBank/SetBuild/bank_build args -> DO NOT RENAME (binary)
6. ATLAS_ELEMENTS - XML element names -> DO NOT RENAME (binary)
7. ASSET_PATHS - Asset("ANIM", "anim/kyno_...") file paths -> RENAME path only
8. TAG_NAMES - AddTag/HasTag("kyno_...") -> RENAME (but verify consistency)
9. OTHER_REFS - recipe.product checks, loot refs, etc. -> RENAME

Outputs:
- rename_map.json: full mapping of old -> new names with categories
- rename_report.txt: human-readable summary
"""

import json
import os
import re
from collections import defaultdict
from pathlib import Path

MOD_ROOT = Path(__file__).parent.parent
SCRIPTS_DIR = MOD_ROOT / "scripts"
TAP_INIT_DIR = MOD_ROOT / "tap_init"
PREFABS_DIR = SCRIPTS_DIR / "prefabs"

def find_lua_files(root):
    """Find all .lua files under root."""
    for path in root.rglob("*.lua"):
        yield path

def find_xml_files(root):
    """Find all .xml files under root."""
    for path in root.rglob("*.xml"):
        yield path

def read_file(path):
    try:
        return path.read_text(encoding="utf-8", errors="replace")
    except Exception:
        return ""

def extract_prefab_names():
    """Extract prefab names from Prefab() return calls in scripts/prefabs/."""
    names = set()
    pattern = re.compile(r'Prefab\(\s*"(kyno_[^"]+)"')
    for lua_file in find_lua_files(PREFABS_DIR):
        content = read_file(lua_file)
        for match in pattern.finditer(content):
            names.add(match.group(1))
    return names

def extract_makeplacer_names():
    """Extract placer names (first arg) from MakePlacer() calls."""
    names = set()
    pattern = re.compile(r'MakePlacer\(\s*"(kyno_[^"]+)"')
    for lua_file in find_lua_files(MOD_ROOT):
        content = read_file(lua_file)
        for match in pattern.finditer(content):
            names.add(match.group(1))
    return names

def extract_makeplacer_build_names():
    """Extract bank/build names (2nd and 3rd args) from MakePlacer() calls."""
    names = set()
    # MakePlacer("name", "bank", "build", "anim", ...)
    pattern = re.compile(
        r'MakePlacer\(\s*"[^"]+"\s*,\s*"(kyno_[^"]+)"\s*,\s*"(kyno_[^"]+)"'
    )
    for lua_file in find_lua_files(MOD_ROOT):
        content = read_file(lua_file)
        for match in pattern.finditer(content):
            names.add(match.group(1))
            names.add(match.group(2))
    return names

def extract_recipe_names():
    """Extract recipe names from AddRecipe2() calls."""
    names = set()
    pattern = re.compile(r'AddRecipe2\(\s*"(kyno_[^"]+)"')
    recipes_file = TAP_INIT_DIR / "tap_recipes.lua"
    if recipes_file.exists():
        content = read_file(recipes_file)
        for match in pattern.finditer(content):
            names.add(match.group(1))
    return names

def extract_string_keys():
    """Extract KYNO_ string keys from STRINGS definitions."""
    keys = set()
    # Match patterns like .KYNO_SOMETHING or ["KYNO_SOMETHING"]
    pattern = re.compile(r'[.\[]\s*"?(KYNO_[A-Z0-9_]+)"?')
    for filename in ["tap_strings.lua", "tap_strings_extras.lua"]:
        filepath = TAP_INIT_DIR / filename
        if filepath.exists():
            content = read_file(filepath)
            for match in pattern.finditer(content):
                keys.add(match.group(1))
    return keys

def extract_build_names():
    """Extract animation bank/build names that are baked into .zip binaries."""
    names = set()

    # SetBank("kyno_...") and SetBuild("kyno_...")
    pattern_bank = re.compile(r'SetBank\(\s*"(kyno_[^"]+)"')
    pattern_build = re.compile(r'SetBuild\(\s*"(kyno_[^"]+)"')

    # bank_build = "kyno_..."
    pattern_bankbuild = re.compile(r'bank_build\s*=\s*"(kyno_[^"]+)"')

    for lua_file in find_lua_files(MOD_ROOT):
        content = read_file(lua_file)
        for match in pattern_bank.finditer(content):
            names.add(match.group(1))
        for match in pattern_build.finditer(content):
            names.add(match.group(1))
        for match in pattern_bankbuild.finditer(content):
            names.add(match.group(1))

    return names

def extract_spawn_refs():
    """Extract SpawnPrefab("kyno_...") references."""
    names = set()
    pattern = re.compile(r'SpawnPrefab\(\s*"(kyno_[^"]+)"')
    for lua_file in find_lua_files(MOD_ROOT):
        content = read_file(lua_file)
        for match in pattern.finditer(content):
            names.add(match.group(1))
    return names

def extract_atlas_elements():
    """Extract kyno_ element names from XML atlas files."""
    names = set()
    pattern = re.compile(r'name="(kyno_[^"]+\.tex)"')
    for xml_file in find_xml_files(MOD_ROOT / "images"):
        content = read_file(xml_file)
        for match in pattern.finditer(content):
            names.add(match.group(1))
    return names

def extract_asset_paths():
    """Extract kyno_ animation asset file paths."""
    paths = set()
    pattern = re.compile(r'Asset\(\s*"ANIM"\s*,\s*"(anim/kyno_[^"]+)"')
    for lua_file in find_lua_files(MOD_ROOT):
        content = read_file(lua_file)
        for match in pattern.finditer(content):
            paths.add(match.group(1))
    return paths

def extract_tag_names():
    """Extract kyno_ tag names from AddTag/HasTag calls."""
    names = set()
    pattern = re.compile(r'(?:AddTag|HasTag|RemoveTag)\(\s*"(kyno_[^"]+)"')
    for lua_file in find_lua_files(MOD_ROOT):
        content = read_file(lua_file)
        for match in pattern.finditer(content):
            names.add(match.group(1))
    return names

def extract_postinit_refs():
    """Extract AddPrefabPostInit("kyno_...") references."""
    names = set()
    pattern = re.compile(r'AddPrefabPostInit\(\s*"(kyno_[^"]+)"')
    for lua_file in find_lua_files(MOD_ROOT):
        content = read_file(lua_file)
        for match in pattern.finditer(content):
            names.add(match.group(1))
    return names

def extract_product_checks():
    """Extract recipe.product == "kyno_..." checks."""
    names = set()
    pattern = re.compile(r'recipe\.product\s*==\s*"(kyno_[^"]+)"')
    for lua_file in find_lua_files(MOD_ROOT):
        content = read_file(lua_file)
        for match in pattern.finditer(content):
            names.add(match.group(1))
    return names

def extract_minimap_icons():
    """Extract kyno_ minimap icon references."""
    names = set()
    pattern = re.compile(r'SetIcon\(\s*"(kyno_[^"]+)"')
    for lua_file in find_lua_files(MOD_ROOT):
        content = read_file(lua_file)
        for match in pattern.finditer(content):
            names.add(match.group(1))
    return names

def extract_container_refs():
    """Extract kyno_ container/writeable references."""
    names = set()
    pattern = re.compile(r'"(kyno_[^"]+)"')
    for filename in ["tap_containers.lua"]:
        filepath = TAP_INIT_DIR / filename
        if filepath.exists():
            content = read_file(filepath)
            for match in pattern.finditer(content):
                names.add(match.group(1))
    # Also check writeables
    writeables = SCRIPTS_DIR / "writeables.lua"
    if writeables.exists():
        content = read_file(writeables)
        for match in re.finditer(r'"(kyno_[^"]+)"', content):
            names.add(match.group(1))
    return names

def kyno_to_sap(name):
    """Convert a kyno_ prefixed name to sap_ prefix."""
    if name.startswith("kyno_"):
        return "sap_" + name[5:]
    if name.startswith("KYNO_"):
        return "SAP_" + name[5:]
    return name

def main():
    print("Scanning codebase...")

    # Extract all categories
    prefab_names = extract_prefab_names()
    placer_names = extract_makeplacer_names()
    placer_build_names = extract_makeplacer_build_names()
    recipe_names = extract_recipe_names()
    string_keys = extract_string_keys()
    build_names = extract_build_names()
    spawn_refs = extract_spawn_refs()
    atlas_elements = extract_atlas_elements()
    asset_paths = extract_asset_paths()
    tag_names = extract_tag_names()
    postinit_refs = extract_postinit_refs()
    product_checks = extract_product_checks()
    minimap_icons = extract_minimap_icons()
    container_refs = extract_container_refs()

    # All names that should be RENAMED (prefab identity)
    rename_names = set()
    rename_names.update(prefab_names)
    rename_names.update(placer_names)
    rename_names.update(recipe_names)
    rename_names.update(spawn_refs)
    rename_names.update(postinit_refs)
    rename_names.update(product_checks)

    # Names that must NOT be renamed (binary references)
    do_not_rename = set()
    do_not_rename.update(build_names)
    do_not_rename.update(placer_build_names)
    # Atlas elements are .tex suffixed, different namespace

    # Names in both categories (need careful handling)
    overlap = rename_names & do_not_rename

    # Build the mapping
    mapping = {}

    for name in sorted(prefab_names):
        mapping[name] = {
            "new_name": kyno_to_sap(name),
            "category": "prefab_name",
            "action": "RENAME",
        }

    for name in sorted(placer_names):
        if name not in mapping:
            mapping[name] = {
                "new_name": kyno_to_sap(name),
                "category": "placer_name",
                "action": "RENAME",
            }

    for name in sorted(recipe_names):
        if name not in mapping:
            mapping[name] = {
                "new_name": kyno_to_sap(name),
                "category": "recipe_name",
                "action": "RENAME",
            }

    for key in sorted(string_keys):
        mapping[key] = {
            "new_name": kyno_to_sap(key),
            "category": "string_key",
            "action": "RENAME",
        }

    for name in sorted(build_names):
        if name not in mapping:
            mapping[name] = {
                "new_name": name,  # unchanged
                "category": "build_name",
                "action": "DO_NOT_RENAME",
            }
        else:
            mapping[name]["also_build_name"] = True
            mapping[name]["note"] = "Prefab name AND build name - rename prefab refs only, keep build refs"

    for elem in sorted(atlas_elements):
        mapping[elem] = {
            "new_name": elem,  # unchanged
            "category": "atlas_element",
            "action": "DO_NOT_RENAME",
        }

    for name in sorted(tag_names):
        if name not in mapping:
            mapping[name] = {
                "new_name": kyno_to_sap(name),
                "category": "tag_name",
                "action": "RENAME",
            }

    for name in sorted(minimap_icons):
        # These reference atlas elements, so DO NOT RENAME
        if name not in mapping:
            mapping[name] = {
                "new_name": name,
                "category": "minimap_icon",
                "action": "DO_NOT_RENAME",
                "note": "References compiled atlas element",
            }

    for path in sorted(asset_paths):
        mapping[path] = {
            "new_name": path.replace("kyno_", "sap_"),
            "category": "asset_path",
            "action": "RENAME_IF_FILE_RENAMED",
            "note": "Only rename if the .zip file is also renamed on disk",
        }

    for name in sorted(spawn_refs):
        if name not in mapping:
            mapping[name] = {
                "new_name": kyno_to_sap(name),
                "category": "spawn_ref",
                "action": "RENAME",
            }

    for name in sorted(postinit_refs):
        if name not in mapping:
            mapping[name] = {
                "new_name": kyno_to_sap(name),
                "category": "postinit_ref",
                "action": "RENAME",
            }

    for name in sorted(product_checks):
        if name not in mapping:
            mapping[name] = {
                "new_name": kyno_to_sap(name),
                "category": "product_check",
                "action": "RENAME",
            }

    for name in sorted(container_refs):
        if name not in mapping:
            mapping[name] = {
                "new_name": kyno_to_sap(name),
                "category": "container_ref",
                "action": "RENAME",
            }

    # Write JSON mapping
    output_dir = MOD_ROOT / "tools"
    output_dir.mkdir(exist_ok=True)

    json_path = output_dir / "rename_map.json"
    with open(json_path, "w") as f:
        json.dump(mapping, f, indent=2, sort_keys=True)

    # Write human-readable report
    report_path = output_dir / "rename_report.txt"

    categories = defaultdict(list)
    for name, info in mapping.items():
        categories[info["category"]].append((name, info))

    with open(report_path, "w") as f:
        f.write("=" * 70 + "\n")
        f.write("KYNO_ -> SAP_ RENAME MAPPING REPORT\n")
        f.write("=" * 70 + "\n\n")

        # Summary
        total_rename = sum(1 for v in mapping.values() if v["action"] == "RENAME")
        total_keep = sum(1 for v in mapping.values() if v["action"] != "RENAME")
        total_overlap = len(overlap)

        f.write(f"Total identifiers: {len(mapping)}\n")
        f.write(f"  TO RENAME:       {total_rename}\n")
        f.write(f"  DO NOT RENAME:   {total_keep}\n")
        f.write(f"  OVERLAP (careful): {total_overlap}\n\n")

        # Per-category breakdown
        for cat in sorted(categories.keys()):
            items = categories[cat]
            rename_count = sum(1 for _, info in items if info["action"] == "RENAME")
            keep_count = sum(1 for _, info in items if info["action"] != "RENAME")

            f.write(f"\n{'=' * 70}\n")
            f.write(f"Category: {cat}\n")
            f.write(f"  Count: {len(items)} (rename: {rename_count}, keep: {keep_count})\n")
            f.write(f"{'=' * 70}\n")

            for name, info in sorted(items):
                action = info["action"]
                new_name = info["new_name"]
                note = info.get("note", "")
                also_build = " [ALSO BUILD NAME]" if info.get("also_build_name") else ""

                if action == "RENAME":
                    f.write(f"  RENAME: {name} -> {new_name}{also_build}\n")
                else:
                    f.write(f"  KEEP:   {name}{also_build}\n")

                if note:
                    f.write(f"          Note: {note}\n")

        # Overlap section
        if overlap:
            f.write(f"\n{'=' * 70}\n")
            f.write("CRITICAL: Names that are BOTH prefab names AND build names\n")
            f.write("These need context-aware renaming (rename Prefab() arg, keep SetBuild() arg)\n")
            f.write(f"{'=' * 70}\n")
            for name in sorted(overlap):
                f.write(f"  {name} -> {kyno_to_sap(name)} (prefab only)\n")

    print(f"\nResults written to:")
    print(f"  {json_path}")
    print(f"  {report_path}")
    print(f"\nSummary:")
    print(f"  Total identifiers: {len(mapping)}")
    print(f"  To rename:         {total_rename}")
    print(f"  Do not rename:     {total_keep}")
    print(f"  Overlap (careful): {total_overlap}")
    print(f"\n  Prefab names:      {len(prefab_names)}")
    print(f"  Placer names:      {len(placer_names)}")
    print(f"  Recipe names:      {len(recipe_names)}")
    print(f"  String keys:       {len(string_keys)}")
    print(f"  Build names:       {len(build_names)} (DO NOT RENAME)")
    print(f"  Atlas elements:    {len(atlas_elements)} (DO NOT RENAME)")
    print(f"  Asset paths:       {len(asset_paths)}")
    print(f"  Tag names:         {len(tag_names)}")
    print(f"  Spawn refs:        {len(spawn_refs)}")
    print(f"  PostInit refs:     {len(postinit_refs)}")
    print(f"  Product checks:    {len(product_checks)}")
    print(f"  Minimap icons:     {len(minimap_icons)}")
    print(f"  Container refs:    {len(container_refs)}")

if __name__ == "__main__":
    main()
