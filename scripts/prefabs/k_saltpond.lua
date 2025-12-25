require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_salt_pond.zip"),
	Asset("ANIM", "anim/quagmire_salt_rack.zip"),
    Asset("ANIM", "anim/splash.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs =
{
	"kyno_salmonfish",
	"kyno_salt_rack",
	"saltrock",
}

local SALT_REGROW_TIME = 1920

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("splash")
    inst.AnimState:PushAnimation("idle", true)
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle", true)
end

local function onbuilt_rack(inst)
    inst.AnimState:PushAnimation("place", true)
end

local function onpickedfn(inst)
    inst.AnimState:PlayAnimation("picked", false)
	inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught")
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/fishingpole_fishcaught")
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("picked", true)
end

local rack_defs = {
	rack = { { 0, 0, 0 } },
}

local function DoSplash(inst)
if inst:HasTag("saltpondrack") then
	inst:DoTaskInTime(4+math.random()*5, function() DoSplash(inst) end)
		inst.AnimState:PlayAnimation("splash")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function pondfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_saltpond.tex")
	
	MakeObstaclePhysics(inst, 1.95)
	
    inst.AnimState:SetBank("quagmire_salt_pond")
    inst.AnimState:SetBuild("quagmire_salt_pond")
    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    
	inst:AddTag("watersource")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    inst:AddTag("saltpond")

    inst.no_wet_prefix = true
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("watersource")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_POND_SALT"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("fishable")
    inst.components.fishable.maxfish = TUNING.OASISLAKE_MAX_FISH
    inst.components.fishable:SetRespawnTime(TUNING.OASISLAKE_FISH_RESPAWN_TIME)
    inst.components.fishable:AddFish("kyno_salmonfish")
	
	inst:AddComponent("savedrotation")
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function saltpondfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("quagmire_salt_rack.png")
	
	MakeObstaclePhysics(inst, 1.95)
	
    inst.AnimState:SetBank("quagmire_salt_pond")
    inst.AnimState:SetBuild("quagmire_salt_pond")
    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
    
	inst:AddTag("watersource")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    inst:AddTag("saltpondrack")

    inst.no_wet_prefix = true
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	local decor_items = rack_defs
		inst.decor = {}
		for item_name, data in pairs(decor_items) do
			for l, offset in pairs(data) do
				local item_inst = SpawnPrefab("kyno_salt_rack")
				item_inst.AnimState:PlayAnimation("place")
				item_inst.AnimState:PushAnimation("idle", true)
				item_inst.entity:SetParent(inst.entity)
				item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
				table.insert(inst.decor, item_inst)
			end
		end
	
	inst:AddComponent("watersource")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_POND_SALT"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("savedrotation")
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	DoSplash(inst)
	
    return inst
end

local function rackfn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
    
	MakeObstaclePhysics(inst, 1.95)
	
    inst.AnimState:SetBank("quagmire_salt_rack")
    inst.AnimState:SetBuild("quagmire_salt_rack")
    inst.AnimState:PlayAnimation("idle", true)
	
    inst.persists = false
	
	inst:AddTag("drying_rack_salt")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.AnimState:SetTime(math.random() * 2)
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SALT_RACK"
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/common/fishingpole_fishcaught"
    inst.components.pickable:SetUp("saltrock", SALT_REGROW_TIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	
	inst:ListenForEvent("onbuilt", onbuilt_rack)
	
    return inst
end

local function rackplacetestfn(inst)
	inst.AnimState:AddOverrideBuild("quagmire_salt_rack")
	-- inst.AnimState:AddOverrideBank("quagmire_salt_rack")
	inst.AnimState:Show("idle")
end

return Prefab("kyno_saltpond", pondfn, assets, prefabs),
Prefab("kyno_saltpond_rack", saltpondfn, assets, prefabs),
Prefab("kyno_salt_rack", rackfn, assets, prefabs),
MakePlacer("kyno_saltpond_placer", "quagmire_salt_pond", "quagmire_salt_pond", "idle", true, nil, nil, nil, 90, nil),
MakePlacer("kyno_saltpond_rack_placer", "quagmire_salt_pond", "quagmire_salt_pond", "idle", true, nil, nil, nil, 90, nil, rackplacetestfn)