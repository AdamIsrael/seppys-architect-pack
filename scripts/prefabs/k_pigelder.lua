require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_elderswampig.zip"),
	
	Asset("SOUND", "sound/pig.fsb"),
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs = {}

local function OnIsPathFindingDirty(inst)    
    local wall_x, wall_y, wall_z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:GetPlatformAtPoint(wall_x, wall_z) == nil then        
        if inst._ispathfinding:value() then
            if inst._pfpos == nil then
                inst._pfpos = Point(wall_x, wall_y, wall_z)
                TheWorld.Pathfinder:AddWall(wall_x, wall_y, wall_z)
            end
        elseif inst._pfpos ~= nil then
            TheWorld.Pathfinder:RemoveWall(wall_x, wall_y, wall_z)
            inst._pfpos = nil
        end
    end
end

local function InitializePathFinding(inst)
    inst:ListenForEvent("onispathfindingdirty", OnIsPathFindingDirty)
    OnIsPathFindingDirty(inst)
end

local function makeobstacle(inst)
    inst.Physics:SetActive(true)
    inst._ispathfinding:set(true)
end

local function clearobstacle(inst)
    inst.Physics:SetActive(false)
    inst._ispathfinding:set(false)
	inst:DoTaskInTime(2, function() inst:Remove() end)
end

local function onhealthchange(inst)
	if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("sleep_pre")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
		clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
	end
end

local function keeptargetfn()
    return false
end

local function onload(inst)
    if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("sleep_pre")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
        clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
    end
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end

local function onhit(inst)
	local healthpercent = inst.components.health:GetPercent()
        if healthpercent > 0 then
		inst.AnimState:PlayAnimation("idle")
		inst.components.talker:Say("HRF!! IT HURTS!! IT HURTS!!")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("sleep_pst")
	inst.AnimState:PushAnimation("idle", true)
end

--[[
local function SaySomethingFar(inst)
	if math.random() < 0.050 then
		inst.components.talker:Say("..HRUMPF..")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("(SNORT) ...s...scales...")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("...p...plague...")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("...zzzZZzzz...")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("...g-GNAW...")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("...s-sky...")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	end
end

local function SaySomethingNear(inst)
	if math.random() < 0.050 then
		inst.components.talker:Say("ELDER'S EYE FEEL HEAVY")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("HRF? YOU TRADE? SUPPLIES?")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("HRF! OUR HOMES DESTROYED")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("HRF? SLEEP... GIVE ELDER NIGHTMARES")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("HRF! GNAW MAD AT PIGS")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("HRF! MOST GOATS NO HELP TO PIGS")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("HRF! WE NEED FIX HOUSES")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.050 then
		inst.components.talker:Say("HRF? ...WHAT LITTLE PIGS DO IF ELDER GONE?")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	end
end
]]--

local function onfar(inst)
	inst.AnimState:PlayAnimation("sleep_pre")
	inst.AnimState:PushAnimation("sleep_loop", true)
	if math.random() < 0.6 then
		inst.components.talker:Say("..HRUMPF..")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("(SNORT) ...s...scales...")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("...p...plague...")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("...zzzZZzzz...")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("...g-GNAW...")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("...s-sky...")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	end
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("sleep_pst")
	inst.AnimState:PushAnimation("idle", true)
	if math.random() < 0.6 then
		inst.components.talker:Say("ELDER'S EYE FEEL HEAVY")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("HRF? YOU TRADE? SUPPLIES?")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("HRF! OUR HOMES DESTROYED")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("HRF? SLEEP... GIVE ELDER NIGHTMARES")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("HRF! GNAW MAD AT PIGS")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("HRF! MOST GOATS NO HELP TO PIGS")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("HRF! WE NEED FIX HOUSES")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("HRF? ...WHAT LITTLE PIGS DO IF ELDER GONE?")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_pigelder.tex")
	
	-- inst.Transform:SetFourFaced()
	-- inst.AnimState:SetScale(3, 3, 3)
	
	inst.AnimState:SetBank("quagmire_elderswampig")
	inst.AnimState:SetBuild("quagmire_elderswampig") 
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 2, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("pigelder")
	-- inst:AddTag("notarget")
	
	inst:AddComponent("talker")
	-- inst.components.talker.ontalk = ontalk
	inst.components.talker.fontsize = 30
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.colour = Vector3(1, 1, 1)
	inst.components.talker.offset = Vector3(0,-600,0)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SWAMPIGELDER"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(100)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(5, 7)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	-- inst:AddComponent("savedrotation")
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

return Prefab("sap_pigelder", fn, assets, prefabs),
MakePlacer("sap_pigelder_placer", "quagmire_elderswampig", "quagmire_elderswampig", "idle")
