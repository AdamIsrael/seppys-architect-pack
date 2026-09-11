require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/inspectaclesbox.zip"),
	Asset("ANIM", "anim/inspectaclesbox2_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"collapse_small",
}

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function common(variant, broken)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(.9)
	inst.Light:SetIntensity(.5)
	inst.Light:SetRadius(.9)
	inst.Light:SetColour(0/255, 180/255, 255/255)
	inst.Light:Enable(true)
	
	MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("inspectaclesbox")
	
	if variant then
		inst.AnimState:SetBuild("inspectaclesbox2_build")
	else
		inst.AnimState:SetBuild("inspectaclesbox")
	end
	
	if broken then
		inst.AnimState:PlayAnimation("idle_broken_loop", true)
	else	
		inst.AnimState:PlayAnimation("idle_fixed_loop", true)
	end
    
	inst:AddTag("structure")
	
	if variant then
		inst:SetPrefabNameOverride("INSPECTACLESBOX2")
	else
		inst:SetPrefabNameOverride("INSPECTACLESBOX")
	end
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("meta4/wires_minigame/hologram_idle_lp", "hololoop")
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	if variant then 
		inst.components.inspectable.nameoverride = "INSPECTACLESBOX2"
	else
		inst.components.inspectable.nameoverride = "INSPECTACLESBOX"
	end
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function box1() -- Variant 1 - Full
    local inst = common(false, false)
    return inst
end

local function box2() -- Variant 1 - Broken
    local inst = common(false, true)
    return inst
end

local function box3() -- Variant 2 - Full
    local inst = common(true, false)
    return inst
end

local function box4() -- Variant 2 - Broken
    local inst = common(true, true)
    return inst
end

return Prefab("sap_cachebox1_full", box1, assets, prefabs),
Prefab("sap_cachebox1_broken", box2, assets, prefabs),
Prefab("sap_cachebox2_full", box3, assets, prefabs),
Prefab("sap_cachebox2_broken", box4, assets, prefabs),
MakePlacer("sap_cachebox1_full_placer", "inspectaclesbox", "inspectaclesbox", "idle_fixed_loop"),
MakePlacer("sap_cachebox1_broken_placer", "inspectaclesbox", "inspectaclesbox", "idle_broken_loop"),
MakePlacer("sap_cachebox2_full_placer", "inspectaclesbox", "inspectaclesbox2_build", "idle_fixed_loop"),
MakePlacer("sap_cachebox2_broken_placer", "inspectaclesbox", "inspectaclesbox2_build", "idle_broken_loop")