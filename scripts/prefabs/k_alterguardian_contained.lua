require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/alterguardian_contained.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PlayAnimation("collect")
	inst.SoundEmitter:PlaySound("moonstorm/common/alterguardian_contained/collect")
	inst.AnimState:PushAnimation("close_idle", false)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_contained.tex")
	
    inst.AnimState:SetBank("alterguardian_contained")
    inst.AnimState:SetBuild("alterguardian_contained")
    inst.AnimState:PlayAnimation("close_idle", false)
    
	inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("moonstorm/common/alterguardian_contained/close")
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ALTERGUARDIAN_CONTAINED"
	
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

return Prefab("sap_lunarextractor", fn, assets),
MakePlacer("sap_lunarextractor_placer", "alterguardian_contained", "alterguardian_contained", "idle")