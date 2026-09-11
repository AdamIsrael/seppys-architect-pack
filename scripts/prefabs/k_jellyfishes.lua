require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/jellyfish.zip"),
	Asset("ANIM", "anim/rainbowjellyfish.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
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
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/jellyfish/death_murder")
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
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/jellyfish/death_murder")
        clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
    end
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end

local function OnAttacked(inst, data)
    if data ~= nil and data.attacker ~= nil then
		if data.attacker.components.health ~= nil and not data.attacker.components.health:IsDead() and
			(data.weapon == nil or ((data.weapon.components.weapon == nil or data.weapon.components.weapon.projectile == nil) and data.weapon.components.projectile == nil)) and
			not (data.attacker.components.inventory ~= nil and data.attacker.components.inventory:IsInsulated()) then
			data.attacker.components.health:DoDelta(-20)
			if data.attacker:HasTag("player") then
				data.attacker.sg:GoToState("electrocute")
			end
		end
	end
end

local function onhit(inst)
	local healthpercent = inst.components.health:GetPercent()
        if healthpercent > 0 then
		inst.AnimState:PlayAnimation("idle")
		inst.AnimState:PushAnimation("idle")
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle", true)
end

local function onbuilt2(inst)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle")
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function shock(inst)
if inst:HasTag("jellyfish") then
	inst:DoTaskInTime(4+math.random()*5, function() shock(inst) end)
		inst.AnimState:PlayAnimation("idle_shock")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/jellyfish/electric_water")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local INTENSITY = 0.65
local function swapColor(inst, light)
	if inst.ispink then
		inst.ispink = false
		inst.isgreen = true
		inst.components.lighttweener:StartTween(light, nil, nil, nil, {0/255, 180/255, 255/255}, 4, swapColor)
	elseif inst.isgreen then
		inst.isgreen = false
		inst.components.lighttweener:StartTween(light, nil, nil, nil, {240/255, 230/255, 100/255}, 4, swapColor)
	else
		inst.ispink = true
		inst.components.lighttweener:StartTween(light, nil, nil, nil, {251/255, 30/255, 30/255}, 4, swapColor)
	end
end

local function turnon(inst)
	if inst.Light and not inst.hidden then	
		inst.Light:Enable(true)
		local secs = 1+math.random()
		inst.components.lighttweener:StartTween(inst.Light, 0, nil, nil, nil, 0)
		inst.components.lighttweener:StartTween(inst.Light, INTENSITY, nil, nil, nil, secs, swapColor)		
	end
end

local function turnoff(inst)
	if inst.Light then
		inst.Light:Enable(false)
		inst.components.lighttweener.callback = nil
		inst.components.lighttweener:EndTween()
	end
end

local function fadein(inst)
	inst.hidden = false
	inst.AnimState:PlayAnimation("idle")
	inst:Show()
	inst:RemoveTag("NOCLICK")	
end

local function fadeout(inst)	
	inst.hidden = true
	inst:AddTag("NOCLICK")
	inst:Hide()
end

local function onwake(inst, isday)
	if not isday then
		fadein(inst)
		turnon(inst)		
	else
		turnoff(inst)
	end
end

local function onsleep(inst, isday)
	if isday then
		fadeout(inst)
		turnoff(inst)
	else
		turnoff(inst)
	end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("jellyfish")
	inst.AnimState:SetBuild("jellyfish")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("jellyfish")
	
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
	
	shock(inst)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	inst:ListenForEvent("attacked", OnAttacked)
	
	return inst
end

local function fn2()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	-- inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	local light = inst.entity:AddLight()
	
	inst.Light:SetColour(251/255, 30/255, 30/255)
	inst.Light:Enable(false)
	inst.Light:SetIntensity(0.65)
	inst.Light:SetRadius(1.5)
	inst.Light:SetFalloff(.45)
	
	inst.AnimState:SetBank("rainbowjellyfish")
	inst.AnimState:SetBuild("rainbowjellyfish")
	-- inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("rainbowjellyfish")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("fader")
	inst:AddComponent("lighttweener")
	
	inst.ispink = true
	inst.components.lighttweener:StartTween(light, nil, nil, nil, {0/255, 180/255, 255/255}, 4, swapColor)

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
	inst.OnEntityWake = onwake
	inst.OnEntitySleep = onsleep
	
	inst:ListenForEvent("onbuilt", onbuilt)
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("daytime", function() inst:DoTaskInTime(2, function() turnoff(inst) end) end, TheWorld)
    inst:ListenForEvent("dusktime", function() turnon(inst) end, TheWorld)
	
	return inst
end

return Prefab("sap_jellyfish", fn, assets, prefabs),
Prefab("sap_jellyfish_rainbow", fn2, assets, prefabs),
MakePlacer("sap_jellyfish_placer", "jellyfish", "jellyfish", "idle"),
MakePlacer("sap_jellyfish_rainbow_placer", "rainbowjellyfish", "rainbowjellyfish", "idle")
