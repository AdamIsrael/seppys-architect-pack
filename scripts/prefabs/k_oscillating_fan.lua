require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/basefan.zip"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs =
{
	"collapse_small"
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit_off")
    inst.AnimState:PushAnimation("off", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/fan/hit")
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
    inst.AnimState:PlayAnimation("activate")
	inst.AnimState:PushAnimation("idle_loop", true)
	-- inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/fan/place")
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/fan/on_LP", "firesuppressor_idle")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_basefan.tex")

    inst.AnimState:SetBank("basefan")
    inst.AnimState:SetBuild("basefan")
    inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/fan/on_LP", "firesuppressor_idle")
	
	MakeObstaclePhysics(inst, .2)

	inst:AddTag("structure")
	inst:AddTag("basefan")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(2)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
    return inst
end

return Prefab("sap_basefan", fn, assets, prefabs),
MakePlacer("sap_basefan_placer", "basefan", "basefan", "off")
