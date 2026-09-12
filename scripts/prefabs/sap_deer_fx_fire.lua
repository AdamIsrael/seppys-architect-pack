local assets =
{
    Asset("ANIM", "anim/deer_fire_circle.zip"),
	Asset("ANIM", "anim/deer_fire_flakes.zip"),
	Asset("ANIM", "anim/deer_fire_burst.zip"),
}

local prefabs =
{
	"deer_fire_burst",
	"deer_fire_circle",
	"deer_fire_flakes"
}

local function dig_up(inst, chopper)
	inst:Remove()
	inst.components.lootdropper:DropLoot()
end

local fire_front = 1

local fire_defs = {
	fire = { { 0, 0, 0 } },
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
    inst.Light:SetColour(220/255, 100/255, 0/255)

    inst.AnimState:SetBank("deer_fire_circle")
    inst.AnimState:SetBuild("deer_fire_circle")
    inst.AnimState:PlayAnimation("loop", true)
	inst.AnimState:Hide("glow")
	inst.AnimState:Hide("track")
	inst.AnimState:Hide("track_ring")
	inst.AnimState:Hide("track20")
	inst.AnimState:Hide("track40")
	inst.AnimState:Hide("track60")
	inst.AnimState:Hide("track80")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:AddTag("structure")
    inst:AddTag("antlion_sinkhole_blocker")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local decor_items = fire_defs
		inst.decor = {}
		for item_name, data in pairs(decor_items) do
			for l, offset in pairs(data) do
				local item_inst = SpawnPrefab("deer_fire_flakes")
				local item_inst2 = SpawnPrefab("deer_fire_burst")
				local item_inst3 = SpawnPrefab("deer_fire_circle")
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

	inst:AddComponent("heater")
    inst.components.heater.heat = 500
	
	inst:AddComponent("propagator")
    inst.components.propagator.damages = true
    inst.components.propagator.propagaterange = .25
    inst.components.propagator.damagerange = .25
    inst.components.propagator:StartSpreading()
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("savedrotation")
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)
	
	MakeSmallPropagator(inst)

    return inst
end

return Prefab("sap_magmafield", fn, assets, prefabs),
MakePlacer("sap_magmafield_placer", "deer_fire_circle", "deer_fire_circle", "loop", true)
