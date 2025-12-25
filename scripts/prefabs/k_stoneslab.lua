require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/rock_flipping.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/2) then
		inst.AnimState:PushAnimation("idle", true)
	elseif workleft < TUNING.ROCKS_MINE*(2/2) then
		inst.AnimState:PushAnimation("idle", true)
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function ontransplantfn(inst)
	inst.components.pickable:MakeBarren()
end

local function wobble(inst)
	if inst.AnimState:IsCurrentAnimation("idle") then
		inst.AnimState:PlayAnimation("wobble")
		inst.AnimState:PushAnimation("idle")
	end
end

local function dowobbletest(inst)
	if math.random() < 0.5 then
		wobble(inst)
	end
end

local function onpickedfn(inst, picker)
	inst.AnimState:PlayAnimation("flip_over", false)
	-- local pt = Point(inst.Transform:GetWorldPosition())
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/harvested/flipping_rock/open")
	-- inst.components.lootdropper:DropLoot()
	inst.flipped = true
end

local function makefullfn(inst)
end

local function onsave(inst, data)
	if inst.flipped then
		data.flipped = true
	end
end

local function onload(inst, data)
	if data and data.makebarren then
		makebarrenfn(inst)
		inst.components.pickable:MakeBarren()
	end
	if data and data.flipped then
		inst.flipped = true
		inst.AnimState:PlayAnimation("idle_flipped")
	end
end

local function OnEntitySleep(inst)
	if inst.fliptask then
		inst.fliptask:Cancel()
		inst.fliptask = nil
	end
end

local function OnEntityWake(inst)
	if inst.fliptask then
		inst.fliptask:Cancel()
	end
	inst.fliptask = inst:DoPeriodicTask(10+(math.random()*10),function() dowobbletest(inst) end)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_stoneslab.tex")
	
	inst.AnimState:SetBank("flipping_rock")
	inst.AnimState:SetBuild("rock_flipping")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, .1)
	
	inst:AddTag("structure")
	inst:AddTag("rockslab")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("pickable")
	inst.components.pickable:SetUp(nil, nil)	
	inst.components.pickable.onpickedfn = onpickedfn
	inst.components.pickable.makefullfn = makefullfn
	inst.components.pickable.ontransplantfn = ontransplantfn
	inst.components.pickable.quickpick = true
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	inst.OnEntitySleep = OnEntitySleep
    inst.OnEntityWake = OnEntityWake
	
	return inst
end

return Prefab("kyno_stoneslab", fn, assets, prefabs),
MakePlacer("kyno_stoneslab_placer", "flipping_rock", "rock_flipping", "idle")