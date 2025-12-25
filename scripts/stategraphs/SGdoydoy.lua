require("stategraphs/commonstates")

local COLLISION_WAVES = 8192

local actionhandlers = 
{
	ActionHandler(ACTIONS.EAT, "eat_loop"),
	ActionHandler(ACTIONS.PICKUP, "action"),
	ActionHandler(ACTIONS.HARVEST, "action"),
	ActionHandler(ACTIONS.PICK, "action"),
	ActionHandler(ACTIONS.LAYEGG, "lay"),
	-- ActionHandler(ACTIONS.MATE, "mate"),
}

local DOYDOY_MATING_FEATHER_CHANCE = 0.2

local events=
{
	CommonHandlers.OnSleep(),
	CommonHandlers.OnFreeze(),
	CommonHandlers.OnAttacked(),
	CommonHandlers.OnHop(),		
	CommonHandlers.OnDeath(),

	EventHandler("locomote", function(inst)

		local is_moving = inst.sg:HasStateTag("moving")
		local is_idling = inst.sg:HasStateTag("idle")
		local should_move = inst.components.locomotor:WantsToMoveForward()
		
		if (is_moving and not should_move) then
			inst.sg:GoToState("walk_stop")
		elseif (is_idling and should_move) or (is_moving and should_move ) then
			if not is_moving then
				inst.sg:GoToState("walk_start")
			end
		end
	end),
}

local states=
{   

	State{
	
		name = "idle",
		tags = {"idle", "canrotate"},
		onenter = function(inst, playanim)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("idle")
			inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/idle")
		end,        
	  
		events=
		{
			EventHandler("animover", function(inst)
				if math.random() < 0.25 then
					inst.sg:GoToState("peck")
				else
					inst.sg:GoToState("idle")
				end
			end),
		},
	},

	State{
		name = "action",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PushAnimation("eat_pre", false)
			inst.sg:SetTimeout(math.random()*2+1)
			inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/eat_pre")
		end,
		
		timeline=
		{
			TimeEvent(20*FRAMES, function(inst)
				inst:PerformBufferedAction()
				inst.sg:RemoveStateTag("busy")
				inst.brain:ForceUpdate()
				inst.sg:AddStateTag("wantstoeat")
			end),
		},

		events =
		{
			EventHandler("animqueueover", function(inst) inst.sg:GoToState("eat_pst") end)
		},

		ontimeout = function(inst)
			inst.sg:GoToState("eat_pst") 
		end,
	},

	State{
		name = "eat_loop",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PushAnimation("eat", false)
		end,
		
		timeline = 
		{
			TimeEvent(22*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/swallow") end),
		},

		events =
		{
			EventHandler("animover", function(inst) 
				inst:PerformBufferedAction()  
			end),

			EventHandler("animqueueover", function(inst) 
				inst.sg:GoToState("eat_pst") 
			end)
		},
	},

	State{
		name = "eat_pst",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("eat_pst")
			inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/swallow")
		end,
		
		events =
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "peck",
		tags = {"busy"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("peck")

			inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/peck")
		end,
		
		timeline = 
		{
			TimeEvent(10*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/peck") end),
		},

		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "hatch",
		tags = {"busy"},
		
		onenter = function(inst)
			local angle = math.random()*2*PI
			local speed = GetRandomWithVariance(3, 2)
			inst.Physics:SetMotorVel(speed*math.cos(angle), 0, speed*math.sin(angle))
			inst.AnimState:PlayAnimation("hatch")
		end,

		timeline =
		{
			TimeEvent(20*FRAMES, function(inst) inst.Physics:SetMotorVel(0,0,0) end),
		},
		
		events=
		{
			EventHandler("animover", function(inst) inst.sg:GoToState("idle") end),
		},
	},

	State{
		name = "mommymate",
		tags = {"busy", "mating"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("mate_dance_pre")
			inst.AnimState:PushAnimation("mate_dance_loop", true)

			inst.sg:SetTimeout(150*FRAMES)

		end,
		
		ontimeout = function(inst)
			
			inst:PerformBufferedAction()
			
			inst.sg:GoToState("dance_pst2")
		end,
	},
	
	State{
		name = "dance_pst2",
		tags = {"busy", "mating"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("mate_dance_pst")
			inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/mate_dance_post")
		end,
		
		
		timeline = 
		{
			TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:KillSound("mating_dance_LP") end),
		},

		events=
		{
			EventHandler("animqueueover", function(inst)

					inst.sg:GoToState("jumpin2")

			end),
		},
	},

	State{
		name = "jumpin2",
		tags = {"busy", "mating"},
		
		onenter = function(inst)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.WORLD)
			inst.Physics:CollidesWith(COLLISION.OBSTACLES)

			inst.AnimState:PlayAnimation("mate_pre")

			local p1 = inst:GetPosition()
			inst.nestpos = p1

			SpawnPrefab("kyno_doydoy_mate_fx").Transform:SetPosition(inst.nestpos:Get())
		end,
		
		events=
		{
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("cloud2") 
			end),
		},
	},

	State{
		name = "cloud2",
		tags = {"busy", "mating"},
		
		onenter = function(inst)
			inst.entity:Hide()

			inst.sg:SetTimeout(FRAMES*79)
		end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("jumpout2")
		end,
	},

	State{
		name = "jumpout2",
		tags = {"busy", "mating"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("mate_pst")
			inst.entity:Show()

			inst.components.locomotor:WalkForward()
		end,

		events=
		{
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle")
			end),
		},
		
		onexit = function(inst)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.WORLD)
			inst.Physics:CollidesWith(COLLISION.OBSTACLES)
			inst.Physics:CollidesWith(COLLISION.CHARACTERS)
			inst.Physics:CollidesWith(COLLISION_WAVES)

			inst:PerformBufferedAction()
		end,
	},
	
	State{
		name = "mate",
		tags = {"busy", "mating"},
		
		onenter = function(inst)
			local doydoymate = GetClosestInstWithTag("d_female", inst, 5) 
			if doydoymate then
			doydoymate.sg:GoToState("mommymate")
				return
			end

			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("mate_dance_pre")
			inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/mate_dance_pre")
		end,
		
		timeline = 
		{
			TimeEvent(14*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/mating_dance_LP", "mating_dance_LP") end),
		},

		events=
		{
			EventHandler("animover", function(inst)
				inst.sg:GoToState("dance_loop")
			end),
		},
	},

	State{
		name = "dance_loop",
		tags = {"busy", "mating"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("mate_dance_loop")
			inst.AnimState:PushAnimation("mate_dance_loop", false)
		end,
		
		events=
		{
			EventHandler("animqueueover", function(inst)
					inst.sg:GoToState("dance_pst")
			end),
		},
	},

	State{
		name = "dance_pst",
		tags = {"busy", "mating"},
		
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("mate_dance_pst")
			inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/mate_dance_post")
		end,
		
		
		timeline = 
		{
			TimeEvent(15*FRAMES, function(inst) inst.SoundEmitter:KillSound("mating_dance_LP") end),
		},

		events=
		{
			EventHandler("animqueueover", function(inst)

					inst.sg:GoToState("jumpin")
			end),
		},
	},

	State{
		name = "jumpin",
		tags = {"busy", "mating"},
		
		onenter = function(inst)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.WORLD)
			inst.Physics:CollidesWith(COLLISION.OBSTACLES)

			inst.AnimState:PlayAnimation("mate_pre")

			local p1 = inst:GetPosition()
			inst.nestpos = p1

			SpawnPrefab("kyno_doydoy_mate_fx").Transform:SetPosition(inst.nestpos:Get())
		end,
		
		events=
		{
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("cloud") 
			end),
		},
	},

	State{
		name = "cloud",
		tags = {"busy", "mating"},
		
		onenter = function(inst)

			inst.entity:Hide()

			inst.sg:SetTimeout(FRAMES*79)
		end,
		
		ontimeout = function(inst)
			inst.sg:GoToState("jumpout")
		end,
	},

	State{
		name = "jumpout",
		tags = {"busy", "mating"},
		
		onenter = function(inst)
			inst.AnimState:PlayAnimation("mate_pst")
			inst.entity:Show()

			SpawnPrefab("kyno_doydoynest2").Transform:SetPosition(inst:GetPosition():Get())

			if math.random() < 0.2 then
				SpawnPrefab("goose_feather").Transform:SetPosition(inst:GetPosition():Get())
			end

			inst.components.locomotor:WalkForward()
		end,

		events=
		{
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle")
			end),
		},
		
		onexit = function(inst)
			inst.Physics:ClearCollisionMask()
			inst.Physics:CollidesWith(COLLISION.WORLD)
			inst.Physics:CollidesWith(COLLISION.OBSTACLES)
			inst.Physics:CollidesWith(COLLISION.CHARACTERS)
			inst.Physics:CollidesWith(COLLISION_WAVES)

			inst:PerformBufferedAction()
		end,
	},
}

CommonStates.AddFrozenStates(states)
CommonStates.AddWalkStates(states, 
{
	walktimeline =
	{
		TimeEvent(FRAMES, function(inst) PlayFootstep(inst) end),
		TimeEvent(5*FRAMES, function(inst) PlayFootstep(inst) end),
		TimeEvent(10*FRAMES, function(inst) PlayFootstep(inst) end),
	}
})
CommonStates.AddCombatStates(states,
{
	attacktimeline = 
	{
		TimeEvent(20*FRAMES, function(inst)
			inst.components.combat:DoAttack(inst.sg.statemem.target, nil, nil, "electric")
		end),
		TimeEvent(22*FRAMES, function(inst) inst.sg:RemoveStateTag("attack") end),
	},

	deathtimeline = 
	{
		TimeEvent(FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/death") end)
	},
})
CommonStates.AddSleepStates(states, 
{
	starttimeline =
	{
		TimeEvent( 7*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/yawn") end)
	},
	sleeptimeline = 
	{
		TimeEvent(25*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC002/creatures/doy_doy/sleep") end)
	},
	waketimeline =
	{
	}
})
	
return StateGraph("doydoy", states, events, "idle", actionhandlers)

