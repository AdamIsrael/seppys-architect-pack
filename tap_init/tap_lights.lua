local _G = GLOBAL

local conf_winter_tree 	= GetModConfigData("TAP_WINTER_TREE")
local conf_glowcap 		= GetModConfigData("TAP_GLOWCAP")
local conf_mushlight 	= GetModConfigData("TAP_MUSHLIGHT")

local function setItemPause(item, pause)
    if item ~= nil then
        -- c_announce("setItemPause: "..(item.prefab and item.prefab or "noname").." "..tostring(pause))
        if pause then
            if item.components.perishable then item.components.perishable:StopPerishing() end
            if item.components.fueled then item.components.fueled:StopConsuming() end
        else
            if item.components.perishable then item.components.perishable:StartPerishing() end
            if item.components.fueled then item.components.fueled:StartConsuming() end
        end
    end
end

local function InfiniteLightFn(inst)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("eternal_light")
    inst:ListenForEvent("itemget", function(inst)
        local container = inst.components.container
        for i=1,container.numslots do
            if container.slots[i] ~= nil then
                setItemPause(container.slots[i], true)
            end
        end
    end)

    local func_RemoveItemBySlot = inst.components.container.RemoveItemBySlot
    inst.components.container.RemoveItemBySlot = function(self, slot)
        local item = func_RemoveItemBySlot(self, slot)
        setItemPause(item, false)
        return item
    end
end

if conf_mushlight == 1 then
    AddPrefabPostInit("mushroom_light", InfiniteLightFn)
end

if conf_glowcap == 1 then
    AddPrefabPostInit("mushroom_light2", InfiniteLightFn)
end

if conf_winter_tree == 1 then
    AddPrefabPostInit("winter_tree", InfiniteLightFn)
    AddPrefabPostInit("winter_deciduoustree", InfiniteLightFn)
    AddPrefabPostInit("winter_twiggytree", InfiniteLightFn)
end