require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_gardenbox.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"petals",
	"petals_evil",
	"foliage",
	"succulent_picked",
	"cutgrass",
	"stinger",
	"boards",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
    local rotation = inst.Transform:GetRotation()
    inst.Transform:SetRotation((rotation + 180) % 360)
end

local function common(burnable, save_rotation, isevil, isflower)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("kyno_gardenbox")
    inst.AnimState:SetBuild("kyno_gardenbox")
    
	inst:AddTag("structure")
	inst:AddTag("gardenbox")
	
	if save_rotation then
		inst.Transform:SetTwoFaced()
	end
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	-- inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	if isevil then
		inst:AddComponent("sanityaura")
		inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL
	end
	
	if isflower then
		inst:AddComponent("sanityaura")
		inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL
	end
	
	if save_rotation then
		inst:AddComponent("savedrotation")
	end
	
	MakeHauntableWork(inst)
	
	if burnable then
		MakeMediumBurnable(inst)
		MakeMediumPropagator(inst)
	end
	
    return inst
end

local function flower1()
	local inst = common(true, true, false, true)
    inst.AnimState:PlayAnimation("idle_flower1")
	inst:AddTag("flower")
    return inst
end

local function flower2()
	local inst = common(true, true, false, true)
    inst.AnimState:PlayAnimation("idle_flower2")
	inst:AddTag("flower")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "petals"})
	
    return inst
end

local function flower3()
	local inst = common(true, true, false, true)
    inst.AnimState:PlayAnimation("idle_flower3")
	inst:AddTag("flower")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "petals"})
	
    return inst
end

local function fern1()
	local inst = common(true, true, false, false)
	inst.AnimState:PlayAnimation("idle_fern1")
	return inst
end

local function fern2()
	local inst = common(true, true, false, false)
	inst.AnimState:PlayAnimation("idle_fern2")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "foliage"})
	
	
	return inst
end

local function fern3()
	local inst = common(true, true, false, false)
	inst.AnimState:PlayAnimation("idle_fern3")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "foliage"})
	
	return inst
end

local function succulent1()
	local inst = common(true, true, false, false)
	inst.AnimState:PlayAnimation("idle_succulent1")
	return inst
end

local function succulent2()
	local inst = common(true, true, false, false)
	inst.AnimState:PlayAnimation("idle_succulent2")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "succulent_picked"})
	
	return inst
end

local function rose()
	local inst = common(true, true, false, true)
	inst.AnimState:PlayAnimation("idle_rose")
	inst:AddTag("flower")
	return inst
end

local function exotic1()
	local inst = common(true, true, false, true)
	inst.AnimState:PlayAnimation("idle_exotic1")
	inst:AddTag("flower")
	return inst
end

local function exotic2()
	local inst = common(true, true, false, true)
	inst.AnimState:PlayAnimation("idle_exotic2")
	inst:AddTag("flower")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "petals"})
	
	return inst
end

local function exotic3()
	local inst = common(true, true, false, true)
	inst.AnimState:PlayAnimation("idle_exotic3")
	inst:AddTag("flower")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "petals"})
	
	return inst
end

local function exotic4()
	local inst = common(true, true, false, true)
	inst.AnimState:PlayAnimation("idle_exotic4")
	inst:AddTag("flower")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "petals"})
	
	return inst
end

local function exotic5()
	local inst = common(true, true, false, true)
	inst.AnimState:PlayAnimation("idle_exotic5")
	inst:AddTag("flower")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "petals"})
	
	return inst
end

local function withered()
	local inst = common(true, true, false, false)
	inst.AnimState:PlayAnimation("idle_withered")
	return inst
end

local function evil1()
	local inst = common(true, true, true, false)
	inst.AnimState:PlayAnimation("idle_evil1")
	inst:AddTag("flower")
	return inst
end

local function evil2()
	local inst = common(true, true, true, false)
	inst.AnimState:PlayAnimation("idle_evil2")
	inst:AddTag("flower")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.lootdropper:SetLoot({"boards", "petals_evil"})
	
	return inst
end

local function empty()
	local inst = common(true, true, false, false)
	inst.AnimState:PlayAnimation("idle_empty")
	return inst
end

local function flower1fn(inst)
	inst.ApplySkin = function(inst, skin)
		if skin == "kyno_gardenbox_flower2" then
			inst.AnimState:PlayAnimation("idle_flower2")
		elseif skin == "kyno_gardenbox_flower3" then
			inst.AnimState:PlayAnimation("idle_flower3")
		end
	end
    return true
end

local function fern1fn(inst)
	inst.ApplySkin = function(inst, skin)
		if skin == "kyno_gardenbox_fern2" then
			inst.AnimState:PlayAnimation("idle_fern2")
		elseif skin == "kyno_gardenbox_flower3" then
			inst.AnimState:PlayAnimation("idle_fern3")
		end
	end
    return true
end

local function succulent1fn(inst)
	inst.ApplySkin = function(inst, skin)
		if skin == "kyno_gardenbox_succulent2" then
			inst.AnimState:PlayAnimation("idle_succulent2")
		end
	end
    return true
end

local function exotic1fn(inst)
	inst.ApplySkin = function(inst, skin)
		if skin == "kyno_gardenbox_exotic2" then
			inst.AnimState:PlayAnimation("idle_exotic2")
		elseif skin == "kyno_gardenbox_exotic3" then
			inst.AnimState:PlayAnimation("idle_exotic3")
		elseif skin == "kyno_gardenbox_exotic4" then
			inst.AnimState:PlayAnimation("idle_exotic4")
		elseif skin == "kyno_gardenbox_exotic5" then
			inst.AnimState:PlayAnimation("idle_exotic5")
		end
	end
    return true
end

local function evil1fn(inst)
	inst.ApplySkin = function(inst, skin)
		if skin == "kyno_gardenbox_evil2" then
			inst.AnimState:PlayAnimation("idle_evil2")
		end
	end
    return true
end

return Prefab("kyno_gardenbox_flower1", flower1, assets, prefabs),
Prefab("kyno_gardenbox_flower2", flower2, assets, prefabs),
Prefab("kyno_gardenbox_flower3", flower3, assets, prefabs),
Prefab("kyno_gardenbox_fern1", fern1, assets, prefabs),
Prefab("kyno_gardenbox_fern2", fern2, assets, prefabs),
Prefab("kyno_gardenbox_fern3", fern3, assets, prefabs),
Prefab("kyno_gardenbox_succulent1", succulent1, assets, prefabs),
Prefab("kyno_gardenbox_succulent2", succulent2, assets, prefabs),
Prefab("kyno_gardenbox_rose", rose, assets, prefabs),
Prefab("kyno_gardenbox_exotic1", exotic1, assets, prefabs),
Prefab("kyno_gardenbox_exotic2", exotic2, assets, prefabs),
Prefab("kyno_gardenbox_exotic3", exotic3, assets, prefabs),
Prefab("kyno_gardenbox_exotic4", exotic4, assets, prefabs),
Prefab("kyno_gardenbox_exotic5", exotic5, assets, prefabs),
Prefab("kyno_gardenbox_withered", withered, assets, prefabs),
Prefab("kyno_gardenbox_evil1", evil1, assets, prefabs),
Prefab("kyno_gardenbox_evil2", evil2, assets, prefabs),
Prefab("kyno_gardenbox_empty", empty, assets, prefabs),
MakePlacer("kyno_gardenbox_flower1_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_flower1", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_flower2_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_flower2", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_flower3_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_flower3", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_fern1_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_fern1", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_fern2_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_fern2", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_fern3_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_fern3", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_succulent1_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_succulent1", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_succulent2_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_succulent2", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_rose_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_rose", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_exotic1_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_exotic1", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_exotic2_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_exotic2", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_exotic3_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_exotic3", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_exotic4_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_exotic4", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_exotic5_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_exotic5", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_withered_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_withered", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_evil1_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_evil1", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_evil2_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_evil2", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_empty_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_empty", false, true, nil, nil, nil, "two")
--[[
MakePlacer("kyno_gardenbox_flower1_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_flower1", false, true, nil, nil, nil, "two", flower1fn),
MakePlacer("kyno_gardenbox_fern1_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_fern1", false, true, nil, nil, nil, "two", fern1fn),
MakePlacer("kyno_gardenbox_succulent1_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_succulent1", false, true, nil, nil, nil, "two", succulent1fn),
MakePlacer("kyno_gardenbox_exotic1_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_exotic1", false, true, nil, nil, nil, "two", exotic1fn),
MakePlacer("kyno_gardenbox_evil1_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_evil1", false, true, nil, nil, nil, "two", evil1fn),
MakePlacer("kyno_gardenbox_rose_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_rose", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_withered_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_withered", false, true, nil, nil, nil, "two"),
MakePlacer("kyno_gardenbox_empty_placer", "kyno_gardenbox", "kyno_gardenbox", "idle_empty", false, true, nil, nil, nil, "two"),

CreateModPrefabSkin("kyno_gardenbox_flower2",
	{
		assets = {
			Asset("ANIM", "anim/kyno_gardenbox.zip"),
		},
		base_prefab = "kyno_gardenbox_flower1",
		fn = flower2,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "kyno_gardenbox",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_gardenbox_flower3",
	{
		assets = {
			Asset("ANIM", "anim/kyno_gardenbox.zip"),
		},
		base_prefab = "kyno_gardenbox_flower1",
		fn = flower3,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "kyno_gardenbox",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_gardenbox_fern2",
	{
		assets = {
			Asset("ANIM", "anim/kyno_gardenbox.zip"),
		},
		base_prefab = "kyno_gardenbox_fern1",
		fn = fern2,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "kyno_gardenbox",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_gardenbox_fern3",
	{
		assets = {
			Asset("ANIM", "anim/kyno_gardenbox.zip"),
		},
		base_prefab = "kyno_gardenbox_fern1",
		fn = fern3,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "kyno_gardenbox",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_gardenbox_succulent2",
	{
		assets = {
			Asset("ANIM", "anim/kyno_gardenbox.zip"),
		},
		base_prefab = "kyno_gardenbox_succulent1",
		fn = succulent2,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "kyno_gardenbox",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_gardenbox_exotic2",
	{
		assets = {
			Asset("ANIM", "anim/kyno_gardenbox.zip"),
		},
		base_prefab = "kyno_gardenbox_exotic1",
		fn = exotic2,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "kyno_gardenbox",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_gardenbox_exotic3",
	{
		assets = {
			Asset("ANIM", "anim/kyno_gardenbox.zip"),
		},
		base_prefab = "kyno_gardenbox_exotic1",
		fn = exotic3,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "kyno_gardenbox",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_gardenbox_exotic4",
	{
		assets = {
			Asset("ANIM", "anim/kyno_gardenbox.zip"),
		},
		base_prefab = "kyno_gardenbox_exotic1",
		fn = exotic4,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "kyno_gardenbox",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_gardenbox_exotic5",
	{
		assets = {
			Asset("ANIM", "anim/kyno_gardenbox.zip"),
		},
		base_prefab = "kyno_gardenbox_exotic1",
		fn = exotic5,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "kyno_gardenbox",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	}),
CreateModPrefabSkin("kyno_gardenbox_evil2",
	{
		assets = {
			Asset("ANIM", "anim/kyno_gardenbox.zip"),
		},
		base_prefab = "kyno_gardenbox_evil1",
		fn = evil2,
		rarity = "Timeless",
		reskinable = true,
		
		build_name_override = "kyno_gardenbox",
		
		type = "item",
		skin_tags = { },
		release_group = 0,
	})
]]--