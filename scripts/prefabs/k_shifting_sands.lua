require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/crabbit.zip"),
	Asset("ANIM", "anim/crabbit_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"sand_puff"
}

local function dig_up_full(inst, chopper)
	SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("crabbit")
    inst.AnimState:SetBuild("crabbit_build")
    inst.AnimState:PlayAnimation("hide_idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("sand")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_full)
	inst.components.workable:SetWorkLeft(1)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    return inst
end

return Prefab("kyno_shiftingsands", fn, assets, prefabs),
MakePlacer("kyno_shiftingsands_placer", "crabbit", "crabbit_build", "hide_idle")