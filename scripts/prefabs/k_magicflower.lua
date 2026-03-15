require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/lifeplant.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("nightmarefuel")
	inst.components.lootdropper:SpawnLootPrefab("poop")
	inst.components.lootdropper:SpawnLootPrefab("petals")
	inst.components.lootdropper:SpawnLootPrefab("petals")
	inst.components.lootdropper:SpawnLootPrefab("petals")
	inst.components.lootdropper:SpawnLootPrefab("petals")
	inst.components.lootdropper:SpawnLootPrefab("petals")
	inst:Remove()
end

local function onnear(inst) 
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/flower_of_life/fx_LP","drainloop")
end

local function onfar(inst)
	inst.SoundEmitter:KillSound("drainloop")
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("idle_loop", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(true)
    inst.Light:SetColour(185/255, 185/255, 20/255)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_magicflower.tex")
	
	inst.AnimState:SetBank("lifeplant")
	inst.AnimState:SetBuild("lifeplant")
	inst.AnimState:PlayAnimation("idle_loop", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("magic_flower")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3, 6)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("sap_magicflower", fn, assets, prefabs),
MakePlacer("sap_magicflower_placer", "lifeplant", "lifeplant", "idle_loop")
