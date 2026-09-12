require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/wagstaff_setpieces.zip"),
}

local prefabs =
{
    "cutstone",
    "transistor",
	"trinket_6",
    "collapse_small",
}

local MAX_NUMBER = 3

local function OnHammered(inst, worker)
    inst.components.lootdropper:DropLoot()

    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("metal")

    inst:Remove()
end

local function OnHit(inst, worker)
    inst.AnimState:PlayAnimation("hit"  .. inst.debris_id)
    inst.AnimState:PushAnimation("idle" .. inst.debris_id)
end

local function SetDebrisType(inst, index)
    if inst.debris_id == nil or (index ~= nil and inst.debris_id ~= index) then
        inst.debris_id = index or tostring(math.random(MAX_NUMBER))
        inst.AnimState:PlayAnimation("idle"..inst.debris_id, true)
    end
end

local function OnSave(inst, data)
    data.debris_id = inst.debris_id
end

local function OnLoad(inst, data)
    inst:SetDebrisType(data ~= nil and data.debris_id or nil)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("wagstaff_machinery.png")
    minimap:SetPriority(5)

    MakeObstaclePhysics(inst, .5)

    inst.AnimState:SetBank("wagstaff_setpieces")
    inst.AnimState:SetBuild("wagstaff_setpieces")

    inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("wagstaff_machinery")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.SetDebrisType = SetDebrisType

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    if not POPULATING then
        inst:SetDebrisType()
    end

    MakeSnowCovered(inst)

    return inst
end

return Prefab("sap_wagstaff_machinery", fn, assets, prefabs),
MakePlacer("sap_wagstaff_machinery_placer", "wagstaff_setpieces", "wagstaff_setpieces", "idle1")