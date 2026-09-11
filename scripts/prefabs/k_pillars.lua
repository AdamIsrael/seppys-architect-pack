require "prefabutil"

local assets = 
{
	Asset("ANIM", "anim/pillar_ruins.zip"),
	Asset("ANIM", "anim/pillar_atrium.zip"),
	Asset("ANIM", "anim/pillar_algae.zip"),
	Asset("ANIM", "anim/pillar_cave.zip"),
	Asset("ANIM", "anim/pillar_cave_flintless.zip"),
	Asset("ANIM", "anim/pillar_cave_rock.zip"),
	Asset("ANIM", "anim/pillar_stalactite.zip"),
	Asset("ANIM", "anim/pillar_archive.zip"),
    Asset("ANIM", "anim/pillar_archive_broken.zip"),
	Asset("ANIM", "anim/moonglass_bigwaterfall.zip"),
}  

local prefabs =
{
	"collapse_big"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function ruinsfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2.35)
	
	inst.AnimState:SetBank("pillar_ruins")
	inst.AnimState:SetBuild("pillar_ruins")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function algaefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2.35)
	
	inst.AnimState:SetBank("pillar_algae")
	inst.AnimState:SetBuild("pillar_algae")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function atriumfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2.35)
	
	inst.AnimState:SetBank("pillar_atrium")
	inst.AnimState:SetBuild("pillar_atrium")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function atriumonfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2.35)
	
	inst.AnimState:SetBank("pillar_atrium")
	inst.AnimState:SetBuild("pillar_atrium")
	inst.AnimState:PlayAnimation("idle_active", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function cavefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2.35)
	
	inst.AnimState:SetBank("pillar_cave")
	inst.AnimState:SetBuild("pillar_cave")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")
	inst:AddTag("NOBLOCK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function flintlessfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2.35)
	
	inst.AnimState:SetBank("pillar_cave_flintless")
	inst.AnimState:SetBuild("pillar_cave_flintless")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")
	inst:AddTag("NOBLOCK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function rockfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2.35)
	
	inst.AnimState:SetBank("pillar_cave_rock")
	inst.AnimState:SetBuild("pillar_cave_rock")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function stalactitefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("pillar_stalactite")
	inst.AnimState:SetBuild("pillar_stalactite")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")
	inst:AddTag("NOBLOCK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function archivefn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2.35)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("pillar_archive.png")
	
	inst.AnimState:SetBank("pillar_archive")
	inst.AnimState:SetBuild("pillar_archive")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function archivebrokenfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 2.35)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("pillar_archive.png")
	
	inst.AnimState:SetBank("pillar_archive_broken")
	inst.AnimState:SetBuild("pillar_archive_broken")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function moon1fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("moonglass_bigwaterfall")
	inst.AnimState:SetBuild("moonglass_bigwaterfall")
	inst.AnimState:PlayAnimation("stalactite1", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")
	inst:AddTag("NOBLOCK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function moon2fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("moonglass_bigwaterfall")
	inst.AnimState:SetBuild("moonglass_bigwaterfall")
	inst.AnimState:PlayAnimation("stalactite2", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")
	inst:AddTag("NOBLOCK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

local function moon3fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("moonglass_bigwaterfall")
	inst.AnimState:SetBuild("moonglass_bigwaterfall")
	inst.AnimState:PlayAnimation("stalactite3", true)
	
	inst:AddTag("structure")
	inst:AddTag("giantpillar")
	inst:AddTag("NOBLOCK")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnFinishCallback(onhammered)

	return inst
end

return Prefab("sap_pillar_ruins", ruinsfn, assets, prefabs),
Prefab("sap_pillar_algae", algaefn, assets, prefabs),
Prefab("sap_pillar_atrium", atriumfn, assets, prefabs),
Prefab("sap_pillar_atrium_on", atriumonfn, assets, prefabs),
Prefab("sap_pillar_cave", cavefn, assets, prefabs),
Prefab("sap_pillar_flintless", flintlessfn, assets, prefabs),
Prefab("sap_pillar_rock", rockfn, assets, prefabs),
Prefab("sap_pillar_stalactite", stalactitefn, assets, prefabs),
Prefab("sap_pillar_archive", archivefn, assets, prefabs),
Prefab("sap_pillar_archive_broken", archivebrokenfn, assets, prefabs),
Prefab("sap_pillar_moon1", moon1fn, assets, prefabs),
Prefab("sap_pillar_moon2", moon2fn, assets, prefabs),
Prefab("sap_pillar_moon3", moon3fn, assets, prefabs),
MakePlacer("sap_pillar_ruins_placer", "pillar_ruins", "pillar_ruins", "idle"),
MakePlacer("sap_pillar_algae_placer", "pillar_algae", "pillar_algae", "idle"),
MakePlacer("sap_pillar_atrium_placer", "pillar_atrium", "pillar_atrium", "idle"),
MakePlacer("sap_pillar_atrium_on_placer", "pillar_atrium", "pillar_atrium", "idle_active"),
MakePlacer("sap_pillar_cave_placer", "pillar_cave", "pillar_cave", "idle"),
MakePlacer("sap_pillar_flintless_placer", "pillar_cave_flintless", "pillar_cave_flintless", "idle"),
MakePlacer("sap_pillar_rock_placer", "pillar_cave_rock", "pillar_cave_rock", "idle"),
MakePlacer("sap_pillar_stalactite_placer", "pillar_stalactite", "pillar_stalactite", "idle"),
MakePlacer("sap_pillar_archive_placer", "pillar_archive", "pillar_archive", "idle"),
MakePlacer("sap_pillar_archive_broken_placer", "pillar_archive_broken", "pillar_archive_broken", "idle"),
MakePlacer("sap_pillar_moon1_placer", "moonglass_bigwaterfall", "moonglass_bigwaterfall", "stalactite1"),
MakePlacer("sap_pillar_moon2_placer", "moonglass_bigwaterfall", "moonglass_bigwaterfall", "stalactite2"),
MakePlacer("sap_pillar_moon3_placer", "moonglass_bigwaterfall", "moonglass_bigwaterfall", "stalactite3")
