require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/workbench_obsidian.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"collapse_big"
}

local function turnlightoff(inst, light)
    if light then
        light:Enable(false)
    end
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("proximity_loop", true)
	inst.AnimState:PushAnimation("proximity_loop", true)
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("proximity_pre")
	inst.AnimState:PushAnimation("proximity_loop", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetPriority(5)
	minimap:SetIcon("kyno_obsidian_workbench.tex")
	
	inst.AnimState:SetBank("workbench_obsidian")
	inst.AnimState:SetBuild("workbench_obsidian")
	inst.AnimState:PlayAnimation("proximity_loop", true)
	
	MakeObstaclePhysics(inst, 2, 1.2)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lighttweener")
    local light = inst.entity:AddLight()

    inst.Light:Enable(true)
    inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(.5)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(1,1,1)
    inst.components.lighttweener:StartTween(light, 1, .9, 0.9, {255/255,177/255,164/255}, 0, turnlightoff)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("sap_workbench", fn, assets, prefabs),
MakePlacer("sap_workbench_placer", "workbench_obsidian", "workbench_obsidian", "idle")  
