require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/atrium_light.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "kyno_atriumlightback",
    "kyno_atriumlightlight",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function GetStatus(inst)
    return not inst.lighton and "ON" or nil
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Light:Enable(false)
    inst.Light:SetRadius(8)
    inst.Light:SetFalloff(.9)
    inst.Light:SetIntensity(.65)
    inst.Light:SetColour(200 / 255, 140 / 255, 140 / 255)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("atrium_light.png")
	
    MakeObstaclePhysics(inst, .45)
	
    inst.AnimState:SetBank("atrium_light")
    inst.AnimState:SetBuild("atrium_light")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetFinalOffset(2)
	inst.AnimState:Hide("back")
    
	inst:AddTag("structure")
	inst:AddTag("atrium_beacon")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
		inst.highlightchildren = {}
        return inst
    end
	
	inst._back = SpawnPrefab("kyno_atriumlightback")
    inst._back.entity:SetParent(inst.entity)

    inst._light = SpawnPrefab("kyno_atriumlightlight")
    inst._light.entity:SetParent(inst.entity)

    inst.highlightchildren = { inst._back, inst._light }
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	local function OnTurnedOff(_light)
        inst:RemoveEventCallback("animover", OnTurnedOff, _light)
        inst.AnimState:PlayAnimation("idle")
        inst._back.AnimState:PlayAnimation("idle")
        _light.AnimState:PlayAnimation("light_idle")
    end
	
	inst:WatchWorldState("isdusk", function(_, ispowered)
        if ispowered then
            if not inst.Light:IsEnabled() then
                inst.Light:Enable(true)
                inst:RemoveEventCallback("animover", OnTurnedOff, inst._light)
                inst.AnimState:PlayAnimation("idle_active")
                inst._back.AnimState:PlayAnimation("idle_active")
                inst._light.AnimState:PlayAnimation("light_turn_on")
                inst._light.AnimState:PushAnimation("light_idle_active", false)
            end
        elseif inst.Light:IsEnabled() then
            inst.Light:Enable(false)
            inst:ListenForEvent("animover", OnTurnedOff, inst._light)
            inst._light.AnimState:PlayAnimation("light_turn_off")
        end
    end, TheWorld)
	
	inst:WatchWorldState("isnight", function(_, ispowered)
        if ispowered then
            if not inst.Light:IsEnabled() then
                inst.Light:Enable(true)
                inst:RemoveEventCallback("animover", OnTurnedOff, inst._light)
                inst.AnimState:PlayAnimation("idle_active")
                inst._back.AnimState:PlayAnimation("idle_active")
                inst._light.AnimState:PlayAnimation("light_turn_on")
                inst._light.AnimState:PushAnimation("light_idle_active", false)
            end
        elseif inst.Light:IsEnabled() then
            inst.Light:Enable(false)
            inst:ListenForEvent("animover", OnTurnedOff, inst._light)
            inst._light.AnimState:PlayAnimation("light_turn_off")
        end
    end, TheWorld)
	
    return inst
end

local function OnEntityReplicated(inst)
    local parent = inst.entity:GetParent()
    if parent ~= nil and parent.prefab == "kyno_atriumbeacon" then
        table.insert(parent.highlightchildren, inst)
    end
end

local function back_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("atrium_light")
    inst.AnimState:SetBuild("atrium_light")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:Hide("front")

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = OnEntityReplicated

        return inst
    end

    inst.persists = false

    return inst
end

local function light_fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("atrium_light")
    inst.AnimState:SetBuild("atrium_light")
    inst.AnimState:PlayAnimation("light_idle")
    inst.AnimState:SetFinalOffset(1)

    inst:AddTag("DECOR") --"FX" will catch mouseover
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = OnEntityReplicated

        return inst
    end

    inst.persists = false

    return inst
end

return Prefab("kyno_atriumbeacon", fn, assets, prefabs),
Prefab("kyno_atriumlightback", back_fn, assets),
Prefab("kyno_atriumlightlight", light_fn, assets),
MakePlacer("kyno_atriumbeacon_placer", "atrium_light", "atrium_light", "idle")