require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/barrel.zip"),
	Asset("ANIM", "anim/boat_containoar.zip"),
}

local prefabs =
{
	"collapse_small"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function onbuilt2(inst)
	inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function onhit(inst)
	inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

local function OnBurnt(inst)
	inst:DoTaskInTime(0.5, function() if inst.components.burnable then inst.components.burnable:Extinguish() end
		inst:RemoveComponent("burnable")
		inst:RemoveComponent("propagator")
	
		inst.components.lootdropper:SetLoot({"charcoal"})
			
		if inst.components.workable then
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnFinishCallback(onhammered)
		end
	end)
    
	inst.AnimState:PlayAnimation("burnt", true)
    inst.AnimState:SetRayTestOnBB(true)
	
    inst:AddTag("burnt")
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.burnt then
		OnBurnt(inst)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
	
    inst.AnimState:SetBank("barrel_01")
    inst.AnimState:SetBuild("barrel")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	
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
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
    return inst
end

local function twofn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
	
    inst.AnimState:SetBank("containoar")
    inst.AnimState:SetBuild("boat_containoar")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeLargeBurnable(inst)
    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:SetOnBurntFn(OnBurnt)
    MakeLargePropagator(inst)

	inst.OnSave = onsave
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt2)
	
    return inst
end

local function barrelplacer(inst)
	inst.AnimState:SetScale(1.2, 1.2, 1.2)
end

local function barrelplacer2(inst)
	inst.AnimState:SetScale(1.4, 1.4, 1.4)
end

return Prefab("sap_boatbarrel", fn, assets, prefabs),
Prefab("sap_boatbarrel2", twofn, assets, prefabs),
MakePlacer("sap_boatbarrel_placer", "barrel_01", "barrel", "idle", false, nil, nil, nil, nil, nil, barrelplacer),
MakePlacer("sap_boatbarrel2_placer", "containoar", "boat_containoar", "idle", false, nil, nil, nil, nil, nil, barrelplacer2)
