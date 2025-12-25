local assets =
{
    Asset("ANIM", "anim/teleporter_worm.zip"),
    Asset("ANIM", "anim/teleporter_worm_build.zip"),
	Asset("ANIM", "anim/teleporter_sickworm_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
    Asset("SOUND", "sound/common.fsb"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.AnimState:PlayAnimation("death")
	inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/sick_die")
	inst:DoPeriodicTask(2.0, function()
	inst:Remove()
	end)
end

local function onhammered_sick(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.AnimState:PlayAnimation("death")
	inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/sick_die")
	inst:DoTaskInTime(1, function() inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/sick_splat") end)
	inst:DoPeriodicTask(2.0, function()
	inst:Remove()
	end)
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("idle_loop")
	inst.AnimState:PushAnimation("idle_loop", true)
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("open_pre")
	inst.AnimState:PushAnimation("open_loop", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/idle", "wormhole_open")
end

local function onfar(inst)
	inst.AnimState:PlayAnimation("open_pst")
	inst.AnimState:PushAnimation("idle_loop", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/close")
end

local function Cough(inst)
if inst:HasTag("wormhole_grinder_sick") then
	inst:DoTaskInTime(5+math.random()*5, function() Cough(inst) end)
		inst.AnimState:PlayAnimation("cough")
		inst:DoTaskInTime(0.6, function() inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/sick_cough") end)
		inst:DoTaskInTime(1.0, function() inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/sick_cough") end)
		inst.AnimState:PushAnimation("idle_loop", true)
	end
end

local function ShouldAcceptItem(inst, item)
	if item.components.inventoryitem ~= nil then
	return true
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.inventoryitem ~= nil and not item:HasTag("PUGALISK_CANT_EAT") then
		inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/swallow")
		item:Remove()
	elseif
		item:HasTag("KeyReplica") then
		inst.components.lootdropper:SpawnLootPrefab("atrium_key")
		inst.SoundEmitter:PlaySound("dontstarve/common/teleportworm/swallow")
	end
		print("ITEM REMOVED OR WORMHOLE REFUSED IT")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("wormhole.png")
	
	inst.AnimState:SetBank("teleporter_worm")
	inst.AnimState:SetBuild("teleporter_worm_build")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("alltrader")
	inst:AddTag("wormhole_grinder")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "WORMHOLE"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(2)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 5)
    inst.components.playerprox.onnear = onnear
    inst.components.playerprox.onfar = onfar

	return inst
end

local function sickfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_wormhole_sick.tex")
	
	inst.AnimState:SetBank("teleporter_worm")
	inst.AnimState:SetBuild("teleporter_sickworm_build")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("alltrader")
	inst:AddTag("wormhole_grinder_sick")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "WORMHOLE"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_sick)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(2)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 5)
    inst.components.playerprox.onnear = onnear
    inst.components.playerprox.onfar = onfar
	
	Cough(inst)

	return inst
end

return Prefab("kyno_wormhole", fn, assets, prefabs),
Prefab("kyno_wormhole_sick", sickfn, assets, prefabs),
MakePlacer("kyno_wormhole_placer", "teleporter_worm", "teleporter_worm_build", "idle_loop"),
MakePlacer("kyno_wormhole_sick_placer", "teleporter_worm", "teleporter_sickworm_build", "idle_loop")