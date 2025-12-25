require("stategraphs/commonstates")


local actionhandlers =
{
	ActionHandler(ACTIONS.ATTACK, "fireattack"),
}

local events=
{
	CommonHandlers.OnStep(),
	CommonHandlers.OnSleep(),
	CommonHandlers.OnLocomote(false,true),
	EventHandler("attacked", function(inst)
		if inst.components.health and not inst.components.health:IsDead() then
			inst.sg:GoToState("hit")
			inst.SoundEmitter:PlaySound(inst.sounds.hurt)
		end
	end),
	EventHandler("death", function(inst) inst.sg:GoToState("death") end),
}

local states=
{
	State{
		name = "idle",
		tags = {"idle", "canrotate"},

		onenter = function(inst, pushanim)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle_loop")
		end,

		timeline=
		{
			TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			-- TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
			TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
   },

	State{
		name = "death",
		tags = {"busy"},

		onenter = function(inst)
			inst.components.container:Close()
			inst.components.container:DropEverything()
			inst.SoundEmitter:PlaySound(inst.sounds.death)
			inst.AnimState:PlayAnimation("death")
			inst.Physics:Stop()
			RemovePhysicsColliders(inst)
		end,

		timeline=
		{
			TimeEvent( 6*FRAMES, function(inst)
				if inst.PackimState == "FAT" then
					inst.SoundEmitter:PlaySound(inst.sounds.death)
				end
			end),
		},
	},

	State{
		name = "open",
		tags = {"busy", "open"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.components.sleeper:WakeUp()
			inst.AnimState:PlayAnimation("open")
		end,

		timeline=
		{
			TimeEvent( 0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.open) end),
			TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("open_idle") end ),
		},
	},

	State{
		name = "open_idle",
		tags = {"busy", "open"},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("idle_loop_open")

			if not inst.sg.mem.pant_ducking or inst.sg:InNewState() then
				inst.sg.mem.pant_ducking = 1
			end

		end,

		timeline=
		{
			TimeEvent( 3*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			-- TimeEvent(24*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
			TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
			TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("open_idle") end ),
		},
	},

	State{
		name = "close",
		tags = {""},

		onenter = function(inst)
			inst.AnimState:PlayAnimation("closed")
		end,
		--[[
		events=
        {   
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
		]]--
		events=
		{
			EventHandler("animover",
				function(inst)
					local packimstate = inst.PackimState == "FIRE"
					if inst.tryeat(inst) then --Do I contain anything I want to eat?
						if packimstate == inst.PackimState then
							inst.sg:GoToState("swallow")
						else
							inst.sg:GoToState("idle", true)
						end
					elseif inst.checkfiretransform(inst) then 
						inst.sg:GoToState("idle", true)
					else 
						inst.sg:GoToState("idle")
					end
				end ),
		},
		
		timeline=
		{
			TimeEvent( 0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.close) end),
			TimeEvent( 5*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},
	},
	
	State{
        name = "transition",
        tags = {"busy"},
        onenter = function(inst)
            inst.Physics:Stop()

            --Remove ability to open chester for short time.
            inst.components.container:Close()
            inst.components.container.canbeopened = false

            --Create light shaft
            inst.sg.statemem.light = SpawnPrefab("chesterlight")
            inst.sg.statemem.light.Transform:SetPosition(inst:GetPosition():Get())
            inst.sg.statemem.light:TurnOn()

            inst.SoundEmitter:PlaySound("dontstarve/creatures/chester/raise")

            inst.AnimState:PlayAnimation("idle_loop")
            inst.AnimState:PushAnimation("idle_loop")
            inst.AnimState:PushAnimation("idle_loop")
			inst.AnimState:PlayAnimation("idle_loop")
            inst.AnimState:PushAnimation("swallow", false)
        end,

        onexit = function(inst)
            --Add ability to open chester again.
            inst.components.container.canbeopened = true
            --Remove light shaft
            if inst.sg.statemem.light then
                inst.sg.statemem.light:TurnOff()
            end
        end,

        timeline = 
        {
            TimeEvent(56*FRAMES, function(inst) 
                local x, y, z = inst.Transform:GetWorldPosition()
                SpawnPrefab("chester_transform_fx").Transform:SetPosition(x, y + 1, z)
            end),
            TimeEvent(60*FRAMES, function(inst)
                inst.SoundEmitter:PlaySound( inst.sounds.transform_pop )
                if inst.MorphPackim ~= nil then
                    inst:MorphPackim()
                end
            end),
        },

        events =
        {
            EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },
	
	State{
		name = "transform",
		tags = {"busy"},

		onenter = function(inst, swallowed)
			inst.Physics:Stop()
			inst.components.sleeper:WakeUp()
			if swallowed then
				inst.SoundEmitter:PlaySound(inst.sounds.swallow)
				inst.AnimState:PlayAnimation("swallow", false) 
			else
				inst.sg:GoToState("transform_stage2")
			end
		end,

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("transform_stage2") end),
		},
	},

	State{
		name = "transform_stage2",
		tags = {"busy"},

		onenter = function(inst)
			inst.Physics:Stop()
			inst.components.sleeper:WakeUp()
			inst.AnimState:PlayAnimation("transform", false) -- 30 fr
			inst.AnimState:PushAnimation("transform_pst", false)
			inst.SoundEmitter:PlaySound(inst.sounds.transform)
			inst.SoundEmitter:PlaySound(inst.sounds.trasnform_stretch)
		end,

		events=
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("idle") end),
		},

		timeline = 
		{
			TimeEvent(30*FRAMES, function(inst)
				if inst.PackimState == "NORMAL" then
					inst.AnimState:SetBuild("packim_build")
				elseif inst.PackimState == "FAT" then
					inst.AnimState:SetBuild("packim_fat_build")
				elseif inst.PackimState == "FIRE" then
					inst.AnimState:SetBuild("packim_fire_build")
				end
				inst.SoundEmitter:PlaySound(inst.sounds.transform_pop)
			end)
		},

	},

	State{
		name = "hit",
		tags = {"busy"},

		onenter = function(inst)
			if inst.components.locomotor then
				inst.components.locomotor:StopMoving()
			end
			inst.AnimState:PlayAnimation("hit")
		end,

		timeline =
		{
			TimeEvent( 6*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},
}

CommonStates.AddWalkStates(states,
{
	starttimeline = 
	{
		TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
	walktimeline = 
	{
		TimeEvent( 0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent( 3*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(11*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(18*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent(19*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(27*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(35*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
	endtimeline = 
	{
		TimeEvent( 0*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent( 6*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
})

CommonStates.AddSleepStates(states,
{
	starttimeline =
	{
		TimeEvent( 2*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(32*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
	},
	sleeptimeline =
	{
		TimeEvent( 1*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(29*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(34*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.sleep) end),
		TimeEvent(45*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		-- TimeEvent(61*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
	},
	waketimeline =
	{
		TimeEvent( 1*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(13*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly_sleep) end),
		TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.bounce) end),
		TimeEvent(23*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(26*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
		TimeEvent(34*FRAMES, function(inst) inst.SoundEmitter:PlaySound(inst.sounds.fly) end),
	},
})

CommonStates.AddHopStates(states, true, nil, 
{
    hop_pre = 
    {
        TimeEvent(0, function(inst) 
            -- TODO(DANY):  This is when Chester starts jumping on the boat. There are a few other creatures that can jump on the boat
            --              but I thought it would make sense to just get chester working properly and then we can look at hooking up 
            --              the other ones after.
            inst.SoundEmitter:PlaySound("dontstarve/common/dropGeneric") 
            end),
    },

    hop_pre = 
    {
        TimeEvent(0, function(inst) 
            -- TODO(DANY):  This is when Chester lands on the boat.
            inst.SoundEmitter:PlaySound("dontstarve/common/dropGeneric") 
            end),
    }    
})

return StateGraph("packim", states, events, "idle", actionhandlers)