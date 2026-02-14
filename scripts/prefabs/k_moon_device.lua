require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/moon_device.zip"),
    Asset("ANIM", "anim/moon_device_break.zip"),
	Asset("ANIM", "anim/moon_device_break.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"collapse_small",
	"kyno_moondevice_energy",
	"kyno_moondevice_pillar",
	"kyno_moondevice_top"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onbuilt1(inst)
	inst.AnimState:PlayAnimation("stage1_idle_pre")
	inst.SoundEmitter:PlaySound("moonstorm/common/moon_device/1_craft")
	inst.AnimState:PushAnimation("stage1_idle")
end

local function onbuilt2(inst)
	inst.AnimState:PlayAnimation("stage1_idle_pre")
	inst.SoundEmitter:PlaySound("moonstorm/common/moon_device/1_craft")
	inst.SoundEmitter:PlaySound("moonstorm/common/moon_device/2_craft")
	inst.AnimState:PushAnimation("stage1_idle")
end

local function onbuilt3(inst)
	inst.AnimState:PlayAnimation("stage1_idle_pre")
	inst.SoundEmitter:PlaySound("moonstorm/common/moon_device/1_craft")
	inst.SoundEmitter:PlaySound("moonstorm/common/moon_device/2_craft")
	inst.SoundEmitter:PlaySound("moonstorm/common/moon_device/3_craft")
	inst.AnimState:PushAnimation("stage1_idle")
end

local function addpillar(inst, local_x, local_z, rotation)
    local pillar = SpawnPrefab("kyno_moondevice_pillar")
    pillar.entity:SetParent(inst.entity)
    pillar.Transform:SetPosition(local_x, 0, local_z)
    pillar.Transform:SetRotation(rotation)

    return pillar
end

spawnpillars = function(inst)
    if inst._pillars == nil then
        local x, y, z = inst.Transform:GetWorldPosition()

        local offset = 2.7

        inst._pillars = {}

        table.insert(inst._pillars, addpillar(inst, -offset, 0, 0))
        table.insert(inst._pillars, addpillar(inst, 0, -offset, 270))
        table.insert(inst._pillars, addpillar(inst, offset, 0, 180))
        table.insert(inst._pillars, addpillar(inst, 0, offset, 90))
    end
end

local function pillarfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetEightFaced()

    inst.AnimState:SetBank("moon_device_stages")
    inst.AnimState:SetBuild("moon_device")
    inst.AnimState:PlayAnimation("stage2_idle")
	inst.AnimState:SetSortOrder(2)

    inst:SetPrefabNameOverride("moon_device")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function topfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetEightFaced()
    inst.Transform:SetRotation(45)

    inst.AnimState:SetBank("moon_device_stages")
    inst.AnimState:SetBuild("moon_device")
    inst.AnimState:PlayAnimation("stage3_idle", true)
	inst.AnimState:SetSortOrder(3)

    inst:SetPrefabNameOverride("moon_device")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function energyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.Transform:SetEightFaced()
    inst.Transform:SetRotation(45)

    inst.AnimState:SetBank("moon_altar_geyser")
    inst.AnimState:SetBuild("moon_geyser")
    inst.AnimState:PlayAnimation("stage2_idle", true)
	inst.AnimState:SetSortOrder(1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

spawntop = function(inst)
    if inst._top == nil then
        inst._top = SpawnPrefab("kyno_moondevice_top")
        inst._top.entity:SetParent(inst.entity)
    end
end

spawnenergy = function(inst)
	if inst._energy == nil then
		inst._energy = SpawnPrefab("kyno_moondevice_energy")
		inst._energy.entity:SetParent(inst.entity)
	end
end

local function OnEntitySleep(inst)
    if inst.SoundEmitter:PlayingSound("loop") then
        inst.SoundEmitter:KillSound("loop")
    end
end

local function OnEntityWake(inst)
    if not inst.SoundEmitter:PlayingSound("loop") then
        inst.SoundEmitter:PlaySound("grotto/common/moon_alter/link/LP", "loop")
        inst.SoundEmitter:SetParameter("loop", "intensity", 1)
    end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    -- MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("moon_device_construction1.png")
	
    inst.AnimState:SetBank("moon_device_stages")
    inst.AnimState:SetBuild("moon_device")
    inst.AnimState:PlayAnimation("stage1_idle", false)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
    
	inst:AddTag("structure")
	inst:AddTag("antlion_sinkhole_blocker")
	
	inst:SetPrefabNameOverride("moon_device")

	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ALTERGUARDIAN_CONTAINED"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt1)
	
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	
	MakeHauntableWork(inst)
	
    return inst
end

local function fn2()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    -- MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("moon_device_construction1.png")
	
    inst.AnimState:SetBank("moon_device_stages")
    inst.AnimState:SetBuild("moon_device")
    inst.AnimState:PlayAnimation("stage1_idle", false)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
    
	inst:AddTag("structure")
	inst:AddTag("antlion_sinkhole_blocker")
	
	inst:SetPrefabNameOverride("moon_device")

	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	spawnpillars(inst)
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ALTERGUARDIAN_CONTAINED"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt2)
	
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	
	MakeHauntableWork(inst)
	
    return inst
end

local function fn3()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    -- MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("moon_device_construction1.png")
	
    inst.AnimState:SetBank("moon_device_stages")
    inst.AnimState:SetBuild("moon_device")
    inst.AnimState:PlayAnimation("stage1_idle", false)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
    
	inst:AddTag("structure")
	inst:AddTag("antlion_sinkhole_blocker")
	
	inst:SetPrefabNameOverride("moon_device")

	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	spawnpillars(inst)
	spawntop(inst)
	spawnenergy(inst)
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ALTERGUARDIAN_CONTAINED"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt3)
	
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("kyno_moondevice_pillar", pillarfn, assets, prefabs),
Prefab("kyno_moondevice_top", topfn, assets, prefabs),
Prefab("kyno_moondevice_energy", energyfn, assets, prefabs),
Prefab("kyno_moondevice_stage1", fn, assets),
Prefab("kyno_moondevice_stage2", fn2, assets),
Prefab("kyno_moondevice_stage3", fn3, assets),
MakePlacer("kyno_moondevice_stage1_placer", "moon_device_stages", "moon_device", "stage1_idle", true),
MakePlacer("kyno_moondevice_stage2_placer", "moon_device_stages", "moon_device", "stage1_idle", true),
MakePlacer("kyno_moondevice_stage3_placer", "moon_device_stages", "moon_device", "stage1_idle", true)