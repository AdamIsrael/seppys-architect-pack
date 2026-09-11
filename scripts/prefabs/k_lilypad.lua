local assets =
{
	Asset("ANIM", "anim/lily_pad.zip"),
	Asset("ANIM", "anim/splash.zip"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst:Remove()
end

local function OnSpawned(inst, child)
	if inst.components.childspawner.childname == "frog_poison" then
	 	inst.SoundEmitter:PlaySound("dontstarve_DLC003/movement/water/small_submerge")		
		child.sg:GoToState("submerge")
	end
end

local function refreshimage(inst)
	inst.AnimState:PlayAnimation(inst.size.."_idle", true)

	if inst.size == "small" then
		-- MakeWaterObstaclePhysics(inst, 2, 2)
		inst:AddTag("lily_pad_small")
	elseif inst.size == "med" then
		-- MakeWaterObstaclePhysics(inst, 3, 3)
		inst:AddTag("lily_pad_medium")
	elseif inst.size == "big" then
		-- MakeWaterObstaclePhysics(inst, 4.2, 4.2)
		inst:AddTag("lily_pad_big")
	end
end

local function onload(inst, data)
	if data then
		if data.size then
			inst.size = data.size
		end
	end
		
	refreshimage(inst)
end

local function onsave(inst, data)
	data.size= inst.size
	data.rotation = inst.rotation
end

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.SEASTACK_MINE)
    end
end

local function fn(pondtype)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_lilypad.tex")
    
	inst.pondtype = pondtype

    inst.AnimState:SetBuild("lily_pad")
    inst.AnimState:SetBank("lily_pad")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

	inst.size = "small"
	
    if math.random() < 0.40 then
		inst.size = "small"
	elseif math.random() < 0.60 then
		inst.size = "med"
	elseif math.random() < 0.80 then
		inst.size = "big"
	end
	
    refreshimage(inst)
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
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
	inst.components.workable:SetOnWorkCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("savedrotation")
	
	-- inst:ListenForEvent("on_collide", OnCollide)

	inst.OnLoad = onload
	inst.OnSave = onsave

	return inst
end

return Prefab("sap_lilypad", fn, assets, prefabs),
MakePlacer("sap_lilypad_placer", "lily_pad", "lily_pad", "med_idle", true, nil, nil, nil, 90, nil)
