require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/alterguardian_meteor.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function spike_break(inst)
    inst.Physics:SetActive(false)

    inst.components.workable:SetWorkable(false)

    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("meteor_pst")

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

local function charge(inst)
if inst:HasTag("glassmeteor") then
	inst:DoTaskInTime(4+math.random()*5, function() charge(inst) end)
		inst.AnimState:PlayAnimation("meteor_charge")
		inst.AnimState:PushAnimation("meteor_idle", true)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_moonglass_meteor.tex")
	
    MakeObstaclePhysics(inst, SPIKE_WALL_RADIUS)
    inst.Physics:SetDontRemoveOnSleep(true)
	
	inst.AnimState:SetBank("alterguardian_meteor")
    inst.AnimState:SetBuild("alterguardian_meteor")
    inst.AnimState:PlayAnimation("meteor_charge")
    inst.AnimState:PushAnimation("meteor_idle", true)

    inst:AddTag("structure")
	inst:AddTag("glassmeteor")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
	inst.groundprefab =  SpawnPrefab("sap_moonglass_meteorground")
	inst.groundprefab.entity:SetParent(inst.entity)
	end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ALTERGUARDIAN_PHASE3TRAP"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(on_spike_mining_finished)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:DoTaskInTime(FRAMES * 1, createExtras)
	
	MakeHauntableWork(inst)
	charge(inst)
	
    return inst
end

local function fn2(Sim)
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.8, .8, .8)
    
    inst.AnimState:SetBank("alterguardian_meteor")
    inst.AnimState:SetBuild("alterguardian_meteor")
	inst.AnimState:PlayAnimation("meteorground_pre")
    inst.AnimState:PushAnimation("meteorground_loop", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
	
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

return Prefab("sap_moonglass_meteor", fn, assets),
Prefab("sap_moonglass_meteorground", fn2, assets),
MakePlacer("sap_moonglass_meteor_placer", "alterguardian_meteor", "alterguardian_meteor", "meteor_idle")