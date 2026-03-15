local assets =
{
    Asset("ANIM", "anim/flowers_rainforest.zip"), 
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "petals",
    "sap_exoticflower",
}

local DAYLIGHT_SEARCH_RANGE = 30

local names = {"f1","f2","f3","f4","f5","f6","f7","f8","f9","f10","f11","f12","f13","f14","f15","f16","f17"}

local function onsave(inst, data)
    data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname)
    end
end

local function onpickedfn(inst, picker)
    local pos = inst:GetPosition()

    if picker ~= nil then
        if picker.components.sanity ~= nil and not picker:HasTag("plantkin") then
            picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
        end
	end

    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("flowers_rainforest")
    inst.AnimState:SetBuild("flowers_rainforest")
    inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("flower")
    inst:AddTag("cattoy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname)

    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("petals", 10)
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = true
    inst.components.pickable.wildfirestarter = true

	inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("moonbutterfly_sapling")
	
	MakeHauntableChangePrefab(inst, "flower_evil")
    
    inst.OnSave = onsave
    inst.OnLoad = onload
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	MakeHauntableIgnite(inst)

    return inst
end

local function artificialfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("flowers_rainforest")
    inst.AnimState:SetBuild("flowers_rainforest")
    inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("exoticflower")
    inst:AddTag("cattoy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname)

    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("petals", 10)
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = true
    inst.components.pickable.wildfirestarter = true
	
	inst:AddComponent("halloweenmoonmutable")
	inst.components.halloweenmoonmutable:SetPrefabMutated("moonbutterfly_sapling")
	
	MakeHauntableChangePrefab(inst, "flower_evil")
    
    inst.OnSave = onsave
    inst.OnLoad = onload

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	MakeHauntableIgnite(inst)

    return inst
end

return Prefab("sap_exoticflower", fn, assets, prefabs),
Prefab("sap_artificial_exoticflower", artificialfn, assets, prefabs),
MakePlacer("sap_exoticflower_placer", "flowers_rainforest", "flowers_rainforest", "f6"),
MakePlacer("sap_artificial_exoticflower_placer", "flowers_rainforest", "flowers_rainforest", "f5")