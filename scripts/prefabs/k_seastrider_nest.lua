require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/oceanvine_cocoon.zip"),
}

local prefabs =
{
    "character_fire",
    "oceanvine_cocoon_burnt",
    "silk",
    "spider_water",
    "twigs",
}

local burnt_prefabs =
{
    "ash",
    "character_fire",
    "charcoal",
}

local function OnPreHit(inst)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_hit")
end

local function OnIgnite(inst, source, doer)
    if inst:GetTimeAlive() > 5 then
        local children_released = inst.components.childspawner:ReleaseAllChildren()
        for _, child in ipairs(children_released) do
            child.sg:GoToState("dropper_enter")
        end
    end
	
    inst.components.childspawner:StopSpawning()
    inst.components.timer:PauseTimer("lookforfish")
end

local function OnBurnt(inst)
    local ix, iy, iz = inst.Transform:GetWorldPosition()

    if inst._firefx ~= nil then
        inst._firefx:Remove()
    end

    inst:Remove()
end

local function CocoonBurnt(inst)
    inst:AddTag("burnt")
    inst:AddTag("notarget")

    inst.components.burnable.canlight = false
    inst.AnimState:PlayAnimation("burnt_pre")
    inst:PushEvent("burntup")

    if inst.MiniMapEntity then
        inst.MiniMapEntity:SetEnabled(false)
    end

    inst._firefx = SpawnPrefab("character_fire")
    inst._firefx.entity:AddFollower()
    inst._firefx.Follower:FollowSymbol(inst.GUID, "swap_fire", 0, 0, 0)
    inst._firefx.persists = false
    if inst._firefx.components.firefx ~= nil then
        inst._firefx.components.firefx:SetLevel(5, true)
        inst._firefx.components.firefx:AttachLightTo(inst)
    end

    inst:ListenForEvent("animover", OnBurnt)
end

local function OnExtinguish(inst)
    inst.components.childspawner:StartSpawning()
    inst.components.timer:ResumeTimer("lookforfish")
end

local function SpawnInvestigator(inst, target_position)
    local spider = inst.components.childspawner:SpawnChild(nil, nil, 4)
    if spider ~= nil then
        spider.sg:GoToState("dropper_enter")
        spider.components.timer:StartTimer("investigating", TUNING.SPIDER_WATER_INVESTIGATETIMEBASE + 5*math.random())

        if target_position ~= nil then
            spider.components.knownlocations:RememberLocation("investigate", target_position)
        end
    end
end

local function SpawnInvestigators(inst, data)
    if inst.components.childspawner == nil or inst.components.freezable:IsFrozen() then
        return
    end

    OnPreHit(inst)

    local target_position = nil

    local num_to_release = math.min(2, inst.components.childspawner.childreninside)
    for i = 1, num_to_release do
        target_position = target_position or (data and data.target and data.target:GetPosition()) or nil
        inst:DoTaskInTime((i-1)*math.random() + (30*FRAMES), SpawnInvestigator, target_position)
    end
end

local SEE_FISH_DISTANCE = 10
local OCEANFISH_TAGS = {"oceanfish"}
local function LookForFish(inst)
    local look_time = math.random()*TUNING.SEG_TIME
    if inst.components.childspawner.childreninside > 0 then
        local a_fish = FindEntity(inst, SEE_FISH_DISTANCE,
            function(fish)
                return TheWorld.Map:IsOceanAtPoint(fish.Transform:GetWorldPosition())
            end,
            OCEANFISH_TAGS)
        if a_fish ~= nil then
            local spider = inst.components.childspawner:SpawnChild(nil, nil, 4)
            if spider ~= nil then
                spider.components.knownlocations:RememberLocation("investigate", a_fish:GetPosition())
                spider.sg:GoToState("dropper_enter")
                look_time = (2 + 2*math.random()) * TUNING.SEG_TIME
            end
        end
    end

    inst.components.timer:StartTimer("lookforfish", look_time)
end

local function OnFreeze(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")
    inst.AnimState:PlayAnimation("frozen", true)
    inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")

    inst.components.childspawner:StopSpawning()
end

local function OnThaw(inst)
    inst.AnimState:PlayAnimation("frozen_pst", true)
    inst.SoundEmitter:PlaySound("dontstarve/common/freezethaw", "thawing")
    inst.AnimState:OverrideSymbol("swap_frozen", "frozen", "frozen")
end

local function OnUnFreeze(inst)
    inst.AnimState:PlayAnimation("idle", true)
    inst.SoundEmitter:KillSound("thawing")
    inst.AnimState:ClearOverrideSymbol("swap_frozen")

    inst.components.childspawner:StartSpawning()
end

local function OnHit(inst, attacker)
    if not inst.components.health:IsDead() then
        SpawnInvestigators(inst, {target = attacker})

        OnPreHit(inst)
    end
end

local COCOON_HOME_TAGS = { "cocoon_home" }
local function OnKilled(inst)
    inst.AnimState:PlayAnimation("death")

    if inst.components.childspawner ~= nil then
        inst.components.childspawner:ReleaseAllChildren()
    end

    RemovePhysicsColliders(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_destroy")

    local c_pos = inst:GetPosition()
    inst.components.lootdropper:DropLoot(c_pos)
end

local function OnTimerDone(inst, data)
    if data.name == "lookforfish" then
        LookForFish(inst)
    end
end

local function SpiderReturned(inst, data)
    if not inst.components.freezable:IsFrozen() then
        OnPreHit(inst)
    end
end

local function OnSave(inst, data)
    data.burnt = inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or nil
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt then
        CocoonBurnt(inst)
    end
end

local function SummonChildren(inst)
    if not inst.components.health:IsDead() and not (inst.components.freezable ~= nil and inst.components.freezable:IsFrozen()) then
		OnPreHit(inst)
        if inst.components.childspawner ~= nil then
            local children_released = inst.components.childspawner:ReleaseAllChildren()
            if children_released then
                for _, v in ipairs(children_released) do
                    v:AddDebuff("spider_summoned_buff", "spider_summoned_buff")
                    v.sg:GoToState("dropper_enter")
                end
            end
        end
    end
end

local ZERO_VECTOR = Vector3(0,0,0)
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeTinyFlyingCharacterPhysics(inst, 1, 0.25)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("oceanvine_cocoon.png")
    
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(3.5, 2.0)

    inst.AnimState:SetBank("ocean_cocoon")
    inst.AnimState:SetBuild("oceanvine_cocoon")
    inst.AnimState:PlayAnimation("idle", true)

    inst.AnimState:SetMultColour(0.75, 0.1, 1.0, 1)

    inst:AddTag("flying")
    inst:AddTag("ignorewalkableplatform")
    inst:AddTag("NOBLOCK")
    inst:AddTag("plant")
    inst:AddTag("spidercocoon")
    inst:AddTag("webbed")

    if not TheNet:IsDedicated() then
        inst:AddComponent("distancefade")
        inst.components.distancefade:Setup(15, 25)
    end

    MakeSnowCoveredPristine(inst)
	inst:SetPrefabNameOverride("oceanvine_cocoon")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * inst.AnimState:GetCurrentAnimationLength())
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "OCEANVINE_COCOON"

    inst:AddComponent("burnable")
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetBurnTime(15)
    inst.components.burnable:AddBurnFX("character_fire", ZERO_VECTOR, "swap_fire", true)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)
    inst.components.burnable:SetOnBurntFn(CocoonBurnt)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguish)

    inst:AddComponent("childspawner")
    inst.components.childspawner:SetRegenPeriod(TUNING.OCEANVINE_COCOON_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.OCEANVINE_COCOON_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(math.random(TUNING.OCEANVINE_COCOON_MIN_CHILDREN, TUNING.OCEANVINE_COCOON_MAX_CHILDREN))
    
	if not TUNING.OCEANVINE_ENABLED then
        inst.components.childspawner.childreninside = 0
    end
	
    inst.components.childspawner:StartRegen()
    inst.components.childspawner:SetGoHomeFn(SpiderReturned)
    inst.components.childspawner.childname = "spider_water"
    inst.components.childspawner.emergencychildname = "spider_water"
    inst.components.childspawner.emergencychildrenperplayer = 1
    inst.components.childspawner.canemergencyspawn = TUNING.OCEANVINE_ENABLED
    inst.components.childspawner.allowwater = true
    inst.components.childspawner.allowboats = true

    inst:AddComponent("timer")
    inst.components.timer:StartTimer("lookforfish", 2 * math.random() * TUNING.SEG_TIME)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(200)

    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(OnHit)

    MakeSnowCovered(inst)
	MakeMediumPropagator(inst)
    MakeMediumFreezableCharacter(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
    inst.SummonChildren = SummonChildren 

    inst:ListenForEvent("death", OnKilled)
    inst:ListenForEvent("activated", SpawnInvestigators)
    inst:ListenForEvent("timerdone", OnTimerDone)
	inst:ListenForEvent("freeze", OnFreeze)
    inst:ListenForEvent("onthaw", OnThaw)
    inst:ListenForEvent("unfreeze", OnUnFreeze)

    return inst
end

return Prefab("sap_seastrider_nest", fn, assets, prefabs),
Prefab("sap_seastrider_nest_water", fn, assets, prefabs),
MakePlacer("sap_seastrider_nest_placer", "ocean_cocoon", "oceanvine_cocoon", "idle"),
MakePlacer("sap_seastrider_nest_water_placer", "ocean_cocoon", "oceanvine_cocoon", "idle")
