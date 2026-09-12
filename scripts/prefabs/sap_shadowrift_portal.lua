require("prefabutil")

local assets =
{
    Asset("ANIM", "anim/shadowrift_portal.zip"),
}

local prefabs =
{
	"rock_break_fx",
}

local names = {"idle1", "idle2", "idle3"}

local function OnWorked(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	inst.AnimState:PlayAnimation("disappear")
	
	inst.SoundEmitter:PlaySound("rifts/portal/portal_disappear")
	inst.SoundEmitter:KillSound("shadowrift_portal_ambience")
	
	inst:ListenForEvent("animover", inst.Remove)
end

local function OnBuilt(inst)
	inst.SoundEmitter:PlaySound("rifts2/shadow_rift/shadowrift_portal_allstage", "shadowrift_portal_ambience")
	inst.AnimState:PlayAnimation("stage_3_pre")
    inst.AnimState:PushAnimation("stage_3_loop", true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("shadowrift_portal.png")
	minimap:SetPriority(1)
	
	MakeObstaclePhysics(inst, 3.2)
    inst.Physics:SetCylinder(3.2, 6)

    inst.AnimState:SetBank ("shadowrift_portal")
    inst.AnimState:SetBuild("shadowrift_portal")
    inst.AnimState:PlayAnimation("stage_3_loop", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)
	
	inst.AnimState:SetSymbolLightOverride("fx_beam",   1)
    inst.AnimState:SetSymbolLightOverride("fx_spiral", 1)
    inst.AnimState:SetLightOverride(0.5)

	inst:AddTag("structure")
	inst:AddTag("birdblocker")
    inst:AddTag("ignorewalkableplatforms")
	inst:AddTag("notraptrigger")
    inst:AddTag("scarytoprey")
	inst:AddTag("NOBLOCK")
	
	inst:SetPrefabNameOverride("SHADOWRIFT_PORTAL")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("rifts2/shadow_rift/shadowrift_portal_allstage", "shadowrift_portal_ambience")

	inst:AddComponent("lootdropper")

    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SHADOWRIFT_PORTAL"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(3)
	inst.components.workable:SetOnFinishCallback(OnWorked)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

    return inst
end

return Prefab("sap_shadowrift_portal", fn, assets, prefabs),
MakePlacer("sap_shadowrift_portal_placer", "shadowrift_portal", "shadowrift_portal", "stage_3_loop", true)