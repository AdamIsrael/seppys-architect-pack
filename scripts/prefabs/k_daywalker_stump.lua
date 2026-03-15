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

local function OnWork(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PlayAnimation("pillar_stump")
        inst.AnimState:PushAnimation("pillar_stump")
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PlayAnimation("pillar_stump")
        inst.AnimState:PushAnimation("pillar_stump")
    else
        inst.AnimState:PlayAnimation("pillar_stump")
        inst.AnimState:PushAnimation("pillar_stump")
    end
end

local function OnBuilt(inst)
	inst.AnimState:PushAnimation("pillar_stump")
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
	inst.AnimState:PlayAnimation("pillar_stump", true)
	
	inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("DAYWALKER_PILLAR")

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverrie = "DAYWALKER_PILLAR"
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

	return inst
end

return Prefab("sap_daywalker_stump", fn, assets, prefabs),
MakePlacer("sap_daywalker_stump_placer", "daywalker_pillar", "daywalker_pillar", "pillar_stump")