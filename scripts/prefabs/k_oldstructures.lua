require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/quagmire_victorian_structures.zip"),
	Asset("ANIM", "anim/quagmire_rubble.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs = {
	"kyno_old_rubble",
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:PushAnimation("idle")
end

local function decorfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    inst:AddTag("DECOR")
    inst:AddTag("NOCLICK")
	
    inst.persists = false

    inst.AnimState:SetBank("quagmire_rubble")
    inst.AnimState:SetBuild("quagmire_rubble")

    return inst
end

local decore_seed = 123456789;
local function decore_rand()
	decore_seed = (1664525 * decore_seed + 1013904223) % 2147483648
	return decore_seed / 2147483649;
end

local function SpawnDecor(inst, x, z)
	if decore_rand() < 0.8 then
		local rubble = SpawnPrefab("kyno_old_rubble")
		rubble.entity:SetParent(inst.entity)

		local r = 0.15
		rubble.Transform:SetPosition(x + decore_rand()*r - r*.5, 0, z + decore_rand()*r - r*.5)

		local scale = .8 - (decore_rand() * .2)
		rubble.Transform:SetScale(scale, scale, scale)
		local tint = .8 - (decore_rand() * .1)
		rubble.AnimState:OverrideMultColour(tint, tint, tint, 1)
		rubble.AnimState:PlayAnimation("f"..math.floor(decore_rand() * 8) + 1)
	end
end

local function PopulateDecor(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	decore_seed = math.floor(math.abs(x) * 281 + math.abs(z) * 353)
	local half_cells = 3
	local cell_spacing = .72
	for x = -half_cells+1, half_cells-1 do
		SpawnDecor(inst, x*cell_spacing, -half_cells*cell_spacing)
		SpawnDecor(inst, x*cell_spacing, half_cells*cell_spacing)
	end
	for z = -half_cells, half_cells do
		SpawnDecor(inst, -half_cells*cell_spacing, z*cell_spacing)
		SpawnDecor(inst, half_cells*cell_spacing, z*cell_spacing)
	end
end

local function common_fn(anim, add_decor, minimap)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddSoundEmitter()
	if anim ~= nil then
		inst.entity:AddAnimState()
	end
	inst.entity:AddNetwork()
	
	if minimap ~= nil then
        inst.entity:AddMiniMapEntity()
        inst.MiniMapEntity:SetIcon(minimap)
    end
	
	if anim ~= nil then
		inst.AnimState:SetBank("quagmire_victorian_structures")
		inst.AnimState:SetBuild("quagmire_victorian_structures")
		inst.AnimState:PlayAnimation(anim)

		MakeObstaclePhysics(inst, 1)
	else
	    inst:AddTag("NOCLICK")
	end

    if not TheNet:IsDedicated() then
		if add_decor then
			inst:DoTaskInTime(0, PopulateDecor)
		end
	end
	
	if anim ~= nil then
		inst:AddTag("structure")
		inst:AddTag("brokenstructures")
	end

	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	if anim ~= nil then
		inst:AddComponent("inspectable")
		inst:AddComponent("lootdropper")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(1)
		inst.components.workable:SetOnFinishCallback(onhammered)
		-- inst.components.workable:SetOnWorkCallback(onhit)
	end

	return inst
end

local function MakeStrcuture(name, anim, add_decor, minimap)
	local function fn() 
		return common_fn(anim, add_decor, minimap)
	end

	return Prefab("kyno_rubble_"..name, fn, assets, {"quagmire_old_rubble"})
end

return Prefab("kyno_old_rubble", decorfn, assets),
MakeStrcuture("bike", "penny_farthing", nil, "kyno_bike.tex"),
MakeStrcuture("carriage", "carriage", nil, "kyno_carriage.tex"),
MakeStrcuture("empty", nil, true),
MakeStrcuture("clock", "grandfather_clock", nil, "kyno_gorgeclock.tex"),
MakeStrcuture("cathedral", "cathedral", nil, "kyno_cathedral.tex"),
MakeStrcuture("pubdoor", "pub_door", nil, "kyno_pubdoor.tex"),
MakeStrcuture("door", "door", nil, "kyno_housedoor.tex"),
MakeStrcuture("roof", "roof", nil, "kyno_roof.tex"),
MakeStrcuture("clocktower", "clocktower", nil, "kyno_clocktower.tex"),
MakeStrcuture("house", "house", nil, "kyno_house.tex"),
MakeStrcuture("chimney", "chimney", nil, "kyno_chimney1.tex"),
MakeStrcuture("chimney2", "chimney2", nil, "kyno_chimney2.tex"),
MakePlacer("kyno_rubble_bike_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "penny_farthing"),
MakePlacer("kyno_rubble_carriage_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "carriage"),
MakePlacer("kyno_rubble_clock_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "grandfather_clock"),
MakePlacer("kyno_rubble_cathedral_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "cathedral"),
MakePlacer("kyno_rubble_pubdoor_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "pub_door"),
MakePlacer("kyno_rubble_door_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "door"),
MakePlacer("kyno_rubble_roof_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "roof"),
MakePlacer("kyno_rubble_clocktower_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "clocktower"),
MakePlacer("kyno_rubble_house_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "house"),
MakePlacer("kyno_rubble_chimney_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "chimney"),
MakePlacer("kyno_rubble_chimney2_placer", "quagmire_victorian_structures", "quagmire_victorian_structures", "chimney2")