require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_signhome.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle_old")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .2)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("sign.png")
	
    inst.AnimState:SetBank("kyno_signhome")
    inst.AnimState:SetBuild("kyno_signhome")
    inst.AnimState:PlayAnimation("idle_old", false)
    
	inst:AddTag("structure")
	inst:AddTag("signold")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "HOMESIGN"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	MakeSmallBurnable(inst, nil, nil, true)
    MakeSmallPropagator(inst)
	
    return inst
end

return Prefab("kyno_homesign_old", fn, assets),
MakePlacer("kyno_homesign_old_placer", "kyno_signhome", "kyno_signhome", "idle_old")