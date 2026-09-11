require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/doydoy_nest.zip"),
	Asset("ANIM", "anim/doydoy.zip"),
	Asset("ANIM", "anim/doydoy_adult_build.zip"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs = 
{
	"sap_doydoy",
}

local function onhammered(inst)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit_nest")
	inst.AnimState:PushAnimation("idle_nest")
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("idle_nest")
	inst.AnimState:PushAnimation("idle_nest")
end

--[[
local function peck(inst)
if inst:HasTag("doydoy") then
	inst:DoTaskInTime(4+math.random()*5, function() peck(inst) end)
		inst.AnimState:PlayAnimation("peck")
		inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/teen_doy_doy/idle")
		inst.AnimState:PushAnimation("idle", true)
	end
end
]]--

local doydoy_front = 1

local doydoy_defs = {
	doydoy = { { -1.28, 0, 1.14 } },
}

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_doydoynest.tex")
	
	inst.AnimState:SetBank("doydoy_nest")
	inst.AnimState:SetBuild("doydoy_nest")
	inst.AnimState:PlayAnimation("idle_nest", true)
	
	MakeObstaclePhysics(inst, 0.25)
	
	inst:AddTag("doydoy")
	inst:AddTag("doydoynest")
	inst:AddTag("structure")
	inst:AddTag("fullnest")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	--[[
	local decor_items = doydoy_defs
		inst.decor = {}
		for item_name, data in pairs(decor_items) do
			for l, offset in pairs(data) do
				local item_inst = SpawnPrefab("sap_doydoy")
				item_inst.AnimState:PushAnimation("idle", true)
				item_inst.entity:SetParent(inst.entity)
				item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
				table.insert(inst.decor, item_inst)
			end
		end
	]]--
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

--[[
local function doydoyfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	inst.DynamicShadow:SetSize(2, .6)
	inst.Transform:SetFourFaced()
	
	MakeObstaclePhysics(inst, .5)
	
	inst.AnimState:SetBank("doydoy")
	inst.AnimState:SetBuild("doydoy_adult_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.persists = false
		
	inst:AddTag("doydoy")
	inst:AddTag("animal")	
	inst:AddTag("smallcreature")	
		
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	peck(inst)

	return inst
end
]]--

return Prefab("sap_doydoy_nest", fn, assets, prefabs),
-- Prefab("kyno_doydoy", doydoyfn, assets, prefabs),
MakePlacer("sap_doydoy_nest_placer", "doydoy_nest", "doydoy_nest", "idle_nest")