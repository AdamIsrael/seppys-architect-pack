require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/pig_shop.zip"),
    Asset("ANIM", "anim/flag_post_duster_build.zip"),
    Asset("ANIM", "anim/flag_post_perdy_build.zip"),
    Asset("ANIM", "anim/flag_post_royal_build.zip"),
    Asset("ANIM", "anim/flag_post_wilson_build.zip"), 
	Asset("ANIM", "anim/pig_tower_build.zip"),
	Asset("ANIM", "anim/pig_tower_royal_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
    "splash_sink",
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("stone")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then 
        inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle")
	end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle")
end

local function Towerfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_watchtower.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetBank("pig_shop")
	inst.AnimState:SetBuild("pig_tower_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("pigtower")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function Towerfn1()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_watchtower.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetBank("pig_shop")
	inst.AnimState:SetBuild("pig_tower_build")
	inst.AnimState:AddOverrideBuild("flag_post_perdy_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("pigtower")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"pigskin", "spear", "cutstone"})
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function Towerfn2()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_watchtower.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetBank("pig_shop")
	inst.AnimState:SetBuild("pig_tower_build")
	inst.AnimState:AddOverrideBuild("flag_post_duster_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("pigtower")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"pigskin", "spear", "cutstone"})
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function Towerfn3()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_watchtower.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetBank("pig_shop")
	inst.AnimState:SetBuild("pig_tower_build")
	inst.AnimState:AddOverrideBuild("flag_post_wilson_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("pigtower")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"pigskin", "spear", "cutstone"})
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function PalaceTowerfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
	inst.entity:AddLightWatcher()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_watchtower_palace.tex")
	
	inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(1)
    inst.Light:Enable(false)
    inst.Light:SetColour(180/255, 195/255, 50/255)
	
	inst.AnimState:SetBank("pig_shop")
	inst.AnimState:SetBuild("pig_tower_royal_build")
	inst.AnimState:AddOverrideBuild("flag_post_royal_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("pigtower")
	inst:AddTag("palacetower")
	
	inst:SetPrefabNameOverride("sap_pigpalacetower")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"pigskin", "spear", "cutstone"})
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)

    MakeHauntableWork(inst)
	MakeSnowCovered(inst, .01)

    inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function placetestfn(inst)
    inst.AnimState:Hide("YOTP")
    inst.AnimState:Hide("SNOW")
	inst.ApplySkin = function(inst, skin)
		if skin == "sap_pigtower1" then
			inst.AnimState:AddOverrideBuild("flag_post_perdy_build")
		elseif skin == "sap_pigtower2" then
			inst.AnimState:AddOverrideBuild("flag_post_duster_build")
		elseif skin == "sap_pigtower3" then
			inst.AnimState:AddOverrideBuild("flag_post_wilson_build")
		elseif skin == "sap_pigtower4" then
			inst.AnimState:SetBuild("pig_tower_royal_build")
			inst.AnimState:AddOverrideBuild("flag_post_royal_build")
		end
	end
    return true
end

local function tower1fn(inst)
	inst.AnimState:Hide("YOTP")
    inst.AnimState:Hide("SNOW")
	inst.AnimState:AddOverrideBuild("flag_post_perdy_build")
end

local function tower2fn(inst)
	inst.AnimState:Hide("YOTP")
    inst.AnimState:Hide("SNOW")
	inst.AnimState:AddOverrideBuild("flag_post_duster_build")
end

local function tower3fn(inst)
	inst.AnimState:Hide("YOTP")
    inst.AnimState:Hide("SNOW")
	inst.AnimState:AddOverrideBuild("flag_post_wilson_build")
end

local function tower4fn(inst)
	inst.AnimState:Hide("YOTP")
    inst.AnimState:Hide("SNOW")
	inst.AnimState:SetBuild("pig_tower_royal_build")
	inst.AnimState:AddOverrideBuild("flag_post_royal_build")
end

return Prefab("sap_pigtower", Towerfn, assets, prefabs),
Prefab("sap_pigtower1", Towerfn1, assets, prefabs),
Prefab("sap_pigtower2", Towerfn2, assets, prefabs),
Prefab("sap_pigtower3", Towerfn3, assets, prefabs),
Prefab("sap_pigtower4", PalaceTowerfn, assets, prefabs),
MakePlacer("sap_pigtower_placer", "pig_shop", "pig_tower_build", "idle", false, nil, nil, nil, 90, nil, placetestfn),
MakePlacer("sap_pigtower1_placer", "pig_shop", "pig_tower_build", "idle", false, nil, nil, nil, nil, nil, tower1fn),
MakePlacer("sap_pigtower2_placer", "pig_shop", "pig_tower_build", "idle", false, nil, nil, nil, nil, nil, tower2fn),
MakePlacer("sap_pigtower3_placer", "pig_shop", "pig_tower_build", "idle", false, nil, nil, nil, nil, nil, tower3fn),
MakePlacer("sap_pigtower4_placer", "pig_shop", "pig_tower_royal_build", "idle", false, nil, nil, nil, nil, nil, tower4fn)
--[[,
CreateModPrefabSkin("sap_pigtower1",
	{
		assets = {
			Asset("ANIM", "anim/pig_shop.zip"),
			Asset("ANIM", "anim/pig_tower_build.zip"),
			
			Asset("ANIM", "anim/flag_post_perdy_build.zip"),
		},
		base_prefab = "sap_pigtower",
		fn = Towerfn1,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "flag_post_perdy_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("sap_pigtower2",
	{
		assets = {
			Asset("ANIM", "anim/pig_shop.zip"),
			Asset("ANIM", "anim/pig_tower_build.zip"),
			
			Asset("ANIM", "anim/flag_post_duster_build.zip"),
		},
		base_prefab = "sap_pigtower",
		fn = Towerfn2,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "flag_post_duster_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("sap_pigtower3",
	{
		assets = {
			Asset("ANIM", "anim/pig_shop.zip"),
			Asset("ANIM", "anim/pig_tower_build.zip"),
			
			Asset("ANIM", "anim/flag_post_wilson_build.zip"),
		},
		base_prefab = "sap_pigtower",
		fn = Towerfn3,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "flag_post_wilson_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("sap_pigtower4",
	{
		assets = {
			Asset("ANIM", "anim/pig_shop.zip"),
			Asset("ANIM", "anim/pig_tower_royal_build.zip"),
			
			Asset("ANIM", "anim/flag_post_royal_build.zip"),
		},
		base_prefab = "sap_pigtower",
		fn = PalaceTowerfn,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "flag_post_royal_build",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	})
]]--