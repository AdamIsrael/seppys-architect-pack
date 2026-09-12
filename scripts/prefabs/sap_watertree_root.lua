require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/watertree_root.zip"),
}

local prefabs =
{
    "driftwood_log",
    "twigs",
}

local NUM_ART_TYPES = 3

local function UpdateArt(inst)
    inst.AnimState:PlayAnimation("idle"..inst.artid, true)
end

local function OnWork(inst, worker, workleft)
    if worker == nil or not worker:HasTag("playerghost") then
        inst.SoundEmitter:PlaySound((worker == nil and "dontstarve/wilson/use_axe_tree")
		or (worker:HasTag("boat") and "waterlogged1/common/boat_wood_small_impact")
		or (worker:HasTag("beaver") and "dontstarve/characters/woodie/beaver_chop_tree")
		or "dontstarve/wilson/use_axe_tree")
    end

   inst.AnimState:PlayAnimation("hit"..inst.artid)
   inst.AnimState:PushAnimation("idle"..inst.artid, true)

    if workleft <= 0 then
        local fx = SpawnPrefab("collapse_small")
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())

        inst:SetPhysicsRadiusOverride(nil)
        local pt = inst:GetPosition()
        inst.components.lootdropper:DropLoot(pt)

        inst:Remove()
    end
end

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.EVERGREEN_CHOPS_SMALL)
    end
end

local function OnSave(inst, data)
    data.artid = inst.artid
end

local function OnLoad(inst, data)
    inst.artid = (data and data.artid) or inst.artid or math.random(NUM_ART_TYPES)
    UpdateArt(inst)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst:SetPhysicsRadiusOverride(2.35)
    MakeWaterObstaclePhysics(inst, 0.80, 2, 0.75)

    inst.AnimState:SetBank("watertree_root")
    inst.AnimState:SetBuild("watertree_root")
    inst.AnimState:PlayAnimation("idle1",true)
	
	inst:AddTag("ignorewalkableplatforms")
    inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("watertree_root")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "WATERTREE_ROOT"

    inst:AddComponent("lootdropper")
    inst.components.lootdropper.max_speed = 2
    inst.components.lootdropper.min_speed = 0.3
    inst.components.lootdropper.y_speed = 14
    inst.components.lootdropper.y_speed_variance = 4
    inst.components.lootdropper.spawn_loot_inside_prefab = true

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(TUNING.WATERTREE_ROOT_CHOPS)
    inst.components.workable:SetOnWorkCallback(OnWork)
    inst.components.workable.savestate = true

    MakeHauntableWork(inst)
    inst:ListenForEvent("on_collide", OnCollide)

    if not POPULATING then
        inst.artid = math.random(NUM_ART_TYPES)
        UpdateArt(inst)
    end

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("sap_watertree_root", fn, assets, prefabs),
MakePlacer("sap_watertree_root_placer", "watertree_root", "watertree_root", "idle1")