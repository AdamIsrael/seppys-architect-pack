require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/roc_junk.zip"),   
    Asset("ANIM", "anim/roc_egg_shells.zip"),   
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local stick_loot = {
	{"twigs", 2},
}

local rock_loot = {
    {"rocks",2},
} 

local tree_loot = {
    {"log",3}
} 
local branch_loot = {
    {"twigs",3}
}
local house_loot = {
    {"cutstone",1},
    {"boards",1}
}
local lamp_loot = {
    {"cutstone",1},    
    {"transistor",1},    
}

local function onpickedfn(inst)
    inst:Remove()
end

local function onworked(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onwork(inst, worker)
    inst.AnimState:PlayAnimation(inst.animname.."_hit")
    inst.AnimState:PushAnimation(inst.animname)

    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")  
end

local function onsave(inst, data)    
    local references = {}
    data.rotation = inst.Transform:GetRotation()
    return references
end

local function onload(inst, data)
    if data and data.rotation then
        inst.rotation = data.rotation
        inst.Transform:SetRotation(data.rotation)
    end
end	

local function workable(file, anim, action, loot, lootmax, minimap, eightfaced)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetEightFaced()

	if minimap then
        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon(minimap)
    end
	
	inst.animname = anim
	
	inst.AnimState:SetBank(file)
	inst.AnimState:SetBuild(file)
	inst.AnimState:PlayAnimation(anim)
	
	inst:AddTag("structure")
	inst:AddTag("BFB_junk")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    if action == ACTIONS.HAMMER or action == ACTIONS.CHOP or action == ACTIONS.MINE then
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(action)
        inst.components.workable:SetWorkLeft(3)
        inst.components.workable:SetOnFinishCallback(onworked)
        inst.components.workable:SetOnWorkCallback(onwork)
	elseif  action == ACTIONS.PICK then
        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"        
        inst.components.pickable:SetUp("twigs")
        inst.components.pickable.onpickedfn = onpickedfn
	end
	
	inst.OnSave = onsave 
	inst.OnLoad = onload

	return inst
end

return Prefab("sap_nest_egg1", function() return workable("roc_egg_shells",  "shell1", ACTIONS.MINE, rock_loot, 3) end, assets, prefabs ),
	MakePlacer("sap_nest_egg1_placer", "roc_egg_shells", "roc_egg_shells", "shell1"),
	
    Prefab("sap_nest_egg2",       function() return workable("roc_egg_shells",  "shell2", ACTIONS.MINE, rock_loot, 3) end, assets, prefabs ),
	MakePlacer("sap_nest_egg2_placer", "roc_egg_shells", "roc_egg_shells", "shell2"),
	
    Prefab("sap_nest_egg3",       function() return workable("roc_egg_shells",  "shell3", ACTIONS.MINE, rock_loot, 3) end, assets, prefabs ),
	MakePlacer("sap_nest_egg3_placer", "roc_egg_shells", "roc_egg_shells", "shell3"),
	
    Prefab("sap_nest_egg4",       function() return workable("roc_egg_shells",  "shell4", ACTIONS.MINE, rock_loot, 3) end, assets, prefabs ),
	MakePlacer("sap_nest_egg4_placer", "roc_egg_shells", "roc_egg_shells", "shell4"),
	
    Prefab("sap_nest_tree1",      function() return workable("roc_junk", "tree1",      ACTIONS.CHOP, tree_loot,    1, "kyno_roc_tree1.tex"      ) end, assets, prefabs ),
	MakePlacer("sap_nest_tree1_placer", "roc_junk", "roc_junk", "tree1"),
	
    Prefab("sap_nest_tree2",      function() return workable("roc_junk", "tree2",      ACTIONS.CHOP, tree_loot,    1, "kyno_roc_tree2.tex"      ) end, assets, prefabs ),
	MakePlacer("sap_nest_tree2_placer", "roc_junk", "roc_junk", "tree2"),
	
    Prefab("sap_nest_bush",       function() return workable("roc_junk", "bush",       ACTIONS.PICK, "cutgrass", nil, "kyno_roc_bush.tex"       ) end, assets, prefabs ),
	MakePlacer("sap_nest_bush_placer", "roc_junk", "roc_junk", "bush"),
	
    Prefab("sap_nest_branch1",    function() return workable("roc_junk", "branch1",    ACTIONS.CHOP, branch_loot,  1, "kyno_roc_branch1.tex"    ) end, assets, prefabs ),
	MakePlacer("sap_nest_branch1_placer", "roc_junk", "roc_junk", "branch1"),
	
    Prefab("sap_nest_branch2",    function() return workable("roc_junk", "branch2",    ACTIONS.CHOP, branch_loot,  1, "kyno_roc_branch2.tex"    ) end, assets, prefabs ),
	MakePlacer("sap_nest_branch2_placer", "roc_junk", "roc_junk", "branch2"),
	
    Prefab("sap_nest_trunk",      function() return workable("roc_junk", "trunk",      ACTIONS.CHOP, tree_loot,    1, "kyno_roc_trunk.tex"      ) end, assets, prefabs ),
	MakePlacer("sap_nest_trunk_placer", "roc_junk", "roc_junk", "trunk"),
	
    Prefab("sap_nest_house",      function() return workable("roc_junk", "house",      ACTIONS.HAMMER, house_loot, 3, "kyno_roc_house.tex"      ) end, assets, prefabs ),
	MakePlacer("sap_nest_house_placer", "roc_junk", "roc_junk", "house"),
	
    Prefab("sap_nest_rusty_lamp", function() return workable("roc_junk", "rusty_lamp", ACTIONS.HAMMER, lamp_loot,  2, "kyno_roc_lamp.tex" ) end, assets, prefabs ),
	MakePlacer("sap_nest_rusty_lamp_placer", "roc_junk", "roc_junk", "rusty_lamp"),
	
    Prefab("sap_nest_debris1",    function() return workable("roc_junk", "stick01",    ACTIONS.PICK, "twigs", 2, nil, true) end, assets, prefabs ),
	MakePlacer("sap_nest_debris1_placer", "roc_junk", "roc_junk", "stick01"),
	
    Prefab("sap_nest_debris2",    function() return workable("roc_junk", "stick02",    ACTIONS.PICK, "twigs", 2, nil, true) end, assets, prefabs ),
	MakePlacer("sap_nest_debris2_placer", "roc_junk", "roc_junk", "stick02"),
	
    Prefab("sap_nest_debris3",    function() return workable("roc_junk", "stick03",    ACTIONS.PICK, "twigs", 2, nil, true) end, assets, prefabs ),
	MakePlacer("sap_nest_debris3_placer", "roc_junk", "roc_junk", "stick03"),
	
    Prefab("sap_nest_debris4",    function() return workable("roc_junk", "stick04",    ACTIONS.PICK, "twigs", 2, nil, true) end, assets, prefabs ),
	MakePlacer("sap_nest_debris4_placer", "roc_junk", "roc_junk", "stick04")