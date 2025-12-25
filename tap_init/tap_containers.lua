-- Common Dependencies.
local _G 					= GLOBAL
local require 				= _G.require
local Vector3    			= _G.Vector3
local ACTIONS    			= _G.ACTIONS
local STRINGS				= _G.STRINGS
local containers 			= require("containers")
local params 				= {}

-- Custom containers.
local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab, data, ...)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k]	= v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    else
        containers_widgetsetup_base(container, prefab, data, ...)
    end
end

params.honeydeposit =
{
    widget =
    {
        slotpos = 
		{
			Vector3(-37.5, 74 + 4, 0),
            Vector3(37.5, 74 + 4, 0),
			
            Vector3(-(64 + 12), 3, 0),
            Vector3(0, 3, 0),
            Vector3(64 + 12, 3, 0),
			
			Vector3(-37.5, -(70 + 4), 0),
            Vector3(37.5, -(70 + 4), 0),
		},
        animbank = "ui_antchest_honeycomb",
        animbuild = "ui_antchest_honeycomb",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

function params.honeydeposit.itemtestfn(container, item, slot)
    return item:HasTag("honeyed") and not container.inst:HasTag("burnt")
end

params.roots_container =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chester_shadow_3x4",
        animbuild = "ui_chester_shadow_3x4",
        pos = Vector3(0, 220, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(params.roots_container.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
    end
end

function params.roots_container.itemtestfn(container, item, slot)
    return not item:HasTag("irreplaceable")
end