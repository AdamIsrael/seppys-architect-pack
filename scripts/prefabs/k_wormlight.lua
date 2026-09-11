local assets =
{
    Asset("ANIM", "anim/worm.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
    Asset("SOUND", "sound/common.fsb"),
}

local prefabs =
{
    "wormlight_lesser",
	"wormlight",
}

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("berry_idle", true)
    inst:DoTaskInTime(8*FRAMES, function()
        inst.Light:Enable(true)
    end)
	inst:AddTag("has_berrie")
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("picking")
    inst.AnimState:PushAnimation("picked")
    inst.Light:Enable(false)
	inst:RemoveTag("has_berrie")
end

local function onpickedfn(inst)
    inst.AnimState:PlayAnimation("picking")
    inst.AnimState:PushAnimation("picked")
    inst.Light:Enable(false)
	inst:RemoveTag("has_berrie")
end

local function dig_up(inst, chopper)
	if inst:HasTag("has_berrie") then
		inst.components.lootdropper:SpawnLootPrefab("wormlight_lesser")
		inst.components.lootdropper:SpawnLootPrefab("poop")
		inst:Remove()
	else
		inst.components.lootdropper:SpawnLootPrefab("poop")
		inst:Remove()
	end
end

local function CustomOnHaunt(inst)
	inst:Remove()
	SpawnPrefab("worm").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Transform:SetTwoFaced()

	inst.Light:SetRadius(1.5)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetColour(1,1,1)
    inst.Light:Enable(true)

    inst.AnimState:SetBank("worm")
    inst.AnimState:SetBuild("worm")
    inst.AnimState:PlayAnimation("berry_idle", true)

	inst:AddTag("plant")
	inst:AddTag("structure")
	inst:AddTag("has_berrie")
	
	inst:SetPrefabNameOverride("wormlight_plant")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.Transform:SetRotation(math.random()*360)
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
    inst.components.pickable:SetUp("wormlight_lesser", TUNING.WORMLIGHT_PLANT_REGROW_TIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	AddHauntableCustomReaction(inst, CustomOnHaunt, true, nil, true)
	
    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)

    return inst
end

local function realfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Transform:SetTwoFaced()

	inst.Light:SetRadius(1.5)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetColour(1,1,1)
    inst.Light:Enable(true)

    inst.AnimState:SetBank("worm")
    inst.AnimState:SetBuild("worm")
    inst.AnimState:PlayAnimation("berry_idle", true)

	inst:AddTag("plant")
	inst:AddTag("structure")
	inst:AddTag("has_berrie")
	
	inst:SetPrefabNameOverride("wormlight_plant")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.Transform:SetRotation(math.random()*360)
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
    inst.components.pickable:SetUp("wormlight", TUNING.WORMLIGHT_PLANT_REGROW_TIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	AddHauntableCustomReaction(inst, CustomOnHaunt, true, nil, true)
	
    MakeMediumBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)

    return inst
end

return Prefab("sap_wormlight", fn, assets, prefabs),
Prefab("sap_wormlight_real", realfn, assets, prefabs),
MakePlacer("sap_wormlight_placer", "worm", "worm", "berry_idle")