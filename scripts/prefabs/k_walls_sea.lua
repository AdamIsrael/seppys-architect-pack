require "prefabutil"

local notags = {'NOBLOCK', 'player', 'FX'}
local function IsOcean(pt)
    local ground_tile = TheWorld.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
    return ground_tile and ground_tile == GROUND.OCEAN_COASTAL_SHORE or ground_tile == GROUND.OCEAN_BRINEPOOL_SHORE or ground_tile == GROUND.OCEAN_COASTAL or ground_tile == GROUND.OCEAN_BRINEPOOL or ground_tile == GROUND.OCEAN_SWELL or ground_tile == GROUND.OCEAN_ROUGH or ground_tile == GROUND.OCEAN_HAZARDOUS
end

local function candeploy(inst, pt)
    if IsOcean(pt) then
        local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 1, nil, notags)
        local min_spacing = inst.components.deployable.min_spacing or 0
        for k, v in pairs(ents) do
            print(k, v)
            if v ~= inst and v:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
                if distsq( Vector3(v.Transform:GetWorldPosition()), pt) < min_spacing*min_spacing then
                    return false
                end
            end
        end
        return true
    end
    return false
end

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
    { threshold = 0, anim = "water_broken" },
    { threshold = 0.4, anim = "water_onequarter" },
    { threshold = 0.5, anim = "water_half" },
    { threshold = 0.99, anim = "water_threequarter" },
    { threshold = 1, anim = { "water_fullA", "water_fullB", "water_fullC" } },
}

local prefabs =
{
	"collapse_small"
}

local function resolveanimtoplay(inst, percent)
    for i, v in ipairs(anims) do
        if percent <= v.threshold then
            if type(v.anim) == "table" then
                -- get a stable animation, by basing it on world position
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
        inst.AnimState:PlayAnimation(anim_to_play.."_hit", true)
        inst.AnimState:PushAnimation(anim_to_play, true)
    else
        if old_percent > 0 then
            clearobstacle(inst)
        end
        inst.AnimState:PlayAnimation(anim_to_play, true)
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

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.SEASTACK_MINE)
    end
end

function MakeWallType(data)
    local assets =
    {
        Asset("ANIM", "anim/wall_sea.zip"),
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
        --inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
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
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

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

        inst:AddComponent("repairer")
		inst.components.repairer.repairmaterial = data.name == "enforcedlimestone" and MATERIALS.STONE or data.name
        inst.components.repairer.healthrepairvalue = data.maxhealth / 6

        inst:AddComponent("deployable")
		inst.components.deployable:SetDeployMode(DEPLOYMODE.WATER)
		inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)
		-- inst._custom_candeploy_fn = candeploy
		inst.components.deployable.ondeploy = ondeploywall

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
            inst.AnimState:PlayAnimation(anim_to_play.."_hit", true)
            inst.AnimState:PushAnimation(anim_to_play, true)
        end
    end

    local function onrepaired(inst)
        if data.buildsound ~= nil then
            inst.SoundEmitter:PlaySound(data.buildsound)
        end
        makeobstacle(inst)
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.Transform:SetEightFaced()

		inst:SetPhysicsRadiusOverride(.5)
		MakeWaterObstaclePhysics(inst, .5, .5, .5)
        inst.Physics:SetDontRemoveOnSleep(true)

        --inst.Transform:SetScale(1.3,1.3,1.3)

        inst:AddTag("wall")
        inst:AddTag("noauradamage")
		inst:AddTag("ignorewalkableplatforms")
		inst:AddTag("rotatableobject")

        inst.AnimState:SetBank("wall")
        inst.AnimState:SetBuild("wall_"..data.name)
        inst.AnimState:PlayAnimation("water_half", true)

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
        inst.components.repairable.repairmaterial = data.name == "enforcedlimestone" and MATERIALS.STONE or data.name
        inst.components.repairable.onrepaired = onrepaired

        inst:AddComponent("combat")
        inst.components.combat:SetKeepTargetFunction(keeptargetfn)
        inst.components.combat.onhitfn = onhit

        inst:AddComponent("health")
        inst.components.health:SetMaxHealth(data.maxhealth)
        inst.components.health:SetCurrentHealth(data.maxhealth * .5)
        inst.components.health.ondelta = onhealthchange
        inst.components.health.nofadeout = true
        inst.components.health.canheal = false

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)

        MakeHauntableWork(inst)

        inst.OnLoad = onload

        MakeSnowCovered(inst)

		inst:ListenForEvent("on_collide", OnCollide)

        return inst
    end

    return Prefab("wall_"..data.name, fn, assets, prefabs),
        Prefab("wall_"..data.name.."_item", itemfn, assets, { "wall_"..data.name, "wall_"..data.name.."_item_placer" }),
        MakePlacer("wall_"..data.name.."_item_placer", "wall", "wall_"..data.name, "water_half", false, false, true, nil, nil, "eight")
end

local wallprefabs = {}
local walldata =
{
	{ name = "enforcedlimestone",	material = "stone", tags = { "stone", "cutstone" },	loot = "rocks", maxloots = 2, maxhealth = TUNING.RUINSWALL_HEALTH,	buildsound = "dontstarve/common/place_structure_stone" },
}

for i, v in ipairs(walldata) do
    local wall, item, placer = MakeWallType(v)
    table.insert(wallprefabs, wall)
    table.insert(wallprefabs, item)
    table.insert(wallprefabs, placer)
end

return unpack(wallprefabs)