require("prefabutil")

local function OnIsPathFindingDirty(inst)
    if inst._ispathfinding:value() then
        if inst._pfpos == nil and inst:GetCurrentPlatform() == nil then
            inst._pfpos = inst:GetPosition()
            TheWorld.Pathfinder:AddWall(inst._pfpos:Get())
        end
    elseif inst._pfpos ~= nil then
        TheWorld.Pathfinder:RemoveWall(inst._pfpos:Get())
        inst._pfpos = nil
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
    { threshold = 0,    anim = "broken"                      },
    { threshold = 0.4,  anim = "onequarter"                  },
    { threshold = 0.5,  anim = "half"                        },
    { threshold = 0.99, anim = "threequarter"                },
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

local function onload(inst,data)
    if inst.components.health:IsDead() then
        clearobstacle(inst)
    end

    if data and data.gridnudge then
        local function normalize(coord)

            local temp = coord%0.5
            coord = coord + 0.5 - temp

            if  coord%1 == 0 then
                coord = coord -0.5
            end

            return coord
        end

        local pt = Vector3(inst.Transform:GetWorldPosition())
        pt.x = normalize(pt.x)
        pt.z = normalize(pt.z)
        inst.Transform:SetPosition(pt.x,pt.y,pt.z)
    end
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end

local PLAYER_TAGS = { "player" }
local function ValidRepairFn(inst)
    if inst.Physics:IsActive() then
        return true
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:IsAboveGroundAtPoint(x, y, z) then
        return true
    end

    if TheWorld.Map:IsVisualGroundAtPoint(x,y,z) then
        for i, v in ipairs(TheSim:FindEntities(x, 0, z, 1, PLAYER_TAGS)) do
            if v ~= inst and
            v.entity:IsVisible() and
            v.components.placer == nil and
            v.entity:GetParent() == nil then
                local px, _, pz = v.Transform:GetWorldPosition()
                if math.floor(x) == math.floor(px) and math.floor(z) == math.floor(pz) then
                    return false
                end
            end
        end
    end
    return true
end

function MakeWallType(data)
    local assets =
    {
        Asset("ANIM", "anim/wall_hedge.zip"),
        Asset("ANIM", "anim/wall_"..data.name..".zip"),
    }

    local prefabs =
    {
        "collapse_small",
    }

    local function ondeploywall(inst, pt, deployer)
        local wall = SpawnPrefab("wall_"..data.name, inst.linked_skinname, inst.skin_id)
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
		MakeInventoryFloatable(inst)

        inst.AnimState:SetBank("wall_hedge")
        inst.AnimState:SetBuild("wall_"..data.name)
        inst.AnimState:PlayAnimation("idle")

		inst:AddTag("wallbuilder")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

		inst:AddComponent("inspectable")
		inst.components.inspectable.nameoverride = "WALL_HEDGE_BLOCK_ITEM"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

        inst:AddComponent("repairer")
		inst.components.repairer.healthrepairvalue = data.maxhealth / 6
        inst.components.repairer.repairmaterial = (data.name == "hedge_block_pink_aged" and MATERIALS.HAY)
		or (data.name == "hedge_cone_pink_aged" and MATERIALS.HAY) or (data.name == "hedge_layered_pink_aged" and MATERIALS.HAY) or data.name

        inst:AddComponent("deployable")
        inst.components.deployable.ondeploy = ondeploywall
        inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)

		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

		MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
		MakeSmallPropagator(inst)
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

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.Transform:SetEightFaced()

        MakeObstaclePhysics(inst, .5)
        inst.Physics:SetDontRemoveOnSleep(true)

        inst.AnimState:SetBank("wall_hedge")
        inst.AnimState:SetBuild("wall_"..data.name)
        inst.AnimState:PlayAnimation("half")

		inst:AddTag("wall")
        inst:AddTag("noauradamage")
		inst:AddTag("rotatableobject")

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

        inst:AddComponent("lootdropper")

		inst:AddComponent("inspectable")
		inst.components.inspectable.nameoverride = "WALL_HEDGE_BLOCK"

        inst:AddComponent("repairable")
        inst.components.repairable.onrepaired = onrepaired
        inst.components.repairable.testvalidrepairfn = ValidRepairFn
		inst.components.repairable.repairmaterial = (data.name == "hedge_block_pink_aged" and MATERIALS.HAY)
		or (data.name == "hedge_cone_pink_aged" and MATERIALS.HAY) or (data.name == "hedge_layered_pink_aged" and MATERIALS.HAY) or data.name

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
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit)
		inst.components.workable:SetWorkLeft(3)

		MakeSnowCovered(inst)
		MakeHauntableWork(inst)
		MakeMediumBurnable(inst)
		MakeLargePropagator(inst)
		inst.components.burnable.flammability = .5
		inst.components.burnable.nocharring = true

        inst.OnLoad = onload

        return inst
    end

    return Prefab("wall_"..data.name, fn, assets, prefabs),
	Prefab("wall_"..data.name.."_item", itemfn, assets, { "wall_"..data.name, "wall_"..data.name.."_item_placer" }),
	MakePlacer("wall_"..data.name.."_item_placer", "wall_hedge", "wall_"..data.name, "half", false, false, true, nil, nil, "eight")
end

local wallprefabs = {}

local walldata =
{
    { name = "hedge_block_pink_aged",   material = "straw", tags = { "grass", "hedge1" }, loot = "cutgrass", maxloots = 2, maxhealth = TUNING.HAYWALL_HEALTH, buildsound = "dontstarve/common/place_structure_straw" },
	{ name = "hedge_cone_pink_aged",    material = "straw", tags = { "grass", "hedge2" }, loot = "cutgrass", maxloots = 2, maxhealth = TUNING.HAYWALL_HEALTH, buildsound = "dontstarve/common/place_structure_straw" },
	{ name = "hedge_layered_pink_aged", material = "straw", tags = { "grass", "hedge3" }, loot = "cutgrass", maxloots = 2, maxhealth = TUNING.HAYWALL_HEALTH, buildsound = "dontstarve/common/place_structure_straw" },
}
for i, v in ipairs(walldata) do
    local wall, item, placer = MakeWallType(v)
    table.insert(wallprefabs, wall)
    table.insert(wallprefabs, item)
    table.insert(wallprefabs, placer)
end

return unpack(wallprefabs)