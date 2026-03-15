local assets =
{
    Asset("ANIM", "anim/kyno_mast_01.zip"),
    Asset("ANIM", "anim/kyno_seafarer_mast_01.zip"),
	
	Asset("ANIM", "anim/kyno_mast_02.zip"),
    Asset("ANIM", "anim/kyno_seafarer_mast_02.zip"),
	
	Asset("ANIM", "anim/kyno_mast_03.zip"),
    Asset("ANIM", "anim/kyno_seafarer_mast_03.zip"),
	
	Asset("ANIM", "anim/kyno_mast_04.zip"),
    Asset("ANIM", "anim/kyno_seafarer_mast_04.zip"),
	
	Asset("ANIM", "anim/kyno_mast_05.zip"),
    Asset("ANIM", "anim/kyno_seafarer_mast_05.zip"),
	
	Asset("ANIM", "anim/kyno_mast_06.zip"),
    Asset("ANIM", "anim/kyno_seafarer_mast_06.zip"),
	
	Asset("ANIM", "anim/kyno_mast_07.zip"),
    Asset("ANIM", "anim/kyno_seafarer_mast_07.zip"),
	
	Asset("ANIM", "anim/kyno_mast_08.zip"),
    Asset("ANIM", "anim/kyno_seafarer_mast_08.zip"),
	
	Asset("ANIM", "anim/kyno_mast_09.zip"),
    Asset("ANIM", "anim/kyno_seafarer_mast_09.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
}

local malbatross_assets =
{
    Asset("ANIM", "anim/boat_mast_malbatross_wip.zip"),
    Asset("ANIM", "anim/boat_mast_malbatross_knots_wip.zip"), 
    Asset("ANIM", "anim/boat_mast_malbatross_opens_wip.zip"), 
    Asset("ANIM", "anim/boat_mast_malbatross_build.zip"),

    Asset("ANIM", "anim/seafarer_mast_malbatross.zip"),
}

local upgrade_assets =
{
    lamp =
    {
        Asset("ANIM", "anim/mastupgrade_lamp.zip"),
    },
    lightningrod =
    {
        Asset("ANIM", "anim/mastupgrade_lightningrod.zip"),
    },
}

local prefabs =
{
	"boat_mast_sink_fx",
	"collapse_small",
    "mast_item", -- deprecated but kept for existing worlds and mods
    "mastupgrade_lamp",
    "mastupgrade_lightningrod",
}

local malbatross_prefabs =
{
	"boat_malbatross_mast_sink_fx",
	"collapse_small",
    "mast_malbatross_item", -- deprecated but kept for existing worlds and mods
    "mastupgrade_lamp",
    "mastupgrade_lightningrod",
}

SetSharedLootTable('kyno_masts',
{
    {'silk',             		1.00},
    {'silk',             		1.00},
    {'silk',             		1.00},
    {'silk',             		1.00},
    {'boards',             	    1.00},
    {'boards',             	    1.00},
    {'rope',             		1.00},
    {'rope',             		1.00},

})

local LIGHT_RADIUS = { MIN=2, MAX=5 }
local LIGHT_COLOUR = Vector3(180 / 255, 195 / 255, 150 / 255)
local LIGHT_INTENSITY = { MIN=0.4, MAX=0.8 }
local LIGHT_FALLOFF = .9

local function on_hammered(inst, hammerer)
    inst.components.lootdropper:DropLoot()

    local collapse_fx = SpawnPrefab("collapse_small")
    collapse_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    collapse_fx:SetMaterial("wood")

    if inst.components.mast and hammerer ~= inst.components.mast.boat then
        inst.components.mast:SetBoat(nil)
    end

    inst:Remove()
end

local function on_hit(inst, hitter)
    if inst.components.mast and not inst.components.mast.is_sail_transitioning then
        if inst.components.mast.is_sail_raised ~= inst.components.mast.inverted then
            inst.AnimState:PlayAnimation("open2_hit")
            inst.AnimState:PushAnimation("open_loop",true)
        else
            inst.AnimState:PlayAnimation("closed_hit")
            inst.AnimState:PushAnimation("closed",false)
        end
    end
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("turnoftides/common/together/boat/mast/place")
end

local function lamp_fuelupdate(inst)
    if inst._lamp ~= nil and inst._lamp:IsValid() then
        local fuelpercent = inst.components.fueled:GetPercent()
        inst.Light:SetIntensity(Lerp(LIGHT_INTENSITY.MIN, LIGHT_INTENSITY.MAX, fuelpercent))
        inst.Light:SetRadius(Lerp(LIGHT_RADIUS.MIN, LIGHT_RADIUS.MAX, fuelpercent))
        inst.Light:SetFalloff(LIGHT_FALLOFF)
    end
end

local function lamp_turnoff(inst)
    inst.Light:Enable(false)

    if inst._lamp ~= nil and inst._lamp:IsValid() then
        inst._lamp:PushEvent("mast_lamp_off")
    end
end

local function lamp_turnon(inst)
    if not inst.components.fueled:IsEmpty() then
        inst.components.fueled:StartConsuming()

        if inst._lamp == nil then
            inst._lamp = SpawnPrefab("mastupgrade_lamp")
            inst._lamp._mast = inst
            lamp_fuelupdate(inst)

            inst.highlightchildren = { inst._lamp }

            inst._lamp.entity:SetParent(inst.entity)
            inst._lamp.entity:AddFollower():FollowSymbol(inst.GUID, "mastupgrade_lamp", 0, 0, 0)
        end

        inst.Light:Enable(true)

        lamp_fuelupdate(inst)
    
        inst._lamp:PushEvent("mast_lamp_on")        
    end
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
end

local function upgrade_lamp(inst, no_built_callback)
    inst:AddComponent("fueled")
    inst.components.fueled:InitializeFuelLevel(TUNING.MAST_LAMP_LIGHTTIME)
    inst.components.fueled:SetDepletedFn(lamp_turnoff)
    inst.components.fueled:SetUpdateFn(lamp_fuelupdate)
    inst.components.fueled:SetTakeFuelFn(lamp_turnon)
    inst.components.fueled:SetFirstPeriod(TUNING.TURNON_FUELED_CONSUMPTION, TUNING.TURNON_FULL_FUELED_CONSUMPTION)
    inst.components.fueled.accepting = true
    inst.components.fueled.canbespecialextinguished = true

    lamp_turnon(inst)

    inst.components.upgradeable.upgradetype = nil

    if not no_built_callback then
        inst._lamp:PushEvent("onbuilt")
    end
end

local function upgrade_lightningrod(inst, no_built_callback)
    inst._lightningrod = SpawnPrefab("mastupgrade_lightningrod")
    inst._lightningrod.entity:SetParent(inst.entity)

    local top = SpawnPrefab("mastupgrade_lightningrod_top")
    top.entity:SetParent(inst.entity)
    top.entity:AddFollower():FollowSymbol(inst.GUID, "mastupgrade_lightningrod_top", 0, 0, 0)

    inst._lightningrod._mast = inst
    inst._lightningrod._top = top

    inst.highlightchildren = { inst._lightningrod, inst._lightningrod._top }

    inst.components.upgradeable.upgradetype = nil

    if not no_built_callback then
        inst._lightningrod:PushEvent("onbuilt")
    end
end

local function OnUpgrade(inst)
    local numupgrades = inst.components.upgradeable.numupgrades
    if numupgrades == 1 then
        upgrade_lamp(inst)
    elseif numupgrades == 2 then
        upgrade_lightningrod(inst)
    end
end

local function onburnt(inst)
	inst:AddTag("burnt")

	local mast = inst.components.mast
	if mast.boat ~= nil then
		mast.boat.components.boatphysics:RemoveMast(mast)
    end
    if mast.rudder ~= nil then
        mast.rudder:Remove()
    end

    inst:RemoveComponent("mast")
    
    lamp_turnoff(inst)

    inst.components.upgradeable.upgradetype = nil
    if inst.components.fueled ~= nil then
        inst:RemoveComponent("fueled")
    end

    if inst._lamp ~= nil and inst._lamp:IsValid() then
        inst._lamp:PushEvent("mast_burnt")
        inst._lamp:Remove()
        inst._lamp = nil
    end

    if inst._lightningrod ~= nil and inst._lightningrod:IsValid() then
        inst._lightningrod:PushEvent("mast_burnt")
        inst._lightningrod:Remove()
        inst._lightningrod = nil
    end




end

local function ondeconstructstructure(inst, caster)
    if inst._lamp ~= nil and inst._lamp:IsValid() then
        inst._lamp:PushEvent("ondeconstructstructure", caster)
    end

    if inst._lightningrod ~= nil and inst._lightningrod:IsValid() then
        inst._lightningrod:PushEvent("ondeconstructstructure", caster)
    end
end

local function lootsetup(lootdropper)
    local inst = lootdropper.inst
    local recipe = inst._lamp ~= nil and AllRecipes["mastupgrade_lamp_item"] or inst._lightningrod ~= nil and AllRecipes["mastupgrade_lightningrod_item"] or nil

    if recipe ~= nil then
        local loots = {}

        local recipeloot = lootdropper:GetRecipeLoot(recipe)
        for k,v in ipairs(recipeloot) do
            table.insert(loots, v)
        end
        
        if #loots > 0 then
            lootdropper:SetLoot(loots)
        end
    end
end

local function onsave(inst, data)
	if inst.components.burnable ~= nil and inst.components.burnable:IsBurning() or inst:HasTag("burnt") then
		data.burnt = true
	end

	if inst.components.mast == nil or inst.components.mast.boat == nil then
		data.rotation = inst.Transform:GetRotation()
		data.is_sail_raised = inst.components.mast and inst.components.mast.is_sail_raised or nil
    end
    
    if inst._lamp ~= nil then
        data.lamp_fuel = inst.components.fueled.currentfuel
    elseif inst._lightningrod ~= nil then
        data.lightningrod = true
        data.lightningrod_chargeleft = inst._lightningrod.chargeleft
    end
end

local function onload(inst, data)
	if data ~= nil then
		if data.burnt then
			inst.components.burnable.onburnt(inst)
			inst:PushEvent("onburnt")
		end
		if data.rotation then
			inst.Transform:SetRotation(data.rotation)
		end
		if data.is_sail_raised and inst.components.mast ~= nil then
			inst.components.mast:SailUnfurled()
        end

        if data.lamp_fuel ~= nil then
            upgrade_lamp(inst)
            inst.components.fueled:InitializeFuelLevel(math.max(0, data.lamp_fuel))
            if data.lamp_fuel == 0 then
                lamp_turnoff(inst)
            else
                lamp_turnon(inst)
            end
        elseif data.lightningrod ~= nil then
            upgrade_lightningrod(inst, true)
            if data.lightningrod_chargeleft ~= nil and data.lightningrod_chargeleft > 0 then
                inst._lightningrod:_setchargedfn(data.lightningrod_chargeleft)
            end
        end
	end
end

local function fn_pre(inst)
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    MakeObstaclePhysics(inst, .2)

    inst.Light:Enable(false)
    --inst.Light:SetIntensity(LIGHT_INTENSITY.MAX)
    inst.Light:SetColour(LIGHT_COLOUR.x, LIGHT_COLOUR.y, LIGHT_COLOUR.z)
    inst.Light:SetFalloff(LIGHT_FALLOFF)
    --inst.Light:SetRadius(LIGHT_RADIUS.MAX)

    inst.Transform:SetEightFaced()

    inst:AddTag("NOBLOCK")
    inst:AddTag("structure")
    inst:AddTag("mast")
end

local function fn_pst(inst)
    MakeLargeBurnable(inst, nil, nil, true)
    inst.components.burnable.ignorefuel = true
    inst:ListenForEvent("onburnt", onburnt)
    MakeLargePropagator(inst)

    inst:AddComponent("hauntable")
    inst:AddComponent("inspectable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst:AddComponent("mast")

    -- The mast loot that this drops is generated from the uncraftable recipe; see recipes.lua for the items.
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLootSetupFn(lootsetup)
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
    inst.components.workable:SetOnFinishCallback(on_hammered)
    inst.components.workable:SetOnWorkCallback(on_hit)

    inst:AddComponent("upgradeable")
    inst.components.upgradeable.upgradetype = UPGRADETYPES.MAST
    inst.components.upgradeable.onupgradefn = OnUpgrade
    
    inst:ListenForEvent("onbuilt", onbuilt)
    inst:ListenForEvent("ondeconstructstructure", ondeconstructstructure)

    inst.OnSave = onsave
    inst.OnLoad = onload
end

local function fn01()
    local inst = CreateEntity()

    fn_pre(inst)

    inst.AnimState:SetBank("mast_01")
    inst.AnimState:SetBuild("kyno_mast_01")
    inst.AnimState:PlayAnimation("closed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    fn_pst(inst)
	
	inst.components.lootdropper:SetChanceLootTable("sap_masts")
	
	inst.components.mast.sail_force = TUNING.BOAT.MAST.MALBATROSS.SAIL_FORCE
    inst.components.mast.rudder_turn_drag = TUNING.BOAT.MAST.MALBATROSS.RUDDER_TURN_DRAG
    inst.components.mast.max_velocity = TUNING.BOAT.MAST.MALBATROSS.MAX_VELOCITY
	inst.components.mast:SetReveseDeploy(false)

	if inst.components.mast ~= nil then
		inst.components.mast.sink_fx = "boat_mast_sink_fx"
	end

    return inst
end

local function fn02()
    local inst = CreateEntity()

    fn_pre(inst)

    inst.AnimState:SetBank("mast_01")
    inst.AnimState:SetBuild("kyno_mast_02")
    inst.AnimState:PlayAnimation("closed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    fn_pst(inst)
	
	inst.components.lootdropper:SetChanceLootTable("sap_masts")
	
	inst.components.mast.sail_force = TUNING.BOAT.MAST.MALBATROSS.SAIL_FORCE
    inst.components.mast.rudder_turn_drag = TUNING.BOAT.MAST.MALBATROSS.RUDDER_TURN_DRAG
    inst.components.mast.max_velocity = TUNING.BOAT.MAST.MALBATROSS.MAX_VELOCITY
	inst.components.mast:SetReveseDeploy(false)

	if inst.components.mast ~= nil then
		inst.components.mast.sink_fx = "boat_mast_sink_fx"
	end

    return inst
end

local function fn03()
    local inst = CreateEntity()

    fn_pre(inst)

    inst.AnimState:SetBank("mast_01")
    inst.AnimState:SetBuild("kyno_mast_03")
    inst.AnimState:PlayAnimation("closed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    fn_pst(inst)
	
	inst.components.lootdropper:SetChanceLootTable("sap_masts")
	
	inst.components.mast.sail_force = TUNING.BOAT.MAST.MALBATROSS.SAIL_FORCE
    inst.components.mast.rudder_turn_drag = TUNING.BOAT.MAST.MALBATROSS.RUDDER_TURN_DRAG
    inst.components.mast.max_velocity = TUNING.BOAT.MAST.MALBATROSS.MAX_VELOCITY
	inst.components.mast:SetReveseDeploy(false)

	if inst.components.mast ~= nil then
		inst.components.mast.sink_fx = "boat_mast_sink_fx"
	end

    return inst
end

local function fn04()
    local inst = CreateEntity()

    fn_pre(inst)

    inst.AnimState:SetBank("mast_01")
    inst.AnimState:SetBuild("kyno_mast_04")
    inst.AnimState:PlayAnimation("closed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    fn_pst(inst)
	
	inst.components.lootdropper:SetChanceLootTable("sap_masts")
	
	inst.components.mast.sail_force = TUNING.BOAT.MAST.MALBATROSS.SAIL_FORCE
    inst.components.mast.rudder_turn_drag = TUNING.BOAT.MAST.MALBATROSS.RUDDER_TURN_DRAG
    inst.components.mast.max_velocity = TUNING.BOAT.MAST.MALBATROSS.MAX_VELOCITY
	inst.components.mast:SetReveseDeploy(false)

	if inst.components.mast ~= nil then
		inst.components.mast.sink_fx = "boat_mast_sink_fx"
	end

    return inst
end

local function fn05()
    local inst = CreateEntity()

    fn_pre(inst)

    inst.AnimState:SetBank("mast_01")
    inst.AnimState:SetBuild("kyno_mast_05")
    inst.AnimState:PlayAnimation("closed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    fn_pst(inst)
	
	inst.components.lootdropper:SetChanceLootTable("sap_masts")
	
	inst.components.mast.sail_force = TUNING.BOAT.MAST.MALBATROSS.SAIL_FORCE
    inst.components.mast.rudder_turn_drag = TUNING.BOAT.MAST.MALBATROSS.RUDDER_TURN_DRAG
    inst.components.mast.max_velocity = TUNING.BOAT.MAST.MALBATROSS.MAX_VELOCITY
	inst.components.mast:SetReveseDeploy(false)

	if inst.components.mast ~= nil then
		inst.components.mast.sink_fx = "boat_mast_sink_fx"
	end

    return inst
end

local function fn06()
    local inst = CreateEntity()

    fn_pre(inst)

    inst.AnimState:SetBank("mast_01")
    inst.AnimState:SetBuild("kyno_mast_06")
    inst.AnimState:PlayAnimation("closed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    fn_pst(inst)
	
	inst.components.lootdropper:SetChanceLootTable("sap_masts")
	
	inst.components.mast.sail_force = TUNING.BOAT.MAST.MALBATROSS.SAIL_FORCE
    inst.components.mast.rudder_turn_drag = TUNING.BOAT.MAST.MALBATROSS.RUDDER_TURN_DRAG
    inst.components.mast.max_velocity = TUNING.BOAT.MAST.MALBATROSS.MAX_VELOCITY
	inst.components.mast:SetReveseDeploy(false)

	if inst.components.mast ~= nil then
		inst.components.mast.sink_fx = "boat_mast_sink_fx"
	end

    return inst
end

local function fn07()
    local inst = CreateEntity()

    fn_pre(inst)

    inst.AnimState:SetBank("mast_01")
    inst.AnimState:SetBuild("kyno_mast_07")
    inst.AnimState:PlayAnimation("closed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    fn_pst(inst)
	
	inst.components.lootdropper:SetChanceLootTable("sap_masts")
	
	inst.components.mast.sail_force = TUNING.BOAT.MAST.MALBATROSS.SAIL_FORCE
    inst.components.mast.rudder_turn_drag = TUNING.BOAT.MAST.MALBATROSS.RUDDER_TURN_DRAG
    inst.components.mast.max_velocity = TUNING.BOAT.MAST.MALBATROSS.MAX_VELOCITY
	inst.components.mast:SetReveseDeploy(false)

	if inst.components.mast ~= nil then
		inst.components.mast.sink_fx = "boat_mast_sink_fx"
	end

    return inst
end

local function fn08()
    local inst = CreateEntity()

    fn_pre(inst)

    inst.AnimState:SetBank("mast_01")
    inst.AnimState:SetBuild("kyno_mast_08")
    inst.AnimState:PlayAnimation("closed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    fn_pst(inst)
	
	inst.components.lootdropper:SetChanceLootTable("sap_masts")
	
	inst.components.mast.sail_force = TUNING.BOAT.MAST.MALBATROSS.SAIL_FORCE
    inst.components.mast.rudder_turn_drag = TUNING.BOAT.MAST.MALBATROSS.RUDDER_TURN_DRAG
    inst.components.mast.max_velocity = TUNING.BOAT.MAST.MALBATROSS.MAX_VELOCITY
	inst.components.mast:SetReveseDeploy(false)

	if inst.components.mast ~= nil then
		inst.components.mast.sink_fx = "boat_mast_sink_fx"
	end

    return inst
end

local function fn09()
    local inst = CreateEntity()

    fn_pre(inst)

    inst.AnimState:SetBank("mast_01")
    inst.AnimState:SetBuild("kyno_mast_09")
    inst.AnimState:PlayAnimation("closed")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    fn_pst(inst)
	
	inst.components.lootdropper:SetChanceLootTable("sap_masts")
	
	inst.components.mast.sail_force = TUNING.BOAT.MAST.MALBATROSS.SAIL_FORCE
    inst.components.mast.rudder_turn_drag = TUNING.BOAT.MAST.MALBATROSS.RUDDER_TURN_DRAG
    inst.components.mast.max_velocity = TUNING.BOAT.MAST.MALBATROSS.MAX_VELOCITY
	inst.components.mast:SetReveseDeploy(false)

	if inst.components.mast ~= nil then
		inst.components.mast.sink_fx = "boat_mast_sink_fx"
	end

    return inst
end

local function setondeploy(inst, prefab)
    local function ondeploy(inst, pt, deployer, rot)
        local mast = SpawnPrefab(prefab)
        if mast ~= nil then
            mast.Physics:SetCollides(false)
            mast.Physics:Teleport(pt.x, 0, pt.z)
            mast.Physics:SetCollides(true)
            mast.SoundEmitter:PlaySound("turnoftides/common/together/boat/mast/place")
            mast.AnimState:PlayAnimation("place")
            mast.AnimState:PushAnimation("closed", false)
            if rot then
                mast.Transform:SetRotation(rot)
                mast.save_rotation = true
            end
            inst:Remove()
        end
    end

    inst.components.deployable.ondeploy = ondeploy  
end


local function item_fn_pre(inst)
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:AddTag("boat_accessory")
    inst:AddTag("deploykititem")

    MakeInventoryPhysics(inst)

    MakeInventoryFloatable(inst, "med", 0.25, 0.83)
end

local function item_fn_pst01(inst)
    inst:AddComponent("deployable")
    setondeploy(inst, "sap_mast_01")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.MAST)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)   

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")    

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

    MakeHauntableLaunch(inst)
end

local function item_fn_pst02(inst)
    inst:AddComponent("deployable")
    setondeploy(inst, "sap_mast_02")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.MAST)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)   

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")    

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

    MakeHauntableLaunch(inst)
end

local function item_fn_pst03(inst)
    inst:AddComponent("deployable")
    setondeploy(inst, "sap_mast_03")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.MAST)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)   

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")    

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

    MakeHauntableLaunch(inst)
end

local function item_fn_pst04(inst)
    inst:AddComponent("deployable")
    setondeploy(inst, "sap_mast_04")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.MAST)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)   

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")    

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

    MakeHauntableLaunch(inst)
end

local function item_fn_pst05(inst)
    inst:AddComponent("deployable")
    setondeploy(inst, "sap_mast_05")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.MAST)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)   

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")    

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

    MakeHauntableLaunch(inst)
end

local function item_fn_pst06(inst)
    inst:AddComponent("deployable")
    setondeploy(inst, "sap_mast_06")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.MAST)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)   

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")    

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

    MakeHauntableLaunch(inst)
end

local function item_fn_pst07(inst)
    inst:AddComponent("deployable")
    setondeploy(inst, "sap_mast_07")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.MAST)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)   

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")    

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

    MakeHauntableLaunch(inst)
end

local function item_fn_pst08(inst)
    inst:AddComponent("deployable")
    setondeploy(inst, "sap_mast_08")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.MAST)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)   

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")    

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

    MakeHauntableLaunch(inst)
end

local function item_fn_pst09(inst)
    inst:AddComponent("deployable")
    setondeploy(inst, "sap_mast_09")
    inst.components.deployable:SetDeployMode(DEPLOYMODE.MAST)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.LESS)   

    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")    

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"

    MakeHauntableLaunch(inst)
end

local function item_fn01()
    local inst = CreateEntity()

    item_fn_pre(inst)

    inst.AnimState:SetBank("kyno_seafarer_mast_01")
    inst.AnimState:SetBuild("kyno_seafarer_mast_01")
    inst.AnimState:PlayAnimation("IDLE")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    item_fn_pst01(inst)

    return inst
end

local function item_fn02()
    local inst = CreateEntity()

    item_fn_pre(inst)

    inst.AnimState:SetBank("kyno_seafarer_mast_02")
    inst.AnimState:SetBuild("kyno_seafarer_mast_02")
    inst.AnimState:PlayAnimation("IDLE")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    item_fn_pst02(inst)

    return inst
end

local function item_fn03()
    local inst = CreateEntity()

    item_fn_pre(inst)

    inst.AnimState:SetBank("kyno_seafarer_mast_03")
    inst.AnimState:SetBuild("kyno_seafarer_mast_03")
    inst.AnimState:PlayAnimation("IDLE")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    item_fn_pst03(inst)

    return inst
end

local function item_fn04()
    local inst = CreateEntity()

    item_fn_pre(inst)

    inst.AnimState:SetBank("kyno_seafarer_mast_04")
    inst.AnimState:SetBuild("kyno_seafarer_mast_04")
    inst.AnimState:PlayAnimation("IDLE")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    item_fn_pst04(inst)

    return inst
end

local function item_fn05()
    local inst = CreateEntity()

    item_fn_pre(inst)

    inst.AnimState:SetBank("kyno_seafarer_mast_05")
    inst.AnimState:SetBuild("kyno_seafarer_mast_05")
    inst.AnimState:PlayAnimation("IDLE")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    item_fn_pst05(inst)

    return inst
end

local function item_fn06()
    local inst = CreateEntity()

    item_fn_pre(inst)

    inst.AnimState:SetBank("kyno_seafarer_mast_06")
    inst.AnimState:SetBuild("kyno_seafarer_mast_06")
    inst.AnimState:PlayAnimation("IDLE")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    item_fn_pst06(inst)

    return inst
end

local function item_fn07()
    local inst = CreateEntity()

    item_fn_pre(inst)

    inst.AnimState:SetBank("kyno_seafarer_mast_07")
    inst.AnimState:SetBuild("kyno_seafarer_mast_07")
    inst.AnimState:PlayAnimation("IDLE")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    item_fn_pst07(inst)

    return inst
end

local function item_fn08()
    local inst = CreateEntity()

    item_fn_pre(inst)

    inst.AnimState:SetBank("kyno_seafarer_mast_08")
    inst.AnimState:SetBuild("kyno_seafarer_mast_08")
    inst.AnimState:PlayAnimation("IDLE")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    item_fn_pst08(inst)

    return inst
end

local function item_fn09()
    local inst = CreateEntity()

    item_fn_pre(inst)

    inst.AnimState:SetBank("kyno_seafarer_mast_09")
    inst.AnimState:SetBuild("kyno_seafarer_mast_09")
    inst.AnimState:PlayAnimation("IDLE")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    item_fn_pst09(inst)

    return inst
end

return Prefab("sap_mast_01", fn01, assets, prefabs),
Prefab("sap_mast_item_01", item_fn01, assets),
MakePlacer("sap_mast_item_01_placer", "mast_01", "kyno_mast_01", "closed", nil,nil,nil,nil,0,"eight"),

Prefab("sap_mast_02", fn02, assets, prefabs),
Prefab("sap_mast_item_02", item_fn02, assets),
MakePlacer("sap_mast_item_02_placer", "mast_01", "kyno_mast_02", "closed", nil,nil,nil,nil,0,"eight"),

Prefab("sap_mast_03", fn03, assets, prefabs),
Prefab("sap_mast_item_03", item_fn03, assets),
MakePlacer("sap_mast_item_03_placer", "mast_01", "kyno_mast_03", "closed", nil,nil,nil,nil,0,"eight"),

Prefab("sap_mast_04", fn04, assets, prefabs),
Prefab("sap_mast_item_04", item_fn04, assets),
MakePlacer("sap_mast_item_04_placer", "mast_01", "kyno_mast_04", "closed", nil,nil,nil,nil,0,"eight"),

Prefab("sap_mast_05", fn05, assets, prefabs),
Prefab("sap_mast_item_05", item_fn05, assets),
MakePlacer("sap_mast_item_05_placer", "mast_01", "kyno_mast_05", "closed", nil,nil,nil,nil,0,"eight"),

Prefab("sap_mast_06", fn06, assets, prefabs),
Prefab("sap_mast_item_06", item_fn06, assets),
MakePlacer("sap_mast_item_06_placer", "mast_01", "kyno_mast_06", "closed", nil,nil,nil,nil,0,"eight"),

Prefab("sap_mast_07", fn07, assets, prefabs),
Prefab("sap_mast_item_07", item_fn07, assets),
MakePlacer("sap_mast_item_07_placer", "mast_01", "kyno_mast_07", "closed", nil,nil,nil,nil,0,"eight"),

Prefab("sap_mast_08", fn08, assets, prefabs),
Prefab("sap_mast_item_08", item_fn08, assets),
MakePlacer("sap_mast_item_08_placer", "mast_01", "kyno_mast_08", "closed", nil,nil,nil,nil,0,"eight"),

Prefab("sap_mast_09", fn09, assets, prefabs),
Prefab("sap_mast_item_09", item_fn09, assets),
MakePlacer("sap_mast_item_09_placer", "mast_01", "kyno_mast_09", "closed", nil,nil,nil,nil,0,"eight")