require "prefabutil"

local assets = {
	Asset("ANIM", "anim/kyno_canopy_shadow.zip"),
}

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetScale(2.5, 2.5, 2.5)
	
	inst.AnimState:SetBank("kyno_canopy_shadow")
	inst.AnimState:SetBuild("kyno_canopy_shadow")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	-- inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetFinalOffset(3)
	
	inst:AddTag("NOCLICK")
	inst:AddTag("dryshelter")
	inst:AddTag("shelter")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("waterproofer")
	inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_LARGE)

	return inst
end

return Prefab("kyno_canopy_shadow", fn, assets)