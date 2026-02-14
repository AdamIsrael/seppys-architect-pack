local assets =
{
    Asset("ANIM", "anim/cave_hole.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"collapse_big",
	"small_puff"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function SetObjectInHole(inst, obj)
    obj.Physics:SetActive(false)
    obj:AddTag("outofreach")
    inst:ListenForEvent("onremove", inst._onremoveobj, obj)
    inst:ListenForEvent("onpickup", inst._onpickupobj, obj)
end

local function ShouldAcceptItem(inst, item)
	if item.components.inventoryitem ~= nil then
	return true
	end
end

local function OnGetItemFromPlayer(inst)
    if inst.allowspawn and inst.components.inventoryitem then
        local myitem = inst.components.objectspawner:SpawnObject(myitem)

        if myitem_stacksize[myitem.prefab] ~= nil and myitem.components.stackable ~= nil then
            local stacksize = myitem_stacksize[myitem.prefab]()
            myitem.components.stackable:SetStackSize(stacksize)
        end

        local x, y, z = inst.Transform:GetWorldPosition()
        myitem.Physics:Teleport(x, y, z)

        if not inst:IsAsleep() then
            SpawnPrefab("small_puff").Transform:SetPosition(x, y, z)
        end
    end

    inst.allowspawn = false
end

local function OnSave(inst, data)
    data.allowspawn = inst.allowspawn
end

local function OnLoad(inst, data)
    if data ~= nil then
        inst.allowspawn = data.allowspawn
    end
end

local function CreateSurfaceAnim()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

	inst.Transform:SetEightFaced()
	
    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")
    inst.persists = false

    inst.AnimState:SetBank("cave_hole")
    inst.AnimState:SetBuild("cave_hole")
    inst.AnimState:Hide("hole")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)

    return inst
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Transform:SetEightFaced()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cave_hole.png")

    -- MakeObstaclePhysics(inst, 2.75)
	
	inst.entity:AddPhysics()
    inst.Physics:SetMass(0)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    inst.Physics:SetCylinder(2.75, 6)

    inst.AnimState:SetBank("cave_hole")
    inst.AnimState:SetBuild("cave_hole")
    inst.AnimState:Hide("surface")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
    inst.AnimState:SetSortOrder(2)

	inst:AddTag("structure")
	inst:AddTag("groundhole")
    inst:AddTag("blocker")
	
    if not TheNet:IsDedicated() then
        CreateSurfaceAnim().entity:SetParent(inst.entity)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(3)
	
	-- inst:AddComponent("trader")
	-- inst.components.trader:SetAcceptTest(ShouldAcceptItem)
    -- inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:AddComponent("objectspawner")
    inst.components.objectspawner.onnewobjectfn = SetObjectInHole
	
	inst._onremoveobj = function(obj)
        table.removearrayvalue(inst.components.objectspawner.objects, obj)
    end

    inst._onpickupobj = function(obj)
        obj.Physics:SetActive(true)
        obj:RemoveTag("outofreach")
        inst._onremoveobj(obj)
        inst:RemoveEventCallback("onremove", inst._onremoveobj, obj)
        inst:RemoveEventCallback("onpickup", inst._onpickupobj, obj)
    end
	
	inst.allowspawn = true
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	
    return inst
end

return Prefab("kyno_ruinshole", fn, assets, prefabs),
MakePlacer("kyno_ruinshole_placer", "cave_hole", "cave_hole", "idle", true)