require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/pig_ruins_entrance.zip"),
    Asset("ANIM", "anim/pig_door_test.zip"), 
    Asset("ANIM", "anim/pig_ruins_entrance_build.zip"),
    Asset("ANIM", "anim/pig_ruins_entrance_top_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"collapse_small"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit_low")
    inst.AnimState:PushAnimation("hit_low")
end

local function refreshImage(inst,push)
    local anim = "idle_low"
    if inst.stage == 2 then 
        anim = "idle_low"
    elseif inst.stage == 1 then 
        anim = "idle_low"
    elseif inst.stage == 0 then 
        anim = "idle_low"
    end

    if inst:HasTag("top_ornament") then
        inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
        inst.AnimState:Hide("swap_ornament2")
        inst.AnimState:Hide("swap_ornament3")
        inst.AnimState:Hide("swap_ornament4")        
    elseif inst:HasTag("top_ornament2") then
        inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
        inst.AnimState:Hide("swap_ornament3")
        inst.AnimState:Hide("swap_ornament4")
        inst.AnimState:Hide("swap_ornament")
    elseif inst:HasTag("top_ornament3") then
        inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
        inst.AnimState:Hide("swap_ornament2")
        inst.AnimState:Hide("swap_ornament4")
        inst.AnimState:Hide("swap_ornament")
    elseif inst:HasTag("top_ornament4") then
        inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
        inst.AnimState:Hide("swap_ornament2")
        inst.AnimState:Hide("swap_ornament3")
        inst.AnimState:Hide("swap_ornament")        
    else
        inst.AnimState:Hide("swap_ornament4")
        inst.AnimState:Hide("swap_ornament3")
        inst.AnimState:Hide("swap_ornament2")
        inst.AnimState:Hide("swap_ornament")
        inst.AnimState:OverrideSymbol("statue_01", "pig_ruins_entrance", "")                
        inst.AnimState:OverrideSymbol("swap_ornament", "pig_ruins_entrance", "")                             
    end

    if push then
        inst.AnimState:PushAnimation(anim, true)
    else
        inst.AnimState:PlayAnimation(anim, true)
    end
end

local function onsave(inst, data)
    data.stage = inst.stage
    if inst:HasTag("top_ornament") then
        data.top_ornament = true
    end
    if inst:HasTag("top_ornament2") then
        data.top_ornament2 = true
    end
    if inst:HasTag("top_ornament3") then
        data.top_ornament3 = true
    end        
end

local function onload(inst, data)
    if data then
        if data.stage then
            inst.stage = data.stage
        end
        if data.top_ornament then
            inst:AddTag("top_ornament")
        end
        if data.top_ornament2 then
            inst:AddTag("top_ornament2")
        end
        if data.top_ornament3 then
            inst:AddTag("top_ornament3")
        end
    end
    
    refreshImage(inst)
end

local function makefn(name, dungeonname)
	local function fn(Sim)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_pigruins_entrance.tex")

    inst.AnimState:SetBank("pig_ruins_entrance")
    inst.AnimState:SetBuild("pig_ruins_entrance_build")
    inst.AnimState:PlayAnimation("idle_low", true)
	
	MakeObstaclePhysics(inst, 1.20)

	inst:AddTag("structure")
	inst:AddTag("ruins_entrance")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	if dungeonname == "RUINS_1" then
		inst:AddTag("top_ornament") 
	elseif dungeonname == "RUINS_2" then
		inst:AddTag("top_ornament2") 
	elseif dungeonname == "RUINS_3" then
		inst:AddTag("top_ornament3") 
	elseif dungeonname == "RUINS_4" or dungeonname == "RUINS_5" then
		inst:AddTag("top_ornament4")
	elseif dungeonname == "RUINS_6" then
		inst:AddTag("top_smallornament")
	end
	
	MakeSnowCovered(inst, .01)
	refreshImage(inst)
	inst.OnSave = onsave
	inst.OnLoad = onload

    return inst
	end
return fn
end

local function ruins_1_placetestfn(inst)
	inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
	inst.AnimState:Show("swap_ornament")
	inst.AnimState:Hide("swap_ornament2")
	inst.AnimState:Hide("swap_ornament3")
	inst.AnimState:Hide("swap_ornament4")
end   

local function ruins_2_placetestfn(inst)
	inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
	inst.AnimState:Show("swap_ornament2")
	inst.AnimState:Hide("swap_ornament")
	inst.AnimState:Hide("swap_ornament3")
	inst.AnimState:Hide("swap_ornament4")
end

local function ruins_3_placetestfn(inst)
	inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
	inst.AnimState:Show("swap_ornament3")
	inst.AnimState:Hide("swap_ornament")
	inst.AnimState:Hide("swap_ornament2")
	inst.AnimState:Hide("swap_ornament4")
end
	
local function ruins_4_placetestfn(inst)
	inst.AnimState:AddOverrideBuild("pig_ruins_entrance_top_build")
	inst.AnimState:Show("swap_ornament4")
	inst.AnimState:Hide("swap_ornament3")
	inst.AnimState:Hide("swap_ornament2")
	inst.AnimState:Hide("swap_ornament")
end

return Prefab("sap_pigruins1", makefn("pig_ruins_entrance", "RUINS_1"), assets, prefabs),
MakePlacer("sap_pigruins1_placer", "pig_ruins_entrance", "pig_ruins_entrance_build", "idle_low", false, nil, nil, nil, nil, nil, ruins_1_placetestfn), 

Prefab("sap_pigruins2", makefn("pig_ruins_entrance", "RUINS_2"), assets, prefabs),
MakePlacer("sap_pigruins2_placer", "pig_ruins_entrance", "pig_ruins_entrance_build", "idle_low", false, nil, nil, nil, nil, nil, ruins_2_placetestfn),

Prefab("sap_pigruins3", makefn("pig_ruins_entrance", "RUINS_3"), assets, prefabs),
MakePlacer("sap_pigruins3_placer", "pig_ruins_entrance", "pig_ruins_entrance_build", "idle_low", false, nil, nil, nil, nil, nil, ruins_3_placetestfn),

Prefab("sap_pigruins4", makefn("pig_ruins_entrance", "RUINS_4"), assets, prefabs),
MakePlacer("sap_pigruins4_placer", "pig_ruins_entrance", "pig_ruins_entrance_build", "idle_low", false, nil, nil, nil, nil, nil, ruins_4_placetestfn),

-- This Prefab actually doesn't exists.
Prefab("sap_pigruins5", makefn("pig_ruins_entrance", "RUINS_5"), assets, prefabs),
MakePlacer("sap_pigruins5_placer", "pig_ruins_entrance", "pig_ruins_entrance_build", "idle_low"),

Prefab("sap_pigruinssmall", makefn("pig_ruins_entrance", "RUINS_6"), assets, prefabs),
MakePlacer("sap_pigruinssmall_placer", "pig_ruins_entrance", "pig_ruins_entrance_build", "idle_low")
