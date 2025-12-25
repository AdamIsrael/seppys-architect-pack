require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/vault_portal.zip"),
	Asset("ANIM", "anim/vault_portal_ground.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()

	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("kyno_vault_teleporter_broken").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhammered2(inst, worker)
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function CreateBase()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:SetCanSleep(TheWorld.ismastersim)

	inst:AddTag("DECOR")
	inst:AddTag("NOCLICK")

	inst.AnimState:SetBank("vault_portal_ground")
	inst.AnimState:SetBuild("vault_portal_ground")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(-3)

	inst.persists = false

	return inst
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("vault_teleporter.png")

    MakeObstaclePhysics(inst, 0.1)

	inst.AnimState:SetBank("vault_portal")
	inst.AnimState:SetBuild("vault_portal")
    inst.AnimState:PlayAnimation("idle_off")

    inst:AddTag("structure")

	inst:SetPrefabNameOverride("vault_teleporter")

	if not TheNet:IsDedicated() then
		inst.base = CreateBase()
		inst.base.entity:SetParent(inst.entity)
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("vault_teleporter.png")

    MakeObstaclePhysics(inst, 0.1)

	inst.AnimState:SetBank("vault_portal")
	inst.AnimState:SetBuild("vault_portal")
    inst.AnimState:PlayAnimation("unpowered_construction")

    inst:AddTag("structure")

	inst:SetPrefabNameOverride("vault_teleporter")

	if not TheNet:IsDedicated() then
		inst.base = CreateBase()
		inst.base.entity:SetParent(inst.entity)
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

    return inst
end

local function fn3()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("vault_teleporter.png")

    MakeObstaclePhysics(inst, 0.1)

	inst.AnimState:SetBank("vault_portal")
	inst.AnimState:SetBuild("vault_portal")
    inst.AnimState:PlayAnimation("idle_broken")

    inst:AddTag("structure")

	inst:SetPrefabNameOverride("vault_teleporter")

	if not TheNet:IsDedicated() then
		inst.base = CreateBase()
		inst.base.entity:SetParent(inst.entity)
	end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered2)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

    return inst
end

return Prefab("kyno_vault_teleporter", fn, assets),
Prefab("kyno_vault_teleporter_construction", fn2, assets),
Prefab("kyno_vault_teleporter_broken", fn3, assets),
MakePlacer("kyno_vault_teleporter_placer", "vault_portal", "vault_portal", "idle_off"),
MakePlacer("kyno_vault_teleporter_construction_placer", "vault_portal", "vault_portal", "unpowered_construction")