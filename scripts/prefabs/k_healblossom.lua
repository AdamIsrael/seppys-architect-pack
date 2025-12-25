local assets =
{
    Asset("ANIM", "anim/lavaarena_heal_flowers_fx.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "petals",
	"nightmarefuel",
    "kyno_healblossom",
}

local DAYLIGHT_SEARCH_RANGE = 30

local names_grow = {"in_1", "in_2", "in_3", "in_4", "in_5", "in_6"}
local names = {"idle_1", "idle_2", "idle_3", "idle_4", "idle_5", "idle_6"}

local function onsave(inst, data)
    data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname, true)
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

local function onbuilt(inst)
	inst.animnamegrow = names_grow[math.random(#names_grow)]
	inst.AnimState:PlayAnimation(inst.animnamegrow)
	inst.AnimState:PushAnimation(inst.animname, true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("lavaarena_heal_flowers")
    inst.AnimState:SetBuild("lavaarena_heal_flowers_fx", true)
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
	inst.components.inspectable.nameoverride = "FLOWER"

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
	
    inst.AnimState:SetBank("lavaarena_heal_flowers")
    inst.AnimState:SetBuild("lavaarena_heal_flowers_fx", true)
    inst.AnimState:SetRayTestOnBB(true)

    inst:AddTag("structure")
	inst:AddTag("flowerheal")
    inst:AddTag("cattoy")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname)

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "FLOWER"

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

local function healflowerplacetestfn(inst)
	inst.AnimState:Hide("drop")
end

return Prefab("kyno_healflower", fn, assets, prefabs),
Prefab("kyno_artificial_healflower", artificialfn, assets, prefabs),
MakePlacer("kyno_healflower_placer", "lavaarena_heal_flowers", "lavaarena_heal_flowers_fx", "idle_1", false, nil, nil, nil, nil, nil, healflowerplacetestfn),
MakePlacer("kyno_artificial_healflower_placer", "lavaarena_heal_flowers", "lavaarena_heal_flowers_fx", "idle_4", false, nil, nil, nil, nil, nil, healflowerplacetestfn)