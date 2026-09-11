require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/woodlegs_cage.zip"),
	Asset("ANIM", "anim/woodlegs.zip"),
}

local prefabs =
{
	"collapse_big"
}

local function onhammered(inst, worker)
	if inst:HasTag("fire") and not inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle_swing", true)
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle_swing", true)
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_woodlegscage.tex")
    minimap:SetPriority(5)

    inst.AnimState:SetBank("woodlegs_cage")
    inst.AnimState:SetBuild("woodlegs_cage")
    inst.AnimState:PlayAnimation("idle_swing", true)
	
	inst.AnimState:AddOverrideBuild("woodlegs")
	
	MakeObstaclePhysics(inst, 1.1)
	
	inst:AddTag("structure")
	inst:AddTag("cage")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	inst:ListenForEvent("onbuilt", onbuilt)

	inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end

return Prefab("sap_woodlegs_cage", fn, assets, prefabs),
MakePlacer("sap_woodlegs_cage_placer", "woodlegs_cage", "woodlegs_cage", "idle_swing")
