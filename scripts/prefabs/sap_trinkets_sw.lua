local assets =
{
    Asset("ANIM", "anim/trinkets_sw.zip"),
}

local prefabs = {}

local SMALLFLOATS =
{
    [13]    = {0.7, 0.1},
    [14]    = {0.7, 0.1},
    [15]    = {0.5, 0.15},
    [16]    = {0.5, 0.15},
	[17]    = {0.9, 0.1},
	[18]    = {0.9, 0.1},
    [19]    = {0.9, 0.1},
	[20]    = {0.8, 0.1},
	[21]    = {0.8, 0.1},
    [22]    = {0.8, 0.1},
    [23]    = {0.8, 0.05},
}

local function MakeTrinket(num)
    local prefabs = {}
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)
		MakeInventoryFloatable(inst)

        inst.AnimState:SetBank("trinkets_sw")
        inst.AnimState:SetBuild("trinkets_sw")
        inst.AnimState:PlayAnimation(tostring(num))

        inst:AddTag("molebait")
        inst:AddTag("cattoy")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

        if SMALLFLOATS[num] ~= nil then
            inst.components.floater:SetScale(SMALLFLOATS[num][1])
            inst.components.floater:SetVerticalOffset(SMALLFLOATS[num][2])
        end

        inst:AddComponent("tradable")
        inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.TRINKETS[num] or 3
		inst.components.tradable.rocktribute = math.ceil(inst.components.tradable.goldvalue / 3)

        MakeHauntableLaunchAndSmash(inst)

        return inst
    end

    return Prefab("trinket_sw_"..tostring(num), fn, assets, prefabs)
end

local ret = {}
for k = 1, NUM_TRINKETS do
    table.insert(ret, MakeTrinket(k))
end

return unpack(ret)