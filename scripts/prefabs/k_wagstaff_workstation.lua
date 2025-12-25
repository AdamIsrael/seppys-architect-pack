require("prefabutil")

local assets = 
{
    Asset("ANIM", "anim/wagpunk_workstation.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
    Asset("SOUND", "sound/together.fsb"),
}

local sounds = 
{
    idle = "rifts5/wagpunk_station/proximity_LP",
    use = "rifts5/wagpunk_station/use",
}

local function OnTurnOn(inst)
    if inst.prototyper_activatedtask then
        return
    end
	
	inst.components.prototyper.on = true
	
	if TheWorld.components.wagpunk_arena_manager then
        TheWorld.components.wagpunk_arena_manager:WorkstationToggled(inst, true)
    end

    inst.AnimState:PushAnimation("proximity_loop", true)
    if not inst.SoundEmitter:PlayingSound("idlesound") then
        inst.SoundEmitter:PlaySound(sounds.idle, "idlesound")
    end
end

local function OnTurnOff(inst)
    if inst.prototyper_activatedtask then
        return
    end
	
	inst.components.prototyper.on = false
	
	if TheWorld.components.wagpunk_arena_manager then
        TheWorld.components.wagpunk_arena_manager:WorkstationToggled(inst, false)
    end

    inst.AnimState:PlayAnimation("idle", false)
    inst.SoundEmitter:KillSound("idlesound")
end

local function FinishUseAnim(inst)
    inst.prototyper_activatedtask = nil
	
    if inst.components.prototyper.on then
        inst.AnimState:PlayAnimation("proximity_loop", true)
		
        if not inst.SoundEmitter:PlayingSound("idlesound") then
            inst.SoundEmitter:PlaySound(sounds.idle, "idlesound")
        end
    else
        inst.AnimState:PushAnimation("idle")
        inst.SoundEmitter:KillSound("idlesound")
    end
end

local function OnActivate(inst)
    inst.AnimState:PlayAnimation("use")
    inst.SoundEmitter:PlaySound(sounds.use)

    if inst.prototyper_activatedtask ~= nil then
        inst.prototyper_activatedtask:Cancel()
        inst.prototyper_activatedtask = nil
    end
	
    inst.prototyper_activatedtask = inst:DoTaskInTime(inst.AnimState:GetCurrentAnimationLength(), FinishUseAnim)
end

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("wagpunk_workstation.png")
	minimap:SetPriority(5)

    MakeObstaclePhysics(inst, 0.4)

    inst.AnimState:SetBank("wagpunk_workstation")
    inst.AnimState:SetBuild("wagpunk_workstation")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddTag("prototyper")
	
	inst:SetPrefabNameOverride("wagpunk_workstation")

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("craftingstation")
	inst:AddComponent("lootdropper")

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = OnTurnOn
    inst.components.prototyper.onturnoff = OnTurnOff
    inst.components.prototyper.onactivate = OnActivate
    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.WAGPUNK_WORKSTATION
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)

    return inst
end

return Prefab("kyno_wagpunk_workstation", fn, assets),
MakePlacer("kyno_wagpunk_workstation_placer", "wagpunk_workstation", "wagpunk_workstation", "idle")