require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_mermcart.zip"),
	Asset("ANIM", "anim/merm_trader1_build.zip"),
    Asset("ANIM", "anim/merm_trader2_build.zip"),
    Asset("ANIM", "anim/ds_pig_basic.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"sap_sammy",
	"sap_pipton",
}

local function onhammered_sammy(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function onhammered_pipton(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit_sammy(inst, worker)
    inst.AnimState:PlayAnimation("idle1")
    inst.AnimState:PushAnimation("idle1")
end

local function onhit_pipton(inst, worker)
    inst.AnimState:PlayAnimation("idle2")
    inst.AnimState:PushAnimation("idle2")
end

local function onbuilt_sammy(inst)
    inst.AnimState:PushAnimation("idle1")
end

local function onbuilt_pipton(inst)
    inst.AnimState:PushAnimation("idle2")
end

local function creepy(inst)
if inst:HasTag("name_is_sammy") or inst:HasTag("name_is_pipton") then
	inst:DoTaskInTime(8+math.random()*5, function() creepy(inst) end)
		inst.SoundEmitter:PlaySound("dontstarve/creatures/merm/idle")
		inst.AnimState:PlayAnimation("idle_creepy")
		inst.AnimState:PushAnimation("idle_loop", true)
	end
end

local sammy_front = 1
local sammy_defs = {
	sammy = { { -1.28, 0, 1.14 } },
}

local function wagonfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_sammywagon.tex")
	
    inst.AnimState:SetBank("quagmire_mermcart")
    inst.AnimState:SetBuild("quagmire_mermcart")
    inst.AnimState:PlayAnimation("idle1")
	
	MakeObstaclePhysics(inst, .2)
    
	inst:AddTag("structure")
	inst:AddTag("sammy_wagon")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	local decor_items = sammy_defs
		inst.decor = {}
		for item_name, data in pairs(decor_items) do
			for l, offset in pairs(data) do
				local item_inst = SpawnPrefab("sap_sammy")
				item_inst.AnimState:PushAnimation("idle_loop", true)
				item_inst.entity:SetParent(inst.entity)
				item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
				table.insert(inst.decor, item_inst)
			end
		end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_MERM_CART1"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered_sammy)
	inst.components.workable:SetOnWorkCallback(onhit_sammy)
	
	inst:AddComponent("savedrotation")
	
	inst:ListenForEvent("onbuilt", onbuilt_sammy)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function sammyfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()
	inst.Transform:SetRotation(-90)
	
	MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetBank("pigman")
	inst.AnimState:SetBuild("merm_trader1_build")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.persists = false
		
	inst:AddTag("name_is_sammy")
		
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	creepy(inst)

	return inst
end

local pipton_front = 1
local pipton_defs = {
	pipton = { { -1.28, 0, 1.14 } },
}

local function cartfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_piptoncart.tex")
	
    inst.AnimState:SetBank("quagmire_mermcart")
    inst.AnimState:SetBuild("quagmire_mermcart")
    inst.AnimState:PlayAnimation("idle2")
	
	MakeObstaclePhysics(inst, .2)
    
	inst:AddTag("structure")
	inst:AddTag("pipton_cart")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	local decor_items = pipton_defs
		inst.decor = {}
		for item_name, data in pairs(decor_items) do
			for l, offset in pairs(data) do
				local item_inst = SpawnPrefab("sap_pipton")
				item_inst.AnimState:PushAnimation("idle_loop", true)
				item_inst.entity:SetParent(inst.entity)
				item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
				table.insert(inst.decor, item_inst)
			end
		end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_MERM_CART2"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered_pipton)
	inst.components.workable:SetOnWorkCallback(onhit_pipton)
	
	inst:AddComponent("savedrotation")
	
	inst:ListenForEvent("onbuilt", onbuilt_pipton)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function piptonfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()
	inst.Transform:SetRotation(-90)
	
	MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetBank("pigman")
	inst.AnimState:SetBuild("merm_trader2_build")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.persists = false
		
	inst:AddTag("name_is_pipton")
		
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	creepy(inst)

	return inst
end

return Prefab("sap_sammywagon", wagonfn, assets, prefabs),
Prefab("sap_sammy", sammyfn, assets, prefabs),
Prefab("sap_piptoncart", cartfn, assets, prefabs),
Prefab("sap_pipton", piptonfn, assets, prefabs),
MakePlacer("sap_sammywagon_placer", "quagmire_mermcart", "quagmire_mermcart", "idle1", false, nil, nil, nil, 90, nil),
MakePlacer("sap_piptoncart_placer", "quagmire_mermcart", "quagmire_mermcart", "idle2", false, nil, nil, nil, 90, nil)