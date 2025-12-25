local brain = require("brains/chickenbrain")

local assets =
{
	Asset("ANIM", "anim/chicken.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs =
{
	"drumstick",
	"drumstick_cooked",
	"bird_egg",
	"goose_feather",
}

local chickensounds = 
{
	scream = "dontstarve_DLC001/creatures/buzzard/hurt",
	hurt = "dontstarve_DLC001/creatures/buzzard/hurt",
}

SetSharedLootTable("kyno_chicken",
{
    {"drumstick",             1.00},
	{"goose_feather",         1.00},
	{"goose_feather",         0.50},
})

local function SetHome(inst)
	inst.components.knownlocations:RememberLocation("home", inst:GetPosition())
end

local function SetNewHome(inst)
	inst.components.knownlocations:ForgetLocation("home")
	inst:DoTaskInTime(1, SetHome) -- Set home again.
end

local function OnStartDay(inst)
    if inst.components.combat:HasTarget() ~= nil then
    	inst.components.combat:SetTarget(nil)
    end
end

local function CanShareTarget(dude)
    return not dude:IsInLimbo() and not dude.components.health:IsDead()
end

local function CanSleep(inst)
	return DefaultSleepTest(inst)
end

local function onbuilt(inst)
	SpawnPrefab("kyno_chicken").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function builderfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddPhysics()
	inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1, 0.75)
	
	inst.Transform:SetFourFaced()
	MakeCharacterPhysics(inst, 100, .5)

	inst.AnimState:SetBank("chicken")
	inst.AnimState:SetBuild("chicken")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("chickenfamily")
	inst:AddTag("animal")
	inst:AddTag("prey")
	inst:AddTag("chicken")
	inst:AddTag("smallcreature")
	
	inst:SetPrefabNameOverride("kyno_chicken")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("knownlocations")
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	inst:AddComponent("embarker")
	
	inst:AddComponent("sleeper")
	inst.components.sleeper:SetSleepTest(CanSleep)

	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = TUNING.RABBIT_RUN_SPEED
	inst.components.locomotor:SetAllowPlatformHopping(true)

	inst:SetBrain(brain)
	inst:SetStateGraph("SGchicken")

	inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.SEEDS }, { FOODTYPE.SEEDS })
    inst.components.eater:SetCanEatRaw()

	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "chest"

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(130)
	inst.components.health:StartRegen(5, 8)
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = 
	{ 
		"Drumstick", "Daisy", "Cah", "Noodle", "Potato",
		"Curry", "Dinner", "Garibalda", "Marta", "Marina",
		"Carrot", "Emilha", "Pintadinha", "Galinha", "Pipoca",
		"Ruiva", "Canjica", "Magricela", "Isolda", "Pedrita",
		"Isadora", "Ruivinha", "Karen", "Penosa", "Bicuda",
		"Mel", "Sol", "Lua", "Outono", "Milharina",
		"Clementina", "Rejane", "Morena", "Flor", "Girasol",
	}
    inst.components.named:PickNewName()	

	inst.sounds = chickensounds
	MakeSmallBurnableCharacter(inst, "body")
	MakeTinyFreezableCharacter(inst, "chest")
	
	inst:ListenForEvent("onbuilt", onbuilt)
	inst:WatchWorldState("startcaveday", OnStartDay)

	return inst
end

local function fn()
	local inst = builderfn()
	
	inst:SetPrefabNameOverride("kyno_chicken")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:DoTaskInTime(0, SetHome)
	
	inst.components.lootdropper:SetChanceLootTable("kyno_chicken")
	
	return inst
end

return Prefab("kyno_chicken_builder", builderfn, assets, prefabs),
Prefab("kyno_chicken", fn, assets, prefabs),
MakePlacer("kyno_chicken_builder_placer", "chicken", "chicken", "idle")
