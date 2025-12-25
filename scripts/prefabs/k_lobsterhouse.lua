local assets =
{
	Asset("ANIM", "anim/lobster_home.zip"),

	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "rocky",
	"kyno_lobster",
}

local function ReturnChildren(inst)
    for k, child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.homeseeker ~= nil then
            child.components.homeseeker:GoHome()
        end
        child:PushEvent("gohome")
    end
end

local function onhammered(inst, worker)
	if inst.components.spawner ~= nil and inst.components.spawner:IsOccupied() then
		inst.components.spawner:ReleaseChild()
	end
	inst.components.lootdropper:DropLoot()
	local fx = SpawnPrefab("collapse_big")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("stone")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("build")
    inst.AnimState:PushAnimation("idle")
end

local function onhit(inst, worker)
end

local function onisday(inst, isday)
	if isday then
		inst.components.childspawner:StopSpawning()
	else
		inst.components.childspawner:StartSpawning()
	end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2.3)
	
	inst:AddTag("structure")

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_lobster_home.tex")

	inst.AnimState:SetBuild("lobster_home")
	inst.AnimState:SetBank("lobster_home")
	inst.AnimState:PlayAnimation("idle", true)

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("childspawner")
	inst.components.childspawner:SetRegenPeriod(20)
	inst.components.childspawner:SetSpawnPeriod(20)
	inst.components.childspawner:SetMaxChildren(1)
	inst.components.childspawner.childname = "kyno_lobster"
	inst.components.childspawner:StartSpawning()
	inst.components.childspawner:StartRegen()
	inst.components.childspawner.childreninside = 1

	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(20)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
    inst:AddComponent("inspectable")
	
	MakeHauntableWorkAndIgnite(inst)
	
	onisday(inst, TheWorld.state.iscaveday)
	inst:WatchWorldState("iscaveday", onisday)
	
	local color = 0.5 + math.random() * 0.5
	inst.AnimState:SetMultColour(color, color, color, 1)
	inst.AnimState:SetTime(math.random()*2)


	MakeHauntableWork(inst)

	return inst
end

return Prefab("kyno_lobster_home", fn, assets, prefabs),
MakePlacer("kyno_lobster_home_placer", "lobster_home", "lobster_home", "idle" ) 