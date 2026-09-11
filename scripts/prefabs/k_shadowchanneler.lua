local assets =
{
    Asset("ANIM", "anim/shadow_channeler.zip"),
}

local function CalcSanityAura(inst, observer)
    return -TUNING.SANITYAURA_MED  
end

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
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("appear")
	inst.AnimState:PushAnimation("idle", true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBank("shadow_channeler")
    inst.AnimState:SetBuild("shadow_channeler")
    inst.AnimState:PlayAnimation("idle", true)
	
	-- inst:AddTag("shadowcreature")
	inst:AddTag("structure")
    inst:AddTag("notraptrigger")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aurafn = CalcSanityAura

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)
    inst.components.health.redirect = nodebrisdmg
	inst.components.health.ondelta = onhealthchange

    inst:AddComponent("combat")
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("savedrotation")
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("sap_shadowchanneler", fn, assets),
MakePlacer("sap_shadowchanneler_placer", "shadow_channeler", "shadow_channeler", "idle", false, nil, nil, nil, 90, nil)