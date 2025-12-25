require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/winona_catapult.zip"),
	Asset("ANIM", "anim/winona_catapult_damage3.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/together/catapult/destroy")
	inst:Remove()
end

local function OnWork(inst, worker)
	inst.AnimState:PlayAnimation("hit_off")
	inst.AnimState:PushAnimation("idle_off")
	inst.SoundEmitter:PlaySound("dontstarve/common/together/catapult/hit")
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle_off")
	inst.SoundEmitter:PlaySound("dontstarve/common/together/catapult/place")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Transform:SetSixFaced()
	
    MakeObstaclePhysics(inst, .5)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("winona_catapult.png")
	
    inst.AnimState:SetBank("winona_catapult")
    inst.AnimState:SetBuild("winona_catapult_damage3")
    inst.AnimState:PlayAnimation("idle_off")
    
	inst:AddTag("structure")
	inst:AddTag("broken_catapult")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "WINONA_CATAPULT"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("kyno_catapult_broken", fn, assets),
MakePlacer("kyno_catapult_broken_placer", "winona_catapult", "winona_catapult_damage3", "idle_off_nodir")