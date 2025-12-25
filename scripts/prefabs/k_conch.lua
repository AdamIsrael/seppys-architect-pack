require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/conch.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"slurtle_shellpieces",
}

local function onpickedfn(inst, picker)
	if picker and picker.components.sanity then
		picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
	end	
	inst:Remove() 
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("conch")
    inst.AnimState:SetBuild("conch")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cattoy")
	inst:AddTag("howlingconch")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SEASHELL"
	
	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("slurtle_shellpieces")
	inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = false
	
	return inst
end

return Prefab("kyno_conch", fn, assets, prefabs),
MakePlacer("kyno_conch_placer", "conch", "conch", "idle")