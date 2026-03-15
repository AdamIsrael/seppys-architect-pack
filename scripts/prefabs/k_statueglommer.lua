local assets =
{
    Asset("ANIM", "anim/glommer_statue.zip"),
    Asset("ANIM", "anim/glommer_swap_flower.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "marble",
}

local function OnMakeEmpty(inst)
    inst.AnimState:ClearOverrideSymbol("swap_flower")
    inst.AnimState:Hide("swap_flower")
end

local function OnMakeFull(inst)
    inst.AnimState:OverrideSymbol("swap_flower", "glommer_swap_flower", "swap_flower")
    inst.AnimState:Show("swap_flower")
end

local function OnIsFullmoon(inst, isfullmoon)
    if not isfullmoon then
        OnMakeEmpty(inst)
		inst.Light:Enable(false)
    else
        OnMakeFull(inst)
		inst.Light:Enable(true)
    end
end

local function OnInit(inst)
    inst:WatchWorldState("isfullmoon", OnIsFullmoon)
    OnIsFullmoon(inst, TheWorld.state.isfullmoon)
end

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("low", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("med", true)
	else
		inst.AnimState:PlayAnimation("full", true)
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("full")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Light:SetRadius(1)
    inst.Light:SetIntensity(.9)
    inst.Light:SetFalloff(0.3)
    inst.Light:SetColour(180 / 255, 195 / 255, 150 / 255)
    inst.Light:Enable(false)

    MakeObstaclePhysics(inst, .75)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("statueglommer.png")
    minimap:SetPriority(5)

    inst.AnimState:SetBank("glommer_statue")
    inst.AnimState:SetBuild("glommer_statue")
    inst.AnimState:PlayAnimation("full")

	inst:AddTag("structure")
	inst:AddTag("glommer_statue")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "STATUEGLOMMER"
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:DoTaskInTime(0, OnInit)

    return inst
end

return Prefab("sap_statueglommer", fn, assets, prefabs),
MakePlacer("sap_statueglommer_placer", "glommer_statue", "glommer_statue", "full")