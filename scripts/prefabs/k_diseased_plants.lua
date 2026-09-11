local assets =
{
    Asset("ANIM", "anim/grass.zip"),
    Asset("ANIM", "anim/grass_diseased_build.zip"),
	
	Asset("ANIM", "anim/sapling.zip"),
    Asset("ANIM", "anim/sapling_diseased_build.zip"),
	
	Asset("ANIM", "anim/berrybush.zip"),
    Asset("ANIM", "anim/berrybush_diseased_build.zip"),
	
	Asset("ANIM", "anim/berrybush2.zip"),
	Asset("ANIM", "anim/berrybush2_diseased_build.zip"),
	
	Asset("ANIM", "anim/berrybush_juicy.zip"),
    Asset("ANIM", "anim/berrybush_juicy_diseased_build.zip"),
	
	Asset("ANIM", "anim/sapling_moon.zip"),
    Asset("ANIM", "anim/sapling_diseased_moon.zip"),
	
	Asset("ANIM", "anim/rock_avocado.zip"),
    Asset("ANIM", "anim/rock_avocado_diseased_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
    "spoiled_food",
}

local function dig_up_grass(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
	inst.components.lootdropper:SpawnLootPrefab("dug_grass")
	SpawnPrefab("disease_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function dig_up_sapling(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
	inst.components.lootdropper:SpawnLootPrefab("dug_sapling")
	SpawnPrefab("disease_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function dig_up_berrybush(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
	inst.components.lootdropper:SpawnLootPrefab("dug_berrybush")
	SpawnPrefab("disease_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function dig_up_berrybush2(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
	inst.components.lootdropper:SpawnLootPrefab("dug_berrybush2")
	SpawnPrefab("disease_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function dig_up_berrybush_juicy(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
	inst.components.lootdropper:SpawnLootPrefab("dug_berrybush_juicy")
	SpawnPrefab("disease_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function dig_up_avocado(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
	inst.components.lootdropper:SpawnLootPrefab("dug_rock_avocado_bush")
	SpawnPrefab("disease_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function grassfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("grass.png")

    inst.AnimState:SetBank("grass")
    inst.AnimState:SetBuild("grass_diseased_build")
    inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("plantdiseased")
	
	inst:SetPrefabNameOverride("grass")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.diseaseprefab =  SpawnPrefab("disease_fx_small")
		inst.diseaseprefab.entity:SetParent(inst.entity)
	end

    inst.AnimState:SetTime(math.random() * 2)
    local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_FUEL)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_grass)
	inst.components.workable:SetWorkLeft(1)

    return inst
end

local function saplingfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("sapling.png")

    inst.AnimState:SetBank("sapling")
    inst.AnimState:SetBuild("sapling_diseased_build")
    inst.AnimState:PlayAnimation("sway", true)

	inst:AddTag("plantdiseased")
	
	inst:SetPrefabNameOverride("sapling")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.diseaseprefab =  SpawnPrefab("disease_fx_small")
		inst.diseaseprefab.entity:SetParent(inst.entity)
	end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_FUEL)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_sapling)
	inst.components.workable:SetWorkLeft(1)

    return inst
end

local function berrybushfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeSmallObstaclePhysics(inst, .1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("berrybush.png")

    inst.AnimState:SetBank("berrybush")
    inst.AnimState:SetBuild("berrybush_diseased_build")
    inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("plantdiseased")
	
	inst:SetPrefabNameOverride("berrybush")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.diseaseprefab =  SpawnPrefab("disease_fx_small")
		inst.diseaseprefab.entity:SetParent(inst.entity)
	end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_FUEL)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_berrybush)
	inst.components.workable:SetWorkLeft(1)

    return inst
end

local function berrybush2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeSmallObstaclePhysics(inst, .1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("berrybush2.png")

    inst.AnimState:SetBank("berrybush2")
    inst.AnimState:SetBuild("berrybush2_diseased_build")
    inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("plantdiseased")
	
	inst:SetPrefabNameOverride("berrybush")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.diseaseprefab =  SpawnPrefab("disease_fx_small")
		inst.diseaseprefab.entity:SetParent(inst.entity)
	end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_FUEL)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_berrybush2)
	inst.components.workable:SetWorkLeft(1)

    return inst
end

local function juicyfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeSmallObstaclePhysics(inst, .1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("berrybush_juicy.png")

    inst.AnimState:SetBank("berrybush_juicy")
    inst.AnimState:SetBuild("berrybush_juicy_diseased_build")
    inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("plantdiseased")
	
	inst:SetPrefabNameOverride("berrybush_juicy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.diseaseprefab =  SpawnPrefab("disease_fx_small")
		inst.diseaseprefab.entity:SetParent(inst.entity)
	end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_FUEL)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_berrybush_juicy)
	inst.components.workable:SetWorkLeft(1)

    return inst
end

local function moonsaplingfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("sapling_moon.png")

    inst.AnimState:SetBank("sapling_moon")
    inst.AnimState:SetBuild("sapling_diseased_moon")
    inst.AnimState:PlayAnimation("sway", true)

	inst:AddTag("plantdiseased")
	
	inst:SetPrefabNameOverride("sapling")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.diseaseprefab =  SpawnPrefab("disease_fx_small")
		inst.diseaseprefab.entity:SetParent(inst.entity)
	end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_FUEL)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_sapling)
	inst.components.workable:SetWorkLeft(1)

    return inst
end

local function stonebushfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeSmallObstaclePhysics(inst, .1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("rock_avocado.png")

    inst.AnimState:SetBank("rock_avocado")
    inst.AnimState:SetBuild("rock_avocado_diseased_build")
    inst.AnimState:PlayAnimation("idle3", true)
	inst.AnimState:Hide("SNOW")

	inst:AddTag("plantdiseased")
	
	inst:SetPrefabNameOverride("rock_avocado_bush")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.diseaseprefab =  SpawnPrefab("disease_fx_small")
		inst.diseaseprefab.entity:SetParent(inst.entity)
	end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_FUEL)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_avocado)
	inst.components.workable:SetWorkLeft(1)

    return inst
end

local function stoneplacefn(inst)
	inst.AnimState:Hide("SNOW")
end

return Prefab("sap_diseased_grass", grassfn, assets, prefabs),
Prefab("sap_diseased_sapling", saplingfn, assets, prefabs),
Prefab("sap_diseased_berrybush", berrybushfn, assets, prefabs),
Prefab("sap_diseased_berrybush2", berrybush2fn, assets, prefabs),
Prefab("sap_diseased_juicyberrybush", juicyfn, assets, prefabs),
Prefab("sap_diseased_moonsapling", moonsaplingfn, assets, prefabs),
Prefab("sap_diseased_stonebush", stonebushfn, assets, prefabs),
MakePlacer("sap_diseased_grass_placer", "grass", "grass_diseased_build", "idle"),
MakePlacer("sap_diseased_sapling_placer", "sapling", "sapling_diseased_build", "sway"),
MakePlacer("sap_diseased_berrybush_placer", "berrybush", "berrybush_diseased_build", "idle"),
MakePlacer("sap_diseased_berrybush2_placer", "berrybush2", "berrybush2_diseased_build", "idle"),
MakePlacer("sap_diseased_berrybush_juicy_placer", "berrybush_juicy", "berrybush_juicy_diseased_build", "idle"),
MakePlacer("sap_diseased_moonsapling_placer", "sapling_moon", "sapling_diseased_moon", "sway"),
MakePlacer("sap_diseased_stonebush_placer", "rock_avocado", "rock_avocado_diseased_build", "idle3", false, nil, nil, nil, nil, nil, stoneplacefn)