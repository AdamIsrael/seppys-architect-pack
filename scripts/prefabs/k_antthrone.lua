require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/throne.zip"),
	Asset("ANIM", "anim/crickant_queen_basics.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs =
{
	"sap_ant_queen",
}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("low", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("med", true)
	else
		inst.AnimState:PlayAnimation("full", true)
	end
end

local function onwork_queen(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("hit", false)
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/antqueen/hit")
		inst.AnimState:PushAnimation("idle", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("hit", false)
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/antqueen/hit")
		inst.AnimState:PushAnimation("idle", true)
	else
		inst.AnimState:PlayAnimation("hit", false)
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/antqueen/hit")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("full")
end

local function onfar(inst)
	inst.AnimState:PlayAnimation("sleep_pre")
	inst.AnimState:PushAnimation("sleep_loop", true)
	inst.SoundEmitter:KillSound("taunt")
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("sleep_pst")
	inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/boss/antqueen/taunt")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_antqueen_entrance.tex")
	
	inst.Transform:SetScale(0.7, 0.7, 0.7)
	
	inst.AnimState:SetBank("throne")
	inst.AnimState:SetBuild("throne")
	inst.AnimState:PlayAnimation("full", true)
	
	MakeObstaclePhysics(inst, 6)
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	inst:AddTag("antthrone")
	inst:AddTag("birdblocker")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function queenfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_antqueen_entrance.tex")
	
	inst.Transform:SetScale(0.7, 0.7, 0.7)
	
	inst.AnimState:SetBank("crick_crickantqueen")
	inst.AnimState:SetBuild("crickant_queen_basics")
	inst.AnimState:PlayAnimation("sleep_loop", true)
	inst.AnimState:AddOverrideBuild("throne")
	
	MakeObstaclePhysics(inst, 6)
	
	inst:AddTag("structure")
	inst:AddTag("boulder")
	inst:AddTag("antthrone")
	inst:AddTag("birdblocker")
	inst:AddTag("antqueen")
	inst:AddTag("epic")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(6, 10)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork_queen)
	inst.components.workable:SetOnFinishCallback(onfinish)

	return inst
end

local function throneplacetestfn(inst)
	inst.Transform:SetScale(0.7, 0.7, 0.7)
end

local function queenplacetestfn(inst)
	inst.Transform:SetScale(0.7, 0.7, 0.7)
	inst.AnimState:AddOverrideBuild("throne")
end

return Prefab("sap_antthrone", fn, assets, prefabs),
Prefab("sap_ant_queen", queenfn, assets, prefabs),
MakePlacer("sap_antthrone_placer", "throne", "throne", "full", false, nil, nil, nil, nil, nil, throneplacetestfn),
MakePlacer("sap_ant_queen_placer", "crick_crickantqueen", "crickant_queen_basics", "idle", false, nil, nil, nil, nil, nil, queenplacetestfn)