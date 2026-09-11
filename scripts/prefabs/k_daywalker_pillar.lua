require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/daywalker_pillar.zip"),
	Asset("ANIM", "anim/daywalker_hole.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"marble",
	"daywalker_pillar_base_fx",
	"daywalker_pillar_hole",
	"shadow_despawn",
}

local function FadeOutHole(inst)
	inst.hole.Transform:SetPosition(inst.hole.Transform:GetWorldPosition())
	inst.hole.entity:SetParent(nil)
	
	inst.hole.AnimState:PlayAnimation("fadeout")
	inst.hole:ListenForEvent("animover", inst.hole.Remove)
end

local function ShakePillarFall(inst)
	ShakeAllCameras(CAMERASHAKE.VERTICAL, .5, .025, .15, inst, 16)
end

local function OnWorkFinished(inst, worker)
	if inst.persists then
		inst.persists = false
		inst.components.lootdropper:DropLoot(inst:GetPosition())

		inst.base:Remove()
		inst.AnimState:PlayAnimation("pillar_fall")
		inst.SoundEmitter:PlaySound("daywalker/pillar/destroy")
		
		
		inst:DoTaskInTime(22 * FRAMES, ShakePillarFall)
		inst:ListenForEvent("animover", inst.Remove)
		inst:AddTag("NOCLICK")
	end
end

local function OnWork(inst, worker, workleft)
    if workleft < TUNING.DAYWALKER_PILLAR_MINE / 3 then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
		inst.AnimState:OverrideSymbol("pillar_full", "daywalker_pillar", "pillar_lowest")
		inst.base.AnimState:OverrideSymbol("pillar_full", "daywalker_pillar", "pillar_lowest_base")
    elseif workleft < TUNING.DAYWALKER_PILLAR_MINE * 2 / 3 then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
		inst.AnimState:OverrideSymbol("pillar_full", "daywalker_pillar", "pillar_low")
		inst.base.AnimState:OverrideSymbol("pillar_full", "daywalker_pillar", "pillar_low_base")
    else
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
		inst.AnimState:OverrideSymbol("pillar_full", "daywalker_pillar", "pillar_med")
		inst.base.AnimState:OverrideSymbol("pillar_full", "daywalker_pillar", "pillar_med_base")
    end
end

local function OnBuilt(inst)
	inst.AnimState:PushAnimation("idle")
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("daywalker_pillar.png")
	minimap:SetPriority(4)

	MakeObstaclePhysics(inst, .95)
	inst.Physics:CollidesWith(COLLISION.OBSTACLES)

	inst.AnimState:SetBank("daywalker_pillar")
	inst.AnimState:SetBuild("daywalker_pillar")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetSymbolLightOverride("pillar_parts_red", 1)
	inst.AnimState:SetSymbolLightOverride("fx_vib_pink", 1)
	inst.AnimState:SetSymbolLightOverride("zap", 1)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("DAYWALKER_PILLAR")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	-- inst.hole = SpawnPrefab("daywalker_pillar_hole")
	-- inst.hole.entity:SetParent(inst.entity)

	inst.base = SpawnPrefab("daywalker_pillar_base_fx")
	inst.base.entity:SetParent(inst.entity)
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverrie = "DAYWALKER_PILLAR"
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.DAYWALKER_PILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable:SetOnFinishCallback(OnWorkFinished)
	inst.components.workable.savestate = true
	
	inst:ListenForEvent("onbuilt", OnBuilt)

	return inst
end

return Prefab("sap_daywalker_pillar", fn, assets, prefabs),
MakePlacer("sap_daywalker_pillar_placer", "daywalker_pillar", "daywalker_pillar", "idle")