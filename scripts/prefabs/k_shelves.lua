require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/room_shelves.zip"),
	Asset("ANIM", "anim/pedestal_crate.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
	
	Asset("ATLAS_BUILD", "images/inventoryimages.xml",  256),
	Asset("ATLAS_BUILD", "images/inventoryimages1.xml", 256),
    Asset("ATLAS_BUILD", "images/inventoryimages2.xml", 256),
    Asset("ATLAS_BUILD", "images/inventoryimages3.xml", 256),	
	Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
    
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs =
{
    "kyno_shelves_slot",
}

local function OnHammered(inst)
    inst.components.lootdropper:DropLoot()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	
    if inst.SoundEmitter then
        inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    end

    if inst.shelves and #inst.shelves > 0 then
        for i, v in ipairs(inst.shelves) do           
            v.empty(v)
            v:Remove()
        end
    end
	
	-- Double check to remove the slots if somehow they're still there when the shelf is destroyed.
	inst:DoTaskInTime(1, function()
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, 0, z, 2, {"DELETE_SHELVES_SLOT"})
	
		for k, item in pairs(ents) do
			if item then 
				item:Remove() 
			end
		end
	end)
	
    inst.shelves = nil
	inst.childrenspawned = nil
	
    inst:Remove()
end    

local function OnHit(inst, worker)
    if not inst:HasTag("burnt") then
        -- inst.AnimState:PlayAnimation("hit") -- Need to add the anim.
        if inst.shelves and #inst.shelves > 0 then
            -- Pick one item in shelves_slots to drop.
            local candidates = {}
            for i, v in ipairs(inst.shelves) do
                if v.components.pocket.numitems > 0 then
                    table.insert(candidates, v)
                end
            end
            if #candidates > 0 then
                local which = math.floor(math.random() * #candidates) + 1
                if candidates[which].components.pocket.numitems > 0 then
                    candidates[which].empty(candidates[which])
                end
            end
        end
    end
end

local function SetPlayerUncraftable(inst)
    inst.entity:AddSoundEmitter()
    
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
    inst:RemoveTag("NOCLICK")
    
	if not inst.components.lootdropper then 
		inst:AddComponent("lootdropper")
	end
   
	if not inst.components.workable then 
		inst:AddComponent("workable")
		inst.components.workable:SetWorkLeft(4)
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetOnFinishCallback(OnHammered)
		inst.components.workable:SetOnWorkCallback(OnHit)
	end
end

local function OnBuilt(inst)
    SetPlayerUncraftable(inst)
    inst.onbuilt = true         
end

local function SetImage(inst, ent, slot)
    local src = ent 
    local image = nil 

    if src ~= nil and src.components.inventoryitem ~= nil then
        image = #(ent.components.inventoryitem.imagename or "") > 0 and ent.components.inventoryitem.imagename or ent.prefab
    end 

    if image ~= nil then 	
        local texname = image..".tex"

		local atlas = src.replica.inventoryitem:GetAtlas()
		if inst:HasTag("no_perish_shelf") then
			if ent.components.perishable then 
				ent.components.perishable:StopPerishing() 
			end	
		end

		if ent.path then atlas = ent.path
			elseif atlas and atlas == "images/inventoryimages.xml"  then atlas = "images/inventoryimages.xml"
			elseif atlas and atlas == "images/inventoryimages1.xml" then atlas = "images/inventoryimages1.xml"
			elseif atlas and atlas == "images/inventoryimages2.xml" then atlas = "images/inventoryimages2.xml"
			elseif atlas and atlas == "images/inventoryimages3.xml" then atlas = "images/inventoryimages3.xml"
			else atlas = "images/inventoryimages/tap_inventoryimages.xml" 
		end
	
		inst.AnimState:OverrideSymbol(slot, resolvefilepath(atlas), texname)
	
        inst.imagename = src ~=nil or ""
    else
        inst.imagename = ""
        inst.AnimState:ClearOverrideSymbol(slot)
    end
end 

local function SetImageFromName(inst, name, slot)
    local image = name

    if image ~= nil then 
        local texname = image..".tex"
        inst.AnimState:OverrideSymbol(slot, resolvefilepath("images/inventoryimages/tap_inventoryimages.xml"), texname)
        inst.imagename = image
    else
        inst.imagename = ""
        inst.AnimState:ClearOverrideSymbol(slot)
    end
end 

local function DisplayNameFn(inst)
    return "whatever"
end

local function SpawnChildren(inst)
    if not inst.childrenspawned then
        inst.shelves = {}
		
        for i = 1, inst.size do
            local object = SpawnPrefab("kyno_shelves_slot")

            if inst.swp_img_list and object.components.inventoryitem and object.components.shelfer then
                object.components.inventoryitem:PutOnShelf(inst, inst.swp_img_list[i])
                object.components.shelfer:SetShelf(inst, inst.swp_img_list[i])            
            else 
                if object.components.inventoryitem and object.components.shelfer then
					object.components.inventoryitem:PutOnShelf(inst, "SWAP_img"..i)
					object.components.shelfer:SetShelf(inst, "SWAP_img"..i)  
                end
            end
			
            table.insert(inst.shelves, object)
			
            if inst.shelfitems then
                for index,set in pairs(inst.shelfitems)do
                    if set[1] == i then
                        local item = SpawnPrefab(set[2])
                        if item and object.components.shelfer then
                            object.components.shelfer:AcceptGift(nil, item)
                        end
                    end
                end
            end
        end
		
        inst.childrenspawned = true
    end
end

local function OnSave(inst, data)    
    if inst.childrenspawned then
        data.childrenspawned = inst.childrenspawned
    end
	  
    if inst.onbuilt then
        data.onbuilt = inst.onbuilt
    end     
	
    if inst:HasTag("playercrafted") then
        data.playercrafted = true
    end    

    data.shelves = {}
    if inst.shelves then
        for i, v in ipairs(inst.shelves)do
            table.insert(data.shelves, v.GUID)
        end
    end

	data.rotation = inst.Transform:GetRotation()  
    data.texture = inst.texture 
end

local function OnLoad(inst, data)
    if data == nil then 
		return 
	end
	
    if data.rotation then
        inst.Transform:SetRotation(data.rotation)
    end    
	
    if data.childrenspawned then
        inst.childrenspawned = data.childrenspawned
    end
	
    if data.onbuilt then
        SetPlayerUncraftable(inst)
        inst.onbuilt = data.onbuilt
    end     
	
    if data.playercrafted then
        inst:AddTag("playercrafted")
    end    
    
    if data.texture then 
		inst.texture = data.texture 
		inst.AnimState:PlayAnimation(data.texture, true)
    end 
end

local function OnLoadPostPass(inst, ents, data)
	--[[
    inst.shelves = {}
    if data and data.shelves and ents then
        for i, v in ipairs(data.shelves) do
            if ents and v and ents[v].entity then
                local shelfer = ents[v].entity
                if shelfer then
                    table.insert(inst.shelves, shelfer)
                end
            end    
        end
    end
	]]--
end  

local function common(setsize, swp_img_list, locked, physics_round, save_rotation)
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()        
	inst.entity:AddNetwork()
	
	local size = setsize or 6
        
    if physics_round then
        MakeObstaclePhysics(inst, .1)
    else
        MakeObstaclePhysics(inst, .1)
    end 
	
	if save_rotation then
		inst.Transform:SetTwoFaced() -- This makes the shelves weird af.
	end
	
	inst.AnimState:SetBank("bookcase")
	inst.AnimState:SetBuild("room_shelves")
    inst.AnimState:PlayAnimation("wood", false)

	inst:AddTag("NOCLICK")
    inst:AddTag("wallsection")
    inst:AddTag("furniture")
	inst:AddTag("no_perish_shelf")
	inst:AddTag("rotatableobject")

    inst.imagename = nil 

    inst.SetImage = SetImage
    inst.SetImageFromName = SetImageFromName
    inst.swp_img_list = swp_img_list
    inst.size = setsize or 6
	
    if swp_img_list then
        for i = 1, size do
            SetImageFromName(inst, nil, swp_img_list[i])
        end
    else
        for i = 1, size do
            SetImageFromName(inst, nil, "SWAP_img"..i)
        end
    end
   
    inst:ListenForEvent("onbuilt", function()
        OnBuilt(inst)
    end)          

    inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
    inst.OnLoadPostPass = OnLoadPostPass

    inst:DoTaskInTime(0, function() 
        if inst:HasTag("playercrafted") then
            SetPlayerUncraftable(inst)
        end

        SpawnChildren(inst) 
    end)
	
	if save_rotation then
		inst:AddComponent("savedrotation")
	end

    return inst
end

local function pedestal(setsize, swp_img_list, locked, physics_round, save_rotation)
    local inst = CreateEntity()
	
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddPhysics()        
	inst.entity:AddNetwork()
	
	local size = setsize or 6
        
    if physics_round then
        MakeObstaclePhysics(inst, .1)
    else
        MakeObstaclePhysics(inst, .1)
    end 
	
	if save_rotation then
		inst.Transform:SetTwoFaced() -- This makes the shelves weird af.
	end
	
	inst.AnimState:SetBank("pedestal")
	inst.AnimState:SetBuild("pedestal_crate")
    inst.AnimState:PlayAnimation("wood", false)

    inst:AddTag("NOCLICK")
    inst:AddTag("wallsection")
    inst:AddTag("furniture")
	inst:AddTag("no_perish_shelf")    
	inst:AddTag("rotatableobject")

    inst.imagename = nil 
    inst.SetImage = SetImage
    inst.SetImageFromName = SetImageFromName
    inst.swp_img_list = swp_img_list
    inst.size = setsize or 6
	
    if swp_img_list then
        for i = 1, size do
            SetImageFromName(inst, nil, swp_img_list[i])
        end
    else
        for i = 1, size do
            SetImageFromName(inst, nil, "SWAP_img"..i)
        end
    end
   
    inst:ListenForEvent("onbuilt", function()
        OnBuilt(inst)
    end)          

    inst.OnSave = OnSave 
    inst.OnLoad = OnLoad
    inst.OnLoadPostPass = OnLoadPostPass

    inst:DoTaskInTime(0, function() 
        if inst:HasTag("playercrafted") then
            SetPlayerUncraftable(inst)
        end

        SpawnChildren(inst) 
    end)
	
	if save_rotation then
		inst:AddComponent("savedrotation")
	end

    return inst
end

local function wood()
    local inst = common()
	
    inst.AnimState:PlayAnimation("wood", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function basic()
    local inst = common()

    inst.AnimState:PlayAnimation("basic", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function marble()
    local inst = common()
   
    inst.AnimState:PlayAnimation("marble", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function glass()
    local inst = common()
    
    inst.AnimState:PlayAnimation("glass", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function ladder()
    local inst = common()
    
    inst.AnimState:PlayAnimation("ladder", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function hutch()
    local inst = common()
    
    inst.AnimState:PlayAnimation("hutch", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function industrial()
    local inst = common()
    
    inst.AnimState:PlayAnimation("industrial", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function adjustable()
    local inst = common()
    
    inst.AnimState:PlayAnimation("adjustable", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function fridge()
    local inst = common()
    
    inst.AnimState:PlayAnimation("fridge", false)
	
    inst:AddTag("playercrafted")
    inst:AddTag("shelf_fridge")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function cinderblocks()
    local inst = common(nil,nil,nil,nil,true)
    
    inst.AnimState:PlayAnimation("cinderblocks", false) 
	
    inst:AddTag("playercrafted")
    inst:AddTag("estante")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function midcentury()
    local inst = common()
    
    inst.AnimState:PlayAnimation("midcentury", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function wallmount()
    local inst = common()
    
    inst.AnimState:PlayAnimation("wallmount", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function aframe()
    local inst = common()
    
    inst.AnimState:PlayAnimation("aframe", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function crates()
    local inst = common(nil,nil,nil,nil,true)
    
    inst.AnimState:PlayAnimation("crates", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function metalcrates()
    local inst = common(nil,nil,nil,nil,true)
    
    inst.AnimState:PlayAnimation("metalcrates", false)
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function pipe()
    local inst = common()
    
    inst.AnimState:PlayAnimation("pipe", false) 
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function hattree()
    local inst = common()
    
    inst.AnimState:PlayAnimation("hattree", false) 
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelf_fridge")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function pallet()
    local inst = common()
    
    inst.AnimState:PlayAnimation("pallet", false) 
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    
    return inst
end

local function floating()
    local inst = common()
    
    inst.AnimState:PlayAnimation("floating", false) 
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function display()
    local inst = common(3, nil,nil,true)
    
    inst.AnimState:SetBuild("room_shelves")
    inst.AnimState:SetBank("bookcase")    
    inst.AnimState:PlayAnimation("displayshelf_wood", false) 
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function display_metal()
    local inst = display()
    
    inst.AnimState:PlayAnimation("displayshelf_metal", false) 
	
	inst:AddTag("shelfcanaccept")
	
    MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function ruins()
    local inst = common(1, nil,nil,true)
	
    local minimap = inst.entity:AddMiniMapEntity()
    inst.MiniMapEntity:SetIcon("kyno_pigruins_shelf.tex")
	
    inst.AnimState:SetBuild("room_shelves")
    inst.AnimState:SetBank("bookcase")    
    inst.AnimState:PlayAnimation("ruins", false) 
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
    return inst
end

local function queen_display_common(size,list)
    local inst = common(size, list, false,true)
	
    inst.AnimState:SetBuild("pedestal_crate")
    inst.AnimState:SetBank("pedestal")    
	
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function queen_display1()
    local inst = queen_display_common(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("lock19_east", false)
	
    inst:AddTag("shelfcanaccept")
	
    return inst
end

local function queen_display2()
    local inst = queen_display_common(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("lock17_east", false) 
    
    return inst
end

local function queen_display3()
    local inst = queen_display_common(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("lock12_west", false) 
	
    inst:AddTag("shelfcanaccept")
	
    return inst
end

local function queen_display4()
    local inst = queen_display_common(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("lock12_west", false) 
    
    return inst
end

local function bank()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("bank", false) 
	inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function woodcrate()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle", false) 
	-- inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function barrel()
    local inst = pedestal(1,{"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_barrel", false) 
	inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function barreldome()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_barrel_dome", false) 
	inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function cablespool()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_cablespool", false)
	inst.AnimState:Hide("sign_overlay")
	-- inst.AnimState:Hide("pedestal_sign")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function cakestand()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_cakestand", false)
	inst.AnimState:Hide("sign_overlay")
	-- inst.AnimState:Hide("pedestal_sign")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function cakestanddome()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_cakestand_dome", false)
	inst.AnimState:Hide("sign_overlay")
	-- inst.AnimState:Hide("pedestal_sign")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function cart()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_cart", false) 
	-- inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function fridge2()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_fridge_display", false) 
	inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelf_fridge")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function globe()
    local inst = pedestal(1,{"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_globe_bar", false) 
	inst.AnimState:Hide("sign_overlay")
	inst.AnimState:Hide("pedestal_sign")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function ice()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_ice_box", false) 
	inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelf_fridge")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function icebucket()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_ice_bucket", false) 
	inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelf_fridge")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function mahogany()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_mahoganycase", false) 
	inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function marble2()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_marble", false) 
	inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function marblesilk()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_marblesilk", false) 
	inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function metal()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_metal", false) 
	inst.AnimState:Hide("sign_overlay")
	-- inst.AnimState:Hide("pedestal_sign")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function stoneslab()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_stoneslab", false) 
	inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function traystand()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_traystand", false)
	inst.AnimState:Hide("sign_overlay")
	-- inst.AnimState:Hide("pedestal_sign")	
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function wagon()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_wagon", false) 
	inst.AnimState:Hide("sign_overlay")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function yotp()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_yotp", false) 
	inst.AnimState:Hide("sign_overlay")
	-- inst.AnimState:Hide("pedestal_sign")	
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function yotp2()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("idle_yotp_2", false) 
	inst.AnimState:Hide("sign_overlay")
	-- inst.AnimState:Hide("pedestal_sign")	
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

local function lockroyal()
    local inst = pedestal(1, {"SWAP_SIGN"})
    
    inst.AnimState:PlayAnimation("lock1_front", true) 
	inst.AnimState:Hide("sign_overlay")
	inst.AnimState:Show("pedestal_lock")
	
    inst:AddTag("playercrafted")
	inst:AddTag("shelfcanaccept")
	
	MakeObstaclePhysics(inst, 0.1)
	
    return inst
end

return Prefab("kyno_shelves_wood", wood, assets, prefabs),
Prefab("kyno_shelves_basic", basic, assets, prefabs),
Prefab("kyno_shelves_marble", marble, assets, prefabs),
Prefab("kyno_shelves_glass", glass, assets, prefabs),
Prefab("kyno_shelves_ladder", ladder, assets, prefabs),
Prefab("kyno_shelves_hutch", hutch, assets, prefabs),
Prefab("kyno_shelves_industrial", industrial, assets, prefabs),
Prefab("kyno_shelves_adjustable", adjustable, assets, prefabs),
Prefab("kyno_shelves_fridge", fridge, assets, prefabs), 
Prefab("kyno_shelves_cinderblocks", cinderblocks, assets, prefabs),
Prefab("kyno_shelves_midcentury", midcentury, assets, prefabs),
Prefab("kyno_shelves_wallmount", wallmount, assets, prefabs),
Prefab("kyno_shelves_aframe", aframe, assets, prefabs),
Prefab("kyno_shelves_crates", crates, assets, prefabs),
Prefab("kyno_shelves_metalcrates", metalcrates, assets, prefabs),
Prefab("kyno_shelves_pipe", pipe, assets, prefabs),
Prefab("kyno_shelves_hattree", hattree, assets, prefabs),
Prefab("kyno_shelves_pallet", pallet, assets, prefabs),
Prefab("kyno_shelves_floating", floating, assets, prefabs),
Prefab("kyno_shelves_displaycase", display, assets, prefabs),
Prefab("kyno_shelves_displaycase_metal", display_metal, assets, prefabs),
Prefab("kyno_shelves_queen_display_1", queen_display1, assets, prefabs),
Prefab("kyno_shelves_queen_display_2", queen_display2, assets, prefabs),
Prefab("kyno_shelves_queen_display_3", queen_display3, assets, prefabs),
Prefab("kyno_shelves_queen_display_4", queen_display4, assets, prefabs),
Prefab("kyno_shelves_ruins", ruins, assets, prefabs),
Prefab("kyno_shelves_bank", bank, assets, prefabs),
Prefab("kyno_shelves_woodcrate", woodcrate, assets, prefabs),
Prefab("kyno_shelves_barrel", barrel, assets, prefabs),
Prefab("kyno_shelves_barreldome", barreldome, assets, prefabs),
Prefab("kyno_shelves_cablespool", cablespool, assets, prefabs),
Prefab("kyno_shelves_cakestand", cakestand, assets, prefabs),
Prefab("kyno_shelves_cakestanddome", cakestanddome, assets, prefabs),
Prefab("kyno_shelves_cart", cart, assets, prefabs),
Prefab("kyno_shelves_fridge2", fridge2, assets, prefabs),
Prefab("kyno_shelves_globe", globe, assets, prefabs),
Prefab("kyno_shelves_ice", ice, assets, prefabs),
Prefab("kyno_shelves_icebucket", icebucket, assets, prefabs),
Prefab("kyno_shelves_mahogany", mahogany, assets, prefabs),
Prefab("kyno_shelves_marble2", marble2, assets, prefabs),
Prefab("kyno_shelves_marblesilk", marblesilk, assets, prefabs),
Prefab("kyno_shelves_metal", metal, assets, prefabs),
Prefab("kyno_shelves_stoneslab", stoneslab, assets, prefabs),
Prefab("kyno_shelves_traystand", traystand, assets, prefabs),
Prefab("kyno_shelves_wagon", wagon, assets, prefabs),
Prefab("kyno_shelves_yotp", yotp, assets, prefabs),
Prefab("kyno_shelves_yotp2", yotp2, assets, prefabs),
Prefab("kyno_shelves_lock", lockroyal, assets, prefabs),
MakePlacer("kyno_shelves_wood_placer", "bookcase", "room_shelves", "wood"),
MakePlacer("kyno_shelves_basic_placer", "bookcase", "room_shelves", "basic"),
MakePlacer("kyno_shelves_marble_placer", "bookcase", "room_shelves", "marble"),
MakePlacer("kyno_shelves_glass_placer", "bookcase", "room_shelves", "glass"),
MakePlacer("kyno_shelves_ladder_placer", "bookcase", "room_shelves", "ladder"),
MakePlacer("kyno_shelves_hutch_placer", "bookcase", "room_shelves", "hutch"),
MakePlacer("kyno_shelves_industrial_placer", "bookcase", "room_shelves", "industrial"),
MakePlacer("kyno_shelves_adjustable_placer", "bookcase", "room_shelves", "adjustable"),
MakePlacer("kyno_shelves_wallmount_placer", "bookcase", "room_shelves", "wallmount"),
MakePlacer("kyno_shelves_fridge_placer", "bookcase", "room_shelves", "fridge"),
MakePlacer("kyno_shelves_floating_placer", "bookcase", "room_shelves", "floating"),
MakePlacer("kyno_shelves_cinderblocks_placer", "bookcase", "room_shelves", "cinderblocks", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_midcentury_placer", "bookcase", "room_shelves", "midcentury"),
MakePlacer("kyno_shelves_aframe_placer", "bookcase", "room_shelves", "aframe"),
MakePlacer("kyno_shelves_crates_placer", "bookcase", "room_shelves", "crates", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_metalcrates_placer", "bookcase", "room_shelves", "metalcrates", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_pipe_placer", "bookcase", "room_shelves", "pipe"),
MakePlacer("kyno_shelves_hattree_placer", "bookcase", "room_shelves", "hattree"),
MakePlacer("kyno_shelves_pallet_placer", "bookcase", "room_shelves", "pallet"),
MakePlacer("kyno_shelves_displaycase_placer", "bookcase", "room_shelves", "displayshelf_wood"),
MakePlacer("kyno_shelves_displaycase_metal_placer", "bookcase", "room_shelves", "displayshelf_metal"),
MakePlacer("kyno_shelves_ruins_placer", "bookcase", "room_shelves", "ruins"),
MakePlacer("kyno_shelves_bank_placer", "pedestal", "pedestal_crate", "bank", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_woodcrate_placer", "pedestal", "pedestal_crate", "idle", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_barrel_placer", "pedestal", "pedestal_crate", "idle_barrel", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_barreldome_placer", "pedestal", "pedestal_crate", "idle_barrel_dome", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_cablespool_placer", "pedestal", "pedestal_crate", "idle_cablespool", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_cakestand_placer", "pedestal", "pedestal_crate", "idle_cakestand", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_cakestanddome_placer", "pedestal", "pedestal_crate", "idle_cakestand_dome", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_cart_placer", "pedestal", "pedestal_crate", "idle_cart", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_fridge2_placer", "pedestal", "pedestal_crate", "idle_fridge_display", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_globe_placer", "pedestal", "pedestal_crate", "idle_globe_bar", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_ice_placer", "pedestal", "pedestal_crate", "idle_ice_box", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_icebucket_placer", "pedestal", "pedestal_crate", "idle_ice_bucket", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_mahogany_placer", "pedestal", "pedestal_crate", "idle_mahoganycase", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_marble2_placer", "pedestal", "pedestal_crate", "idle_marble", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_marblesilk_placer", "pedestal", "pedestal_crate", "idle_marblesilk", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_metal_placer", "pedestal", "pedestal_crate", "idle_metal", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_stoneslab_placer", "pedestal", "pedestal_crate", "idle_stoneslab", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_traystand_placer", "pedestal", "pedestal_crate", "idle_traystand", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_wagon_placer", "pedestal", "pedestal_crate", "idle_wagon", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_yotp_placer", "pedestal", "pedestal_crate", "idle_yotp", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_yotp2_placer", "pedestal", "pedestal_crate", "idle_yotp_2", nil, nil, nil, nil, nil, "two"),
MakePlacer("kyno_shelves_lock_placer", "pedestal", "pedestal_crate", "lock1_front", nil, nil, nil, nil, nil, "two")