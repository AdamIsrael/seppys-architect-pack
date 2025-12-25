require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/graves_water.zip"),
    Asset("ANIM", "anim/graves_water_crate.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function setanim(inst, anim)
	inst.anim = anim
	inst.AnimState:PlayAnimation("idle" .. anim, true)
end

local function onsave(inst, data)
	data.anim = inst.anim
end

local function onload(inst, data)
	if data and data.anim then
		setanim(inst, data.anim)
	end
end


local function onhammered(inst)
	if inst:HasTag("fire") and not inst.components.burnable then
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
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
	minimap:SetIcon("kyno_crate.tex")
	
	inst.AnimState:SetBank("graves_water")
	inst.AnimState:SetBuild("graves_water")
	-- inst.AnimState:PlayAnimation("idle", true)
	setanim(inst, math.random(1, 5))
	
	-- inst:SetPhysicsRadiusOverride(0.3)
	-- MakeWaterObstaclePhysics(inst, 0.3, 0.3, 0.3)
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(1)
	
	-- inst:ListenForEvent("on_collide", OnCollide)
	
	inst.OnSave = onsave
	inst.OnLoad = onload

	return inst
end

return Prefab("kyno_watercrate", fn, assets, prefabs),
MakePlacer("kyno_watercrate_placer", "graves_water", "graves_water", "idle1")  