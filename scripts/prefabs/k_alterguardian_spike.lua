require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/alterguardian_spike.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function spike_break(inst)
    inst.Physics:SetActive(false)

    inst.components.workable:SetWorkable(false)

    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("spike_pst")

    inst.SoundEmitter:PlaySound("turnoftides/common/together/moon_glass/break",nil,.25)
	inst.components.lootdropper:DropLoot()
end

local function on_spike_mining_finished(inst, worker)
    if inst._break_task ~= nil then
        inst._break_task:Cancel()
        inst._break_task = nil
    end

    spike_break(inst)
end

local SPIKE_WALL_RADIUS = 1.1

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_moonglass_spike.tex")
	
    MakeObstaclePhysics(inst, SPIKE_WALL_RADIUS)
    inst.Physics:SetDontRemoveOnSleep(true)
	
	inst.AnimState:SetBank("alterguardian_spike")
    inst.AnimState:SetBuild("alterguardian_spike")
    inst.AnimState:PlayAnimation("spike_pre")
    inst.AnimState:PushAnimation("spike_loop", true)

    inst.SoundEmitter:PlaySoundWithParams("moonstorm/creatures/boss/alterguardian2/spike",  { intensity = math.random() }) 

    inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ALTERGUARDIAN_PHASE2SPIKE"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(on_spike_mining_finished)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("kyno_moonglass_spike", fn, assets),
MakePlacer("kyno_moonglass_spike_placer", "alterguardian_spike", "alterguardian_spike", "spike_loop")