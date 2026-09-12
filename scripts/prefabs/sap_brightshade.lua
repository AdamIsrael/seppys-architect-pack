require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/lunarthrall_plant_front.zip"),
    Asset("ANIM", "anim/lunarthrall_plant_back.zip"),
}

local prefabs =
{
	"plantmeat",
	"lunarplant_husk",
}
local function customPlayAnimation(inst, anim, loop)
    inst.AnimState:PlayAnimation(anim, loop)
	
    if inst.back then
        inst.back.AnimState:PlayAnimation(anim, loop)
    end
end

local function customPushAnimation(inst, anim, loop)
    inst.AnimState:PushAnimation(anim, loop)
	
    if inst.back then
        inst.back.AnimState:PushAnimation(anim, loop)
    end
end

local function customSetRandomFrame(inst)
    local frame = math.random(inst.AnimState:GetCurrentAnimationNumFrames()) -1
	
    inst.AnimState:SetFrame(frame)
    
    if inst.back then
        inst.back.AnimState:SetFrame(frame)
    end
end

local function back_onentityreplicated(inst)
	local parent = inst.entity:GetParent()
	
	if parent ~= nil and parent.prefab == "sap_brightshade" then
		table.insert(parent.highlightchildren, inst)
	end
end

local function back_onremoveentity(inst)
	local parent = inst.entity:GetParent()
	
	if parent ~= nil and parent.highlightchildren ~= nil then
		table.removearrayvalue(parent.highlightchildren, inst)
	end
end

local function backfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("lunarthrall_plant_back")
    inst.AnimState:SetBuild("lunarthrall_plant_back")
    inst.AnimState:PlayAnimation("idle_med", true)

    inst:AddTag("fx")

	inst.OnRemovedEntity = back_onremoveentity

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = back_onentityreplicated
        return inst
    end

    inst.persists = false

    return inst
end

local function spawnback(inst)
    local back = SpawnPrefab("sap_brightshade_back")
	
    back.AnimState:SetFinalOffset(-1)
    inst.back = back
	
	table.insert(inst.highlightchildren, back)

    back:ListenForEvent("death", function()
        local self = inst.components.burnable
        if self ~= nil and self:IsBurning() and not self.nocharring then
            back.AnimState:SetMultColour(.2, .2, .2, 1)
        end
    end, inst)

    if math.random() < 0.5 then
        inst.AnimState:SetScale(-1,1)
        back.AnimState:SetScale(-1,1)
    end
	
    local color = .6 + math.random() * .4
	
    inst.tintcolor = color
    inst.AnimState:SetMultColour(color, color, color, 1)
    back.AnimState:SetMultColour(color, color, color, 1)

	back.entity:SetParent(inst.entity)
    inst.components.colouradder:AttachChild(back)
end

local function OnHit(inst)
	inst:customPlayAnimation("hit_med")
end

local function OnBuilt(inst)
    inst:customPlayAnimation("spawn_med")
end

local function OnDeath(inst)
    inst.components.lootdropper:DropLoot()
	
    inst:customPlayAnimation("death_med")
	
    inst:ListenForEvent("animover", function()
        if inst.AnimState:IsCurrentAnimation("death_med") then
            inst:Remove()
        end
    end)
end

local function CreateFlame()
    local inst = CreateEntity()

    inst:AddTag("FX")
    if not TheWorld.ismastersim then
        inst.entity:SetCanSleep(false)
    end

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddFollower()

    inst.AnimState:SetBank("lunarthrall_plant")
    inst.AnimState:SetBuild("lunarthrall_plant_front")
    inst.AnimState:PlayAnimation("gestalt_fx", true)
	inst.AnimState:SetMultColour(1, 1, 1, 0.6)
	inst.AnimState:SetLightOverride(0.1)
    inst.AnimState:SetFrame(math.random(inst.AnimState:GetCurrentAnimationNumFrames()) -1)
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
	
	inst.persists = false

    return inst
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, .8)
	inst:SetPhysicsRadiusOverride(.4)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("lunarthrall_plant.png")
    minimap:SetPriority(5)

    inst.AnimState:SetBank("lunarthrall_plant")
    inst.AnimState:SetBuild("lunarthrall_plant_front")
    inst.AnimState:PlayAnimation("idle_med", true)
    inst.AnimState:SetFinalOffset(1)

    inst.customPlayAnimation = customPlayAnimation
    inst.customPushAnimation = customPushAnimation
    inst.customSetRandomFrame = customSetRandomFrame

    inst:AddTag("structure")
    inst:AddTag("lunar_aligned")

	inst.highlightchildren = {}

    inst.entity:SetPristine()

    inst.targetsize = "med"

    if not TheNet:IsDedicated() then
        inst.flame = CreateFlame()
        inst.flame.entity:SetParent(inst.entity)
        inst.flame.Follower:FollowSymbol(inst.GUID, "follow_gestalt_fx", nil, nil, nil, true)
    end

    if not TheWorld.ismastersim then
        return inst
    end

    inst:customSetRandomFrame()
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("colouradder")
    inst:AddComponent("timer")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)
	inst.components.health:StartRegen(100, 8)
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false
	inst.components.health.redirect = nodebrisdmg
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "LUNARTHRALL_PLANT"

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(0)
	
	inst:SetStateGraph("SGlunarthrall_plant")

    inst:ListenForEvent("death", OnDeath)
	inst:ListenForEvent("onbuilt", OnBuilt)

    MakeLargeBurnableCharacter(inst,"follow_gestalt_fx")

	spawnback(inst)

    return inst
end

return Prefab("sap_brightshade_back", backfn, assets, prefabs),
Prefab("sap_brightshade", fn, assets, prefabs),
MakePlacer("sap_brightshade", "lunarthrall_plant", "lunarthrall_plant_front", "idle_med")