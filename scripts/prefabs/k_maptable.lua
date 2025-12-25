require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/map_table.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
	SpawnPrefab("kyno_maptable_broken").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onhammered_broken(inst)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/common/winter_meter_craft")
end

local function OnActivate(inst, doer)
	local mapscroll = SpawnPrefab("mapscroll")
    local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0,2,0)
    mapscroll.Transform:SetPosition(pt:Get())
    local down = TheCamera:GetDownVec()
    local angle = math.atan2(down.z, down.x) + (math.random()*60)*DEGREES
    local sp = 3 + math.random()
    mapscroll.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cartographydesk.png")
	
	MakeObstaclePhysics(inst, .4)
	
	inst.AnimState:SetBank("map_table")
	inst.AnimState:SetBuild("map_table")
	inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("structure")
	inst:AddTag("mapeador")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
		
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	--[[
	inst:AddComponent("activatable")
    inst.components.activatable.quickaction = true
    inst.components.activatable.OnActivate = OnActivate
	]]--
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function brokenfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cartographydesk.png")
	
	MakeObstaclePhysics(inst, .4)
	
	inst.AnimState:SetBank("map_table")
	inst.AnimState:SetBuild("map_table")
	inst.AnimState:PlayAnimation("broken")
	
	inst:AddTag("structure")
	inst:AddTag("mapeador")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
		
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered_broken)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)

	return inst
end

return Prefab("kyno_maptable", fn, assets, prefabs),
Prefab("kyno_maptable_broken", brokenfn, assets, prefabs),
MakePlacer("kyno_maptable_placer", "map_table", "map_table", "idle")