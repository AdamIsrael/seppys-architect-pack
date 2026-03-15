local assets =
{
    Asset("ANIM", "anim/tentacle_pillar.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
    Asset("SOUND", "sound/tentacle.fsb"),
}

local prefabs = 
{
    "tentaclespike",
    "tentaclespots",
    "turf_marsh",
    "rocks",
}

local function OnHit(inst, attacker, damage) 
    if not inst.components.health:IsDead() then
        inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_hurt_VO")
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", true)
    end
end

local function OnEmergeOver(inst)
    inst:RemoveEventCallback("animover", OnEmergeOver)
    inst:RemoveTag("notarget")
    inst.components.health:SetInvincible(false)

    inst.AnimState:PlayAnimation("idle", true)
end

local function OnEmerge(inst)
    if not inst.components.health:IsDead() then
        inst:AddTag("notarget")
        inst.components.health:SetInvincible(true)

        inst.AnimState:PlayAnimation("emerge")
        inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_emerge")

        inst:ListenForEvent("animover", OnEmergeOver)
    end
end

local function DoRetract(inst)
    if not inst.components.health:IsDead() then
        inst:RemoveEventCallback("animover", OnEmergeOver)
        inst.components.health:SetInvincible(false)
        inst.components.health:Kill()
    end
end

local function SwapToHole(inst)
    inst:Remove()
end

local function OnDeath(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    inst.components.lootdropper:DropLoot(Vector3(x, 20, z))

    if inst:IsAsleep() then
        SwapToHole(inst)
    else
        inst.AnimState:PlayAnimation("retract")

        inst.SoundEmitter:KillSound("loop")
        inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_die")
        inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_die_VO")

        inst:ListenForEvent("animover", SwapToHole)
        inst:ListenForEvent("entitysleep", SwapToHole)
    end
end

local function OnEntityWake(inst)
    inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_idle_LP", "loop") 
end

local function OnEntitySleep(inst)
    inst.SoundEmitter:KillSound("loop")
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("emerge")
	inst.SoundEmitter:PlaySound("dontstarve/tentacle/tentapiller_emerge")
    inst.AnimState:PushAnimation("idle", true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 2, 24)
    inst.entity:SetAABB(60, 20)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("tentacle_pillar.png")

    inst.AnimState:SetBank("tentaclepillar")
    inst.AnimState:SetBuild("tentacle_pillar")
    inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
    inst:AddTag("wet")
	
	inst:SetPrefabNameOverride("tentacle_pillar")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")	
    inst:AddComponent("lootdropper")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(100)
    inst:ListenForEvent("death", OnDeath)

    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(OnHit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst.OnEmerge = OnEmerge
    inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake
	
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("sap_bigtentacle", fn, assets, prefabs),
MakePlacer("sap_bigtentacle_placer", "tentaclepillar", "tentacle_pillar", "idle")