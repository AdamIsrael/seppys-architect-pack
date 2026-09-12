require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/seashell.zip"),
}

local prefabs =
{
	"sap_seashell_buried",
}

local function ondeploy(inst, pt, deployer)
local seashell = SpawnPrefab("sap_seashell_buried")
	if seashell ~= nil then
		seashell.Transform:SetPosition(pt:Get())
		inst.components.stackable:Get():Remove()
		seashell.components.pickable:OnTransplant()
		if deployer ~= nil and deployer.SoundEmitter ~= nil then
			deployer.SoundEmitter:PlaySound("dontstarve/common/plant")
		end
	end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("seashell")
    inst.AnimState:SetBuild("seashell")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("cattoy")
	inst:AddTag("seashell")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	
    inst:AddComponent("inspectable")
    
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

    inst:AddComponent("tradable")
	inst:AddComponent("deployable")
	inst.components.deployable.ondeploy = ondeploy
	inst.components.deployable:SetDeployMode(DEPLOYMODE.PLANT)
	
    return inst
end

return Prefab("seashell", fn, assets, prefabs),
MakePlacer("seashell_placer", "seashell", "seashell", "idle")