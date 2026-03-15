local assets_baby =
{
	Asset("ANIM", "anim/doydoy.zip"),
	Asset("ANIM", "anim/doydoy_baby.zip"),
	Asset("ANIM", "anim/doydoy_baby_build.zip"),
	Asset("ANIM", "anim/doydoy_teen_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local assets =
{
	Asset("ANIM", "anim/doydoy.zip"),
	Asset("ANIM", "anim/doydoy_adult_build.zip"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs_baby =
{
	"goose_feather",
	"drumstick",
}

local prefabs =
{
	"goose_feather",
	"drumstick",
	"sap_doydoy_mate_fx",
}

local brain = require("brains/doydoybrain")

local babyloot = {"smallmeat","goose_feather"}
local teenloot = {"drumstick","goose_feather","goose_feather"}
local adultloot = {"meat", "drumstick", "drumstick", "goose_feather", "goose_feather"}

local babyfoodprefs = {"SEEDS"}
local teenfoodprefs = {"SEEDS", "VEGGIE"}
local adultfoodprefs = {"MEAT", "VEGGIE", "SEEDS", "ELEMENTAL", "WOOD"}

local babysounds = 
{
	eat_pre = "dontstarve_DLC002/creatures/baby_doy_doy/eat_pre",
	swallow = "dontstarve_DLC002/creatures/baby_doy_doy/swallow",
	hatch = "dontstarve_DLC002/creatures/baby_doy_doy/hatch",
	death = "dontstarve_DLC002/creatures/baby_doy_doy/death",
	jump = "dontstarve_DLC002/creatures/baby_doy_doy/jump",
	peck = "dontstarve_DLC002/creatures/teen_doy_doy/peck",
}

local teensounds = 
{
	idle = "dontstarve_DLC002/creatures/teen_doy_doy/idle",
	eat_pre = "dontstarve_DLC002/creatures/teen_doy_doy/eat_pre",
	swallow = "dontstarve_DLC002/creatures/teen_doy_doy/swallow",
	hatch = "dontstarve_DLC002/creatures/teen_doy_doy/hatch",
	death = "dontstarve_DLC002/creatures/teen_doy_doy/death",
	jump = "dontstarve_DLC002/creatures/baby_doy_doy/jump",
	peck = "dontstarve_DLC002/creatures/teen_doy_doy/peck",
}

local DOYDOY_BABY_GROW_TIME = 960
local DOYDOY_TEEN_GROW_TIME = 480

local function SetBaby(inst)
	inst.AnimState:SetScale(1, 1, 1)

	inst.AnimState:SetBank("doydoy_baby")
	inst.AnimState:SetBuild("doydoy_baby_build")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("baby")
	inst:RemoveTag("teen")

	inst.sounds = babysounds
	inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/baby_doy_doy/hit")

	inst.components.health:SetMaxHealth(25)
	inst.components.locomotor.walkspeed = 5
	inst.components.locomotor.runspeed = 5
	inst.components.lootdropper:SetLoot(babyloot)
	-- inst.components.eater.foodprefs = babyfoodprefs

	inst.components.inventoryitem:ChangeImageName("sap_doydoy_baby")
end

local function SetTeen(inst)
	inst.AnimState:SetScale(0.8, 0.8, 0.8)

	inst.AnimState:SetBank("doydoy")
	inst.AnimState:SetBuild("doydoy_teen_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("teen")
	inst:RemoveTag("baby")

	inst.sounds = teensounds
	inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/doy_doy/hit")

	inst.components.health:SetMaxHealth(75)
	inst.components.locomotor.walkspeed = 1.7
	inst.components.locomotor.runspeed = 1.7
	inst.components.lootdropper:SetLoot(teenloot)
	-- inst.components.eater.foodprefs = teenfoodprefs

	inst.components.inventoryitem:ChangeImageName("sap_doydoy_teen")
	inst.components.named:SetName("Teen Doydoy")
end

local function SetFullyGrown(inst)
	inst.needtogrowup = true
end

local function GetBabyGrowTime()
	return DOYDOY_BABY_GROW_TIME
end

local function GetTeenGrowTime()
	return DOYDOY_TEEN_GROW_TIME
end

local growth_stages =
{
	{name = "baby",  time = GetBabyGrowTime, fn = SetBaby},
	{name = "teen",  time = GetTeenGrowTime, fn = SetTeen},
	{name = "grown", time = GetTeenGrowTime, fn = SetFullyGrown},
}

local function OnEntitySleep(inst)
	if inst.shouldGoAway then
		inst:Remove()
	end
end

local function OnGrowUp(inst)
	if not inst:IsValid() then return end
	
	local grown = SpawnPrefab("sap_doydoy")

	local owner = inst.components.inventoryitem ~= nil and inst.components.inventoryitem.owner or nil
	local holder = owner ~= nil and (owner.components.inventory or owner.components.container) or nil
	if holder ~= nil then
		local slot = holder:GetItemSlot(inst)
		inst:Remove()
		holder:GiveItem(grown, slot)
	else
		local x, y, z = inst.Transform:GetWorldPosition()
		local rot = inst.Transform:GetRotation()
		inst:Remove()
		grown.Transform:SetPosition(x, y, z)
		grown.Transform:SetRotation(rot)
	end
end

local function OnEntityWake(inst)
	inst:ClearBufferedAction()
	if inst.needtogrowup then
		inst:DoTaskInTime(0, OnGrowUp)
	end
end

local function CanEatFn(inst, food)
	return food.prefab ~= "sap_doydoyegg" and food.prefab ~= "sap_doydoyegg_cooked"
end

local function OnInventory(inst)
	inst:ClearBufferedAction()
	inst:AddTag("mating")
end

local function OnDropped(inst)
	inst.components.sleeper:GoToSleep()
	inst:AddTag("mating")
end

local function OnDeath(inst, data) 
	local owner = inst.components.inventoryitem:GetGrandOwner()

	if inst.components.lootdropper and owner then
		local loots = inst.components.lootdropper:GenerateLoot()
		inst:Remove()
		
		for k, v in pairs(loots) do
			local loot = SpawnPrefab(v)
			owner.components.inventory:GiveItem(loot)
		end
	end
end

local function OnSleep(inst)
	inst.components.inventoryitem.canbepickedup = true
end

local function OnWakeUp(inst) 
	inst.components.inventoryitem.canbepickedup = false
	inst:RemoveTag("mating")
end

local function OnMate(inst, partner)
end

local function babyfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, 0.8)
	
	MakeCharacterPhysics(inst, 50, .5)
	inst.Transform:SetFourFaced()

	inst.AnimState:SetBank("doydoy_baby")
	inst.AnimState:SetBuild("doydoy_baby_build")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("baby")
	inst:AddTag("doydoy")
	inst:AddTag("companion")
	inst:AddTag("animal")
	
	MakeFeedableSmallLivestockPristine(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
	end
	
	inst.sounds = babysounds
	
	inst:AddComponent("inspectable")
	inst:AddComponent("sizetweener")
	inst:AddComponent("sleeper")
	inst:AddComponent("named")
	inst:AddComponent("inventory")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 5
	inst.components.locomotor.runspeed = 5
	
	inst:SetBrain(brain)
	inst:SetStateGraph("SGdoydoybaby")
	
	-- inst:AddComponent("eater")
    -- inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
    -- inst.components.eater:SetCanEatHorrible()
    -- inst.components.eater:SetCanEatRaw()
	-- inst.components.eater:SetCanEatGears()
    -- inst.components.eater.strongstomach = true
	-- inst.components.eater.foodprefs = babyfoodprefs
	
	inst:AddComponent("combat")
	inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/baby_doy_doy/hit")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(25)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot(babyloot)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	inst.components.inventoryitem:ChangeImageName("sap_doydoy_baby")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.longpickup = true

	inst:AddComponent("growable")
	inst.components.growable.stages = growth_stages
	inst.components.growable:SetStage(1)
	inst.components.growable.growoffscreen = true
	inst.components.growable:StartGrowing()
	
	inst:ListenForEvent("entitysleep", OnEntitySleep)
	inst:ListenForEvent("entitywake", OnEntityWake)
	inst:ListenForEvent("gotosleep", OnSleep)
    inst:ListenForEvent("onwakeup", OnWakeUp)
	inst:ListenForEvent("death", OnDeath)
	
	MakeSmallBurnableCharacter(inst, "swap_fire")
	MakeSmallFreezableCharacter(inst, "mossling_body")
	MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME, OnInventory, OnDropped)

	return inst
end

local function adultfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLightWatcher()
    inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, 0.8)
	
	MakeCharacterPhysics(inst, 50, .5)
	inst.Transform:SetFourFaced()

	inst.AnimState:SetBank("doydoy")
	inst.AnimState:SetBuild("doydoy_adult_build")
	inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("doydoy")
	inst:AddTag("companion")
	inst:AddTag("animal")
	
	MakeFeedableSmallLivestockPristine(inst)
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
        return inst
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("sizetweener")
	inst:AddComponent("sleeper")
	inst:AddComponent("named")
	inst:AddComponent("inventory")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.walkspeed = 1.7
	inst.components.locomotor.runspeed = 1.7
	
	inst:SetBrain(brain)
	inst:SetStateGraph("SGdoydoy")
	
	-- inst:AddComponent("eater")
    -- inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
    -- inst.components.eater:SetCanEatHorrible()
    -- inst.components.eater:SetCanEatRaw()
	-- inst.components.eater:SetCanEatGears()
    -- inst.components.eater.strongstomach = true
	-- inst.components.eater.foodprefs = adultfoodprefs
	
	inst:AddComponent("combat")
	inst.components.combat:SetHurtSound("dontstarve_DLC002/creatures/doy_doy/hit")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(100)
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot(adultloot)
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	inst.components.inventoryitem:ChangeImageName("sap_doydoy")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem.canbepickedup = false
	inst.components.inventoryitem.longpickup = true
	
	inst:ListenForEvent("entitysleep", OnEntitySleep)
	inst:ListenForEvent("entitywake", OnEntityWake)
	inst:ListenForEvent("gotosleep", OnSleep)
    inst:ListenForEvent("onwakeup", OnWakeUp)
	inst:ListenForEvent("death", OnDeath)
	
	MakeSmallBurnableCharacter(inst, "swap_fire")
	MakeSmallFreezableCharacter(inst, "mossling_body")
	MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME, OnInventory, OnDropped)

	return inst
end

return Prefab("sap_doydoy_baby", babyfn, assets_baby, prefabs_baby),
Prefab("sap_doydoy", adultfn, assets, prefabs)