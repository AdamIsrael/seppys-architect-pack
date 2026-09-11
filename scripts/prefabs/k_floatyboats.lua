require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/knightboat.zip"),
    Asset("ANIM", "anim/knightboat_build.zip"),
	
	Asset("ANIM", "anim/bishopboat.zip"),
    Asset("ANIM", "anim/bishopboat_build.zip"),
	
	Asset("ANIM", "anim/rookboat.zip"),
    Asset("ANIM", "anim/rookboat_build.zip"),
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
		inst.AnimState:PlayAnimation("sleep_pre")
		inst.AnimState:PlayAnimation("sleep_loop")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/death")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/death_voice")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/sinking_bubbles")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/sinking_parts")
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
		inst.AnimState:PlayAnimation("sleep_loop")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/death")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/death_voice")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/sinking_bubbles")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/sinking_parts")
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
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/hit")
		inst.AnimState:PushAnimation("idle_loop", true)
	end
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("idle_loop", true)
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("taunt")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/knight_steamboat/taunt")
	inst.AnimState:PushAnimation("idle_loop", true)
end

local function onnear2(inst)
	inst.AnimState:PlayAnimation("taunt")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/bishop/voice")
	inst.AnimState:PushAnimation("idle_loop", true)
end

local function onnear3(inst)
	inst.AnimState:PlayAnimation("taunt")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/rook/voice")
	inst.AnimState:PushAnimation("idle_loop", true)
end

local function onfar(inst)
	inst.AnimState:PlayAnimation("idle_loop", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("knightboat")
	inst.AnimState:SetBuild("knightboat_build")
	inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("floatyboaty")
	inst:AddTag("rotatableobject")
	
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
	
	inst.OnLoad = onload
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

local function fn2()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("bishopboat")
	inst.AnimState:SetBuild("bishopboat_build")
	inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("floatyboaty")
	inst:AddTag("rotatableobject")
	
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
	
	inst.OnLoad = onload
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6)
    inst.components.playerprox:SetOnPlayerNear(onnear2)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

local function fn3()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("rookboat")
	inst.AnimState:SetBuild("rookboat_build")
	inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("floatyboaty")
	inst:AddTag("rotatableobject")
	
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
	
	inst.OnLoad = onload
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6)
    inst.components.playerprox:SetOnPlayerNear(onnear3)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

return Prefab("sap_knightboat", fn, assets, prefabs),
Prefab("sap_bishopboat", fn2, assets, prefabs),
Prefab("sap_rookboat", fn3, assets, prefabs),
MakePlacer("sap_knightboat_placer", "knightboat", "knightboat_build", "idle_loop"),
MakePlacer("sap_bishopboat_placer", "bishopboat", "bishopboat_build", "idle_loop"),
MakePlacer("sap_rookboat_placer", "rookboat", "rookboat_build", "idle_loop")
