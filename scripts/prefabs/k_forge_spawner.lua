require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/lavaarena_spawner.zip"),
    Asset("ANIM", "anim/lavaarena_spawndecor.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local DECOR_RADIUS = 3.3
local NUM_DECOR = 6

local function GetDecorPos(index)
    local angle = 240 * DEGREES
    local start_angle = -.5 * angle
    local delta_angle = angle / (NUM_DECOR - 1)
    return DECOR_RADIUS * math.sin(start_angle + index * delta_angle),
        0,
        -DECOR_RADIUS * math.cos(start_angle + index * delta_angle)
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function CreateScratches()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --[[Non-networked entity]]

    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:SetBank("lavaarena_spawner")
    inst.AnimState:SetBuild("lavaarena_spawner")
    inst.AnimState:PlayAnimation("idle_scratch")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    return inst
end

local function CreateSpawnTooth(variation)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    --[[Non-networked entity]]

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:SetBank("lavaarena_spawndecor")
    inst.AnimState:SetBuild("lavaarena_spawndecor")
    inst.AnimState:PlayAnimation("idle")
    if variation > 0 then
        inst.AnimState:OverrideSymbol("spawntooth", "lavaarena_spawndecor", "spawntooth"..tostring(variation + 1))
    end

    return inst
end

local function AddDecor(inst)
    CreateScratches().entity:SetParent(inst.entity)

    inst.highlightchildren = {}

    for i = 0, NUM_DECOR - 1 do
        local decor = CreateSpawnTooth(i % 4)
        decor.entity:SetParent(inst.entity)
        decor.Transform:SetPosition(GetDecorPos(i))
        table.insert(inst.highlightchildren, decor)
    end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_lavaspawner.tex")
	
	-- inst.Transform:SetSixFaced()
	
    inst.AnimState:SetBank("lavaarena_spawner")
    inst.AnimState:SetBuild("lavaarena_spawner")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    inst.AnimState:SetFinalOffset(1)
	
	inst:AddTag("structure")
	inst:AddTag("notarget")
	inst:AddTag("the_forge_spawner")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
		
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "LAVAARENA_SPAWNER"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("savedrotation")
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
	AddDecor(inst)
	
    return inst
end

return Prefab("kyno_lavaspawner", fn, assets, prefabs),
MakePlacer("kyno_lavaspawner_placer", "lavaarena_spawner", "lavaarena_spawner", "idle", true, nil, nil, nil, 90, nil)