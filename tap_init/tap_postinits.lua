-- Common Dependencies.
local _G 				= GLOBAL
local require 			= _G.require
local STRINGS 			= _G.STRINGS
local Recipe 			= _G.Recipe
local resolvefilepath 	= _G.resolvefilepath
local ActionHandler 	= _G.ActionHandler
local SpawnPrefab 		= _G.SpawnPrefab
local ACTIONS 			= _G.ACTIONS
local BufferedAction 	= _G.BufferedAction
local TheSim 			= _G.TheSim
local TheNet 			= _G.TheNet
local IsServer 			= TheNet:GetIsServer() or TheNet:IsDedicated()
local shelfer 			= require("components/shelfer")
local TechTree 			= require("techtree")
local KENV 				= env

modimport("tap_init/libs/env")
modimport("tap_init/tap_upvaluehacker")

-- Immortal birds.
local BIRD_PERISH = GetModConfigData("TAP_BIRD_PERISH")
if BIRD_PERISH == 1 then
	TUNING.BIRD_PERISH_TIME = 999999
end

local tap_spoilablenuts = 
{
	"kyno_coconut",
	"teatree_nut",
}

for k, v in pairs(tap_spoilablenuts) do
	AddPrefabPostInit(v, function(inst)	
		if not _G.TheWorld.ismastersim then
			return inst
		end
	
		inst.components.perishable:SetPerishTime(TUNING.PERISH_PRESERVED)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
	end)
end

-- YOTP Decorations.
local function HideYOTP(inst)	
	local YOTP = GetModConfigData("TAP_HAMLET_YOTP")
	if YOTP == 0 then
		inst.AnimState:Hide("YOTP")
	end
end

AddPrefabPostInit("kyno_pighouse_city", 		HideYOTP)
AddPrefabPostInit("kyno_pighouse_city1", 		HideYOTP)
AddPrefabPostInit("kyno_pighouse_city2", 		HideYOTP)
AddPrefabPostInit("kyno_pighouse_city3", 		HideYOTP)
AddPrefabPostInit("kyno_pighouse_city4", 		HideYOTP)
AddPrefabPostInit("kyno_pighouse_city5", 		HideYOTP)
AddPrefabPostInit("kyno_lamppost", 				HideYOTP)
AddPrefabPostInit("kyno_pigtower", 				HideYOTP)
AddPrefabPostInit("kyno_pigtower1", 			HideYOTP)
AddPrefabPostInit("kyno_pigtower2", 			HideYOTP)
AddPrefabPostInit("kyno_pigtower3", 			HideYOTP)
AddPrefabPostInit("kyno_pigtower4", 			HideYOTP)
AddPrefabPostInit("kyno_pigpalacetower", 		HideYOTP)
AddPrefabPostInit("kyno_pigshop_mycityhall", 	HideYOTP)
AddPrefabPostInit("kyno_pigshop_cityhall", 		HideYOTP)
AddPrefabPostInit("kyno_pigshop_cityhall", 		HideYOTP)
AddPrefabPostInit("kyno_pigshop_academy", 		HideYOTP)
AddPrefabPostInit("kyno_pigshop_tinker", 		HideYOTP)
AddPrefabPostInit("kyno_pigshop_bank", 			HideYOTP)
AddPrefabPostInit("kyno_pigshop_hatshop", 		HideYOTP)
AddPrefabPostInit("kyno_pigshop_weapons", 		HideYOTP)
AddPrefabPostInit("kyno_pigshop_arcane", 		HideYOTP)
AddPrefabPostInit("kyno_pigshop_antiquities", 	HideYOTP)
AddPrefabPostInit("kyno_pigshop_produce", 		HideYOTP)
AddPrefabPostInit("kyno_pigshop_deli", 			HideYOTP)
AddPrefabPostInit("kyno_pigshop_general", 		HideYOTP)
AddPrefabPostInit("kyno_pigshop_flower", 		HideYOTP)
AddPrefabPostInit("kyno_pigshop_spa", 			HideYOTP)

-- Infinite Light, with fuel change.
local function new_DoDelta(self, amount)
    local oldsection = self:GetCurrentSection()
    local newsection = (self:GetCurrentSection() + 1) % 5

	self.currentfuel = math.max(0, math.min(self.maxfuel, self.maxfuel * (newsection-0.5)/4.0) )

    if oldsection ~= newsection then
        if self.sectionfn then
            self.sectionfn(newsection, oldsection, self.inst, doer)
        end
        self.inst:PushEvent("onfueldsectionchanged", { newsection = newsection, oldsection = oldsection, doer = doer })
        if self.currentfuel <= 0 and self.depleted then
            self.depleted(self.inst)
        end
    end

    self:StopConsuming()
    self.inst:PushEvent("percentusedchange", { percent = self:GetPercent() })
end

local function InfiniteLight(inst)
	inst:AddTag("eternal")

	if not _G.TheWorld.ismastersim then
		return inst
	end

	local fueled = inst.components.fueled
	if fueled then
		fueled:StopConsuming()
		fueled.DoDelta = new_DoDelta
	end
end

AddPrefabPostInit("kyno_brazier", 	InfiniteLight)
AddPrefabPostInit("nightlight", 	InfiniteLight)

-- Speed for Turfs.
AddComponentPostInit("locomotor", function(inst)
	local QUGSM = inst.UpdateGroundSpeedMultiplier
	
	inst.UpdateGroundSpeedMultiplier = function(self)
	QUGSM(self)
	if self.wasoncreep == false and self:FasterOnRoad() and
	_G.TheWorld.Map:GetTileAtPoint(self.inst.Transform:GetWorldPosition()) == WORLD_TILES.QUAGMIRE_CITYSTONE then
			self.groundspeedmultiplier = self.fastmultiplier
		end
	end
end)

-- Packim Baggims drops from Malbatross.
local PACKIM_CHANCE = GetModConfigData("TAP_PACKIM")
AddPrefabPostInit("malbatross", function(inst)
	if _G.TheWorld.ismastersim and not _G.TheSim:FindFirstEntityWithTag("packim_fishbone") then
		inst.components.lootdropper:AddChanceLoot("packim_fishbone", PACKIM_CHANCE) 
	end
end)

-- Ominous Carving is a trash can for items.
local function PugaliskTrapdoor(inst)
	inst:AddTag("pugalisk_cant_eat")

	if not _G.TheWorld.ismastersim then
		return inst
	end
end

local function TagMe(inst)
	inst:AddTag("key_replica")

	if not _G.TheWorld.ismastersim then
		return inst
	end
end

AddPrefabPostInit("chester_eyebone", 	PugaliskTrapdoor)
AddPrefabPostInit("packim_fishbone", 	PugaliskTrapdoor)
AddPrefabPostInit("glommerflower", 		PugaliskTrapdoor)
AddPrefabPostInit("moonrockseed", 		PugaliskTrapdoor)
AddPrefabPostInit("hutch_fishbowl", 	PugaliskTrapdoor)
AddPrefabPostInit("atrium_key", 		PugaliskTrapdoor)
AddPrefabPostInit("atrium_key", 		TagMe)

AddPrefabPostInitAny(function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
    if inst.components.inventoryitem ~= nil and not inst.components.tradable and not inst:HasTag("pugalisk_cant_eat") then 
		inst:AddComponent("tradable")
		inst:AddTag("pugalisk_test")
	end
end)

-- Plant Butterflies closer than normal.
_G.DEPLOYSPACING.MIN = 6
_G.DEPLOYSPACING_RADIUS[_G.DEPLOYSPACING.MIN] = .5

AddPrefabPostInit("butterfly", function(inst)
	if _G.TheWorld.ismastersim then
		inst.components.deployable:SetDeployMode(_G.DEPLOYMODE.PLANT)
		inst.components.deployable:SetDeploySpacing(_G.DEPLOYSPACING.MIN)
	end
end
)

-- Ro Bin drops from Ancient Guardian.
local ROBIN_CHANCE = GetModConfigData("TAP_ROBIN")
AddPrefabPostInit("minotaur", function(inst)
	if _G.TheWorld.ismastersim and not _G.TheSim:FindFirstEntityWithTag("ro_bin_gizzard_stone") and not _G.TheSim:FindFirstEntityWithTag("ro_bin") then
		inst.components.lootdropper:AddChanceLoot("ro_bin_gizzard_stone", ROBIN_CHANCE) 
	end
end)

local function InfiniteFestiveLight(inst)
	inst:AddTag("festive_infinite")

	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.fueled then
		if inst.components.inventoryitem then
			local old_ondropfn = inst.components.inventoryitem.ondropfn
			inst.components.inventoryitem:SetOnDroppedFn(function(inst)
				old_ondropfn(inst)
				inst.components.fueled:StopConsuming()
			end)
		end
		inst.components.fueled:StopConsuming()
	end
end

AddPrefabPostInit("winter_ornament_light1", InfiniteFestiveLight)
AddPrefabPostInit("winter_ornament_light2", InfiniteFestiveLight)
AddPrefabPostInit("winter_ornament_light3", InfiniteFestiveLight)
AddPrefabPostInit("winter_ornament_light4", InfiniteFestiveLight)
AddPrefabPostInit("winter_ornament_light5", InfiniteFestiveLight)
AddPrefabPostInit("winter_ornament_light6", InfiniteFestiveLight)
AddPrefabPostInit("winter_ornament_light7", InfiniteFestiveLight)
AddPrefabPostInit("winter_ornament_light8", InfiniteFestiveLight)

-- Frozen Furnace drops from Dragonfly if it's winter. Salad Furnace secret drop.
AddPrefabPostInit("dragonfly", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if _G.TheWorld.state.iswinter then
		inst.components.lootdropper:AddChanceLoot("kyno_frozenfurnace_blueprint",     1.00)
		inst.components.lootdropper:AddChanceLoot("saladfurnace_blueprint_blueprint", 0.01)
	else
		inst.components.lootdropper:AddChanceLoot("saladfurnace_blueprint_blueprint", 0.01)
	end
end)

-- Rename some of them.
local function rename_it(inst)
    inst.components.named:PickNewName()
end

AddPrefabPostInit("parrot_pirate", function(inst)
	inst:AddTag("_named")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
		
	inst:RemoveTag("_named")
	
	inst:AddComponent("named")
	inst.components.named.possiblenames = 
	{
		"reD", "Sokoteur", "Glermz", "Kiss-Shot Acerola-Orion Heart-Under-Blade", 
		"Nicky", "Orfeu", "Thalz", "Kyno", "Jazzy", "Ogait", "Harry", "Murdoc", "John", "Jack Sparrow", "Davy Jones", 
		"Cornelius", "Frida", "Dan Van 3000", "Sammy", "Jahzus", "Lakhish", "Pollygon", "Loro", "Vegetable", "Dr Hook", 
		"Donny Jepp", "Octoparrot", "Pequi", "Oilo", "Freddo", "James Bucket", "Gabriel", "Glommer Slayer", "The Destroyer", 
		"Lunatic Parrot", "Helicalpuma" 
	}
	inst.components.named:PickNewName()
end)

-- Cool new loot for some bosses and mobs.
--[[
AddPrefabPostInit("moose", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_goosenestegg_blueprint", 0.10)
end)
]]--

AddPrefabPostInit("beequeen", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.lootdropper and not _G.KnownModIndex:IsModEnabled("workshop-2334209327") then
		inst.components.lootdropper:AddChanceLoot("kyno_antchest_blueprint", 1.00)
	end
end)

--[[
AddPrefabPostInit("leif", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_treeclump_blueprint", 0.05)
end)

AddPrefabPostInit("leif_sparse", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_treeclump_blueprint", 0.05)
end)

AddPrefabPostInit("livingtree", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_truerootchest_blueprint", 0.25) 
end)

AddPrefabPostInit("spiderqueen", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("cocoonedtree_short_blueprint", 0.33)
end)

AddPrefabPostInit("spider_warrior", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.components.lootdropper:AddChanceLoot("cocoonedtreelegacy_short_blueprint", 0.05) 
end)

AddPrefabPostInit("spider_hider", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("cocoonedtreelegacy2_short_blueprint", 0.05) 
end)

AddPrefabPostInit("deerclops", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_snowman_blueprint", 0.33)
end)

AddPrefabPostInit("lightninggoat", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_lightninggoatrod_blueprint", 0.01)
end)

AddPrefabPostInit("alterguardian_phase3dead", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:AddChanceLoot("kyno_defeated_cc4_blueprint", 0.33)
end)
]]--

AddPrefabPostInit("kyno_sharkitten", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if _G.KnownModIndex:IsModEnabled("workshop-2174681153") or _G.KnownModIndex:IsModEnabled("workshop-2334209327") then
		inst.components.lootdropper:AddChanceLoot("kyno_shark_fin", 1.00)
	end
end)

local function BrambleHuskPostinit(inst)
	local function OnCooldown(inst)
		inst._cdtask = nil
	end

	local function DoThorns(inst, owner)
		inst._cdtask = inst:DoTaskInTime(.3, OnCooldown)

		inst._hitcount = 0

		SpawnPrefab("bramblefx_armor"):SetFXOwner(owner)

		if owner.SoundEmitter ~= nil then
			owner.SoundEmitter:PlaySound("dontstarve/common/together/armor/cactus")
		end
	end

	local function OnBlocked(owner, data, inst)
		if inst._cdtask == nil and data ~= nil and not data.redirected then
			DoThorns(inst, owner)
		end
	end

	local function OnAttackOther(owner, data, inst)
		if inst._cdtask == nil and checknumber(inst._hitcount) then
			inst._hitcount = inst._hitcount + 1

			if inst._hitcount >= TUNING.WORMWOOD_ARMOR_BRAMBLE_RELEASE_SPIKES_HITCOUNT then
				DoThorns(inst, owner)
			end
		end
	end

	local function onequipbrambletap(inst, owner)
		local skin_build = inst:GetSkinBuild()
		if skin_build ~= nil then
			owner:PushEvent("equipskinneditem", inst:GetSkinName())
			owner.AnimState:OverrideItemSkinSymbol("swap_body", skin_build, "swap_body", inst.GUID, "armor_bramble")
		else
			owner.AnimState:OverrideSymbol("swap_body", "armor_bramble", "swap_body")
		end

		inst:ListenForEvent("blocked", inst._onblocked, owner)
		inst:ListenForEvent("attacked", inst._onblocked, owner)

		inst._hitcount = 0

		if owner.components.skilltreeupdater ~= nil and owner.components.skilltreeupdater:IsActivated("wormwood_armor_bramble") then
			inst:ListenForEvent("onattackother", inst._onattackother, owner)
		end
		
		owner:AddTag("bramble_resistant")
	end

	local function onunequipbrambletap(inst, owner)
		owner.AnimState:ClearOverrideSymbol("swap_body")

		inst:RemoveEventCallback("blocked", inst._onblocked, owner)
		inst:RemoveEventCallback("attacked", inst._onblocked, owner)
		inst:RemoveEventCallback("onattackother", inst._onattackother, owner)

		inst._hitcount = nil

		local skin_build = inst:GetSkinBuild()
		if skin_build ~= nil then
			owner:PushEvent("unequipskinneditem", inst:GetSkinName())
		end
		
		owner:RemoveTag("bramble_resistant")
	end
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst._hitcount = nil
	
	inst.components.equippable:SetOnEquip(onequipbrambletap)
    inst.components.equippable:SetOnUnequip(onunequipbrambletap)
	
	inst._onblocked      = function(owner, data)     OnBlocked(owner, data, inst) end
    inst._onattackother  = function(owner, data) OnAttackOther(owner, data, inst) end
end

AddPrefabPostInit("armor_bramble", BrambleHuskPostinit)

--[[
local function ondeathnew(inst)
	if math.random() < 0.1 then
		_G.SpawnPrefab("kyno_wigfridge_blueprint").Transform:SetPosition(inst.Transform:GetWorldPosition())
	end
	inst.battleborn = 0
end

AddPrefabPostInit("wathgrithr", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:ListenForEvent("death", ondeathnew)
end)
]]--

local tap_rotatablestructures = 
{
	"wall_hay",
	"wall_wood",
	"wall_stone",
	"wall_thulecite",
	"wall_moonrock",
	"wall_ruins",
	"wall_ruins_2",
	"wall_dreadstone",
	"ruinsrelic_plate",
	"ruinsrelic_bowl",
	"ruinsrelic_chair",
	"ruinsrelic_chipbowl",
	"ruinsrelic_vase",
	"ruinsrelic_table",
}

for k, v in pairs(tap_rotatablestructures) do
	AddPrefabPostInit(v, function(inst)
		inst:AddTag("rotatableobject")
	end)
end

-- Default strings for some turfs.
local tap_carpetstrings = 
{
	"turf_redcarpet",
	"turf_pinkcarpet",
	"turf_orangecarpet",
	"turf_cyancarpet",
	"turf_whitecarpet",
	"turf_snakeskinfloor",
}

local tap_rockystrings = 
{
	"turf_magma",
	"turf_volcano",
	"turf_ash",
	"turf_stonecity",
	"turf_forgerock",
}

local tap_roadstrings = 
{
	"turf_modern_cobblestones",
	"turf_forgeroad",
}

local tap_grassstrings = 
{
	"turf_meadow",
	"turf_cultivated",
	"turf_mossy_blossom",
}

local tap_foreststrings = 
{
	"turf_jungle",
	"turf_rainforest",
	"turf_deepjungle",
	"turf_gasjungle",
}

local tap_desertstrings = 
{
	"turf_beach",
	"turf_bog",
}

for k, v in pairs(tap_carpetstrings) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		if inst.components.inspectable ~= nil then
			inst.components.inspectable.nameoverride = "TURF_CARPETFLOOR"
		end
	end)
end

for k, v in pairs(tap_rockystrings) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		if inst.components.inspectable ~= nil then
			inst.components.inspectable.nameoverride = "TURF_ROCKY"
		end
	end)
end

for k, v in pairs(tap_roadstrings) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		if inst.components.inspectable ~= nil then
			inst.components.inspectable.nameoverride = "TURF_ROAD"
		end
	end)
end

for k, v in pairs(tap_grassstrings) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		if inst.components.inspectable ~= nil then
			inst.components.inspectable.nameoverride = "TURF_GRASS"
		end
	end)
end

for k, v in pairs(tap_foreststrings) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
		
		if inst.components.inspectable ~= nil then
			inst.components.inspectable.nameoverride = "TURF_FOREST"
		end
	end)
end

AddPrefabPostInit("turf_tidalmarsh", function(inst)	
	if inst.components.inspectable ~= nil then
	inst.components.inspectable.nameoverride = "TURF_MARSH"
	end 
end)

AddPrefabPostInit("turf_plains", function(inst)	
	if inst.components.inspectable ~= nil then
	inst.components.inspectable.nameoverride = "TURF_SAVANNA"
	end 
end)

AddPrefabPostInit("turf_batcave", function(inst)	
	if inst.components.inspectable ~= nil then
	inst.components.inspectable.nameoverride = "TURF_CAVE"
	end 
end)

AddPrefabPostInit("turf_antcave", function(inst)	
	if inst.components.inspectable ~= nil then
	inst.components.inspectable.nameoverride = "TURF_UNDERROCK"
	end 
end)

-- Common strings for some structures.
AddPrefabPostInit("kyno_rubble_bike", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_RUBBLE_BIKE"
	end 
end)

AddPrefabPostInit("kyno_rubble_carriage", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end	
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_RUBBLE_CARRIAGE"
	end 
end)

AddPrefabPostInit("kyno_rubble_clock", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_RUBBLE_CLOCK"
	end 
end)

AddPrefabPostInit("kyno_rubble_cathedral", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_RUBBLE_CATHEDRAL"
	end 
end)

AddPrefabPostInit("kyno_rubble_pubdoor", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_RUBBLE_PUBDOOR"
	end 
end)

AddPrefabPostInit("kyno_rubble_door", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_RUBBLE_PUBDOOR"
	end 
end)

AddPrefabPostInit("kyno_rubble_roof", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_RUBBLE_ROOF"
	end 
end)

AddPrefabPostInit("kyno_rubble_clocktower", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_RUBBLE_CLOCKTOWER"
	end 
end)

AddPrefabPostInit("kyno_rubble_house", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_RUBBLE_HOUSE"
	end 
end)

AddPrefabPostInit("kyno_rubble_chimney", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_RUBBLE_CHIMNEY"
	end 
end)

AddPrefabPostInit("kyno_rubble_chimney2", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_RUBBLE_CHIMNEY2"
	end 
end)

AddPrefabPostInit("kyno_carrot_planted", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "CARROT"
	end 
end)

AddPrefabPostInit("kyno_potato_planted", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "POTATO"
	end 
end)

AddPrefabPostInit("kyno_turnip_planted", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_TURNIP"
	end 
end)

AddPrefabPostInit("kyno_onion_planted", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "ONION"
	end 
end)

AddPrefabPostInit("kyno_wheat_planted", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "QUAGMIRE_WHEAT"
	end 
end)

AddPrefabPostInit("kyno_garlic_planted", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "GARLIC"
	end 
end)

AddPrefabPostInit("kyno_tomato_planted", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "TOMATO"
	end 
end)

AddPrefabPostInit("kyno_sculpture_knighthead", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
		
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "SCULPTURE_KNIGHTHEAD"
	end 
end)

AddPrefabPostInit("kyno_sculpture_bishophead", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "SCULPTURE_BISHOPHEAD"
	end 
end)

AddPrefabPostInit("kyno_sculpture_rooknose", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "SCULPTURE_ROOKNOSE"
	end 
end)

AddPrefabPostInit("kyno_altar_glass", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
		
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "MOON_ALTAR_GLASS"
	end 
end)

AddPrefabPostInit("kyno_altar_seed", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "MOON_ALTAR_SEED"
	end 
end)

AddPrefabPostInit("kyno_altar_crown", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "MOON_ALTAR_CROWN"
	end 
end)

AddPrefabPostInit("kyno_altar_idol", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "MOON_ALTAR_IDOL"
	end 
end)

AddPrefabPostInit("kyno_pighead", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "PIGHEAD"
	end 
end)

AddPrefabPostInit("kyno_mermhead", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "MERMHEAD"
	end 
end)

AddPrefabPostInit("kyno_pond", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "POND"
	end 
end)

AddPrefabPostInit("kyno_pondmarsh", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "POND"
	end 
end)

AddPrefabPostInit("kyno_pondlava", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "LAVA_POND"
	end 
end)

AddPrefabPostInit("kyno_pondrock", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "ROCK"
	end 
end)

AddPrefabPostInit("kyno_pond_rock", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "ROCK"
	end 
end)

AddPrefabPostInit("kyno_p_farmrock", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "ROCKS"
	end
end)

AddPrefabPostInit("kyno_p_farmrocktall", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "ROCKS"
	end
end)

AddPrefabPostInit("kyno_p_farmrockflat", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "ROCKS"
	end 
end)

AddPrefabPostInit("kyno_p_stick", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "TWIGS"
	end 
end)

AddPrefabPostInit("kyno_p_stickright", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "TWIGS"
	end 
end)

AddPrefabPostInit("kyno_p_stickleft", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "TWIGS"
	end 
end)

AddPrefabPostInit("kyno_p_signleft", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "HOMESIGN"
	end 
end)

AddPrefabPostInit("kyno_p_signright", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "HOMESIGN"
	end 
end)

AddPrefabPostInit("kyno_p_fencepost", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "FENCE"
	end 
end)

AddPrefabPostInit("kyno_p_fencepostright", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "FENCE"
	end 
end)

AddPrefabPostInit("kyno_p_burntstickright", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "TWIGS"
	end 
end)

AddPrefabPostInit("kyno_p_burntstickleft", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "TWIGS"
	end 
end)

AddPrefabPostInit("kyno_p_burntstick", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "TWIGS"
	end 
end)

AddPrefabPostInit("kyno_p_burntfencepost", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "FENCE"
	end 
end)

AddPrefabPostInit("kyno_p_burntfencepostright", function(inst)	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "FENCE"
	end 
end)

-- Common strings for Mast and Mast Items.
local tap_masts = 
{
	"kyno_mast_01",
	"kyno_mast_02",
	"kyno_mast_03",
	"kyno_mast_04",
	"kyno_mast_05",
	"kyno_mast_06",
	"kyno_mast_07",
	"kyno_mast_08",
	"kyno_mast_019",
}

local tap_masts_items = 
{
	"kyno_mast_item_01",
	"kyno_mast_item_02",
	"kyno_mast_item_03",
	"kyno_mast_item_04",
	"kyno_mast_item_05",
	"kyno_mast_item_06",
	"kyno_mast_item_07",
	"kyno_mast_item_08",
	"kyno_mast_item_09",
}

for k, v in pairs(tap_masts) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
	
		if inst.components.inspectable ~= nil then
			inst.components.inspectable.nameoverride = "MAST"
		end 
	end)
end

for k, v in pairs(tap_masts_items) do
	AddPrefabPostInit(v, function(inst)
		if not _G.TheWorld.ismastersim then
			return inst
		end
	
		if inst.components.inspectable ~= nil then
			inst.components.inspectable.nameoverride = "MAST_ITEM"
		end 
	end)
end

-- Wendy's Sisturn preserve things inside it.
AddPrefabPostInit("sisturn", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
		
	inst:AddComponent("preserver")
	inst.components.preserver:SetPerishRateMultiplier(0)
end)

-- Night Light spawns Nightmare Creatures when lit.
local function onfuelchangenew(newsection, oldsection, inst)
    if newsection <= 0 then
        inst.components.burnable:Extinguish()
		inst.components.childspawner:StopRegen()
		inst.components.childspawner:StopSpawning()
		for k,child in pairs(inst.components.childspawner.childrenoutside) do
			child.components.combat:SetTarget(nil)
			child.components.lootdropper:SetLoot({})
			child.components.lootdropper:SetChanceLootTable(nil)
			child.components.health:Kill()
		end
    else
        if not inst.components.burnable:IsBurning() then
            inst.components.burnable:Ignite()
			inst.components.childspawner:StartRegen()
			inst.components.childspawner:StartSpawning()
        end

        inst.components.burnable:SetFXLevel(newsection, inst.components.fueled:GetSectionPercent())
    end
end

AddPrefabPostInit("nightlight", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("childspawner")
	inst.components.childspawner:SetRegenPeriod(5)
	inst.components.childspawner:SetSpawnPeriod(30)
	inst.components.childspawner:SetMaxChildren(0)
	inst.components.childspawner.childname = "crawlingnightmare"
	inst.components.childspawner:SetRareChild("nightmarebeak", 0.35)
	local _sectionfn = inst.components.fueled.sectionfn
	inst.components.fueled:SetSectionCallback(function(section, ...)
		_sectionfn(section, ...)
		if section > 0 then
			inst.components.childspawner:StartRegen()
			inst.components.childspawner:StartSpawning()
		else
			inst.components.childspawner:StopRegen()
			inst.components.childspawner:StopSpawning()
			for k,child in pairs(inst.components.childspawner.childrenoutside) do
				child.components.combat:SetTarget(nil)
				child.components.lootdropper:SetLoot({})
				child.components.lootdropper:SetChanceLootTable(nil)
				child.components.health:Kill()
			end
		end
		inst.components.childspawner:SetMaxChildren(section)
		inst.components.childspawner:SetSpawnPeriod(50-section*10)
	end)
end)

-- For placing structures closer.
local STATUES_PLACER = GetModConfigData("TAP_STATUES_PLACER")
if STATUES_PLACER == 1 then
	AddComponentPostInit("inventory", function(self)
		local InventoryDropItemFromInvTile = self.DropItemFromInvTile
		self.DropItemFromInvTile = function(self, item, single)
			if not item.components.inventoryitem.cangoincontainer then
				local player = self.inst
				local playercontroller = player.components.playercontroller
				if not player.sg:HasStateTag("busy") and self:CanAccessItem(item) and playercontroller then
					local pos = playercontroller:GetRemotePredictPosition() or player:GetPosition()
					pos.x = math.floor(pos.x) + 0.5
					pos.z = math.floor(pos.z) + 0.5
					local act = BufferedAction(player, nil, ACTIONS.DROP, item, pos)
					player.components.locomotor:PushAction(act, true)
				end
			else
				InventoryDropItemFromInvTile(self, item, single)
			end
		end
	end)
end

--[[
AddPrefabPostInit("kingfisher", function(inst)
	if not _G.KnownModIndex:IsModEnabled("workshop-2334209327") then 
		if inst.components.periodicspawner ~= nil then
			inst.components.periodicspawner:SetPrefab("kyno_koi")
			inst.components.periodicspawner:SetDensityInRange(20, 2)
			inst.components.periodicspawner:SetMinimumSpacing(15)
		end
	end
end)
]]--

-- For the Pyre Nest.
AddPrefabPostInit("tallbirdegg", function(inst)
	inst:AddTag("pyre_egg")
end)

-- Custom names for the Hamlet Pigs.
AddPrefabPostInit("kyno_pigman_mayor", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.named.possiblenames = { "Mayor Truffleston" }
	inst.components.named:PickNewName()
end)

AddPrefabPostInit("kyno_pigman_queen", function(inst)
	inst.AnimState:Show("hat")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end

	inst.components.named.possiblenames = { "Queen Malfalfa" }
	inst.components.named:PickNewName()
end)

-- Tree cycle (Short-Tall / Tall-Short).
local function TreeCycle(inst)
	local CYCLE = GetModConfigData("TAP_TREE_CYCLE")
	if inst.components.growable ~= nil then
		if CYCLE == 0 then
			inst.components.growable.loopstages = false
		else
			inst.components.growable.loopstages = true
		end
	end
end

AddPrefabPostInit("kyno_palmtree", 				TreeCycle)
AddPrefabPostInit("tubertree", 					TreeCycle)
AddPrefabPostInit("tubertreebloom", 			TreeCycle)
AddPrefabPostInit("teatree", 					TreeCycle)
AddPrefabPostInit("spidermonkeytree", 			TreeCycle)
AddPrefabPostInit("clawtree", 					TreeCycle)
AddPrefabPostInit("clawtree2", 					TreeCycle)
AddPrefabPostInit("rainforesttree", 			TreeCycle)
AddPrefabPostInit("rainforesttree_bloom", 		TreeCycle)
AddPrefabPostInit("rainforesttreelegacy_bloom", TreeCycle)
AddPrefabPostInit("rainforesttreelegacy", 		TreeCycle)
AddPrefabPostInit("rainforesttreelegacy2", 		TreeCycle)
AddPrefabPostInit("rainforesttree_rot", 		TreeCycle)
AddPrefabPostInit("rainforesttreelegacy_rot", 	TreeCycle)
AddPrefabPostInit("mangrovetree", 				TreeCycle)
AddPrefabPostInit("jungletree", 				TreeCycle)
AddPrefabPostInit("cocoonedtree", 				TreeCycle)
AddPrefabPostInit("cocoonedtreelegacy", 		TreeCycle)
AddPrefabPostInit("cocoonedtreelegacy2",		TreeCycle)
AddPrefabPostInit("cottontree", 				TreeCycle)

-- For using Wickerbottom's book on marble trees.
AddPrefabPostInit("marbleshrub", function(inst)
	inst:AddTag("plant")
	inst:AddTag("tree")
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
end)

-- For the Lobster Home.
--[[
local function RockyPostinit(inst)
	local function OnGetItemFromPlayerRocky(inst, giver, item)
		if item.components.edible ~= nil and item.components.edible.foodtype == FOODTYPE.ELEMENTAL then
			if inst.components.combat:TargetIs(giver) then
				inst.components.combat:SetTarget(nil)
			elseif giver.components.leader ~= nil then
				giver:PushEvent("makefriend")
				giver.components.leader:AddFollower(inst)
				inst.components.follower:AddLoyaltyTime(
					giver:HasTag("polite")
					and TUNING.ROCKY_LOYALTY + TUNING.ROCKY_POLITENESS_LOYALTY_BONUS
					or TUNING.ROCKY_LOYALTY
				)
				inst.sg:GoToState("rocklick")
			end
		end
		if inst.components.sleeper:IsAsleep() then
			inst.components.sleeper:WakeUp()
		end
	end
	
	local loot2 = { "rocks", "rocks", "meat", "flint", "flint", "kyno_lobster_claw" }
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:SetLoot(loot2)
	inst.components.trader.onaccept = OnGetItemFromPlayerRocky
end

AddPrefabPostInit("rocky", RockyPostinit)
]]--

-- Ancient Fuelweaver drops the Gateway blueprint.
--[[
local function StalkerPostinit(inst)
	local function AtriumLootFnTAP2(lootdropper)
		lootdropper:SetLoot(nil)
		if lootdropper.inst.atriumdecay then
			lootdropper:AddChanceLoot("shadowheart", 1)
		else
			lootdropper:AddChanceLoot("thurible", 1)
			lootdropper:AddChanceLoot("armorskeleton", 1)
			lootdropper:AddChanceLoot("skeletonhat", 1)
			lootdropper:AddChanceLoot("chesspiece_stalker_sketch", 1)
			lootdropper:AddChanceLoot("kyno_atriumgateway_blueprint", 1)
			lootdropper:AddChanceLoot("nightmarefuel", 1)
			lootdropper:AddChanceLoot("nightmarefuel", 1)
			lootdropper:AddChanceLoot("nightmarefuel", 1)
			lootdropper:AddChanceLoot("nightmarefuel", 1)
			lootdropper:AddChanceLoot("nightmarefuel", .5)
			lootdropper:AddChanceLoot("nightmarefuel", .5)
			if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
				lootdropper:AddChanceLoot("winter_ornament_boss_fuelweaver", 1)
				lootdropper:AddChanceLoot(GetRandomBasicWinterOrnament(), 1)
				lootdropper:AddChanceLoot(GetRandomBasicWinterOrnament(), 1)
				lootdropper:AddChanceLoot(GetRandomBasicWinterOrnament(), 1)
			end
		end
	end
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.lootdropper:SetLootSetupFn(AtriumLootFnTAP2)
end

AddPrefabPostInit("stalker_atrium", StalkerPostinit)
]]--

local function OrangeAmuletPostinit(inst)
	local ORANGE_PICKUP_CANT_TAGS = { "INLIMBO", "NOCLICK", "knockbackdelayinteraction", 
	"catchable", "fire", "minesprung", "mineactive", "spider", "bookshelfed" }
	
	local function OrangeAmuletPickup(inst, owner)
		if owner == nil or owner.components.inventory == nil then
			return
		end
		local x, y, z = owner.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, TUNING.ORANGEAMULET_RANGE, ORANGE_PICKUP_MUST_TAGS, ORANGE_PICKUP_CANT_TAGS)
		local ba = owner:GetBufferedAction()
		for i, v in ipairs(ents) do
			if v.components.inventoryitem ~= nil and
				v.components.inventoryitem.canbepickedup and
				v.components.inventoryitem.cangoincontainer and
				not v.components.inventoryitem:IsHeld() and
				owner.components.inventory:CanAcceptCount(v, 1) > 0 and
				(ba == nil or ba.action ~= ACTIONS.PICKUP or ba.target ~= v) then

				if owner.components.minigame_participator ~= nil then
					local minigame = owner.components.minigame_participator:GetMinigame()
					if minigame ~= nil then
						minigame:PushEvent("pickupcheat", { cheater = owner, item = v })
					end
				end

				SpawnPrefab("sand_puff").Transform:SetPosition(v.Transform:GetWorldPosition())

				inst.components.finiteuses:Use(1)

				local v_pos = v:GetPosition()
				if v.components.stackable ~= nil then
					v = v.components.stackable:Get()
				end

				if v.components.trap ~= nil and v.components.trap:IsSprung() then
					v.components.trap:Harvest(owner)
				else
					owner.components.inventory:GiveItem(v, nil, v_pos)
				end
				return
			end
		end
	end
	
	local function onequip_orangetap(inst, owner)
		owner.AnimState:OverrideSymbol("swap_body", "torso_amulets", "orangeamulet")
		inst.task = inst:DoPeriodicTask(TUNING.ORANGEAMULET_ICD, OrangeAmuletPickup, nil, owner)
	end

	local function onunequip_orangetap(inst, owner)
		owner.AnimState:ClearOverrideSymbol("swap_body")
		if inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
		end
	end
	
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	inst.components.equippable:SetOnEquip(onequip_orangetap)
    inst.components.equippable:SetOnUnequip(onunequip_orangetap)
end

AddPrefabPostInit("orangeamulet", OrangeAmuletPostinit)

AddPrefabPostInit("wall_moonrock", function(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	-- This does not affect the durability of Moon Rock Wall.
	inst.components.workable:SetWorkLeft(3)
end)

-- Keep food fresh on Cooking Stations.
local KEEP_FOOD = GetModConfigData("TAP_FOOD_FRESH")
if KEEP_FOOD == 1 then
	local tap_foodstations = {
		"cookpot",
		"archive_cookpot",
		"portablecookpot",
		"portablespicer",
		"kyno_archive_cookpot",
	}
	for k, v in pairs(tap_foodstations) do
		AddPrefabPostInit(v, function(inst)
			if inst.components.stewer then
				inst.components.stewer.onspoil = function() 
					inst.components.stewer.spoiltime = 1
					inst.components.stewer.targettime = _G.GetTime()
					inst.components.stewer.product_spoilage = 0
				end
			end
		end)
	end
end

-- Table For Display Mod.
_G.AllRecipes["table_winters_feast"].level = TechTree.Create(_G.TECH.NONE)
local food_fx = "wintersfeast2019/winters_feast/table/fx"
local function SetFoodSymbol(inst, foodname, override_build)
	if foodname == nil then
		inst.AnimState:ClearOverrideSymbol("swap_cooked")
	else
		inst.AnimState:OverrideSymbol("swap_cooked", override_build or "food_winters_feast_2019", foodname)
	end
end
	
local function ChangeFestiveTable(inst)
	if inst and inst.components and inst.components.shelf then
		local old_onshelfitemfn = inst.components.shelf.onshelfitemfn
		inst.components.shelf.onshelfitemfn = function(inst, item)
			if item ~= nil then
				inst.components.trader:Disable()
				if item.prefab ~= "spoiled_food" and not item:HasTag("wintersfeastcookedfood") then 
					if item:HasTag("spicedfood") then
						local spice_start, spice_end = string.find(item.prefab, "_spice_")
						local baseprefab = string.sub(item.prefab, 1, spice_start - 1)
						local spicesymbol = string.sub(item.prefab, spice_start + 1)

						SetFoodSymbol(inst, baseprefab, item.food_symbol_build or item.AnimState:GetBuild())
						inst.AnimState:OverrideSymbol("swap_garnish", "spices", spicesymbol)
						inst.AnimState:OverrideSymbol("swap_plate", "plate_food", "plate")
					else
						SetFoodSymbol(inst, item.prefab, item.AnimState:GetBuild())
					end
					if item.components.perishable then
						item.components.perishable:StopPerishing()
					end
					inst.components.wintersfeasttable.canfeast = false
					inst.components.shelf.cantakeitem = true

					inst.AnimState:PlayAnimation("food")
					inst.AnimState:PushAnimation("idle")

					inst.SoundEmitter:PlaySound(food_fx)
				else
					old_onshelfitemfn(inst, item)
				end
			end
		end
		local old_ontakeitemfn = inst.components.shelf.ontakeitemfn
		inst.components.shelf.ontakeitemfn = function(inst, taker, item)
				if item and item.components and item.components.perishable then
				item.components.perishable:StartPerishing()
			end
			old_ontakeitemfn(inst, taker, item)
		end
	end
end

AddPrefabPostInit("table_winters_feast", change)

-- Support for Multi-Shards.
local BUILDING_MIGRATOR = GetModConfigData("TAP_BUILDING_MIGRATOR")
if BUILDING_MIGRATOR == 1 and shard then
	local tap_building_migrators = 
	{
		"kyno_ruinsentrance_ground1",
		"kyno_ruinsentrance_ground2",
		"kyno_ruinsentrance_ground3",
		"kyno_archive_portal",
		"kyno_atriumgateway",
		"kyno_atriumgateway_wip",
		"kyno_lavagateway",
		"kyno_lavaspawner",
		"kyno_friendomatic",
		"kyno_mossygateway",
		"kyno_ham_prototyper",
		"kyno_sw_prototyper",
		"kyno_lunar_energy",
		"kyno_lunar_energy_wip",
		"kyno_portalstone",
		"kyno_juryriggedportal",
		"kyno_portalbuilding",
		"kyno_celestialportal",
		"kyno_sinkhole",
		"kyno_sinkhole_closed",
		"kyno_sinkhole_vip",
		"kyno_sinkhole_ruins",
		"kyno_cavehole",
		"kyno_surfacestairs",
		"kyno_surfacestairs_closed",
		"kyno_surfacestairs_vip",
		"kyno_volcanostairs",
		"kyno_monkeyisland_portal1",
		"kyno_monkeyisland_portal2",
		"kyno_lunarrift_portal",
		"kyno_shadowrift_portal",
	}
	
	for k, v in pairs(tap_building_migrators) do
		AddPrefabPostInit(v, function(inst)
			
			if not _G.TheWorld.ismastersim then
				return inst
			end
			
			inst:AddComponent("worldmigrator")
		end)
	end
end

-- Wurt is also fast on Tidal Marsh turf.
local function WurtPostinit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.locomotor ~= nil then
		inst.components.locomotor:SetFasterOnGroundTile(WORLD_TILES.TIDALMARSH, true)
		inst.components.locomotor:SetFasterOnGroundTile(WORLD_TILES.GREENMARSH, true)
	end
end

AddPrefabPostInit("wurt", WurtPostinit)

-- Honey and Honey-based foods do not spoil inside Honey Deposits.
local spices = 
{
	"chili",
	"garlic",
	"sugar",
	"salt",
}

local honeyed_foods2 = 
{
	"bandage",
	"honey",
	"royal_jelly",
    "honeynuggets",
	"honeyham",
	"powcake",
	"freshfruitcrepes",
	"taffy",
	"icecream",
	"leafymeatsouffle",
	"voltgoatjelly",
	"sweettea",
	"pumpkincookie",
	"leafymeatsouffle",
	"beeswax",
	"bee",
	"killerbee",
	"beemine",
	"hivehat",
}

local function HoneyFoodsPostinit(inst)
	if not inst:HasTag("honeyed") then -- Just in case if they already have.
		inst:AddTag("honeyed")
	end
end

for k,v in pairs(honeyed_foods2) do
	AddPrefabPostInit(v, HoneyFoodsPostinit)
	
	for k,s in pairs(spices) do 
		AddPrefabPostInit(v.."_spice_"..s, HoneyFoodsPostinit)
	end
end

local function DriftwoodGatePostinit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "FENCE_GATE_ITEM"
	end
end

AddPrefabPostInit("kyno_driftwood_gate", DriftwoodGatePostinit)
AddPrefabPostInit("kyno_driftwood_gate_item", DriftwoodGatePostinit)

local function DriftwoodFencePostinit(inst)
	if not _G.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.inspectable ~= nil then
		inst.components.inspectable.nameoverride = "FENCE_ITEM"
	end
end

AddPrefabPostInit("kyno_driftwood_fence", DriftwoodFencePostinit)
AddPrefabPostInit("kyno_driftwood_fence_item", DriftwoodFencePostinit)

-- New birds will spawn when landing on these turfs.
local SPECIAL_BIRDS = GetModConfigData("TAP_SPECIAL_BIRDS")
if SPECIAL_BIRDS == 1 then
	AddClassPostConstruct("components/birdspawner", function(self) 
		local BIRD_TYPES = UpvalueHacker.GetUpvalue(self.SpawnBird, "PickBird", "BIRD_TYPES")
	
		-- Hamlet Birds --
		BIRD_TYPES[WORLD_TILES.RAINFOREST]            = { "kingfisher2", "parrot_blue", "toucan_hamlet" }
		BIRD_TYPES[WORLD_TILES.FIELDS]                = { "kingfisher2", "parrot_blue", "toucan_hamlet" }
		BIRD_TYPES[WORLD_TILES.MOSSY_BLOSSOM]         = { "kingfisher2", "parrot_blue", "toucan_hamlet" }
		BIRD_TYPES[WORLD_TILES.PLAINS]                = { "toucan_hamlet", "parrot_blue" }
		BIRD_TYPES[WORLD_TILES.BOG]                   = { "toucan_hamlet" }
		BIRD_TYPES[WORLD_TILES.PIGRUINS]              = { "parrot_blue" }
		BIRD_TYPES[WORLD_TILES.DECIDUOUS]             = { "toucan_hamlet" }
		BIRD_TYPES[WORLD_TILES.LAWN]                  = { "pigeon" }
		BIRD_TYPES[WORLD_TILES.COBBLEROAD]            = { "pigeon" }
		BIRD_TYPES[WORLD_TILES.FOUNDATION]            = { "pigeon" }
	
		-- Gorge Birds --
		BIRD_TYPES[WORLD_TILES.PINKSTONE]             = { "quagmire_pigeon" }
		BIRD_TYPES[WORLD_TILES.QUAGMIRE_PARKFIELD]    = { "quagmire_pigeon", "toucan_hamlet" }
		BIRD_TYPES[WORLD_TILES.QUAGMIRE_CITYSTONE]    = { "quagmire_pigeon" }
		BIRD_TYPES[WORLD_TILES.GREYFOREST]            = { "quagmire_pigeon" }
		BIRD_TYPES[WORLD_TILES.BROWNCARPET]           = { "quagmire_pigeon" }
	
		-- Shipwrecked Birds --
		BIRD_TYPES[WORLD_TILES.BEACH]                 = { "toucan", "parrot", "parrot_pirate", "seagull" }
		BIRD_TYPES[WORLD_TILES.JUNGLE]                = { "toucan", "parrot", "parrot_pirate" }
		BIRD_TYPES[WORLD_TILES.MEADOW]                = { "toucan", "parrot" }
		BIRD_TYPES[WORLD_TILES.TIDALMARSH]            = { "toucan", "parrot", "parrot_pirate" }
		BIRD_TYPES[WORLD_TILES.OCEAN_COASTAL]         = { "puffin", "seagull", "cormorant" }
		BIRD_TYPES[WORLD_TILES.OCEAN_COASTAL_SHORE]   = { "puffin", "seagull", "cormorant" }
		BIRD_TYPES[WORLD_TILES.OCEAN_SWELL]           = { "puffin", "seagull", "cormorant" }
		BIRD_TYPES[WORLD_TILES.OCEAN_ROUGH]           = { "puffin", "seagull", "cormorant" }
		BIRD_TYPES[WORLD_TILES.OCEAN_BRINEPOOL]       = { "puffin", "seagull", "cormorant" }
		BIRD_TYPES[WORLD_TILES.OCEAN_BRINEPOOL_SHORE] = { "puffin", "seagull", "cormorant" }
		BIRD_TYPES[WORLD_TILES.OCEAN_HAZARDOUS]       = { "puffin", "seagull", "cormorant" }
	end)
end

-- Fix for blueprints without a recipe name. 
-- Credits: https://steamcommunity.com/sharedfiles/filedetails/?id=3252664875
AddGlobalClassPostConstruct("prefabs", "Prefab", function(self, name, fn, assets, deps, force_path_search)
    if (name == "blueprint") then
        local oldCanBlueprintRandomRecipe = nil

        i = 1
        while true do
            local n, v = GLOBAL.debug.getupvalue(self.fn, i)
            if not n then
                break
            elseif n == "CanBlueprintRandomRecipe" then
                oldCanBlueprintRandomRecipe = v
                break
            end
            i = i + 1
        end
        
        GLOBAL.debug.setupvalue(self.fn, i, function(recipe, ...)
            if GLOBAL.STRINGS.NAMES[string.upper(recipe.name)] == nil then
                return false
            end
            return oldCanBlueprintRandomRecipe(recipe, ...)
        end)
    end
end)

-- Lord of the Fruit Flies drops Garden Sprinkler blueprint.
AddPrefabPostInit("lordfruitfly", function(inst)
	if not _G.KnownModIndex:IsModEnabled("workshop-2334209327") then 
		_G.SetSharedLootTable("tap_lordfruitfly",
		{
			{"plantmeat", 1.00},
			{"kyno_garden_sprinkler_blueprint", 1.00},
		})
	
		if not _G.TheWorld.ismastersim then
			return inst
		end
	
		if inst.components.lootdropper ~= nil then
			inst.components.lootdropper:SetChanceLootTable("tap_lordfruitfly")
		end
	end
end)

-- From Island Adventures https://steamcommunity.com/sharedfiles/filedetails/?id=1467214795
-- Hope they don't smack and bonk my head...
local _FISHfn = ACTIONS.FISH.fn
function ACTIONS.FISH.fn(act, ...)
    if act.doer and act.doer.components.fishingrod then
        act.doer.components.fishingrod:StartFishing(act.target, act.doer)
        return true
    end
    return _FISHfn(act, ...)
end

local COMPONENT_ACTIONS = UpvalueHacker.GetUpvalue(EntityScript.CollectActions, "COMPONENT_ACTIONS")
local USEITEM = COMPONENT_ACTIONS.USEITEM
local EQUIPPED = COMPONENT_ACTIONS.EQUIPPED

local _USEITEMfishingrod = USEITEM.fishingrod
function USEITEM.fishingrod(inst, doer, target, actions, ...)
    if inst.replica.fishingrod:HasCaughtFish() then
        if doer.sg == nil or doer.sg:HasStateTag("fishing") then
            table.insert(actions, ACTIONS.REEL)
        end
    else
        return _USEITEMfishingrod(inst, doer, target, actions, ...)
    end
end

local _EQUIPPEDfishingrod = EQUIPPED.fishingrod
function EQUIPPED.fishingrod(inst, doer, target, actions, ...)
    if inst.replica.fishingrod:HasCaughtFish() then
        if doer.sg == nil or doer.sg:HasStateTag("fishing") then
            table.insert(actions, ACTIONS.REEL)
        end
    else
        return _EQUIPPEDfishingrod(inst, doer, target, actions, ...)
    end
end

local FishingRod = require("components/fishingrod")
function FishingRod:OnUpdate()
	if self:IsFishing() then
		if not self.fisherman:IsValid()
		or (not self.fisherman.sg:HasStateTag("fishing") and not self.fisherman.sg:HasStateTag("catchfish"))
		or (self.inst.components.equippable and not self.inst.components.equippable.isequipped) then
            self:StopFishing()
		end
	end
end

local CHARCOAL_SOURCES = {"log", "livinglog", "driftwood_log"}

local function MakeCharcoalSource(inst)
	inst:AddTag("burnablecharcoal")
end

for index, prefab in ipairs(CHARCOAL_SOURCES) do
	AddPrefabPostInit(prefab, MakeCharcoalSource)
end