require("prefabutil")

local function OnIsPathFindingDirty(inst)
    local wall_x, wall_y, wall_z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:GetPlatformAtPoint(wall_x, wall_z) == nil then
        if inst._ispathfinding:value() then
            if inst._pfpos == nil then
                inst._pfpos = Point(wall_x, wall_y, wall_z)
                TheWorld.Pathfinder:AddWall(wall_x, wall_y, wall_z)
            end
        elseif inst._pfpos ~= nil then
            TheWorld.Pathfinder:RemoveWall(wall_x, wall_y, wall_z)
            inst._pfpos = nil
        end
    end
end

local function InitializePathFinding(inst)
    inst:ListenForEvent("onispathfindingdirty", OnIsPathFindingDirty)
    OnIsPathFindingDirty(inst)
end

local function makeobstacle(inst)
    inst.Physics:SetActive(true)
    inst._ispathfinding:set(true)
end

local function clearobstacle(inst)
    inst.Physics:SetActive(false)
    inst._ispathfinding:set(false)
end

local anims =
{
    { threshold = 0,    anim = "broken" },
    { threshold = 0.4,  anim = "onequarter" },
    { threshold = 0.5,  anim = "half" },
    { threshold = 0.99, anim = "threequarter" },
    { threshold = 1,    anim = { "fullA", "fullB", "fullC" } },
}

local prefabs =
{
	"collapse_small"
}

local function resolveanimtoplay(inst, percent)
    for i, v in ipairs(anims) do
        if percent <= v.threshold then
            if type(v.anim) == "table" then
                local x, y, z = inst.Transform:GetWorldPosition()
                local x = math.floor(x)
                local z = math.floor(z)
                local q1 = #v.anim + 1
                local q2 = #v.anim + 4
                local t = ( ((x%q1)*(x+3)%q2) + ((z%q1)*(z+3)%q2) )% #v.anim + 1
                return v.anim[t]
            else
                return v.anim
            end
        end
    end
end

local function onhealthchange(inst, old_percent, new_percent)
    local anim_to_play = resolveanimtoplay(inst, new_percent)
    if new_percent > 0 then
        if old_percent <= 0 then
            makeobstacle(inst)
        end
        inst.AnimState:PlayAnimation(anim_to_play.."_hit")
        inst.AnimState:PushAnimation(anim_to_play, false)
    else
        if old_percent > 0 then
            clearobstacle(inst)
        end
        inst.AnimState:PlayAnimation(anim_to_play)
    end
end

local function keeptargetfn()
    return false
end

local function onload(inst)
    if inst.components.health:IsDead() then
        clearobstacle(inst)
    end
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end

function MakeWallType(data)
    local assets =
    {
        Asset("ANIM", "anim/wall.zip"),
        Asset("ANIM", "anim/wall_"..data.name..".zip"),

		Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
		Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),

		Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
		Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),

		Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
		Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
		Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
    }

    local prefabs =
    {
        "collapse_small",
    }

    local function ondeploywall(inst, pt, deployer)
        local wall = SpawnPrefab("wall_"..data.name)
        if wall ~= nil then
            local x = math.floor(pt.x) + .5
            local z = math.floor(pt.z) + .5
            wall.Physics:SetCollides(false)
            wall.Physics:Teleport(x, 0, z)
            wall.Physics:SetCollides(true)
            inst.components.stackable:Get():Remove()

            if data.buildsound ~= nil then
                wall.SoundEmitter:PlaySound(data.buildsound)
            end
        end
    end

    local function onhammered(inst, worker)
        if data.maxloots ~= nil and data.loot ~= nil then
            local num_loots = math.max(1, math.floor(data.maxloots * inst.components.health:GetPercent()))
            for i = 1, num_loots do
                inst.components.lootdropper:SpawnLootPrefab(data.loot)
            end
        end

        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        if data.material ~= nil then
            fx:SetMaterial(data.material)
        end

        inst:Remove()
    end

    local function itemfn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
		local item_floats = (data.name == "wood") or (data.name == "hay")
        if item_floats then
            MakeInventoryFloatable(inst)
        end

        inst:AddTag("wallbuilder")

        inst.AnimState:SetBank("wall")
        inst.AnimState:SetBuild("wall_"..data.name)
        inst.AnimState:PlayAnimation("idle")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        if not item_floats then
            inst.components.inventoryitem:SetSinks(true)
        end

        inst:AddComponent("repairer")
		inst.components.repairer.healthrepairvalue = data.maxhealth / 6
        inst.components.repairer.repairmaterial = data.name == "legacy_moonrock" and MATERIALS.MOONROCK
		or data.name == "legacyruins" and MATERIALS.THULECITE
		or data.name == "reed" and MATERIALS.HAY
		or data.name == "bone" and MATERIALS.STONE
		or data.name == "living" and MATERIALS.STONE
		or data.name == "mud" and MATERIALS.HAY
		or data.name == "ice" and MATERIALS.STONE
		or data.name == "driftwood" and MATERIALS.WOOD or data.name

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = ondeploywall
        inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)

		if data.flammable then
			inst:AddComponent("fuel")
            inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

            MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
            MakeSmallPropagator(inst)
        end

        MakeHauntableLaunch(inst)

        return inst
    end

    local function onhit(inst)
        if data.material ~= nil then
            inst.SoundEmitter:PlaySound("dontstarve/common/destroy_"..data.material)
        end

        local healthpercent = inst.components.health:GetPercent()
        if healthpercent > 0 then
            local anim_to_play = resolveanimtoplay(inst, healthpercent)
            inst.AnimState:PlayAnimation(anim_to_play.."_hit")
            inst.AnimState:PushAnimation(anim_to_play, false)
        end
    end

    local function onrepaired(inst)
        if data.buildsound ~= nil then
            inst.SoundEmitter:PlaySound(data.buildsound)
        end
        makeobstacle(inst)
    end

	local function wallplacetestfn(inst)
		inst.AnimState:SetScale(1.1, 1, 1.1)
	end

	local function wallplacetestfn2(inst)
		inst.AnimState:SetScale(.8, .8, .8)
	end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.Transform:SetEightFaced()

        MakeObstaclePhysics(inst, .5)
        inst.Physics:SetDontRemoveOnSleep(true)

		if data.name == "legacy_moonrock" then
			inst.AnimState:SetScale(1.1, 1, 1.1)
		end

		if data.name == "ice" then
			inst.AnimState:SetScale(.8, .8, .8)
		end

        inst:AddTag("wall")
        inst:AddTag("noauradamage")
		inst:AddTag("rotatableobject")

        inst.AnimState:SetBank("wall")
        inst.AnimState:SetBuild("wall_"..data.name)
        inst.AnimState:PlayAnimation("half")

        for i, v in ipairs(data.tags) do
            inst:AddTag(v)
        end

        MakeSnowCoveredPristine(inst)

        inst._pfpos = nil
        inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")

        makeobstacle(inst)

        inst:DoTaskInTime(0, InitializePathFinding)
        inst.OnRemoveEntity = onremove

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("lootdropper")

        inst:AddComponent("repairable")
		inst.components.repairable.onrepaired = onrepaired
        inst.components.repairable.repairmaterial = data.name == "legacy_moonrock" and MATERIALS.MOONROCK
		or data.name == "legacyruins" and MATERIALS.THULECITE
		or data.name == "reed" and MATERIALS.HAY
		or data.name == "bone" and MATERIALS.STONE
		or data.name == "living" and MATERIALS.STONE
		or data.name == "mud" and MATERIALS.HAY
		or data.name == "ice" and MATERIALS.STONE
		or data.name == "driftwood" and MATERIALS.WOOD or data.name

        inst:AddComponent("combat")
        inst.components.combat:SetKeepTargetFunction(keeptargetfn)
        inst.components.combat.onhitfn = onhit

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(data.maxhealth)
        inst.components.health:SetCurrentHealth(data.maxhealth * .5)
        inst.components.health.ondelta = onhealthchange
        inst.components.health.nofadeout = true
        inst.components.health.canheal = false
        if data.name == "legacy_moonrock" then
            inst.components.health:SetAbsorptionAmountFromPlayer(TUNING.MOONROCKWALL_PLAYERDAMAGEMOD)
        end

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(data.name == "legacy_moonrock" and TUNING.MOONROCKWALL_WORK or 3)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)

		if data.flammable then
            MakeMediumBurnable(inst)
            MakeLargePropagator(inst)
            inst.components.burnable.flammability = .5
            inst.components.burnable.nocharring = true

            if data.name == MATERIALS.WOOD then
                inst.components.propagator.flashpoint = 30 + math.random() * 10
            end
        else
            inst.components.health.fire_damage_scale = 0
        end

		inst.OnLoad = onload

        MakeHauntableWork(inst)
        MakeSnowCovered(inst)

        return inst
    end

    return Prefab("wall_"..data.name, fn, assets, prefabs),
        Prefab("wall_"..data.name.."_item", itemfn, assets, {  "wall_"..data.name,     "wall_"..data.name.."_item_placer" }),
        MakePlacer("wall_"..data.name.."_item_placer", "wall", "wall_"..data.name,     "half", false, false, true, nil, nil, "eight"),
		MakePlacer("wall_legacy_moonrock_item_placer", "wall", "wall_legacy_moonrock", "half", false, false, true, nil, nil, "eight", wallplacetestfn),
		MakePlacer("wall_ice_item_placer",             "wall", "wall_ice",             "half", false, false, true, nil, nil, "eight", wallplacetestfn2),
		MakePlacer("wall_driftwood_item_placer",       "wall", "wall_driftwood",       "half", false, false, true, nil, nil, "eight")
end

local wallprefabs = {}

--6 rock, 8 wood, 4 straw
--NOTE: Stacksize is now set in the actual recipe for the item.
local walldata =
{
    { name = "legacy_moonrock", material = "stone", tags = { "stone", "moonrock"  }, loot = "moonrocknugget",   maxloots = 2, maxhealth = TUNING.MOONROCKWALL_HEALTH, flammable = false, buildsound = "dontstarve/common/place_structure_stone"     },
	{ name = "legacyruins",     material = "stone", tags = { "stone", "ruins"     }, loot = "thulecite_pieces", maxloots = 2, maxhealth = TUNING.RUINSWALL_HEALTH,    flammable = false, buildsound = "dontstarve/common/place_structure_stone"     },
	{ name = "reed",            material = "straw", tags = { "grass", "cutreeds"  }, loot = "cutreeds",         maxloots = 2, maxhealth = TUNING.HAYWALL_HEALTH,      flammable = true,  buildsound = "dontstarve/common/place_structure_straw"     },
	{ name = "bone",            material = "stone", tags = { "stone", "boneshard" }, loot = "boneshard",        maxloots = 2, maxhealth = 650,                        flammable = false, buildsound = "dontstarve/common/place_structure_stone"     },
	{ name = "living",          material = "stone", tags = { "ruins", "tentacle"  }, loot = "tentaclespots",    maxloots = 2, maxhealth = 750,                        flammable = false, buildsound = "dontstarve/common/place_structure_stone"     },
	{ name = "mud",             material = "straw", tags = { "grass", "poop"      }, loot = "poop",             maxloots = 2, maxhealth = 250,                        flammable = true,  buildsound = "dontstarve/creatures/spider/spider_egg_sack" },
	{ name = "ice",             material = "stone", tags = { "stone", "ice"       }, loot = "ice",              maxloots = 2, maxhealth = 650,                        flammable = false, buildsound = "dontstarve/common/place_structure_stone"     },
	{ name = "driftwood",       material = "wood",  tags = { "wood"               }, loot = "driftwood_log",    maxloots = 2, maxhealth = TUNING.WOODWALL_HEALTH,     flammable = true,  buildsound = "dontstarve/common/place_structure_wood"      },
}

for i, v in ipairs(walldata) do
    local wall, item, placer = MakeWallType(v)
    table.insert(wallprefabs, wall)
    table.insert(wallprefabs, item)
    table.insert(wallprefabs, placer)
end

return unpack(wallprefabs)