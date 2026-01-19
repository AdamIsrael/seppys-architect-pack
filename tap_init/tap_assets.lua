-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local resolvefilepath 	= _G.resolvefilepath

-- Some Assets don't show correctly if they're not set here.
Assets = {
	Asset("ANIM", "anim/kyno_turfs_hamlet.zip"),
	Asset("ANIM", "anim/kyno_turfs_shipwrecked.zip"),
	Asset("ANIM", "anim/kyno_turfs_events.zip"),
	Asset("ANIM", "anim/kyno_turfs_ruins.zip"),
	Asset("ANIM", "anim/kyno_turfs_interior.zip"),
	Asset("ANIM", "anim/kyno_turfs_other.zip"),
	Asset("ANIM", "anim/red_clawling.zip"),
	Asset("ANIM", "anim/cave_exit_rope.zip"),
	Asset("ANIM", "anim/copycreep_build.zip"),
	Asset("ANIM", "anim/vine01_build.zip"),
	Asset("ANIM", "anim/vine02_build.zip"),
	
	-- Mod-specific animations (previously orphaned).
	Asset("ANIM", "anim/porkalypse_clock_01.zip"),
	Asset("ANIM", "anim/porkalypse_clock_02.zip"),
	Asset("ANIM", "anim/porkalypse_clock_03.zip"),
	Asset("ANIM", "anim/porkalypse_clock_marker.zip"),
	Asset("ANIM", "anim/porkalypse_totem.zip"),
	Asset("ANIM", "anim/rock_magma.zip"),
	Asset("ANIM", "anim/rock_magma_gold.zip"),
	Asset("ANIM", "anim/kyno_swamphouses.zip"),
	
	-- Vanilla animation dependencies (used by multiple prefabs).
	Asset("ANIM", "anim/ds_pig_basic.zip"),
	Asset("ANIM", "anim/ds_pig_actions.zip"),
	Asset("ANIM", "anim/ds_pig_attacks.zip"),
	Asset("ANIM", "anim/quagmire_swampig_build.zip"),
	Asset("ANIM", "anim/quagmire_swampig_extras.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("IMAGE", "images/tabimages/tap_tabimages.tex"),
	Asset("ATLAS", "images/tabimages/tap_tabimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_wagstaff.fev"),
	Asset("SOUND", "sound/dontstarve_wagstaff.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/shadwell_sfx.fev"),
	Asset("SOUND", "sound/shadwell_sfx.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/tap_sounds.fev"),
	Asset("SOUND", "sound/tap_sounds.fsb"),
}

-- Minimap Icons.
AddMinimapAtlas("images/minimapimages/tap_minimapicons.xml")