require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quake_pillar.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"rock_break_fx"
}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("rock_idle")
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("rock_idle")
	else
		inst.AnimState:PlayAnimation("rock_idle")
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst.components.lootdropper:DropLoot(pt)
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("rock_in")
	inst.AnimState:PushAnimation("rock_idle")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("rock.png")
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("quake_pillar")
	inst.AnimState:SetBuild("quake_pillar")
	inst.AnimState:PlayAnimation("rock_idle")
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("kyno_quakepillar", fn, assets, prefabs),
MakePlacer("kyno_quakepillar_placer", "quake_pillar", "quake_pillar", "rock_idle")