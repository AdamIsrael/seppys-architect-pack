require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/ancient_husk.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function fn(anim)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("ancient_husk")
    inst.AnimState:SetBuild("ancient_husk")
    inst.AnimState:PlayAnimation(anim)
    
	inst:AddTag("structure")
	inst:AddTag("rotatableobject")
	
	inst:SetPrefabNameOverride("ancient_husk")
	
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
	
	MakeHauntableWork(inst)
	
    return inst
end

local function husk1()
	return fn("husk_architect")
end

local function husk2()
	return fn("husk_handmaid")
end

local function husk3()
	return fn("husk_mason")
end

return Prefab("kyno_vault_ancienthusk1", husk1, assets),
MakePlacer("kyno_vault_ancienthusk1_placer", "ancient_husk", "ancient_husk", "husk_architect"),

Prefab("kyno_vault_ancienthusk2", husk2, assets),
MakePlacer("kyno_vault_ancienthusk2_placer", "ancient_husk", "ancient_husk", "husk_handmaid"),

Prefab("kyno_vault_ancienthusk3", husk3, assets),
MakePlacer("kyno_vault_ancienthusk3_placer", "ancient_husk", "ancient_husk", "husk_mason")