require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/dragoon_den.zip"),
	Asset("ANIM", "anim/dragoon_build.zip"),
	Asset("ANIM", "anim/dragoon_actions.zip"),
	Asset("ANIM", "anim/dragoon_basic.zip"),
}

local prefabs =
{
	"sap_dragoon",
}

local function ongohome(inst, child)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
end

local function StartSpawningFn(inst)
	if inst.components.childspawner then
		inst.components.childspawner:StartSpawning()
	end
end

local function StopSpawningFn(inst)
	if inst.components.childspawner then
		inst.components.childspawner:StopSpawning()
	end
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/dragoon_den_place")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_dragoonden.tex")
	
	inst.AnimState:SetBank("dragoon_den")
	inst.AnimState:SetBuild("dragoon_den")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1.5)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("childspawner")
	inst.components.childspawner:SetRegenPeriod(120)
	inst.components.childspawner:SetSpawnPeriod(30)
	inst.components.childspawner:SetMaxChildren(math.random(3,4))
	inst.components.childspawner:StartRegen()
	inst.components.childspawner.childname = "sap_dragoon"
	inst.components.childspawner:StartSpawning()
	inst.components.childspawner.ongohome = ongohome
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)

	inst:AddComponent("savedrotation")
	
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("sap_dragoonden", fn, assets, prefabs),
MakePlacer("sap_dragoonden_placer", "dragoon_den", "dragoon_den", "idle", false, nil, nil, nil, 90, nil)