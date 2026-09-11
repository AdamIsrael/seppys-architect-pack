require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/oceanvine.zip"),
}

local prefabs =
{
    "fig",
}

local BURN_DURATION = 2

local function OnFinished(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	if inst.components.pickable and inst.components.pickable:CanBePicked() then
		inst.components.lootdropper:SpawnLootPrefab("fig")
    end
	
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function OnWork(inst, worker)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
end

local function OnStartBurnAnim(inst)
    inst.persists = false

    if inst.components.inspectable ~= nil then
        inst:RemoveComponent("inspectable")
    end

    if inst.components.pickable ~= nil then
        inst:RemoveComponent("pickable")
    end
    
    inst.components.burnable:SetOnExtinguishFn(inst.Remove)

    inst.AnimState:PlayAnimation("burn")
    inst:ListenForEvent("animover", inst.Remove)

    local theta = math.random() * 2 * PI
    local spd = math.random() * 2
    local ash = SpawnPrefab("ash")
    ash.Transform:SetPosition(inst:GetPosition():Get())
    ash.Physics:SetVel(math.cos(theta) * spd, 8 + math.random() * 4, math.sin(theta) * spd)
end

local function OnExtinguishNotFinishedBurning(inst)
    if inst.burn_anim_task ~= nil then
        inst.burn_anim_task:Cancel()
        inst.burn_anim_task = nil
    end
end

local function OnIgnite(inst, source, doer)
    inst.burn_anim_task = inst:DoTaskInTime(BURN_DURATION, OnStartBurnAnim)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguishNotFinishedBurning)
end

local function OnFall(inst)
    inst.AnimState:PlayAnimation("spawn", false)
    inst.AnimState:PushAnimation("idle_fruit", true)
end

local function OnPicked(inst, picker, loot)
    inst.AnimState:PlayAnimation("harvest", false)
    inst.AnimState:PushAnimation("idle_nofruit", true)

    if inst.components.inspectable ~= nil then
        inst:RemoveComponent("inspectable")
    end
end

local function MakeEmpty(inst)
    inst.AnimState:Hide("fig")
    inst.AnimState:PlayAnimation("idle_nofruit", true)

    if inst.components.inspectable ~= nil then
        inst:RemoveComponent("inspectable")
    end
end

local function MakeFull(inst)
    inst.AnimState:Show("fig")
    if POPULATING then
        inst.AnimState:PlayAnimation("idle_fruit", true)
    else
        inst.AnimState:PlayAnimation("fruit_grow", false)
        inst.AnimState:PushAnimation("idle_fruit", true)
    end

    if inst.components.inspectable == nil then
        inst:AddComponent("inspectable")
    end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("spawn", false)
    inst.AnimState:PushAnimation("idle_fruit", true)

	if inst.components.pickable ~= nil and inst.components.pickable:CanBePicked() then
		inst.components.pickable:MakeEmpty()
    end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("oceanvine.png")

	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
    
	inst.AnimState:SetBank("oceanvine")
    inst.AnimState:SetBuild("oceanvine")
	inst.AnimState:PlayAnimation("idle_fruit", true)

	inst:AddTag("structure")
    inst:AddTag("flying")
    inst:AddTag("NOBLOCK")
	
	inst:SetPrefabNameOverride("oceanvine")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    
    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/harvest_berries"
    inst.components.pickable.onpickedfn = OnPicked
    inst.components.pickable.makeemptyfn = MakeEmpty
    inst.components.pickable.makefullfn = MakeFull
    inst.components.pickable:SetUp("fig", TUNING.OCEANVINE_REGROW_TIME)
    inst.components.pickable.max_cycles = nil
    inst.components.pickable.cycles_left = 1
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable:SetOnFinishCallback(OnFinished)

    MakeSmallBurnable(inst, nil, nil, nil, "swap_fire")
    inst.components.burnable.fxdata[1].prefab = "character_fire"
    inst.components.burnable.fxdata[1].followaschild = true
    inst.components.burnable:SetFXOffset(0, 1, 0)
    inst.components.burnable:SetBurnTime(BURN_DURATION + 5)
    inst.components.burnable:SetOnIgniteFn(OnIgnite)
    inst.components.burnable:SetOnBurntFn(inst.Remove)
	
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
    
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	return inst
end

local function fallenfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
	inst.AnimState:SetBank("oceanvine")
    inst.AnimState:SetBuild("oceanvine")
	inst.AnimState:PlayAnimation("fallen", true)

    inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("oceanvine")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable:SetOnFinishCallback(OnFinished)

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)
	
	return inst
end

return Prefab("sap_fig_vine", fn, assets, prefabs),
Prefab("sap_fig_vine_fallen", fallenfn, assets, prefabs),
MakePlacer("sap_fig_vine_placer", "oceanvine", "oceanvine", "idle_fruit"),
MakePlacer("sap_fig_vine_fallen_placer", "oceanvine", "oceanvine", "fallen")