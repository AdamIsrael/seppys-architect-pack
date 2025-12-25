require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/elderdrake_house.zip"),
	Asset("ANIM", "anim/elderdrake_basic.zip"),
	Asset("ANIM", "anim/elderdrake_actions.zip"),
	Asset("ANIM", "anim/elderdrake_attacks.zip"),
    Asset("ANIM", "anim/elderdrake_build.zip"),  
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

prefabs = {
	"kyno_mandrakeman",
}

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
    	inst.AnimState:PlayAnimation("hit")
    	inst.AnimState:PushAnimation("idle")
    end
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("open")
	inst.AnimState:PushAnimation("idle")
    inst.SoundEmitter:PlaySound("dontstarve/common/craftable/rabbit_hutch")
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end
end

local function onload(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
	end
end

local function Happy(inst)
if inst:HasTag("mandrakeman") then
	inst:DoTaskInTime(4+math.random()*5, function() Happy(inst) end)
		inst:DoTaskInTime(0.4, function() inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/elderdrake/clap") end)
		inst:DoTaskInTime(0.6, function() inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/elderdrake/clap") end)
		inst:DoTaskInTime(0.8, function() inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/elderdrake/clap") end)
		inst:DoTaskInTime(1.0, function() inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/elderdrake/clap") end)
		inst:DoTaskInTime(1.2, function() inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/elderdrake/clap") end)
		inst:DoTaskInTime(1.4, function() inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/elderdrake/clap") end)
		inst:DoTaskInTime(1.6, function() inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/elderdrake/clap") end)
		inst.AnimState:PlayAnimation("idle_happy")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/elderdrake/idle_happy")
		inst.AnimState:PushAnimation("idle_loop", true)
	end
end

local mandrake_front = 1

local mandrake_defs = {
	mandrake = { { -1.30, 0, 2.50 } },
}

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_mandrakehouse.tex")
	
	inst.AnimState:SetBank("elderdrake_house")
	inst.AnimState:SetBuild("elderdrake_house")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("structure")
	inst:AddTag("mandrake_shelter")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local decor_items = mandrake_defs
		inst.decor = {}
		for item_name, data in pairs(decor_items) do
			for l, offset in pairs(data) do
				local item_inst = SpawnPrefab("kyno_mandrakeman")
				item_inst.AnimState:PushAnimation("idle_loop", true)
				item_inst.entity:SetParent(inst.entity)
				item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
				table.insert(inst.decor, item_inst)
			end
		end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
   
	inst:AddComponent("savedrotation")
   
	MakeSnowCovered(inst, 0.01)
   
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

local function mandrakefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	inst.DynamicShadow:SetSize(1.5, .75)
	inst.Transform:SetFourFaced()
	
	MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetBank("elderdrake")
	inst.AnimState:SetBuild("elderdrake_build")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.persists = false
		
	inst:AddTag("mandrakeman")
	inst:AddTag("animal")	
	inst:AddTag("mediumcreature")	
	inst:AddTag("rotatableobject")
		
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("savedrotation")
	
	Happy(inst)

	return inst
end

return Prefab("kyno_mandrakehouse", fn, assets, prefabs),
Prefab("kyno_mandrakeman", mandrakefn, assets, prefabs),
MakePlacer("kyno_mandrakehouse_placer", "elderdrake_house", "elderdrake_house", "idle", false, nil, nil, nil, 90, nil)