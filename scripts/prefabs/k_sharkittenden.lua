require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/sharkitten_den.zip"),
	Asset("ANIM", "anim/sharkitten_basic.zip"),
	Asset("ANIM", "anim/sharkitten_build.zip"),
}

local prefabs = 
{
	"sap_sharkittenden_low",
	"sap_sharkitten",
}

local anims = {"idle_active", "idle_inactive"}

local function ReturnChildren(inst)
    for k,child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.homeseeker then
            child.components.homeseeker:GoHome()
        end
        child:PushEvent("gohome")
    end
end

local function SpawnKittens(inst, num)
    for i = 1, num do
        local kitten = SpawnPrefab("sap_sharkitten")
        kitten.Transform:SetPosition(inst:GetPosition():Get())
        inst.components.herd:AddMember(kitten)
    end
end

local function MorningMilk(inst, isday)
    if isday then
        inst.components.childspawner:StartSpawning()
    else
        inst.components.childspawner:StopSpawning()
        ReturnChildren(inst)
    end
end

local function ActivateSpawner(inst, isload)
    if not inst.spawneractive then
        inst.spawneractive = true

        inst.activatefn = function()
            inst.AnimState:PlayAnimation("idle_active")
            inst.blink_task = inst:DoPeriodicTask(math.random() * 10 + 10, function()
                if inst.components.childspawner and inst.components.childspawner.childreninside > 0 then
                    inst.AnimState:PlayAnimation("blink")
                    inst.AnimState:PushAnimation("idle_active")
                end
            end)
    
            inst:WatchWorldState("iscaveday", MorningMilk)
        end

        if isload then
            inst.activatefn()
        end
    end
end

local function DeactiveateSpawner(inst, isload)
    if inst.spawneractive then
        inst.spawneractive = false
        
        inst.deactivatefn = function()
            inst.AnimState:PlayAnimation("idle_inactive")
            if inst.blink_task then
                inst.blink_task:Cancel()
                inst.blink_task = nil
            end

            inst:StopWatchingWorldState("iscaveday", MorningMilk)
        end

        if isload then
            inst.deactivatefn()
        end
    end
end

local function getstatus(inst)
    if not inst.spawneractive then 
        return "INACTIVE"
    end
end

local function OnSave(inst, data)
    data.spawneractive = inst.spawneractive
end

local function OnLoad(inst, data)
    -- if data and data.spawneractive then
        -- ActivateSpawner(inst, true)
	-- else
		-- DeactiveateSpawner(inst, true)
	-- end
end

local function dig_up_active(inst, worker, workleft)
	SpawnPrefab("sand_puff_large_front").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("sand_puff_large_back").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
	SpawnPrefab("sap_sharkittenden_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_inactive(inst, worker, workleft)
	SpawnPrefab("sand_puff_large_front").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("sand_puff_large_back").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:SpawnLootPrefab("spoiled_fish")
	inst.components.lootdropper:SpawnLootPrefab("spoiled_fish_small")
	inst.components.lootdropper:SpawnLootPrefab("turf_beach")
	inst.components.lootdropper:SpawnLootPrefab("turf_beach")
	inst:Remove()
end

local function activefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_sharkden.tex")
	
	inst.AnimState:SetBank("sharkittenden")
	inst.AnimState:SetBuild("sharkitten_den")
	inst.AnimState:PlayAnimation("idle_active")
	
	MakeObstaclePhysics(inst, 2)
	
	inst:AddTag("structure")
	inst:AddTag("sharkhome")
	inst:AddTag("scarytoprey")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")

	inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_active)
	inst.components.workable:SetWorkLeft(5)
	
	inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "sap_sharkitten"
    inst.components.childspawner:SetRegenPeriod(2400)
    inst.components.childspawner:SetSpawnPeriod(30)
    inst.components.childspawner:SetMaxChildren(4)
    inst.components.childspawner:StartRegen()
	
	inst.SpawnKittens = SpawnKittens
    inst.OnLoad = OnLoad
    inst.OnSave = OnSave
	
	inst:WatchWorldState("iscaveday", MorningMilk)
    ActivateSpawner(inst, true)
    inst.components.childspawner:StartSpawning()
	
	return inst
end

local function inactivefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_sharkden.tex")
	
	inst.AnimState:SetBank("sharkittenden")
	inst.AnimState:SetBuild("sharkitten_den")
	inst.AnimState:PlayAnimation("idle_inactive")
	
	MakeObstaclePhysics(inst, 2)
	
	inst:AddTag("structure")
	inst:AddTag("sharkhome")
	inst:AddTag("scarytoprey")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_inactive)
	inst.components.workable:SetWorkLeft(2)
	
	return inst
end

return Prefab("sap_sharkittenden", activefn, assets, prefabs),
Prefab("sap_sharkittenden_low", inactivefn, assets, prefabs),
MakePlacer("sap_sharkittenden_placer", "sharkittenden", "sharkitten_den", "idle_active", false, nil, nil, nil, 90, nil)