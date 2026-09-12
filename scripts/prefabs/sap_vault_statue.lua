require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/statue_vault.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()

	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function fn(anim, hasminimapicon, minimapicon, isdecor)
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()
	
    MakeObstaclePhysics(inst, .5)
	
	if hasminimapicon then
		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon(minimapicon..".png" or "vault_statue_guard.png")
	end
	
    inst.AnimState:SetBank("statue_vault")
    inst.AnimState:SetBuild("statue_vault")
    inst.AnimState:PlayAnimation(anim)
    
	inst:AddTag("structure")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	if isdecor then
		inst.components.inspectable.nameoverride = "relic"
	else
		inst.components.inspectable.nameoverride = "ancient_statue"
	end
	
	inst:AddComponent("workable")
	if isdecor then
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(1)
	else
		inst.components.workable:SetWorkAction(ACTIONS.MINE)
		inst.components.workable:SetWorkLeft(6)
	end
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function ancient1()
	return fn("idle_ancient1", true, "vault_statue_guard")
end

local function ancient2()
	return fn("idle_ancient2", true, "vault_statue_guard")
end

local function ancient3()
	return fn("idle_ancient3", true, "vault_statue_guard")
end

local function ancient4()
	return fn("idle_ancient4", true, "vault_statue_guard")
end

local function bug1()
	return fn("idle_bug1", true, "vault_statue_guard")
end

local function bug2()
	return fn("idle_bug2", true, "vault_statue_guard")
end

local function bug3()
	return fn("idle_bug3", true, "vault_statue_guard")
end

local function gate()
	return fn("idle_gate", true, "vault_statue_gate")
end

local function guard1()
	return fn("idle_guard1", true, "vault_statue_guard")
end

local function guard2()
	return fn("idle_guard2", true, "vault_statue_guard")
end

local function guard3()
	return fn("idle_guard3", true, "vault_statue_guard")
end

local function king()
	return fn("idle_king", true, "vault_statue_king")
end

local function vase1()
	return fn("idle_vase1", false, nil, true)
end

local function vase1b()
	return fn("idle_vase1b", false, nil, true)
end

local function vase2()
	return fn("idle_vase2", false, nil, true)
end

local function vase2b()
	return fn("idle_vase2b", false, nil, true)
end

local function vase3()
	return fn("idle_vase3", false, nil, true)
end

local function vase3b()
	return fn("idle_vase3b", false, nil, true)
end

return Prefab("sap_vault_statue_ancient1", ancient1, assets),
MakePlacer("sap_vault_statue_ancient1_placer", "statue_vault", "statue_vault", "idle_ancient1"),

Prefab("sap_vault_statue_ancient2", ancient2, assets),
MakePlacer("sap_vault_statue_ancient2_placer", "statue_vault", "statue_vault", "idle_ancient2"),

Prefab("sap_vault_statue_ancient3", ancient3, assets),
MakePlacer("sap_vault_statue_ancient3_placer", "statue_vault", "statue_vault", "idle_ancient3"),

Prefab("sap_vault_statue_ancient4", ancient4, assets),
MakePlacer("sap_vault_statue_ancient4_placer", "statue_vault", "statue_vault", "idle_ancient4"),

Prefab("sap_vault_statue_bug1", bug1, assets),
MakePlacer("sap_vault_statue_bug1_placer", "statue_vault", "statue_vault", "idle_bug1"),

Prefab("sap_vault_statue_bug2", bug2, assets),
MakePlacer("sap_vault_statue_bug2_placer", "statue_vault", "statue_vault", "idle_bug2"),

Prefab("sap_vault_statue_bug3", bug3, assets),
MakePlacer("sap_vault_statue_bug3_placer", "statue_vault", "statue_vault", "idle_bug3"),

Prefab("sap_vault_statue_gate", gate, assets),
MakePlacer("sap_vault_statue_gate_placer", "statue_vault", "statue_vault", "idle_gate"),

Prefab("sap_vault_statue_guard1", guard1, assets),
MakePlacer("sap_vault_statue_guard1_placer", "statue_vault", "statue_vault", "idle_guard1"),

Prefab("sap_vault_statue_guard2", guard2, assets),
MakePlacer("sap_vault_statue_guard2_placer", "statue_vault", "statue_vault", "idle_guard2"),

Prefab("sap_vault_statue_guard3", guard3, assets),
MakePlacer("sap_vault_statue_guard3_placer", "statue_vault", "statue_vault", "idle_guard3"),

Prefab("sap_vault_statue_king", king, assets),
MakePlacer("sap_vault_statue_king_placer", "statue_vault", "statue_vault", "idle_king"),

Prefab("sap_vault_statue_vase1", vase1, assets),
MakePlacer("sap_vault_statue_vase1_placer", "statue_vault", "statue_vault", "idle_vase1"),

Prefab("sap_vault_statue_vase1b", vase1b, assets),
MakePlacer("sap_vault_statue_vase1b_placer", "statue_vault", "statue_vault", "idle_vase1b"),

Prefab("sap_vault_statue_vase2", vase2, assets),
MakePlacer("sap_vault_statue_vase2_placer", "statue_vault", "statue_vault", "idle_vase2"),

Prefab("sap_vault_statue_vase2b", vase2b, assets),
MakePlacer("sap_vault_statue_vase2b_placer", "statue_vault", "statue_vault", "idle_vase2b"),

Prefab("sap_vault_statue_vase3", vase3, assets),
MakePlacer("sap_vault_statue_vase3_placer", "statue_vault", "statue_vault", "idle_vase3"),

Prefab("sap_vault_statue_vase3b", vase3b, assets),
MakePlacer("sap_vault_statue_vase3b_placer", "statue_vault", "statue_vault", "idle_vase3b")