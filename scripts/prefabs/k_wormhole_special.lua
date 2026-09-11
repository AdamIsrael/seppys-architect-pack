require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/wormhole_hamlet.zip"),
	Asset("ANIM", "anim/wormhole_shipwrecked.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("in")
    inst.AnimState:PushAnimation("open_loop")
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

local function hamfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("wormhole.png")
	
    inst.AnimState:SetBank("teleporter_worm")
    inst.AnimState:SetBuild("wormhole_hamlet")
    inst.AnimState:PlayAnimation("open_loop")
    
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
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function swfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("wormhole.png")
	
    inst.AnimState:SetBank("teleporter_worm")
    inst.AnimState:SetBuild("wormhole_shipwrecked")
    inst.AnimState:PlayAnimation("open_loop")
    
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
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_wormhole_ham", hamfn, assets),
Prefab("sap_wormhole_sw", swfn, assets),
MakePlacer("sap_wormhole_ham_placer", "teleporter_worm", "wormhole_hamlet", "open_loop"),
MakePlacer("sap_wormhole_sw_placer", "teleporter_worm", "wormhole_shipwrecked", "open_loop")