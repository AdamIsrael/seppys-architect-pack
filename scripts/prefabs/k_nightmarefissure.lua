require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/nightmare_crack_upper.zip"),
	Asset("ANIM", "anim/nightmare_crack_ruins.zip"),
}

local prefabs =
{
	"upper_nightmarefissurefx",
	"nightmarefissurefx",
}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
	inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("open_1")
	inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_fissure_open")
	inst.AnimState:PushAnimation("idle_open", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetRadius(1)
	inst.Light:SetIntensity(.6)
	inst.Light:SetFalloff(.9)
	inst.Light:SetColour(239/255, 194/255, 194/255)
	inst.Light:Enable(true)
	inst.Light:EnableClientModulation(true)
	
	inst.AnimState:SetBank("nightmare_crack_upper")
	inst.AnimState:SetBuild("nightmare_crack_upper")
	inst.AnimState:PlayAnimation("idle_open", true)
	inst.AnimState:SetFinalOffset(1)
	
	inst:AddTag("structure")
	inst:AddTag("fissure_nightmare")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
	inst.nightmareprefab =  SpawnPrefab("upper_nightmarefissurefx")
	inst.nightmareprefab.entity:SetParent(inst.entity)
	end
	
	inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_fissure_open_LP", "loop")
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:DoTaskInTime(1, createExtras)

	return inst
end

local function ruinsfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetRadius(1)
	inst.Light:SetIntensity(.6)
	inst.Light:SetFalloff(.9)
	inst.Light:SetColour(239/255, 194/255, 194/255)
	inst.Light:Enable(true)
	inst.Light:EnableClientModulation(true)
	
	inst.AnimState:SetBank("nightmare_crack_ruins")
	inst.AnimState:SetBuild("nightmare_crack_ruins")
	inst.AnimState:PlayAnimation("idle_open", true)
	inst.AnimState:SetFinalOffset(1)
	
	inst:AddTag("structure")
	inst:AddTag("fissure_nightmare")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras2(inst)
	inst.nightmareprefab2 =  SpawnPrefab("nightmarefissurefx")
	inst.nightmareprefab2.entity:SetParent(inst.entity)
	end
	
	inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_fissure_open_LP", "loop")
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:DoTaskInTime(1, createExtras2)

	return inst
end

return Prefab("sap_nightmarefissure", fn, assets, prefabs),
Prefab("sap_nightmarefissure_ruins", ruinsfn, assets, prefabs),
MakePlacer("sap_nightmarefissure_placer", "nightmare_crack_upper", "nightmare_crack_upper", "idle_open"),
MakePlacer("sap_nightmarefissure_ruins_placer", "nightmare_crack_ruins", "nightmare_crack_ruins", "idle_open")