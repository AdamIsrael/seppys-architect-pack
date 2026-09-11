require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/shipwreck.zip"),
}

local prefabs =
{
	"collapse_big"
}

local MAST = 1
local BOW = 2
local MIDSHIP = 3
local STERN = 4

local anims =
{
	mast =
	{
		full = "idle_full1",
		empty = "idle_empty1",
		grow = "grow1",
		picked = "picked1",
		hitfull = "hit_full1",
		hitempty = "hit_empty1"
	},
	bow =
	{
		full = "idle_full2",
		empty = "idle_empty2",
		grow = "grow2",
		picked = "picked2",
		hitfull = "hit_full2",
		hitempty = "hit_empty2"
	},
	midship =
	{
		full = "idle_full3",
		empty = "idle_empty3",
		grow = "grow3",
		picked = "picked3",
		hitfull = "hit_full3",
		hitempty = "hit_empty3"
	},
	stern =
	{
		full = "idle_full4",
		empty = "idle_empty4",
		grow = "grow4",
		picked = "picked4",
		hitfull = "hit_full4",
		hitempty = "hit_empty4"
	},
}

local sizes =
{
	mast = 0.1,
	bow = 0.9, --1.6,
	midship = 0.9, --1.5,
	stern = 0.9 --1.5
}

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit_mast(inst, worker)
    inst.AnimState:PlayAnimation("hit_empty1")
    inst.AnimState:PushAnimation("idle_empty1")
end

local function onhit_bow(inst, worker)
    inst.AnimState:PlayAnimation("hit_empty2")
    inst.AnimState:PushAnimation("idle_empty2")
end

local function onhit_midship(inst, worker)
    inst.AnimState:PlayAnimation("hit_empty3")
    inst.AnimState:PushAnimation("idle_empty3")
end

local function onhit_stern(inst, worker)
    inst.AnimState:PlayAnimation("hit_empty4")
    inst.AnimState:PushAnimation("idle_empty4")
end

local function settype(inst, wrecktype)
	if type(wrecktype) == "number" or wrecktype == "random" then
		local types = {"mast", "bow", "midship", "stern"}
		inst.wrecktype = types[math.random(1, #types)]
	elseif wrecktype == "hull" then
		local hulls = {"bow", "midship", "stern"}
		inst.wrecktype = hulls[math.random(1, #hulls)]
	else
		inst.wrecktype = wrecktype
	end
	inst.AnimState:PlayAnimation(anims[inst.wrecktype].empty, true)
	-- inst.Physics:SetCapsule(sizes[inst.wrecktype], 2.0)
end

local function onsave(inst, data)
	data.wrecktype = inst.wrecktype
end

local function onload(inst, data)
	if data.wrecktype then
		settype(inst, data.wrecktype)
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

local function mastfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_wreck.tex")
	
	inst.AnimState:SetBank("shipwreck")
	inst.AnimState:SetBuild("shipwreck")
	inst.AnimState:PlayAnimation("idle_empty1", true)
	
	-- inst:SetPhysicsRadiusOverride(.1)
	-- MakeWaterObstaclePhysics(inst, .1, .1, .1)
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("structure")
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
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnWorkCallback(onhit_mast)
	inst.components.workable:SetOnFinishCallback(onhammered)

	-- MakeLargeBurnable(inst)
    -- MakeSmallPropagator(inst)
	
	settype(inst, "mast")

	inst.OnSave = onsave
	inst.OnLoad = onload
	
	-- inst:ListenForEvent("on_collide", OnCollide)

	return inst
end

local function bowfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_wreck.tex")
	
	inst.AnimState:SetBank("shipwreck")
	inst.AnimState:SetBuild("shipwreck")
	inst.AnimState:PlayAnimation("idle_empty2", true)
	
	-- inst:SetPhysicsRadiusOverride(1)
	-- MakeWaterObstaclePhysics(inst, 1, 1, 1)
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("structure")
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
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnWorkCallback(onhit_bow)
	inst.components.workable:SetOnFinishCallback(onhammered)

	-- MakeLargeBurnable(inst)
    -- MakeSmallPropagator(inst)
	
	settype(inst, "bow")

	inst.OnSave = onsave
	inst.OnLoad = onload
	
	-- inst:ListenForEvent("on_collide", OnCollide)

	return inst
end

local function midshipfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_wreck.tex")
	
	inst.AnimState:SetBank("shipwreck")
	inst.AnimState:SetBuild("shipwreck")
	inst.AnimState:PlayAnimation("idle_empty3", true)
	
	-- inst:SetPhysicsRadiusOverride(1)
	-- MakeWaterObstaclePhysics(inst, 1, 1, 1)
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("structure")
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
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnWorkCallback(onhit_midship)
	inst.components.workable:SetOnFinishCallback(onhammered)

	-- MakeLargeBurnable(inst)
    -- MakeSmallPropagator(inst)
	
	settype(inst, "midship")
	
	inst.OnSave = onsave
	inst.OnLoad = onload
	
	-- inst:ListenForEvent("on_collide", OnCollide)

	return inst
end

local function sternfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_wreck.tex")
	
	inst.AnimState:SetBank("shipwreck")
	inst.AnimState:SetBuild("shipwreck")
	inst.AnimState:PlayAnimation("idle_empty4", true)
	
	-- inst:SetPhysicsRadiusOverride(1)
	-- MakeWaterObstaclePhysics(inst, 1, 1, 1)
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("structure")
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
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnWorkCallback(onhit_stern)
	inst.components.workable:SetOnFinishCallback(onhammered)

	-- MakeLargeBurnable(inst)
    -- MakeSmallPropagator(inst)
	
	settype(inst, "stern")

	inst.OnSave = onsave
	inst.OnLoad = onload
	
	-- inst:ListenForEvent("on_collide", OnCollide)

	return inst
end

return Prefab("sap_wreck_1", mastfn, assets, prefabs),
Prefab("sap_wreck_2", bowfn, assets, prefabs),
Prefab("sap_wreck_3", midshipfn, assets, prefabs),
Prefab("sap_wreck_4", sternfn, assets, prefabs),
MakePlacer("sap_wreck_1_placer", "shipwreck", "shipwreck", "idle_empty1"),
MakePlacer("sap_wreck_2_placer", "shipwreck", "shipwreck", "idle_empty2"),
MakePlacer("sap_wreck_3_placer", "shipwreck", "shipwreck", "idle_empty3"),
MakePlacer("sap_wreck_4_placer", "shipwreck", "shipwreck", "idle_empty4")
