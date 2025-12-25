require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/portal_adventure.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onfar(inst)
	inst.AnimState:PushAnimation("deactivate", false)
	inst.AnimState:PushAnimation("idle_off", true)
	inst.SoundEmitter:KillSound("idle")
	inst.SoundEmitter:PlaySound("dontstarve/common/maxwellportal_shutdown")
	inst:DoTaskInTime(1, function()
	inst.SoundEmitter:SetVolume("ragtime", 0)
	end)
end

local function onnear(inst)
	inst.AnimState:PushAnimation("activate", false)
	inst.AnimState:PushAnimation("idle_loop_on", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/maxwellportal_activate")
	inst.SoundEmitter:PlaySound("dontstarve/common/maxwellportal_idle", "idle")
	inst:DoTaskInTime(1, function()
	if inst.ragtime_playing == nil then
		inst.ragtime_playing = true
		inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/ragtime", "ragtime")
	else
		inst.SoundEmitter:SetVolume("ragtime", 1)
		end
	end)
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, 1)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_maxwelldoor.tex")
	
    inst.AnimState:SetBank("portal_adventure")
    inst.AnimState:SetBuild("portal_adventure")
    inst.AnimState:PlayAnimation("idle_off", true)
    
	inst:AddTag("structure")
	inst:AddTag("maxwelldoor")
	
	inst:SetPrefabNameOverride("adventure_portal")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("playerprox")
	inst.components.playerprox:SetDist(4, 5)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("kyno_waxwelldoor", fn, assets),
MakePlacer("kyno_waxwelldoor_placer", "portal_adventure", "portal_adventure", "idle_off")