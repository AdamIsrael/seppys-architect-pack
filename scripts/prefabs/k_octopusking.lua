require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/octopus.zip"),
}

local prefabs =
{
	"collapse_big"
}

local function WakeUp(inst)
	inst.AnimState:PlayAnimation("sleep_pst")
	inst.AnimState:PushAnimation("idle", true)
end

local function Sleep(inst)
	inst.AnimState:PlayAnimation("sleep_pre")
	inst.AnimState:PushAnimation("sleep_loop", true)
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
if not inst:HasTag("burnt") then
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:PushAnimation("idle", true)
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle", true)
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
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_octopusking.tex")
	minimap:SetPriority(5)
	
	inst.DynamicShadow:SetSize(10, 5)
	
	inst.AnimState:SetBank("octopus")
	inst.AnimState:SetBuild("octopus")
	inst.AnimState:PlayAnimation("idle", true)
	
	-- inst:SetPhysicsRadiusOverride(2)
	-- MakeWaterObstaclePhysics(inst, 2, 2)
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3, 5)
    inst.components.playerprox:SetOnPlayerNear(WakeUp)
    inst.components.playerprox:SetOnPlayerFar(Sleep)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	-- inst:ListenForEvent("on_collide", OnCollide)

	return inst
end

return Prefab("sap_octopusking", fn, assets, prefabs),
MakePlacer("sap_octopusking_placer", "octopus", "octopus", "idle")  
