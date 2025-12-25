require "prefabutil"
local CANOPY_SHADOW_DATA = require("prefabs/canopyshadows")

local assets =
{
	Asset("ANIM", "anim/pillar_tree.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs = {
	"kyno_canopy_shadow",
}

local function chop_tree(inst, chopper, chops)
	if chopper and chopper.components.beaverness and chopper.components.beaverness:IsBeaver() then
		inst.SoundEmitter:PlaySound("dontstarve/characters/woodie/beaver_chop_tree")
	else
		inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_tree")
	end
	inst.AnimState:PlayAnimation("idle", true)
end

local MIN = TUNING.SHADE_CANOPY_RANGE_SMALL
local MAX = MIN + TUNING.WATERTREE_PILLAR_CANOPY_BUFFER

local function OnFar(inst, player)
    if player.canopytrees then   
        player.canopytrees = player.canopytrees - 1
        player:PushEvent("onchangecanopyzone", player.canopytrees > 0)
    end
    inst.players[player] = nil
end

local function OnNear(inst,player)
    inst.players[player] = true

    player.canopytrees = (player.canopytrees or 0) + 1

    player:PushEvent("onchangecanopyzone", player.canopytrees > 0)
end

local function removecanopyshadow(inst)
    if inst.canopy_data ~= nil then
        for _, shadetile_key in ipairs(inst.canopy_data.shadetile_keys) do
            if TheWorld.shadetiles[shadetile_key] ~= nil then
                TheWorld.shadetiles[shadetile_key] = TheWorld.shadetiles[shadetile_key] - 1

                if TheWorld.shadetiles[shadetile_key] <= 0 then
                    if TheWorld.shadetile_key_to_leaf_canopy_id[shadetile_key] ~= nil then
                        DespawnLeafCanopy(TheWorld.shadetile_key_to_leaf_canopy_id[shadetile_key])
                        TheWorld.shadetile_key_to_leaf_canopy_id[shadetile_key] = nil
                    end
                end
            end
        end

        for _, ray in ipairs(inst.canopy_data.lightrays) do
            ray:Remove()
        end
    end
end

local TAGS = {"oceanvine", "leafystalk"}
local function removecanopy(inst)
    if inst.roots then
        inst.roots:Remove()
    end
    if inst._ripples then
        inst._ripples:Remove()
    end

    for player in pairs(inst.players) do
        if player:IsValid() then
            if player.canopytrees then
                OnFar(inst, player)
            end
        end
    end
    local point = inst:GetPosition()
    local oceanvines = TheSim:FindEntities(point.x, point.y, point.z, MAX+1, TAGS)
    if #oceanvines > 0 then
        for i, ent in ipairs(oceanvines) do
            ent.fall(ent)
        end
    end

    inst._hascanopy:set(false)    
end

local function chop_down_tree(inst, chopper)
	removecanopyshadow(inst)
    inst:RemoveComponent("canopyshadows")

	inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
	local pt = Vector3(inst.Transform:GetWorldPosition())
	local hispos = Vector3(chopper.Transform:GetWorldPosition())

	local he_right = (hispos - pt):Dot(TheCamera:GetRightVec()) > 0
	if he_right then
		inst.components.lootdropper:DropLoot(pt - TheCamera:GetRightVec())
	else
		inst.components.lootdropper:DropLoot(pt + TheCamera:GetRightVec())
	end
	
	RemovePhysicsColliders(inst)
	
	removecanopy(inst)
	inst._hascanopy:set(false)
	
	inst:Remove()
end

local function OnRemove(inst)
    removecanopy(inst)
	removecanopyshadow(inst)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 3, 24)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_leafystalk.tex")
	
	inst.AnimState:SetBank("pillar_tree")
	inst.AnimState:SetBuild("pillar_tree")
	inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("structure")
	inst:AddTag("tree_pillar")
	inst:AddTag("shadecanopysmall")
    inst:AddTag("event_trigger")
	inst:AddTag("leafystalk")
	
	if not TheNet:IsDedicated() then
        inst:AddComponent("distancefade")
        inst.components.distancefade:Setup(15,25)

        inst:AddComponent("canopyshadows")
        inst.components.canopyshadows.range = math.floor(TUNING.SHADE_CANOPY_RANGE_SMALL/4)

        inst:ListenForEvent("hascanopydirty", function()
            if not inst._hascanopy:value() then
                inst:RemoveComponent("canopyshadows")
            end
        end)
    end

    inst._hascanopy = net_bool(inst.GUID, "oceantree_pillar._hascanopy", "hascanopydirty")
    inst._hascanopy:set(true)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.players = {}
	
	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.CHOP)
	inst.components.workable:SetOnWorkCallback(chop_tree)
	inst.components.workable:SetOnFinishCallback(chop_down_tree)
	inst.components.workable:SetWorkLeft(15)
	
	inst:AddComponent("lightningblocker")
    inst.components.lightningblocker:SetBlockRange(TUNING.SHADE_CANOPY_RANGE_SMALL)
	
	inst:ListenForEvent("onremove", OnRemove)

	return inst
end

return Prefab("kyno_leafystalk", fn, assets, prefabs),
MakePlacer("kyno_leafystalk_placer", "pillar_tree", "pillar_tree", "idle")