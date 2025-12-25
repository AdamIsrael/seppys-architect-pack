require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/sharkboi_icespike.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"ice",
}

local names = {"spike1", "spike2", "spike3"}

local function OnWork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE * (1/3) then
		inst.AnimState:PlayAnimation(inst.animname .. "_low", true)
	elseif workleft < TUNING.ROCKS_MINE * (2/3) then
		inst.AnimState:PlayAnimation(inst.animname .. "_low", true)
	else
		inst.AnimState:PlayAnimation(inst.animname, true)
	end
end

local function OnWorkLarge(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE * (1/3) then
		inst.AnimState:PlayAnimation("spike4_low", true)
	elseif workleft < TUNING.ROCKS_MINE * (2/3) then
		inst.AnimState:PlayAnimation("spike4_med", true)
	else
		inst.AnimState:PlayAnimation("spike4", true)
	end
end

local function OnWorked(inst, worker)
	inst.components.lootdropper:DropLoot()
	worker.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
	
	inst:Remove()
end

local function OnBuilt(inst)
    inst.AnimState:PushAnimation(inst.animname, true)
end

local function OnBuiltLarge(inst)
    inst.AnimState:PushAnimation("spike4", true)
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

local function twofn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("sharkboi_icespike")
	inst.AnimState:SetBuild("sharkboi_icespike")
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname, true)

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ICE"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable:SetOnFinishCallback(OnWorked)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

	return inst
end

local function fourfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, 1)

	inst.AnimState:SetBank("sharkboi_icespike")
	inst.AnimState:SetBuild("sharkboi_icespike")
	inst.AnimState:PlayAnimation("spike4")
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.number = "4"

	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ICE"
	
	inst:AddComponent("workable")
	inst.components.workable.savestate = true
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(OnWorkLarge)
	inst.components.workable:SetOnFinishCallback(OnWorked)
	
	inst:ListenForEvent("onbuilt", OnBuiltLarge)

	return inst
end

return Prefab("kyno_sharkboi_icespike2", twofn, assets, prefabs),
Prefab("kyno_sharkboi_icespike4", fourfn, assets, prefabs),
MakePlacer("kyno_sharkboi_icespike2_placer", "sharkboi_icespike", "sharkboi_icespike", "spike2"),
MakePlacer("kyno_sharkboi_icespike4_placer", "sharkboi_icespike", "sharkboi_icespike", "spike4")