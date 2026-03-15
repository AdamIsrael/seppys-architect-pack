require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/monkey_island_portal.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"sap_monkeyisland_portalfx"
}

local fx_assets =
{
    Asset("ANIM", "anim/monkey_island_portal_fx.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
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

local function follow_fx_finish(fx)
    fx.AnimState:PlayAnimation("idle_pst")
    fx:ListenForEvent("animover", fx.Remove)
end

local function followfx_fn()
    local inst = CreateEntity("MonkeyIslandPortalLoot.SpawnFollowFX")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("monkey_island_portal_fx")
    inst.AnimState:SetBuild("monkey_island_portal_fx")
    inst.AnimState:PlayAnimation("idle_loop", true)

    inst.AnimState:SetFinalOffset(1)
    inst.AnimState:SetScale(0.65, 0.65)
    inst.AnimState:SetMultColour(0.4, 0.4, 0.4, 0.4)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(0.6)
	
	inst:AddTag("FX")
    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    inst.fx_len = inst.AnimState:GetCurrentAnimationLength()
    inst:DoTaskInTime(inst.fx_len, follow_fx_finish)

    return inst
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetIntensity(.7)
    inst.Light:SetRadius(5)
    inst.Light:SetFalloff(.8)
    inst.Light:SetColour(98/255, 18/255, 227/255)
    inst.Light:Enable(true)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("monkey_island_portal.png")
    minimap:SetPriority(1)

    inst.AnimState:SetBank("monkey_island_portal")
    inst.AnimState:SetBuild("monkey_island_portal")
    inst.AnimState:PlayAnimation("in_idle", true)
	
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)

	inst:AddTag("structure")
    inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("notraptrigger")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.extraprefab = SpawnPrefab("sap_monkeyisland_portalfx")
		inst.extraprefab.entity:SetParent(inst.entity)
	end
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MONKEYISLAND_PORTAL"
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
    inst.components.health.redirect = nodebrisdmg
	inst.components.health.ondelta = onhealthchange

    inst:AddComponent("combat")
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetIntensity(.7)
    inst.Light:SetRadius(5)
    inst.Light:SetFalloff(.8)
    inst.Light:SetColour(98/255, 18/255, 227/255)
    inst.Light:Enable(true)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("monkey_island_portal.png")
    minimap:SetPriority(1)

    inst.AnimState:SetBank("monkey_island_portal")
    inst.AnimState:SetBuild("monkey_island_portal")
    inst.AnimState:PlayAnimation("out_idle", true)
	
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:SetLightOverride(1)

	inst:AddTag("structure")
    inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("notraptrigger")
    inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.extraprefab = SpawnPrefab("sap_monkeyisland_portalfx")
		inst.extraprefab.entity:SetParent(inst.entity)
	end
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MONKEYISLAND_PORTAL"
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
    inst.components.health.redirect = nodebrisdmg
	inst.components.health.ondelta = onhealthchange

    inst:AddComponent("combat")
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    return inst
end

return Prefab("sap_monkeyisland_portal1", fn, assets, prefabs),
Prefab("sap_monkeyisland_portal2", fn2, assets, prefabs),
Prefab("sap_monkeyisland_portalfx", followfx_fn, fx_assets),
MakePlacer("sap_monkeyisland_portal1_placer", "monkey_island_portal", "monkey_island_portal", "in_idle"),
MakePlacer("sap_monkeyisland_portal2_placer", "monkey_island_portal", "monkey_island_portal", "out_idle")
