require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/lavaarena_floorgrate.zip"),  
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"collapse_small"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:PushAnimation("idle", true)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local s = .75
	inst.AnimState:SetScale(s, s, s)
	
	inst.AnimState:SetBank("lavaarena_floorgrate")
	inst.AnimState:SetBuild("lavaarena_floorgrate")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)   
	
	inst:AddTag("structure")
	inst:AddTag("lavahole")
	inst:AddTag("notarget")
	
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
	inst.components.workable:SetWorkLeft(3)
   
	inst:AddComponent("savedrotation")
   
	return inst
end

local function lavaholeplacetestfn(inst)
	local st = .75
	inst.AnimState:SetScale(st, st, st)
end

return Prefab("sap_lavahole", fn, assets, prefabs),
MakePlacer("sap_lavahole_placer", "lavaarena_floorgrate", "lavaarena_floorgrate", "idle", true, nil, nil, nil, 90, nil, lavaholeplacetestfn)
