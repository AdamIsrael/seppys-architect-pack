local assets =
{
    Asset("ANIM", "anim/sharkitten_basic.zip"),
	Asset("ANIM", "anim/sharkitten_build.zip"),
}

local prefabs = 
{
    "fishmeat",
}

local brain = require "brains/sharkittenbrain"
local TARGET_DIST = 15

SetSharedLootTable('kyno_sharkitten',
{
    {"fishmeat", 1.00},
    {"fishmeat", 1.00},
})

local function OnAttacked(inst, data)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, 30, {'kyno_sharkitten'})
    
    local num_friends = 0
    local maxnum = 5
    for k,v in pairs(ents) do
        v:PushEvent("gohome")
        num_friends = num_friends + 1
        
        if num_friends > maxnum then
            break
        end
    end
end

local function RetargetFn(inst)
    local notags = {"FX", "NOCLICK","INLIMBO"}
    local yestags = {"prey", "smallcreature"}
    return FindEntity(inst, TARGET_DIST, function(guy)
        return inst.components.combat:CanTarget(guy)
    end, nil, notags, yestags)
end

local function KeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function kittenfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 10, .5)

	inst.DynamicShadow:SetSize(2.0, 1.0)
    inst.Transform:SetFourFaced()
	
	inst.AnimState:SetScale(0.75, 0.75, 0.75)

    inst.AnimState:SetBank("sharkitten")
    inst.AnimState:SetBuild("sharkitten_build")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("sharkitten")
	inst:AddTag("sap_sharkitten")
    inst:AddTag("scarytoprey")
    inst:AddTag("prey")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("sleeper")
    inst:AddComponent("follower")
    inst:AddComponent("knownlocations")
	inst:AddComponent("eater")
	
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 10
    inst.components.locomotor.runspeed = 10

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)

    inst:AddComponent("combat")
    inst.components.combat:SetRetargetFunction(2, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('kyno_sharkitten')

	inst:SetBrain(brain)
    inst:SetStateGraph("SGsharkitten")
	
    inst:ListenForEvent("attacked", OnAttacked)
	
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    return inst
end

return Prefab("sap_sharkitten", kittenfn, assets, prefabs)