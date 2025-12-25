require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/pig_royalguard.zip"),
	Asset("ANIM", "anim/pig_royalguard_2.zip"),
	Asset("ANIM", "anim/pig_royalguard_3.zip"),
	Asset("ANIM", "anim/pig_royalguard_rich.zip"),
	Asset("ANIM", "anim/pig_royalguard_rich_2.zip"),
	Asset("ANIM", "anim/townspig_actions.zip"),
	Asset("ANIM", "anim/townspig_basic.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

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
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
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
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
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
		inst.AnimState:PushAnimation("idle_loop")
		inst.components.talker:Say("THOU HAST THE STENCH OF UNPIG!")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle_loop")
	inst.AnimState:PushAnimation("idle_loop", true)
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("emote_hat")
	inst.AnimState:PushAnimation("idle_loop", true)
	if math.random() < 0.6 then
		inst.components.talker:Say("MINE SERVICE UNTO YOU")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("YON MAJESTY")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("LONG LIVE YON MAJESTY!")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("THY HONOR US LOWLY PIGS")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("THOU MIGHTY SCEPTER'D BEING")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("FORTUNE SMILE 'PON MAJESTY!")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("THE APORKALYPSE APPROACH-ETH")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	elseif math.random() < 0.6 then
		inst.components.talker:Say("DOOMSDAY IS NEAR!")
		-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/city_pig/conversational_talk_gaurd","talk")
	end
end

local function onfar(inst)
	inst.AnimState:PushAnimation("idle_loop", true)
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

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("townspig")
	inst.AnimState:SetBuild("pig_royalguard")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:Hide("arm_CARRY")
	
	MakeObstaclePhysics(inst, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("pig_royalguard")
	inst:AddTag("rotatableobject")
	
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
    inst.components.playerprox:SetDist(5, 7)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("savedrotation")
	
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

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("townspig")
	inst.AnimState:SetBuild("pig_royalguard_2")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:Hide("arm_CARRY")
	
	MakeObstaclePhysics(inst, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("pig_royalguard")
	inst:AddTag("rotatableobject")
	
	inst:AddComponent("talker")
	-- inst.components.talker.ontalk = ontalk
	inst.components.talker.fontsize = 30
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.colour = Vector3(1, 1, 1)
	inst.components.talker.offset = Vector3(0,-600,0)
	
	inst:SetPrefabNameOverride("kyno_royalguard_2")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"meat", "armorwood", "pigskin"})
	
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
    inst.components.playerprox:SetDist(5, 7)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("savedrotation")
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

local function fn3()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("townspig")
	inst.AnimState:SetBuild("pig_royalguard_rich")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:Hide("arm_CARRY")
	
	MakeObstaclePhysics(inst, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("pig_royalguard")
	inst:AddTag("rotatableobject")
	
	inst:AddComponent("talker")
	-- inst.components.talker.ontalk = ontalk
	inst.components.talker.fontsize = 30
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.colour = Vector3(1, 1, 1)
	inst.components.talker.offset = Vector3(0,-600,0)
	
	inst:SetPrefabNameOverride("kyno_royalguard_rich")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"meat", "armorwood", "pigskin"})
	
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
    inst.components.playerprox:SetDist(5, 7)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("savedrotation")
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

local function fn4()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("townspig")
	inst.AnimState:SetBuild("pig_royalguard_rich_2")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:Hide("arm_CARRY")
	
	MakeObstaclePhysics(inst, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("pig_royalguard")
	inst:AddTag("rotatableobject")
	
	inst:AddComponent("talker")
	inst.components.talker.fontsize = 30
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.colour = Vector3(1, 1, 1)
	inst.components.talker.offset = Vector3(0,-600,0)
	
	inst:SetPrefabNameOverride("kyno_royalguard_rich_2")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"meat", "armorwood", "pigskin"})
	
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
    inst.components.playerprox:SetDist(5, 7)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("savedrotation")
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

local function fn5()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("townspig")
	inst.AnimState:SetBuild("pig_royalguard_3")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:Hide("arm_CARRY")
	
	MakeObstaclePhysics(inst, .5)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("pig_royalguard")
	inst:AddTag("rotatableobject")
	
	inst:AddComponent("talker")
	-- inst.components.talker.ontalk = ontalk
	inst.components.talker.fontsize = 30
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.colour = Vector3(1, 1, 1)
	inst.components.talker.offset = Vector3(0,-600,0)
	
	inst:SetPrefabNameOverride("kyno_royalguard_palace")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"meat", "armorwood", "pigskin"})
	
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
    inst.components.playerprox:SetDist(5, 7)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("savedrotation")
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

local function pigplacerfn(inst)
	inst.ApplySkin = function(inst, skin)
		if skin == "kyno_royalguard1" then
			inst.AnimState:SetBuild("pig_royalguard_2")
		elseif skin == "kyno_royalguard2" then
			inst.AnimState:SetBuild("pig_royalguard_rich")
		elseif skin == "kyno_royalguard3" then
			inst.AnimState:SetBuild("pig_royalguard_rich_2")
		elseif skin == "kyno_royalguard4" then
			inst.AnimState:SetBuild("pig_royalguard_3")
		end
	end
end

return Prefab("kyno_royalguard", fn, assets, prefabs),
Prefab("kyno_royalguard1", fn2, assets, prefabs),
Prefab("kyno_royalguard2", fn3, assets, prefabs),
Prefab("kyno_royalguard3", fn4, assets, prefabs),
Prefab("kyno_royalguard4", fn5, assets, prefabs),
MakePlacer("kyno_royalguard_placer", "townspig", "pig_royalguard", "idle_loop", false, nil, nil, nil, 90, nil, pigplacerfn),
MakePlacer("kyno_royalguard1_placer", "townspig", "pig_royalguard_2", "idle_loop"),
MakePlacer("kyno_royalguard2_placer", "townspig", "pig_royalguard_rich", "idle_loop"),
MakePlacer("kyno_royalguard3_placer", "townspig", "pig_royalguard_rich_2", "idle_loop"),
MakePlacer("kyno_royalguard4_placer", "townspig", "pig_royalguard_3", "idle_loop")
--[[,
CreateModPrefabSkin("kyno_royalguard1",
	{
		assets = {
			Asset("ANIM", "anim/pig_royalguard_2.zip"),
			Asset("ANIM", "anim/townspig_actions.zip"),
			Asset("ANIM", "anim/townspig_basic.zip"),
			
			Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
			Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
			Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
			Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
		},
		base_prefab = "kyno_royalguard",
		fn = fn2,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "pig_royalguard_2",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_royalguard2",
	{
		assets = {
			Asset("ANIM", "anim/pig_royalguard_3.zip"),
			Asset("ANIM", "anim/townspig_actions.zip"),
			Asset("ANIM", "anim/townspig_basic.zip"),
			
			Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
			Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
			Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
			Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
		},
		base_prefab = "kyno_royalguard",
		fn = fn3,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "pig_royalguard_3",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_royalguard3",
	{
		assets = {
			Asset("ANIM", "anim/pig_royalguard_rich.zip"),
			Asset("ANIM", "anim/townspig_actions.zip"),
			Asset("ANIM", "anim/townspig_basic.zip"),
			
			Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
			Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
			Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
			Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
		},
		base_prefab = "kyno_royalguard",
		fn = fn4,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "pig_royalguard_rich",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_royalguard4",
	{
		assets = {
			Asset("ANIM", "anim/pig_royalguard_rich_2.zip"),
			Asset("ANIM", "anim/townspig_actions.zip"),
			Asset("ANIM", "anim/townspig_basic.zip"),
			
			Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
			Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
			Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
			Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
		},
		base_prefab = "kyno_royalguard",
		fn = fn5,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "pig_royalguard_rich_2",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	})
]]--