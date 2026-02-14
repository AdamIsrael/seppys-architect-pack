require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/moonstorm_groundlight.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs = {}

local function dig_up(inst, chopper)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("moonstorm_groundlight")
	inst.AnimState:SetBuild("moonstorm_groundlight")
	inst.AnimState:PlayAnimation("strike", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("NOBLOCK")
	inst:AddTag("storm_that_is_approaching")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

local function fn2()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("moonstorm_groundlight")
	inst.AnimState:SetBuild("moonstorm_groundlight")
	inst.AnimState:PlayAnimation("strike2", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("NOBLOCK")
	inst:AddTag("storm_that_is_approaching")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

return Prefab("kyno_moonstorm_lightning", fn, assets, prefabs),
Prefab("kyno_moonstorm_lightning2", fn2, assets, prefabs),
MakePlacer("kyno_moonstorm_lightning_placer", "moonstorm_groundlight", "moonstorm_groundlight", "strike", true, nil, nil, nil, 90, nil),
MakePlacer("kyno_moonstorm_lightning2_placer", "moonstorm_groundlight", "moonstorm_groundlight", "strike2", true, nil, nil, nil, 90, nil)