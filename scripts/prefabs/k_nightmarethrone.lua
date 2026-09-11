require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/maxwell_throne.zip"),
	Asset("ANIM", "anim/maxwell_endgame.zip"),
	
	Asset("SOUNDPACKAGE", "sound/shadwell_sfx.fev"),
	Asset("SOUND", "sound/shadwell_sfx.fsb"),
}

local prefabs = 
{
	"sap_endgame_maxwell",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst.SoundEmitter:PlaySound("dontstarve/common/throne/thronemagic", "deathrattle")
	inst:Remove()
end

local function onhammered2(inst, worker)
	SpawnPrefab("sap_endgame_maxwell_die").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function killmaxwell(inst)
	inst.SoundEmitter:PlaySound("dontstarve/maxwell/breakchains")
	inst:DoTaskInTime(113 * (1/30), function() inst.SoundEmitter:PlaySound("dontstarve/maxwell/blowsaway") end)
    inst:DoTaskInTime(95  * (1/30), function() inst.SoundEmitter:PlaySound("dontstarve/maxwell/throne_scream") end)    
    inst:DoTaskInTime(213 * (1/30), function() inst.SoundEmitter:KillSound("deathrattle") end)
	
	inst:ListenForEvent("animover", function() inst:Remove() end)
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("appear")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/common/throne/thronemagic", "deathrattle")
	inst:DoTaskInTime(3, function() inst.SoundEmitter:KillSound("deathrattle") end)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(3, 2)    
	
    MakeObstaclePhysics(inst, .5)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_nightmarethrone.tex")
	
    inst.AnimState:SetBank("throne")
    inst.AnimState:SetBuild("maxwell_throne")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(-1)
    
	inst:AddTag("structure")
	inst:AddTag("nightmarethrone")
	
	inst:SetPrefabNameOverride("maxwellthrone")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	inst:AddComponent("sittable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
    return inst
end

local function fn2()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(3, 2)    
	
    MakeObstaclePhysics(inst, .5)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_nightmarethrone.tex")
	
    inst.AnimState:SetBank("throne")
    inst.AnimState:SetBuild("maxwell_throne")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetFinalOffset(2)
    
	inst:AddTag("structure")
	inst:AddTag("nightmarethrone")
	
	inst:SetPrefabNameOverride("maxwellthrone")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.maxwellprefab = SpawnPrefab("sap_endgame_maxwell")
		inst.maxwellprefab.entity:SetParent(inst.entity)
	end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered2)
	inst.components.workable:SetOnWorkCallback(function(inst, worker)
	if worker.components.combat then
		if worker.components.inventory == nil or not worker.components.inventory:IsInsulated() then
			worker.components.combat:GetAttacked(inst, TUNING.MOOSE_EGG_DAMAGE, nil, "electric")
			end
		end
	end)
	
	inst:DoTaskInTime(1.2, createExtras)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
    return inst
end

local function maxwellfn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 2)
    
    inst.AnimState:SetBank("maxwellthrone")
    inst.AnimState:SetBuild("maxwell_endgame")
    inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:SetFinalOffset(3)
	
	inst:AddTag("locked_maxwell")
	
	inst:SetPrefabNameOverride("waxwell")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

local function maxwelldiefn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, .5)
    
    inst.AnimState:SetBank("maxwellthrone")
    inst.AnimState:SetBuild("maxwell_endgame")
    inst.AnimState:PlayAnimation("death")
	inst.AnimState:SetFinalOffset(3)
	
	inst:AddTag("locked_maxwell")
	
	inst:SetPrefabNameOverride("waxwell")
	
	inst.persists = false
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	killmaxwell(inst)

    return inst
end

local function maxwellplacerfn(inst)
    local placer2 = CreateEntity()

    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    local s = 1 / 1
    placer2.Transform:SetScale(s, s, s)

    placer2.AnimState:SetBank("maxwellthrone")
    placer2.AnimState:SetBuild("maxwell_endgame")
    placer2.AnimState:PlayAnimation("idle_loop", true)
    placer2.AnimState:SetLightOverride(1)
	
    placer2.entity:SetParent(inst.entity)
    inst.components.placer:LinkEntity(placer2)
end

return Prefab("sap_nightmarethrone", fn, assets, prefabs),
Prefab("sap_maxwellthrone", fn2, assets, prefabs),
Prefab("sap_endgame_maxwell", maxwellfn, assets, prefabs),
Prefab("sap_endgame_maxwell_die", maxwelldiefn, assets, prefabs),
MakePlacer("sap_nightmarethrone_placer", "throne", "maxwell_throne", "idle"),
MakePlacer("sap_maxwellthrone_placer", "throne", "maxwell_throne", "idle", false, nil, nil, nil, nil, nil, maxwellplacerfn)