require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/buoy.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs = 
{
	"collapse_small",
}

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
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
	inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_buoy.tex")
	
	inst.Light:SetColour(223/255,246/255,255/255)
    inst.Light:Enable(true)
    inst.Light:SetIntensity(.75)
    inst.Light:SetFalloff(0.5)
	inst.Light:SetRadius(2)
	
	inst.AnimState:SetBank("buoy")
	inst.AnimState:SetBuild("buoy")
	inst.AnimState:PlayAnimation("idle", true)
	
	-- inst:SetPhysicsRadiusOverride(.2)
	-- MakeWaterObstaclePhysics(inst, .2, .2, .2)
	
	inst:AddTag("structure")
	inst:AddTag("buoy")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	
	MakeSnowCoveredPristine(inst)
	
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
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
 	
	MakeSnowCovered(inst, .01)	
	
	-- inst:ListenForEvent("on_collide", OnCollide)
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

return Prefab("sap_buoy", fn, assets, prefabs),
MakePlacer("sap_buoy_placer", "buoy", "buoy", "idle")