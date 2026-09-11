local assets =
{
    Asset("ANIM", "anim/moonglass_bigwaterfall_steam.zip"),
    Asset("ANIM", "anim/moonglasspool_tile.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
    "grotto_waterfall_small1",
    "grotto_waterfall_small2",
    "grottopool_sfx",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function setup_children(inst)
    if inst._waterfall == nil then
        local wf = SpawnPrefab("grotto_waterfall_small"..math.random(1,2))
        wf.Transform:SetPosition(inst.Transform:GetWorldPosition())

        inst._waterfall = wf
    end

    if inst._waterfall ~= nil then
        inst._waterfall:ListenForEvent("onremove", function() inst._waterfall = nil end)
    end
end

local function register_pool(inst)
    TheWorld:PushEvent("ms_registergrottopool", {pool = inst, small = true})
end

local function on_save(inst, data)
    if inst._waterfall ~= nil then
        data.wf_id = inst._waterfall.GUID
        return {data.wf_id}
    end
end

local function on_load_postpass(inst, newents, data)
    if data ~= nil and data.wf_id ~= nil then
        local waterfall = newents[data.wf_id]
        if waterfall ~= nil then
            inst._waterfall = waterfall.entity
        end
    end
end

local function on_removed(inst)
    if inst._waterfall ~= nil then
        inst._waterfall:Remove()
    end
end

local function makesmallmist(proxy)
    if not proxy then
        return nil
    end

    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    local parent = proxy.entity:GetParent()
    if parent ~= nil then
        inst.entity:SetParent(parent.entity)
    end

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")

    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.Transform:SetFromProxy(proxy.GUID)

    inst.AnimState:SetBuild("moonglass_bigwaterfall_steam")
    inst.AnimState:SetBank("moonglass_bigwaterfall_steam")
    inst.AnimState:PlayAnimation("steam_small"..math.random(1,2), true)
    inst.AnimState:SetLightOverride(0.5)

    proxy:ListenForEvent("onremove", function() inst:Remove() end)

    return inst
end

local COLOUR_R, COLOUR_G, COLOUR_B = 227/255, 227/255, 227/255
local function poolfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, makesmallmist)
    end

    MakeObstaclePhysics(inst, TUNING.GROTTO_POOL_SMALL_RADIUS)

    inst.AnimState:SetBuild("moonglasspool_tile")
    inst.AnimState:SetBank("moonglasspool_tile")
    inst.AnimState:PlayAnimation("smallpool_idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetLightOverride(0.25)

    inst.MiniMapEntity:SetIcon("grotto_pool_small.png")

    inst.Light:SetColour(COLOUR_R, COLOUR_G, COLOUR_B)
    inst.Light:SetIntensity(0.3)
    inst.Light:SetFalloff(0.6)
    inst.Light:SetRadius(0.6)

    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    inst:AddTag("watersource")

    inst.no_wet_prefix = true

    inst:SetDeployExtraSpacing(2)
	
	inst:SetPrefabNameOverride("grotto_pool_small")

    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, register_pool)
    end

    inst.entity:SetPristine()
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("watersource")

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)

    inst:ListenForEvent("onremove", on_removed)
    
	if TheNet:IsDedicated() then
		inst:DoTaskInTime(0, setup_children)	
	else
		inst:DoTaskInTime(0, setup_children)
	end

    inst.OnSave = on_save
    inst.OnLoadPostPass = on_load_postpass

    return inst
end

local function poolfn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, TUNING.GROTTO_POOL_SMALL_RADIUS)

    inst.AnimState:SetBuild("moonglasspool_tile")
    inst.AnimState:SetBank("moonglasspool_tile")
    inst.AnimState:PlayAnimation("smallpool_idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetLightOverride(0.25)

    inst.MiniMapEntity:SetIcon("grotto_pool_small.png")

    inst.Light:SetColour(COLOUR_R, COLOUR_G, COLOUR_B)
    inst.Light:SetIntensity(0.3)
    inst.Light:SetFalloff(0.6)
    inst.Light:SetRadius(0.6)

    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    inst:AddTag("watersource")

    inst.no_wet_prefix = true

    inst:SetDeployExtraSpacing(2)
	
	inst:SetPrefabNameOverride("grotto_pool_small")

    if not TheNet:IsDedicated() then
        inst:DoTaskInTime(0, register_pool)
    end

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("watersource")

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)

    inst:ListenForEvent("onremove", on_removed)

    inst.OnSave = on_save
    inst.OnLoadPostPass = on_load_postpass

    return inst
end

return Prefab("sap_vitreoasis_small", poolfn, assets, prefabs),
Prefab("sap_vitreoasis2_small", poolfn2, assets, prefabs),
MakePlacer("sap_vitreoasis_small_placer", "moonglasspool_tile", "moonglasspool_tile", "smallpool_idle", true),
MakePlacer("sap_vitreoasis2_small_placer", "moonglasspool_tile", "moonglasspool_tile", "smallpool_idle", true)