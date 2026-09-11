require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/brain_coral_rock.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"collapse_small"
}

local CORALSTATE =
{
	FULL = "_full",
	PICKED = "_picked",
	GLOW = "_glow",
}

local min_rad = 2.5
local max_rad = 3
local min_falloff = 0.8
local max_falloff = 0.7
local min_intensity = 0.8
local max_intensity = 0.7

local function pulse_light(inst)
    local s = GetSineVal(0.05, true, inst)
    local rad = Lerp(min_rad, max_rad, s)
    local intentsity = Lerp(min_intensity, max_intensity, s)
    local falloff = Lerp(min_falloff, max_falloff, s)
    inst.Light:SetFalloff(falloff)
    inst.Light:SetIntensity(intentsity)
    inst.Light:SetRadius(rad)
end

local function turnon(inst, time)
    inst.Light:Enable(true)

    local s = GetSineVal(0.05, true, inst, time)
    local rad = Lerp(min_rad, max_rad, s)
    local intentsity = Lerp(min_intensity, max_intensity, s)
    local falloff = Lerp(min_falloff, max_falloff, s)

    local startpulse = function()
    	inst.light_pulse = inst:DoPeriodicTask(0.1, pulse_light)
	end

    inst.components.lighttweener:StartTween(inst.Light, rad, intentsity, falloff, nil, time, startpulse)
end

local function turnoff(inst, time)
	if inst.light_pulse then
		inst.light_pulse:Cancel()
		inst.light_pulse = nil
	end

	local lightoff = function() inst.Light:Enable(false) end

    inst.components.lighttweener:StartTween(inst.Light, 0, 0, nil, nil, time, lightoff)
end

local function OnIsDusk(inst, isdusk)
	if isdusk then
		turnon(inst, 5)
		inst.AnimState:PushAnimation("idle_full", true)
	end
end

local function OnIsDay(inst, isday)
	if isday then
		turnoff(inst, 5)
		inst.AnimState:PushAnimation("idle_full", true)
	end
end

local function onhammered(inst, worker)
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst)
	inst.AnimState:PlayAnimation("hit_full")
	inst.AnimState:PushAnimation("idle_full", true)
end

local function sanityaurafn(inst, observer)
	if inst.coralstate == CORALSTATE.GLOW then
		return TUNING.SANITYAURA_SMALL
	else
		return 0
	end
end

local function onsave(inst, data)
	data.coralstate = inst.coralstate
end

local function onload(inst, data)
	inst.coralstate = data and data.coralstate or CORALSTATE.FULL

	if inst.coralstate == CORALSTATE.GLOW then
	    inst.AnimState:PlayAnimation("glow_pre")
    	inst.AnimState:PushAnimation("idle_full", true)
		turnon(inst, 0)
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
	inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_brain.tex")
	
	inst.Light:SetColour(210/255, 247/255, 228/255)
    inst.Light:Enable(false)
    inst.Light:SetIntensity(0)
    inst.Light:SetFalloff(0.7)
	
	inst.AnimState:SetBank("brain_coral_rock")
	inst.AnimState:SetBuild("brain_coral_rock")
	inst.AnimState:PlayAnimation("idle_full", true)
	
	-- inst:SetPhysicsRadiusOverride(1)
	-- MakeWaterObstaclePhysics(inst, 0.80, 2, 1.25)
	
	inst:AddTag("structure")
	inst:AddTag("brain")
	inst:AddTag("rock")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	inst:AddComponent("lighttweener")
	inst:AddTag("ignorewalkableplatforms")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aurafn = sanityaurafn
	
	inst:WatchWorldState("isday", OnIsDay)
	inst:WatchWorldState("isdusk", OnIsDusk)
	
	-- inst:ListenForEvent("on_collide", OnCollide)

	inst.OnSave = onsave
	inst.OnLoad = onload
	
	MakeSnowCovered(inst, .01)

	return inst
end

return Prefab("sap_brain_rock", fn, assets, prefabs),
MakePlacer("sap_brain_rock_placer", "brain_coral_rock", "brain_coral_rock", "idle_full")
