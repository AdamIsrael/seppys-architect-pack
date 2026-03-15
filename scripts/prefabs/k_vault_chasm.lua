require("prefabutil")

local assets = 
{
    Asset("ANIM", "anim/vault_lobby_exit.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()

	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("vault_lobby_exit.png")
	
	inst.Transform:SetEightFaced()
	inst:SetDeploySmartRadius(3)

    inst.entity:AddPhysics()
    inst.Physics:SetMass(0)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
	inst.Physics:SetCollisionMask(
		COLLISION.ITEMS,
		COLLISION.CHARACTERS,
		COLLISION.GIANTS
	)
    inst.Physics:SetCylinder(1.8, 6)

    inst.AnimState:SetBank("vault_lobby_exit")
    inst.AnimState:SetBuild("vault_lobby_exit")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(2)
	
	inst:AddTag("structure")
    inst:AddTag("blocker")
	
	inst:SetPrefabNameOverride("vault_lobby_exit")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)

    return inst
end

return Prefab("sap_vault_chasm", fn, assets),
MakePlacer("sap_vault_chasm_placer", "vault_lobby_exit", "vault_lobby_exit", "idle", true)