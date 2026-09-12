local assets =
{
    Asset("ANIM", "anim/diviningrod.zip"),
    Asset("ANIM", "anim/diviningrod_maxwell.zip"),
}

local prefabs =
{
    "diviningrod",
}

local function HasStaff(inst, staffname)
    return (inst._staffinst ~= nil and inst._staffinst.prefab or inst.components.pickable.product) == staffname
end

local function OnRodGiven(inst, giver, item)
	inst.AnimState:PlayAnimation("idle_full")
    inst.components.trader:Disable()
    inst.components.pickable:SetUp("diviningrod")
    inst.components.pickable:Pause()
    inst.components.pickable.caninteractwith = true
    inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_add_divining")
	inst:AddTag("IsHoldingRod")
end

local function OnRodTaken(inst, picker, loot)
	inst.components.trader:Enable()
    inst.components.pickable.caninteractwith = false
    inst.AnimState:PlayAnimation("idle_empty")
    inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_add_divining")
	inst:RemoveTag("IsHoldingRod")
end

local function ItemTradeTest(inst, item)
    if item == nil then
        return false
    elseif item.prefab ~= "diviningrod" then
        return false, "NOTDIVININGROD"
    end
    return true
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
	if inst:HasTag("IsHoldingRod") then
	inst.components.lootdropper:SpawnLootPrefab("diviningrod")
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("diviningrod")
    inst.AnimState:SetBuild("diviningrod_maxwell")
    inst.AnimState:PlayAnimation("idle_empty", true)

    inst:AddTag("trader")
    inst:AddTag("structure")
	inst:AddTag("maxwelllock")
	
	inst:SetPrefabNameOverride("maxwelllock")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetWorkLeft(3)

    inst:AddComponent("pickable")
    inst.components.pickable.caninteractwith = false
    inst.components.pickable.onpickedfn = OnRodTaken

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.deleteitemonaccept = false
    inst.components.trader.onaccept = OnRodGiven

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddSoundEmitter()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("diviningrod")
    inst.AnimState:SetBuild("diviningrod")
    inst.AnimState:PlayAnimation("idle_empty", true)

    inst:AddTag("trader")
    inst:AddTag("structure")
	inst:AddTag("adventurelock")
	
	inst:SetPrefabNameOverride("diviningrodbase")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetWorkLeft(3)

    inst:AddComponent("pickable")
    inst.components.pickable.caninteractwith = false
    inst.components.pickable.onpickedfn = OnRodTaken

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTest)
    inst.components.trader.deleteitemonaccept = false
    inst.components.trader.onaccept = OnRodGiven

    return inst
end

return Prefab("sap_waxwelllock", fn, assets, prefabs),
Prefab("sap_adventurelock", fn2, assets, prefabs),
MakePlacer("sap_waxwelllock_placer", "diviningrod", "diviningrod_maxwell", "idle_empty"),
MakePlacer("sap_adventurelock_placer", "diviningrod", "diviningrod", "idle_empty")