require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/sand_dune.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"kyno_sandhill_med",
	"kyno_sandhill_low",
	"sand_puff",
}

--[[
local anims = {"low", "med", "full"}

local function dig_up(inst, worker, workleft)
    print("workleft", workleft)

    if workleft == 0 then
        -- last time
        -- inst.components.lootdropper:SetLoot({"turf_desertdirt"}) Craftable from Tab.

        -- figure out which side to drop the loot
        local pt = Vector3(inst.Transform:GetWorldPosition())
        local hispos = Vector3(worker.Transform:GetWorldPosition())

        local he_right = ((hispos - pt):Dot(TheCamera:GetRightVec()) > 0)
        
        if he_right then
            inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec()*(.5+math.random())))
        else
            inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec()*(.5+math.random())))
        end
        inst:Remove()
    else
        print("PlayAnimation", workleft, anims[workleft])
        inst.AnimState:PlayAnimation(anims[workleft])
    end
end
]]--

local function dig_up_full(inst, chopper)
	SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
	SpawnPrefab("kyno_sandhill_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_med(inst, chopper)
	SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
	SpawnPrefab("kyno_sandhill_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_low(inst, chopper)
	SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("turf_beach").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function fullfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("sand_dune")
	inst.AnimState:SetBuild("sand_dune")
	inst.AnimState:PlayAnimation("full")
	
	inst:AddTag("structure")
	inst:AddTag("sand")
	
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
	inst.components.workable:SetOnWorkCallback(dig_up_full)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

local function medfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("sand_dune")
	inst.AnimState:SetBuild("sand_dune")
	inst.AnimState:PlayAnimation("med")
	
	inst:AddTag("structure")
	inst:AddTag("sand")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_med)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

local function lowfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("sand_dune")
	inst.AnimState:SetBuild("sand_dune")
	inst.AnimState:PlayAnimation("low")
	
	inst:AddTag("structure")
	inst:AddTag("sand")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_low)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

return Prefab("kyno_sandhill", fullfn, assets, prefabs),
Prefab("kyno_sandhill_med", medfn, assets, prefabs),
Prefab("kyno_sandhill_low", lowfn, assets, prefabs),
MakePlacer("kyno_sandhill_placer", "sand_dune", "sand_dune", "full")