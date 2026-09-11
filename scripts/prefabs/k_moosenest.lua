require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/goosemoose_nest.zip"),
}

local prefabs =
{
    "moose_nest_fx_idle",
    "moose_nest_fx_hit",
}

local function DoEffect(inst)
	local fx = SpawnPrefab("moose_nest_fx_idle")
	local pos = inst:GetPosition()
		fx.Transform:SetPosition(pos.x, 0.1, pos.z)
	if inst.fx_task then
		inst.fx_task:Cancel()
		inst.fx_task = nil
	end
	inst.fx_task = inst:DoTaskInTime(math.random() * 10, DoEffect)
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("nest")
    inst.AnimState:PushAnimation("nest")
end

local function onhit_egg(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle")
	local fx = SpawnPrefab("moose_nest_fx_hit")
	local pos = inst:GetPosition()
	fx.Transform:SetPosition(pos.x, 0.1, pos.z)
end

local function rename(inst)
    inst.components.named:PickNewName()
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetScale(1.33, 1.33, 1.33)
	
    inst.AnimState:SetBank("goosemoose_nest")
    inst.AnimState:SetBuild("goosemoose_nest")
    inst.AnimState:PlayAnimation("nest")
    
	inst:AddTag("structure")
	inst:AddTag("lightningrod")
	inst:AddTag("_named")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:RemoveTag("_named")
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOOSEEGG"
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Moose Nest", "Goose Nest" }
    inst.components.named:PickNewName()
    inst:DoPeriodicTask(5, rename)
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	MakeHauntableWork(inst)
	
    return inst
end

local function eggfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    inst.AnimState:SetScale(1.33, 1.33, 1.33)
	MakeObstaclePhysics(inst, 1)
	
    inst.AnimState:SetBank("goosemoose_nest")
    inst.AnimState:SetBuild("goosemoose_nest")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("lightningrod")
	inst:AddTag("_named")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:RemoveTag("_named")
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOOSEEGG"
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Moose Egg", "Goose Egg", "BFB Egg" }
    inst.components.named:PickNewName()
    inst:DoPeriodicTask(5, rename)
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_egg)
	
	MakeHauntableWork(inst)
	DoEffect(inst)
	
    return inst
end

local function eggplacetestfn(inst)
	inst.AnimState:SetScale(1.33, 1.33, 1.33)
end

return Prefab("sap_goosenest", fn, assets, prefabs),
Prefab("sap_goosenestegg", eggfn, assets, prefabs),
MakePlacer("sap_goosenest_placer", "goosemoose_nest", "goosemoose_nest", "nest", false, nil, nil, nil, nil, nil, eggplacetestfn),
MakePlacer("sap_goosenestegg_placer", "goosemoose_nest", "goosemoose_nest", "idle", false, nil, nil, nil, nil, nil, eggplacetestfn)