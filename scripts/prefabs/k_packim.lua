local assets =
{
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),

    Asset("ANIM", "anim/packim.zip"),
	Asset("ANIM", "anim/packim_build.zip"),
	Asset("ANIM", "anim/packim_fat_build.zip"),
	Asset("ANIM", "anim/packim_fire_build.zip"),

    Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs =
{
    "packim_fishbone",
    "chesterlight",
    "chester_transform_fx",
    "globalmapiconunderfog",
}

local brain = require "brains/chesterbrain"

local sounds =
{
	close = "dontstarve_DLC002/creatures/packim/close",
	death = "dontstarve_DLC002/creatures/packim/death",
	hurt = "dontstarve_DLC002/creatures/packim/hurt",
	land = "dontstarve_DLC002/creatures/packim/land",
	open = "dontstarve_DLC002/creatures/packim/open",
	swallow = "dontstarve_DLC002/creatures/packim/swallow",
	transform = "dontstarve_DLC002/creatures/packim/transform",
	trasnform_stretch = "dontstarve_DLC002/creatures/packim/trasnform_stretch",
	transform_pop = "dontstarve_DLC002/creatures/packim/trasformation_pop",
	fly = "dontstarve_DLC002/creatures/packim/fly",
	fly_sleep = "dontstarve_DLC002/creatures/packim/fly_sleep",
	sleep = "dontstarve_DLC002/creatures/packim/sleep",
	bounce = "dontstarve_DLC002/creatures/packim/fly_bounce",
}

local WAKE_TO_FOLLOW_DISTANCE = 14
local SLEEP_NEAR_LEADER_DISTANCE = 7

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE)
end

local function ShouldSleep(inst)
    return DefaultSleepTest(inst) and not inst.sg:HasStateTag("open") and inst.components.follower:IsNearLeader(SLEEP_NEAR_LEADER_DISTANCE) and not TheWorld.state.isfullmoon
end

local function ShouldKeepTarget()
    return false
end

local function OnOpen(inst)
    if not inst.components.health:IsDead() then
        inst.sg:GoToState("open")
    end
end

local function OnClose(inst)
    if not inst.components.health:IsDead() and inst.sg.currentstate.name ~= "transition" then
        inst.sg:GoToState("close")		
	end
end

local function OnStopFollowing(inst)
    inst:RemoveTag("companion")
end

local function OnStartFollowing(inst)
    inst:AddTag("companion")
end

local function tryeatcontents(inst)
    local dideat = false
    local dideatfire = false
    local container = inst.components.container
	
	if container:IsOpen() then 
		return false 
	end

	if inst.PackimState == "FIRE" then
        for slot, item in pairs(inst.components.container.slots) do
            if item and not item:HasTag("irreplaceable") then				
				local replacement
				
				if item.components.cookable ~= nil then
					replacement = FunctionOrValue(item.components.cookable.product, item, inst)
					
					if item.components.cookable.oncooked ~= nil then
						item.components.cookable.oncooked(item, inst) 
					end
				elseif item.components.burnable ~= nil and not item.components.perishable then
					replacement = item:HasTag("burnablecharcoal") and "charcoal" or "ash"
				end
				
				replacement = replacement and SpawnPrefab(replacement)
				
                if replacement ~= nil then	
					if replacement.components.perishable ~= nil and item.components.perishable ~= nil then
						replacement.components.perishable:SetPercent(1)
					end
					
					if replacement.components.stackable ~= nil and item.components.stackable ~= nil then
						local stacksize = item.components.stackable:StackSize() * replacement.components.stackable:StackSize()
						replacement.components.stackable:SetStackSize(stacksize)
					end
					
					inst.components.container:RemoveItemBySlot(slot)
                    inst.components.container:GiveItem(replacement, slot)
                end 
				
				local item = replacement or item
					
				if item.components.inventoryitem ~= nil then
					item.components.inventoryitem:InheritMoisture(0, false)
				end
		
				if item.components.temperature ~= nil then
					item.components.temperature:SetTemperature(item.components.temperature:GetMax())
				end
            end
		end
	end
	
	local loot = {}
	
	if #loot > 0 then
		inst.components.lootdropper:SetLoot(loot)

		inst:DoTaskInTime(60 * FRAMES, function(inst)
			inst.components.lootdropper:DropLoot()
			inst.components.lootdropper:SetLoot({})
		end)
	end
	
	return dideat
end

local function MorphFatPackim(inst)
    inst.AnimState:SetBuild("packim_fat_build")
    inst:AddTag("fatboy")
    inst.MiniMapEntity:SetIcon("kyno_packimbaggims_fat.tex")
    inst.components.maprevealable:SetIcon("kyno_packimbaggims_fat.tex")

    inst.components.container:WidgetSetup("shadowchester")

    inst.PackimState = "FAT"
    inst._isfatpackim:set(true)
end

local function MorphFirePackim(inst)
    inst.AnimState:SetBuild("packim_fire_build")
    inst:AddTag("fireboy")
    inst.MiniMapEntity:SetIcon("kyno_packimbaggims_fire.tex")
    inst.components.maprevealable:SetIcon("kyno_packimbaggims_fire.tex")

    inst.PackimState = "FIRE"
    inst._isfatpackim:set(false)
end

local function CanMorph(inst, dideat)
    if dideat and inst.PackimState ~= "NORMAL" or not TheWorld.state.isfullmoon then
        return false, false
    end

    local container = inst.components.container
	
    if container:IsOpen() then
        return false, false
    end

    local canFire = true
    local canFat = true

    for i = 1, container:GetNumSlots() do
        local item = container:GetItemInSlot(i)
        if item == nil then
            return false, false
        end

        canFire = canFire and item.prefab == "redgem"
        canFat = canFat and item.prefab == "pondfish"

        if not (canFire or canFat) then
            return false, false
        end
    end

    return canFire, canFat
end

local function CheckForMorph(inst)
	local dideat = tryeatcontents(inst)
    local canFire, canFat = CanMorph(inst, dideat)
	
    if canFire or canFat then
        inst.sg:GoToState("transition")
	elseif dideat then
        inst.sg:GoToState("swallow")
    end
end

local function DoMorph(inst, fn)
    inst.MorphPackim = nil
    inst:StopWatchingWorldState("isfullmoon", CheckForMorph)
    inst:RemoveEventCallback("onclose", CheckForMorph)
    fn(inst)
end

local function MorphPackim(inst)
    local canFire, canFat = CanMorph(inst)
    if not (canFire or canFat) then
        return
    end

    local container = inst.components.container
	
    for i = 1, container:GetNumSlots() do
        container:RemoveItem(container:GetItemInSlot(i)):Remove()
    end

    DoMorph(inst, canFire and MorphFirePackim or MorphFatPackim)
end

local function OnSave(inst, data)
    data.PackimState = inst.PackimState
end

local function OnPreLoad(inst, data)
    if data == nil then
        return
    elseif data.PackimState == "FIRE" then
        DoMorph(inst, MorphFirePackim)
    elseif data.PackimState == "FAT" then
        DoMorph(inst, MorphFatPackim)
    end
end

local function OnIsFatPackimDirty(inst)
    if inst._isfatpackim:value() ~= inst._clientshadowmorphed then
        inst._clientshadowmorphed = inst._isfatpackim:value()
        inst.replica.container:WidgetSetup(inst._clientshadowmorphed and "shadowchester" or nil)
    end
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

local function create_packim()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()
    inst.entity:AddLightWatcher()

    inst.MiniMapEntity:SetIcon("kyno_packimbaggims.tex")
    inst.MiniMapEntity:SetCanUseCache(false)
	
	inst.DynamicShadow:SetSize(2, 1.5)
   	inst.Transform:SetSixFaced()
	
	MakeFlyingGiantCharacterPhysics(inst, 75, .5)

    inst.AnimState:SetBank("packim")
    inst.AnimState:SetBuild("packim_build")
	
	inst:AddTag("companion")
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("packim")
	inst:AddTag("flying")
    inst:AddTag("notraptrigger")
    inst:AddTag("noauradamage")
	inst:AddTag("ignorewalkableplatformdrowning")

    inst._isfatpackim = net_bool(inst.GUID, "_isfatpackim", "onisfatpackimdirty")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst._clientshadowmorphed = false
        inst:ListenForEvent("onisfatpackimdirty", OnIsFatPackimDirty)
		inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("chester") end
        return inst
    end
    
	-- inst:AddComponent("cooker")
	
    inst:AddComponent("maprevealable")
    inst.components.maprevealable:SetIconPrefab("globalmapiconunderfog")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "chester_body"
    inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.CHESTER_HEALTH)
    inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 10
    inst.components.locomotor:SetAllowPlatformHopping(false)
	inst.components.locomotor.pathcaps = { ignorewalls = true, allowocean = true }

    -- inst:AddComponent("embarker")

    inst:AddComponent("follower")
    inst:ListenForEvent("stopfollowing", OnStopFollowing)
    inst:ListenForEvent("startfollowing", OnStartFollowing)

    inst:AddComponent("knownlocations")

    MakeSmallBurnableCharacter(inst, "chester_body")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("chester")
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    MakeHauntableDropFirstItem(inst)
    AddHauntableCustomReaction(inst, OnHaunt, false, false, true)

    inst.sounds = sounds

    inst:SetStateGraph("SGpackim")
    inst.sg:GoToState("idle")

    inst:SetBrain(brain)

    inst.PackimState = "NORMAL"
    inst.MorphPackim = MorphPackim
    inst:WatchWorldState("isfullmoon", CheckForMorph)
    inst:ListenForEvent("onclose", CheckForMorph)

    inst.OnSave = OnSave
    inst.OnPreLoad = OnPreLoad
	
	inst.tryeat = tryeatcontents
	inst.checkfiretransform = CheckForMorph
	
    return inst
end

return Prefab("packim", create_packim, assets, prefabs)