local conf_light 	= GetModConfigData("TAP_ENDTABLE_LIGHT")
local conf_flower 	= GetModConfigData("TAP_ENDTABLE_DECOR")

_G = GLOBAL
TUNING = _G.TUNING

local FLOWER_MAP =
{
    petals              = { flowerids = { 1, 2, 3, 4, 6, 10, 11, 12 } },
    lightbulb           = { flowerids = { 5, 7, 8 } },
    wormlight           = { flowerids = { 9 } },
    wormlight_lesser    = { flowerids = { 9 } },
    forgetmelots        = { flowerids = { 13, 14 } },
    moon_tree_blossom   = { flowerids = { 15 } },
}

local FLOWERID_MAP =
{
    "petals",
    "petals",
    "petals",
    "petals",
    "lightbulb",
    "petals",
    "lightbulb",
    "lightbulb",
    "wormlight",
    "petals",
    "petals",
    "petals",
	"forgetmelots",
	"forgetmelots",
	"moon_tree_blossom",
}

local FLOWER_SWAPS =
{
    { lightsource = false, 	sanityboost = TUNING.SANITY_TINY },
    { lightsource = false, 	sanityboost = TUNING.SANITY_TINY },
    { lightsource = false, 	sanityboost = TUNING.SANITY_TINY },
    { lightsource = false, 	sanityboost = TUNING.SANITY_TINY },
    { lightsource = true, 	sanityboost = 0 },
    { lightsource = false, 	sanityboost = TUNING.SANITY_TINY },
    { lightsource = true, 	sanityboost = 0 },
    { lightsource = true, 	sanityboost = 0 },
    { lightsource = true, 	sanityboost = 0 },
    { lightsource = false, 	sanityboost = TUNING.SANITY_TINY },
    { lightsource = false, 	sanityboost = TUNING.SANITY_TINY },
    { lightsource = false, 	sanityboost = TUNING.SANITY_TINY },
    { lightsource = false, 	sanityboost = TUNING.SANITY_TINY },
    { lightsource = false, 	sanityboost = TUNING.SANITY_TINY },
    { lightsource = false, 	sanityboost = TUNING.SANITY_TINY },
}

local function updatelight(inst)
    --local remaining = _G.GetTaskRemaining(inst.task) / TUNING.ENDTABLE_FLOWER_WILTTIME
    local remaining = 1
    inst.Light:SetRadius(1.5 + (1.5 * remaining))
    inst.Light:SetIntensity(0.4 + (0.4 * remaining))
    inst.Light:SetFalloff(0.8 + (1 - 1 * remaining))
end

local function setEternal(inst)
    -- light stays bright
    if conf_light == 1 and inst.lighttask ~= nil then
        inst.lighttask:Cancel()
        inst.lighttask = nil
    end

    if inst.task ~= nil then
        if (FLOWERID_MAP[inst.flowerid]=="petals" and conf_flower==1) or 
            (FLOWERID_MAP[inst.flowerid]~="petals" and conf_light==1) then 
            inst.task:Cancel()
            inst.task = nil
            inst.wilttime = TUNING.ENDTABLE_FLOWER_WILTTIME
        end
    end

    if inst.flowerid then
        if FLOWER_SWAPS[inst.flowerid].lightsource then
            if conf_light == 1 then
                inst.AnimState:SetLightOverride(0.3)
                inst.Light:Enable(true)
                updatelight(inst)
            end
        else
            if conf_flower == 1 then
                inst.AnimState:SetLightOverride(0)
                inst.Light:Enable(false)
            end
        end
    end
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    elseif inst.flowerid ~= nil then
        data.flowerid = inst.flowerid
        if conf_flower == 1 then
            data.wilttime = TUNING.ENDTABLE_FLOWER_WILTTIME
        else
            if inst.task ~= nil then
                data.wilttime = GetTaskRemaining(inst.task)
            end
        end
    end
end

local function onhit(inst, worker, workleft)
    if  not inst:HasTag("burnt") then
        inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stagehand/hit")
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end

    if inst.flowerid ~= nil then
        if (FLOWERID_MAP[inst.flowerid]=="petals" and conf_flower==1) or 
            (FLOWERID_MAP[inst.flowerid]~="petals" and conf_light==1) or inst.task~=nil then
            local flowerids = FLOWER_MAP[FLOWERID_MAP[inst.flowerid]].flowerids
            for i,id in pairs(flowerids) do
                if id == inst.flowerid then
                    inst.flowerid = flowerids[(i)%(#flowerids)+1] -- get next flower appearance
                    break
                end
            end
            --inst.flowerid = _G.GetRandomItem(FLOWER_MAP[FLOWERID_MAP[inst.flowerid]].flowerids)
            inst.AnimState:OverrideSymbol("swap_flower", "swap_flower", "f"..tostring(inst.flowerid))

            local workable = inst.components.workable
            if inst.lastworktime == nil then
                inst.lastworktime = _G.GetTime()
            end

            if _G.GetTime() - inst.lastworktime > 2 then
                workable:SetWorkLeft(3) 
                --_G.c_announce("reset!")
                inst.lastworktime = _G.GetTime()
            end
            --_G.c_announce("workleft: "..workable.workleft)
        end
    end
end

local function InfiniteTable(inst)

    if not _G.TheWorld.ismastersim then
        return inst
    end

    inst:AddTag("eternal")
    if inst.components.vase then
        local old_ondecorate = inst.components.vase.ondecorate
        inst.components.vase.ondecorate = function(inst, giver, item)
            old_ondecorate(inst, giver, item)
            setEternal(inst)
        end
    end

    if inst.components.workable then
        inst.components.workable:SetOnWorkCallback(onhit)
    end

    inst.OnSave = onsave 

    local old_onload = inst.OnLoad
    inst.OnLoad = function(inst, data)
        old_onload(inst, data)
        setEternal(inst)
    end
end

AddPrefabPostInit("endtable", InfiniteTable)