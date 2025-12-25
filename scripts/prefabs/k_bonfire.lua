require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_bonfire.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst.SoundEmitter:KillSound("burning")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("off")
	inst.AnimState:PushAnimation("off")
	inst.SoundEmitter:KillSound("burning")
	inst.Light:Enable(false)
	inst.Light:SetIntensity(0)
end

local function LightsOn(inst, isdusk, isnight)
if isdusk then
	inst:AddComponent("cooker")
	inst:AddComponent("heater")
    inst.components.heater.heat = 100
    inst.AnimState:PlayAnimation("lit")
    inst.AnimState:PushAnimation("lit", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/campfire", "burning")
    inst.Light:Enable(true)
	inst.Light:SetIntensity(0.6)
	inst.lighton = true
	end
end

local function LightsOff(inst, isday)
if isday then
	inst:RemoveComponent("cooker")
	inst:RemoveComponent("heater")
    inst.AnimState:PlayAnimation("off")    
    inst.AnimState:PushAnimation("off", true)
	inst.SoundEmitter:KillSound("burning")
	inst.Light:Enable(false)
	inst.Light:SetIntensity(0)
	inst.lighton = false
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.60, .60, .60)
	
	inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(0.6)
    inst.Light:SetRadius(4)
    inst.Light:Enable(true)
    inst.Light:SetColour(197/255, 197/255, 10/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_bonfire.tex")
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("kyno_bonfire")
    inst.AnimState:SetBuild("kyno_bonfire")
    inst.AnimState:PlayAnimation("off")
    
	inst:AddTag("structure")
	inst:AddTag("bonfire")
	inst:AddTag("knife_party")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("cooker")
    
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CAMPFIRE"
	
	inst:AddComponent("heater")
    inst.components.heater.heat = 10
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
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
                inst.Light:Enable(true)
                inst.Light:SetIntensity(0.6)
                inst.lighton = true
            end
        end
    end
	
	MakeHauntableWork(inst)
	
    return inst
end

local function bonfireplacetestfn(inst)
	inst.AnimState:SetScale(.60, .60, .60)
end

return Prefab("kyno_bonfire", fn, assets),
MakePlacer("kyno_bonfire_placer", "kyno_bonfire", "kyno_bonfire", "lit", false, nil, nil, nil, nil, nil, bonfireplacetestfn)