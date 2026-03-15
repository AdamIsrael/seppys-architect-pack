require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/stagehand.zip"),
	
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

local function DoPeek(inst)
if inst:HasTag("contrarregra") then
	inst:DoTaskInTime(4+math.random()*5, function() DoPeek(inst) end)
		if math.random()<0.5 then
			inst.AnimState:PlayAnimation("peeking_idle_loop_01")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stagehand/footstep")
		else
			inst.AnimState:PlayAnimation("extinguish")
			inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stagehand/hit")
		end
		inst.AnimState:PushAnimation("idle_loop_01", true)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("stagehand")
    inst.AnimState:SetBuild("stagehand")
    inst.AnimState:PlayAnimation("idle_loop_01", true)
    
	inst:AddTag("structure")
	inst:AddTag("contrarregra")

	MakeSnowCoveredPristine(inst)
	
	inst:SetPrefabNameOverride("stagehand")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(6)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
    MakeSnowCovered(inst)
	
	DoPeek(inst)
	
    return inst
end

return Prefab("sap_contrarregra", fn, assets, prefabs),
MakePlacer("sap_contrarregra_placer", "stagehand", "stagehand", "idle")
