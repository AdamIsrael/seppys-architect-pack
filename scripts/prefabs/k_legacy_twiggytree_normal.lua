require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/legacy_twiggytree_short_normal.zip"),
	-- Asset("ANIM", "anim/legacy_twiggytree_tall_old.zip"),

	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),

	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),

	Asset("ANIM", "anim/dust_fx.zip"),
	Asset("SOUND", "sound/forest.fsb"),
}

local prefabs =
{
	"log",
	"twiggy_nut",
	"charcoal",
}

local function StopGrow(inst)
	inst.components.timer:StopTimer("grow")
end

local function GrowTwiggy(inst)
	if not inst.components.timer:TimerExists("grow") then
        local growtime = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
        inst.components.timer:StartTimer("grow", growtime)
    end
end

local function OnTimerDone(inst, data)
    if data.name == "grow" then
        inst.AnimState:PlayAnimation("grow_normal_to_tall")
		inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrowFromWilt")

		inst:ListenForEvent("animover", function() inst:Remove() end)
		inst:ListenForEvent("animover", function() SpawnPrefab("kyno_legacytwiggy_tall").Transform:SetPosition(inst.Transform:GetWorldPosition()) end)
    end
end

local function chop_down_burnt_tree(inst, chopper)
    inst:RemoveComponent("workable")

    inst.SoundEmitter:PlaySound("dontstarve/forest/treeCrumble")
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	inst.AnimState:PlayAnimation("chop_burnt_normal")

	RemovePhysicsColliders(inst)

	inst:ListenForEvent("animover", function() inst:Remove() end)
    inst.components.lootdropper:SpawnLootPrefab("charcoal")
    inst.components.lootdropper:DropLoot()
end

local function OnBurnt(inst)
	inst:DoTaskInTime( 0.5,
		function()
		    if inst.components.burnable then
			    inst.components.burnable:Extinguish()
			end
			inst:RemoveComponent("burnable")
			inst:RemoveComponent("propagator")

			inst.components.lootdropper:SetLoot({})

			if inst.components.workable then
				inst.components.workable:SetWorkLeft(1)
				inst.components.workable:SetOnWorkCallback(nil)
				inst.components.workable:SetOnFinishCallback(chop_down_burnt_tree)
			end
		end)

	inst.AnimState:PlayAnimation("burnt_normal", true)

    inst.AnimState:SetRayTestOnBB(true);
    inst:AddTag("burnt")

	StopGrow(inst)
end

local function ondug(inst, worker)
	inst:Remove()
	inst.components.lootdropper:SpawnLootPrefab("log")
end

local function makestump(inst, instant)
    inst:RemoveComponent("workable")
    RemovePhysicsColliders(inst)

    if instant then
    	inst.AnimState:PlayAnimation("stump_normal")
    else
    	inst.AnimState:PushAnimation("stump_normal")
    end

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(ondug)
    inst.components.workable:SetWorkLeft(1)

    inst:AddTag("stump")

	StopGrow(inst)
end

local function onworked(inst, chopper, workleft)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	end

	inst.AnimState:PlayAnimation("chop_normal")
	inst.AnimState:PushAnimation("sway1_loop_normal", true)
end

local function onworkfinish(inst, chopper)
	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local hispos = Vector3(chopper.Transform:GetWorldPosition())
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0

    if he_right then
        inst.AnimState:PlayAnimation("fallleft_normal")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation("fallright_normal")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

    makestump(inst)
end

local function onsave(inst, data)
	if inst:HasTag("stump") then
		data.stump = true
	end

    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.stump then
		makestump(inst, true)
	end

	if data and data.burnt then
		OnBurnt(inst)
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .75)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_legacytwiggy.tex")

	inst.AnimState:SetBank("twiggy_short_normal")
	inst.AnimState:SetBuild("legacy_twiggytree_short_normal")
	inst.AnimState:PlayAnimation("sway1_loop_normal", true)

	inst:AddTag("tree")
	inst:AddTag("workable")
	inst:AddTag("shelter")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log", "twiggy_nut", "twigs"})

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", OnTimerDone)

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "TWIGGYTREE"

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(10)
	inst.components.workable:SetOnWorkCallback(onworked)
	inst.components.workable:SetOnFinishCallback(onworkfinish)

    MakeLargeBurnable(inst)
	MakeSmallPropagator(inst)
    inst.components.burnable:SetFXLevel(5)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

	MakeSnowCovered(inst, .01)

	inst.OnSave = onsave
	inst.OnLoad = onload

	GrowTwiggy(inst)

	return inst
end

local function twiggyplacefn(inst)
	inst.AnimState:Hide("SNOW")
	inst.AnimState:Hide("symbol_1d298b03")
end

return Prefab("kyno_legacytwiggy_normal", fn, assets, prefabs),
MakePlacer("kyno_legacytwiggy_normal_placer", "twiggy_short_normal", "legacy_twiggytree_short_normal", "sway1_loop_normal", false, nil, nil, nil, nil, nil, twiggyplacefn)