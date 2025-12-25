require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_beefalo_vomit.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
    "phlegm",
}

local function DigUp(inst, chopper)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("kyno_beefalo_vomit")
    inst.AnimState:SetBuild("kyno_beefalo_vomit")
    inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "PHLEGM"
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(DigUp)
	inst.components.workable:SetWorkLeft(1)

    MakeSmallBurnable(inst, TUNING.SMALL_FUEL)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)

    return inst
end

return Prefab("kyno_beefalo_vomit", fn, assets, prefabs),
MakePlacer("kyno_beefalo_vomit_placer", "kyno_beefalo_vomit", "kyno_beefalo_vomit", "idle")