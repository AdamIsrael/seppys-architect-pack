require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/sharkboi_iceplow_fx.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"ice",
}

local function OnWork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE * (1/3) then
		inst.AnimState:PlayAnimation("iceplow" .. inst.number .. "_idle", true)
	elseif workleft < TUNING.ROCKS_MINE * (2/3) then
		inst.AnimState:PlayAnimation("iceplow" .. inst.number .. "_idle", true)
	else
		inst.AnimState:PlayAnimation("iceplow" .. inst.number .. "_idle", true)
	end
end

local function OnWorked(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
	
	inst:Remove()
end

local function OnBuilt(inst)
    inst.AnimState:PushAnimation("iceplow".. inst.number .."_idle", true)
end

local function onefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetBank("sharkboi_iceplow_fx")
	inst.AnimState:SetBuild("sharkboi_iceplow_fx")
	inst.AnimState:PlayAnimation("iceplow1_idle")
	-- inst.AnimState:SetFinalOffset(1)
	
	inst:AddTag("structure")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.number = "1"

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_SHARKBOI_ICEPLOW1"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable:SetOnFinishCallback(OnWorked)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

	return inst
end

local function twofn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetBank("sharkboi_iceplow_fx")
	inst.AnimState:SetBuild("sharkboi_iceplow_fx")
	inst.AnimState:PlayAnimation("iceplow2_idle")
	-- inst.AnimState:SetFinalOffset(1)
	
	inst:AddTag("structure")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.number = "2"

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ICE"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable:SetOnFinishCallback(OnWorked)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

	return inst
end

local function PlaceTestFn(inst)
	inst.AnimState:SetFinalOffset(1)
end

return Prefab("sap_sharkboi_iceplow1", onefn, assets, prefabs),
Prefab("sap_sharkboi_iceplow2", twofn, assets, prefabs),
MakePlacer("sap_sharkboi_iceplow1_placer", "sharkboi_iceplow_fx", "sharkboi_iceplow_fx", "iceplow1_idle"), -- , false, nil, nil, nil, nil, nil, PlaceTestFn),
MakePlacer("sap_sharkboi_iceplow2_placer", "sharkboi_iceplow_fx", "sharkboi_iceplow_fx", "iceplow2_idle")  -- , false, nil, nil, nil, nil, nil, PlaceTestFn)