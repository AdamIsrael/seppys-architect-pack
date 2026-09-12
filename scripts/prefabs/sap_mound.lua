local assets =
{
    Asset("ANIM", "anim/gravestones.zip"),
}

local prefabs = {
	"sap_mound_dug",
	"ghost",
}

local function ReturnChildren(inst)
    local toremove = {}
    for k, v in pairs(inst.components.childspawner.childrenoutside) do
        table.insert(toremove, v)
    end
    for i, v in ipairs(toremove) do
        if v:IsAsleep() then
            v:PushEvent("detachchild")
            v:Remove()
        else
            v.components.health:Kill()
        end
    end
end

local function onfullmoon(inst, isfullmoon)
    if isfullmoon then
        inst.components.childspawner:StartSpawning()
        inst.components.childspawner:StopRegen()
    else
        inst.components.childspawner:StopSpawning()
        inst.components.childspawner:StartRegen()
        ReturnChildren(inst)
    end
end

local function oninit(inst)
    inst:WatchWorldState("isfullmoon", onfullmoon)
    onfullmoon(inst, TheWorld.state.isfullmoon)
end

local function dig_up_mound(inst, chopper)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("boneshard")
	inst.components.lootdropper:SpawnLootPrefab("boneshard")
	SpawnPrefab("sap_mound_dug").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up(inst, chopper)
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("gravestone")
    inst.AnimState:SetBuild("gravestones")
    inst.AnimState:PlayAnimation("gravedirt")

    inst:AddTag("grave")
	inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOUND"
	
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_mound)
    inst.components.workable:SetWorkLeft(1)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	
	inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "ghost"
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:SetSpawnPeriod(10, 3)

    inst:DoTaskInTime(0, oninit)

    return inst
end

local function dugfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("gravestone")
    inst.AnimState:SetBuild("gravestones")
    inst.AnimState:PlayAnimation("dug")

    inst:AddTag("grave")
	inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOUND"
	
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
    inst.components.workable:SetWorkLeft(1)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_SMALL)
	
	inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "ghost"
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:SetSpawnPeriod(10, 3)

    inst:DoTaskInTime(0, oninit)

    return inst
end

return Prefab("sap_mound", fn, assets, prefabs),
Prefab("sap_mound_dug", dugfn, assets, prefabs),
MakePlacer("sap_mound_placer", "gravestone", "gravestones", "gravedirt")