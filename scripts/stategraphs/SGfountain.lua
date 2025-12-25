require("stategraphs/commonstates")

local actionhandlers = {}

local events = {}

local states =
{

    State
    {
        name = "loop",
        tags = {"idle"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("flow_loop")
        end,

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("loop") end),
        }
    },

    State
    {
        name = "wateron",
        tags = {"flow"},

        onenter = function(inst)
            -- inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/thumper/reset")
            inst.AnimState:PlayAnimation("flow_pre")
        end,

        timeline = {    
            TimeEvent(2 * FRAMES, function(inst)                
                -- inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/thumper/steam")
            end),
            TimeEvent(6 * FRAMES, function(inst)                
                -- inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/thumper/steam")
            end),
            TimeEvent(17 * FRAMES, function(inst)                
                -- inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/thumper/steam")
            end),
            TimeEvent(28 * FRAMES, function(inst)                
                -- inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/thumper/steam")
            end),
            TimeEvent(34 * FRAMES, function(inst)                
                -- inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/thumper/steam")
            end),
            TimeEvent(51 * FRAMES, function(inst)    
                -- inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/thumper/hit")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("loop") end),
        }
    },

    State
    {
        name = "loopoff",
        tags = {"idle_off"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("off")
        end,
		--[[
        onexit = function(inst)
            inst.components.machine:TurnOff()
        end,
		]]--
        timeline = {    
            TimeEvent(7 * FRAMES, function(inst)                
                inst.AnimState:PlayAnimation("off")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("loopoff") end),
        }
    },
	
	State
    {
        name = "wateroff",
        tags = {"dry"},

        onenter = function(inst)
            inst.AnimState:PlayAnimation("flow_pst")
        end,
		--[[
        onexit = function(inst)
            inst.components.machine:TurnOff()
        end,
		]]--
        timeline = {    
            TimeEvent(7 * FRAMES, function(inst)                
                inst.AnimState:PlayAnimation("off")
            end),
        },

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("loopoff") end),
        }
    },
	--[[
    State
    {
        name = "hit_water",
        tags = {"water"},

        onenter = function(inst)
            --Stop some loop sound            
            -- inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/thumper/hit")
            inst.AnimState:PlayAnimation("flow_loop")
        end,
        
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("loop") end),
        }        
    },
	
	State
    {
        name = "hit_off",
        tags = {"dry"},

        onenter = function(inst)
            --Stop some loop sound            
            -- inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/thumper/hit")
            inst.AnimState:PlayAnimation("off")
        end,
        
        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("loopoff") end),
        }        
    },
	]]--
    State
    {  
        name = "place",
        tags = {"busy"},

        onenter = function(inst, data)
            -- inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/thumper/place")
            inst.AnimState:PlayAnimation("off")
            -- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/sprinkler/place")
            --Play some sound / good idea
        end,

        timeline = {},

        events =
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("loopoff") end)
        },
    },

    State
    {  
        name = "hit",
        tags = {"busy"},

        onenter = function(inst, data)
            if inst.on then 
                inst.AnimState:PlayAnimation("flow_loop")
            else
                inst.AnimState:PlayAnimation("off")
            end
        end,

        timeline = {},

        events =
        {
            EventHandler("animover", function(inst) 
               inst.sg:GoToState("loopoff")
            end)
        },
    },
}

return StateGraph("fountain", states, events, "loop", actionhandlers)