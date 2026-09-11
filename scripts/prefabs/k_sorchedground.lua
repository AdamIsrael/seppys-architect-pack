local assets =
{
    Asset("ANIM", "anim/scorched_ground.zip"),
}

local anim_names =
{
    "idle",
}

local prefabs =
{
	"ash",
}

for i = 2, 10 do
    table.insert(anim_names, "idle"..tostring(i))
end

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("ash")
	inst:Remove()
end

local function OnSave(inst, data)
    data.anim = inst.anim
    data.rotation = inst.Transform:GetRotation()
end

local function OnLoad(inst, data)
    if data ~= nil then
        if data.anim ~= nil then
            inst.anim = data.anim
            inst.AnimState:PlayAnimation(inst.anim)
        end
        if data.rotation ~= nil then
            inst.Transform:SetRotation(data.rotation)
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("scorched_ground")
    inst.AnimState:SetBank("scorched_ground")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:AddTag("notarget")
    inst:AddTag("dragonfly_fx")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	-- inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("savedrotation")

    inst.anim = anim_names[math.random(#anim_names)]
    inst.AnimState:PlayAnimation(inst.anim)
    inst.Transform:SetRotation(math.random() * 360)

    inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("sap_scorchedground", fn, assets),
MakePlacer("sap_scorchedground_placer", "scorched_ground", "scorched_ground", "idle2", true, nil, nil, nil, 90, nil)