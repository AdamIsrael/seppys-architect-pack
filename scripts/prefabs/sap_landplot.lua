require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/land_plot.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetScale(.8, .8, .8)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("sign.png")
	
    inst.AnimState:SetBank("landplot")
    inst.AnimState:SetBuild("land_plot")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("land_plot")
	
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
	
    return inst
end

local function landplacerfn(inst)
	inst.AnimState:SetScale(.8, .8, .8)
end

return Prefab("sap_landplot", fn, assets),
MakePlacer("sap_landplot_placer", "landplot", "land_plot", "idle", false, nil, nil, nil, nil, nil, landplacerfn)