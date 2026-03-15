require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/pig_townhouse2.zip"),
	Asset("ANIM", "anim/pig_townhouse3.zip"),
	Asset("ANIM", "anim/pig_townhouse4.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs = 
{
	"splash_sink",
	"pigman",
    "sap_pigman_collector",
    "sap_pigman_banker",
    "sap_pigman_beautician",
    "sap_pigman_florist",
    "sap_pigman_erudite",
    "sap_pigman_hunter",
    "sap_pigman_hatmaker",
    "sap_pigman_usher",
    "sap_pigman_mechanic",
    "sap_pigman_storeowner",
    "sap_pigman_professor",
}

local citizens_list = {
	[1] = "sap_pigman_banker",
	[2] = "sap_pigman_beautician",
	[3] = "sap_pigman_collector",
	[4] = "sap_pigman_erudite",
	[5] = "sap_pigman_florist",
	[6] = "sap_pigman_hunter",
	[7] = "sap_pigman_hatmaker",
	[8] = "sap_pigman_mechanic",
	[9] = "sap_pigman_professor",
	[10] = "sap_pigman_storeowner",
	[11] = "sap_pigman_usher",
}

local function LightsOn(inst)
    if not inst:HasTag("burnt") then
        inst.Light:Enable(true)
		if inst:HasTag("oldtownhouse") then
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
	
    MakeObstaclePhysics(inst, 1)
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_townhouse.tex")
	
    inst.AnimState:SetBank("pig_townhouse")
    inst.AnimState:SetBuild("pig_townhouse2")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:Hide("snow")
    
	inst:AddTag("structure")
	inst:AddTag("pigtownhouse")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_PIGHOUSE_CITY"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("spawner")
    inst.components.spawner:Configure(citizens_list[math.random(1, 11)], TUNING.TOTAL_DAY_TIME*4)
    inst.components.spawner.onoccupied = onoccupied
    inst.components.spawner.onvacate = onvacate
    inst.components.spawner:SetWaterSpawning(false, true)
    inst.components.spawner:CancelSpawning()
	
    inst.OnSave = onsave 
    inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
    inst.inittask = inst:DoTaskInTime(0, oninit)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function fn2()
	local inst = fn()
	
	inst.AnimState:SetBuild("pig_townhouse3")
	inst.AnimState:PlayAnimation("idle")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "boards", "cutstone", "pigskin", "pigskin"})
	
	return inst
end

local function fn3()
	local inst = fn()
	
	inst.AnimState:SetBuild("pig_townhouse4")
	inst.AnimState:PlayAnimation("idle")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "boards", "cutstone", "pigskin", "pigskin"})
	
	return inst
end

local function townplacerfn(inst)
	inst.AnimState:Hide("snow")
	inst.ApplySkin = function(inst, skin)
		if skin == "sap_pigtown2" then
			inst.AnimState:SetBuild("pig_townhouse3")
			inst.AnimState:PlayAnimation("idle")
		elseif skin == "sap_pigtown3" then
			inst.AnimState:SetBuild("pig_townhouse4")
			inst.AnimState:PlayAnimation("idle")
		end
	end
end

local function townplacefn(inst)
	inst.AnimState:Hide("snow")
end

return Prefab("sap_pigtown1", fn, assets),
Prefab("sap_pigtown2", fn2, assets),
Prefab("sap_pigtown3", fn3, assets),
MakePlacer("sap_pigtown1_placer", "pig_townhouse", "pig_townhouse2", "idle", false, nil, nil, nil, nil, nil, townplacerfn),
MakePlacer("sap_pigtown2_placer", "pig_townhouse", "pig_townhouse3", "idle", false, nil, nil, nil, nil, nil, townplacefn),
MakePlacer("sap_pigtown3_placer", "pig_townhouse", "pig_townhouse4", "idle", false, nil, nil, nil, nil, nil, townplacefn)
--[[,
CreateModPrefabSkin("sap_pigtown2",
	{
		assets = {
			Asset("ANIM", "anim/pig_townhouse3.zip"),
		},
		base_prefab = "sap_pigtown1",
		fn = fn2,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "pig_townhouse3",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("sap_pigtown3",
	{
		assets = {
			Asset("ANIM", "anim/pig_townhouse4.zip"),
		},
		base_prefab = "sap_pigtown1",
		fn = fn3,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "pig_townhouse4",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	})
]]--