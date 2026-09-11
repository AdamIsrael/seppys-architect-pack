require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/coral_rock.zip"),
}

local prefabs =
{
	"rock_break_fx"
}

local function onwork1(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("low1", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("med1", true)
	else
		inst.AnimState:PlayAnimation("full1", true)
	end
end

local function onwork2(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("low2", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("med2", true)
	else
		inst.AnimState:PlayAnimation("full2", true)
	end
end

local function onwork3(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("low3", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("med3", true)
	else
		inst.AnimState:PlayAnimation("full3", true)
	end
end

local function onfinish_coral(inst, worker)
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

local function fn1()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_coral.tex")
	
	inst.AnimState:SetBank("coral_rock")
	inst.AnimState:SetBuild("coral_rock")
	inst.AnimState:PlayAnimation("full1", true)
	
	-- inst:SetPhysicsRadiusOverride(1)
	-- MakeWaterObstaclePhysics(inst, 0.80, 2, 1.25)
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork1)
	inst.components.workable:SetOnFinishCallback(onfinish_coral)

	-- inst:ListenForEvent("on_collide", OnCollide)

	return inst
end

local function fn2()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_coral.tex")
	
	inst.AnimState:SetBank("coral_rock")
	inst.AnimState:SetBuild("coral_rock")
	inst.AnimState:PlayAnimation("full2", true)
	
	-- inst:SetPhysicsRadiusOverride(1)
	-- MakeWaterObstaclePhysics(inst, 0.80, 2, 1.25)
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork2)
	inst.components.workable:SetOnFinishCallback(onfinish_coral)

	-- inst:ListenForEvent("on_collide", OnCollide)

	return inst
end

local function fn3()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_coral.tex")
	
	inst.AnimState:SetBank("coral_rock")
	inst.AnimState:SetBuild("coral_rock")
	inst.AnimState:PlayAnimation("full3", true)
	
	-- inst:SetPhysicsRadiusOverride(1)
	-- MakeWaterObstaclePhysics(inst, 0.80, 2, 1.25)
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork3)
	inst.components.workable:SetOnFinishCallback(onfinish_coral)

	-- inst:ListenForEvent("on_collide", OnCollide)

	return inst
end

return Prefab("sap_rock_coral_1", fn1, assets, prefabs),
Prefab("sap_rock_coral_2", fn2, assets, prefabs),
Prefab("sap_rock_coral_3", fn3, assets, prefabs),
MakePlacer("sap_rock_coral_1_placer", "coral_rock", "coral_rock", "full1"),
MakePlacer("sap_rock_coral_2_placer", "coral_rock", "coral_rock", "full2"),
MakePlacer("sap_rock_coral_3_placer", "coral_rock", "coral_rock", "full3")
