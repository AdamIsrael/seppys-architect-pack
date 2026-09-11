local assets =
{
    Asset("ANIM", "anim/oasis_tile.zip"),
    Asset("ANIM", "anim/splash.zip"),
}

local prefabs =
{
    "pondfish",
	"turf_desertdirt",
	"ice",
}

local WATER_RADIUS = 3.8
local NO_DEPLOY_RADIUS = WATER_RADIUS + 0.1

local function OnIsWetChanged(inst, iswet, skipanim)
    if iswet then
        if not inst.isdamp then
            inst.isdamp = true
            if skipanim or inst.driedup then
                inst.AnimState:PlayAnimation("wet")
            else
                inst.AnimState:PlayAnimation("dry_pre")
                inst.AnimState:PushAnimation("wet", false)
            end
        end
    elseif inst.driedup then
        if inst.isdamp then
            inst.isdamp = false
            inst.AnimState:PlayAnimation("dry_idle")
        end
    elseif skipanim then
        inst.AnimState:PlayAnimation("dry_idle")
    else
        inst.AnimState:PlayAnimation("dry_pre")
        inst.AnimState:PushAnimation("dry_idle", false)
    end
end

local function OnIsWet(inst, iswet)
    OnIsWetChanged(inst, iswet, false)
end

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("pondfish")
	inst.components.lootdropper:SpawnLootPrefab("pondfish")
	inst.components.lootdropper:SpawnLootPrefab("turf_desertdirt")
	inst.components.lootdropper:SpawnLootPrefab("turf_desertdirt")
	inst.components.lootdropper:SpawnLootPrefab("ice")
	inst.components.lootdropper:SpawnLootPrefab("ice")
	inst.components.lootdropper:SpawnLootPrefab("ice")
	inst.components.lootdropper:SpawnLootPrefab("ice")
	inst.components.lootdropper:SpawnLootPrefab("ice")
	inst.components.lootdropper:SpawnLootPrefab("ice")
	inst.components.lootdropper:SpawnLootPrefab("ice")
	inst.components.lootdropper:SpawnLootPrefab("ice")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("dry_pst")
	inst.AnimState:PushAnimation("idle", true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.Transform:SetRotation(45)
    MakeObstaclePhysics(inst, 6)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("oasis.png")

    inst.AnimState:SetBuild("oasis_tile")
    inst.AnimState:SetBank("oasis_tile")
    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)

    inst:AddTag("watersource")
    inst:AddTag("birdblocker")
    inst:AddTag("antlion_sinkhole_blocker")
	
	inst:SetPrefabNameOverride("oasislake")

    inst.no_wet_prefix = true
    inst:SetDeployExtraSpacing(NO_DEPLOY_RADIUS)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("watersource")

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("fishable")
    inst.components.fishable.maxfish = TUNING.OASISLAKE_MAX_FISH
    inst.components.fishable:SetRespawnTime(TUNING.OASISLAKE_FISH_RESPAWN_TIME)
    inst.components.fishable:AddFish("pondfish")

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("sap_lake", fn, assets, prefabs),
MakePlacer("sap_lake_placer", "oasis_tile", "oasis_tile", "idle", true)