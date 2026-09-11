require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/vault_runes.zip"),
	
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
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("vault_rune.png")
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("vault_runes")
    inst.AnimState:SetBuild("vault_runes")
    inst.AnimState:PlayAnimation("idle1")
    
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("vault_rune")
	
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
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("vault_rune.png")
	
    MakeObstaclePhysics(inst, .5)
	
    inst.AnimState:SetBank("vault_runes")
    inst.AnimState:SetBuild("vault_runes")
    inst.AnimState:PlayAnimation("idle2")
    
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("vault_rune")
	
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

return Prefab("sap_vault_rune1", fn1, assets),
Prefab("sap_vault_rune2", fn2, assets),
MakePlacer("sap_vault_rune1_placer", "vault_runes", "vault_runes", "idle1"),
MakePlacer("sap_vault_rune2_placer", "vault_runes", "vault_runes", "idle2")