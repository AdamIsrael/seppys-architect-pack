local assets =
{
    Asset("ANIM", "anim/quagmire_sapbucket.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_short.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_normal.zip"),
	Asset("ANIM", "anim/quagmire_tree_cotton_tall.zip"),
    Asset("ANIM", "anim/quagmire_tree_cotton_build.zip"),
    Asset("ANIM", "anim/quagmire_tree_cotton_trunk_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"log",
	"ash",
	"charcoal",
}

local function GrowTree(inst)
	local tree = SpawnPrefab(inst.growprefab) 
    if tree then 
		tree.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
        inst:Remove()
	end
end

local function stopgrowing(inst)
    inst.components.timer:StopTimer("grow")
end

startgrowing = function(inst)
    if not inst.components.timer:TimerExists("grow") then
        local growtime = GetRandomWithVariance(TUNING.PINECONE_GROWTIME.base, TUNING.PINECONE_GROWTIME.random)
        inst.components.timer:StartTimer("grow", growtime)
    end
end

local function OnTimerDone(inst, data)
    if data.name == "grow" then
        GrowTree(inst)
		inst.SoundEmitter:PlaySound("dontstarve/forest/treeGrow")
    end
end

local function DigUpStump(inst)
    inst.components.lootdropper:SpawnLootPrefab("log")
    inst:Remove()
end

local function MakeStumpSmall(inst)
	local stump = SpawnPrefab("cottontree_small_stump")
	stump.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
	
	inst:Remove()
end

local function MakeStumpNormal(inst)
	local stump = SpawnPrefab("cottontree_normal_stump")
	stump.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
	
	inst:Remove()
end

local function MakeStumpTall(inst)
	local stump = SpawnPrefab("cottontree_tall_stump")
	stump.Transform:SetPosition(inst.Transform:GetWorldPosition()) 
	
	inst:Remove()
end

local function PushSway(inst, skippre)
    inst.AnimState:PushAnimation(math.random() < .5 and "sway1_loop" or "sway2_loop", true)
end

local function ChopTree(inst, chopper, chops)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound(chopper ~= nil and chopper:HasTag("beaver") and
		"dontstarve/characters/woodie/beaver_chop_tree" or
		"dontstarve/wilson/use_axe_tree")
    end
    inst.AnimState:PlayAnimation("chop")

    PushSway(inst)
end

local function ChopDownTreeSmall(inst, chopper)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

    local pt = inst:GetPosition()
    local hispos = chopper:GetPosition()
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
    if he_right then
        inst.AnimState:PlayAnimation("fallleft")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation("fallright")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

	inst:ListenForEvent("animover", MakeStumpSmall)
end

local function ChopDownTreeNormal(inst, chopper)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

    local pt = inst:GetPosition()
    local hispos = chopper:GetPosition()
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
    if he_right then
        inst.AnimState:PlayAnimation("fallleft")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation("fallright")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end
	
	inst:ListenForEvent("animover", MakeStumpNormal)
end

local function ChopDownTreeTall(inst, chopper)
    inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")

    local pt = inst:GetPosition()
    local hispos = chopper:GetPosition()
    local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
    if he_right then
        inst.AnimState:PlayAnimation("fallleft")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
    else
        inst.AnimState:PlayAnimation("fallright")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
    end

	inst:ListenForEvent("animover", MakeStumpTall)
end

local function short_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.85, .85, .85)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("quagmire_sugarwoodtree.png")
    minimap:SetPriority(1)
	
	MakeObstaclePhysics(inst, .25)

	inst.AnimState:SetBank("quagmire_tree_cotton_short")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
    inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:PlayAnimation("sway1_loop", true)
	
	inst.AnimState:Hide("swap_tapper")
    inst.AnimState:Hide("sap")

	inst:AddTag("tree")
    inst:AddTag("shelter")
    inst:AddTag("cottontree_small")
		
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
		
	inst.growprefab = "cottontree_normal"
	inst.StartGrowing = startgrowing

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", OnTimerDone)
		
	startgrowing(inst)

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnWorkCallback(ChopTree)
    inst.components.workable:SetOnFinishCallback(ChopDownTreeSmall)
	inst.components.workable:SetWorkLeft(5)

	return inst
end

local function normal_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.85, .85, .85)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("quagmire_sugarwoodtree.png")
    minimap:SetPriority(1)
	
	MakeObstaclePhysics(inst, .25)

	inst.AnimState:SetBank("quagmire_tree_cotton_normal")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
    inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:PlayAnimation("sway1_loop", true)
	
	inst.AnimState:Hide("swap_tapper")
    inst.AnimState:Hide("sap")

	inst:AddTag("tree")
    inst:AddTag("shelter")
    inst:AddTag("cottontree_normal")
		
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
		
	inst.growprefab = "cottontree_tall"
	inst.StartGrowing = startgrowing

	inst:AddComponent("timer")
	inst:ListenForEvent("timerdone", OnTimerDone)
		
	startgrowing(inst)

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log", "log", "pinecone"})

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnWorkCallback(ChopTree)
    inst.components.workable:SetOnFinishCallback(ChopDownTreeNormal)
	inst.components.workable:SetWorkLeft(10)

	return inst
end

local function tall_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.85, .85, .85)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("quagmire_sugarwoodtree.png")
    minimap:SetPriority(1)
	
	MakeObstaclePhysics(inst, .25)

	inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
    inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:PlayAnimation("sway1_loop", true)
	
	inst.AnimState:Hide("swap_tapper")
    inst.AnimState:Hide("sap")

	inst:AddTag("tree")
    inst:AddTag("shelter")
    inst:AddTag("cottontree_tall")
		
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log", "log", "log", "pinecone", "pinecone"})

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnWorkCallback(ChopTree)
    inst.components.workable:SetOnFinishCallback(ChopDownTreeTall)
	inst.components.workable:SetWorkLeft(15)

	return inst
end

local function stump_small_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.85, .85, .85)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("quagmire_sugarwoodtree.png")
    minimap:SetPriority(1)

	inst.AnimState:SetBank("quagmire_tree_cotton_short")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
    inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:PlayAnimation("stump", true)
	
	inst.AnimState:Hide("swap_tapper")
    inst.AnimState:Hide("sap")

    inst:AddTag("cottontree")
		
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
		
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(DigUpStump)
	inst.components.workable:SetWorkLeft(1)

	return inst
end

local function stump_normal_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.85, .85, .85)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("quagmire_sugarwoodtree.png")
    minimap:SetPriority(1)

	inst.AnimState:SetBank("quagmire_tree_cotton_normal")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
    inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:PlayAnimation("stump", true)
	
	inst.AnimState:Hide("swap_tapper")
    inst.AnimState:Hide("sap")

    inst:AddTag("cottontree")
		
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
		
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(DigUpStump)
	inst.components.workable:SetWorkLeft(1)

	return inst
end

local function stump_tall_fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(.85, .85, .85)

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("quagmire_sugarwoodtree.png")
    minimap:SetPriority(1)

	inst.AnimState:SetBank("quagmire_tree_cotton_tall")
    inst.AnimState:SetBuild("quagmire_tree_cotton_build")
    inst.AnimState:AddOverrideBuild("quagmire_tree_cotton_trunk_build")
    inst.AnimState:PlayAnimation("stump", true)
	
	inst.AnimState:Hide("swap_tapper")
    inst.AnimState:Hide("sap")

    inst:AddTag("cottontree")
		
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
		
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "QUAGMIRE_SUGARWOODTREE"

	inst:AddComponent("lootdropper")

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(DigUpStump)
	inst.components.workable:SetWorkLeft(1)

	return inst
end

return Prefab("cottontree_small", short_fn, assets, prefabs),
Prefab("cottontree_normal", normal_fn, assets, prefabs),
Prefab("cottontree_tall", tall_fn, assets, prefabs),
Prefab("cottontree_small_stump", stump_small_fn, assets, prefabs),
Prefab("cottontree_normal_stump", stump_normal_fn, assets, prefabs),
Prefab("cottontree_tall_stump", stump_tall_fn, assets, prefabs)