require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/grass_tall.zip"),
	Asset("ANIM", "anim/yellow_grass_tall.zip"),
}

local prefabs = {}

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
    inst.AnimState:PlayAnimation("picking")
    inst.AnimState:PushAnimation("idle", true)
	-- inst:RemoveTag("tall_grass")
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("grow")
    inst.AnimState:PushAnimation("idle", true)
	-- inst:AddTag("tall_grass")
end

local function makeemptyfn(inst)
    inst.AnimState:PushAnimation("idle", true)
	-- inst:RemoveTag("tall_grass")
end

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("dug_grass")
	inst.components.lootdropper:SpawnLootPrefab("poop")
	inst:Remove()
end

local function DoRustle(inst)
if inst:HasTag("tall_grass") then
	inst:DoTaskInTime(4+math.random()*5, function() DoRustle(inst) end)
		inst.AnimState:PlayAnimation("rustle")
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("grow")
	inst.AnimState:PushAnimation("idle", true)
	-- inst:AddTag("tall_grass")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_grass_green.tex")
	
	inst.AnimState:SetBank("grass_tall")
	inst.AnimState:SetBuild("grass_tall")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("tall_grass")
	-- inst:AddTag("plant")
	-- inst:AddTag("silviculture")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	--[[
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
    inst.components.pickable:SetUp("cutgrass", TUNING.GRASS_REGROW_TIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	
    MakeNoGrowInWinter(inst)
	]]--

	inst:ListenForEvent("onbuilt", onbuilt)
	
	DoRustle(inst)

	return inst
end

local function yellowfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("grass.png")
	
	inst.AnimState:SetBank("yellow_grass_tall")
	inst.AnimState:SetBuild("yellow_grass_tall")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("tall_grass")
	-- inst:AddTag("plant")
	-- inst:AddTag("silviculture")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	--[[
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
    inst.components.pickable:SetUp("cutgrass", TUNING.GRASS_REGROW_TIME)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	
    MakeNoGrowInWinter(inst)
	]]--
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	DoRustle(inst)

	return inst
end

return Prefab("sap_tallgrass", fn, assets, prefabs),
Prefab("sap_tallgrass_yellow", yellowfn, assets, prefabs),
MakePlacer("sap_tallgrass_placer", "grass_tall", "grass_tall", "idle"),
MakePlacer("sap_tallgrass_yellow_placer", "yellow_grass_tall", "yellow_grass_tall", "idle")
