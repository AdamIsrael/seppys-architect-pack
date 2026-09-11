local assets =
{
    Asset("ANIM", "anim/grass.zip"),
    Asset("ANIM", "anim/reeds.zip"),
}

local prefabs =
{
    "cutreeds",
}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("cutreeds")
	inst:Remove()
end

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.AnimState:PlayAnimation("picking")
    inst.AnimState:PushAnimation("picked")
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("picked")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("reeds.png")

    inst.AnimState:SetBank("grass")
    inst.AnimState:SetBuild("reeds")
    inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("plant")
	inst:AddTag("silviculture")
	
	inst:SetPrefabNameOverride("reeds")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)
    local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
    inst.components.pickable:SetUp("cutreeds", TUNING.REEDS_REGROW_TIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    inst.components.pickable.SetRegenTime = 120

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_FUEL)
    MakeSmallPropagator(inst)
    MakeNoGrowInWinter(inst)
    MakeHauntableIgnite(inst)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

    return inst
end

return Prefab("sap_reeds", fn, assets, prefabs),
MakePlacer("sap_reeds_placer", "grass", "reeds", "idle")