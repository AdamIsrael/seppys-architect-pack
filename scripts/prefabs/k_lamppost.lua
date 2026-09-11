require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/lamp_post2.zip"),
    Asset("ANIM", "anim/lamp_post2_city_build.zip"),    
    Asset("ANIM", "anim/lamp_post2_yotp_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"collapse_small"
}

local INTENSITY = 0.6

local LAMP_DIST = 16
local LAMP_DIST_SQ = LAMP_DIST * LAMP_DIST

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function GetStatus(inst)
    return not inst.lighton and "ON" or nil
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
end

local function LightsOn(inst, isdusk, isnight)
	if isdusk then
		inst.components.fader:StopAll()
		
		-- inst.AnimState:PlayAnimation("on")
		-- inst.AnimState:PushAnimation("idle", true)
		
		inst.AnimState:Show("FIRE")
		inst.AnimState:Show("GLOW")       
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
		-- inst.AnimState:PlayAnimation("off")    
		-- inst.AnimState:PushAnimation("idle", true)
		
		inst.AnimState:Hide("FIRE")
		inst.AnimState:Hide("GLOW")
		inst.Light:Enable(false)
		
		if inst:IsAsleep() then
			inst.Light:SetIntensity(0)
		else
			inst.components.fader:Fade(INTENSITY, 0, .75 + math.random() * 1, function(v) inst.Light:SetIntensity(v) end)
		end
	end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(INTENSITY)
    inst.Light:SetRadius(12)
    inst.Light:Enable(false)
    inst.Light:SetColour(197/255, 197/255, 10/255)
	
	MakeObstaclePhysics(inst, 0.25)
	
	inst.AnimState:SetBank("lamp_post")
	inst.AnimState:SetBuild("lamp_post2_city_build")
	-- inst.AnimState:AddOverrideBuild("lamp_post2_yotp_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("lamp_post")
	
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
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
   
	inst:AddComponent("fader")
   
	-- inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:DoTaskInTime(1, function()
        if TheWorld.state.isday and not TheWorld:HasTag("cave") then
            -- inst.AnimState:PlayAnimation("off")
			inst.AnimState:PushAnimation("idle", true)
			
			inst.AnimState:Hide("FIRE")
			inst.AnimState:Hide("GLOW")
            inst.Light:Enable(false)
			
			inst.Light:SetIntensity(0)
			inst.components.fader:Fade(INTENSITY, 0, .75 + math.random() * 1, function(v) inst.Light:SetIntensity(v) end)
        else
			-- inst.AnimState:PlayAnimation("on")
			inst.AnimState:PushAnimation("idle", true)
			
			inst.AnimState:Show("FIRE")
			inst.AnimState:Show("GLOW")
            inst.Light:Enable(true)
			
			inst.Light:SetIntensity(INTENSITY)
			inst.components.fader:Fade(INTENSITY, INTENSITY, 3 + math.random() * 2, function(v) inst.Light:SetIntensity(v) end)
        end
    end)
	
    inst:ListenForEvent("phasechanged", function(src, data)
        if data ~= "night" and data ~= "dusk" and not TheWorld:HasTag("cave") then
            inst:DoTaskInTime(2, function()
                -- inst.AnimState:PlayAnimation("off")
				inst.AnimState:PushAnimation("idle", true)
				
                inst.AnimState:Hide("FIRE")
				inst.AnimState:Hide("GLOW")
				
				inst.Light:Enable(false)
				inst.Light:SetIntensity(0)
            end)
        else
            inst:DoTaskInTime(2, function()
				-- inst.AnimState:PlayAnimation("on")
                inst.AnimState:PushAnimation("idle", true)
				
				inst.AnimState:Show("FIRE")
				inst.AnimState:Show("GLOW")
				
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
				
                inst.AnimState:Show("FIRE")
                inst.AnimState:Show("GLOW")        
                inst.lighton = true
            end
        end
    end

	return inst
end

local function lampplacetestfn(inst)
    inst.AnimState:Hide("YOTP")
    inst.AnimState:Hide("SNOW")
    return true
end

return Prefab("kyno_lamppost", fn, assets, prefabs),
MakePlacer("kyno_lamppost_placer", "lamp_post", "lamp_post2_city_build", "idle", false, nil, nil, nil, nil, nil, lampplacetestfn)