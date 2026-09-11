local assets =
{
    Asset("ANIM", "anim/bioluminessence.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local INTENSITY = .65

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
end

local function GetStatus(inst)
    return not inst.lighton and "ON" or nil
end

local function LightsOn(inst, isdusk, isnight)
if isdusk then
    inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("idle_pre")
	inst.AnimState:PushAnimation("idle_loop", true)
	inst.AnimState:Show("single_luminese")
	inst:RemoveTag("NOCLICK")
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
if isday then
	inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("idle_pst")    
	inst.AnimState:Hide("single_luminese")
	inst:AddTag("NOCLICK")
	inst:Hide()
	inst.Light:Enable(false)
	if inst:IsAsleep() then
		inst.Light:SetIntensity(0)
	else
		inst.components.fader:Fade(INTENSITY, 0, .75+math.random()*1, function(v) inst.Light:SetIntensity(v) end)
		end
	end
end

local function onworked(inst, worker)
	-- SpawnPrefab("fireflies").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
	local light = inst.entity:AddLight()
	
    inst.Light:SetFalloff(.45)
    inst.Light:SetIntensity(0.65)
    inst.Light:SetRadius(1)
    inst.Light:SetColour(0/255, 180/255, 255/255)
    inst.Light:SetIntensity(0.65)
    inst.Light:Enable(false)
    inst.Light:EnableClientModulation(true)

	inst.AnimState:SetBank("bioluminessence")
	inst.AnimState:SetBuild("bioluminessence")
	inst.AnimState:PlayAnimation("idle_loop", true)   
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetRayTestOnBB(true)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")

    inst:AddTag("cattoyairborne")
	inst:AddTag("flying")
	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("NOBLOCK")
	
	inst.no_wet_prefix = true

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("fader")
	inst:AddComponent("lighttweener")
    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onworked)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:DoTaskInTime(1, function()
        if TheWorld.state.isday and not TheWorld:HasTag("cave") then
            inst.AnimState:PlayAnimation("idle_pst")
			inst.AnimState:Hide("single_luminese")
			inst:Hide()
            inst.Light:Enable(false)
			inst.Light:SetIntensity(0)
			inst.components.fader:Fade(INTENSITY, 0, .75+math.random()*1, function(v) inst.Light:SetIntensity(v) end)
        else
			inst.AnimState:PlayAnimation("idle_pre")
			inst.AnimState:PushAnimation("idle_loop", true)
			inst.AnimState:Show("single_luminese")
			inst:Show()
            inst.Light:Enable(true)
			inst.Light:SetIntensity(INTENSITY)
			inst.components.fader:Fade(0, INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end)
        end
    end)
    inst:ListenForEvent("phasechanged", function(src, data)
        if data ~= "night" and data ~= "dusk" and not TheWorld:HasTag("cave") then
            inst:DoTaskInTime(2, function()
                inst.AnimState:PlayAnimation("idle_pst")
				inst.AnimState:Hide("single_luminese")
				inst:Hide()
				inst.Light:Enable(false)
				inst.Light:SetIntensity(0)
            end)
        else
            inst:DoTaskInTime(2, function()
				inst.AnimState:PlayAnimation("idle_pre")
				inst.AnimState:PushAnimation("idle_loop", true)
				inst.AnimState:Show("single_luminese")
				inst:Show()
				inst.Light:Enable(true)
				inst.Light:SetIntensity(INTENSITY)
            end)
        end
    end,TheWorld)
	
	inst.OnSave = function(inst, data)
        if inst.lighton then
            data.lighton = inst.lighton
        end
    end        

    inst.OnLoad = function(inst, data)    
        if data then
            if data.lighton then 
                fadein(inst)
                inst.AnimState:PlayAnimation("idle_pre")
				inst.AnimState:PushAnimation("idle_loop", true)
				inst.AnimState:Show("single_luminese")
				inst:Show()  
                inst.lighton = true
            end
        end
    end

    return inst
end

return Prefab("sap_bioluminescence", fn, assets),
MakePlacer("sap_bioluminescence_placer", "bioluminessence", "bioluminessence", "idle_loop")