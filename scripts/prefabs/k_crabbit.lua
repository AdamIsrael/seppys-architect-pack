local assets =
{
	Asset("ANIM", "anim/crabbit_build.zip"),
	Asset("ANIM", "anim/crabbit_beardling_build.zip"),
	Asset("ANIM", "anim/beardling_crabbit.zip"),
	Asset("ANIM", "anim/crabbit.zip"),
}

local prefabs =
{
	"fishmeat_small",
}

local crabbitsounds = 
{
    scream = "dontstarve_DLC002/creatures/crab/scream",
    hurt = "dontstarve_DLC002/creatures/crab/scream_short",
}

local beardsounds = 
{
    scream = "dontstarve_DLC002/creatures/crab/bearded_crab",
    hurt = "dontstarve_DLC002/creatures/crab/scream_short",
}

local brain = require "brains/crabbrain"

local crabbitloot = { "fishmeat_small" }

local function IsCrazyGuy(guy)
    local sanity = guy ~= nil and guy.replica.sanity or nil
    return sanity ~= nil and sanity:IsInsanityMode() and sanity:GetPercentNetworked() <= (guy:HasTag("dappereffects") and TUNING.DAPPER_BEARDLING_SANITY or TUNING.BEARDLING_SANITY)
end

local function SetCrabbitLoot(lootdropper)
    if lootdropper.loot ~= crabbitloot and not lootdropper.inst._fixedloot then
        lootdropper:SetLoot(crabbitloot)
    end
end

local function SetBeardlingLoot(lootdropper)
    if lootdropper.loot == crabbitloot and not lootdropper.inst._fixedloot then
        lootdropper:SetLoot(nil)
        lootdropper:AddRandomLoot("beardhair", .5)
        lootdropper:AddRandomLoot("monstermeat", 1)
        lootdropper:AddRandomLoot("nightmarefuel", 1)
        lootdropper.numrandomloot = 1
    end
end

local function BecomeCrabbit(inst)
    if inst.components.health:IsDead() then
        return
    end
    inst.AnimState:SetBuild("crabbit_build")
    inst.sounds = crabbitsounds
    if inst.components.hauntable ~= nil then
        inst.components.hauntable.haunted = false
    end
	inst.components.inventoryitem:ChangeImageName("sap_crabbit")
end

local function CalcSanityAura(inst, observer)
    return IsCrazyGuy(observer) and -TUNING.SANITYAURA_MED or 0
end

local function GetCookProductFn(inst, cooker, chef)
    return IsCrazyGuy(chef) and "fishmeat_small" or "fishmeat_small_cooked"
end

local function OnCookedFn(inst, cooker, chef)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/crab/scream_short")
end

local function LootSetupFunction(lootdropper)
    local guy = lootdropper.inst.causeofdeath
    if IsCrazyGuy(guy ~= nil and guy.components.follower ~= nil and guy.components.follower.leader or guy) then
        SetBeardlingLoot(lootdropper)
    else
        SetCrabbitLoot(lootdropper)
    end
end

local CRABBIT_MUST_TAGS = { "crabbit" }
local CRABBIT_CANT_TAGS = { "INLIMBO" }
local function OnAttacked(inst, data)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 30, CRABBIT_MUST_TAGS, CRABBIT_CANT_TAGS)
    local maxnum = 5
    for i, v in ipairs(ents) do
        v:PushEvent("gohome")
        if i >= maxnum then
            break
        end
    end
end

local function OnDropped(inst)
    inst.sg:GoToState("stunned")
end

local function getmurdersound(inst, doer)
    return IsCrazyGuy(doer) and beardsounds.hurt or inst.sounds.hurt
end

local function drawimageoverride(inst, viewer)
    return IsCrazyGuy(viewer) and "crabbit_beardling"
end

local function OnWake(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
	BecomeCrabbit(inst)
end

local function OnSleep(inst)
    if inst.task ~= nil then
        inst.task:Cancel()
        inst.task = nil
    end
end

local function OnInit(inst)
    inst.OnEntityWake = OnWake
    inst.OnEntitySleep = OnSleep
    if inst.entity:IsAwake() then
        OnWake(inst)
    end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
	MakeCharacterPhysics(inst, 1, 0.5)
	inst.DynamicShadow:SetSize(1.5, .5)

	inst.AnimState:SetBank("crabbit")
	inst.AnimState:SetBuild("crabbit_build")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("animal")
    inst:AddTag("prey")
    inst:AddTag("crabbit")
    inst:AddTag("smallcreature")
    inst:AddTag("canbetrapped")
    inst:AddTag("cattoy")
    inst:AddTag("catfood")
    inst:AddTag("stunnedbybomb")
	inst:AddTag("cookable")

    inst.AnimState:SetClientsideBuildOverride("insane", "crabbit_build", "beardling_crabbit")
    inst:SetClientSideInventoryImageOverride("insane", "kyno_crabbit.tex", "kyno_crabbit_beardling.tex")

    MakeFeedableSmallLivestockPristine(inst)
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
        return inst
	end

	inst:AddComponent("knownlocations")
	inst:AddComponent("inspectable")
	inst:AddComponent("tradable")

	inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
	inst.components.locomotor.runspeed = 5
	inst.components.locomotor.walkspeed = 1.5

	inst:SetBrain(brain)
	inst:SetStateGraph("SGcrab")

	inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODGROUP.OMNI })
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true
    inst.components.inventoryitem:SetSinks(true)

	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(50)
	inst.components.health.murdersound = "dontstarve_DLC002/creatures/crab/scream_short"

	inst:AddComponent("combat")
	inst.components.combat.hiteffectsymbol = "chest"

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLootSetupFn(LootSetupFunction)
    LootSetupFunction(inst.components.lootdropper)
	
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("cookable")
    inst.components.cookable.product = GetCookProductFn
    inst.components.cookable:SetOnCookedFn(OnCookedFn)

	inst:AddComponent("sleeper")
    inst.components.sleeper.watchlight = true

	inst.sounds = nil
    inst.task = nil
	inst:DoTaskInTime(0, OnInit)
    BecomeCrabbit(inst)

    inst:ListenForEvent("attacked", OnAttacked)
    inst.drawimageoverride = drawimageoverride
	
	MakeHauntablePanic(inst)
	MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME, nil, OnDropped)
	MakeSmallBurnableCharacter(inst, "chest")
	MakeTinyFreezableCharacter(inst, "chest")

	return inst
end

return Prefab("sap_crabbit", fn, assets, prefabs)