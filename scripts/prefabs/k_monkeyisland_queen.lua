require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/monkey_queen.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
    "dock_kit",
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
	
	inst.SoundEmitter:KillSound("monkeyisland/monkeyqueen/speak")
end

local function OnTalk(inst, script)
    inst.SoundEmitter:PlaySound("monkeyisland/monkeyqueen/speak")
end

local function OnIsNight(inst, isnight)
    if isnight then
		inst.AnimState:PlayAnimation("sleep_pre")
		inst.AnimState:PushAnimation("sleep_loop", true)
    else
		inst.AnimState:PlayAnimation("sleep_pst")
		inst.AnimState:PushAnimation("idle", true)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("monkey_queen.png")
    minimap:SetPriority(1)
	
	local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize(6, 3.5)

    inst.AnimState:SetBank("monkey_queen")
    inst.AnimState:SetBuild("monkey_queen")
    inst.AnimState:PlayAnimation("idle", true)

	inst:AddTag("structure")
    inst:AddTag("shelter")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("lootdropper")
    
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MONKEYQUEEN"
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(5, 7)
    inst.components.playerprox:SetOnPlayerNear(OnTalk)
    inst.components.playerprox:SetOnPlayerFar(OnTalk)
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
    inst.components.health.redirect = nodebrisdmg
	inst.components.health.ondelta = onhealthchange

    inst:AddComponent("combat")
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
	
	inst:SetStateGraph("SGmonkeyqueen")
	
	inst:WatchWorldState("isnight", OnIsNight)
    OnIsNight(inst, TheWorld.state.isnight)

    return inst
end

return Prefab("sap_monkeyisland_queen", fn, assets, prefabs),
MakePlacer("sap_monkeyisland_queen_placer", "monkey_queen", "monkey_queen", "idle")