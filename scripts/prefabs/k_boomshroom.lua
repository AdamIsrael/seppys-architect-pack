require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/mushroombomb.zip"),
	Asset("ANIM", "anim/mushroombomb_dark_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("green_cap")
	inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_explode")
	inst:Remove()
end

local function dig_up_dark(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("blue_cap")
	inst.components.lootdropper:SpawnLootPrefab("spoiled_food")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_explode")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("land")
	inst.AnimState:PushAnimation("grow1", false)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/toad_stool/spore_grow")
end

local function regularfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()
	
	inst.Light:SetFalloff(.5)
	inst.Light:SetIntensity(.8)
	inst.Light:SetRadius(1.5)
	inst.Light:SetColour(200 / 255, 100 / 255, 170 / 255)
	inst.Light:Enable(true)
	inst.Light:EnableClientModulation(true)
	
	inst.AnimState:SetBank("mushroombomb")
	inst.AnimState:SetBuild("mushroombomb")
	inst.AnimState:PlayAnimation("grow1", false)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	inst:AddTag("structure")
	inst:AddTag("boomshroom")
	
	inst:SetPrefabNameOverride("mushroombomb")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function darkfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Transform:SetFourFaced()
	
	inst.Light:SetFalloff(.5)
	inst.Light:SetIntensity(.8)
	inst.Light:SetRadius(1.5)
	inst.Light:SetColour(200 / 255, 100 / 255, 170 / 255)
	inst.Light:Enable(true)
	inst.Light:EnableClientModulation(true)
	
	inst.AnimState:SetBank("mushroombomb")
	inst.AnimState:SetBuild("mushroombomb_dark_build")
	inst.AnimState:PlayAnimation("grow1", false)
	inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	inst:AddTag("structure")
	inst:AddTag("boomshroom")
	
	inst:SetPrefabNameOverride("mushroombomb")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_dark)
	inst.components.workable:SetWorkLeft(1)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("sap_boomshroom", regularfn, assets, prefabs),
Prefab("sap_boomshroom_dark", darkfn, assets, prefabs),
MakePlacer("sap_boomshroom_placer", "mushroombomb", "mushroombomb", "grow1"),
MakePlacer("sap_boomshroom_dark_placer", "mushroombomb", "mushroombomb_dark_build", "grow1")
