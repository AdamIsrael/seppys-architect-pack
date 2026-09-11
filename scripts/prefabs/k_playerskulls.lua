require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_playerskulls.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_inventoryimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_inventoryimages.xml"),
	Asset("ATLAS_BUILD", "images/inventoryimages/tap_inventoryimages.xml", 256),
	
}

local function common()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("kyno_playerskulls")
    inst.AnimState:SetBuild("kyno_playerskulls")
    
	inst:AddTag("cattoy")
	inst:AddTag("dead_players")
	inst:AddTag("chewable")  
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("tradable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_PLAYERSKULL"
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tap_inventoryimages.xml"
	
	MakeHauntableLaunchAndIgnite(inst)
	
    return inst
end

local function wilson()
    local inst = common()
    inst.AnimState:PlayAnimation("wilson")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wilsonskull"
	
    return inst
end

local function willow()
    local inst = common()
    inst.AnimState:PlayAnimation("willow")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_willowskull"
	
    return inst
end

local function wolfgang()
    local inst = common()
    inst.AnimState:PlayAnimation("wolfgang")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wolfgangskull"
	
    return inst
end

local function wendy()
    local inst = common()
    inst.AnimState:PlayAnimation("wendy")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wendyskull"
	
    return inst
end

local function wx78()
    local inst = common()
    inst.AnimState:PlayAnimation("wx78")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wx78skull"
	
    return inst
end

local function wickerbottom()
    local inst = common()
    inst.AnimState:PlayAnimation("wickerbottom")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wickerbottomskull"
	
    return inst
end

local function woodie()
    local inst = common()
    inst.AnimState:PlayAnimation("woodie")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_woodieskull"
	
    return inst
end

local function wes()
    local inst = common()
    inst.AnimState:PlayAnimation("wes")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wesskull"
	
    return inst
end

local function waxwell()
    local inst = common()
    inst.AnimState:PlayAnimation("waxwell")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_waxwellskull"
	
    return inst
end

local function wathgrithr()
    local inst = common()
    inst.AnimState:PlayAnimation("wathgrithr")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wathgrithrskull"
    return inst
end

local function webber()
    local inst = common()
    inst.AnimState:PlayAnimation("webber")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inspectable.nameoverride = "KYNO_WEBBERSKULL"
	inst.components.inventoryitem.imagename = "sap_webberskull"
	
    return inst
end

local function warly()
    local inst = common()
    inst.AnimState:PlayAnimation("warly")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_warlyskull"
	
    return inst
end

local function wilbur()
    local inst = common()
    inst.AnimState:PlayAnimation("wilbur")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wilburskull"
	
    return inst
end

local function wormwood()
    local inst = common()
    inst.AnimState:PlayAnimation("wormwood")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wormwoodskull"
	
    return inst
end

local function winona()
    local inst = common()
    inst.AnimState:PlayAnimation("winona")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_winonaskull"
	
    return inst
end

local function wortox()
    local inst = common()
    inst.AnimState:PlayAnimation("wortox")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wortoxskull"
	
    return inst
end

local function wurt()
    local inst = common()
    inst.AnimState:PlayAnimation("wurt")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wurtskull"
	
    return inst
end

local function walter()
    local inst = common()
    inst.AnimState:PlayAnimation("walter")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_walterskull"
	
	-- https://www.youtube.com/watch?v=R9Qgxit1Y64
	
    return inst
end

local function wallace()
	local inst = common()
	inst.AnimState:PlayAnimation("wallace")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wallaceskull"
	
	return inst
end

local function winnie()
	local inst = common()
	inst.AnimState:PlayAnimation("winnie")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_winnieskull"
	
	return inst
end

local function waverly()
	local inst = common()
	inst.AnimState:PlayAnimation("waverly")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_waverlyskull"
	
	return inst
end

local function wilton()
	local inst = common()
	inst.AnimState:PlayAnimation("wilton")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wiltonskull"
	
	return inst
end

local function wanda()
	local inst = common()
	inst.AnimState:PlayAnimation("wanda")
	inst.AnimState:SetScale(1.1,1.1,1.1)
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.inventoryitem.imagename = "sap_wandaskull"
	
	return inst
end

local function wonkey()
	local inst = common()
	inst.AnimState:PlayAnimation("wonkey")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "sap_wonkeyskull"
	
	return inst
end

return Prefab("sap_wilsonskull", wilson, assets),
Prefab("sap_willowskull", willow, assets),
Prefab("sap_wolfgangskull", wolfgang, assets),
Prefab("sap_wendyskull", wendy, assets),
Prefab("sap_wx78skull", wx78, assets),
Prefab("sap_wickerbottomskull", wickerbottom, assets),
Prefab("sap_woodieskull", woodie, assets),
Prefab("sap_wesskull", wes, assets),
Prefab("sap_waxwellskull", waxwell, assets),
Prefab("sap_wathgrithrskull", wathgrithr, assets),
Prefab("sap_webberskull", webber, assets),
Prefab("sap_warlyskull", warly, assets),
Prefab("sap_wilburskull", wilbur, assets),
Prefab("sap_wormwoodskull", wormwood, assets),
Prefab("sap_winonaskull", winona, assets),
Prefab("sap_wortoxskull", wortox, assets),
Prefab("sap_wurtskull", wurt, assets),
Prefab("sap_walterskull", walter, assets),
Prefab("sap_wallaceskull", wallace, assets),
Prefab("sap_winnieskull", winnie, assets),
Prefab("sap_waverlyskull", waverly, assets),
Prefab("sap_wiltonskull", wilton, assets),
Prefab("sap_wandaskull", wanda, assets),
Prefab("sap_wonkeyskull", wonkey, assets)