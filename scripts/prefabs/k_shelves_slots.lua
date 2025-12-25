local assets =
{
    Asset("ANIM", "anim/shelf_slot.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
}

local prefabs =
{

}

local function empty(inst)     
   local item =  inst.components.pocket:RemoveItem("shelfitem")  
    if item then    
        inst.components.shelfer:GiveGift(item)
		
        local pt = inst.Transform:GetWorldPosition()
		if inst.components.shelfer.shelf then
            pt = inst.components.shelfer.shelf.Transform:GetWorldPosition()
        end
     
		if item and inst.components.lootdropper then
			inst.components.lootdropper:DropLoot(pt)
		end
    end
end

local function common()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddNetwork()

    inst.AnimState:SetBuild("shelf_slot")
    inst.AnimState:SetBank("shelf_slot")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:Show("mouseclick")
	inst.AnimState:SetMultColour(255/255, 255/255, 255/255, 0.02)

	inst.AnimState:SetLayer(LAYER_WORLD)
    inst.AnimState:SetSortOrder(3)	
	
	inst:AddTag("shelfcanaccept")
	inst:AddTag("SHELVES_SLOT")
	inst:AddTag("DELETE_SHELVES_SLOT")
	inst:AddTag("NOBLOCK")
	
	inst:AddComponent("pocket")
    inst:AddComponent("shelfer")
   
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
   
    inst:AddComponent("lootdropper")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.canbepickedup = false
    inst.empty = empty
	
    return inst
end

return Prefab("kyno_shelves_slot", common, assets, prefabs)       