require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_flowerlight_post.zip"),
	Asset("ANIM", "anim/kyno_flowerlight_post2.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"collapse_small"
}

local INTENSITY = 0.75

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
	if inst:HasTag("flowerlight_post1") then
		inst.SoundEmitter:PlaySound("dontstarve/common/together/mushroom_lamp/craft_1")
	else
		inst.SoundEmitter:PlaySound("dontstarve/common/together/mushroom_lamp/craft_2")
	end
end

local function OnBurnt(inst)
	inst:DoTaskInTime( 0.5, function() if inst.components.burnable then inst.components.burnable:Extinguish() end
		inst:RemoveComponent("burnable")
		inst:RemoveComponent("propagator")
	
		inst.components.lootdropper:SetLoot({"charcoal"})
			
		if inst.components.workable then
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnFinishCallback(onhammered)
		end
	end)
    
	inst.AnimState:PlayAnimation("burnt", true)
	inst.AnimState:Hide("glow")
	inst.AnimState:Hide("glow-0")
    inst.AnimState:SetRayTestOnBB(true)
	inst.Light:Enable(false)
	
    inst:AddTag("burnt")
end

local function GetStatus(inst)
    return not inst.lighton and "ON" or nil
end

local function LightsOn(inst, isdusk, isnight)
if isdusk and not inst:HasTag("burnt") then
    inst.components.fader:StopAll()
    -- inst.AnimState:PlayAnimation("colour_change")
    inst.AnimState:PushAnimation("idle", true)
	inst.AnimState:Show("glow")       
	inst.AnimState:Show("glow-0")
    inst.Light:Enable(true)
	if inst:IsAsleep() then
		inst.Light:SetIntensity(INTENSITY)
	else
		inst.Light:SetIntensity(0)
		inst.components.fader:Fade(0, INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end)
		end
	end
end

local function LightsOff(inst, isday)
if isday and not inst:HasTag("burnt") then
	inst.components.fader:StopAll()
    -- inst.AnimState:PlayAnimation("colour_change")    
    inst.AnimState:PushAnimation("idle", true)
	inst.AnimState:Hide("glow")
	inst.AnimState:Hide("glow-0")
	inst.Light:Enable(false)
	if inst:IsAsleep() then
		inst.Light:SetIntensity(0)
	else
		inst.components.fader:Fade(INTENSITY, 0, .75+math.random()*1, function(v) inst.Light:SetIntensity(v) end)
		end
	end
end

local function post1fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.85)
    inst.Light:SetIntensity(INTENSITY)
    inst.Light:SetRadius(12)
    inst.Light:Enable(true)
    inst.Light:SetColour(237/255, 237/255, 209/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("mushroom_light.png")
	
	inst.AnimState:SetScale(.75, .75, .75)
	
    MakeObstaclePhysics(inst, .3)
	
    inst.AnimState:SetBank("kyno_flowerlight_post")
    inst.AnimState:SetBuild("kyno_flowerlight_post")
    inst.AnimState:PlayAnimation("idle", true)
    
	inst:AddTag("structure")
	inst:AddTag("flowerlight_post1")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	inst:AddComponent("fader")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	MakeMediumBurnable(inst)
    MakeMediumPropagator(inst)
    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

	inst:DoTaskInTime(1, function()
        if TheWorld.state.isday and not TheWorld:HasTag("cave") then
			if not inst:HasTag("burnt") then
            -- inst.AnimState:PlayAnimation("colour_change")
			inst.AnimState:PushAnimation("idle", true)
			inst.AnimState:Hide("glow")
			inst.AnimState:Hide("glow-0")
            inst.Light:Enable(false)
			inst.Light:SetIntensity(0)
			inst.components.fader:Fade(INTENSITY, 0, .75+math.random()*1, function(v) inst.Light:SetIntensity(v) end)
			end
        else
			if not inst:HasTag("burnt") then
			-- inst.AnimState:PlayAnimation("colour_change")
			inst.AnimState:PushAnimation("idle", true)
			inst.AnimState:Show("glow")
			inst.AnimState:Show("glow-0")
            inst.Light:Enable(true)
			inst.Light:SetIntensity(INTENSITY)
			inst.components.fader:Fade(0, INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end)
			end
        end
    end)
    inst:ListenForEvent("phasechanged", function(src, data)
        if data ~= "night" and data ~= "dusk" and not TheWorld:HasTag("cave") then
            inst:DoTaskInTime(2, function()
				if not inst:HasTag("burnt") then
                -- inst.AnimState:PlayAnimation("colour_change")
				inst.AnimState:PushAnimation("idle", true)
				inst.AnimState:Hide("glow")
				inst.AnimState:Hide("glow-0")
				inst.Light:Enable(false)
				inst.Light:SetIntensity(0)
				end
            end)
        else
            inst:DoTaskInTime(2, function()
				if not inst:HasTag("burnt") then
				-- inst.AnimState:PlayAnimation("colour_change")
				inst.AnimState:PushAnimation("idle", true)
				inst.AnimState:Show("glow")
				inst.AnimState:Show("glow-0")
				inst.Light:Enable(true)
				inst.Light:SetIntensity(INTENSITY)
				end
            end)
        end
    end,TheWorld)
	
	inst.OnSave = function(inst, data)
        if inst.lighton then
            data.lighton = inst.lighton
        end
		
		if inst:HasTag("burnt") or inst:HasTag("fire") then
			data.burnt = true
		end
    end        

    inst.OnLoad = function(inst, data)    
        if data then
            if data.lighton then
				if not inst:HasTag("burnt") then
                fadein(inst)
                inst.Light:Enable(true)
                inst.Light:SetIntensity(INTENSITY)            
                inst.AnimState:Show("glow")
				inst.AnimState:Show("glow-0")
                inst.lighton = true
				end
            end
			if data.burnt then
				OnBurnt(inst)
			end
        end
    end
	
    return inst
end

local function post2fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.85)
    inst.Light:SetIntensity(INTENSITY)
    inst.Light:SetRadius(12)
    inst.Light:Enable(true)
    inst.Light:SetColour(237/255, 237/255, 209/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("mushroom_light.png")
	
    MakeObstaclePhysics(inst, .3)
	
    inst.AnimState:SetBank("kyno_flowerlight_post2")
    inst.AnimState:SetBuild("kyno_flowerlight_post2")
    inst.AnimState:PlayAnimation("idle", true)
    
	inst:AddTag("structure")
	inst:AddTag("flowerlight_post2")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	inst:AddComponent("fader")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	MakeMediumBurnable(inst)
    MakeMediumPropagator(inst)
    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

	inst:DoTaskInTime(1, function()
        if TheWorld.state.isday and not TheWorld:HasTag("cave") then
			if not inst:HasTag("burnt") then
            -- inst.AnimState:PlayAnimation("colour_change")
			inst.AnimState:PushAnimation("idle", true)
			inst.AnimState:Hide("glow")
			inst.AnimState:Hide("glow-0")
            inst.Light:Enable(false)
			inst.Light:SetIntensity(0)
			inst.components.fader:Fade(INTENSITY, 0, .75+math.random()*1, function(v) inst.Light:SetIntensity(v) end)
			end
        else
			if not inst:HasTag("burnt") then
			-- inst.AnimState:PlayAnimation("colour_change")
			inst.AnimState:PushAnimation("idle", true)
			inst.AnimState:Show("glow")
			inst.AnimState:Show("glow-0")
            inst.Light:Enable(true)
			inst.Light:SetIntensity(INTENSITY)
			inst.components.fader:Fade(0, INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end)
			end
        end
    end)
    inst:ListenForEvent("phasechanged", function(src, data)
        if data ~= "night" and data ~= "dusk" and not TheWorld:HasTag("cave") then
            inst:DoTaskInTime(2, function()
				if not inst:HasTag("burnt") then
                -- inst.AnimState:PlayAnimation("colour_change")
				inst.AnimState:PushAnimation("idle", true)
				inst.AnimState:Hide("glow")
				inst.AnimState:Hide("glow-0")
				inst.Light:Enable(false)
				inst.Light:SetIntensity(0)
				end
            end)
        else
            inst:DoTaskInTime(2, function()
				if not inst:HasTag("burnt") then
				-- inst.AnimState:PlayAnimation("colour_change")
				inst.AnimState:PushAnimation("idle", true)
				inst.AnimState:Show("glow")
				inst.AnimState:Show("glow-0")
				inst.Light:Enable(true)
				inst.Light:SetIntensity(INTENSITY)
				end
            end)
        end
    end,TheWorld)
	
	inst.OnSave = function(inst, data)
        if inst.lighton then
            data.lighton = inst.lighton
        end
		
		if inst:HasTag("burnt") or inst:HasTag("fire") then
			data.burnt = true
		end
    end        

    inst.OnLoad = function(inst, data)    
        if data then
            if data.lighton then 
				if not inst:HasTag("burnt") then
                fadein(inst)
                inst.Light:Enable(true)
                inst.Light:SetIntensity(INTENSITY)            
                inst.AnimState:Show("glow")
				inst.AnimState:Show("glow-0")
                inst.lighton = true
				end
            end
			if data.burnt then
				OnBurnt(inst)
			end
        end
    end
	
    return inst
end

local function flowerlightpostplacer(inst)
	inst.AnimState:SetScale(.75, .75, .75)
end

return Prefab("sap_flowerlight_post1", post1fn, assets, prefabs),
Prefab("sap_flowerlight_post2", post2fn, assets, prefabs),
MakePlacer("sap_flowerlight_post1_placer", "kyno_flowerlight_post", "kyno_flowerlight_post", "idle", false, nil, nil, nil, nil, nil, flowerlightpostplacer),
MakePlacer("sap_flowerlight_post2_placer", "kyno_flowerlight_post2", "kyno_flowerlight_post2", "idle")
