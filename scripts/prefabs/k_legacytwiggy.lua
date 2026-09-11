local assets =
{
	Asset("ANIM", "anim/legacytwiggy_build.zip"),
	Asset("ANIM", "anim/legacytwiggy_short_normal.zip"),
	Asset("ANIM", "anim/legacytwiggy_tall_old.zip"),

	-- Asset("ANIM", "anim/legacytwiggy_diseased_build.zip"),
	-- Asset("ANIM", "anim/legacytwiggy_diseased_short_normal.zip"),
	-- Asset("ANIM", "anim/legacytwiggy_diseased_tall_old.zip"),
	-- Asset("ANIM", "anim/legacytwiggy_diseased_transformed.zip"),

	Asset("ANIM", "anim/dust_fx.zip"),
	Asset("SOUND", "sound/forest.fsb"),
}

local prefabs =
{
	"log",
	"pinecone",
	"charcoal",
	"spoiled_food",
}

local builds =
{
	normal = {
		file="twiggy_build",
		file_bank="twiggy",
		prefab_name="legacytwiggy",
		regrowth_tuning=TUNING.EVERGREEN_REGROWTH,
        grow_times=TUNING.TWIGGY_TREE_GROW_TIME,
		normal_loot = {"log","twigs","twiggy_nut"},
        short_loot = {"twigs"},
        tall_loot = {"log", "twigs","twigs","twiggy_nut","twiggy_nut"},
		old_loot = {"twiggy_nut"},
		rebirth_loot = {loot="twigs", max=2},
	},
	diseased = {
		file="twiggy_build",
		file_bank="twiggy",
		prefab_name="legacytwiggy_diseased",
		normal_loot = {"log","spoiled_food","spoiled_food"},
        short_loot = {"spoiled_food"},
        tall_loot = {"log", "spoiled_food","spoiled_food", "spoiled_food"},
		old_loot = {"log"},
	},
}

local function makeanims(stage)
	return {
		idle="idle_"..stage,
		sway1="sway1_loop_"..stage,
		sway2="sway2_loop_"..stage,
		chop="chop_"..stage,
		fallleft="fallleft_"..stage,
		fallright="fallright_"..stage,
		stump="stump_"..stage,
		burning="burning_loop_"..stage,
		burnt="burnt_"..stage,
		chop_burnt="chop_burnt_"..stage,
		idle_chop_burnt="idle_chop_burnt_"..stage,
		blown1="blown_loop_"..stage.."1",
		blown2="blown_loop_"..stage.."2",
		blown_pre="blown_pre_"..stage,
		blown_pst="blown_pst_"..stage
	}
end

local short_anims = makeanims("short")
local tall_anims = makeanims("tall")
local normal_anims = makeanims("normal")
local old_anims =
{
	idle="idle_old",
	sway1="idle_old",
	sway2="idle_old",
	chop="chop_old",
	fallleft="chop_old",
	fallright="chop_old",
	stump="stump_old",
	burning="burning_loop_old",
	burnt="burnt_old",
	chop_burnt="chop_burnt_old",
	idle_chop_burnt="idle_chop_burnt_tall",
	blown="blown_loop",
	blown_pre="blown_pre",
	blown_pst="blown_pst"
}

local function dig_up_stump(inst, chopper)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("log")
end

local function chop_down_burnt_tree(inst, chopper)
	inst:RemoveComponent("workable")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	inst.AnimState:PlayAnimation(inst.anims.chop_burnt)
	RemovePhysicsColliders(inst)
	inst:ListenForEvent("animover", function() inst:Remove() end)
	inst.components.lootdropper:SpawnLootPrefab("charcoal")
	inst.components.lootdropper:DropLoot()
	if inst.pineconetask then
		inst.pineconetask:Cancel()
		inst.pineconetask = nil
	end
end

local function GetBuild(inst)
    return builds[inst.build] or builds["normal"]
end

local burnt_highlight_override = {.5,.5,.5}
local function OnBurnt(inst, imm)

	local function changes()
		if inst.components.burnable then
			inst.components.burnable:Extinguish()
		end
		inst:RemoveComponent("burnable")
		inst:RemoveComponent("propagator")
		inst:RemoveComponent("growable")
		inst:RemoveComponent("blowinwindgust")
		inst:RemoveTag("shelter")
		inst:RemoveTag("dragonflybait_lowprio")
		inst:RemoveTag("fire")
		inst:RemoveTag("gustable")

		inst.components.lootdropper:SetLoot({})

		if inst.components.workable then
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnWorkCallback(nil)
			inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree)
		end
	end

	if imm then
		changes()
	else
		inst:DoTaskInTime( 0.5, changes)
	end
	inst.AnimState:PlayAnimation(inst.anims.burnt, true)
	--inst.AnimState:SetRayTestOnBB(true);
	inst:AddTag("burnt")

	inst.highlight_override = burnt_highlight_override
end

local function DoRebirthLoot(inst)
    local rebirth_loot = GetBuild(inst).rebirth_loot
    if rebirth_loot ~= nil then
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, 8)
        local numloot = 0
        for i,ent in ipairs(ents) do
            if ent.prefab == rebirth_loot.loot then
                numloot = numloot + 1
            end
        end
        local prob = 1-(numloot/rebirth_loot.max)
        if math.random() < prob then
            inst:DoTaskInTime(17*FRAMES, function()
                inst.components.lootdropper:SpawnLootPrefab(rebirth_loot.loot)
            end)
        end
        inst._lastrebirth = GetTime()
    end
end

local function PushSway(inst)
	if math.random() > .5 then
		inst.AnimState:PushAnimation(inst.anims.sway1, true)
	else
		inst.AnimState:PushAnimation(inst.anims.sway2, true)
	end
end

local function Sway(inst)
	if math.random() > .5 then
		inst.AnimState:PlayAnimation(inst.anims.sway1, true)
	else
		inst.AnimState:PlayAnimation(inst.anims.sway2, true)
	end
	inst.AnimState:SetTime(math.random()*2)
end

local function SetShort(inst)
	inst.anims = short_anims

	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_SMALL)
	end
	-- if inst:HasTag("shelter") then inst:RemoveTag("shelter") end

	inst.components.lootdropper:SetLoot(GetBuild(inst).short_loot)
	Sway(inst)
end

local function GrowShort(inst)
	inst.AnimState:PlayAnimation("grow_old_to_short")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")
	PushSway(inst)
	DoRebirthLoot(inst)
end

local function SetNormal(inst)
	inst.anims = normal_anims

	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_NORMAL)
	end
	-- if inst:HasTag("shelter") then inst:RemoveTag("shelter") end

	inst.components.lootdropper:SetLoot(GetBuild(inst).normal_loot)
	Sway(inst)
end

local function GrowNormal(inst)
	inst.AnimState:PlayAnimation("grow_short_to_normal")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	PushSway(inst)
end

local function SetTall(inst)
	inst.anims = tall_anims
	if inst.components.workable then
		inst.components.workable:SetWorkLeft(TUNING.EVERGREEN_CHOPS_TALL)
	end
	-- inst:AddTag("shelter")
	inst.components.lootdropper:SetLoot(GetBuild(inst).tall_loot)
	Sway(inst)
end

local function GrowTall(inst)
	inst.AnimState:PlayAnimation("grow_normal_to_tall")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	PushSway(inst)
end

local function SetOld(inst)
    inst.anims = old_anims
    if inst.components.workable ~= nil then
        inst.components.workable:SetWorkLeft(1)
    end

	inst.components.lootdropper:SetLoot(GetBuild(inst).old_loot)
    Sway(inst)
end

local function GrowOld(inst)
    inst.AnimState:PlayAnimation("grow_tall_to_old")
    inst.SoundEmitter:PlaySound("dontstarve/forest/treeWilt")
    PushSway(inst)
end

local function inspect_tree(inst)
	if inst:HasTag("burnt") then
		return "BURNT"
	elseif inst:HasTag("stump") then
		return "CHOPPED"
	end
end

local growth_stages =
{
	{name="short", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[1].base, TUNING.EVERGREEN_GROW_TIME[1].random) end, fn = function(inst) SetShort(inst) end,  growfn = function(inst) GrowShort(inst) end , leifscale=.7 },
	{name="normal", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[2].base, TUNING.EVERGREEN_GROW_TIME[2].random) end, fn = function(inst) SetNormal(inst) end, growfn = function(inst) GrowNormal(inst) end, leifscale=1 },
	{name="tall", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[3].base, TUNING.EVERGREEN_GROW_TIME[3].random) end, fn = function(inst) SetTall(inst) end, growfn = function(inst) GrowTall(inst) end, leifscale=1.25 },
	{name="old", time = function(inst) return GetRandomWithVariance(TUNING.EVERGREEN_GROW_TIME[4].base, TUNING.EVERGREEN_GROW_TIME[4].random) end, fn = function(inst) SetOld(inst) end, growfn = function(inst) GrowOld(inst) end, leifscale=1.25 },
}

local function make_stump(inst)
    inst:RemoveComponent("burnable")
    MakeSmallBurnable(inst)
    inst:RemoveComponent("propagator")
    MakeSmallPropagator(inst)
    inst:RemoveComponent("workable")
    inst:RemoveTag("shelter")
    inst:RemoveComponent("hauntable")
    MakeHauntableIgnite(inst)

    RemovePhysicsColliders(inst)

    inst:AddTag("stump")
    if inst.components.growable ~= nil then
        inst.components.growable:StopGrowing()
    end

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up_stump)
    inst.components.workable:SetWorkLeft(1)

end

local function chop_tree(inst, chopper, chops)

	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	end

	inst.AnimState:PlayAnimation(inst.anims.chop)
	inst.AnimState:PushAnimation(inst.anims.sway1, true)
end

local function chop_down_tree(inst, chopper)
	inst:RemoveComponent("burnable")
	MakeSmallBurnable(inst)
	inst:RemoveComponent("propagator")
	MakeSmallPropagator(inst)
	inst:RemoveComponent("workable")
	inst:RemoveTag("shelter")
	inst:RemoveTag("gustable")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local hispos = Vector3(chopper.Transform:GetWorldPosition())

	local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

	if he_right then
		inst.AnimState:PlayAnimation(inst.anims.fallleft)
		inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
	else
		inst.AnimState:PlayAnimation(inst.anims.fallright)
		inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
	end

	RemovePhysicsColliders(inst)
	inst.AnimState:PushAnimation(inst.anims.stump)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up_stump)
	inst.components.workable:SetWorkLeft(1)

	inst:AddTag("stump")
	if inst.components.growable then
		inst.components.growable:StopGrowing()
	end

	-- inst:AddTag("NOCLICK")
	-- inst:DoTaskInTime(2, function() inst:RemoveTag("NOCLICK") end)
end

local function tree_burnt(inst)
	OnBurnt(inst)
	inst.pineconetask = inst:DoTaskInTime(10,
		function()
			local pt = Vector3(inst.Transform:GetWorldPosition())
			if math.random(0, 1) == 1 then
				pt = pt + TheCamera:GetRightVec()
			else
				pt = pt - TheCamera:GetRightVec()
			end
			inst.components.lootdropper:DropLoot(pt)
			inst.pineconetask = nil
		end)
end

local function handler_growfromseed (inst)
	inst.components.growable:SetStage(1)
	inst.AnimState:PlayAnimation("grow_seed_to_short")
	inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
	PushSway(inst)
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end

	if inst:HasTag("stump") then
		data.stump = true
	end

	if inst.build ~= "normal" then
		data.build = inst.build
	end

	if inst._lastrebirth ~= nil then
        data.lastrebirth = inst._lastrebirth - GetTime()
    end
end

local function onload(inst, data)
	if data then
		if not data.build or builds[data.build] == nil then
			inst.build = "normal"
		else
			inst.build = data.build
		end

		if data.burnt then
			inst:AddTag("fire") -- Add the fire tag here: OnEntityWake will handle it actually doing burnt logic
		elseif data.stump then
			inst:RemoveComponent("burnable")
			MakeSmallBurnable(inst)
			inst:RemoveComponent("workable")
			inst:RemoveComponent("propagator")
			MakeSmallPropagator(inst)
			inst:RemoveComponent("growable")
			RemovePhysicsColliders(inst)
			inst.AnimState:PlayAnimation(inst.anims.stump)
			inst:AddTag("stump")
			inst:RemoveTag("shelter")
			inst:RemoveTag("gustable")
			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetOnFinishCallback(dig_up_stump)
			inst.components.workable:SetWorkLeft(1)
		end
	end

	if data.lastrebirth ~= nil then
            inst._lastrebirth = data.lastrebirth + GetTime()
        end
end

local function OnEntitySleep(inst)
	local fire = false
	if inst:HasTag("fire") then
		fire = true
	end
	inst:RemoveComponent("burnable")
	inst:RemoveComponent("propagator")
	inst:RemoveComponent("inspectable")
	if fire then
		inst:AddTag("fire")
	end
end

local function OnEntityWake(inst)

	if not inst:HasTag("burnt") and not inst:HasTag("fire") then
		if not inst.components.burnable then
			if inst:HasTag("stump") then
				MakeSmallBurnable(inst)
			else
				MakeLargeBurnable(inst)
				inst.components.burnable:SetFXLevel(5)
				inst.components.burnable:SetOnBurntFn(tree_burnt)
			end
		end

		if not inst.components.propagator then
			if inst:HasTag("stump") then
				MakeSmallPropagator(inst)
			else
				MakeLargePropagator(inst)
			end
		end
	elseif not inst:HasTag("burnt") and inst:HasTag("fire") then
		OnBurnt(inst, true)
	end

	if not inst.components.inspectable then
		inst:AddComponent("inspectable")
		inst.components.inspectable.getstatus = inspect_tree
	end

	local isstump = inst:HasTag("stump")
	if not isstump and GetBuild(inst).rebirth_loot ~= nil then
            -- This is a failsafe because trees don't actually grow offscreen (or
            -- rather, never more than one stage) So this will cause trees that
            -- have been offscreen for multiple stages to drop some loot even if
            -- their growth hasn't reached there yet.
            local growthcycletime = inst._lastrebirth
            for i,data in ipairs(GetBuild(inst).grow_times) do
                growthcycletime = growthcycletime + data.base
            end
            if growthcycletime < GetTime() then
                DoRebirthLoot(inst)
        end
    end
end

local REMOVABLE =
{
    ["log"] = true,
    ["pinecone"] = true,
    ["twigs"] = true,
    ["twiggy_nut"] = true,
    ["charcoal"] = true,
}

local DECAYREMOVE_MUST_TAGS = { "_inventoryitem" }
local DECAYREMOVE_CANT_TAGS = { "INLIMBO", "fire" }
local function OnTimerDone(inst, data)
    if data.name == "decay" then
        local x, y, z = inst.Transform:GetWorldPosition()
        if inst:IsAsleep() then
            -- before we disappear, clean up any crap left on the ground
            -- too many objects is as bad for server health as too few!
            local leftone = false
            for i, v in ipairs(TheSim:FindEntities(x, y, z, 6, DECAYREMOVE_MUST_TAGS, DECAYREMOVE_CANT_TAGS)) do
                if REMOVABLE[v.prefab] then
                    if leftone then
                        v:Remove()
                    else
                        leftone = true
                    end
                end
            end
        else
            SpawnPrefab("small_puff").Transform:SetPosition(x, y, z)
        end
        inst:Remove()
    end
end

local function CheckBuild(inst)
	if inst:HasTag("legacy_twiggy") then
		inst.AnimState:AddOverrideBuild("legacytwiggy_build")
	else
		inst.AnimState:AddOverrideBuild("legacytwiggy_diseased_build")
	end
end

local function makefn(build, stage, data)

	local function fn(Sim)
		local l_stage = stage
		if l_stage == 0 then
			l_stage = math.random(1,3)
		end

		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

		MakeObstaclePhysics(inst, .25)
		-- inst.Transform:SetScale(.75, .75, .75)

		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon("kyno_legacytwiggy.tex")
		minimap:SetPriority(1)

		inst:AddTag("tree")
		inst:AddTag("workable")
		inst:AddTag("shelter")

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
            return inst
        end

		inst.build = build
		inst.AnimState:SetBuild(GetBuild(inst).file)
		inst.AnimState:SetBank(GetBuild(inst).file_bank)
		local color = 0.5 + math.random() * 0.5
		inst.AnimState:SetMultColour(color, color, color, 1)
		inst.AnimState:Hide("SNOW")
		inst.AnimState:Hide("symbol_1d298b03")

		MakeLargeBurnable(inst)
		inst.components.burnable:SetFXLevel(5)
		inst.components.burnable:SetOnBurntFn(tree_burnt)

		MakeLargePropagator(inst)

		inst:AddComponent("inspectable")
		-- inst.components.inspectable.getstatus = inspect_tree
		inst.components.inspectable.nameoverride = "TWIGGYTREE"

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.CHOP)
		inst.components.workable:SetOnWorkCallback(chop_tree)
		inst.components.workable:SetOnFinishCallback(chop_down_tree)

		inst:AddComponent("lootdropper")

		inst:AddComponent("growable")
		inst.components.growable.stages = growth_stages
		inst.components.growable:SetStage(l_stage)
		inst.components.growable.loopstages = true
		inst.components.growable.springgrowth = true
		inst.components.growable:StartGrowing()

		inst.growfromseed = handler_growfromseed

		inst.AnimState:SetTime(math.random()*2)

		inst.OnSave = onsave
		inst.OnLoad = onload

		MakeSnowCovered(inst, .01)

		inst:SetPrefabName( GetBuild(inst).prefab_name )

		if GetBuild(inst).rebirth_loot ~= nil then
            inst._lastrebirth = 0
            for i,time in ipairs(GetBuild(inst).grow_times) do
                if i == inst.components.growable.stage then
                    break
                end
                inst._lastrebirth = inst._lastrebirth - time.base
            end
        end

		if data =="burnt"  then
			OnBurnt(inst)
		end

		if data =="stump"  then
			inst:RemoveComponent("burnable")
			MakeSmallBurnable(inst)
			inst:RemoveComponent("workable")
			inst:RemoveComponent("propagator")
			MakeSmallPropagator(inst)
			inst:RemoveComponent("growable")
			inst:RemoveTag("gustable")
			RemovePhysicsColliders(inst)
			inst.AnimState:PlayAnimation(inst.anims.stump)
			inst:AddTag("stump")
			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(ACTIONS.DIG)
			inst.components.workable:SetOnFinishCallback(dig_up_stump)
			inst.components.workable:SetWorkLeft(1)
		end

		inst.OnEntitySleep = OnEntitySleep
		inst.OnEntityWake = OnEntityWake

		CheckBuild(inst)

		return inst
	end
	return fn
end

local function twiggyplacefn(inst)
	inst.AnimState:Hide("SNOW")
	inst.AnimState:Hide("symbol_1d298b03")
end

local function tree(name, build, stage, data)
	return Prefab(name, makefn(build, stage, data), assets, prefabs)
end

return tree("legacytwiggy", "normal", 0),
tree("legacytwiggy_normal", "normal", 2),
tree("legacytwiggy_tall", "normal", 3),
tree("legacytwiggy_short", "normal", 1),
tree("legacytwiggy_old", "normal", 4),
tree("legacytwiggy_burnt", "normal", 0, "burnt"),
tree("legacytwiggy_stump", "normal", 0, "stump"),

tree("legacytwiggy_diseased", "diseased", 0),
tree("legacytwiggy_diseased_normal", "diseased", 2),
tree("legacytwiggy_diseased_tall", "diseased", 3),
tree("legacytwiggy_diseased_short", "diseased", 1),
tree("legacytwiggy_diseased_old", "diseased", 4),
tree("legacytwiggy_diseased_burnt", "diseased", 0, "burnt"),
tree("legacytwiggy_diseased_stump", "diseased", 0, "stump"),

MakePlacer("sap_legacytwiggy_placer", "twiggy", "legacytwiggy_build", "sway1_loop_short", false, nil, nil, nil, nil, nil, twiggyplacefn),
MakePlacer("sap_legacytwiggy_diseased_placer", "twiggy", "legacytwiggy_diseased_build", "sway1_loop_short", false, nil, nil, nil, nil, nil, twiggyplacefn)