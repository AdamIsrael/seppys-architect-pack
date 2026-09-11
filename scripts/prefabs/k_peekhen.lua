require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/buzzard_basic.zip"),
	Asset("ANIM", "anim/peekhen_build.zip"),
	
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
		inst.AnimState:PlayAnimation("death")
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/death")
		clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
	end
end

local function keeptargetfn()
    return false
end

local function onload(inst)
    if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("death")
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/death")
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
		inst.AnimState:PlayAnimation("hit")
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/hurt")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle", true)
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("taunt")
	inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/buzzard/taunt")
end

local function onfar(inst)
	inst.AnimState:PushAnimation("idle", true)
end

local function sleep(inst, isnight)
	if isnight then
		inst.AnimState:PlayAnimation("sleep_pre")
		inst.AnimState:PushAnimation("sleep_loop", true)
	else
		inst.AnimState:PlayAnimation("sleep_pst")
		inst.AnimState:PushAnimation("idle_loop", true)
	end
end

local function peck(inst)
if inst:HasTag("peekhen") then
	inst:DoTaskInTime(4+math.random()*5, function() peck(inst) end)
		inst.AnimState:PlayAnimation("peck")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.25, .75)
	
	inst.AnimState:SetBank("buzzard")
	inst.AnimState:SetBuild("peekhen_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("fakebuzzard")
	inst:AddTag("peekhen")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(200)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false
	inst.components.health.redirect = nodebrisdmg

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	
	inst:AddComponent("savedrotation")
	
	sleep(inst)
	peck(inst)
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

return Prefab("sap_peekhen", fn, assets, prefabs),
MakePlacer("sap_peekhen_placer", "buzzard", "peekhen_build", "idle", false, nil, nil, nil, 90, nil)
