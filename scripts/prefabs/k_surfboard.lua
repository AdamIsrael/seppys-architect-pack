require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/surfboard.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_surfboard.tex")
	
    inst.AnimState:SetBank("surfboard")
    inst.AnimState:SetBuild("surfboard")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("surfboard")
	
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
	
	MakeHauntableWork(inst)
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
    return inst
end

return Prefab("sap_surfboard", fn, assets),
MakePlacer("sap_surfboard_placer", "surfboard", "surfboard", "idle")