require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/volcano_entrance.zip"),
	
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

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	inst.Light:Enable(true)
	inst.Light:SetIntensity(.75)
	inst.Light:SetColour(197/255,197/255,50/255)
	inst.Light:SetFalloff(0.5)
	inst.Light:SetRadius(1)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_volcanoexit.tex")
	
	inst.AnimState:SetBank("volcano_entrance")
	inst.AnimState:SetBuild("volcano_entrance")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("volcano_stairs")
	
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
	inst.components.workable:SetWorkLeft(4)

	return inst
end

return Prefab("sap_volcanostairs", fn, assets, prefabs),
MakePlacer("sap_volcanostairs_placer", "volcano_entrance", "volcano_entrance", "idle")
