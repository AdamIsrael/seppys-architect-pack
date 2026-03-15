local assets =
{
    Asset("ANIM", "anim/marsh_tile.zip"),
    Asset("ANIM", "anim/splash.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "marsh_plant",
	"pondfish",
	"pondeel",
    "frog",
    "mosquito",
}

local function SpawnPlants(inst)
    inst.task = nil

    if inst.plant_ents ~= nil then
        return
    end

    if inst.plants == nil then
        inst.plants = {}
        for i = 1, math.random(2, 4) do
            local theta = math.random() * 2 * PI
            table.insert(inst.plants,
            {
                offset =
                {
                    math.sin(theta) * 1.9 + math.random() * .3,
                    0,
                    math.cos(theta) * 2.1 + math.random() * .3,
                },
            })
        end
    end

    inst.plant_ents = {}

    for i, v in pairs(inst.plants) do
        if type(v.offset) == "table" and #v.offset == 3 then
            local plant = SpawnPrefab(inst.planttype)
            if plant ~= nil then
                plant.entity:SetParent(inst.entity)
                plant.Transform:SetPosition(unpack(v.offset))
                plant.persists = false
                table.insert(inst.plant_ents, plant)
            end
        end
    end
end

local function DespawnPlants(inst)
    if inst.plant_ents ~= nil then
        for i, v in ipairs(inst.plant_ents) do
            if v:IsValid() then
                v:Remove()
            end
        end

        inst.plant_ents = nil
    end

    inst.plants = nil
end

local function OnSnowLevel(inst, snowlevel)
    if snowlevel > .02 then
        if not inst.frozen then
            inst.frozen = true
            inst.AnimState:PlayAnimation("frozen")
            inst.SoundEmitter:PlaySound("dontstarve/winter/pondfreeze")
            inst.components.childspawner:StopSpawning()
            inst.components.fishable:Freeze()

            inst.Physics:SetCollisionGroup(COLLISION.LAND_OCEAN_LIMITS)
            inst.Physics:ClearCollisionMask()
            inst.Physics:CollidesWith(COLLISION.WORLD)
            inst.Physics:CollidesWith(COLLISION.ITEMS)

            DespawnPlants(inst)

            inst.components.watersource.available = false
        end
    elseif inst.frozen then
        inst.frozen = false
        inst.AnimState:PlayAnimation("idle"..inst.pondtype, true)
        inst.components.childspawner:StartSpawning()
        inst.components.fishable:Unfreeze()

		inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.ITEMS)
        inst.Physics:CollidesWith(COLLISION.CHARACTERS)
        inst.Physics:CollidesWith(COLLISION.GIANTS)

        SpawnPlants(inst)

        inst.components.watersource.available = true
    elseif inst.frozen == nil then
        inst.frozen = false
        SpawnPlants(inst)
    end
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit_pond(inst, worker)
    inst.AnimState:PlayAnimation("splash")
    inst.AnimState:PushAnimation("idle", true)
end

local function onhit_marsh(inst, worker)
    inst.AnimState:PlayAnimation("splash_mos")
    inst.AnimState:PushAnimation("idle_mos", true)
end

local function onhit_cave(inst, worker)
	inst.AnimState:PlayAnimation("splash_cave")
	inst.AnimState:PushAnimation("idle_cave", true)
end

local function OnSave(inst, data)
    data.plants = inst.plants
end

local function OnLoad(inst, data)
    if data ~= nil and data.plants ~= nil and inst.plants == nil and inst.task ~= nil then
        inst.plants = data.plants
    end
end

local function OnPreLoadCave(inst, data)
	inst.nitreformations = data and data.nitreformations or nil
end

local function commonfn(pondtype)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("pond"..pondtype..".png")

    MakeObstaclePhysics(inst, 1.95)

    inst.AnimState:SetBuild("marsh_tile")
    inst.AnimState:SetBank("marsh_tile")
    inst.AnimState:PlayAnimation("idle"..pondtype, true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

	inst:AddTag("structure")
    inst:AddTag("watersource")
	inst:AddTag("pond")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")

    inst.no_wet_prefix = true

    inst:SetDeployExtraSpacing(2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.pondtype = pondtype
	
	inst:AddComponent("watersource")
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")

    inst:AddComponent("childspawner")
    inst.components.childspawner:SetRegenPeriod(TUNING.POND_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.POND_SPAWN_TIME)
    inst.components.childspawner:SetMaxChildren(math.random(3, 4))
    inst.components.childspawner:StartRegen()

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "pond"

    inst:AddComponent("fishable")
    inst.components.fishable:SetRespawnTime(TUNING.FISH_RESPAWN_TIME)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

local function ReturnChildren(inst)
    for k, child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.homeseeker ~= nil then
            child.components.homeseeker:GoHome()
        end
        child:PushEvent("gohome")
    end
end

local function OnIsDay(inst, isday)
    if isday ~= inst.dayspawn then
        inst.components.childspawner:StopSpawning()
        ReturnChildren(inst)
    elseif not TheWorld.state.iswinter then
        inst.components.childspawner:StartSpawning()
    end
end

local function OnInit(inst)
    inst.task = nil
    inst:WatchWorldState("isday", OnIsDay)
    inst:WatchWorldState("snowlevel", OnSnowLevel)
    OnIsDay(inst, TheWorld.state.isday)
    OnSnowLevel(inst, TheWorld.state.snowlevel)
end

local function pondmos()
    local inst = commonfn("_mos")
	
	inst:SetPrefabNameOverride("pond")
	
	inst:AddTag("pond_swamp")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.childspawner.childname = "mosquito"
    inst.components.fishable:AddFish("pondfish")

    inst.planttype = "marsh_plant"
    inst.dayspawn = false
    inst.task = inst:DoTaskInTime(0, OnInit)
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_marsh)

    return inst
end 

local function pondfrog()
    local inst = commonfn("")
	
	inst:SetPrefabNameOverride("pond")

	inst:AddTag("pond_common")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.childspawner.childname = "frog"
    inst.components.fishable:AddFish("pondfish")

    inst.planttype = "marsh_plant"
    inst.dayspawn = true
    inst.task = inst:DoTaskInTime(0, OnInit)
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_pond)

    return inst
end

local function pondcave()
    local inst = commonfn("_cave")
	
	inst:SetPrefabNameOverride("pond")
	
	inst:AddTag("pond_caves")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.fishable:AddFish("pondeel")

    inst.planttype = "pond_algae"
    inst.task = inst:DoTaskInTime(0, SpawnPlants)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_cave)
	
    return inst
end

return Prefab("sap_pond", pondfrog, assets, prefabs),
Prefab("sap_pondmarsh", pondmos, assets, prefabs),
Prefab("sap_pondcave", pondcave, assets, prefabs),
MakePlacer("sap_pond_placer", "marsh_tile", "marsh_tile", "idle", true, nil, nil, nil, 90, nil),
MakePlacer("sap_pondmarsh_placer", "marsh_tile", "marsh_tile", "idle_mos", true, nil, nil, nil, 90, nil),
MakePlacer("sap_pondcave_placer", "marsh_tile", "marsh_tile", "idle_cave", true, nil, nil, nil, 90, nil)