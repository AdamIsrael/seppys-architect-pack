require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/gingerbread_house1.zip"),
    Asset("ANIM", "anim/gingerbread_house2.zip"),
    Asset("ANIM", "anim/gingerbread_house3.zip"),
    Asset("ANIM", "anim/gingerbread_house4.zip"),
}

local prefabs =
{
    "wintersfeastfuel",
    "gingerdeadpig",
    "crumbs",
}

local animdata = 
{
    { build = "gingerbread_house1", bank = "gingerbread_house1" },
    { build = "gingerbread_house3", bank = "gingerbread_house2" },
    { build = "gingerbread_house2", bank = "gingerbread_house2" },
    { build = "gingerbread_house4", bank = "gingerbread_house1" },
}

local function sethousetype(inst, bank, build)
	if build == nil or bank == nil then
		local index = math.random(#animdata)
		inst.build = animdata[index].build
		inst.bank  = animdata[index].bank
	else
        inst.build = build
        inst.bank = bank
	end

    inst.AnimState:SetBuild(inst.build)
    inst.AnimState:SetBank(inst.bank)
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end

    local x, y, z = inst.Transform:GetWorldPosition()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(x, y, z)
    fx:SetMaterial("wood")

    if not inst:HasTag("burnt") then
        inst.components.lootdropper:DropLoot()
        if math.random() < 0.3 then
            local gingerdeadman = SpawnPrefab("gingerdeadpig")
            gingerdeadman.Transform:SetPosition(x, y, z)
            inst.components.lootdropper:SpawnLootPrefab("wintersfeastfuel", Point(x,y,z))
        end
    end

    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then 
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
    end
end

local function OnSave(inst, data)
    data.build = inst.build
    data.bank = inst.bank
end

local function OnLoad(inst, data)
	sethousetype(inst, data ~= nil and data.bank, data ~= nil and data.build)
end

local function fn1()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("gingerbread_house1")
    inst.AnimState:SetBuild("gingerbread_house1")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
	inst:AddTag("gingerbreadhouse")
	
	inst:SetPrefabNameOverride("gingerbreadhouse")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("inspectable")

    MakeSnowCovered(inst)

    MakeSmallBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("gingerbread_house2")
    inst.AnimState:SetBuild("gingerbread_house2")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
	inst:AddTag("gingerbreadhouse")
	
	inst:SetPrefabNameOverride("gingerbreadhouse")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("inspectable")

    MakeSnowCovered(inst)

    MakeSmallBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)

    return inst
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("gingerbread_house2")
    inst.AnimState:SetBuild("gingerbread_house3")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
	inst:AddTag("gingerbreadhouse")
	
	inst:SetPrefabNameOverride("gingerbreadhouse")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("inspectable")

    MakeSnowCovered(inst)

    MakeSmallBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)

    return inst
end

local function fn4()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("gingerbread_house1")
    inst.AnimState:SetBuild("gingerbread_house4")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
	inst:AddTag("gingerbreadhouse")
	
	inst:SetPrefabNameOverride("gingerbreadhouse")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("inspectable")

    MakeSnowCovered(inst)

    MakeSmallBurnable(inst, nil, nil, true)
    MakeMediumPropagator(inst)

    return inst
end

return Prefab("sap_gingerbreadhouse1", fn1, assets, prefabs),
Prefab("sap_gingerbreadhouse2", fn2, assets, prefabs),
Prefab("sap_gingerbreadhouse3", fn3, assets, prefabs),
Prefab("sap_gingerbreadhouse4", fn4, assets, prefabs),
MakePlacer("sap_gingerbreadhouse1_placer", "gingerbread_house1", "gingerbread_house1", "idle"),
MakePlacer("sap_gingerbreadhouse2_placer", "gingerbread_house2", "gingerbread_house2", "idle"),
MakePlacer("sap_gingerbreadhouse3_placer", "gingerbread_house2", "gingerbread_house3", "idle"),
MakePlacer("sap_gingerbreadhouse4_placer", "gingerbread_house1", "gingerbread_house4", "idle")