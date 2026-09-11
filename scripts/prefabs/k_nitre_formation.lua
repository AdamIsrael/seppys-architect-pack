require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/pond_nitrecrystal.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"rock_break_fx",
}

local names = {"idle1", "idle2", "idle3"}

local function OnWorked(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("rock_break_fx").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
end

local function OnSave(inst, data)
	data.anim = inst.animname
end

local function OnLoad(inst, data)
	if data and data.anim then
        inst.animname = data.anim
        inst.AnimState:PlayAnimation(inst.animname, true)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetScale(0.75, 0.75)

    inst.AnimState:SetBank("pond_rock")
    inst.AnimState:SetBuild("pond_nitrecrystal")

    inst:AddTag("structure")
	
	inst:SetPrefabNameOverride("NITRE_FORMATION")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname, true)
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "NITRE_FORMATION"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(OnWorked)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

    return inst
end

return Prefab("sap_nitre_formation", fn, assets, prefabs),
MakePlacer("sap_nitre_formation_placer", "pond_rock", "pond_nitrecrystal", "idle1")