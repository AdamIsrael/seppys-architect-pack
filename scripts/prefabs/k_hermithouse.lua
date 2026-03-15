require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/hermitcrab_home.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{

}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt1(inst)
    inst.AnimState:PushAnimation("idle_stage1", true)
end

local function onbuilt2(inst)
	inst.AnimState:PlayAnimation("stage2_placing")
    inst.AnimState:PushAnimation("idle_stage2", true)
end

local function onbuilt3(inst)
	inst.AnimState:PlayAnimation("stage3_placing")
    inst.AnimState:PushAnimation("idle_stage3", true)
end

local function onbuilt4(inst)
	inst.AnimState:PlayAnimation("stage4_placing")
    inst.AnimState:PushAnimation("idle_stage4", true)
end

local function dowind3(inst)
    if inst.AnimState:IsCurrentAnimation("idle_stage3") then
        inst.AnimState:PlayAnimation("idle_stage3_wind")
        inst.AnimState:PushAnimation("idle_stage3")
    end
    inst:DoTaskInTime(math.random()*5, function() dowind3(inst) end)
end

local function dowind4(inst)
    if inst.AnimState:IsCurrentAnimation("idle_stage4") then
        inst.AnimState:PlayAnimation("idle_stage4_wind")
        inst.AnimState:PushAnimation("idle_stage4")
    end
    inst:DoTaskInTime(math.random()*5, function() dowind4(inst) end)
end

local function stage1fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1.5)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("hermitcrab_home.png")
	
    inst.AnimState:SetBank("hermitcrab_home")
    inst.AnimState:SetBuild("hermitcrab_home")
    inst.AnimState:PlayAnimation("idle_stage1", true)
    
	inst:AddTag("structure")
	inst:AddTag("pearlhouse")
	
	inst:SetPrefabNameOverride("hermithouse")
	
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
	
	inst:ListenForEvent("onbuilt", onbuilt1)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function stage2fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1.5)
	
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetRadius(1)
	inst.Light:Enable(true)
	inst.Light:SetColour(180/255, 195/255, 50/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("hermitcrab_home2.png")
	
    inst.AnimState:SetBank("hermitcrab_home")
    inst.AnimState:SetBuild("hermitcrab_home")
    inst.AnimState:PlayAnimation("idle_stage2", true)
    
	inst:AddTag("structure")
	inst:AddTag("pearlhouse")
	
	inst:SetPrefabNameOverride("hermithouse")
	
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
	
	inst:ListenForEvent("onbuilt", onbuilt2)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function stage3fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1.5)
	
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetRadius(1)
	inst.Light:Enable(true)
	inst.Light:SetColour(180/255, 195/255, 50/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("hermitcrab_home2.png")
	
    inst.AnimState:SetBank("hermitcrab_home")
    inst.AnimState:SetBuild("hermitcrab_home")
    inst.AnimState:PlayAnimation("idle_stage3", true)
    
	inst:AddTag("structure")
	inst:AddTag("pearlhouse")
	
	inst:SetPrefabNameOverride("hermithouse")
	
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
	
	inst:ListenForEvent("onbuilt", onbuilt3)
	
	MakeHauntableWork(inst)
	
	inst:DoTaskInTime(math.random()*5, function() dowind3(inst) end)
	
    return inst
end

local function stage4fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1.5)
	
	inst.Light:SetFalloff(1)
	inst.Light:SetIntensity(.5)
	inst.Light:SetRadius(1)
	inst.Light:Enable(true)
	inst.Light:SetColour(180/255, 195/255, 50/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("hermitcrab_home2.png")
	
    inst.AnimState:SetBank("hermitcrab_home")
    inst.AnimState:SetBuild("hermitcrab_home")
    inst.AnimState:PlayAnimation("idle_stage4", true)
    
	inst:AddTag("structure")
	inst:AddTag("pearlhouse")
	
	-- inst:SetPrefabNameOverride("hermithouse_pearl")
	
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
	
	inst:ListenForEvent("onbuilt", onbuilt4)
	
	MakeHauntableWork(inst)
	
	inst:DoTaskInTime(math.random()*5, function() dowind4(inst) end)
	
    return inst
end

return Prefab("sap_hermithouse1", stage1fn, assets, prefabs),
Prefab("sap_hermithouse2", stage2fn, assets, prefabs),
Prefab("sap_hermithouse3", stage3fn, assets, prefabs),
Prefab("sap_hermithouse4", stage4fn, assets, prefabs),
MakePlacer("sap_hermithouse1_placer", "hermitcrab_home", "hermitcrab_home", "idle_stage1"),
MakePlacer("sap_hermithouse2_placer", "hermitcrab_home", "hermitcrab_home", "idle_stage2"),
MakePlacer("sap_hermithouse3_placer", "hermitcrab_home", "hermitcrab_home", "idle_stage3"),
MakePlacer("sap_hermithouse4_placer", "hermitcrab_home", "hermitcrab_home", "idle_stage4")