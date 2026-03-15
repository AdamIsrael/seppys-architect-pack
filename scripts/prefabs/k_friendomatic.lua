local assets =
{
    Asset("ANIM", "anim/portal_friends.zip"),
   
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
   
	Asset("SOUND", "sound/common.fsb"),
}

local function close(inst)
    inst.AnimState:PlayAnimation("closing")
    inst.AnimState:PushAnimation("idle_closed", true)
end

local function open(inst)
    inst.AnimState:PlayAnimation("opening")
    inst.AnimState:PushAnimation("idle", true)
end

local function full(inst)
    inst.AnimState:PlayAnimation("opening", true)
end

local function activate(inst)
    inst.AnimState:PlayAnimation("activate")
    inst.AnimState:PushAnimation("opening")
    inst.AnimState:PushAnimation("idle")
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("activate")
    inst.AnimState:PushAnimation("idle_closed")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("portal_dst.png")

    inst.AnimState:SetBank("portal_friends")
    inst.AnimState:SetBuild("portal_friends")
    inst.AnimState:PlayAnimation("idle_closed", true)

	inst:AddTag("structure")
	inst:AddTag("shard_portal")
	
	inst:SetPrefabNameOverride("migration_portal")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("sap_friendomatic", fn, assets),
MakePlacer("sap_friendomatic_placer", "portal_friends", "portal_friends", "idle_closed")