require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/python_trap_door.zip"),
}

local prefabs =
{
	"atrium_key",
}

local STATES = {
   CLOSED = 1,
   OPENING = 2,
   OPEN = 3,
   CLOSNG = 4,
}

local function setart(inst)
    if inst.state == STATES.CLOSED then
        inst.AnimState:PlayAnimation("closed",true)
    elseif inst.state == STATES.OPENING then
        inst.AnimState:PlayAnimation("opening")
    elseif inst.state == STATES.OPEN then
        inst.AnimState:PlayAnimation("open",true)
    elseif inst.state == STATES.CLOSNG then
        inst.AnimState:PlayAnimation("closing")
    end
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("opening")
	inst.AnimState:PushAnimation("closed")
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("opening")
	inst.AnimState:PushAnimation("open")
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/trap_door")
end

local function onfar(inst)
	inst.AnimState:PlayAnimation("closing")
	inst.AnimState:PushAnimation("closed")
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/trap_door")
end

local function ShouldAcceptItem(inst, item)
	if item.components.inventoryitem ~= nil then
	return true
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.inventoryitem ~= nil and not item:HasTag("PUGALISK_CANT_EAT") then
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/entrance")
		SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
		item:Remove()
	elseif
		item:HasTag("KeyReplica") then
		inst.components.lootdropper:SpawnLootPrefab("atrium_key")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/pugalisk/entrance")
	end
		print("ITEM REMOVED OR PUGALISK REFUSED IT")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("python_trap_door")
	inst.AnimState:SetBuild("python_trap_door")
	inst.AnimState:PlayAnimation("closed", true)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("alltrader")
	inst:AddTag("pugalisk_trap_door")
	
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

return Prefab("sap_trapdoor", fn, assets, prefabs),
MakePlacer("sap_trapdoor_placer", "python_trap_door", "python_trap_door", "closed")