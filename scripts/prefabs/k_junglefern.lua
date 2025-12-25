require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/fern_plant.zip"),
    Asset("ANIM", "anim/fern2_plant.zip"),
	Asset("ANIM", "anim/jungle_bush.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "foliage",
	"succulent_picked",
}

local function onsave(inst, data)
	data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
			inst.AnimState:PlayAnimation("idle")
		else
			inst.AnimState:PlayAnimation("idle2")
	end
end

local function onpicked(inst)
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local color = 0.7 + math.random() * 0.3
	inst.AnimState:SetMultColour(color, color, color, 1)  

    inst.AnimState:SetBank("fern_plant")
    inst.AnimState:SetBuild("fern_plant")
    inst.AnimState:SetRayTestOnBB(true)
	if math.random()<0.5 then
        inst.AnimState:PlayAnimation("idle")
    else
        inst.AnimState:PlayAnimation("idle2")
    end

	inst:AddTag("notarget")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("foliage")
    inst.components.pickable.onpickedfn = onpicked

    inst.components.pickable.quickpick = true

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

local function fernfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local color = 0.7 + math.random() * 0.3
	inst.AnimState:SetMultColour(color, color, color, 1)  

    inst.AnimState:SetBank("fern2_plant")
    inst.AnimState:SetBuild("fern2_plant")
	inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("notarget")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("succulent_picked")
    inst.components.pickable.onpickedfn = onpicked

    inst.components.pickable.quickpick = true

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

local function redfernfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
	
	local color = 0.7 + math.random() * 0.3
	inst.AnimState:SetMultColour(color, color, color, 1)  

    inst.AnimState:SetBank("jungle_bush")
    inst.AnimState:SetBuild("jungle_bush")
	inst.AnimState:PlayAnimation("idle_dead", true)
    inst.AnimState:SetRayTestOnBB(true)

	inst:AddTag("notarget")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("foliage")
    inst.components.pickable.onpickedfn = onpicked

    inst.components.pickable.quickpick = true

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

local function fernplacer(inst)
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
end

return Prefab("kyno_junglefern", fn, assets, prefabs),
MakePlacer("kyno_junglefern_placer", "fern_plant", "fern_plant", "idle2"),

Prefab("kyno_junglefern_green", fernfn, assets, prefabs),
MakePlacer("kyno_junglefern_green_placer", "fern2_plant", "fern2_plant", "idle"),

Prefab("kyno_redfern", redfernfn, assets, prefabs),
MakePlacer("kyno_redfern_placer", "jungle_bush", "jungle_bush", "idle_dead", false, nil, nil, nil, nil, nil, fernplacer)