require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/portal_stone.zip"),
	Asset("ANIM", "anim/portal_stone_construction.zip"),
	Asset("ANIM", "anim/portal_moonrock.zip"),
	Asset("ANIM", "anim/portal_juryrigged.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local INTENSITY = 0.6

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst.SoundEmitter:KillSound("spawnportal_idle_LP")
	inst.SoundEmitter:KillSound("spawnportal_idle")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:PushAnimation("idle_loop", true)
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle_loop")
	inst.AnimState:PushAnimation("idle_loop", true)
	-- inst.SoundEmitter:PlaySound("dontstarve/common/together/spawn_vines/spawnportal_spawning")
end

local function onbuilt_moon(inst)
	inst.AnimState:PlayAnimation("fx")
	inst.AnimState:PushAnimation("idle_loop", true)
	-- inst.SoundEmitter:PlaySound("dontstarve/common/together/spawn_portal_celestial/reveal")
end
	
local function Scratch(inst)
if inst:HasTag("dstmultiplayerportal") then
	inst:DoTaskInTime(10+math.random()*5, function() Scratch(inst) end)
		inst.AnimState:PlayAnimation("idle_eyescratch")
		-- inst.SoundEmitter:PlaySound("dontstarve/common/together/spawn_vines/spawnportal_scratch")
		inst.AnimState:PushAnimation("idle_loop", true)
	end
end

local function LightsOn(inst, isdusk, isnight)
if isdusk then
    inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:PushAnimation("idle_loop", true)
	inst.AnimState:Show("glow")       
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
    inst.AnimState:PlayAnimation("idle_loop")    
    inst.AnimState:PushAnimation("idle_loop", true)
	inst.AnimState:Hide("glow")
	inst.Light:Enable(false)
	if inst:IsAsleep() then
		inst.Light:SetIntensity(0)
	else
		inst.components.fader:Fade(INTENSITY, 0, .75+math.random()*1, function(v) inst.Light:SetIntensity(v) end)
		end
	end
end

local function GetStatus(inst)
    return not inst.lighton and "ON" or nil
end

local function IdleSound(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/together/spawn_vines/spawnportal_idle_LP")
end

local function IdleSoundMoon(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/together/spawn_vines/spawnportal_idle")
end

local function charliefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("portal_dst.png")
	
    inst.AnimState:SetBank("portal_dst")
    inst.AnimState:SetBuild("portal_stone")
    inst.AnimState:PlayAnimation("idle_loop", true)
    
	inst:AddTag("structure")
	inst:AddTag("dstmultiplayerportal")
	inst:AddTag("resurrector")
	
	inst:SetPrefabNameOverride("multiplayer_portal")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
	
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	Scratch(inst)
	IdleSound(inst)
	
    return inst
end

local function buildfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("portal_dst.png")
	
    inst.AnimState:SetBank("portal_construction_dst")
    inst.AnimState:SetBuild("portal_stone_construction")
	inst.AnimState:AddOverrideBuild("portal_stone")
    inst.AnimState:PlayAnimation("idle_loop", true)
    -- inst.AnimState:OverrideSymbol("portal01", "portal01", "portal01")
	inst.AnimState:Hide("stage2")
	inst.AnimState:Hide("stage3")
	inst.AnimState:Hide("moonrock_vines_0")
	inst.AnimState:Hide("moonrock_vines_1")
	inst.AnimState:Hide("moonrock_vines_2")
	inst.AnimState:Hide("moonrock_vines_3")
	inst.AnimState:Hide("moonrock_vines_4")
	inst.AnimState:Hide("moonrock_vines_5")
	inst.AnimState:Hide("moonrock_vines_6")
	inst.AnimState:Hide("moonrock_vines_7")
	inst.AnimState:Hide("eye")
	inst.AnimState:Show("portal01")
    
	inst:AddTag("structure")
	inst:AddTag("portal_building")
	inst:AddTag("resurrector")
	
	inst:SetPrefabNameOverride("multiplayer_portal")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
	
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	Scratch(inst)
	IdleSound(inst)
	
    return inst
end

local function celestialfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("portal_dst.png")
	
    inst.AnimState:SetBank("portal_moonrock_dst")
    inst.AnimState:SetBuild("portal_moonrock")
    inst.AnimState:PlayAnimation("idle_loop", true)
    
	inst:AddTag("structure")
	inst:AddTag("dstmultiplayerportal")
	inst:AddTag("resurrector")
	
	inst:SetPrefabNameOverride("multiplayer_portal_moonrock")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
	
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", onbuilt_moon)
	
	Scratch(inst)
	IdleSoundMoon(inst)
	
    return inst
end

local function legacyfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(INTENSITY)
    inst.Light:SetRadius(4)
    inst.Light:Enable(true)
    inst.Light:SetColour(197/255, 197/255, 10/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("portal_dst.png")
	
    inst.AnimState:SetBank("portal_legacy")
    inst.AnimState:SetBuild("portal_juryrigged")
    inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:Hide("portaldoormagic_cycle")
	
	inst:AddTag("structure")
	inst:AddTag("dstmultiplayerportal")
	inst:AddTag("resurrector")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
	
	inst:AddComponent("fader")
	
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:DoTaskInTime(1/30, function()
	inst:WatchWorldState("isday", LightsOff)
    LightsOff(inst, TheWorld.state.isday)
	end)
	
	inst:DoTaskInTime(1/30, function()
	inst:WatchWorldState("isdusk", LightsOn)
	inst:WatchWorldState("isnight", LightsOn)
    LightsOn(inst, TheWorld.state.isdusk)
	LightsOn(inst, TheWorld.state.isnight)
	end)
	
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
	
	Scratch(inst)
	IdleSound(inst)
	
    return inst
end

local function buildingplacetestfn(inst)
	inst.AnimState:AddOverrideBuild("portal_stone")
	inst.AnimState:Hide("stage2")
	inst.AnimState:Hide("stage3")
	inst.AnimState:Hide("moonrock_vines_0")
	inst.AnimState:Hide("moonrock_vines_1")
	inst.AnimState:Hide("moonrock_vines_2")
	inst.AnimState:Hide("moonrock_vines_3")
	inst.AnimState:Hide("moonrock_vines_4")
	inst.AnimState:Hide("moonrock_vines_5")
	inst.AnimState:Hide("moonrock_vines_6")
	inst.AnimState:Hide("moonrock_vines_7")
	inst.AnimState:Hide("eye")
	inst.AnimState:Show("portal01")
end

return Prefab("kyno_portalstone", charliefn, assets),
Prefab("kyno_juryriggedportal", legacyfn, assets),
Prefab("kyno_portalbuilding", buildfn, assets),
Prefab("kyno_celestialportal", celestialfn, assets),
MakePlacer("kyno_juryriggedportal_placer", "portal_legacy", "portal_juryrigged", "idle_loop"),
MakePlacer("kyno_portalstone_placer", "portal_dst", "portal_stone", "idle_loop"),
MakePlacer("kyno_portalbuilding_placer", "portal_construction_dst", "portal_stone_construction", "idle_loop", false, nil, nil, nil, nil, nil, buildingplacetestfn),
MakePlacer("kyno_celestialportal_placer", "portal_moonrock_dst", "portal_moonrock", "idle_loop")