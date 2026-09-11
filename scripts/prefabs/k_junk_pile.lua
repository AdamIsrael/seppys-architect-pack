require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/scrappile.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"wagpunk_bits",
	"junk_break_fx",
}

local function OnPickedBigFn(inst, digger)
	local pile = SpawnPrefab("sap_junk_pile_med")
	pile.Transform:SetPosition(inst.Transform:GetWorldPosition())

	SpawnPrefab("junk_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("qol1/wagstaff_ruins/rummagepile_lrg")
    
	inst:Remove()
end

local function OnPickedMedFn(inst, digger)
	local pile = SpawnPrefab("sap_junk_pile_low")
	pile.Transform:SetPosition(inst.Transform:GetWorldPosition())

	SpawnPrefab("junk_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("qol1/wagstaff_ruins/rummagepile_med")
	
	inst:Remove()
end

local function OnPickedLowFn(inst, digger)
	inst.components.lootdropper:DropLoot()

	SpawnPrefab("junk_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("qol1/wagstaff_ruins/rummagepile_sml")
	
	inst:Remove()
end

local function commonfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("junk_pile.png")
	
    inst.AnimState:SetBank("scrappile")
    inst.AnimState:SetBuild("scrappile")
    
	inst:AddTag("structure")
	inst:AddTag("pickable_rummage_str")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "JUNK_PILE"
	
	inst:AddComponent("pickable")
    inst.components.pickable:SetUp(nil, 0)
    inst.components.pickable.onpickedfn = OnPickedBigFn
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"
	
    return inst
end

local function big1fn()
    local inst = commonfn()
	
    inst.AnimState:PlayAnimation("big_idle")
	
    return inst
end

local function big2fn()
    local inst = commonfn()
	
    inst.AnimState:PlayAnimation("idle1")
	
    return inst
end

local function big3fn()
    local inst = commonfn()
	
    inst.AnimState:PlayAnimation("idle2")
	
    return inst
end

local function big4fn()
    local inst = commonfn()
	
    inst.AnimState:PlayAnimation("idle3")
	
    return inst
end

local function big5fn()
    local inst = commonfn()
	
    inst.AnimState:PlayAnimation("side_idle1")
	
    return inst
end

local function big6fn()
    local inst = commonfn()
	
    inst.AnimState:PlayAnimation("side_idle2")
	
    return inst
end

local function medfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("junk_pile.png")
	
    inst.AnimState:SetBank("scrappile")
    inst.AnimState:SetBuild("scrappile")
	inst.AnimState:PlayAnimation("idlemed", true)
	
	inst:AddTag("structure")
	inst:AddTag("pickable_rummage_str")
	
	inst:SetPrefabNameOverride("JUNK_PILE")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "JUNK_PILE"
	
	inst:AddComponent("pickable")
    inst.components.pickable:SetUp(nil, 0)
    inst.components.pickable.onpickedfn = OnPickedMedFn
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"

	return inst
end

local function lowfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("junk_pile.png")
	
    inst.AnimState:SetBank("scrappile")
    inst.AnimState:SetBuild("scrappile")
	inst.AnimState:PlayAnimation("idlelow", true)
	
	inst:AddTag("structure")
	inst:AddTag("pickable_rummage_str")
	
	inst:SetPrefabNameOverride("JUNK_PILE")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"wagpunk_bits"})
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "JUNK_PILE"
	
	inst:AddComponent("pickable")
    inst.components.pickable:SetUp(nil, 0)
    inst.components.pickable.onpickedfn = OnPickedLowFn
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"

	return inst
end

return Prefab("sap_junk_pile_big1", big1fn, assets),
Prefab("sap_junk_pile_big2", big2fn, assets),
Prefab("sap_junk_pile_big3", big3fn, assets),
Prefab("sap_junk_pile_big4", big4fn, assets),
Prefab("sap_junk_pile_big5", big5fn, assets),
Prefab("sap_junk_pile_big6", big6fn, assets),
Prefab("sap_junk_pile_med", medfn, assets, prefabs),
Prefab("sap_junk_pile_low", lowfn, assets, prefabs),
MakePlacer("sap_junk_pile_big1_placer", "scrappile", "scrappile", "big_idle"),
MakePlacer("sap_junk_pile_big2_placer", "scrappile", "scrappile", "idle1"),
MakePlacer("sap_junk_pile_big3_placer", "scrappile", "scrappile", "idle2"),
MakePlacer("sap_junk_pile_big4_placer", "scrappile", "scrappile", "idle3"),
MakePlacer("sap_junk_pile_big5_placer", "scrappile", "scrappile", "side_idle1"),
MakePlacer("sap_junk_pile_big6_placer", "scrappile", "scrappile", "side_idle2")