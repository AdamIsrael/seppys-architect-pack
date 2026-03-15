local assets =
{
    Asset("ANIM", "anim/moon_altar_link.zip"),
	Asset("ANIM", "anim/kyno_lunar_energy.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function KeepTargetFn()
    return false
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function onhealthchange(inst)
	if inst.components.health:IsDead() then
		inst.components.lootdropper:DropLoot()
	end
	
	inst.SoundEmitter:KillSound("loop")
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("low_pre")
	inst.AnimState:PushAnimation("high_idle", true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetLightOverride(1)

    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(2.4, 1)

    inst.AnimState:SetBank("kyno_lunar_energy")
    inst.AnimState:SetBuild("kyno_lunar_energy")
    inst.AnimState:PlayAnimation("high_idle", true)
	inst.AnimState:Hide("tape_parts")
	inst.AnimState:Hide("tape_parts_0")
	inst.AnimState:Hide("tape_parts_1")
	inst.AnimState:Hide("tape_parts_2")
	inst.AnimState:Hide("tape_parts_3")
	inst.AnimState:Hide("tape_parts_4")
	
	inst:AddTag("structure")
    inst:AddTag("notraptrigger")
	
	inst:SetPrefabNameOverride("moon_altar_link")
	
	inst.SoundEmitter:PlaySound("grotto/common/moon_alter/link/LP", "loop")
    inst.SoundEmitter:SetParameter("loop", "intensity", 0)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
    inst.components.health.redirect = nodebrisdmg
	inst.components.health.ondelta = onhealthchange

    inst:AddComponent("combat")
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

local function wipfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetLightOverride(1)

    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize(2.4, 1)

    inst.AnimState:SetBank("moon_altar_link")
    inst.AnimState:SetBuild("moon_altar_link")
    inst.AnimState:PlayAnimation("high_idle", true)
	
	inst:AddTag("structure")
    inst:AddTag("notraptrigger")
	
	inst:SetPrefabNameOverride("moon_altar_link")
	
	inst.SoundEmitter:PlaySound("grotto/common/moon_alter/link/LP", "loop")
    inst.SoundEmitter:SetParameter("loop", "intensity", 0)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
    inst.components.health.redirect = nodebrisdmg
	inst.components.health.ondelta = onhealthchange

    inst:AddComponent("combat")
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

local function energyplacetestfn(inst)
	inst.AnimState:Hide("tape_parts")
	inst.AnimState:Hide("tape_parts_0")
	inst.AnimState:Hide("tape_parts_1")
	inst.AnimState:Hide("tape_parts_2")
	inst.AnimState:Hide("tape_parts_3")
	inst.AnimState:Hide("tape_parts_4")
end

return Prefab("sap_lunar_energy", fn, assets),
Prefab("sap_lunar_energy_wip", wipfn, assets),
MakePlacer("sap_lunar_energy_placer", "moon_altar_link", "moon_altar_link", "high_idle"),
MakePlacer("sap_lunar_energy_wip_placer", "kyno_lunar_energy", "kyno_lunar_energy", "high_idle", false, nil, nil, nil, nil, nil, energyplacetestfn)