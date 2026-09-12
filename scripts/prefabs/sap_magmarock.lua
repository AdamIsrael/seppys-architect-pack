require "prefabutil"

local assets_magma =
{
	-- Animations now loaded globally in tap_assets.lua to prevent orphaned resources.
}

local assets_magma_gold =
{
	-- Animations now loaded globally in tap_assets.lua to prevent orphaned resources.
}

local prefabs = 
{
	"sap_magmarock_med",
	"sap_magmarock_low",
	"sap_magmarock_gold_med",
	"sap_magmarock_gold_low",
}

--[[
local anims_magma = {"low", "med", "full"}
local anims_magma_gold = {"low", "med", "full"}

local function dig_up_magma(inst, worker, workleft)
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
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
        inst:Remove()
    else
        print("PlayAnimation", workleft, anims_magma[workleft])
        inst.AnimState:PlayAnimation(anims_magma[workleft])
    end
end

local function dig_up_magma_gold(inst, worker, workleft)
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
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
        inst:Remove()
    else
        print("PlayAnimation", workleft, anims_magma_gold[workleft])
        inst.AnimState:PlayAnimation(anims_magma_gold[workleft])
    end
end
]]--
local function dig_up_magma_full(inst, worker, workleft)
	inst:Remove()
	SpawnPrefab("sap_magmarock_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_magma_med(inst, worker, workleft)
	inst:Remove()
	SpawnPrefab("sap_magmarock_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_magma_low(inst, worker, workleft)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("rocks")
	inst.components.lootdropper:SpawnLootPrefab("rocks")
	inst.components.lootdropper:SpawnLootPrefab("flint")
	inst.components.lootdropper:SpawnLootPrefab("flint")
end

local function dig_up_magma_gold_full(inst, worker, workleft)
	inst:Remove()
	SpawnPrefab("sap_magmarock_gold_med").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_magma_gold_med(inst, worker, workleft)
	inst:Remove()
	SpawnPrefab("sap_magmarock_gold_low").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up_magma_gold_low(inst, worker, workleft)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("rocks")
	inst.components.lootdropper:SpawnLootPrefab("rocks")
	inst.components.lootdropper:SpawnLootPrefab("flint")
	inst.components.lootdropper:SpawnLootPrefab("flint")
	inst.components.lootdropper:SpawnLootPrefab("goldnugget")
end

local function commonfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_magma.tex")
	
	MakeObstaclePhysics(inst, 1)
	
	-- inst.AnimState:SetBank("rock_magma")
	-- inst.AnimState:SetBuild("rock_magma")
	-- inst.AnimState:PlayAnimation(anims[#anims])
	
	inst:AddTag("structure")
	inst:AddTag("rock")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    
	--	inst:AddComponent("workable")
	-- inst.components.workable:SetWorkAction(ACTIONS.DIG)
	-- inst.components.workable:SetOnWorkCallback(dig_up)
	-- inst.components.workable:SetWorkLeft(#anims)

	return inst
end

local function MagmaGoldFn()
	local inst = commonfn()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_magma.tex")
	
	inst.AnimState:SetBank("rock_magma_gold")
	inst.AnimState:SetBuild("rock_magma_gold")
	inst.AnimState:PlayAnimation("full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_magma_gold_full)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

local function MagmaGoldMedFn()
	local inst = commonfn()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_magma.tex")
	
	inst.AnimState:SetBank("rock_magma_gold")
	inst.AnimState:SetBuild("rock_magma_gold")
	inst.AnimState:PlayAnimation("med")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_magma_gold_med)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

local function MagmaGoldLowFn()
	local inst = commonfn()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_magma.tex")
	
	inst.AnimState:SetBank("rock_magma_gold")
	inst.AnimState:SetBuild("rock_magma_gold")
	inst.AnimState:PlayAnimation("low")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_magma_gold_low)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

local function MagmaFn()
	local inst = commonfn()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_magma.tex")
	
	inst.AnimState:SetBank("rock_magma")
	inst.AnimState:SetBuild("rock_magma")
	inst.AnimState:PlayAnimation("full")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_magma_full)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

local function MagmaMedFn()
	local inst = commonfn()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_magma.tex")
	
	inst.AnimState:SetBank("rock_magma")
	inst.AnimState:SetBuild("rock_magma")
	inst.AnimState:PlayAnimation("med")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_magma_med)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end

local function MagmaLowFn()
	local inst = commonfn()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_rock_magma.tex")
	
	inst.AnimState:SetBank("rock_magma")
	inst.AnimState:SetBuild("rock_magma")
	inst.AnimState:PlayAnimation("low")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up_magma_low)
	inst.components.workable:SetWorkLeft(1)
	
	return inst
end
	
return Prefab("sap_magmarock_gold", MagmaGoldFn, assets_magma_gold, prefabs),
Prefab("sap_magmarock_gold_med", MagmaGoldMedFn, assets_magma_gold, prefabs),
Prefab("sap_magmarock_gold_low", MagmaGoldLowFn, assets_magma_gold, prefabs),
Prefab("sap_magmarock", MagmaFn, assets_magma, prefabs),
Prefab("sap_magmarock_med", MagmaMedFn, assets_magma, prefabs),
Prefab("sap_magmarock_low", MagmaLowFn, assets_magma, prefabs),
MakePlacer("sap_magmarock_gold_placer", "rock_magma_gold", "rock_magma_gold", "full"),
MakePlacer("sap_magmarock_placer", "rock_magma", "rock_magma", "full")