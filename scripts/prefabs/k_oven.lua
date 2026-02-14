require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_oven.zip"),
	Asset("ANIM", "anim/quagmire_oven_fire.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"collapse_small",
	"kyno_firepit",
	"kyno_oven_back"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_oven.tex")
	
    MakeObstaclePhysics(inst, .3)
	
    inst.AnimState:SetBank("quagmire_oven")
    inst.AnimState:SetBuild("quagmire_oven")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(3)
	inst.AnimState:Hide("goop_small")
    inst.AnimState:Show("oven_back")

	inst:AddTag("structure")
	inst:AddTag("kyno_oven")
	inst:AddTag("cooker")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	--[[
	local function createBack(inst)
	inst.backprefab =  SpawnPrefab("kyno_oven_back")
	inst.firepitprefab = SpawnPrefab("kyno_firepit")
	inst.backprefab.entity:SetParent(inst.entity)
	inst.firepitprefab.entity:SetParent(inst.entity)
	end
	]]--
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_OVEN"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
	-- inst:DoTaskInTime(FRAMES * 1, createBack)
	
    return inst
end

local function backfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetBank("quagmire_oven")
    inst.AnimState:SetBuild("quagmire_oven")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(0)
	inst.AnimState:Show("oven_back")
	inst.AnimState:Hide("goop_small")
	inst.AnimState:Hide("goop")
	inst.AnimState:Hide("oven")

	inst:AddTag("structure")
	inst:AddTag("kyno_oven_back")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	return inst
end

local function ovenplacetestfn(inst)
	inst.AnimState:Hide("steam")
    inst.AnimState:Hide("smoke")
    inst.AnimState:Hide("oven")
    inst.AnimState:Hide("goop")
    inst.AnimState:Hide("goop_small")
	inst.AnimState:Show("oven")
	inst.AnimState:Show("oven_back")
end

return Prefab("kyno_oven", fn, assets, prefabs),
Prefab("kyno_oven_back", backfn, assets, prefabs),
MakePlacer("kyno_oven_placer", "quagmire_oven", "quagmire_oven", "idle", false, nil, nil, nil, nil, nil, ovenplacetestfn)