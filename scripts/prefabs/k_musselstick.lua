require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/musselfarm.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"collapse_small"
}

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("small_to_full")
    inst.AnimState:PushAnimation("idle_full", true)
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.burnt then
        inst.components.burnable.onburnt(inst)
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
    minimap:SetIcon("kyno_mussel_stick.tex")

    inst.AnimState:SetBank("musselFarm")
    inst.AnimState:SetBuild("musselFarm")
    inst.AnimState:PlayAnimation("idle_full", true)
	
	-- inst:SetPhysicsRadiusOverride(0.8)
	-- MakeWaterObstaclePhysics(inst, 0.8, 1.2, 1.2)
	-- inst.Physics:SetDontRemoveOnSleep(true)

	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	-- inst:ListenForEvent("on_collide", OnCollide)

	inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end

return Prefab("kyno_musselfarm", fn, assets, prefabs),
MakePlacer("kyno_musselfarm_placer", "musselFarm", "musselFarm", "idle_full")