require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/klaus_bag.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function OnActivate(inst)
	inst.AnimState:PlayAnimation("open")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/chain_foley")
	inst.SoundEmitter:PlaySound("dontstarve/creatures/together/klaus/lock_break")
	inst:DoPeriodicTask(0.6, function()
	inst.components.lootdropper:DropLoot()
	inst:Remove()
	end)
end

local function Jiggle(inst)
if inst:HasTag("klaus_bag") then
	inst:DoTaskInTime(4+math.random()*5, function() Jiggle(inst) end)
		inst.AnimState:PlayAnimation("jiggle")
		inst.SoundEmitter:PlaySound("dontstarve/creatures/together/deer/chain")
		inst.AnimState:PushAnimation("idle")
	end
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
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("klaus_sack.png")

    inst.AnimState:SetBank("klaus_bag")
    inst.AnimState:SetBuild("klaus_bag")
    inst.AnimState:PlayAnimation("idle")
	
	MakeObstaclePhysics(inst, 1)

	inst:AddTag("structure")	
	inst:AddTag("klaus_bag")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("_named")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:RemoveTag("_named")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KLAUS_SACK"
	
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("activatable")
    inst.components.activatable.quickaction = false
    inst.components.activatable.OnActivate = OnActivate
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Loot Stash", "Free Loot", "Endless Musket Pouch", "Claptrap's Secret Stash", "Large Krampus Sack" }
    inst.components.named:PickNewName()
    inst:DoPeriodicTask(5, rename)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	Jiggle(inst)

    return inst
end

local function winterfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("klaus_sack.png")

    inst.AnimState:SetBank("klaus_bag")
    inst.AnimState:SetBuild("klaus_bag")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:OverrideSymbol("swap_chain", "klaus_bag", "swap_chain_winter")
	inst.AnimState:OverrideSymbol("swap_chain_link", "klaus_bag", "swap_chain_link_winter")
	inst.AnimState:OverrideSymbol("swap_chain_lock", "klaus_bag", "swap_chain_lock_winter")
	
	MakeObstaclePhysics(inst, 1)

	inst:AddTag("structure")	
	inst:AddTag("klaus_bag")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("_named")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:RemoveTag("_named")

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KLAUS_SACK"
	
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("activatable")
    inst.components.activatable.quickaction = false
    inst.components.activatable.OnActivate = OnActivate
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Loot Stash", "Free Loot", "Endless Musket Pouch", "Claptrap's Secret Stash", "Large Krampus Sack" }
    inst.components.named:PickNewName()
    inst:DoPeriodicTask(5, rename)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	Jiggle(inst)

    return inst
end

local function klausbagplacetestfn(inst)
	inst.AnimState:OverrideSymbol("swap_chain", "klaus_bag", "swap_chain_winter")
	inst.AnimState:OverrideSymbol("swap_chain_link", "klaus_bag", "swap_chain_link_winter")
	inst.AnimState:OverrideSymbol("swap_chain_lock", "klaus_bag", "swap_chain_lock_winter")
end

return Prefab("kyno_klausbag", fn, assets, prefabs),
Prefab("kyno_klausbag_winter", winterfn, assets, prefabs),
MakePlacer("kyno_klausbag_placer", "klaus_bag", "klaus_bag", "idle"),
MakePlacer("kyno_klausbag_winter_placer", "klaus_bag", "klaus_bag", "idle", false, nil, nil, nil, nil, nil, klausbagplacetestfn)