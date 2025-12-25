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
	
	inst.components.inventoryitem.imagename = "kyno_wilsonskull"
	
    return inst
end

local function willow()
    local inst = common()
    inst.AnimState:PlayAnimation("willow")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_willowskull"
	
    return inst
end

local function wolfgang()
    local inst = common()
    inst.AnimState:PlayAnimation("wolfgang")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wolfgangskull"
	
    return inst
end

local function wendy()
    local inst = common()
    inst.AnimState:PlayAnimation("wendy")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wendyskull"
	
    return inst
end

local function wx78()
    local inst = common()
    inst.AnimState:PlayAnimation("wx78")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wx78skull"
	
    return inst
end

local function wickerbottom()
    local inst = common()
    inst.AnimState:PlayAnimation("wickerbottom")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wickerbottomskull"
	
    return inst
end

local function woodie()
    local inst = common()
    inst.AnimState:PlayAnimation("woodie")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_woodieskull"
	
    return inst
end

local function wes()
    local inst = common()
    inst.AnimState:PlayAnimation("wes")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wesskull"
	
    return inst
end

local function waxwell()
    local inst = common()
    inst.AnimState:PlayAnimation("waxwell")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_waxwellskull"
	
    return inst
end

local function wathgrithr()
    local inst = common()
    inst.AnimState:PlayAnimation("wathgrithr")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wathgrithrskull"
    return inst
end

local function webber()
    local inst = common()
    inst.AnimState:PlayAnimation("webber")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inspectable.nameoverride = "KYNO_WEBBERSKULL"
	inst.components.inventoryitem.imagename = "kyno_webberskull"
	
    return inst
end

local function warly()
    local inst = common()
    inst.AnimState:PlayAnimation("warly")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_warlyskull"
	
    return inst
end

local function wilbur()
    local inst = common()
    inst.AnimState:PlayAnimation("wilbur")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wilburskull"
	
    return inst
end

local function wormwood()
    local inst = common()
    inst.AnimState:PlayAnimation("wormwood")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wormwoodskull"
	
    return inst
end

local function winona()
    local inst = common()
    inst.AnimState:PlayAnimation("winona")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_winonaskull"
	
    return inst
end

local function wortox()
    local inst = common()
    inst.AnimState:PlayAnimation("wortox")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wortoxskull"
	
    return inst
end

local function wurt()
    local inst = common()
    inst.AnimState:PlayAnimation("wurt")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wurtskull"
	
    return inst
end

local function walter()
    local inst = common()
    inst.AnimState:PlayAnimation("walter")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_walterskull"
	
	-- https://www.youtube.com/watch?v=R9Qgxit1Y64
	
    return inst
end

local function wallace()
	local inst = common()
	inst.AnimState:PlayAnimation("wallace")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wallaceskull"
	
	return inst
end

local function winnie()
	local inst = common()
	inst.AnimState:PlayAnimation("winnie")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_winnieskull"
	
	return inst
end

local function waverly()
	local inst = common()
	inst.AnimState:PlayAnimation("waverly")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_waverlyskull"
	
	return inst
end

local function wilton()
	local inst = common()
	inst.AnimState:PlayAnimation("wilton")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wiltonskull"
	
	return inst
end

local function wanda()
	local inst = common()
	inst.AnimState:PlayAnimation("wanda")
	inst.AnimState:SetScale(1.1,1.1,1.1)
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst.components.inventoryitem.imagename = "kyno_wandaskull"
	
	return inst
end

local function wonkey()
	local inst = common()
	inst.AnimState:PlayAnimation("wonkey")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.inventoryitem.imagename = "kyno_wonkeyskull"
	
	return inst
end

return Prefab("kyno_wilsonskull", wilson, assets),
Prefab("kyno_willowskull", willow, assets),
Prefab("kyno_wolfgangskull", wolfgang, assets),
Prefab("kyno_wendyskull", wendy, assets),
Prefab("kyno_wx78skull", wx78, assets),
Prefab("kyno_wickerbottomskull", wickerbottom, assets),
Prefab("kyno_woodieskull", woodie, assets),
Prefab("kyno_wesskull", wes, assets),
Prefab("kyno_waxwellskull", waxwell, assets),
Prefab("kyno_wathgrithrskull", wathgrithr, assets),
Prefab("kyno_webberskull", webber, assets),
Prefab("kyno_warlyskull", warly, assets),
Prefab("kyno_wilburskull", wilbur, assets),
Prefab("kyno_wormwoodskull", wormwood, assets),
Prefab("kyno_winonaskull", winona, assets),
Prefab("kyno_wortoxskull", wortox, assets),
Prefab("kyno_wurtskull", wurt, assets),
Prefab("kyno_walterskull", walter, assets),
Prefab("kyno_wallaceskull", wallace, assets),
Prefab("kyno_winnieskull", winnie, assets),
Prefab("kyno_waverlyskull", waverly, assets),
Prefab("kyno_wiltonskull", wilton, assets),
Prefab("kyno_wandaskull", wanda, assets),
Prefab("kyno_wonkeyskull", wonkey, assets)