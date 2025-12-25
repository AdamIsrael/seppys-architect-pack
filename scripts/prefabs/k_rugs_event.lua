require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/yotb_post_rug.zip"),
	Asset("ANIM", "anim/yotc_carrat_rug.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"silk",
	"charcoal",
}

local function OnBurnt(inst)
	inst:DoTaskInTime( 0.5, function() if inst.components.burnable then inst.components.burnable:Extinguish() end
		inst:RemoveComponent("burnable")
		inst:RemoveComponent("propagator")
	
		inst.components.lootdropper:SetLoot({"charcoal", "silk"})
			
		if inst.components.workable then
			inst.components.workable:SetWorkLeft(1)
			inst.components.workable:SetOnFinishCallback(onhammered)
		end
	end)
    
	inst.AnimState:PlayAnimation("burnt", true)
    inst.AnimState:SetRayTestOnBB(true)
	
    inst:AddTag("burnt")
end

local function onhammered(inst, worker)
	if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function onsave(inst, data)
    if inst:HasTag("burnt") or inst:HasTag("fire") then
        data.burnt = true
    end
end

local function onload(inst, data)
	if data and data.burnt then
		OnBurnt(inst)
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("idle", true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetBank("post_rug")
	inst.AnimState:SetBuild("yotb_post_rug")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("kyno_rug")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_RUGS_OVAL"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

	inst.OnSave = onsave
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

local function fn2()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst.AnimState:SetBank("carrat_rug")
	inst.AnimState:SetBuild("yotc_carrat_rug")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("kyno_rug")
	inst:AddTag("NOBLOCK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_RUGS_OVAL"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

	MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
    inst.components.burnable:SetFXLevel(2)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

	inst.OnSave = onsave
	inst.OnLoad = onload
	
	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("kyno_yotb_rug", fn, assets, prefabs),
Prefab("kyno_yotc_rug", fn2, assets, prefabs),
MakePlacer("kyno_yotb_rug_placer", "post_rug", "yotb_post_rug", "idle", true),
MakePlacer("kyno_yotc_rug_placer", "carrat_rug", "yotc_carrat_rug", "idle", true)