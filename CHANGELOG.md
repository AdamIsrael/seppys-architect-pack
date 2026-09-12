# Changelog

All notable changes to Seppy's Architect Pack are recorded here.

## [3.0.0] - 2026-09-11

A compatibility release. Every prefab in the mod was renamed to end a long-running
conflict with Heap of Foods, and three separate crashes were fixed along the way.

Existing worlds keep their structures. Every old prefab name is registered as an
alias that spawns the renamed one, so saves made with 2.0.0 load normally.

### Changed

- **Renamed all 1450 prefabs from the `kyno_` prefix to `sap_`.** Both this mod and
  Heap of Foods used `kyno_`, so whichever loaded second lost its prefabs and the
  client crashed while preloading. Art, animation banks, and build names keep their
  original spelling, since those are baked into the compiled asset files.
- **Renamed all 686 prefab source files to a `sap_` prefix.** Heap of Foods names its
  files the same way this mod did, and the game caches script modules by path, so a
  shared file name made one mod silently register the other's prefabs. Files named
  after vanilla prefabs in order to override them are unchanged.

### Added

- **Legacy name support for existing saves.** Old `kyno_` names still resolve, each
  spawning its renamed counterpart. A name already claimed by another mod is left
  alone, so the compatibility layer cannot recreate the original conflict.
- **Eleven prefab files are enabled again.** These had been disabled as a workaround
  for the name conflict: ant chest, garden sprinkler, fishes, jellyfishes, lotus
  flower, mussel stick, raindrop, spore caps, truffles, water spray, and birds.

### Fixed

- **Crash on load from a missing declaration in 216 prefab files.**
- **Crash inside the audio engine.** Sound banks were loaded once per prefab file
  rather than once for the mod, with a single sound package loaded by 38 separate
  files. Each bank is now declared exactly once.
- **The audio setting had no effect.** Turning audio off only skipped one file while
  prefab files declared sound directly, so the engine kept loading banks. The setting
  now disables audio completely.
- **Hundreds of failed sound loads per session.** 78 declarations named base-game
  sound banks the mod does not ship, which could never resolve.
- **Renamed items showed an empty inventory slot.** Icons are looked up by prefab
  name, and the image atlases still listed only the old names. Both names resolve now.
- **Some prefabs could not be spawned at all**, a consequence of the file name
  collision described above.

### Performance

- **Removed 2059 redundant asset declarations across 641 prefab files.** Every prefab
  re-declared shared image atlases that the mod already registers once for itself.

## [2.0.0]

- Added compatibility with other mods and fixed bugs, especially with other mods
  containing a large number of audio assets that could cause the game to crash.

## [1.0.0]

- Initial release.
