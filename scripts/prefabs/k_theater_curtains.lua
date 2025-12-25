require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/charlie_curtains.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function OpenCurtain(inst)
    if inst == nil then
        return
    end
	
	inst.AnimState:PlayAnimation("curtain_open")
    inst.AnimState:PushAnimation("idle_open")
	inst:AddTag("curtain_opened")
end

local function CloseCurtain(inst)
    if inst == nil then
        return
    end
	
	inst.AnimState:PlayAnimation("close")
    inst.AnimState:PushAnimation("idle_closed")
	inst:RemoveTag("curtain_opened")
end

local function ToggleCurtain(inst)
	inst.components.activatable.inactive = true

    if inst:HasTag("curtain_opened") then
        CloseCurtain(inst)
    else
        OpenCurtain(inst)
    end
end

local function GetActivateString(inst)
    if inst:HasTag("curtain_opened") then
		return "CLOSE"
	else
		return "OPEN"
	end
end

local function OnSave(inst, data)
	if inst:HasTag("curtain_opened") then
		data.curtainopened = true
	end
end

local function OnLoad(inst, data)
	if data and data.curtainopened then
		OpenCurtain(inst)
	end
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("charlie_stage_post.png")
	
    inst.AnimState:SetBank("charlie_curtains")
    inst.AnimState:SetBuild("charlie_curtains")
    inst.AnimState:PlayAnimation("idle_closed")
    
	inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.GetActivateVerb = GetActivateString
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "CHARLIE_STAGE_POST"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
    inst.components.workable:SetWorkLeft(4)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = ToggleCurtain
	inst.components.activatable.standingaction = true
	
	MakeHauntableWork(inst)
	
	inst.curtainopened = false
	
	inst.OnSave	= OnSave
	inst.OnLoad = OnLoad
	
    return inst
end

return Prefab("kyno_theater_curtains", fn, assets),
MakePlacer("kyno_theater_curtains_placer", "charlie_curtains", "charlie_curtains", "idle_closed")