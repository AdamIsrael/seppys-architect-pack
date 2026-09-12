require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_powderbarrel.zip"),
	Asset("ANIM", "anim/explode.zip"),
}

local prefabs =
{
	"explode_small"
}

local function OnHammered(inst, worker)
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function OnHit(inst)
	inst.AnimState:PlayAnimation("barrel_off")
	inst.AnimState:PushAnimation("barrel_off", false)
end

local function OnIgniteFn(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_fuse_LP", "hiss")
	inst.AnimState:PushAnimation("barrel_on", false)
    DefaultBurnFn(inst)
end

local function OnExtinguishFn(inst)
    inst.SoundEmitter:KillSound("hiss")
	inst.AnimState:PushAnimation("barrel_off", false)
    DefaultExtinguishFn(inst)
end

local function OnExplodeFn(inst)
    inst.SoundEmitter:KillSound("hiss")
    SpawnPrefab("explode_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
end

local function OnHitFn(inst)
	if inst.components.burnable then
		inst.components.burnable:Ignite()
		inst.AnimState:PushAnimation("barrel_on", false)
	end
	if inst.components.freezable then
		inst.components.freezable:Unfreeze()
	end
	if inst.components.health then
		inst.components.health:DoFireDamage(0)
	end
end

local s = 1.3

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)
	inst.AnimState:SetScale(s, s, s)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_powderbarrel.tex")
	
	inst.AnimState:SetBank("kyno_powderbarrel")
	inst.AnimState:SetBuild("kyno_powderbarrel")
	inst.AnimState:PlayAnimation("barrel_off", false)
	
	inst:AddTag("structure")
	inst:AddTag("explosive")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

	inst:AddComponent("combat")
	inst.components.combat:SetOnHit(OnHitFn)
	
	inst:AddComponent("explosive")
    inst.components.explosive:SetOnExplodeFn(OnExplodeFn)
    inst.components.explosive.explosivedamage = 5000 -- Let's kill some players...
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	
	MakeHauntableLaunchAndIgnite(inst)
	MakeSmallBurnable(inst, 3 + math.random() * 3)
	inst.components.burnable:SetOnBurntFn(nil)
    inst.components.burnable:SetOnIgniteFn(OnIgniteFn)
    inst.components.burnable:SetOnExtinguishFn(OnExtinguishFn)
	MakeSmallPropagator(inst)

	return inst
end

local function barrelplacerfn(inst)
	inst.AnimState:SetScale(s, s, s)
end

return Prefab("sap_gunpowderbarrel", fn, assets, prefabs),
MakePlacer("sap_gunpowderbarrel_placer", "kyno_powderbarrel", "kyno_powderbarrel", "barrel_off", false, nil, nil, nil, nil, nil, barrelplacerfn)  