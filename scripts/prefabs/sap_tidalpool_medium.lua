require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/tidal_pool.zip"),
	Asset("ANIM", "anim/marsh_plant_tropical.zip"),
}

local prefabs =
{
	"sap_marsh_plant_tropical",
	"sap_tropicalfish",
}

local function SpawnPlants(inst, plantname, count, maxradius)

	if inst.decor then
		for i,item in ipairs(inst.decor) do
			item:Remove()
		end
	end
	inst.decor = {}

	local plant_offsets = {}

	for i=1,math.random(math.ceil(count/2),count) do
		local a = math.random()*math.pi*2
		local x = math.sin(a)*maxradius+math.random()*0.2
		local z = math.cos(a)*maxradius+math.random()*0.2
		table.insert(plant_offsets, {x,0,z})
	end

	for k, offset in pairs( plant_offsets ) do
		local plant = SpawnPrefab( plantname )
		plant.entity:SetParent( inst.entity )
		plant.Transform:SetPosition( offset[1], offset[2], offset[3] )
		table.insert( inst.decor, plant )
	end
end

local sizes =
{
	{anim="small_idle", rad=2.0, plantcount=2, plantrad=2.0},
	{anim="med_idle", rad=2.6, plantcount=3, plantrad=2.6},
	{anim="big_idle", rad=3.6, plantcount=4, plantrad=3.7},
}

local function SetSize(inst, size)
	inst.size = size or 2
	inst.AnimState:PlayAnimation(sizes[inst.size].anim, true)
	inst.Physics:SetCylinder(sizes[inst.size].rad, 1.0)
	SpawnPlants(inst, "sap_marsh_plant_tropical", sizes[inst.size].plantcount, sizes[inst.size].plantrad)
end

local function onsave(inst, data)
	data.size = inst.size
end

local function onload(inst, data, newents)
	if data and data.size then
		SetSize(inst, data.size)
	end
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation(sizes[inst.size].anim, true)
	inst.AnimState:PushAnimation(sizes[inst.size].anim, true)
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation(sizes[inst.size].anim, true)
	inst.AnimState:PushAnimation(sizes[inst.size].anim, true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("pond_cave.png")
	
	inst.AnimState:SetBank("tidal_pool")
	inst.AnimState:SetBuild("tidal_pool")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	MakeObstaclePhysics(inst, 3.5)
	
	inst:AddTag("watersource")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    inst:AddTag("fishable")
    inst:AddTag("tidalpool")

    inst.no_wet_prefix = true
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("watersource")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("fishable")
	inst.components.fishable:AddFish("sap_tropicalfish")
	inst.components.fishable:SetRespawnTime(TUNING.FISH_RESPAWN_TIME)
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)

	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst.OnSave = onsave
	inst.OnLoad = onload

	SetSize(inst)

	return inst
end

local function plantfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)
	
	inst.AnimState:SetBank("marsh_plant_tropical")
	inst.AnimState:SetBuild("marsh_plant_tropical")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddComponent("inspectable")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	return inst
end

return Prefab("sap_tidalpool_medium", fn, assets, prefabs),
-- Prefab("kyno_marsh_plant_tropical", plantfn, assets, prefabs),
MakePlacer("sap_tidalpool_medium_placer", "tidal_pool", "tidal_pool", "med_idle", true)