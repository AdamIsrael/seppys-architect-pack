require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/carnival_plaza.zip"),
	Asset("ANIM", "anim/kyno_carnival_tree.zip"),
	Asset("ANIM", "anim/kyno_carnival_tree2.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
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
    SpawnPrefab(math.random() < 0.5 and "orange_leaves_chop" or "yellow_leaves_chop").Transform:SetPosition(x, y + math.random(), z)
end

local function chop_down_tree_shake(inst)
	inst.SoundEmitter:PlaySound("summerevent/plaza/hit")
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
        inst.SoundEmitter:PlaySound("summerevent/plaza/fall")
    else
        inst.AnimState:PlayAnimation("fallleft")
        inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
        inst.SoundEmitter:PlaySound("summerevent/plaza/fall")
    end

	inst.persists = false
	inst:DoTaskInTime(14*FRAMES, chop_down_tree_shake)
	inst:ListenForEvent("animover", inst.Remove)
	SpawnPrefab("log").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
    inst.SoundEmitter:PlaySound("summerevent/plaza/place")
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
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
	minimap:SetIcon("carnival_plaza.png")
	minimap:SetPriority(5)

	inst.AnimState:SetBank("carnival_plaza")
	inst.AnimState:SetBuild("carnival_plaza")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("sap_carnival")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CARNIVAL_PLAZA"

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(5)
	inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree)

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
	MakeSnowCovered(inst)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function naturalfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("carnival_plaza.png")
	minimap:SetPriority(5)

	inst.AnimState:SetBank("kyno_carnival_tree")
	inst.AnimState:SetBuild("kyno_carnival_tree")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("sap_carnival")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CARNIVAL_PLAZA"

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(5)
	inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree)

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
	MakeSnowCovered(inst)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function noleaffn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("carnival_plaza.png")
	minimap:SetPriority(5)

	inst.AnimState:SetBank("kyno_carnival_tree2")
	inst.AnimState:SetBuild("kyno_carnival_tree2")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("leaves")
	inst.AnimState:Hide("leaves-0")
	inst.AnimState:Hide("leaves-1")
	inst.AnimState:Hide("leaves-2")
	
	inst:AddTag("structure")
	inst:AddTag("sap_carnival")
	
	MakeSnowCoveredPristine(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CARNIVAL_PLAZA"

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetWorkLeft(5)
	inst.components.workable:SetOnWorkCallback(chop_tree)
    inst.components.workable:SetOnFinishCallback(chop_down_tree)

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
	MakeSnowCovered(inst)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function floorfn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetBank("carnival_plaza_floor")
	inst.AnimState:SetBuild("carnival_plaza_floor")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(-2)
	
	inst:AddTag("NOBLOCK")
	inst:AddTag("structure")

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")

	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)

	inst:ListenForEvent("onbuilt", function() inst.AnimState:PlayAnimation("place") inst.AnimState:PushAnimation("idle", false) end)

	return inst
end

local function carnivalplacer(inst)
	inst.AnimState:Hide("leaves-0")
	inst.AnimState:Hide("leaves-1")
	inst.AnimState:Hide("leaves-2")
end

return Prefab("sap_carnival_tree", fn, assets, prefabs),
Prefab("sap_carnival_tree_natural", naturalfn, assets, prefabs),
Prefab("sap_carnival_tree_noleaf", noleaffn, assets, prefabs),
Prefab("sap_carnival_tree_floor", floorfn, assets, prefabs),
MakePlacer("sap_carnival_tree_placer", "carnival_plaza", "carnival_plaza", "idle"),
MakePlacer("sap_carnival_tree_natural_placer", "kyno_carnival_tree", "kyno_carnival_tree", "idle"),
MakePlacer("sap_carnival_tree_noleaf_placer", "kyno_carnival_tree2", "kyno_carnival_tree2", "idle", false, nil, nil, nil, nil, nil, carnivalplacer),
MakePlacer("sap_carnival_tree_floor_placer", "carnival_plaza_floor", "carnival_plaza_floor", "idle", true, nil, nil, nil, 90, nil)