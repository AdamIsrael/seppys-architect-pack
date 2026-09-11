require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/ant_honey_cache.zip"),
}

local prefabs =
{
	"collapse_small"
}

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
	inst.components.lootdropper:DropLoot()
	if inst.components.container then inst.components.container:DropEverything() end
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst.SoundEmitter:KillSound("loop")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("full_hit")
		inst.AnimState:PushAnimation("full_hit", true)
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("full")
	inst.AnimState:PushAnimation("full", true)
	inst.SoundEmitter:PlaySound("dontstarve/bee/bee_hive_LP", "loop")
end	

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end
end

local function onload(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
	end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_antcache.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(true)
    inst.Light:SetColour(185/255, 185/255, 20/255)
    inst.lightson = true
	
	inst.AnimState:SetBank("honey_cache")
	inst.AnimState:SetBuild("ant_honey_cache")
	inst.AnimState:PlayAnimation("full", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("antcache")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	-- MakeMediumBurnable(inst, nil, nil, true)
    -- MakeLargePropagator(inst)
   
	MakeSnowCovered(inst, 0.01)
   
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

return Prefab("sap_antcache", fn, assets, prefabs),
MakePlacer("sap_antcache_placer", "honey_cache", "ant_honey_cache", "full")
