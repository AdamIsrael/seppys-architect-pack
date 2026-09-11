require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/parrot_pirate_intro.zip"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs = {
    "sap_wally_bird",
    "sap_debris_1",
    "sap_debris_2",
    "sap_debris_3",
    "sap_shipmast",
}

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit_shipmast(inst, worker)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle")
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation(anim)
	inst.AnimState:PushAnimation(anim)
end

local function onworked(inst, hitanim, anim)
    inst.AnimState:PlayAnimation(hitanim)
    inst.AnimState:PushAnimation(anim)
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation(anim)
	inst.AnimState:PushAnimation(anim)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_crate.tex")
	
	inst.AnimState:SetBank("parrot_pirate_intro")
	inst.AnimState:SetBuild("parrot_pirate_intro")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("notarget")
    inst:AddTag("wallyintro")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddTag("structure")
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(1)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function birdfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_shipmast.tex")
	
	inst.AnimState:SetBank("parrot_pirate_intro")
    inst.AnimState:SetBuild("parrot_pirate_intro")
    inst.AnimState:PlayAnimation("takeoff_diagonal_pre")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddComponent("inspectable")
	
	inst.persists = false
	
	return inst
end

local function debrisfn(anim, hitanim, workoverride, lootoverride, collision)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_crate.tex")

    if collision then
        MakeObstaclePhysics(inst, .1)
    end

	inst.AnimState:SetBank("parrot_pirate_intro")
    inst.AnimState:SetBuild("parrot_pirate_intro")
    inst.AnimState:PlayAnimation(anim)
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(workoverride or 1)
    if workoverride and workoverride > 1 then
        inst.components.workable:SetOnWorkCallback(function() onworked(inst, hitanim, anim) end)
    end
    inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("lootdropper")
    -- inst.components.lootdropper:AddLoot("log")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
	return inst
end	

local function DoPeck(inst)
if inst:HasTag("wallythebird") then
	inst:DoTaskInTime(8+math.random()*5, function() DoPeck(inst) end)
		inst.AnimState:PlayAnimation("idle_peck")
		inst.AnimState:PushAnimation("idle")
	end
end

local function shipmastfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_shipmast.tex")

    MakeObstaclePhysics(inst, .1)

	inst.AnimState:SetBank("parrot_pirate_intro")
    inst.AnimState:SetBuild("parrot_pirate_intro")
    inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("wallythebird")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
	inst.components.workable:SetOnWorkCallback(onhit_shipmast)
    inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("lootdropper")
    -- inst.components.lootdropper:AddLoot("log")

    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
	
	DoPeck(inst)
	
	return inst
end
	
return Prefab("sap_debris", fn, assets, prefabs),
Prefab("sap_wally_bird", birdfn, assets),
Prefab("sap_debris_1", function() return debrisfn("debris_1") end, assets),
Prefab("sap_debris_2", function() return debrisfn("debris_2") end, assets),
Prefab("sap_debris_3", function() return debrisfn("debris_3") end, assets),
Prefab("sap_shipmast", function() return shipmastfn("idle_empty", "hit", 4, "boards", true) end, assets),
MakePlacer("sap_shipmast_placer", "parrot_pirate_intro", "parrot_pirate_intro", "idle_empty"),
MakePlacer("sap_debris_1_placer", "parrot_pirate_intro", "parrot_pirate_intro", "debris_1"),
MakePlacer("sap_debris_2_placer", "parrot_pirate_intro", "parrot_pirate_intro", "debris_2"),
MakePlacer("sap_debris_3_placer", "parrot_pirate_intro", "parrot_pirate_intro", "debris_3")