require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/thunderbird_nest.zip"),
	Asset("ANIM", "anim/thunderbird.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"sap_thunderbird",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("nest")
	inst.AnimState:PushAnimation("nest", false)
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("nest")
	inst.AnimState:PushAnimation("nest", false)
end	

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_thundernest.tex")
	
	inst.AnimState:SetBank("thunderbird_nest")
	inst.AnimState:SetBuild("thunderbird_nest")
	inst.AnimState:PlayAnimation("nest", false)
	inst.AnimState:SetFinalOffset(2)
	
	inst:AddTag("structure")
	inst:AddTag("thundernest")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createBird(inst)
	inst.birdprefab = SpawnPrefab("sap_thunderbird")
	inst.birdprefab.entity:SetParent(inst.entity)
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
   
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst:DoTaskInTime(FRAMES * 1, createBird)

	return inst
end

local function birdfn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
    
    inst.AnimState:SetBank("thunderbird")
    inst.AnimState:SetBuild("thunderbird")
    inst.AnimState:PlayAnimation("CCW", true)
	inst.AnimState:SetFinalOffset(3)
	
    inst.persists = false
	
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
    return inst
end

return Prefab("sap_thundernest", fn, assets, prefabs),
Prefab("sap_thunderbird", birdfn, assets, prefabs),
MakePlacer("sap_thundernest_placer", "thunderbird_nest", "thunderbird_nest", "orenest")