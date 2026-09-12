require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/seashell.zip"),
}

local prefabs =
{
	"seashell",
}

local function onpickedfn(inst, picker)
	if picker and picker.components.sanity then
		picker.components.sanity:DoDelta(TUNING.SANITY_TINY)
	end	
	inst:Remove() 
end

local function onsave(inst, data)
	data.anim = inst.animname
end

local function onload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
	    inst.AnimState:PlayAnimation(inst.animname)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("seashell")
    inst.AnimState:SetBuild("seashell")
    inst.AnimState:PlayAnimation("buried")

    inst:AddTag("cattoy")
	inst:AddTag("seashell")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("pickable")
	inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("seashell")
	inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.quickpick = true
	
	inst.OnSave = onsave
    inst.OnLoad = onload
	
	return inst
end

return Prefab("sap_seashell_buried", fn, assets, prefabs)