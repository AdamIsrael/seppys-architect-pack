require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),

    Asset("ANIM", "anim/ro_bin.zip"),
    Asset("ANIM", "anim/ro_bin_water.zip"),
    Asset("ANIM", "anim/ro_bin_build.zip"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "ro_bin_gizzard_stone",
}

local brain = require "brains/chesterbrain"

local WAKE_TO_FOLLOW_DISTANCE = 14
local SLEEP_NEAR_LEADER_DISTANCE = 7

local function OnAttacked(inst, data)
inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/ro_bin/hit")
end

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE)
end

local function ShouldSleep(inst)
    return DefaultSleepTest(inst) and not inst.sg:HasStateTag("open") 
    and inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE) 
    and not TheWorld.state.isfullmoon
end

local function ShouldKeepTarget(ifnst, target)
    return false 
end

local function OnOpen(inst)
    if not inst.components.health:IsDead() then
        inst.sg:GoToState("open")
    end
end 

local function OnClose(inst) 
    if not inst.components.health:IsDead() then
        inst.sg:GoToState("close")
    end
end 

local function OnStopFollowing(inst) 
    inst:RemoveTag("companion") 
end

local function OnStartFollowing(inst) 
    inst:AddTag("companion") 
end

local function OnSave(inst, data)
    data.ChesterState = inst.ChesterState
end

local function OnPreLoad(inst, data)
    if not data then return end
end

local function OnEntityWake(inst)   
end

local function OnEntitySleep(inst)
end

local function OnHaunt(inst)
    if math.random() <= TUNING.HAUNT_CHANCE_ALWAYS then
        inst.components.hauntable.panic = true
        inst.components.hauntable.panictimer = TUNING.HAUNT_PANIC_TIME_SMALL
        inst.components.hauntable.hauntvalue = TUNING.HAUNT_SMALL
        return true
    end
    return false
end

local function create_ro_bin()
    local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	inst.MiniMapEntity:SetIcon("kyno_ro_bin.tex")
	
	inst.DynamicShadow:SetSize(2, 1.5)
	inst.Transform:SetFourFaced()
	
	MakeCharacterPhysics(inst, 75, .5)
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)

    inst.entity:AddAnimState()
    inst.AnimState:SetBank("ro_bin")
    inst.AnimState:SetBuild("ro_bin_build")
    inst.Transform:SetScale(.9, .9, .9)
	
	inst:AddTag("companion")
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("ro_bin")
    inst:AddTag("notraptrigger")
	inst:AddTag("noauradamage")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("shadowchester") end
        return inst
    end

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "chester_body"
    inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.CHESTER_HEALTH)
    inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)

    inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 5
    inst.components.locomotor.runspeed = 7
    inst.components.locomotor:SetAllowPlatformHopping(true)

    inst:AddComponent("embarker")
	inst:AddComponent("knownlocations")

    inst:AddComponent("follower")
    inst:ListenForEvent("stopfollowing", OnStopFollowing)
    inst:ListenForEvent("startfollowing", OnStartFollowing)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("shadowchester")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:SetStateGraph("SGRo_Bin")
    inst.sg:GoToState("idle")

	MakeMediumBurnableCharacter(inst, "robin_body")

    inst:SetBrain(brain)
    inst.ChesterState = "NORMAL"

    inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad

	inst:DoPeriodicTask(5 + math.random(), function(inst)
        -- We somehow got a ro bin without a gizzard stone. Kill it! Kill it with fire!
        if not TheSim:FindFirstEntityWithTag("ro_bin_gizzard_stone") then
            	inst:Remove()
        end
    end)

    inst.OnEntityWake = OnEntityWake
    inst.OnEntitySleep = OnEntitySleep
    inst:ListenForEvent("attacked", OnAttacked)

    return inst
end

return Prefab("ro_bin", create_ro_bin, assets, prefabs) 