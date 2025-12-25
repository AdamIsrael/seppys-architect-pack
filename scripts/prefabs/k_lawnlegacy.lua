require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_lawnlegacy.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
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
	
    MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetScale(.4, .4, .4)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_lawnlegacy.tex")
	
    inst.AnimState:SetBank("kyno_lawnlegacy")
    inst.AnimState:SetBuild("kyno_lawnlegacy")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("lawnlegacy")
	
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

local function lawnplacer(inst)
	inst.AnimState:SetScale(.4, .4, .4)
end

return Prefab("kyno_lawnlegacy", fn, assets),
MakePlacer("kyno_lawnlegacy_placer", "kyno_lawnlegacy", "kyno_lawnlegacy", "idle", false, nil, nil, nil, nil, nil, lawnplacer)