require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_fog.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle", false)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetMultColour(1, 1, 1, .5)
	
    inst.AnimState:SetBank("kyno_fog")
    inst.AnimState:SetBuild("kyno_fog")
    inst.AnimState:PlayAnimation("idle", false)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
    
	inst:AddTag("structure")
	inst:AddTag("custom_fog")
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	inst:AddTag("notarget")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.NET)
    inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
    return inst
end

return Prefab("sap_fog", fn, assets),
MakePlacer("sap_fog_placer", "kyno_fog", "kyno_fog", "idle", true, nil, nil, nil, 90, nil)