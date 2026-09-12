require "prefabutil"

local assets = 
{
	Asset("ANIM", "anim/turf.zip"),
}

local prefabs =
{
    "gridplacer",
	
	"sinkhole_spawn_fx_1",
    "sinkhole_spawn_fx_2",
    "sinkhole_spawn_fx_3",
	
	"sap_turf_webbing",
	"sap_ground_webbing",
}

local function OnDigWebbing(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("sinkhole_spawn_fx_"..tostring(math.random(3))).Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("sap_turf_webbing").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/wilson/dig")
	
	inst.GroundCreepEntity:SetRadius(0)
	
	inst:Remove()
end

local function OnPickup(inst)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
end

local function OnDeploy(inst, pt)
    local web = SpawnPrefab("sap_ground_webbing")
    if web ~= nil then
		web.SoundEmitter:PlaySound("dontstarve/creatures/spider/spider_egg_sack")
        web.Transform:SetPosition(pt:Get())
        inst.components.stackable:Get():Remove()
    end
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	MakeInventoryFloatable(inst, "med", nil, 0.65)

	inst.AnimState:SetBank("turf")
	inst.AnimState:SetBuild("turf")
	inst.AnimState:PlayAnimation("webbing")

	inst:AddTag("cattoy")
	inst:AddTag("molebait")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
		
	inst:AddComponent("bait")
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	inst.components.inventoryitem:SetOnPickupFn(OnPickup)

	inst:AddComponent("fuel")
	inst.components.fuel.fuelvalue = TUNING.MED_FUEL

	inst:AddComponent("deployable")
	inst.components.deployable:SetDeployMode(DEPLOYMODE.WALL)
	inst.components.deployable:SetUseGridPlacer(true)
	inst.components.deployable.ondeploy = OnDeploy
	
	MakeMediumBurnable(inst, TUNING.MED_BURNTIME)
	MakeSmallPropagator(inst)
	MakeHauntableLaunchAndIgnite(inst)
		
	return inst
end

local function webfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local GroundCreep = inst.entity:AddGroundCreepEntity()
	GroundCreep:SetRadius(1)
	
	inst:AddTag("webbedground")
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(OnDigWebbing)
	inst.components.workable:SetWorkLeft(1)

	return inst
end

return Prefab("sap_turf_webbing", fn, assets, prefabs),
Prefab("sap_ground_webbing", webfn, assets, prefabs)