require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/abyss_pillar_minion.zip"),
	Asset("ANIM", "anim/abyss_pillar_minion_broken_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()

	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function fn1()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("abyss_pillar_minion")
    inst.AnimState:SetBuild("abyss_pillar_minion")
    inst.AnimState:PlayAnimation("idle_off")
    
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("abysspillar_minion")
	
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

local function fn2()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("abyss_pillar_minion")
    inst.AnimState:SetBuild("abyss_pillar_minion")
    inst.AnimState:PlayAnimation("broken")
    
	inst:AddTag("structure")
	inst:AddTag("rotatableobject")
	
	inst:SetPrefabNameOverride("abysspillar_minion")
	
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

return Prefab("sap_vault_minion1", fn1, assets),
Prefab("sap_vault_minion2", fn2, assets),
MakePlacer("sap_vault_minion1_placer", "abyss_pillar_minion", "abyss_pillar_minion", "idle_off"),
MakePlacer("sap_vault_minion2_placer", "abyss_pillar_minion", "abyss_pillar_minion", "broken")