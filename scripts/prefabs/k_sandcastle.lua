require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/sand_castle.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"kyno_sandcastle_med",
	"kyno_sandcastle_low",
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
	SpawnPrefab("kyno_sandcastle_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_med(inst, chopper)
	SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
	SpawnPrefab("kyno_sandcastle_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_low(inst, chopper)
	SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("turf_beach").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("cutgrass").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("cutgrass").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("flint").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("sand_castle")
	inst.AnimState:SetBuild("sand_castle")
	inst.AnimState:PlayAnimation("full")
	
	MakeObstaclePhysics(inst, .4)
	
	inst:AddTag("structure")
	inst:AddTag("sandcastle")
	inst:AddTag("sand")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL
	
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
	
	inst.AnimState:SetBank("sand_castle")
	inst.AnimState:SetBuild("sand_castle")
	inst.AnimState:PlayAnimation("med")
	
	MakeObstaclePhysics(inst, .4)
	
	inst:AddTag("structure")
	inst:AddTag("sandcastle")
	inst:AddTag("sand")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
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
	
	inst.AnimState:SetBank("sand_castle")
	inst.AnimState:SetBuild("sand_castle")
	inst.AnimState:PlayAnimation("low")
	
	MakeObstaclePhysics(inst, .4)
	
	inst:AddTag("structure")
	inst:AddTag("sandcastle")
	inst:AddTag("sand")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = TUNING.SANITYAURA_SMALL
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_low)
	inst.components.workable:SetWorkLeft(1)

	return inst
end

return Prefab("kyno_sandcastle", fn, assets, prefabs),
Prefab("kyno_sandcastle_med", medfn, assets, prefabs),
Prefab("kyno_sandcastle_low", lowfn, assets, prefabs),
MakePlacer("kyno_sandcastle_placer", "sand_castle", "sand_castle", "full")