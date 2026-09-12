require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_altar.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle_empty")
    inst.AnimState:PushAnimation("idle_empty")
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle_empty")
end

local function onturnoff(inst)
	inst.components.prototyper.on = false
end

local function onturnon(inst)
	inst.components.prototyper.on = true
end

local function Gnawfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_gnawaltar.tex")
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("quagmire_altar")
    inst.AnimState:SetBuild("quagmire_altar")
    inst.AnimState:PlayAnimation("idle_empty")
    
	inst:AddTag("structure")
	inst:AddTag("gnawaltar")
	-- inst:AddTag("prototyper")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_ALTAR"
	
	-- inst:AddComponent("prototyper")
	-- inst.components.prototyper.onturnon = onturnon
	-- inst.components.prototyper.onturnoff = onturnoff
	-- inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.TAPGORGE_TWO
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_gorge_prototyper", Gnawfn, assets),
MakePlacer("sap_gorge_prototyper_placer", "quagmire_altar", "quagmire_altar", "idle_empty")