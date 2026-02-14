require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/chameleon.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs =
{
	"kyno_chamaleon_child"
}

local function disolve(inst, mult)
    if not mult then
        mult = 1
    end
    local time_to_erode = 4 * mult

    local tick_time = TheSim:GetTickTime()
    inst:StartThread( function()
        local ticks = 0
        while ticks * tick_time < time_to_erode do
            local erode_amount = ticks * tick_time / time_to_erode
            inst.AnimState:SetErosionParams( erode_amount, 0.1, 1.0 )
            ticks = ticks + 1
            Yield()
        end
        inst:Remove()
    end)
end

local function Disappear(inst, mult)
    if not mult then
        mult = 1
    end

    inst.AnimState:SetMultColour(1,0.5,0.5, 1)
    inst.AnimState:PlayAnimation("disappear")
    inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/cameleon/disappear","appear")
    inst.SoundEmitter:SetParameter("appear", "intensity", 0)
    inst.SoundEmitter:SetParameter("appear", "intensity", 1)  

    local layer1 = SpawnPrefab("kyno_chamaleon_child")
    inst:AddChild(layer1)
    layer1.AnimState:SetFinalOffset(-1)            
    layer1.Transform:SetPosition(0,0,0)
    layer1.AnimState:PlayAnimation("disappear")    
    inst.layer1 = layer1

    local layer2 = SpawnPrefab("kyno_chamaleon_child")
    inst:AddChild(layer2)
    layer2.AnimState:SetFinalOffset(-2)    
    layer2.AnimState:SetMultColour(0.5,0.5,1, 1)
    layer2.Transform:SetPosition(0,0,0)
    layer2.AnimState:PlayAnimation("disappear")
    inst.layer2 = layer2

    local layer3 = SpawnPrefab("kyno_chamaleon_child")
    inst:AddChild(layer3)
    layer3.AnimState:SetFinalOffset(-3)    
    layer3.AnimState:SetMultColour(0.5,1,0.5, 1)
    layer3.Transform:SetPosition(0,0,0)
    layer3.AnimState:PlayAnimation("disappear")    
    inst.layer3 = layer3

    inst:DoTaskInTime(0*mult,function() disolve(layer1, mult) end)
    inst:DoTaskInTime(0.5*mult,function() disolve(layer2, mult) end)
    inst:DoTaskInTime(1*mult,function() disolve(layer3, mult) end)
    inst:DoTaskInTime(1.5*mult,function() disolve(inst, mult) end)
end

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
	-- inst:DoTaskInTime(2, function() inst:Remove() end)
end

local function onhealthchange(inst)
	if inst.components.health:IsDead() then
		Disappear(inst)
		clearobstacle(inst)
		inst.components.lootdropper:DropLoot()
	end
end

local function keeptargetfn()
    return false
end

local function onload(inst)
    if inst.components.health:IsDead() then
		Disappear(inst)
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
		inst.AnimState:PlayAnimation("dialogue_2")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle", true)
	inst.components.talker:Say("Nice two point landing... Out of ten that is.")
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/cameleon/talk")
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
	
	inst.Transform:SetTwoFaced()
	inst.Transform:SetScale(0.85,0.85,0.85)
	
	inst.AnimState:SetBank("cham")
	inst.AnimState:SetBuild("chameleon")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("chameleon")
	
	inst:AddComponent("talker")
	inst.components.talker.fontsize = 30
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.colour = Vector3(.9, .4, .4)
	inst.components.talker.offset = Vector3(0,-550,0)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(200)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false
	inst.components.health.redirect = nodebrisdmg

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	
	inst:AddComponent("savedrotation")
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

local function introchildfn()  
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	
    inst.Transform:SetTwoFaced()

    inst.AnimState:SetBank("cham")
    inst.AnimState:SetBuild("chameleon")
    inst.AnimState:PlayAnimation("idle")

    inst.persists = false

    inst:AddTag("NOCLICK")
    inst:AddTag("notarget")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

return Prefab("kyno_chamaleon", fn, assets, prefabs),
Prefab("kyno_chamaleon_child", introchildfn, assets, prefabs),
MakePlacer("kyno_chamaleon_placer", "cham", "chameleon", "idle", false, nil, nil, nil, 90, nil)