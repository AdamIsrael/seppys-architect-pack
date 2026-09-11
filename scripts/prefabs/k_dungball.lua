require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/dungball_build.zip"),   
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs =
{
	"flies",
}

local function dig_up(inst, chopper)
	inst.components.lootdropper:SpawnLootPrefab("poop")
	inst.components.lootdropper:SpawnLootPrefab("poop")
	inst.components.lootdropper:SpawnLootPrefab("twigs")
	inst.components.lootdropper:SpawnLootPrefab("twigs")
	inst:Remove()
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/creatures/dungbeetle/dungball_break")
	if inst.flies ~= nil then
        inst.flies:Remove()
	end 
end

local function onbuilt(inst)
	inst.AnimState:PushAnimation("idle")
	if inst.flies == nil then
        inst.flies = inst:SpawnChild("flies")
    end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddDynamicShadow()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	inst.Transform:SetFourFaced()
    inst.DynamicShadow:SetSize(1.7, .8)
	
	inst.AnimState:SetBank("tumbleweed")
	inst.AnimState:SetBuild("dungball_build")
	inst.AnimState:PlayAnimation("idle", true)
	
	MakeObstaclePhysics(inst, 1)
	
	inst:AddTag("dungball")
	inst:AddTag("structure")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst.flies = inst:SpawnChild("flies")
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

	inst:ListenForEvent("onbuilt", onbuilt)

	return inst
end

return Prefab("sap_dungball", fn, assets, prefabs),
MakePlacer("sap_dungball_placer", "tumbleweed", "dungball_build", "idle")