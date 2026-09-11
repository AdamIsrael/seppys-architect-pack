require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quacken.zip"),
	Asset("ANIM", "anim/quacken_tentacle.zip"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
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
    -- inst.Physics:SetActive(true)
    inst._ispathfinding:set(true)
end

local function clearobstacle(inst)
    -- inst.Physics:SetActive(false)
    inst._ispathfinding:set(false)
	inst:DoTaskInTime(2, function() inst:Remove() end)
end

local function onhealthchange(inst)
	if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("death")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/death")
		clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
	end
end

local function onhealthchange2(inst)
	if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("exit")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/tentacle_submerge")
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
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/death")
        clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
    end
end

local function onload2(inst)
    if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("exit")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/tentacle_submerge")
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
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/hit")
		inst.AnimState:PushAnimation("idle_loop", true)
	end
end

local function onhit2(inst)
	local healthpercent = inst.components.health:GetPercent()
        if healthpercent > 0 then
		inst.AnimState:PlayAnimation("hit")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/hit")
		inst.AnimState:PushAnimation("idle_slow", true)
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("enter")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/enter")
	inst.AnimState:PushAnimation("idle_loop", true)
end

local function onbuilt2(inst)
	inst.AnimState:PlayAnimation("enter")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/tentacle_emerge")
	inst.AnimState:PushAnimation("idle_loop", true)
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("taunt")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/taunt")
	inst.AnimState:PushAnimation("idle_loop", true)
end

local function onfar(inst)
	inst.AnimState:PlayAnimation("idle_loop", true)
end

local function onnear2(inst)
	inst.AnimState:PlayAnimation("shake")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/shake")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/shake")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/quacken/shake")
	inst.AnimState:PushAnimation("idle_slow", true)
end

local function onfar2(inst)
	inst.AnimState:PlayAnimation("idle_slow", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_kraken.tex")
	
	inst.AnimState:SetBank("quacken")
	inst.AnimState:SetBuild("quacken")
	inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("quacken")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
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
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(7, 10)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

local function fn2()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_krakententacle.tex")
	
	inst.AnimState:SetBank("quacken_tentacle")
	inst.AnimState:SetBuild("quacken_tentacle")
	inst.AnimState:PlayAnimation("idle_slow", true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("quacken_tentacle")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(200)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
	inst.components.health.ondelta = onhealthchange2
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false
	inst.components.health.redirect = nodebrisdmg

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit2
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(6, 9)
    inst.components.playerprox:SetOnPlayerNear(onnear2)
    inst.components.playerprox:SetOnPlayerFar(onfar2)
	
	inst.OnLoad = onload2
	
	inst:ListenForEvent("onbuilt", onbuilt2)
	
	return inst
end

return Prefab("sap_kraken", fn, assets, prefabs),
Prefab("sap_kraken_tentacle", fn2, assets, prefabs),
MakePlacer("sap_kraken_placer", "quacken", "quacken", "idle_loop"),
MakePlacer("sap_kraken_tentacle_placer", "quacken_tentacle", "quacken_tentacle", "idle_slow")
