require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/tesla_tree_short.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local function DoEffect(inst)
	local fx = SpawnPrefab("moose_nest_fx_idle")
	local pos = inst:GetPosition()
		fx.Transform:SetPosition(pos.x, 0.1, pos.z)
	if inst.fx_task then
		inst.fx_task:Cancel()
		inst.fx_task = nil
	end
	inst.fx_task = inst:DoTaskInTime(math.random() * 10, DoEffect)
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function GetStatus(inst)
    return not inst.lighton and "ON" or nil
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("chop")
    inst.AnimState:PushAnimation("sway1_loop", true)
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("sway1_loop", true)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddLight()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.Light:SetFalloff(0.9)
    inst.Light:SetIntensity(0.6)
    inst.Light:SetRadius(7)
    inst.Light:Enable(true)
    inst.Light:SetColour(197/255, 197/255, 10/255)
	
    MakeObstaclePhysics(inst, .2)
	
    inst.AnimState:SetBank("tesla_tree_short")
    inst.AnimState:SetBuild("tesla_tree_short")
    inst.AnimState:PlayAnimation("sway1_loop", true)
    
	inst:AddTag("structure")
	inst:AddTag("teslalamp")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	inst:AddComponent("battery")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	DoEffect(inst)
	
    return inst
end

return Prefab("sap_teslapost", fn, assets),
MakePlacer("sap_teslapost_placer", "tesla_tree_short", "tesla_tree_short", "sway1_loop")