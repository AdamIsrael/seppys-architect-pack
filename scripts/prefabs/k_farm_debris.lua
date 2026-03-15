local assets =
{
    Asset("ANIM", "anim/farm_soil_debris.zip"),
    Asset("ANIM", "anim/smoke_puff_small.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "dirt_puff"
}

local names = {"f1", "f2", "f3", "f4"}

local function onfinishcallback(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
	inst.components.lootdropper:DropLoot()

    SpawnPrefab("dirt_puff").Transform:SetPosition(x, y, z)
    inst:Remove()
end

local function onsave(inst, data)
    data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("farm_soil_debris")
    inst.AnimState:SetBuild("farm_soil_debris")
	inst.AnimState:SetRayTestOnBB(true)
	
	inst:AddTag("farmdebris")
	inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname)

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "farm_soil_debris"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.components.workable:SetOnFinishCallback(onfinishcallback)

    inst.OnSave = onsave
    inst.OnLoad = onload

    return inst
end

return Prefab("sap_farmdebris", fn, assets, prefabs),
MakePlacer("sap_farmdebris_placer", "farm_soil_debris", "farm_soil_debris", "f1")