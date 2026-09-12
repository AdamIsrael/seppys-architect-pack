require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/potted_mushrooms.zip"),
	Asset("ANIM", "anim/potted_cacti.zip"),
	Asset("ANIM", "anim/potted_flowers.zip"),
	Asset("ANIM", "anim/potted_evilflowers.zip"),
	Asset("ANIM", "anim/potted_roses.zip"),
}

local prefabs =
{
    "collapse_small",
}

local function onsave(inst, data)
    data.anim = inst.animname
end

local function onload(inst, data)
    if data ~= nil and data.anim ~= nil then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname)
    end
end

local function onhammered(inst)
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("pot")
    inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function common()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetRayTestOnBB(true)
	
	inst:AddTag("structure")
	inst:AddTag("potted_plant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onhammered)

    MakeHauntableWork(inst)
    MakeHauntableWork(inst)

    inst.OnSave = onsave 
    inst.OnLoad = onload 

    return inst
end

local function blue()
    local inst = common()
	
    inst.AnimState:SetBank("potted_mushrooms")
    inst.AnimState:SetBuild("potted_mushrooms")
	
	inst.animname = "bm" .. tostring(math.random(3))
	inst.AnimState:PlayAnimation(inst.animname)
    return inst
end

local function green()
    local inst = common()
	
    inst.AnimState:SetBank("potted_mushrooms")
    inst.AnimState:SetBuild("potted_mushrooms")
	
	inst.animname = "gm" .. tostring(math.random(3))
	inst.AnimState:PlayAnimation(inst.animname)
	
	inst:SetPrefabNameOverride("sap_pottedbluemushroom")
	
    return inst
end

local function red()
    local inst = common()
	
    inst.AnimState:SetBank("potted_mushrooms")
    inst.AnimState:SetBuild("potted_mushrooms")
	
	inst.animname = "rm" .. tostring(math.random(3))
	inst.AnimState:PlayAnimation(inst.animname)
	
	inst:SetPrefabNameOverride("sap_pottedbluemushroom")
	
    return inst
end

local function cactus()
    local inst = common()
	
    inst.AnimState:SetBank("potted_cacti")
    inst.AnimState:SetBuild("potted_cacti")
	
	inst.animname = "c" .. tostring(math.random(5))
	inst.AnimState:PlayAnimation(inst.animname)
	
    return inst
end

local function flower()
    local inst = common()
	
    inst.AnimState:SetBank("potted_flowers")
    inst.AnimState:SetBuild("potted_flowers")
	
	inst.animname = "pf" .. tostring(math.random(9))
	inst.AnimState:PlayAnimation(inst.animname)
	
    return inst
end

local function evilflower()
    local inst = common()
	
    inst.AnimState:SetBank("potted_evilflowers")
    inst.AnimState:SetBuild("potted_evilflowers")
	
	inst.animname = "ef" .. tostring(math.random(8))
	inst.AnimState:PlayAnimation(inst.animname)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inspectable.nameoverride = "KYNO_POTTEDFLOWER"
	
    return inst
end

local function rose()
    local inst = common()
	
    inst.AnimState:SetBank("potted_roses")
    inst.AnimState:SetBuild("potted_roses")
	
	inst.animname = "pr" .. tostring(math.random(7))
	inst.AnimState:PlayAnimation(inst.animname)
	
    return inst
end

return Prefab("sap_pottedbluemushroom", blue, assets, prefabs),
Prefab("sap_pottedgreenmushroom", green, assets, prefabs),
Prefab("sap_pottedredmushroom", red, assets, prefabs),
Prefab("sap_pottedcactus", cactus, assets, prefabs),
Prefab("sap_pottedflower", flower, assets, prefabs),
Prefab("sap_pottedevilflower", evilflower, assets, prefabs),
Prefab("sap_pottedrose", rose, assets, prefabs),
MakePlacer("sap_pottedbluemushroom_placer", "potted_mushrooms", "potted_mushrooms", "bm1"),
MakePlacer("sap_pottedgreenmushroom_placer", "potted_mushrooms", "potted_mushrooms", "gm1"),
MakePlacer("sap_pottedredmushroom_placer", "potted_mushrooms", "potted_mushrooms", "rm1"),
MakePlacer("sap_pottedcactus_placer", "potted_cacti", "potted_cacti", "c1"),
MakePlacer("sap_pottedflower_placer", "potted_flowers", "potted_flowers", "pf1"),
MakePlacer("sap_pottedevilflower_placer", "potted_evilflowers", "potted_evilflowers", "ef1"),
MakePlacer("sap_pottedrose_placer", "potted_roses", "potted_roses", "pr1")