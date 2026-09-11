require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/lunar_rift_portal.zip"),
    Asset("ANIM", "anim/lunar_rift_portal_small.zip"),
}

local prefabs =
{
	"lunarrift_portal_shadow"
}

local function KeepTargetFn()
    return false
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function clearobstacle(inst)
	inst.AnimState:PlayAnimation("stage_3_disappear")
	inst:ListenForEvent("animover", inst.Remove)
end

local function onhealthchange(inst)
	if inst.components.health:IsDead() then
		inst.components.lootdropper:DropLoot()
		clearobstacle(inst)
	end
	
	inst.SoundEmitter:KillSound("lunarrift_portal_ambience")
end

local function OnBuilt(inst)
	inst.SoundEmitter:PlaySound("rifts/portal/rift_portal_allstage", "lunarrift_portal_ambience")
	inst.AnimState:PlayAnimation("stage_3_appear")
    inst.AnimState:PushAnimation("stage_3_loop", true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetIntensity(0.7)
    inst.Light:SetRadius(0.7)
    inst.Light:SetFalloff(0.8)
    inst.Light:SetColour(119/255, 255/255, 255/255)
    inst.Light:Enable(true)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("lunarrift_portal.png")
    minimap:SetPriority(1)

    inst.AnimState:SetBank("lunar_rift_portal")
    inst.AnimState:SetBuild("lunar_rift_portal")
    inst.AnimState:PlayAnimation("stage_3_loop", true)
    inst.AnimState:SetLightOverride(1)

	inst:AddTag("structure")
	inst:AddTag("birdblocker")
    inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("notraptrigger")
	inst:AddTag("scarytoprey")
    inst:AddTag("NOBLOCK")
	
	inst:SetPrefabNameOverride("LUNARRIFT_PORTAL")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("rifts/portal/rift_portal_allstage", "lunarrift_portal_ambience")
	
	inst.shadow = SpawnPrefab("lunarrift_portal_shadow")
    inst.shadow.entity:SetParent(inst.entity)
    inst.shadow.Transform:SetPosition(0, 0, 0)
	
    local initial_shadow_scale = 1.2
    inst.shadow.AnimState:SetScale(initial_shadow_scale, initial_shadow_scale)
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "LUNARRIFT_PORTAL"
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(200)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
    inst.components.health.redirect = nodebrisdmg
	inst.components.health.ondelta = onhealthchange

    inst:AddComponent("combat")
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

    return inst
end

return Prefab("sap_lunarrift_portal", fn, assets, prefabs),
MakePlacer("sap_lunarrift_portal_placer", "lunar_rift_portal", "lunar_rift_portal", "stage_3_loop")
