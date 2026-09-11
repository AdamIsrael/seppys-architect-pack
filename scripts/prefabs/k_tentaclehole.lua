require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/tentacle_pillar.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("SOUND", "sound/tentacle.fsb"),
}

local prefabs =
{
	"collapse_small"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function ShouldAcceptItem(inst, item)
	if item.components.inventoryitem ~= nil then
	return true
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.inventoryitem ~= nil and not item:HasTag("PUGALISK_CANT_EAT") then
		inst.SoundEmitter:PlaySound("dontstarve/cave/tentapiller_hole_throw_item")
		item:Remove()
	elseif
		item:HasTag("KeyReplica") then
		inst.components.lootdropper:SpawnLootPrefab("atrium_key")
		inst.SoundEmitter:PlaySound("dontstarve/cave/tentapiller_hole_throw_item")
	end
		print("ITEM REMOVED OR PUGALISK REFUSED IT")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("tentacle_pillar.png")

	MakeSmallObstaclePhysics(inst, 2, 24)
    inst.entity:SetAABB(60, 20)
	
	inst.AnimState:SetBank("tentaclepillar")
	inst.AnimState:SetBuild("tentacle_pillar")
	inst.AnimState:PlayAnimation("idle_hole", true)
	
	inst:AddTag("structure")
	inst:AddTag("alltrader")
	inst:AddTag("wet")
	inst:AddTag("tentacle_hole")
	
	inst:SetPrefabNameOverride("tentacle_pillar")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_hiddenidle_LP", "loop")
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	return inst
end

return Prefab("sap_tentaclehole", fn, assets, prefabs),
MakePlacer("sap_tentaclehole_placer", "tentaclepillar", "tentacle_pillar", "idle_hole")
