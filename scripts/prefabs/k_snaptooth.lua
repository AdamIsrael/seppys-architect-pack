require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/venus_flytrap_lg_build.zip"),
	Asset("ANIM", "anim/venus_flytrap_planted.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
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
	end
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("idle", true)
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("taunt")
	inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/venus_flytrap/4/taunt")
end

local function onfar(inst)
	inst.AnimState:PlayAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/venus_flytrap/4/breath_out")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/enemy/venus_flytrap/4/breath_out")
	
	inst.AnimState:SetScale(1.5, 1.5, 1.5)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_flytrap.tex")
	
	inst.Transform:SetFourFaced()
	
	inst.AnimState:SetBank("venus_flytrap_planted")
	inst.AnimState:SetBuild("venus_flytrap_lg_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	inst.Physics:SetDontRemoveOnSleep(true)
	
	inst._pfpos = nil
	inst._ispathfinding = net_bool(inst.GUID, "_ispathfinding", "onispathfindingdirty")
	makeobstacle(inst)
	inst:DoTaskInTime(0, InitializePathFinding)

	inst.OnRemoveEntity = onremove
	
	inst:AddTag("structure")
	inst:AddTag("plantkin")
	-- inst:AddTag("notarget")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3, 6)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(250)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = true
	inst.components.health.canheal = false

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	
	inst:AddComponent("savedrotation")
	
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	return inst
end

local function snaptoothplacetestfn(inst)
	inst.AnimState:SetScale(1.5, 1.5, 1.5)
end

return Prefab("kyno_flytrap", fn, assets, prefabs),
MakePlacer("kyno_flytrap_placer", "venus_flytrap_planted", "venus_flytrap_lg_build", "idle", false, nil, nil, nil, 90, nil, snaptoothplacetestfn)