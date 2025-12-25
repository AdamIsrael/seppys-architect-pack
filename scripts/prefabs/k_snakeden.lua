require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/bush_vine.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local SNAKE_POISON_CHANCE = 0.25
local onshake

local function stopshaking(inst)
	if inst.shaketask then
		inst.shaketask:Cancel()
		inst.shaketask = nil
	end
end

local function startshaking(inst)
	stopshaking(inst)
	inst.shaketask = inst:DoTaskInTime(5+(math.random()*2), onshake)
end

local function spawnsnake(inst, target)
	if math.random() < SNAKE_POISON_CHANCE then
		inst.components.childspawner.childname = "kyno_cobra_poison"
	else
		inst.components.childspawner.childname = "kyno_cobra"
	end

	local snake = inst.components.childspawner:SpawnChild()
	if snake then
		local spawnpos = Vector3(inst.Transform:GetWorldPosition())
		spawnpos = spawnpos + TheCamera:GetDownVec()
		snake.Transform:SetPosition(spawnpos:Get())
		if snake and target and snake.components.combat then
			snake.components.combat:SetTarget(target)
		end
	end
end

local function startspawning(inst, isday)
	if inst.components.childspawner then
		inst.components.childspawner:StartSpawning()
	end
end

local function stopspawning(inst)
	if inst.components.childspawner then
		inst.components.childspawner:StopSpawning()
	end
end

onshake = function (inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/snake/snake_bush")
	inst.AnimState:PlayAnimation("rustle_snake", false)
	inst.AnimState:PushAnimation("idle", true)
	
	startshaking(inst)
end

local function onspawnsnake(inst)
	if inst:IsValid() then
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/snake/snake_bush")
		inst.AnimState:PlayAnimation("rustle", false)
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function onwake(inst)
	startshaking(inst)
end

local function onsleep(inst)
	stopshaking(inst)
end

local function onremove(inst)
	stopshaking(inst)
end

local function onnear(inst, player)
	stopshaking(inst)
	spawnsnake(inst, player)
end

local function onfar(inst)
	startshaking(inst)
end

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("twigs")
	inst.components.lootdropper:SpawnLootPrefab("twigs")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle", true)
	inst.Physics:SetCollides(true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_vinebush.tex")
	
	inst.AnimState:SetBank("bush_vine")
	inst.AnimState:SetBuild("bush_vine")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("thorny")
	inst:AddTag("snakeden")
	
	inst:SetPrefabNameOverride("kyno_vinebush")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "kyno_cobra"
	-- inst.components.childspawner:SetRareChild("kyno_cobra_poison", 0.25)
	inst.components.childspawner:SetRegenPeriod(90)
	inst.components.childspawner:SetSpawnPeriod(5)
	inst.components.childspawner:SetMaxChildren(3)
	inst.components.childspawner:SetSpawnedFn(onspawnsnake)
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(2, 3)
	inst.components.playerprox:SetOnPlayerNear(onnear)
	inst.components.playerprox:SetOnPlayerFar(onfar)
	inst.components.playerprox.period = math.random()*0.16+0.32

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
		
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)	
	
	inst.OnEntityWake = onwake
	inst.OnEntitySleep = onsleep
	inst.OnRemoveEntity = onremove
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:DoTaskInTime(1, function()
        if TheWorld.state.isday and not TheWorld:HasTag("cave") then
            stopspawning(inst)
        else
			startspawning(inst)
        end
    end)
    inst:ListenForEvent("phasechanged", function(src, data)
        if data ~= "night" and data ~= "dusk" and not TheWorld:HasTag("cave") then
			inst:DoTaskInTime(2, function()
				stopspawning(inst)
			end)
        else
			inst:DoTaskInTime(2, function()
				startspawning(inst)
			end)
		end
    end, TheWorld)

	return inst
end

return Prefab("kyno_snakeden", fn, assets, prefabs),
MakePlacer("kyno_snakeden_placer", "bush_vine", "bush_vine", "idle")