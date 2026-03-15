require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/kyno_adai_desolate_tree.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"log",
	"acorn",
}

local function chop_tree(inst, chopper, chopsleft, numchops)
    if not (chopper ~= nil and chopper:HasTag("playerghost")) then
        inst.SoundEmitter:PlaySound(
            chopper ~= nil and chopper:HasTag("beaver") and
            "dontstarve/characters/woodie/beaver_chop_tree" or
            "dontstarve/wilson/use_axe_tree"
        )
    end

    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)

    local x, y, z = inst.Transform:GetWorldPosition()
	SpawnPrefab(math.random() < 0.5 and "green_leaves_chop" or "green_leaves_chop").Transform:SetPosition(x, y + math.random(), z)
end

local function chop_down_tree_shake(inst)
    ShakeAllCameras(CAMERASHAKE.FULL, .25, .03, .5, inst, 6)
end

local function chop_down_tree(inst, chopper)
    local pt = inst:GetPosition()

    local he_right = true
    if chopper then
        local hispos = chopper:GetPosition()
        he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
    else
        if math.random() > 0.5 then
            he_right = false
        end
    end
    if he_right then
        inst.AnimState:PlayAnimation("fallright")
        inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
        inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    else
        inst.AnimState:PlayAnimation("fallleft")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
        inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
    end

	inst.persists = false
	inst:DoTaskInTime(14*FRAMES, chop_down_tree_shake)
	inst:ListenForEvent("animover", inst.Remove)
	SpawnPrefab("sap_oaktree_stump").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function dig_up(inst, chopper)
    inst.components.lootdropper:SpawnLootPrefab("log")
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_adai_tree.tex")
	minimap:SetPriority(5)

	inst.AnimState:SetBank("kyno_adai_desolate_tree")
	inst.AnimState:SetBuild("kyno_adai_desolate_tree")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("plant")
	inst:AddTag("tree")
	inst:AddTag("shelter")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.AnimState:SetTime(math.random()*2)

    local color = 0.5 + math.random() * 0.5
    inst.AnimState:SetMultColour(color, color, color, 1)
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"log", "log", "acorn"})

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(15)
	inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree)

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
	MakeSnowCovered(inst)

	return inst
end

local function stumpfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, .5)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_adai_tree_stump.tex")
	minimap:SetPriority(5)

    inst.AnimState:SetBuild("kyno_adai_desolate_tree")
    inst.AnimState:SetBank("kyno_adai_desolate_tree")
    inst.AnimState:PlayAnimation("stump", true)

    inst:AddTag("stump")
    inst:AddTag("hallowed")
	
	inst:SetPrefabNameOverride("sap_oaktree")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random()*2)

    local color = 0.5 + math.random() * 0.5
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(dig_up)
    inst.components.workable:SetWorkLeft(1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeLargeBurnable(inst)
    MakeMediumPropagator(inst)
    MakeHauntableIgnite(inst)

    return inst
end

return Prefab("sap_oaktree", fn, assets, prefabs),
Prefab("sap_oaktree_stump", stumpfn, assets, prefabs),
MakePlacer("sap_oaktree_placer", "kyno_adai_desolate_tree", "kyno_adai_desolate_tree", "idle")