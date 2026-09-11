require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_lamp_post.zip"),
	Asset("ANIM", "anim/kyno_lamp_post_short.zip"),
}

local INTENSITY = 0.75

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function GetStatus(inst)
    return not inst.lighton and "ON" or nil
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle_off", true)
    inst.AnimState:PushAnimation("idle_off", true)
end

local function LightsOn(inst, isdusk, isnight)
	if isdusk then
		inst.components.fader:StopAll()
    
		inst.AnimState:PlayAnimation("idle_on")
		inst.AnimState:PushAnimation("idle_on", true)
	
		inst.AnimState:Show("glow")       
		inst.Light:Enable(true)
	
		if inst:IsAsleep() then
			inst.Light:SetIntensity(INTENSITY)
		else
			inst.Light:SetIntensity(0)
			inst.components.fader:Fade(0, INTENSITY, 3 + math.random() * 2, function(v) inst.Light:SetIntensity(v) end)
		end
	end
end

local function LightsOff(inst, isday)
	if isday then
		inst.components.fader:StopAll()
		
		inst.AnimState:PlayAnimation("idle_off")    
		inst.AnimState:PushAnimation("idle_off", true)
	
		inst.AnimState:Hide("glow")
		inst.Light:Enable(false)
	
		if inst:IsAsleep() then
			inst.Light:SetIntensity(0)
		else
			inst.components.fader:Fade(INTENSITY, 0, .75 + math.random() * 1, function(v) inst.Light:SetIntensity(v) end)
		end
	end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("idle_on")
end

local function tallfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.58)
    inst.Light:SetIntensity(INTENSITY)
    inst.Light:SetRadius(12)
    inst.Light:SetColour(235/255, 235/255, 235/255)
	inst.Light:Enable(true)
	
    MakeObstaclePhysics(inst, .2)
	
    inst.AnimState:SetBank("kyno_lamp_post")
    inst.AnimState:SetBuild("kyno_lamp_post")
    inst.AnimState:PlayAnimation("idle_on")
    
	inst:AddTag("structure")
	inst:AddTag("streetlamp")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_LAMP_POST"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("fader")
	
	-- inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
	inst:DoTaskInTime(1, function()
        if TheWorld.state.isday and not TheWorld:HasTag("cave") then
            inst.AnimState:PlayAnimation("idle_off")
			inst.AnimState:PushAnimation("idle_off", true)
			
            inst.Light:Enable(false)
			inst.Light:SetIntensity(0)
			inst.components.fader:Fade(INTENSITY, 0, .75 + math.random() * 1, function(v) inst.Light:SetIntensity(v) end)
        else
			inst.AnimState:PlayAnimation("idle_on")
			inst.AnimState:PushAnimation("idle_on", true)
			
            inst.Light:Enable(true)
			inst.Light:SetIntensity(INTENSITY)
			inst.components.fader:Fade(INTENSITY, INTENSITY, 3 + math.random() * 2, function(v) inst.Light:SetIntensity(v) end)
        end
    end)
	
    inst:ListenForEvent("phasechanged", function(src, data)
        if data ~= "night" and data ~= "dusk" and not TheWorld:HasTag("cave") then
            inst:DoTaskInTime(2, function()
                inst.AnimState:PlayAnimation("idle_off")
				inst.AnimState:PushAnimation("idle_off", true)
				
				inst.Light:Enable(false)
				inst.Light:SetIntensity(0)
            end)
        else
            inst:DoTaskInTime(2, function()
				inst.AnimState:PlayAnimation("idle_on")
				inst.AnimState:PushAnimation("idle_on", true)
				
				inst.Light:Enable(true)
				inst.Light:SetIntensity(INTENSITY)
            end)
        end
    end, TheWorld)
	
	inst.OnSave = function(inst, data)
        if inst.lighton then
            data.lighton = inst.lighton
        end
    end        

    inst.OnLoad = function(inst, data)    
        if data then
            if data.lighton then 
                fadein(inst)
				
                inst.Light:Enable(true)
                inst.Light:SetIntensity(INTENSITY)
				
                inst.AnimState:Show("glow")        
                inst.lighton = true
            end
        end
    end
	
    return inst
end

local function shortfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.58)
    inst.Light:SetIntensity(INTENSITY)
    inst.Light:SetRadius(12)
    inst.Light:SetColour(200/255, 200/255, 200/255)
	inst.Light:Enable(true)
	
    MakeObstaclePhysics(inst, .2)
	
    inst.AnimState:SetBank("kyno_lamp_post_short")
    inst.AnimState:SetBuild("kyno_lamp_post_short")
    inst.AnimState:PlayAnimation("idle_on")
    
	inst:AddTag("structure")
	inst:AddTag("streetlamp_short")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_LAMP_SHORT"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("fader")
	
	-- inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
	inst:DoTaskInTime(1, function()
        if TheWorld.state.isday and not TheWorld:HasTag("cave") then
            inst.AnimState:PlayAnimation("idle_off")
			inst.AnimState:PushAnimation("idle_off", true)
			
            inst.Light:Enable(false)
			inst.Light:SetIntensity(0)
			inst.components.fader:Fade(INTENSITY, 0, .75 + math.random() * 1, function(v) inst.Light:SetIntensity(v) end)
        else
			inst.AnimState:PlayAnimation("idle_on")
			inst.AnimState:PushAnimation("idle_on", true)
			
            inst.Light:Enable(true)
			inst.Light:SetIntensity(INTENSITY)
			inst.components.fader:Fade(INTENSITY, INTENSITY, 3 + math.random() * 2, function(v) inst.Light:SetIntensity(v) end)
        end
    end)
    inst:ListenForEvent("phasechanged", function(src, data)
        if data ~= "night" and data ~= "dusk" and not TheWorld:HasTag("cave") then
            inst:DoTaskInTime(2, function()
                inst.AnimState:PlayAnimation("idle_off")
				inst.AnimState:PushAnimation("idle_off", true)
				
				inst.Light:Enable(false)
				inst.Light:SetIntensity(0)
            end)
        else
            inst:DoTaskInTime(2, function()
				inst.AnimState:PlayAnimation("idle_on")
				inst.AnimState:PushAnimation("idle_on", true)
				
				inst.Light:Enable(true)
				inst.Light:SetIntensity(INTENSITY)
            end)
        end
    end, TheWorld)
	
	inst.OnSave = function(inst, data)
        if inst.lighton then
            data.lighton = inst.lighton
        end
    end        

    inst.OnLoad = function(inst, data)    
        if data then
            if data.lighton then 
                fadein(inst)
				
                inst.Light:Enable(true)
                inst.Light:SetIntensity(INTENSITY)
				
                inst.AnimState:Show("glow")        
                inst.lighton = true
            end
        end
    end
	
    return inst
end

return Prefab("sap_streetlight1", tallfn, assets),
Prefab("sap_streetlight2", shortfn, assets),
MakePlacer("sap_streetlight1_placer", "kyno_lamp_post", "kyno_lamp_post", "idle_off"),
MakePlacer("sap_streetlight2_placer", "kyno_lamp_post_short", "kyno_lamp_post_short", "idle_off")