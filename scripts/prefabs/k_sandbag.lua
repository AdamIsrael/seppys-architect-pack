require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/sandbag_small.zip"),
	Asset("ANIM", "anim/sandbag.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs =
{
	"gridplacer",
	"kyno_sandbagsmall_item",
}

local function OnIsPathFindingDirty(inst)
    if inst._ispathfinding:value() then
        if inst._pfpos == nil then
            inst._pfpos = inst:GetPosition()
			TheWorld.Pathfinder:AddWall(inst._pfpos.x + 0.5, inst._pfpos.y, inst._pfpos.z + 0.5)
			TheWorld.Pathfinder:AddWall(inst._pfpos.x + 0.5, inst._pfpos.y, inst._pfpos.z - 0.5)
			TheWorld.Pathfinder:AddWall(inst._pfpos.x - 0.5, inst._pfpos.y, inst._pfpos.z + 0.5)
			TheWorld.Pathfinder:AddWall(inst._pfpos.x - 0.5, inst._pfpos.y, inst._pfpos.z - 0.5)
        end
    elseif inst._pfpos ~= nil then
		TheWorld.Pathfinder:RemoveWall(inst._pfpos.x + 0.5, inst._pfpos.y, inst._pfpos.z + 0.5)
		TheWorld.Pathfinder:RemoveWall(inst._pfpos.x + 0.5, inst._pfpos.y, inst._pfpos.z - 0.5)
		TheWorld.Pathfinder:RemoveWall(inst._pfpos.x - 0.5, inst._pfpos.y, inst._pfpos.z + 0.5)
		TheWorld.Pathfinder:RemoveWall(inst._pfpos.x - 0.5, inst._pfpos.y, inst._pfpos.z - 0.5)
        inst._pfpos = nil
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
end

local anims =
{
	{ threshold = 0, anim = "rubble" },
	{ threshold = 0.4, anim = "heavy_damage" },
	{ threshold = 0.5, anim = "half" },
	{ threshold = 0.99, anim = "light_damage" },
	{ threshold = 1, anim = "full" },
}

local function resolveanimtoplay(inst, percent)
    for i, v in ipairs(anims) do
        if percent <= v.threshold then
            return v.anim
        end
    end
end

local function onhealthchange(inst, old_percent, new_percent)
    local anim_to_play = resolveanimtoplay(inst, new_percent)
	inst.AnimState:PlayAnimation(anim_to_play)
	if new_percent > 0 and old_percent <= 0 then makeobstacle(inst) end
	if old_percent > 0 and new_percent <= 0 then clearobstacle(inst) end
end

local function keeptargetfn()
    return false
end

local function onload(inst)
    if inst.components.health:IsDead() then
        clearobstacle(inst)
	else
		makeobstacle(inst)
    end
end

local function onremove(inst)
    inst._ispathfinding:set_local(false)
    clearobstacle(inst)
end

local function quantizepos(pt)
	local x, y, z = TheWorld.Map:GetTileCenterPoint(pt:Get())

	if pt.x > x then
		x = x + 1
	else
		x = x - 1
	end

	if pt.z > z then
		z = z + 1
	else
		z = z - 1
	end

	return Vector3(x,y,z)
end

local function quantizeplacer(inst)
	inst.Transform:SetPosition(quantizepos(inst:GetPosition()):Get())
end

local function sandbagplacetestfn(inst)
	inst.components.placer.onupdatetransform = quantizeplacer
end

local function ondeploy(inst, pt, deployer)
	local wall = SpawnPrefab("kyno_sandbagsmall") 
	if wall then
		pt = quantizepos(pt)
		wall.Physics:SetCollides(false)
		wall.Physics:Teleport(pt.x, pt.y, pt.z) 
		wall.Physics:SetCollides(true)
		inst.components.stackable:Get():Remove()
		wall.SoundEmitter:PlaySound("dontstarve_DLC002/common/sandbag")
		makeobstacle(wall)
	end
end

local function onhammered(inst, worker)
	local max_loots = 2
	local num_loots = math.max(1, math.floor(max_loots*inst.components.health:GetPercent()))
	for k = 1, num_loots do
		inst.components.lootdropper:SpawnLootPrefab("turf_beach")
	end
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function onhealthchange(inst, old_percent, new_percent)
	if old_percent <= 0 and new_percent > 0 then makeobstacle(inst) end
	if old_percent > 0 and new_percent <= 0 then clearobstacle(inst) end
	local anim_to_play = resolveanimtoplay(inst, new_percent)
	inst.AnimState:PlayAnimation(anim_to_play)
end

local function onhit(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sandbag")
	local healthpercent = inst.components.health:GetPercent()
	local anim_to_play = resolveanimtoplay(inst, healthpercent)
	inst.AnimState:PushAnimation(anim_to_play)
end

local function onrepaired(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sandbag")		
	makeobstacle(inst)
end

local function onload(inst, data)
	makeobstacle(inst)
	if inst.components.health:GetPercent() <= 0 then
		clearobstacle(inst)
	end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetEightFaced()
	
	inst.AnimState:SetBank("sandbag_small")
	inst.AnimState:SetBuild("sandbag_small")
	inst.AnimState:PlayAnimation("full", false)
	
	MakeObstaclePhysics(inst, 1)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	inst:DoTaskInTime(0, makeobstacle)
	inst:DoTaskInTime(0, InitializePathFinding)
	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("wall")
	inst:AddTag("noauradamage")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("repairable")
	inst.components.repairable.repairmaterial = "kyno_sandbagsmall"
	inst.components.repairable.onrepaired = onrepaired
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("combat")
	inst.components.combat.onhitfn = onhit
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(300)
	inst.components.health.currenthealth = 300
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false

    inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	MakeMediumBurnable(inst)
	MakeLargePropagator(inst)
	inst.components.burnable.flammability = .5
	inst.components.burnable.nocharring = true
	inst.components.propagator.flashpoint = 30 + math.random() * 10
	
	inst.OnLoad = onload
	MakeHauntableWork(inst)

	return inst
end

local function itemfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("sandbag")
	inst.AnimState:SetBuild("sandbag")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("wallbuilder")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = "kyno_sandbagsmall_item"
	inst.components.repairer.healthrepairvalue = 300 / 2
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM
	
	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	
	inst:AddComponent("deployable")
	inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)
	inst.components.deployable.ondeploy = ondeploy
	
	MakeHauntableLaunch(inst)
	
	return inst
end

return Prefab("kyno_sandbagsmall", fn, assets, prefabs),
Prefab("kyno_sandbagsmall_item", itemfn, assets, prefabs),
MakePlacer("kyno_sandbagsmall_item_placer", "sandbag_small", "sandbag_small", "full", false, false, true, nil, nil, "eight", sandbagplacetestfn)