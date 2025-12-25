require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/kyno_driftwood_thinktank.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "collapse_small",
}

local function OnHammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
	
    inst.components.lootdropper:DropLoot()
	
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function OnHit(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        if inst.components.prototyper.on then
            inst.AnimState:PushAnimation("proximity_loop", true)
            if not inst.SoundEmitter:PlayingSound("loop_sound") then
                inst.SoundEmitter:PlaySound("turnoftides/common/together/seafaring_prototyper/LP", "loop_sound")
            end
        else
            inst.AnimState:PushAnimation("idle", false)
            inst.SoundEmitter:KillSound("loop_sound")
        end
    end
end

local function TurnOff(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PushAnimation("idle", false)
        inst.SoundEmitter:KillSound("loop_sound")
    end
end

local function TurnOn(inst)
    if not inst:HasTag("burnt") then
        if inst.AnimState:IsCurrentAnimation("proximity_loop") or
            inst.AnimState:IsCurrentAnimation("place") or
            inst.AnimState:IsCurrentAnimation("use") then
			inst.AnimState:PushAnimation("proximity_loop", true)
            if not inst.SoundEmitter:PlayingSound("loop_sound") then
                inst.SoundEmitter:PlaySound("turnoftides/common/together/seafaring_prototyper/LP", "loop_sound")
            end
        else
            inst.AnimState:PlayAnimation("proximity_loop", true)
            if not inst.SoundEmitter:PlayingSound("loop_sound") then
                inst.SoundEmitter:PlaySound("turnoftides/common/together/seafaring_prototyper/LP", "loop_sound")
            end
        end
    end
end

local function OnActivate(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("use")
        inst.AnimState:PushAnimation("proximity_loop", true)
        inst.SoundEmitter:PlaySound("turnoftides/common/together/seafaring_prototyper/use")
    end
end

local function OnBuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", false)
    inst.SoundEmitter:PlaySound("turnoftides/common/together/seafaring_prototyper/place")
end

local function OnSave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function OnLoad(inst, data)
    if data ~= nil and data.burnt then
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
	minimap:SetIcon("kyno_driftwood_thinktank.tex")
	minimap:SetPriority(5)

    MakeObstaclePhysics(inst, .4)

    inst.AnimState:SetBank("lighthouse")
    inst.AnimState:SetBuild("kyno_driftwood_thinktank")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddTag("prototyper")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SEAFARING_PROTOTYPER"
	
    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = TurnOn
    inst.components.prototyper.onturnoff = TurnOff
    inst.components.prototyper.onactivate = OnActivate
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.SEAFARING_STATION

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	
    MakeSnowCovered(inst)
    MakeLargeBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("kyno_driftwood_thinktank", fn, assets, prefabs),
MakePlacer("kyno_driftwood_thinktank_placer", "lighthouse", "kyno_driftwood_thinktank", "idle")