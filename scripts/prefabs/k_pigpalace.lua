require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/palace.zip"),
	Asset("ANIM", "anim/palace2.zip"),
    -- Asset("ANIM", "anim/pig_shop_doormats.zip"),
    -- Asset("ANIM", "anim/palace_door.zip"),
	
	Asset("SOUND", "sound/pig.fsb"),
}

local prefabs =
{
    "sap_pigman_queen",
    "splash_sink",
}

local function LightsOn(inst)
    if not inst:HasTag("burnt") then
        inst.Light:Enable(true)
		if inst:HasTag("oldpalace") then
			inst.AnimState:PlayAnimation("idle", true)
		else
			inst.AnimState:PlayAnimation("lit", true)
		end
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
    if child.parent ~= nil and not child.parent:HasTag("burnt") then
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
	LightsOn(inst)
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
    --print(inst, "OnStartDay")
    if not inst:HasTag("burnt")
        and inst.components.spawner:IsOccupied() then

        if inst.doortask ~= nil then
            inst.doortask:Cancel()
        end
        inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, onstartdaylighttask)
    end
end

local function onbuilt(inst)
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
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
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
	minimap:SetIcon("kyno_watchtower_palace.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetBank("palace")
	inst.AnimState:SetBuild("palace")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1.25)
	
	inst:AddTag("structure")
	inst:AddTag("pighouse")
	inst:AddTag("pigpalace")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	-- inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("spawner")
    inst.components.spawner:Configure("sap_pigman_queen", TUNING.TOTAL_DAY_TIME*4)
    inst.components.spawner.onoccupied = onoccupied
    inst.components.spawner.onvacate = onvacate
    inst.components.spawner:SetWaterSpawning(false, true)
    inst.components.spawner:CancelSpawning()
	
    inst.OnSave = onsave 
    inst.OnLoad = onload

    MakeHauntableWork(inst)
	
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)
    inst.inittask = inst:DoTaskInTime(0, oninit)

	return inst
end

local function oldfn()
	local inst = fn()
	
	inst.AnimState:SetBank("palace2")
	inst.AnimState:SetBuild("palace2")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("oldpalace")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"marble", "goldnugget", "pigskin"})
	
	return inst
end

local function palaceplacerfn(inst)
	inst.ApplySkin = function(inst, skin)
		if skin == "sap_pigpalace2" then
			inst.AnimState:SetBank("palace2")
			inst.AnimState:SetBuild("palace2")
			inst.AnimState:PlayAnimation("idle", true)
		end
	end
end

return Prefab("sap_pigpalace", fn, assets, prefabs),
Prefab("sap_pigpalace2", oldfn, assets, prefabs),
MakePlacer("sap_pigpalace_placer", "palace", "palace", "idle", false, nil, nil, nil, nil, nil, palaceplacerfn),
MakePlacer("sap_pigpalace2_placer", "palace2", "palace2", "idle")
--[[
CreateModPrefabSkin("sap_pigpalace2",
	{
		assets = {
			Asset("ANIM", "anim/palace2.zip"),
		},
		base_prefab = "sap_pigpalace",
		fn = oldfn,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "palace2",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	})
]]--