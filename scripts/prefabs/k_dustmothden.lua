local assets =
{
    Asset("ANIM", "anim/dustmothden.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
    "dustmoth",
}

local function StartRepairing(inst, repairer)
    -- Usually called from SGdustmoth

    if inst.components.timer:TimerExists("repair") then
        if inst.components.timer:IsPaused("repair") then
            inst.components.timer:ResumeTimer("repair")
        end
    else
        inst.components.timer:StartTimer("repair", TUNING.DUSTMOTHDEN.REPAIR_TIME)
    end
    
    inst.components.entitytracker:TrackEntity("repairer", repairer)

    inst.AnimState:PlayAnimation("repair", true)
end

local function PauseRepairing(inst)
    inst.components.timer:PauseTimer("repair")

    if not inst.components.workable.workable then
        inst.AnimState:PlayAnimation("idle")
    end

    inst.components.entitytracker:ForgetEntity("repairer")
end

local function MakeWhole(inst, play_growth_anim)
    if play_growth_anim then
        inst.AnimState:PlayAnimation("growth")
        inst.AnimState:PushAnimation("idle_thulecite", false)
    else
        inst.AnimState:PlayAnimation("idle_thulecite")
    end
    
    inst.components.workable.workleft = inst.components.workable.workleft <= 0 and inst.components.workable.maxwork or inst.components.workable.workleft
    inst.components.workable.workable = true
    
    local repairer = inst.components.entitytracker:GetEntity("repairer")
    if repairer ~= nil and repairer:IsValid() then
        repairer:PushEvent("dustmothden_repaired", inst)
    end
    inst.components.entitytracker:ForgetEntity("repairer")
end

local function OnTimerDone(inst, data)
    if data ~= nil and data.name == "repair" then
        MakeWhole(inst, true)
    end
end

local function OnFinishWork(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.workable.workable = false

    inst.AnimState:PlayAnimation("idle")

    inst.SoundEmitter:PlaySoundWithParams("dontstarve/creatures/together/antlion/sfx/ground_break", { size = 1 })
end

local function OnLoadPostPass(inst, ents, data)
    if inst.components.workable.workleft <= 0 then
        inst.components.workable.workable = false
        inst.AnimState:PlayAnimation("idle")
    else
        MakeWhole(inst, false)
    end
    
    if inst.components.timer:TimerExists("repair") then
        PauseRepairing(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("dustmothden.png")

    MakeSmallObstaclePhysics(inst, .5)

    inst.AnimState:SetBank("dustmothden")
    inst.AnimState:SetBuild("dustmothden")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
	inst:AddTag("moth_house")
	
	inst:SetPrefabNameOverride("dustmothden")
    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst._start_repairing_fn = StartRepairing
    inst._pause_repairing_fn = PauseRepairing
    
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "dustmoth"
    inst.components.childspawner:SetRegenPeriod(TUNING.DUSTMOTHDEN.REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.DUSTMOTHDEN.RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartRegen()
    inst.components.childspawner:StartSpawning()

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetMaxWork(TUNING.DUSTMOTHDEN.MAXWORK)
    inst.components.workable:SetWorkLeft(TUNING.DUSTMOTHDEN.MAXWORK)
    inst.components.workable:SetOnFinishCallback(OnFinishWork)
    inst.components.workable.savestate = true

    inst.components.workable.workleft = 0
    inst.components.workable.workable = false
    
    inst:AddComponent("timer")
    inst:AddComponent("entitytracker")
    
    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")

    inst:ListenForEvent("timerdone", OnTimerDone)

    MakeSnowCovered(inst)
    MakeHauntableWork(inst)

    inst.OnLoadPostPass = OnLoadPostPass

    return inst
end

return Prefab("sap_dustmothden", fn, assets, prefabs),
MakePlacer("sap_dustmothden_placer", "dustmothden", "dustmothden", "idle")