require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_birdbath.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_birdfountain.tex")
	
    MakeObstaclePhysics(inst, .2)
	
    inst.AnimState:SetBank("quagmire_birdbath")
    inst.AnimState:SetBuild("quagmire_birdbath")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("birdfountain")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_PARK_FOUNTAIN"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)
	
    return inst
end

return Prefab("sap_birdfountain", fn, assets),
MakePlacer("sap_birdfountain_placer", "quagmire_birdbath", "quagmire_birdbath", "idle")