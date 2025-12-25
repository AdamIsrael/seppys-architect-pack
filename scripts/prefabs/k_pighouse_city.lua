require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/pig_farmhouse_build.zip"),

	Asset("ANIM", "anim/pig_townhouse1.zip"),
    Asset("ANIM", "anim/pig_townhouse5.zip"),
    Asset("ANIM", "anim/pig_townhouse6.zip"),    

    Asset("ANIM", "anim/pig_townhouse1_pink_build.zip"),
    Asset("ANIM", "anim/pig_townhouse1_green_build.zip"),
    Asset("ANIM", "anim/pig_townhouse1_brown_build.zip"),
    Asset("ANIM", "anim/pig_townhouse1_white_build.zip"),

    Asset("ANIM", "anim/pig_townhouse5_beige_build.zip"),
    Asset("ANIM", "anim/pig_townhouse6_red_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUND", "sound/pig.fsb"),
}

local prefabs = 
{
	"splash_sink",
	"pigman",
    "kyno_pigman_collector",
    "kyno_pigman_banker",
    "kyno_pigman_beautician",
    "kyno_pigman_florist",
    "kyno_pigman_erudite",
    "kyno_pigman_hunter",
    "kyno_pigman_hatmaker",
    "kyno_pigman_usher",
    "kyno_pigman_mechanic",
    "kyno_pigman_storeowner",
    "kyno_pigman_professor",
}

local city_1_citizens = {
    "kyno_pigman_banker",
    "kyno_pigman_beautician",
    "kyno_pigman_florist",
    "kyno_pigman_usher",
    "kyno_pigman_mechanic",
    "kyno_pigman_storeowner",
    "kyno_pigman_professor",
}

local city_2_citizens = {
    "kyno_pigman_collector",
    "kyno_pigman_erudite",
    "kyno_pigman_hatmaker",
    "kyno_pigman_hunter",
}

local city_citizens = {
    city_1_citizens,
    city_2_citizens,
}

local spawned_farm = {
    "kyno_pigman_farmer",
}

local spawned_mine = {
    "kyno_pigman_miner",
}

local citizens_list = {
	[1] = "kyno_pigman_banker",
	[2] = "kyno_pigman_beautician",
	[3] = "kyno_pigman_collector",
	[4] = "kyno_pigman_erudite",
	[5] = "kyno_pigman_florist",
	[6] = "kyno_pigman_hunter",
	[7] = "kyno_pigman_hatmaker",
	[8] = "kyno_pigman_mechanic",
	[9] = "kyno_pigman_professor",
	[10] = "kyno_pigman_storeowner",
	[11] = "kyno_pigman_usher",
}

local farm_citizens_list = {
	[1] = "kyno_pigman_farmer",
	[2] = "kyno_pigman_miner",
}

local SCALEBUILD ={}
SCALEBUILD["pig_townhouse1_pink_build"] = true
SCALEBUILD["pig_townhouse1_green_build"] = true
SCALEBUILD["pig_townhouse1_white_build"] = true
SCALEBUILD["pig_townhouse1_brown_build"] = true

local SETBANK ={}
SETBANK["pig_townhouse1_pink_build"] = "pig_townhouse"
SETBANK["pig_townhouse1_green_build"] = "pig_townhouse"
SETBANK["pig_townhouse1_white_build"] = "pig_townhouse"
SETBANK["pig_townhouse1_brown_build"] = "pig_townhouse"
SETBANK["pig_townhouse5_beige_build"] = "pig_townhouse5"
SETBANK["pig_townhouse6_red_build"] = "pig_townhouse6"

local house_builds = {
   "pig_townhouse1_pink_build",
   "pig_townhouse1_green_build",
   "pig_townhouse1_white_build",
   "pig_townhouse1_brown_build",
   "pig_townhouse5_beige_build",
   "pig_townhouse6_red_build",   
}

local function setScale(inst,build)
    if SCALEBUILD[build] then
        inst.AnimState:SetScale(0.75,0.75,0.75)
    else
        inst.AnimState:SetScale(1,1,1)
    end
end

local function getScale(inst,build)
    if SCALEBUILD[build] then
        return {0.75,0.75,0.75}
    else
        return {1,1,1}
    end
end

local function LightsOn(inst)
    if not inst:HasTag("burnt") then
        inst.Light:Enable(true)
        inst.AnimState:PlayAnimation("lit", true)
        inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lighton")
        inst.lightson = true
    end
end

local function LightsOff(inst)
    if not inst:HasTag("burnt") then
        inst.Light:Enable(false)
        inst.AnimState:PlayAnimation("idle", true)
        inst.SoundEmitter:PlaySound("dontstarve/pig/pighut_lightoff")
        inst.lightson = false
    end
end

local function onfar(inst) 
    if not inst:HasTag("burnt") then
        if inst.components.spawner and inst.components.spawner:IsOccupied() then
            LightsOn(inst)
        end
    end
end

local function getstatus(inst)
    if inst:HasTag("burnt") then
        return "BURNT"
    elseif inst.components.spawner and inst.components.spawner:IsOccupied() then
        if inst.lightson then
            return "FULL"
        else
            return "LIGHTSOUT"
        end
    end
end

local function onnear(inst) 
    if not inst:HasTag("burnt") then
        if inst.components.spawner and inst.components.spawner:IsOccupied() then
            LightsOff(inst)
        end
    end
end

local function onwere(child)
    if child.parent and not child.parent:HasTag("burnt") then
        child.parent.SoundEmitter:KillSound("pigsound")
        child.parent.SoundEmitter:PlaySound("dontstarve/pig/werepig_in_hut", "pigsound")
    end
end

local function onnormal(child)
    if child.parent ~= nil and not child.parent:HasTag("burnt") then
        child.parent.SoundEmitter:KillSound("pigsound")
        child.parent.SoundEmitter:PlaySound("dontstarve/pig/pig_in_hut", "pigsound")
    end
end

local function onoccupieddoortask(inst)
    inst.doortask = nil
    if not inst.components.playerprox:IsPlayerClose() then
        LightsOn(inst)
    end
end

local function onoccupied(inst, child)
    if not inst:HasTag("burnt") then 
        inst.SoundEmitter:PlaySound("dontstarve/pig/pig_in_hut", "pigsound")
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")

        if inst.doortask ~= nil then
            inst.doortask:Cancel()
        end
        inst.doortask = inst:DoTaskInTime(1, onoccupieddoortask)
        if child ~= nil then
            inst:ListenForEvent("transformwere", onwere, child)
            inst:ListenForEvent("transformnormal", onnormal, child)
        end
    end
end

local function onvacate(inst, child)
    if not inst:HasTag("burnt") then
        if inst.doortask ~= nil then
            inst.doortask:Cancel()
            inst.doortask = nil
        end
        inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
        inst.SoundEmitter:KillSound("pigsound")
        LightsOff(inst)

        if child ~= nil then
            inst:RemoveEventCallback("transformwere", onwere, child)
            inst:RemoveEventCallback("transformnormal", onnormal, child)
            if child.components.werebeast ~= nil then
                child.components.werebeast:ResetTriggers()
            end

            local child_platform = child:GetCurrentPlatform()
            if (child_platform == nil and not child:IsOnValidGround()) then
                local fx = SpawnPrefab("splash_sink")
                fx.Transform:SetPosition(child.Transform:GetWorldPosition())

                child:Remove()
            else
                if child.components.health ~= nil then
                    child.components.health:SetPercent(1)
                end
			    child:PushEvent("onvacatehome")
            end
        end
    end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    if inst.doortask ~= nil then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        inst.components.spawner:ReleaseChild()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then 
        inst.AnimState:PlayAnimation("hit")
        if inst.lightson then
            inst.AnimState:PushAnimation("lit")
            if inst._window ~= nil then
                inst._window.AnimState:PlayAnimation("windowlight_hit")
                inst._window.AnimState:PushAnimation("windowlight_idle")
            end
            if inst._windowsnow ~= nil then
                inst._windowsnow.AnimState:PlayAnimation("windowsnow_hit")
                inst._windowsnow.AnimState:PushAnimation("windowsnow_idle")
            end
        else
            inst.AnimState:PushAnimation("idle")
        end
    end
end

local function onstartdaydoortask(inst)
    inst.doortask = nil
    if not inst:HasTag("burnt") then
        inst.components.spawner:ReleaseChild()
    end
end

local function onstartdaylighttask(inst)
    if inst.LightWatcher:GetLightValue() > 0.8 then -- they have their own light! make sure it's brighter than that out.
        LightsOff(inst)
        inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, onstartdaydoortask)
    elseif TheWorld.state.iscaveday then
        inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, onstartdaylighttask)
    else
        inst.doortask = nil
    end
end

local function OnStartDay(inst)
    if not inst:HasTag("burnt")
        and inst.components.spawner:IsOccupied() then

        if inst.doortask ~= nil then
            inst.doortask:Cancel()
        end
        inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, onstartdaylighttask)
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/pighouse/wood_2")
    inst.AnimState:PushAnimation("idle")
end

local function onburntup(inst)
    if inst.doortask ~= nil then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    if inst.inittask ~= nil then
        inst.inittask:Cancel()
        inst.inittask = nil
    end
    if inst._window ~= nil then
        inst._window:Remove()
        inst._window = nil
    end
    if inst._windowsnow ~= nil then
        inst._windowsnow:Remove()
        inst._windowsnow = nil
    end
end

local function onignite(inst)
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        inst.components.spawner:ReleaseChild()
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data then
        if data.burnt then
            inst.components.burnable.onburnt(inst)
        end
    end
end

local function spawncheckday(inst)
    inst.inittask = nil
    inst:WatchWorldState("startcaveday", OnStartDay)
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        if TheWorld.state.iscaveday or
            (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
            inst.components.spawner:ReleaseChild()
        else
            inst.components.playerprox:ForceUpdate()
            onoccupieddoortask(inst)
        end
    end
end

local function oninit(inst)
    inst.inittask = inst:DoTaskInTime(math.random(), spawncheckday)
    if inst.components.spawner ~= nil and
        inst.components.spawner.child == nil and
        inst.components.spawner.childname ~= nil and
        not inst.components.spawner:IsSpawnPending() then
        local child = SpawnPrefab(inst.components.spawner.childname)
        if child ~= nil then
            inst.components.spawner:TakeOwnership(child)
            inst.components.spawner:GoHome(child)
        end
    end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_townhouse.tex")
	
	MakeObstaclePhysics(inst, 1)
	inst.AnimState:SetScale(0.75,0.75,0.75)
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetBank("pig_shop")
	inst.AnimState:SetBuild("pig_townhouse1_green_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("pigtownhouse")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("spawner")
    inst.components.spawner:Configure(citizens_list[math.random(1, 11)], TUNING.TOTAL_DAY_TIME*4)
    inst.components.spawner.onoccupied = onoccupied
    inst.components.spawner.onvacate = onvacate
    inst.components.spawner:SetWaterSpawning(false, true)
    inst.components.spawner:CancelSpawning()

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(10, 13)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	MakeMediumBurnable(inst, nil, nil, true)
	MakeLargePropagator(inst)
	inst:ListenForEvent("burntup", function(inst)
		if inst.doortask then
			inst.doortask:Cancel()
			inst.doortask = nil
		end
		inst:Remove()
	end)
		inst:ListenForEvent("onignite", function(inst)
            if inst.components.spawner and inst.components.spawner:IsOccupied() then
				inst.components.spawner:ReleaseChild()
            end
	end)
	
	inst.OnSave = onsave 
	inst.OnLoad = onload

    inst:ListenForEvent("onbuilt", onbuilt)
    inst.inittask = inst:DoTaskInTime(0, oninit)
	
	MakeHauntableWork(inst)
	MakeSnowCovered(inst)
	
	return inst
end

local function farm()
	local inst = fn()
	
	inst.AnimState:SetScale(1,1,1)
	
	inst.AnimState:SetBank("pig_shop")
    inst.AnimState:SetBuild("pig_farmhouse_build")
    inst.AnimState:PlayAnimation("idle", true)
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.spawner:Configure(farm_citizens_list[math.random(1, 2)], TUNING.TOTAL_DAY_TIME*4)
	
	return inst
end

local function house1()
	local inst = fn()
	
	inst.AnimState:SetBank("pig_shop")
    inst.AnimState:SetBuild("pig_townhouse1_pink_build")
    inst.AnimState:PlayAnimation("idle", true)
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"pigskin", "pigskin", "cutstone", "cutstone", "boards", "boards"})
	
	return inst
end

local function house2()
	local inst = fn()
	
	inst.AnimState:SetBank("pig_shop")
    inst.AnimState:SetBuild("pig_townhouse1_white_build")
    inst.AnimState:PlayAnimation("idle", true)
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"pigskin", "pigskin", "cutstone", "cutstone", "boards", "boards"})
	
	return inst
end

local function house3()
	local inst = fn()
	
	inst.AnimState:SetBank("pig_shop")
    inst.AnimState:SetBuild("pig_townhouse1_brown_build")
    inst.AnimState:PlayAnimation("idle", true)
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"pigskin", "pigskin", "cutstone", "cutstone", "boards", "boards"})
	
	return inst
end

local function house4()
	local inst = fn()
	
	inst.AnimState:SetScale(1,1,1)
	
	inst.AnimState:SetBank("pig_shop")
    inst.AnimState:SetBuild("pig_townhouse5_beige_build")
    inst.AnimState:PlayAnimation("idle", true)
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"pigskin", "pigskin", "cutstone", "cutstone", "boards", "boards"})
	
	return inst
end

local function house5()
	local inst = fn()
	
	inst.AnimState:SetScale(1,1,1)
	
	inst.AnimState:SetBank("pig_shop")
    inst.AnimState:SetBuild("pig_townhouse6_red_build")
    inst.AnimState:PlayAnimation("idle", true)
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"pigskin", "pigskin", "cutstone", "cutstone", "boards", "boards"})
	
	return inst
end

local function townhouseplacetestfn(inst)
    inst.AnimState:Hide("YOTP")
    inst.AnimState:Hide("SNOW")
	inst.AnimState:SetScale(0.75,0.75,0.75)
	inst.ApplySkin = function(inst, skin)
		if skin == "kyno_pighouse_city1" then
			inst.AnimState:SetBuild("pig_townhouse1_pink_build")
			inst.AnimState:PlayAnimation("idle", true)
			inst.AnimState:SetScale(0.75,0.75,0.75)
		elseif skin == "kyno_pighouse_city2" then
			inst.AnimState:SetBuild("pig_townhouse1_white_build")
			inst.AnimState:PlayAnimation("idle", true)
			inst.AnimState:SetScale(0.75,0.75,0.75)
		elseif skin == "kyno_pighouse_city3" then
			inst.AnimState:SetBuild("pig_townhouse1_brown_build")
			inst.AnimState:PlayAnimation("idle", true)
			inst.AnimState:SetScale(0.75,0.75,0.75)
		elseif skin == "kyno_pighouse_city4" then
			inst.AnimState:SetBuild("pig_townhouse5_beige_build")
			inst.AnimState:PlayAnimation("idle", true)
			inst.AnimState:SetScale(1,1,1)
		elseif skin == "kyno_pighouse_city5" then
			inst.AnimState:SetBuild("pig_townhouse6_red_build")
			inst.AnimState:PlayAnimation("idle", true)
			inst.AnimState:SetScale(1,1,1)
		end
	end
    return true
end

local function townhouseplacetest2fn(inst)
	inst.AnimState:Hide("YOTP")
    inst.AnimState:Hide("SNOW")
	inst.AnimState:SetScale(1, 1, 1)
    return true
end

local function farmhouseplacetestfn(inst)
    inst.AnimState:Hide("YOTP")
    inst.AnimState:Hide("SNOW")
    return true
end

return Prefab("kyno_pighouse_city", fn, assets, prefabs),
Prefab("kyno_pighouse_city1", house1, assets, prefabs),
Prefab("kyno_pighouse_city2", house2, assets, prefabs),
Prefab("kyno_pighouse_city3", house3, assets, prefabs),
Prefab("kyno_pighouse_city4", house4, assets, prefabs),
Prefab("kyno_pighouse_city5", house5, assets, prefabs),
Prefab("kyno_pighouse_farm", farm, assets, prefabs),
MakePlacer("kyno_pighouse_city_placer", "pig_shop", "pig_townhouse1_green_build", "idle", false, nil, nil, nil, nil, nil, townhouseplacetestfn),
MakePlacer("kyno_pighouse_city1_placer", "pig_shop", "pig_townhouse1_pink_build", "idle", false, nil, nil, nil, nil, nil, townhouseplacetestfn),
MakePlacer("kyno_pighouse_city2_placer", "pig_shop", "pig_townhouse1_white_build", "idle", false, nil, nil, nil, nil, nil, townhouseplacetestfn),
MakePlacer("kyno_pighouse_city3_placer", "pig_shop", "pig_townhouse1_brown_build", "idle", false, nil, nil, nil, nil, nil, townhouseplacetestfn),
MakePlacer("kyno_pighouse_city4_placer", "pig_shop", "pig_townhouse5_beige_build", "idle", false, nil, nil, nil, nil, nil, townhouseplacetest2fn),
MakePlacer("kyno_pighouse_city5_placer", "pig_shop", "pig_townhouse6_red_build", "idle", false, nil, nil, nil, nil, nil, farmhouseplacetestfn),
MakePlacer("kyno_pighouse_farm_placer", "pig_shop", "pig_farmhouse_build", "idle", false, nil, nil, nil, nil, nil, farmhouseplacetestfn)
--[[,
CreateModPrefabSkin("kyno_pighouse_city1",
	{
		assets = {
			Asset("ANIM", "anim/pig_townhouse1.zip"),
			Asset("ANIM", "anim/pig_townhouse1_pink_build.zip"),
		},
		base_prefab = "kyno_pighouse_city",
		fn = house1,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "pig_townhouse1_pink_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_pighouse_city2",
	{
		assets = {
			Asset("ANIM", "anim/pig_townhouse1.zip"),
			Asset("ANIM", "anim/pig_townhouse1_white_build.zip"),
		},
		base_prefab = "kyno_pighouse_city",
		fn = house2,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "pig_townhouse1_white_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_pighouse_city3",
	{
		assets = {
			Asset("ANIM", "anim/pig_townhouse1.zip"),
			Asset("ANIM", "anim/pig_townhouse1_brown_build.zip"),
		},
		base_prefab = "kyno_pighouse_city",
		fn = house3,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "pig_townhouse1_brown_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_pighouse_city4",
	{
		assets = {
			Asset("ANIM", "anim/pig_townhouse5.zip"),
			Asset("ANIM", "anim/pig_townhouse5_beige_build.zip"),
		},
		base_prefab = "kyno_pighouse_city",
		fn = house4,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "pig_townhouse5_beige_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_pighouse_city5",
	{
		assets = {
			Asset("ANIM", "anim/pig_townhouse6.zip"),
			Asset("ANIM", "anim/pig_townhouse6_red_build.zip"),
		},
		base_prefab = "kyno_pighouse_city",
		fn = house5,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "pig_townhouse6_red_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	})
]]--