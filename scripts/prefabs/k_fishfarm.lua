require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/fish_farm.zip"),	
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs =
{
    "pondfish",
	"kyno_koi",
	"kyno_neonfish",
	"kyno_grouper",
	"kyno_pierrotfish",
	"kyno_tropicalfish",
}

local FISH_BREED_TIME = 1920

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
		inst.components.burnable:Extinguish()
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle", true)
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle", true)
	inst.components.pickable:MakeEmpty()
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

local function onpickedfn(inst)
    inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/item_wet_harvest")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle", true)
	inst.AnimState:Hide("sign")
	inst.AnimState:Hide("fish")
	inst.AnimState:Hide("fish_body")
	inst.AnimState:Hide("fish_fin")
end

local function onregenfn(inst)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle", true)
	inst.AnimState:Show("sign")
	inst.AnimState:Show("fish")
	inst.AnimState:Show("fish_body")
	inst.AnimState:Show("fish_fin")
end

local function makeemptyfn(inst)
    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("sign")
	inst.AnimState:Hide("fish")
	inst.AnimState:Hide("fish_body")
	inst.AnimState:Hide("fish_fin")
end

local function AddFishes(inst, isautumn, iswinter, isspring, issummer)
	if TheWorld.state.isautumn then
		inst.components.pickable:ChangeProduct("kyno_koi")
	end
	if TheWorld.state.iswinter then
		inst.components.pickable:ChangeProduct("kyno_neonfish")
	end
	if TheWorld.state.isspring then
		inst.components.pickable:ChangeProduct("kyno_pierrotfish")
	end
	if TheWorld.state.issummer then
		inst.components.pickable:ChangeProduct("kyno_grouper")
	end
	inst:DoTaskInTime(4, function() AddFishes(inst) end) -- Repeat this function to update the fishes.
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_fishfarm.tex")
	
    inst.AnimState:SetBank("fish_farm")
    inst.AnimState:SetBuild("fish_farm")
    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	-- inst:SetPhysicsRadiusOverride(1.2)
	-- MakeWaterObstaclePhysics(inst, 1.2, 1.2, 1.2)
	-- inst.Physics:SetDontRemoveOnSleep(true)

	inst:AddTag("structure")
	inst:AddTag("aquatic")
	inst:AddTag("wet")
	inst:AddTag("ignorewalkableplatforms")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve_DLC002/common/item_wet_harvest"
    inst.components.pickable.onregenfn = onregenfn
    inst.components.pickable.onpickedfn = onpickedfn
    inst.components.pickable.makeemptyfn = makeemptyfn
	inst.components.pickable:SetUp("kyno_koi", FISH_BREED_TIME)
	
	AddFishes(inst)
	
    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	-- inst:ListenForEvent("on_collide", OnCollide)
	inst:ListenForEvent("onbuilt", onbuilt)

	inst.OnSave = onsave 
    inst.OnLoad = onload

    return inst
end

return Prefab("kyno_fishfarm", fn, assets, prefabs),
MakePlacer("kyno_fishfarm_placer", "fish_farm", "fish_farm", "idle")