require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/toadstool_actions.zip"),
    Asset("ANIM", "anim/toadstool_build.zip"),
    Asset("ANIM", "anim/toadstool_dark_build.zip"),
}

local prefabs = {}

local function onworked(inst, chopper, workleft)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")          
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_mushroom")          
	end
	inst.AnimState:PlayAnimation("mushroom_toad_hit")
end

local function onworkfinish(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local hispos = Vector3(chopper.Transform:GetWorldPosition())
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
    if he_right then
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end
	inst:Remove()
end

local function onbuilt(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/mushroom_up")
    inst.AnimState:PlayAnimation("spawn_appear_mushroom")
	inst.AnimState:PushAnimation("mushroom_toad_idle_loop")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)
	inst.Transform:SetSixFaced()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("toadstool_cap.png")

	inst.AnimState:SetBank("toadstool")
	inst.AnimState:SetBuild("toadstool_build")
	inst.AnimState:PlayAnimation("mushroom_toad_idle_loop", true)
	
	inst:AddTag("plant")
	inst:AddTag("tree")
	inst:AddTag("giant_mushroom")
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("toadstool_cap")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(5)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetOnFinishCallback(onworkfinish)

	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function darkfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .5)
	inst.Transform:SetSixFaced()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("toadstool_cap_dark.png")

	inst.AnimState:SetBank("toadstool")
	inst.AnimState:SetBuild("toadstool_dark_build")
	inst.AnimState:PlayAnimation("mushroom_toad_idle_loop", true)
	
	inst:AddTag("plant")
	inst:AddTag("tree")
	inst:AddTag("giant_mushroom")
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("toadstool_cap")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(5)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetOnFinishCallback(onworkfinish)

	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("sap_toadstoolcap", fn, assets, prefabs),
Prefab("sap_toadstoolcap_dark", darkfn, assets, prefabs),
MakePlacer("sap_toadstoolcap_placer", "toadstool", "toadstool_build", "mushroom_toad_idle_loop"),
MakePlacer("sap_toadstoolcap_dark_placer", "toadstool", "toadstool_dark_build", "mushroom_toad_idle_loop")
