local assets = {
	Asset("ANIM", "anim/palmtree_build.zip"),
	Asset("ANIM", "anim/palmtree_normal.zip"),
	Asset("ANIM", "anim/palmtree_short.zip"),
	Asset("ANIM", "anim/palmtree_tall.zip"),

    Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "charcoal",
    "log",
    "tree_petal_fx_chop",
    "palmcone_leaf_fx_normal",
    "palmcone_leaf_fx_short",
    "palmcone_leaf_fx_tall",
    "palmcone_scale",
    "palmcone_seed",
}

local function makeanims(stage)
    return {
        idle            = "idle_"..stage,
        sway1           = "sway1_loop_"..stage,
        sway2           = "sway2_loop_"..stage,
        chop            = "chop_"..stage,
        fallleft        = "fallleft_"..stage,
        fallright       = "fallright_"..stage,
        stump           = "stump_"..stage,
        burning         = "burning_loop_"..stage,
        burnt           = "burnt_"..stage,
        chop_burnt      = "chop_burnt_"..stage,
        idle_chop_burnt = "idle_chop_burnt_"..stage,
    }
end

local SHORT  = "short"
local NORMAL = "normal"
local TALL   = "tall"

local anims  = {
    [SHORT]  = makeanims(SHORT),
    [TALL]   = makeanims(TALL),
    [NORMAL] = makeanims(NORMAL),
}

SetSharedLootTable("kyno_palmtree_small",
{
    {"log", 1.0},
    {"log", 1.0},
})

SetSharedLootTable("kyno_palmtree_normal",
{
    {"log", 1.0},
    {"log", 1.0},
    {"log", 1.0},
	{"kyno_coconut", 1.0},
})

SetSharedLootTable("kyno_palmtree_tall",
{
    {"log", 1.0},
    {"log", 1.0},
    {"log", 1.0},
    {"kyno_coconut", 1.0},
	{"kyno_coconut", 1.0},
})

SetSharedLootTable("kyno_palmtree_burnt",
{
    {"charcoal", 1.0},
})

local function chop_down_burnt(inst, chopper)
    inst:RemoveComponent("workable")

    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
    end

    inst.AnimState:PlayAnimation(anims[inst.size].chop_burnt)

    RemovePhysicsColliders(inst)

    inst:ListenForEvent("animover", inst.Remove)

    inst.components.lootdropper:DropLoot()
end

local function burnt_changes(inst)
    if inst.components.burnable ~= nil then
        inst.components.burnable:Extinguish()
    end

    inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
    inst:RemoveComponent("growable")
    inst:RemoveComponent("hauntable")
    MakeHauntableWork(inst)

    inst:RemoveTag("shelter")

    inst.components.lootdropper:SetChanceLootTable("kyno_palmtree_burnt")

    if inst.components.workable then
        inst.components.workable:SetWorkLeft(1)
        inst.components.workable:SetOnWorkCallback(nil)
        inst.components.workable:SetOnFinishCallback(chop_down_burnt)
    end
end

local function tree_burnt_immediate_helper(inst, immediate)
    if immediate then
        burnt_changes(inst)
    else
        inst:DoTaskInTime(.5, burnt_changes)
    end

    inst.AnimState:PlayAnimation(anims[inst.size].burnt, true)
    inst.MiniMapEntity:SetIcon("kyno_palmtree.tex")

    inst.AnimState:SetRayTestOnBB(true)
    inst:AddTag("burnt")
end

local function on_tree_burnt(inst)
    tree_burnt_immediate_helper(inst, false)
end

local function inspect_tree(inst)
    return (inst:HasTag("burnt") and "BURNT")
	or (inst:HasTag("stump") and "CHOPPED")
	or nil
end

local function on_chop_tree(inst, chopper, chops_remaining, num_chops)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound(chopper ~= nil and chopper:HasTag("beaver") and
		"dontstarve/characters/woodie/beaver_chop_tree" or "dontstarve/wilson/use_axe_tree")
    end

    local anim_set = anims[inst.size]
    inst.AnimState:PlayAnimation(anim_set.chop)
    inst.AnimState:PushAnimation(anim_set.sway1, true)

    local x, y, z = inst.Transform:GetWorldPosition()
end

local function dig_up_stump(inst, digger)
	inst.components.lootdropper:SpawnLootPrefab("log")
    inst:Remove()
end

local function make_stump_burnable(inst)
    if inst.size == SHORT then
        MakeSmallBurnable(inst)
    elseif inst.size == NORMAL then
        MakeMediumBurnable(inst)
    else
        MakeLargeBurnable(inst)
        inst.components.burnable:SetFXLevel(5)
    end
end

local function make_stump(inst)
    inst:RemoveComponent("burnable")
    inst:RemoveComponent("propagator")
    inst:RemoveComponent("workable")
    inst:RemoveComponent("hauntable")
    inst:RemoveTag("shelter")

    make_stump_burnable(inst)
    MakeMediumPropagator(inst)
    MakeHauntableIgnite(inst)

    RemovePhysicsColliders(inst)

    inst:AddTag("stump")
    if inst.components.growable ~= nil then
        inst.components.growable:StopGrowing()
    end

    inst.MiniMapEntity:SetIcon("kyno_palmtree.tex")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up_stump)
    inst.components.workable:SetWorkLeft(1)
end

local function on_chop_tree_down(inst, chopper)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    local pt = inst:GetPosition()

    local chopper_on_rightside = true
    if chopper then
        local chopper_position = chopper:GetPosition()
        chopper_on_rightside = (chopper_position - pt):Dot(TheCamera:GetRightVec()) > 0
    else
        if math.random() > 0.5 then
            chopper_on_rightside = false
        end
    end

    local anim_set = anims[inst.size]
    if chopper_on_rightside then
        inst.AnimState:PlayAnimation(anim_set.fallleft)
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation(anim_set.fallright)
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

    inst:DoTaskInTime(0.4, function (inst)
        ShakeAllCameras( CAMERASHAKE.FULL, .25, .03, (inst.size == TALL and .5) or .25, inst, 6 )
    end)

    make_stump(inst)
    inst.AnimState:PushAnimation(anim_set.stump)
end

local function sway(inst)
    local anim_to_play = (math.random() > .5 and anims[inst.size].sway1) or anims[inst.size].sway2
    inst.AnimState:PlayAnimation(anim_to_play, true)
end

local function push_sway(inst)
    local anim_to_play = (math.random() > .5 and anims[inst.size].sway1) or anims[inst.size].sway2
    inst.AnimState:PushAnimation(anim_to_play, true)
end

local function set_short_burnable(inst)
    if inst.components.burnable == nil then
        inst:AddComponent("burnable")
    end
    inst.components.burnable:AddBurnFX("fire", Vector3(0, 0, 0))
    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:SetBurnTime(TUNING.TREE_BURN_TIME / 2)
    inst.components.burnable:SetOnIgniteFn(DefaultBurnFn)
    inst.components.burnable:SetOnExtinguishFn(DefaultExtinguishFn)
    inst.components.burnable:SetOnBurntFn(on_tree_burnt)

    if inst.components.propagator == nil then
        inst:AddComponent("propagator")
    end
    inst.components.propagator.acceptsheat = true
    inst.components.propagator:SetOnFlashPoint(DefaultIgniteFn)
    inst.components.propagator.flashpoint = 5 + math.random()*5
    inst.components.propagator.decayrate = 0.5
    inst.components.propagator.propagaterange = 5
    inst.components.propagator.heatoutput = 5
    inst.components.propagator.damagerange = 2
    inst.components.propagator.damages = true
end

local function set_short(inst)
    inst.size = SHORT
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(5)
    end
    set_short_burnable(inst)
    inst.components.lootdropper:SetChanceLootTable("kyno_palmtree_small")
    inst:AddTag("shelter")

    sway(inst)
end

local function grow_short(inst)
    inst.AnimState:PlayAnimation("grow_tall_to_short")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")
    set_short_burnable(inst)
    push_sway(inst)
end

local function set_normal_burnable(inst)
    if inst.components.burnable == nil then
        inst:AddComponent("burnable")
    end
    inst.components.burnable:AddBurnFX("fire", Vector3(0, 0, 0))
    inst.components.burnable:SetBurnTime(TUNING.TREE_BURN_TIME)
    inst.components.burnable:SetFXLevel(3)
    inst.components.burnable:SetOnIgniteFn(DefaultBurnFn)
    inst.components.burnable:SetOnExtinguishFn(DefaultExtinguishFn)
    inst.components.burnable:SetOnBurntFn(on_tree_burnt)

    if inst.components.propagator == nil then
        inst:AddComponent("propagator")
    end
    inst.components.propagator.acceptsheat = true
    inst.components.propagator:SetOnFlashPoint(DefaultIgniteFn)
    inst.components.propagator.flashpoint = 5 + math.random()*5
    inst.components.propagator.decayrate = 0.5
    inst.components.propagator.propagaterange = 5
    inst.components.propagator.heatoutput = 5
    inst.components.propagator.damagerange = 2
    inst.components.propagator.damages = true
end

local function set_normal(inst)
    inst.size = NORMAL
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(10)
    end
    set_normal_burnable(inst)
    inst.components.lootdropper:SetChanceLootTable("kyno_palmtree_normal")
    inst:AddTag("shelter")
    sway(inst)
end

local function grow_normal(inst)
    inst.AnimState:PlayAnimation("grow_short_to_normal")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    set_normal_burnable(inst)
    push_sway(inst)
end

local function set_tall_burnable(inst)
    if inst.components.burnable == nil then
        inst:AddComponent("burnable")
    end
    inst.components.burnable:AddBurnFX("fire", Vector3(0, 0, 0))
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetBurnTime(TUNING.TREE_BURN_TIME * 1.5)
    inst.components.burnable:SetOnIgniteFn(DefaultBurnFn)
    inst.components.burnable:SetOnExtinguishFn(DefaultExtinguishFn)
    inst.components.burnable:SetOnBurntFn(on_tree_burnt)

    if inst.components.propagator == nil then
        inst:AddComponent("propagator")
    end
    inst.components.propagator.acceptsheat = true
    inst.components.propagator:SetOnFlashPoint(DefaultIgniteFn)
    inst.components.propagator.flashpoint = 15+math.random()*10
    inst.components.propagator.decayrate = 0.5
    inst.components.propagator.propagaterange = 7
    inst.components.propagator.heatoutput = 8.5
    inst.components.propagator.damagerange = 3
    inst.components.propagator.damages = true
end

local function set_tall(inst)
    inst.size = TALL
    if inst.components.workable then
        inst.components.workable:SetWorkLeft(15)
    end
    set_tall_burnable(inst)
    inst.components.lootdropper:SetChanceLootTable("kyno_palmtree_tall")
    inst:AddTag("shelter")
    sway(inst)
end

local function grow_tall(inst)
    inst.AnimState:PlayAnimation("grow_normal_to_tall")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    set_tall_burnable(inst)
    push_sway(inst)
end

local growth_stages = {
    {
        name = SHORT,
        time = function(inst)
            return GetRandomWithVariance(TUNING.PALMCONETREE_GROWTH_TIME[1].base, TUNING.PALMCONETREE_GROWTH_TIME[1].random)
        end,
        fn = set_short,
        growfn = grow_short,
    },
    {
        name = NORMAL,
        time = function(inst)
            return GetRandomWithVariance(TUNING.PALMCONETREE_GROWTH_TIME[2].base, TUNING.PALMCONETREE_GROWTH_TIME[2].random)
        end,
        fn = set_normal,
        growfn = grow_normal,
    },
    {
        name = TALL,
        time = function(inst)
            return GetRandomWithVariance(TUNING.PALMCONETREE_GROWTH_TIME[3].base, TUNING.PALMCONETREE_GROWTH_TIME[3].random)
        end,
        fn = set_tall,
        growfn = grow_tall,
    },
}

local function growfromseed_handler(inst)
    inst.components.growable:SetStage(1)
    inst.AnimState:PlayAnimation("grow_seed_to_short")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    push_sway(inst)
end

local function on_save(inst, data)
    if inst:HasTag("burnt") or (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
        data.burnt = true
    end

    if inst:HasTag("stump") then
        data.stump = true
    end

    data.size = inst.size
end

local function on_load(inst, data)
    if data == nil then
        return
    end

    inst.size = data.size ~= nil and data.size or NORMAL
    if inst.size == SHORT then
        set_short(inst)
    elseif inst.size == NORMAL then
        set_normal(inst)
    else
        set_tall(inst)
    end

    local is_burnt = data.burnt or inst:HasTag("burnt")
    if data.stump and is_burnt then
        make_stump(inst)
        inst.AnimState:PlayAnimation(anims[inst.size].stump)
        DefaultBurntFn(inst)
    elseif data.stump then
        make_stump(inst)
        inst.AnimState:PlayAnimation(anims[inst.size].stump)
    elseif is_burnt then
        tree_burnt_immediate_helper(inst, true)
    else
        sway(inst)
    end
end

local function on_sleep(inst)
    local do_burnt = inst.components.burnable ~= nil and inst.components.burnable:IsBurning()
    if do_burnt and inst:HasTag("stump") then
        DefaultBurntFn(inst)
    else
        inst:RemoveComponent("burnable")
        inst:RemoveComponent("propagator")
        inst:RemoveComponent("inspectable")
        if do_burnt then
            inst:RemoveComponent("growable")
            inst:AddTag("burnt")
        end
    end
end

local function on_wake(inst)
    if inst:HasTag("burnt") then
        on_tree_burnt(inst)
    else
        if not (inst.components.burnable ~= nil and inst.components.burnable:IsBurning()) then
            local is_stump = inst:HasTag("stump")
            if is_stump then
                if inst.components.burnable == nil then
                    make_stump_burnable(inst)
                end

                if inst.components.propagator == nil then
                    MakeMediumPropagator(inst)
                end
            else
                if inst.size == SHORT then
                    set_short_burnable(inst)
                elseif inst.size == NORMAL then
                    set_normal_burnable(inst)
                else
                    set_tall_burnable(inst)
                end
            end
        end
    end

    if inst.components.inspectable == nil then
        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = inspect_tree
    end
end

local function tree(name, stage, data)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()
		
		local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon("kyno_palmtree.tex")

        MakeObstaclePhysics(inst, .5)
		
		inst.AnimState:SetBank("treepalm")
        inst.AnimState:SetBuild("palmtree_build")
		
		inst:AddTag("plant")
        inst:AddTag("tree")
        inst:AddTag("shelter")

        MakeSnowCoveredPristine(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.color = 0.75 + math.random() * 0.25
        inst.AnimState:SetMultColour(inst.color, inst.color, inst.color, 1)
		
		inst.size = (stage == 1 and SHORT)
		or (stage == 2 and NORMAL)
		or (stage == 3 and TALL)
		or nil

        if inst.size == SHORT then
            set_short_burnable(inst)
        elseif inst.size == NORMAL then
            set_normal_burnable(inst)
        else
            set_tall_burnable(inst)
        end
		
		inst:AddComponent("lootdropper")
		inst:AddComponent("timer")

        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = inspect_tree

        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.CHOP)
        inst.components.workable:SetOnWorkCallback(on_chop_tree)
        inst.components.workable:SetOnFinishCallback(on_chop_tree_down)

        inst:AddComponent("growable")
        inst.components.growable.stages = growth_stages
        inst.components.growable:SetStage(stage == 0 and math.random(1, 3) or stage)
        inst.components.growable.loopstages = true
        inst.components.growable.springgrowth = true
        inst.components.growable:StartGrowing()
        inst.growfromseed = growfromseed_handler

        inst.OnSave = on_save
        inst.OnLoad = on_load

		MakeHauntableWorkAndIgnite(inst)
        MakeSnowCovered(inst)

        inst.AnimState:SetTime(math.random() * .2)

        inst.OnEntitySleep = on_sleep
        inst.OnEntityWake = on_wake

        return inst
    end

    return Prefab(name, fn, assets, prefabs)
end

return tree("kyno_palmtree", 0),
tree("kyno_palmtree_short",  1),
tree("kyno_palmtree_normal", 2),
tree("kyno_palmtree_tall",   3)