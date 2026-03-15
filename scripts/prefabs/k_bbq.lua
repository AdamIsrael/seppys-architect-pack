require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_bbq.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst.SoundEmitter:KillSound("burning")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle", true)
end

local function FireSound(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/campfire", "burning")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	-- inst.AnimState:SetScale(.60, .60, .60)
	
	inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(0.6)
    inst.Light:SetRadius(4)
    inst.Light:Enable(true)
    inst.Light:SetColour(197/255, 197/255, 10/255)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("firepit.png")
	
    MakeObstaclePhysics(inst, .3)
	MakeSnowCoveredPristine(inst)
	
    inst.AnimState:SetBank("kyno_bbq")
    inst.AnimState:SetBuild("kyno_bbq")
    inst.AnimState:PlayAnimation("idle", true)
    
	inst:AddTag("structure")
	inst:AddTag("bbq")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	inst:AddComponent("cooker")
	
	inst:AddComponent("heater")
    inst.components.heater.heat = 80
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)
	
	FireSound(inst)
	
    return inst
end

local function bbqplacetestfn(inst)
	inst.AnimState:SetScale(.60, .60, .60)
end

return Prefab("sap_bbq", fn, assets),
MakePlacer("sap_bbq_placer", "kyno_bbq", "kyno_bbq", "idle")