require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/ballphin_house.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUND", "sound/pig.fsb"),
}

local function LightsOn(inst)
    if not inst:HasTag("burnt") then
        inst.Light:Enable(true)
        inst.AnimState:PlayAnimation("lit", true)
        inst.lightson = true
    end
end

local function LightsOff(inst)
	inst.Light:Enable(false)
	inst.AnimState:PlayAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lightoff")
	inst.lightson = false
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
if not inst:HasTag("burnt") then
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")
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
	local light = inst.entity:AddLight()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	light:SetFalloff(1)
    light:SetIntensity(.5)
    light:SetRadius(2)
    light:Enable(false)
	light:SetColour(0/255, 180/255, 255/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_ballphinhouse.tex")
	
	inst.AnimState:SetBank("ballphin_house")
	inst.AnimState:SetBuild("ballphin_house")
	inst.AnimState:PlayAnimation("idle", true)
	
	-- inst:SetPhysicsRadiusOverride(1.5)
	-- MakeWaterObstaclePhysics(inst, 1.5, 1.5)
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	
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
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	-- inst:ListenForEvent("on_collide", OnCollide)
	
	 MakeSnowCovered(inst, .01)

	return inst
end

return Prefab("kyno_ballphinhouse", fn, assets, prefabs),
MakePlacer("kyno_ballphinhouse_placer", "ballphin_house", "ballphin_house", "idle")  