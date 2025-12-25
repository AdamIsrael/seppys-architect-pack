require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/roc_nest.zip"),  
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("nest_decal")
	inst.AnimState:PushAnimation("nest_decal")
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("nest_decal")
	inst.AnimState:PushAnimation("nest_decal")
end	

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("roc_nest")
	inst.AnimState:SetBuild("roc_nest")
	inst.AnimState:PlayAnimation("nest_decal")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)   
	
	inst:AddTag("structure")
	inst:AddTag("BFB_nest")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
   
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("kyno_rocnest", fn, assets),
MakePlacer("kyno_rocnest_placer", "roc_nest", "roc_nest", "nest_decal", true)