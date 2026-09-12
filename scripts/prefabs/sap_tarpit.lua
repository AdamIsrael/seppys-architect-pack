require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/tar_pit.zip"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:SpawnLootPrefab("ash")
	inst.components.lootdropper:SpawnLootPrefab("boneshard")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("idle", true)
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
	minimap:SetIcon("kyno_tarbubble.tex")
	
	inst.AnimState:SetBank("tar_pit")
	inst.AnimState:SetBuild("tar_pit")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	
	-- inst:SetPhysicsRadiusOverride(1)
	-- MakeWaterObstaclePhysics(inst, 1, 1, 1)
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("tar_pit")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	-- inst:ListenForEvent("on_collide", OnCollide)

	return inst
end

return Prefab("sap_tarpit", fn, assets, prefabs),
MakePlacer("sap_tarpit_placer", "tar_pit", "tar_pit", "idle")
