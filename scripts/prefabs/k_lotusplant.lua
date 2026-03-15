require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/lotus.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "sap_lotus_flower",
}

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("turnoftides/common/together/water/harvest_plant")
    inst.AnimState:PlayAnimation("picking")
    inst.AnimState:PushAnimation("picked", true)
	inst:AddTag("nolotus")
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle_plant", true)
	inst:RemoveTag("nolotus")
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("picked", true)
	inst:AddTag("nolotus")
end

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("kelp")
	inst.components.lootdropper:SpawnLootPrefab("petals")
	inst.components.lootdropper:SpawnLootPrefab("petals")
	inst:Remove()
end

local function WakeUp(inst, isday)
	if isday and not inst:HasTag("nolotus") then
		inst.AnimState:PlayAnimation("open")
		inst.AnimState:PushAnimation("idle_plant", true)
	end
end

local function Sleep(inst, isdusk)
	if isdusk and not inst:HasTag("nolotus") then
		inst.AnimState:PlayAnimation("close")
		inst.AnimState:PushAnimation("idle_plant_close", true)
	end
end

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.SEASTACK_MINE)
    end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_lotusplant.tex")
	
	inst.AnimState:SetBank("lotus")
	inst.AnimState:SetBuild("lotus")
	inst.AnimState:PlayAnimation("idle_plant", true)
	
	-- inst:SetPhysicsRadiusOverride(.25)
	-- MakeWaterObstaclePhysics(inst, .25, .25)
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("structure")
	inst:AddTag("lotus")
	inst:AddTag("aquatic")
	inst:AddTag("plant")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst.AnimState:SetTime(math.random() * 2)

    local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "turnoftides/common/together/water/harvest_plant"
    inst.components.pickable:SetUp("sap_lotus_flower", TUNING.LICHEN_REGROW_TIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	
	inst:DoTaskInTime(1/30, function()
	inst:WatchWorldState("isday", WakeUp)
    WakeUp(inst, TheWorld.state.isday)
	end)
	
	inst:DoTaskInTime(1/30, function()
	inst:WatchWorldState("isdusk", Sleep)
    Sleep(inst, TheWorld.state.isdusk)
	end)
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeNoGrowInWinter(inst)
    MakeHauntableIgnite(inst)

	return inst
end

return Prefab("sap_lotusplant", fn, assets, prefabs),
MakePlacer("sap_lotusplant_placer", "lotus", "lotus", "idle_plant")