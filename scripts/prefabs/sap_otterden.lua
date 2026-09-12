require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/otter_den.zip"),
}

local prefabs =
{
    "collapse_big",
	"collapse_small",
    "otter",
    "otterden_dead",
}

local POSSIBLE_LOOT_ITEMS = 
{
    barnacle          = 1,
    boatpatch_kelp    = 1,
    bullkelp_root     = 1,
    driftwood_log     = 1,
    fishmeat          = 2,
    fishmeat_small    = 2,
    kelp              = 2,
    monstermeat       = 2,
    meat              = 2,
    smallmeat         = 2,
}

for loot_item in pairs(POSSIBLE_LOOT_ITEMS) do
    table.insert(prefabs, loot_item)
end

local SLEEP_TIMER_NAME = "push_sleep_anim"

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("sap_otterden_dead").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function OnHammeredDestroyed(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function spawn_child_and_do_aggro(inst, aggro_target)
    inst._force_spawn = true
    inst.components.childspawner:SpawnChild(aggro_target)
    inst._force_spawn = nil
end

local function try_generate_loot_item(inst)
    local inventory = inst.components.inventory
    if inventory:IsFull() then
        local valid_options = nil
		
        inventory:ForEachItem(function(item, options)
            if POSSIBLE_LOOT_ITEMS[item.prefab] and item.components.stackable then
                options = options or {}
                table.insert(options, item)
            end
        end, valid_options)
		
        if valid_options then
            local item = valid_options[math.random(#valid_options)]
            local item_stackable = item.components.stackable
            if not item_stackable:IsFull() then
                item_stackable:SetStackSize(item_stackable:StackSize() + 1)
                return true
            end
        end
    else
        local item_to_spawn = weighted_random_choice(POSSIBLE_LOOT_ITEMS)
        inventory:GiveItem(SpawnPrefab(item_to_spawn))
		
        return true
    end

    return false
end

local function OnGoHome(inst, child)
    inst.SoundEmitter:PlaySound("meta4/otter_den/enter")
	
    if not inst.components.inventory:IsFull() then
        child.components.inventory:TransferInventory(inst)
    else
        child.components.inventory:DropEverything()
    end

    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
end

local function change_otter_sleeping_inside_state(inst, new_state)
    if new_state == inst._is_sleeping_inside then return end

    inst._is_sleeping_inside = new_state
    if new_state then
        inst.components.timer:ResumeTimer(SLEEP_TIMER_NAME)
        inst.SoundEmitter:PlaySound("dontstarve/pig/pig_in_hut", "ottersound")
    else
        inst.components.timer:PauseTimer(SLEEP_TIMER_NAME)
        inst.SoundEmitter:KillSound("ottersound")
    end
end

local function OnSpawned(inst, child)
    inst.SoundEmitter:PlaySound("meta4/otter_den/enter")
end

local function OnOccupied(inst)
    change_otter_sleeping_inside_state(inst, true)
end

local function OnVacate(inst)
    change_otter_sleeping_inside_state(inst, false)
end

local function CanSpawn(inst)
    return inst._force_spawn or not (TheWorld.state.iscavenight or TheWorld.state.iswinter)
end

local function OnHit(inst, attacker)
    if inst.components.health:IsDead() then return end

    spawn_child_and_do_aggro(inst, attacker)

    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)

    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spiderLair_hit")
end

local function GetDenStatus(inst, viewer)
    return (inst.components.inventory:GetFirstItemInAnySlot() == nil and "GENERIC") or "HAS_LOOT"
end

local function OnSearched(inst, searcher)
    spawn_child_and_do_aggro(inst, searcher)

    local searched_item = inst.components.inventory:GetFirstItemInAnySlot()
    if not searched_item then
        return false, "NOTHING_INSIDE"
    end

    searched_item = (searched_item.components.stackable ~= nil and searched_item.components.stackable:Get())
        or searched_item
    if searcher.components.inventory then
        searcher.components.inventory:GiveItem(searched_item)
    else
        inst.components.inventory:DropItem(searched_item)
    end

    local half_inventory_count = math.floor(0.5 * inst.components.inventory.maxslots)
    if inst.components.inventory:NumStackedItems() <= half_inventory_count and inst._pile2_showing then
        inst.AnimState:Hide("pile2")
        inst._pile2_showing = nil
    end

    if not inst.components.inventory:GetFirstItemInAnySlot() then
        inst.components.searchable.canbesearched = false
        if inst._pile1_showing then
            inst.AnimState:Hide("pile1")
            inst._pile1_showing = nil
        end
    end

    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)

    return true
end

local function OnIgnited(inst, source, doer)
    local childspawner = inst.components.childspawner
    for child in pairs(childspawner.childrenoutside) do
        if child.components.combat then
            child.components.combat:SuggestTarget(doer or source)
        end
    end
    childspawner:ReleaseAllChildren(doer or source)

    DefaultBurnFn(inst, source, doer)
end

local function OnKilled(inst, data)
    RemovePhysicsColliders(inst)

    inst.components.childspawner:ReleaseAllChildren((data and data.afflicter) or nil)

    local ipos = inst:GetPosition()
    inst.components.lootdropper:DropLoot(ipos)

    local dead_den = SpawnPrefab("sap_otterden_dead")
	dead_den.Transform:SetPosition(ipos:Get())

    inst:Remove()
end

local function OnItemGet(inst, data)
    local inventory = inst.components.inventory

    inst.components.searchable.canbesearched = (data ~= nil and data.item ~= nil and inventory:GetFirstItemInAnySlot() ~= nil)

    local half_inventory_count = math.floor(0.5 * inventory.maxslots)
    local num_stacked_items = inventory:NumStackedItems()
    if num_stacked_items > half_inventory_count then
        if not inst._pile1_showing then
            inst.AnimState:Show("pile1")
            inst._pile1_showing = true
        end
        if not inst._pile2_showing then
            inst.AnimState:Show("pile2")
            inst._pile2_showing = true
        end
    elseif inventory:NumStackedItems() == 1 then
        inst.AnimState:Show("pile1")
        inst._pile1_showing = true
    end
end

local function OnMoved(inst, mover)
    local childspawner = inst.components.childspawner
    for child in pairs(childspawner.childrenoutside) do
        if child.components.combat then
            child.components.combat:SuggestTarget(mover)
        end
    end
end

local function OnIsNightChanged(inst, isnight)
    if not isnight then
        inst.components.childspawner:StartSpawning()
    else
        inst.components.childspawner:StopSpawning()
    end
end

local SLEEPING_LOOT_TIME = (TUNING.AUTUMN_LENGTH * TUNING.TOTAL_DAY_TIME) / (2 * TUNING.OTTERDEN_INVENTORY_SLOTS)
local SLEEPING_LOOT_NAME = "entitysleep_generate_loot"

local function IsWinter_UpdateLootGeneration(inst, iswinter)
    local timer = inst.components.timer
	
    if iswinter and timer:TimerExists(SLEEPING_LOOT_NAME) then
        timer:StopTimer(SLEEPING_LOOT_NAME)
    elseif not iswinter and not timer:TimerExists(SLEEPING_LOOT_NAME) then
        timer:StartTimer(SLEEPING_LOOT_NAME, SLEEPING_LOOT_TIME)
    end
end

local function OnEntitySleep(inst)
    local timer = inst.components.timer
	
    if not TheWorld.state.iswinter and not timer:TimerExists(SLEEPING_LOOT_NAME) then
        timer:StartTimer(SLEEPING_LOOT_NAME, SLEEPING_LOOT_TIME)
    end
	
    inst:WatchWorldState("iswinter", IsWinter_UpdateLootGeneration)
end

local function OnEntityWake(inst)
    inst:StopWatchingWorldState("iswinter", IsWinter_UpdateLootGeneration)
    inst.components.timer:StopTimer(SLEEPING_LOOT_NAME)
end

local function OnTimerDone(inst, data)
    if data.name == SLEEPING_LOOT_NAME then
        if try_generate_loot_item(inst) then
            inst.components.timer:StartTimer(SLEEPING_LOOT_NAME, SLEEPING_LOOT_TIME)
        end
		
    elseif data.name == SLEEP_TIMER_NAME then
        if inst._is_sleeping_inside then
            if inst.AnimState:IsCurrentAnimation("idle") then
                inst.AnimState:PlayAnimation("sleep")
                inst.AnimState:PushAnimation("idle", true)
                inst.components.timer:StartTimer(SLEEP_TIMER_NAME, 6 + 3 * math.random())
            else
                inst.components.timer:StartTimer(SLEEP_TIMER_NAME, 1 + math.random())
            end
        else
            inst.components.timer:StartTimer(SLEEP_TIMER_NAME, 6 + 3 * math.random(), true)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.7)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("otter_den.png")

    inst.AnimState:SetBuild("otter_den")
    inst.AnimState:SetBank("otter_den")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:Hide("pile1")
    inst.AnimState:Hide("pile2")

    inst:AddTag("angry_when_rowed")
    inst:AddTag("pickable_search_str")
    inst:AddTag("soulless")
    inst:AddTag("wet")

    MakeSnowCoveredPristine(inst)
	
	inst:SetPrefabNameOverride("otterden")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "otter"
    inst.components.childspawner.allowwater = true
    inst.components.childspawner.allowboats = true
    inst.components.childspawner:SetRegenPeriod(TUNING.OTTERDEN_REGEN_PERIOD)
    inst.components.childspawner:SetSpawnPeriod(TUNING.OTTERDEN_SPAWN_PERIOD)
    inst.components.childspawner:SetMaxChildren(2)
    inst.components.childspawner:SetGoHomeFn(OnGoHome)
    inst.components.childspawner:SetSpawnedFn(OnSpawned)
    inst.components.childspawner:SetOccupiedFn(OnOccupied)
    inst.components.childspawner:SetVacateFn(OnVacate)
    inst.components.childspawner.canspawnfn = CanSpawn
    inst.components.childspawner:StartRegen()
    inst.components.childspawner:StartSpawning()
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)

	inst:AddComponent("combat")
    inst.components.combat:SetOnHit(OnHit)

	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.OTTERDEN_HEALTH)
    inst.components.health.nofadeout = true

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "OTTERDEN"
    inst.components.inspectable.getstatus = GetDenStatus

	inst:AddComponent("inventory")
    inst.components.inventory.maxslots = TUNING.OTTERDEN_INVENTORY_SLOTS
	
    inst:AddComponent("searchable")
    inst.components.searchable.onsearchfn = OnSearched

    inst:AddComponent("timer")
    inst.components.timer:StartTimer(SLEEP_TIMER_NAME, 5, true)

    local burnable = MakeMediumBurnable(inst)
    burnable:SetOnIgniteFn(OnIgnited)
    burnable:SetOnBurntFn(OnKilled)

    MakeHauntable(inst)
    MakeSnowCovered(inst)

    inst:ListenForEvent("death", OnKilled)
    inst:ListenForEvent("itemget", OnItemGet)
    inst:ListenForEvent("timerdone", OnTimerDone)
    inst:ListenForEvent("onmoved", OnMoved)

    inst:WatchWorldState("iscavenight", OnIsNightChanged)

    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake

    return inst
end

local function deadfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.7)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("otter_den.png")

    inst.AnimState:SetBuild("otter_den")
    inst.AnimState:SetBank("otter_den")
    inst.AnimState:PlayAnimation("dead", true)

    MakeSnowCoveredPristine(inst)
	
	inst:SetPrefabNameOverride("otterden_dead")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "OTTERDEN"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnHammeredDestroyed)

    MakeHauntable(inst)
    MakeSnowCovered(inst)
	
    return inst
end

return Prefab("sap_otterden", fn, assets, prefabs),
Prefab("sap_otterden_dead", deadfn, assets, prefabs),
MakePlacer("sap_otterden_placer", "otter_den", "otter_den", "idle")