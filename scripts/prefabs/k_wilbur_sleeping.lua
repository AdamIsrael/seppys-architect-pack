require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/wilbur.zip"),
	Asset("ANIM", "anim/wilbur_nocrown.zip"),
	Asset("ANIM", "anim/wilbur_raft_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs = 
{
	"kyno_wilbur_boat",
}

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	inst.AnimState:PlayAnimation("boat_death", false)
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/characters/wilbur/sinking_death")
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("small_to_full")
    inst.AnimState:PushAnimation("idle_full", true)
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.burnt then
        inst.components.burnable.onburnt(inst)
    end
end

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.SEASTACK_MINE)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_wilbursleeping.tex")

    inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("wilbur_nocrown")
	inst.AnimState:PlayAnimation("sleep", true)
	inst.AnimState:SetFinalOffset(3)
	inst.AnimState:Hide("ARM_carry")
	inst.AnimState:Hide("hat")
	inst.AnimState:Hide("hat_hair")
	inst.AnimState:Hide("PROPDROP")

	inst.AnimState:OverrideSymbol("fx_wipe", "wilson_fx", "fx_wipe")
	inst.AnimState:OverrideSymbol("fx_liquid", "wilson_fx", "fx_liquid")
	inst.AnimState:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")
	inst.AnimState:OverrideSymbol("ripplebase", "player_boat_death", "ripplebase")
	inst.AnimState:OverrideSymbol("waterline", "player_boat_death", "waterline")
	inst.AnimState:OverrideSymbol("waterline", "player_boat_death", "waterline")
	
	inst.AnimState:AddOverrideBuild("wilbur_raft_build")
    inst.AnimState:OverrideSymbol("flotsam", "flotsam_lograft_build", "flotsam")

	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("sleeping_monkey")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
	inst.boatprefab = SpawnPrefab("kyno_wilbur_boat")
	inst.boatprefab.entity:SetParent(inst.entity)
	end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:DoTaskInTime(FRAMES * 1, createExtras)

	inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("wilbur_raft")
	inst.AnimState:SetBuild("wilbur_raft_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst.AnimState:SetFinalOffset(0)
    inst.persists = false
	
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	return inst
end

local function wilburplacetestfn(inst)
	inst.AnimState:Hide("ARM_carry")
	inst.AnimState:Hide("hat")
	inst.AnimState:Hide("hat_hair")
	inst.AnimState:Hide("PROPDROP")

	inst.AnimState:OverrideSymbol("fx_wipe", "wilson_fx", "fx_wipe")
	inst.AnimState:OverrideSymbol("fx_liquid", "wilson_fx", "fx_liquid")
	inst.AnimState:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")
	inst.AnimState:OverrideSymbol("ripplebase", "player_boat_death", "ripplebase")
	inst.AnimState:OverrideSymbol("waterline", "player_boat_death", "waterline")
	inst.AnimState:OverrideSymbol("waterline", "player_boat_death", "waterline")
	
    inst.AnimState:OverrideSymbol("flotsam", "flotsam_lograft_build", "flotsam")
end

return Prefab("kyno_wilbur_sleeping", fn, assets, prefabs),
Prefab("kyno_wilbur_boat", fn2, assets, prefabs),
MakePlacer("kyno_wilbur_sleeping_placer", "wilbur_raft", "wilbur_raft_build", "idle")