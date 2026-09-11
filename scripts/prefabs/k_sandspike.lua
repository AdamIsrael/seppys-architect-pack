require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/sand_spike.zip"),
	Asset("ANIM", "anim/sand_block.zip"),
    Asset("ANIM", "anim/sand_splash_fx.zip"),
}

local prefabs =
{
	"sap_sandspike_med",
	"sap_sandspike_small",
	"sap_sandblock",
	"sand_puff",
}

local function onhammered_tall(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break_spike")
	inst.AnimState:PlayAnimation("tall_break")
	inst:DoTaskInTime(0.7, function()
	inst:Remove()
	end)
end

local function onhammered_med(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break_spike")
	inst.AnimState:PlayAnimation("med_break")
	inst:DoTaskInTime(1, function()
	inst:Remove()
	end)
end

local function onhammered_small(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break_spike")
	inst.AnimState:PlayAnimation("short_break")
	inst:DoTaskInTime(1, function()
	inst:Remove()
	end)
end

local function onhammered_block(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("sand_puff").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break_spike")
	inst.AnimState:PlayAnimation("block_break")
	inst:DoTaskInTime(1, function()
	inst:Remove()
	end)
end

local function onhit_tall(inst, worker)
    inst.AnimState:PlayAnimation("tall_hit")
    inst.AnimState:PushAnimation("tall_pst", false)
end

local function onhit_med(inst, worker)
    inst.AnimState:PlayAnimation("med_hit")
    inst.AnimState:PushAnimation("med_pst", false)
end

local function onhit_small(inst, worker)
    inst.AnimState:PlayAnimation("short_hit")
    inst.AnimState:PushAnimation("short_pst", false)
end

local function onhit_block(inst, worker)
    inst.AnimState:PlayAnimation("block_hit")
    inst.AnimState:PushAnimation("block_pst", false)
end

local function onbuilt_tall(inst)
	inst.AnimState:PlayAnimation("tall_pre")
	inst.AnimState:PushAnimation("tall_pst", false)
	inst:DoTaskInTime(1, function()
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break")
	end)
end

local function onbuilt_med(inst)
	inst.AnimState:PlayAnimation("med_pre")
	inst.AnimState:PushAnimation("med_pst", false)
	inst:DoTaskInTime(1, function()
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break")
	end)
end

local function onbuilt_small(inst)
	inst.AnimState:PlayAnimation("short_pre")
	inst.AnimState:PushAnimation("short_pst", false)
	inst:DoTaskInTime(1, function()
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break")
	end)
end

local function onbuilt_block(inst)
	inst.AnimState:PlayAnimation("block_pre")
	inst.AnimState:PushAnimation("block_pst", false)
	inst:DoTaskInTime(1, function()
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/antlion/sfx/break")
	end)
end

local function tallfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("sand_spike")
	inst.AnimState:SetBuild("sand_spike")
	inst.AnimState:PlayAnimation("tall_pst", false)
	
	inst:AddTag("structure")
	inst:AddTag("sand")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SANDSPIKE"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered_tall)
	inst.components.workable:SetOnWorkCallback(onhit_tall)
	
	inst:ListenForEvent("onbuilt", onbuilt_tall)
	
	return inst
end

local function medfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("sand_spike")
	inst.AnimState:SetBuild("sand_spike")
	inst.AnimState:PlayAnimation("med_pst", false)
	
	inst:AddTag("structure")
	inst:AddTag("sand")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SANDSPIKE"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered_med)
	inst.components.workable:SetOnWorkCallback(onhit_med)
	
	inst:ListenForEvent("onbuilt", onbuilt_med)
	
	return inst
end

local function smallfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("sand_spike")
	inst.AnimState:SetBuild("sand_spike")
	inst.AnimState:PlayAnimation("short_pst", false)
	
	inst:AddTag("structure")
	inst:AddTag("sand")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SANDSPIKE"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered_small)
	inst.components.workable:SetOnWorkCallback(onhit_small)
	
	inst:ListenForEvent("onbuilt", onbuilt_small)
	
	return inst
end

local function blockfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("sand_block")
	inst.AnimState:SetBuild("sand_block")
	inst.AnimState:PlayAnimation("block_pst", false)
	
	inst:AddTag("structure")
	inst:AddTag("sandcastle")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SANDBLOCK"
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered_block)
	inst.components.workable:SetOnWorkCallback(onhit_block)
	
	inst:ListenForEvent("onbuilt", onbuilt_block)
	
	return inst
end

return Prefab("sap_sandspike_tall", tallfn, assets, prefabs),
Prefab("sap_sandspike_med", medfn, assets, prefabs),
Prefab("sap_sandspike_small", smallfn, assets, prefabs),
Prefab("sap_sandblock", blockfn, assets, prefabs),
MakePlacer("sap_sandspike_tall_placer", "sand_spike", "sand_spike", "tall_pst"),
MakePlacer("sap_sandspike_med_placer", "sand_spike", "sand_spike", "med_pst"),
MakePlacer("sap_sandspike_small_placer", "sand_spike", "sand_spike", "short_pst"),
MakePlacer("sap_sandblock_placer", "sand_block", "sand_block", "block_pst")