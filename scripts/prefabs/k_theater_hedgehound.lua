require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/hedgehound_bush.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("dug_berrybush")
	inst.components.lootdropper:SpawnLootPrefab("petals")
	inst.components.lootdropper:SpawnLootPrefab("stinger")
	inst:Remove()
end

local function onpickedfn(inst, picker)
    inst.AnimState:PushAnimation("reward_idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
	
	if picker ~= nil then
        if picker.components.combat ~= nil and not (picker.components.inventory ~= nil and picker.components.inventory:EquipHasTag("bramble_resistant")) then
            picker.components.combat:GetAttacked(inst, TUNING.ROSE_DAMAGE)
            picker:PushEvent("thorns")
        end
    end
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("reward_to_bush")
    inst.AnimState:PushAnimation("bush_idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("reward_idle", true)
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("reward_to_bush")
    inst.AnimState:PushAnimation("bush_idle", true)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds")
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_theater_hedgehound.tex")
	
	inst.AnimState:SetBank("hedgehound_bush")
	inst.AnimState:SetBuild("hedgehound_bush")
	inst.AnimState:PlayAnimation("bush_idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("thorny")
	
	inst:SetPrefabNameOverride("hedgehound_bush")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
    inst.components.pickable:SetUp("petals", 960)
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	
    MakeNoGrowInWinter(inst)

	return inst
end

return Prefab("kyno_theater_hedgehound", fn, assets),
MakePlacer("kyno_theater_hedgehound_placer", "hedgehound_bush", "hedgehound_bush", "bush_idle")