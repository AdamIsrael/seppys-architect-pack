require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_grill.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/common/cook_pot_craft")
end

local function onnear(inst)
	inst.AnimState:PushAnimation("idle")
	--inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish")
end

local function onfar(inst)
	inst.AnimState:PushAnimation("idle")
	-- inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
end

local function largefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_grill.tex")
	
	MakeObstaclePhysics(inst, .3)
	
	inst.AnimState:SetBank("quagmire_grill")
	inst.AnimState:SetBuild("quagmire_grill")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(3)
	
	inst:AddTag("structure")
	inst:AddTag("churrasqueira_grande")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_GRILL"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(4, 6)
    inst.components.playerprox.onnear = onnear
    inst.components.playerprox.onfar = onfar

	return inst
end

return Prefab("kyno_grill_large", largefn, assets, prefabs),
MakePlacer("kyno_grill_large_placer", "quagmire_grill", "quagmire_grill", "idle")