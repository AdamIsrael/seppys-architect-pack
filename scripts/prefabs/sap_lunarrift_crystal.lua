require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/lunar_rift_crystals.zip"),
}

local prefabs =
{
    "collapse_small",
    "lunarrift_crystal_spawn_fx",
    "mining_crystal_fx",
    "purebrilliance",
}

local HALF_WORK = 0.5 * TUNING.LUNARRIFT_CRYSTAL_MINES

local function ShouldRecoil(inst, worker, tool, numworks)
	if worker ~= nil and inst.components.workable:GetWorkLeft() > math.max(1, numworks) and not 
	(tool ~= nil and tool.components.tool ~= nil and tool.components.tool:GetEffectiveness(ACTIONS.MINE) > 1) then
		local t = GetTime()
		if inst._recoils == nil then
			inst._recoils = {}
		end
		
		for k, v in pairs(inst._recoils) do
			if t - v > 10 then
				inst._recoils[k] = nil
			end
		end
		
		if inst._recoils[worker] == nil then
			inst._recoils[worker] = t - (2 + math.random())
		elseif t - inst._recoils[worker] > 3 then
			inst._recoils[worker] = t - math.random()
			return true, numworks * .1 
		end
	end
	
	return false, numworks
end

local function BigWorked(inst, worker, work_left)
    if work_left <= 0 then
        local position = inst:GetPosition()
        SpawnPrefab("mining_moonglass_fx").Transform:SetPosition(position:Get())
        SpawnPrefab("collapse_small").Transform:SetPosition(position:Get())

        inst.components.lootdropper:DropLoot(position)

        inst:Remove()
    else
		local anim = work_left < 3 and "half" or "full"
		if not inst.AnimState:IsCurrentAnimation(anim) then
			inst.AnimState:PlayAnimation(anim, true)
		end
    end
end

local function SmallWorked(inst, worker, work_left)
    if work_left <= 0 then
        local position = inst:GetPosition()
        SpawnPrefab("mining_moonglass_fx").Transform:SetPosition(position:Get())
        SpawnPrefab("collapse_small").Transform:SetPosition(position:Get())

        inst.components.lootdropper:DropLoot(position)

        inst:Remove()
    end
end

local function basefn(anim_prefix, physics_size)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, physics_size or 0.6)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("lunar_rift_crystals.png")

    inst.Transform:SetEightFaced()

    inst.AnimState:SetBank("lunar_rift_crystals")
    inst.AnimState:SetBuild("lunar_rift_crystals")
    inst.AnimState:PlayAnimation(anim_prefix, true)
    inst.AnimState:SetLightOverride(0.1)

	inst:AddTag("structure")
    inst:AddTag("birdblocker")
    inst:AddTag("boulder")
    inst:AddTag("crystal")
	
	inst:SetPrefabNameOverride("LUNARRIFT_CRYSTAL")

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst._anim_prefix = anim_prefix
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")

    inst:AddComponent("inspectable")
    inst.components.inspectable.nameoverride = "LUNARRIFT_CRYSTAL"

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	-- inst.components.workable:SetShouldRecoilFn(ShouldRecoil)
    inst.components.workable.savestate = true
    
    MakeHauntableWork(inst)
    MakeSnowCovered(inst)

    return inst
end

local function bigfn()
    local crystal = basefn("full", 1.0)

    if not TheWorld.ismastersim then
        return crystal
    end

    crystal.components.workable:SetWorkLeft(6)
    crystal.components.workable:SetOnWorkCallback(BigWorked)

    return crystal
end

local function smallfn()
    local crystal = basefn("small", 0.25)

    if not TheWorld.ismastersim then
        return crystal
    end

    crystal.components.workable:SetWorkLeft(3)
    crystal.components.workable:SetOnWorkCallback(SmallWorked)

    return crystal
end

return Prefab("sap_lunarrift_crystal1", bigfn, assets, prefabs),
Prefab("sap_lunarrift_crystal2", smallfn, assets, prefabs),
MakePlacer("sap_lunarrift_crystal1_placer", "lunar_rift_crystals", "lunar_rift_crystals", "full", false, nil, nil, nil, 90, nil),
MakePlacer("sap_lunarrift_crystal2_placer", "lunar_rift_crystals", "lunar_rift_crystals", "small", false, nil, nil, nil, 90, nil)
