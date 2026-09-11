require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/atrium_gate.zip"),
	Asset("ANIM", "anim/atrium_gate_build.zip"),
    Asset("ANIM", "anim/atrium_floor.zip"),
	Asset("ANIM", "anim/kyno_ancientgateway.zip"),
}

local prefabs =
{
	"sap_ancientgateway2",
    "atrium_gate_activatedfx",
    "atrium_gate_pulsesfx",
    "atrium_gate_explodesfx",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function DoPulse(inst)
	if inst:HasTag("thegateway") then
		inst:DoTaskInTime(5 + math.random() * 5, function() DoPulse(inst) end)
		inst.AnimState:PlayAnimation("overload_pulse")
		inst.SoundEmitter:PlaySound("dontstarve/common/together/atrium_gate/shadow_pulse")
		inst.AnimState:PushAnimation("overload_loop", true)
	end
end

local function TestItem(inst, item, giver)
	if item.components.inventoryitem ~= nil and item.prefab == "dreadstone" then
		return true -- Accept the Item.
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.inventoryitem ~= nil and item.prefab == "dreadstone" then
		SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
		
		local newportal = SpawnPrefab("sap_ancientgateway2")
		newportal.Transform:SetPosition(inst.Transform:GetWorldPosition())
		newportal.SoundEmitter:PlaySound("rifts2/atrium/fixed")
	end
	
	inst:Remove()
end

local function CreateFloor()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("atrium_floor")
    inst.AnimState:SetBuild("atrium_floor")
    inst.AnimState:PlayAnimation("idle_active")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)

    return inst
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("atrium_gate.png")
	
    inst.AnimState:SetBank("atrium_gate")
    inst.AnimState:SetBuild("atrium_gate")
    inst.AnimState:PlayAnimation("idle", true)
    
	inst:AddTag("trader")
	inst:AddTag("structure")
	inst:AddTag("thegateway")
	
	-- DoPulse(inst)
	
	-- if not TheNet:IsDedicated() then
    --    CreateFloor().entity:SetParent(inst.entity)
    -- end
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	-- inst.SoundEmitter:PlaySound("dontstarve/common/together/atrium_gate/destabilize_LP", "loop")
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(TestItem)
    inst.components.trader.onaccept = OnGetItemFromPlayer
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function wipfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("atrium_gate.png")
	
	local s = 1.2
	inst.AnimState:SetScale(s, s, s)
	
    inst.AnimState:SetBank("kyno_ancientgateway")
    inst.AnimState:SetBuild("kyno_ancientgateway")
    inst.AnimState:PlayAnimation("idle", true)
    
	inst:AddTag("structure")
	inst:AddTag("wipgateway")
	
	-- if not TheNet:IsDedicated() then
    -- 	  CreateFloor().entity:SetParent(inst.entity)
    -- end
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function builtfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("atrium_gate.png")
	
    inst.AnimState:SetBank("atrium_gate")
    inst.AnimState:SetBuild("atrium_gate_build")
    inst.AnimState:PlayAnimation("fixed", false)
    
	inst:AddTag("structure")
	inst:AddTag("thegateway")
	
	-- DoPulse(inst)
	
	-- if not TheNet:IsDedicated() then
    --    CreateFloor().entity:SetParent(inst.entity)
    -- end
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	-- inst.SoundEmitter:PlaySound("dontstarve/common/together/atrium_gate/destabilize_LP", "loop")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_ATRIUMGATEWAY"
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({
		"thulecite", "thulecite", "thulecite",
		"nightmarefuel", "nightmarefuel", "nightmarefuel",
		"cutstone", "cutstone", "dreadstone"})
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function gatewayplacetestfn(inst)
	local s = 1.2
	inst.AnimState:SetScale(s, s, s)
end

return Prefab("sap_atriumgateway", fn, assets, prefabs),
Prefab("sap_ancientgateway2", builtfn, assets, prefabs),
Prefab("sap_atriumgateway_wip", wipfn, assets, prefabs),
Prefab("sap_atriumfloor", CreateFloor, assets, prefabs),
MakePlacer("sap_atriumgateway_placer", "atrium_gate", "atrium_gate", "idle"),
MakePlacer("sap_atriumgateway_wip_placer", "kyno_ancientgateway", "kyno_ancientgateway", "idle", false, nil, nil, nil, nil, nil, gatewayplacetestfn),
MakePlacer("sap_atriumfloor_placer", "atrium_floor", "atrium_floor", "idle_active", true)