local assets =
{
    Asset("ANIM", "anim/sign_home.zip"),
    Asset("ANIM", "anim/sign_elite.zip"),
    Asset("ANIM", "anim/swap_sign_elite.zip"),
	Asset("ANIM", "anim/ui_board_5x3.zip"),
}

local prefabs =
{
	"propsignshatterfx",
	"collapse_small",
}

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_object")
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_sign_elite", "swap_sign_elite")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function OnSmashed(inst, pos)
	local fx = SpawnPrefab("propsignshatterfx")
    fx.Transform:SetPosition(pos:Get())
    fx.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	if inst.components.finiteuses then
		inst.components.finiteuses:Use(1)
	end
end

local function OnBurnt(inst)
    inst:AddTag("burnt")
    inst.AnimState:SetMultColour(0, 0, 0, 1)
	inst:Remove()
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function OnDelayInteraction(inst)
    inst._knockbacktask = nil
    inst:RemoveTag("knockbackdelayinteraction")
end

local function OnDelayPlayerInteraction(inst)
    inst._playerknockbacktask = nil
    if not inst.broken then
        inst:RemoveTag("NOCLICK")
    end
end

local function OnKnockbackDropped(inst, data)
    if data ~= nil and (data.delayinteraction or 0) > 0 then
        if inst._knockbacktask ~= nil then
            inst._knockbacktask:Cancel()
        else
            inst:AddTag("knockbackdelayinteraction")
        end
        inst._knockbacktask = inst:DoTaskInTime(data.delayinteraction, OnDelayInteraction)
    elseif inst._knockbacktask ~= nil then
        inst._knockbacktask:Cancel()
        OnDelayInteraction(inst)
    end

    if data ~= nil and (data.delayplayerinteraction or 0) > 0 then
        if inst._playerknockbacktask ~= nil then
            inst._playerknockbacktask:Cancel()
        else
            inst:AddTag("NOCLICK")
        end
        inst._playerknockbacktask = inst:DoTaskInTime(data.delayplayerinteraction, OnDelayPlayerInteraction)
    elseif inst._playerknockbacktask ~= nil then
        inst._playerknockbacktask:Cancel()
        OnDelayPlayerInteraction(inst)
    end
end

local function on_uses_finished(inst)
    if inst.components.inventoryitem.owner ~= nil then
        inst.components.inventoryitem.owner:PushEvent("toolbroke", { tool = inst })
    end
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sign_home")
    inst.AnimState:SetBuild("sign_elite")
    inst.AnimState:OverrideSymbol("burnt", "sign_home", "burnt")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("propweapon")

    inst:SetPrefabNameOverride("homesign")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	inst.components.inventoryitem.imagename = "sap_propsign"
    -- inst.components.inventoryitem.cangoincontainer = true

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    inst:AddComponent("weapon")
    inst.components.weapon:SetRange(TUNING.PROP_WEAPON_RANGE)
    inst.components.weapon:SetDamage(1)
	
	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(20)
    inst.components.finiteuses:SetUses(20)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
	
	inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL

    MakeSmallBurnable(inst, 5, nil, true)
    MakeSmallPropagator(inst)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

    inst.OnSave = onsave
    inst.OnLoad = onload

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:ListenForEvent("propsmashed", OnSmashed)
    inst:ListenForEvent("knockbackdropped", OnKnockbackDropped)

    return inst
end

--------------------------------------------------------------------------------------------------

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
    end
end

local function onsave2(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end
end

local function onload2(inst, data)
    if data ~= nil and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function onbuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/sign_craft")
end

local function signfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("sign.png")
	
	MakeObstaclePhysics(inst, .2)

    inst.AnimState:SetBank("sign_home")
    inst.AnimState:SetBuild("sign_elite")
    inst.AnimState:PlayAnimation("idle")

    MakeSnowCoveredPristine(inst)

    inst:AddTag("structure")
    inst:AddTag("sign")
	inst:AddTag("sign_elite")
    inst:AddTag("_writeable")
	
	inst:SetPrefabNameOverride("homesign")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:RemoveTag("_writeable")

    inst:AddComponent("inspectable")
    inst:AddComponent("writeable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

	MakeSnowCovered(inst)
	
    MakeSmallBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)
    inst.OnSave = onsave2
    inst.OnLoad = onload2

    MakeHauntableWork(inst)
    inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("sap_propsign", fn, assets, prefabs),
Prefab("sap_propsign_structure", signfn, assets, prefabs),
MakePlacer("sap_propsign_structure_placer", "sign_home", "sign_elite", "idle")