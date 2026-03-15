require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/icemachine.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs =
{
	"collapse_small",
	"ice",
}

local MACHINESTATES =
{
	ON = "_on",
	OFF = "_off",
}

local ICEMAKER_FUEL_MAX = 90
local ICEMAKER_SPAWN_TIME = 30

local function spawnice(inst)
	inst:RemoveEventCallback("animover", spawnice)

    local ice = SpawnPrefab("ice")
    local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0,2,0)
    ice.Transform:SetPosition(pt:Get())
    local down = TheCamera:GetDownVec()
    local angle = math.atan2(down.z, down.x) + (math.random()*60)*DEGREES
    local sp = 3 + math.random()
    ice.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
   
	inst.components.fueled:StartConsuming()
	inst.AnimState:PlayAnimation("idle_on", true)
end

local function onhammered(inst, worked)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function fueltaskfn(inst)
	inst.AnimState:PlayAnimation("use")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/icemachine_start")
	inst.components.fueled:StopConsuming() 
	inst:ListenForEvent("animover", spawnice)
end

local function ontakefuelfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/machine_fuel")
	inst.components.fueled:StartConsuming()
end

local function fuelupdatefn(inst, dt)
	-- TODO: summer season rate adjustment?
	inst.components.fueled.rate = 1
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit"..inst.machinestate)
	inst.AnimState:PushAnimation("idle"..inst.machinestate, true)
	inst:RemoveEventCallback("animover", spawnice)
	if inst.machinestate == MACHINESTATES.ON then
		inst.components.fueled:StartConsuming() --resume fuel consumption incase you were interrupted from fueltaskfn
	end
end

local function fuelsectioncallback(new, old, inst)
	if new == 0 and old > 0 then
		inst.machinestate = MACHINESTATES.OFF
		inst.AnimState:PlayAnimation("turn"..inst.machinestate)
		inst.AnimState:PushAnimation("idle"..inst.machinestate, true)
		inst.SoundEmitter:KillSound("loop")
		if inst.fueltask ~= nil then
			inst.fueltask:Cancel()
			inst.fueltask = nil
		end
	elseif new > 0 and old == 0 then
		inst.machinestate = MACHINESTATES.ON
		inst.AnimState:PlayAnimation("turn"..inst.machinestate)
		inst.AnimState:PushAnimation("idle"..inst.machinestate, true)
		if not inst.SoundEmitter:PlayingSound("loop") then
			inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/icemachine_lp", "loop")
		end
		if inst.fueltask == nil then
			inst.fueltask = inst:DoPeriodicTask(ICEMAKER_SPAWN_TIME, fueltaskfn)
		end
	end
end

local function getstatus(inst)
	local sec = inst.components.fueled:GetCurrentSection()
	if sec == 0 then
		return "OUT"
	elseif sec <= 4 then
		local t = {"VERYLOW","LOW","NORMAL","HIGH"}
		return t[sec]
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle"..inst.machinestate)
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/icemaker_place")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_icemaker.tex")
	
	inst.AnimState:SetBank("icemachine")
	inst.AnimState:SetBuild("icemachine")
	inst.AnimState:PlayAnimation("idle_off", true)
	
	MakeObstaclePhysics(inst, .4)
	
	inst:AddTag("icemaker")
	inst:AddTag("machine")
	inst:AddTag("structure")
	inst:AddTag("gray_da_fairytail")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("fueled")
	inst.components.fueled.maxfuel = ICEMAKER_FUEL_MAX
	inst.components.fueled.accepting = true
	inst.components.fueled:SetSections(4)
	inst.components.fueled:SetTakeFuelFn(ontakefuelfn)
	inst.components.fueled:SetUpdateFn(fuelupdatefn)
	inst.components.fueled:SetSectionCallback(fuelsectioncallback)
	inst.components.fueled:InitializeFuelLevel(ICEMAKER_FUEL_MAX/2)
	inst.components.fueled:StartConsuming()
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	-- inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	inst.machinestate = MACHINESTATES.ON
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("sap_icemaker", fn, assets, prefabs),
MakePlacer("sap_icemaker_placer", "icemachine", "icemachine", "idle_off")