require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/bermudatriangle.zip"),
	Asset("ANIM", "anim/teleporter_worm.zip"),
	Asset("ANIM", "anim/teleporter_worm_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"collapse_big"
}

local function onfar(inst) 
	inst.AnimState:PlayAnimation("open_pst")
	inst.AnimState:PushAnimation("idle_loop", true)
end

local function onnear(inst) 
    inst.AnimState:PlayAnimation("open_pre")
	inst.AnimState:PushAnimation("open_loop", true)
end

local function onhammered(inst, worker)
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("stone")
    inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("idle_loop", true)
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle_loop", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetScale(1.2, 1.2, 1.2)
	inst.Transform:SetRotation(45)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_bermudatriangle.tex")
	
	inst.AnimState:SetBank("bermudatriangle")
	inst.AnimState:SetBuild("bermudatriangle")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("structure")
	inst:AddTag("bermudatriangle")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(2)
	
    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(2, 5)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("savedrotation")
	
    inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("kyno_bermudatriangle", fn, assets, prefabs),
MakePlacer("kyno_bermudatriangle_placer", "bermudatriangle", "bermudatriangle", "idle_loop", true, nil, nil, nil, 90, nil)