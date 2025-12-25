require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/grotto_bug_house.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onhammered(inst, worker)
	if inst.doortask ~= nil then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        inst.components.spawner:ReleaseChild()
    end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local prefabs =
{
    "bunnyman",
    "splash_sink",
}

local function getstatus(inst)
    return (inst:HasTag("burnt") and "BURNT")
        or (inst.lightson and
            inst.components.spawner ~= nil and
            inst.components.spawner:IsOccupied() and
            "FULL")
        or nil
end

local function onvacate(inst, child)
    if not inst:HasTag("burnt") and child ~= nil then
        local child_platform = child:GetCurrentPlatform()
        if (child_platform == nil and not child:IsOnValidGround()) then
            local fx = SpawnPrefab("splash_sink")
            fx.Transform:SetPosition(child.Transform:GetWorldPosition())
            child:Remove()
        elseif child.components.health ~= nil then
            child.components.health:SetPercent(1)
        end
    end
end

local function onstopcavedaydoortask(inst)
    inst.doortask = nil
    inst.components.spawner:ReleaseChild()
end

local function OnStopCaveDay(inst)
    if not inst:HasTag("burnt") and inst.components.spawner:IsOccupied() then
        if inst.doortask ~= nil then
            inst.doortask:Cancel()
        end
        inst.doortask = inst:DoTaskInTime(1 + math.random() * 2, onstopcavedaydoortask)
    end
end

local function SpawnCheckCaveDay(inst)
    inst.inittask = nil
    inst:WatchWorldState("stopcaveday", OnStopCaveDay)
    if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
        if not TheWorld.state.iscaveday then
            inst.components.spawner:ReleaseChild()
        end
    end
end

local function oninit(inst)
    inst.inittask = inst:DoTaskInTime(math.random(), SpawnCheckCaveDay)
    if inst.components.spawner ~= nil and
        inst.components.spawner.child == nil and
        inst.components.spawner.childname ~= nil and
        not inst.components.spawner:IsSpawnPending() then
        local child = SpawnPrefab(inst.components.spawner.childname)
        if child ~= nil then
            inst.components.spawner:TakeOwnership(child)
            inst.components.spawner:GoHome(child)
        end
    end
end

local function onbuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/rabbit_hutch_craft")
end

local function house1fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1.2)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_grottohouse1.tex")
	
    inst.AnimState:SetBank("grotto_bug_house")
    inst.AnimState:SetBuild("grotto_bug_house")
    inst.AnimState:PlayAnimation("idle1")
    
	inst:AddTag("structure")
	inst:AddTag("cavedweller")
	inst:AddTag("grotto_structure")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("spawner")
    inst.components.spawner:Configure("bunnyman", TUNING.RABBITHOUSE_SPAWN_TIME)
    inst.components.spawner.onvacate = onvacate
    inst.components.spawner:CancelSpawning()
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", onbuilt)
    inst.inittask = inst:DoTaskInTime(0, oninit)
	
    return inst
end

local function house2fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1.2)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_grottohouse2.tex")
	
    inst.AnimState:SetBank("grotto_bug_house")
    inst.AnimState:SetBuild("grotto_bug_house")
    inst.AnimState:PlayAnimation("idle2")
    
	inst:AddTag("structure")
	inst:AddTag("cavedweller")
	inst:AddTag("grotto_structure")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("spawner")
    inst.components.spawner:Configure("bunnyman", TUNING.RABBITHOUSE_SPAWN_TIME)
    inst.components.spawner.onvacate = onvacate
    inst.components.spawner:CancelSpawning()
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", onbuilt)
    inst.inittask = inst:DoTaskInTime(0, oninit)
	
    return inst
end

local function house3fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1.2)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_grottohouse3.tex")
	
    inst.AnimState:SetBank("grotto_bug_house")
    inst.AnimState:SetBuild("grotto_bug_house")
    inst.AnimState:PlayAnimation("idle3")
    
	inst:AddTag("structure")
	inst:AddTag("cavedweller")
	inst:AddTag("grotto_structure")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("spawner")
    inst.components.spawner:Configure("bunnyman", TUNING.RABBITHOUSE_SPAWN_TIME)
    inst.components.spawner.onvacate = onvacate
    inst.components.spawner:CancelSpawning()
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", onbuilt)
    inst.inittask = inst:DoTaskInTime(0, oninit)
	
    return inst
end

return Prefab("kyno_grottohouse1", house1fn, assets),
Prefab("kyno_grottohouse2", house2fn, assets),
Prefab("kyno_grottohouse3", house3fn, assets),
MakePlacer("kyno_grottohouse1_placer", "grotto_bug_house", "grotto_bug_house", "idle1"),
MakePlacer("kyno_grottohouse2_placer", "grotto_bug_house", "grotto_bug_house", "idle2"),
MakePlacer("kyno_grottohouse3_placer", "grotto_bug_house", "grotto_bug_house", "idle3")