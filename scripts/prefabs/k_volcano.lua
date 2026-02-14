require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/volcano.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC002.fev"),
	Asset("SOUND", "sound/dontstarve_shipwreckedSFX.fsb"),
}

local prefabs =
{
	"collapse_big"
}

local function onwork(inst, worker, workleft)
	if workleft < 100*(1/3) then
		inst.AnimState:PlayAnimation("active_idle", true)
	elseif workleft < 200*(2/3) then
		inst.AnimState:PlayAnimation("active_idle", true)
	else
		inst.AnimState:PlayAnimation("active_idle", true)
	end
end

local function onfinish(inst, worker)
	local pt = Point(inst.Transform:GetWorldPosition())
	inst.components.lootdropper:DropLoot(pt)
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function Erupt(inst)
if inst:HasTag("theVolcano") then
	inst:DoTaskInTime(100+math.random()*5, function() Erupt(inst) end)
		inst.AnimState:PlayAnimation("erupt")
		inst:DoTaskInTime(3, function() inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/volcano/volcano_erupt") end)
		inst.AnimState:PushAnimation("active_idle", true)
	end
end

local DAMAGE_SCALE = 10.0
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
	inst.entity:AddLight()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_volcano_active.tex")
	minimap:SetPriority(5)
	
    inst.Light:SetFalloff(0.4)
    inst.Light:SetIntensity(.7)
    inst.Light:SetRadius(10)
    inst.Light:SetColour(249/255, 130/255, 117/255)
    inst.Light:Enable(true)
	
	inst.AnimState:SetBank("volcano")
	inst.AnimState:SetBuild("volcano")
	inst.AnimState:PlayAnimation("active_idle", true)
	
	-- inst:SetPhysicsRadiusOverride(30)
	-- MakeWaterObstaclePhysics(inst, 30, 5)
	-- inst.Physics:SetDontRemoveOnSleep(true)
	
	inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("structure")
	inst:AddTag("theVolcano")
	inst:AddTag("aquatic")
	
	Erupt(inst)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/volcano/volcano_external_amb", "volcano")
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("heater")
    inst.components.heater.heat = 500
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(400)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	-- inst:ListenForEvent("on_collide", OnCollide)

	return inst
end

return Prefab("kyno_volcano", fn, assets, prefabs),
MakePlacer("kyno_volcano_placer", "volcano", "volcano", "active_idle")  