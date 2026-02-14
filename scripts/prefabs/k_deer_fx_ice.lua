local assets =
{
    Asset("ANIM", "anim/deer_ice_circle.zip"),
	Asset("ANIM", "anim/deer_ice_flakes.zip"),
	Asset("ANIM", "anim/deer_ice_fx.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local prefabs =
{
	"deer_ice_circle",
	"deer_ice_flakes",
	"deer_ice_fx"
}

local function dig_up(inst, chopper)
	inst:Remove()
	inst.components.lootdropper:DropLoot()
end

local ice_front = 1

local ice_defs = {
	ice = { { 0, 0, 0 } },
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(.9)
    inst.Light:SetIntensity(.8)
    inst.Light:SetRadius(3)
    inst.Light:Enable(true)
    inst.Light:SetColour(60/255, 120/255, 255/255)

    inst.AnimState:SetBank("deer_ice_circle")
    inst.AnimState:SetBuild("deer_ice_circle")
    inst.AnimState:PlayAnimation("loop", true)
	inst.AnimState:Hide("track")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:AddTag("structure")
    inst:AddTag("antlion_sinkhole_blocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local decor_items = ice_defs
		inst.decor = {}
		for item_name, data in pairs(decor_items) do
			for l, offset in pairs(data) do
				local item_inst = SpawnPrefab("deer_ice_flakes")
				local item_inst2 = SpawnPrefab("deer_ice_fx")
				local item_inst3 = SpawnPrefab("deer_ice_circle")
				item_inst.entity:SetParent(inst.entity)
				item_inst2.entity:SetParent(inst.entity)
				item_inst3.entity:SetParent(inst.entity)
				item_inst.Transform:SetPosition(offset[1], offset[2], offset[3])
				item_inst2.Transform:SetPosition(offset[1], offset[2], offset[3])
				item_inst3.Transform:SetPosition(offset[1], offset[2], offset[3])
				table.insert(inst.decor, item_inst)
				table.insert(inst.decor, item_inst2)
				table.insert(inst.decor, item_inst3)
			end
		end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

    return inst
end

return Prefab("kyno_icegeyser", fn, assets, prefabs),
MakePlacer("kyno_icegeyser_placer", "deer_ice_circle", "deer_ice_circle", "loop", true)