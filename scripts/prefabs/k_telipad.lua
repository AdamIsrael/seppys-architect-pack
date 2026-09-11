require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/teleport_pad.zip"),
	Asset("ANIM", "anim/teleport_pad_beacon.zip"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_wagstaff.fev"),
	Asset("SOUND", "sound/dontstarve_wagstaff.fsb"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs = {
	"sap_telipad_beacon",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("idle", true)
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle", true)
	inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/telepad_1")
end

local function onremove(inst)
	if TheWorld.telipads then
		for i,pad in ipairs(TheWorld.telipads) do
			if pad == inst then
				table.remove(TheWorld.telipads,i)
				break
			end
		end
	end
end

local function turnoff(inst)
	if inst.decor then
		for i,deco in ipairs(inst.decor) do
			if not deco.AnimState:IsCurrentAnimation("place") then
				deco.AnimState:PlayAnimation("off")
			end
		end	
	end
end

local function turnon(inst)
	if inst.decor then
		for i,deco in ipairs(inst.decor) do
			if not deco.AnimState:IsCurrentAnimation("place") then
				deco.AnimState:PlayAnimation("on")
			end
		end	
	end	
end

local rock_front = 1

local decor_defs = {
	beacon = { { -1.28, 0, 1.14 } },
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_telipad.tex")
	
	inst.Transform:SetRotation(0)

    inst.AnimState:SetBank("teleport_pad")
    inst.AnimState:SetBuild("teleport_pad")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("telipad")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.turnoff = turnoff
	inst.turnon = turnon
	
	local sound_name = "dontstarve_wagstaff/characters/wagstaff/telepad_1"

	inst:ListenForEvent("onbuilt", function () onbuilt(inst, sound_name) end)
	-- inst:ListenForEvent("onremove", function () onremove(inst) end)
	
	local decor_items = decor_defs
		inst.decor = {}
		for item_name, data in pairs(decor_items) do
			for l, offset in pairs(data) do
				local item_inst = SpawnPrefab("sap_telipad_beacon")
				item_inst.AnimState:PlayAnimation("place")
				item_inst.AnimState:PushAnimation("off")
				item_inst.SoundEmitter:PlaySound("dontstarve_wagstaff/characters/wagstaff/telepad_2")
				item_inst.entity:SetParent(inst.entity)
				item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
				table.insert(inst.decor, item_inst)
			end
		end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	--[[
	if not TheWorld.telipads then
			TheWorld.telipads = {}
		end
	table.insert(TheWorld.telipads,inst)
	]]--
	
    return inst
end

local function beaconfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("teleport_pad_beacon")
    inst.AnimState:SetBuild("teleport_pad_beacon")
    inst.AnimState:PlayAnimation("on")
	
	inst.persists = false
	
	inst:AddTag("telipad_beacon")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.placesound = "dontstarve_wagstaff/characters/wagstaff/telepad_2"
	
	return inst
end

return Prefab("sap_telipad", fn, assets, prefabs),
Prefab("sap_telipad_beacon", beaconfn, assets, prefabs),
MakePlacer("sap_telipad_placer", "teleport_pad", "teleport_pad", "idle", true)