require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/skeletons.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"boneshard",
}

local names = {"idle7", "idle8"}

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_rock")
	
	inst:Remove()
end

local function OnBuilt(inst)
    inst.AnimState:PushAnimation(inst.animname, true)
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
	
    MakeSmallObstaclePhysics(inst, 0.25)
	
    inst.AnimState:SetBank("skeleton")
    inst.AnimState:SetBuild("skeletons")
    
	inst:AddTag("structure")
	inst:AddTag("skeleton")
	
	inst:SetPrefabNameOverride("SKELETON")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.animname = names[math.random(#names)]
    inst.AnimState:PlayAnimation(inst.animname, true)
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SKELETON"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	
    return inst
end

return Prefab("kyno_skeleton2", fn, assets),
MakePlacer("kyno_skeleton2_placer", "skeleton", "skeletons", "idle7")