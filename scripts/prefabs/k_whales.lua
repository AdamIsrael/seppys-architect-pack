require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/whale.zip"),
	Asset("ANIM", "anim/whale_blue_build.zip"),
	Asset("ANIM", "anim/whale_moby_build.zip"),
	
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
	if inst:HasTag("blue_whale") then
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/blue_whale/death")
	else
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/white_whale/death")
	end
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
	if inst:HasTag("blue_whale") then
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/blue_whale/death")
	else
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/white_whale/death")
	end
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
		inst.AnimState:PushAnimation("idle")
		if inst:HasTag("blue_whale") then
			inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/blue_whale/hit")
		else
			inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/white_whale/hit")
		end
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle", true)
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function rename(inst)
    inst.components.named:PickNewName()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_whale_carcass.tex")
	
	inst.AnimState:SetBank("whale")
	inst.AnimState:SetBuild("whale_blue_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("genshin")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("blue_whale")
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
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

local function fn2()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_whale_carcass.tex")
	
	inst.AnimState:SetBank("whale")
	inst.AnimState:SetBuild("whale_moby_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("genshin")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("white_whale")
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
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "White Whale", "Moby Dick", "Doby Mick" }
    inst.components.named:PickNewName()
    inst:DoPeriodicTask(5, rename)
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

return Prefab("sap_whale_blue", fn, assets, prefabs),
Prefab("sap_whale_white", fn2, assets, prefabs),
MakePlacer("sap_whale_blue_placer", "whale", "whale_blue_build", "idle"),
MakePlacer("sap_whale_white_placer", "whale", "whale_moby_build", "idle")
