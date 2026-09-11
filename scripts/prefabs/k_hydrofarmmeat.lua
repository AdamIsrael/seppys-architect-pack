require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/hydroponic_slow_farmplot.zip"),	
	Asset("ANIM", "anim/hydroponic_fast_farmplot.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs =
{
    "meat",
	"hambat",
}

local HYDROFARM_SLOW_TIME = 2880
local HYDROFARM_FAST_TIME = 1920

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("Idle", true)
	inst.components.pickable:MakeEmpty()
end

local function onbuilt2(inst)
    inst.AnimState:PushAnimation("idle", true)
	inst.components.pickable:MakeEmpty()
end

local function onpickedfn(inst)
	inst.AnimState:PushAnimation("picked", true)
end

local function onpickedfn2(inst)
	inst.AnimState:PushAnimation("picked", true)
end

local function onregenfn(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PlayAnimation("grow_pst")
	inst.AnimState:PushAnimation("Idle2", true)
end

local function onregenfn2(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PlayAnimation("grow_pst")
	inst.AnimState:PushAnimation("idle2", true)
end

local function makeemptyfn(inst)
   inst.AnimState:PushAnimation("Idle", true)
end

local function makeemptyfn2(inst)
   inst.AnimState:PushAnimation("idle", true)
end

local function ShouldAcceptItem(inst, item)
	if item.components.inventoryitem ~= nil then
	return true
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.prefab == "hambat" then
		inst.components.pickable:ChangeProduct("hambat")
		inst.components.pickable:MakeEmpty()
	elseif item.prefab == "meat" then
		inst.components.pickable:ChangeProduct("meat")
		inst.components.pickable:MakeEmpty()
	elseif item.prefab == "smallmeat" then
		inst.components.pickable:ChangeProduct("smallmeat")
		inst.components.pickable:MakeEmpty()
	end
	print("CHANGED FARM PRODUCT")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_slow_hydrofarmmeat.tex")
	
    inst.AnimState:SetBank("hydroponic_slow_farmplot")
    inst.AnimState:SetBuild("hydroponic_slow_farmplot")
    inst.AnimState:PlayAnimation("Idle", true)

	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve_DLC002/common/item_wet_harvest"
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable:SetUp("meat", HYDROFARM_SLOW_TIME)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_fast_hydrofarmmeat.tex")
	
    inst.AnimState:SetBank("hydroponic_fast_farmplot")
    inst.AnimState:SetBuild("hydroponic_fast_farmplot")
    inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve_DLC002/common/item_wet_harvest"
    inst.components.pickable.onregenfn = onregenfn2
    inst.components.pickable.onpickedfn = onpickedfn2
    inst.components.pickable.makeemptyfn = makeemptyfn2
	inst.components.pickable:SetUp("meat", HYDROFARM_FAST_TIME)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt2)

    return inst
end

return Prefab("sap_slow_hydrofarmmeat", fn, assets, prefabs),
Prefab("sap_fast_hydrofarmmeat", fn2, assets, prefabs),
MakePlacer("sap_slow_hydrofarmmeat_placer", "hydroponic_slow_farmplot", "hydroponic_slow_farmplot", "Idle"),
MakePlacer("sap_fast_hydrofarmmeat_placer", "hydroponic_fast_farmplot", "hydroponic_fast_farmplot", "idle")