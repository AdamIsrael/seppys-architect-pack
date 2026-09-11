require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/sea_cocoon.zip"),

	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),

	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "rock_break_fx",
    "rocks",
	"guano",
}

local function OnWork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("low", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("med", true)
	else
		inst.AnimState:PlayAnimation("full", true)
	end
end

local function OnWorked(inst, worker)
	inst.AnimState:PlayAnimation("break")

	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)

	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())

	inst:ListenForEvent("animover", inst.Remove)
end

local function OnWorked2(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)

	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())

	inst:Remove()
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

	inst:SetPhysicsRadiusOverride(2.35)
    MakeWaterObstaclePhysics(inst, 0.80, 2, 1.25)

	MakeInventoryFloatable(inst, "med", nil, 0.85)
    inst.components.floater.bob_percent = 0

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_sea_cocoon.tex")

    inst.AnimState:SetBank("sea_cocoon")
    inst.AnimState:SetBuild("sea_cocoon")
    inst.AnimState:PlayAnimation("full")

    inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	local land_time = (POPULATING and math.random()*5*FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)

    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.SEASTACK_MINE)
    inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable:SetOnFinishCallback(OnWorked)
    inst.components.workable.savestate = true

    MakeHauntableWork(inst)

    inst:ListenForEvent("on_collide", OnCollide)

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst:SetPhysicsRadiusOverride(2.35)
    MakeWaterObstaclePhysics(inst, 0.80, 2, 1.25)

	MakeInventoryFloatable(inst, "med", nil, 0.85)
    inst.components.floater.bob_percent = 0

    inst.AnimState:SetBank("sea_cocoon")
    inst.AnimState:SetBuild("sea_cocoon")

    inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	local land_time = (POPULATING and math.random()*5*FRAMES) or 0
    inst:DoTaskInTime(land_time, function(inst)
        inst.components.floater:OnLandedServer()
    end)

    inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SEA_COCOON"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(TUNING.SEASTACK_MINE)
	inst.components.workable:SetOnFinishCallback(OnWorked2)

    MakeHauntableWork(inst)

    inst:ListenForEvent("on_collide", OnCollide)

    return inst
end

local function deco1()
    local inst = fn2()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_sea_cocoon_1.tex")

    inst.AnimState:PlayAnimation("deco1")

    return inst
end

local function deco2()
    local inst = fn2()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_sea_cocoon_2.tex")

    inst.AnimState:PlayAnimation("deco2")

    return inst
end

local function deco3()
    local inst = fn2()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_sea_cocoon_3.tex")

    inst.AnimState:PlayAnimation("deco3")

    return inst
end

return Prefab("sap_sea_cocoon", fn, assets, prefabs),
Prefab("sap_sea_cocoon_1", deco1, assets, prefabs),
Prefab("sap_sea_cocoon_2", deco2, assets, prefabs),
Prefab("sap_sea_cocoon_3", deco3, assets, prefabs),
MakePlacer("sap_sea_cocoon_placer", "sea_cocoon", "sea_cocoon", "full"),
MakePlacer("sap_sea_cocoon_1_placer", "sea_cocoon", "sea_cocoon", "deco1"),
MakePlacer("sap_sea_cocoon_2_placer", "sea_cocoon", "sea_cocoon", "deco2"),
MakePlacer("sap_sea_cocoon_3_placer", "sea_cocoon", "sea_cocoon", "deco3")