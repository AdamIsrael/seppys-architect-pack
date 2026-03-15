require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/nightmaregrowth.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "sap_nightmaregrowth_crack",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("grotto/common/nightmare_growth/grow")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("nightmaregrowth.png")
	
	MakeObstaclePhysics(inst, 1.1)

    inst.AnimState:SetBuild("nightmaregrowth")
    inst.AnimState:SetBank("nightmaregrowth")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("structure")
	inst:AddTag("nightmare_obelisk")

    inst:SetPrefabNameOverride("nightmaregrowth")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
	inst.towerprefab =  SpawnPrefab("sap_nightmaregrowth_crack")
	inst.towerprefab.entity:SetParent(inst.entity)
	end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SUPERHUGE

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:DoTaskInTime(FRAMES * 1, createExtras)

    return inst
end

local function crackfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    
    inst.AnimState:SetBank("nightmaregrowth")
    inst.AnimState:SetBuild("nightmaregrowth")
    inst.AnimState:PlayAnimation("crack_idle", false)

    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst:AddTag("DECOR")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false
    
    inst.Transform:SetRotation(math.random() * 360)

    return inst
end

return Prefab("sap_nightmareobelisk", fn, assets, prefabs),
Prefab("sap_nightmaregrowth_crack", crackfn, assets, prefabs),
MakePlacer("sap_nightmareobelisk_placer", "nightmaregrowth", "nightmaregrowth", "idle")