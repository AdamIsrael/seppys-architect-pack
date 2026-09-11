local assets =
{
    Asset("ANIM", "anim/scorched_skeletons.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local animstates = { 1, 2, 3, 4, 5, 6 }

local function onsave(inst, data)
    data.anim = inst.animnum
end

local function onload(inst, data)
    if data ~= nil then
        if data.anim ~= nil then
            inst.animnum = data.anim
            inst.AnimState:PlayAnimation("idle"..inst.animnum)
        end
    end
end

local function onhammered(inst)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("rock")
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
    inst.entity:AddSoundEmitter()

    MakeSmallObstaclePhysics(inst, 0.25)

    inst.AnimState:SetBank("skeleton")
    inst.AnimState:SetBuild("scorched_skeletons")

    inst.animnum = animstates[math.random(#animstates)]
    inst.AnimState:PlayAnimation("idle"..inst.animnum)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst.components.inspectable:RecordViews()
	inst.components.inspectable.nameoverride = "SCORCHED_SKELETON"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst.OnLoad = onload
    inst.OnSave = onsave

    return inst
end

return Prefab("sap_scorchedskeleton", fn, assets),
MakePlacer("sap_scorchedskeleton_placer", "skeleton", "scorched_skeletons", "idle6")
