require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/water_chest.zip"),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
}

local prefabs =
{
    "collapse_small",
}

local function onopen(inst)
    if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("open")
        inst.AnimState:PushAnimation("opened")
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
    end
end 

local function onclose(inst)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("close")
        inst.AnimState:PushAnimation("closed", true)
        inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
    end
end

local function onhammered(inst, worker)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() then
        inst.components.burnable:Extinguish()
    end
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    if not inst:HasTag("burnt") then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("closed", false)
        if inst.components.container ~= nil then
            inst.components.container:DropEverything()
            inst.components.container:Close()
        end
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("close")
	inst.AnimState:PushAnimation("closed", true)
    inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
end

local function onsave(inst, data)
    if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
        data.burnt = true
    end
end

local function onload(inst, data)
    if data ~= nil and data.burnt and inst.components.burnable ~= nil then
        inst.components.burnable.onburnt(inst)
    end
end

local DAMAGE_SCALE = 0.5
local function OnCollide(inst, data)
    local boat_physics = data.other.components.boatphysics
    if boat_physics ~= nil then
        local hit_velocity = math.floor(math.abs(boat_physics:GetVelocity() * data.hit_dot_velocity) * DAMAGE_SCALE / boat_physics.max_velocity + 0.5)
        inst.components.workable:WorkedBy(data.other, hit_velocity * TUNING.EVERGREEN_CHOPS_SMALL)
    end
end

local function GetStatus(inst, viewer)
    if inst._chestupgrade_stacksize then
        return "UPGRADED_STACKSIZE"
    end

    return "GENERIC"
end

local function OnUpgrade(inst, performer, upgraded_from_item)
    local numupgrades = inst.components.upgradeable.numupgrades
	
    if numupgrades == 1 then
        inst._chestupgrade_stacksize = true
		
        if inst.components.container ~= nil then
            inst.components.container:Close()
            inst.components.container:EnableInfiniteStackSize(true)
            inst.components.inspectable.getstatus = GetStatus
        end
		
        if upgraded_from_item then
            local x, y, z = inst.Transform:GetWorldPosition()
            local fx = SpawnPrefab("chestupgrade_stacksize_fx")
            fx.Transform:SetPosition(x, y, z)
        end
    end
	
    inst.components.upgradeable.upgradetype = nil
	
	if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot({"alterguardianhatshard"})
    end
end

local function OnLoadPostPass(inst, newents, data)
    if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
        OnUpgrade(inst)
    end
end

local function OnDecontructStructure(inst, caster)
    if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
        if inst.components.lootdropper ~= nil then
            inst.components.lootdropper:SpawnLootPrefab("alterguardianhatshard")
        end
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_seachest.tex")

    inst.AnimState:SetBank("water_chest")
    inst.AnimState:SetBuild("water_chest")
    inst.AnimState:PlayAnimation("closed", true)
	
	-- inst:SetPhysicsRadiusOverride(.5)
	-- MakeWaterObstaclePhysics(inst, .5, .5, .5)
	-- inst.Physics:SetDontRemoveOnSleep(true)

	inst:AddTag("structure")
    inst:AddTag("chest")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("treasurechest") end
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("treasurechest")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("upgradeable")
	inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
	inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)
	
    inst:ListenForEvent("onbuilt", onbuilt)
	inst:ListenForEvent("ondeconstructstructure", OnDecontructStructure)
	-- inst:ListenForEvent("on_collide", OnCollide)

    AddHauntableDropItemOrWork(inst)
	
	inst.OnLoadPostPass = OnLoadPostPass
	
    return inst
end

return Prefab("sap_waterchest", fn, assets),
MakePlacer("sap_waterchest_placer", "water_chest", "water_chest", "closed")