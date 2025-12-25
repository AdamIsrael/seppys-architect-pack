require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/zeb.zip"),
	Asset("ANIM", "anim/zeb_build.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs =
{
    "meat",
	"manrabbit_tail",
}

SetSharedLootTable('kyno_zeb',
{
    {'meat',             1.00},
    {'meat',             1.00},
    {'manrabbit_tail',   1.00},
})

local ZEB_TARGET_DIST 	= 5
local ZEB_CHASE_DIST	= 30
local ZEB_DAMAGE 		= 20
local ZEB_ATTACK_RANGE 	= 3
local ZEB_ATTACK_PERIOD = 2
local ZEB_WALK_SPEED 	= 6
local ZEB_RUN_SPEED 	= 10
local ZEB_FOLLOW_TIME 	= 30

local function RetargetFn(inst)
    if inst.charged then
        local targ = FindEntity(inst, ZEB_TARGET_DIST, function(guy)
            return not guy:HasTag("zeb") and 
			inst.components.combat:CanTarget(guy) and 
			not guy:HasTag("wall")
        end)
        if not targ then
            targ = FindEntity(inst, ZEB_TARGET_DIST, function(guy)
                return not guy:HasTag("zeb") and 
					inst.components.combat:CanTarget(guy)
				end)
			end
        return targ
    end
end

local function KeepTargetFn(inst, target)
    if target:HasTag("wall") then 
        local newtarg = FindEntity(inst, ZEB_TARGET_DIST, function(guy)
            return not guy:HasTag("zeb") and 
			inst.components.combat:CanTarget(guy) and 
			not guy:HasTag("wall")
        end)
        return newtarg == nil
    else
        if inst.components.herdmember
        and inst.components.herdmember:GetHerd() then
            local herd = inst.components.herdmember and inst.components.herdmember:GetHerd()
            if herd then
                return distsq(Vector3(herd.Transform:GetWorldPosition() ), Vector3(inst.Transform:GetWorldPosition() ) ) < ZEB_CHASE_DIST * ZEB_CHASE_DIST
            end
        end
        return true
    end
end

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
    inst.components.combat:SetTarget(attacker)
    inst.components.combat:ShareTarget(attacker, 20, function(dude) return dude:HasTag("zeb") end, 3) 
end

local function OnBuilt(inst)
	SpawnPrefab("kyno_zeb").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function builderfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.75,.75)
	
	inst.Transform:SetFourFaced()
	MakeCharacterPhysics(inst, 100, 1)
	
	inst.AnimState:SetBank("zeb")
	inst.AnimState:SetBuild("zeb_build")
	inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst:AddTag("animal")
	inst:AddTag("zeb")
	
	inst:SetPrefabNameOverride("kyno_zeb")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("knownlocations")
	inst:AddComponent("embarker")
	
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetChanceLootTable('kyno_zeb')

	inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
	
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(350)
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(ZEB_DAMAGE)
    inst.components.combat:SetRange(ZEB_ATTACK_RANGE)
    inst.components.combat.hiteffectsymbol = "sprint"
    inst.components.combat:SetAttackPeriod(ZEB_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst.components.combat:SetHurtSound("dontstarve_DLC003/creatures/zeb/hurt")
	
	inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = ZEB_WALK_SPEED
    inst.components.locomotor.runspeed = ZEB_RUN_SPEED
	inst.components.locomotor:SetAllowPlatformHopping(true)

    inst:SetStateGraph("SGzeb")
    
	local brain = require("brains/zebbrain")
    inst:SetBrain(brain)
	
	MakeMediumBurnableCharacter(inst, "spring")
    MakeMediumFreezableCharacter(inst, "spring")
	
	inst:ListenForEvent("attacked", OnAttacked)
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	return inst
end

local function fn()
	local inst = builderfn()
	
	inst:SetPrefabNameOverride("kyno_zeb")
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("herdmember")
    inst.components.herdmember:SetHerdPrefab("kyno_zeb_herd")
	
	inst.components.lootdropper:SetChanceLootTable('kyno_zeb')
	
	return inst
end

return Prefab("kyno_zeb_builder", builderfn, assets, prefabs),
Prefab("kyno_zeb", fn, assets, prefabs),
MakePlacer("kyno_zeb_builder_placer", "zeb", "zeb_build", "idle_loop")