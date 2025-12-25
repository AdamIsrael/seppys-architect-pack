local assets =
{
    Asset("ANIM", "anim/scorched_rock.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "rock_break_fx",
}

local rocc = {"idle", "idle2", "idle3", "idle4", "idle5", "idle6", "idle7"}

local function setpiecetype(inst, name)
    if inst.piece == nil or (name ~= nil and inst.piece ~= name) then
        inst.piece = name or (math.random() or rocc[math.random(#rocc)])
        inst.AnimState:PlayAnimation(inst.piece)
    end
end

local function onsave(inst, data)
    data.piece = inst.piece
end

local function onload(inst, data)
    setpiecetype(inst, data ~= nil and data.piece or nil)
end

local function onworkfinished(inst)
    SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot()
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	inst.piece = rocc[math.random(#rocc)]
	
    inst.AnimState:SetBank("scorched_rock")
    inst.AnimState:SetBuild("scorched_rock")
	inst.AnimState:PlayAnimation(inst.piece)

	inst:SetPrefabNameOverride("lava_pond_rock")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    MakeHauntableWork(inst)

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onworkfinished)
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    --------SaveLoad
    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("kyno_pondrock", fn, assets, prefabs),
MakePlacer("kyno_pondrock_placer", "scorched_rock", "scorched_rock", "idle")