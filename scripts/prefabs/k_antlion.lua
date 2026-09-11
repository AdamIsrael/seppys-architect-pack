require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/antlion_build.zip"),
    Asset("ANIM", "anim/antlion_basic.zip"),
    Asset("ANIM", "anim/antlion_action.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs = {}

local function OnIsPathFindingDirty(inst)    
    local wall_x, wall_y, wall_z = inst.Transform:GetWorldPosition()
    if TheWorld.Map:GetPlatformAtPoint(wall_x, wall_z) == nil then        
        if inst._ispathfinding:value() then
            if inst._pfpos == nil then
                inst._pfpos = Point(wall_x, wall_y, wall_z)
                TheWorld.Pathfinder:AddWall(wall_x, wall_y, wall_z)
            end
        elseif inst._pfpos ~= nil then
            TheWorld.Pathfinder:RemoveWall(wall_x, wall_y, wall_z)
            inst._pfpos = nil
        end
    end
end

local function InitializePathFinding(inst)
    inst:ListenForEvent("onispathfindingdirty", OnIsPathFindingDirty)
    OnIsPathFindingDirty(inst)
end

local function makeobstacle(inst)
    inst.Physics:SetActive(true)
    inst._ispathfinding:set(true)
end

local function clearobstacle(inst)
    inst.Physics:SetActive(false)
    inst._ispathfinding:set(false)
	inst:DoTaskInTime(2, function() inst:Remove() end)
end

local function onhealthchange(inst)
	if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("death")
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/bodyfall_death")
		clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
	end
end

local function keeptargetfn()
    return false
end

local function onload(inst)
    if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("death")
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/bodyfall_death")
        clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
    end
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    OnIsPathFindingDirty(inst)
end

local function onhit(inst)
	local healthpercent = inst.components.health:GetPercent()
        if healthpercent > 0 then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle", true)
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/hit")
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("enter")
	inst.AnimState:PushAnimation("idle", true)
end

local function nodebrisdmg(inst, amount, overtime, cause, ignore_invincible, afflicter, ignore_absorb)
    return afflicter ~= nil and afflicter:HasTag("quakedebris")
end

local function lookaround(inst)
if inst:HasTag("antlion_friendly") then
	inst:DoTaskInTime(5+math.random()*10, function() lookaround(inst) end)
		inst.AnimState:PlayAnimation("lookaround")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("taunt")
	inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/taunt")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("antlion.png")
	
	MakeObstaclePhysics(inst, 1.5)
	
	inst.AnimState:SetBank("antlion")
	inst.AnimState:SetBuild("antlion_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("antlion_friendly")
	
	inst:SetPrefabNameOverride("antlion")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(250)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false
	inst.components.health.redirect = nodebrisdmg

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(5, 7)
    inst.components.playerprox:SetOnPlayerNear(onnear)
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	lookaround(inst)
	
	return inst
end

return Prefab("kyno_antlion", fn, assets, prefabs),
MakePlacer("kyno_antlion_placer", "antlion", "antlion_build", "idle", false, nil, nil, nil, 90, nil, nil)  