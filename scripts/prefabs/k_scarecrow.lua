require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_scarecrow.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("idle")
end

local function rename(inst)
    inst.components.named:PickNewName()
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
    MakeObstaclePhysics(inst, .5)
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_scarecrow.tex")
	
    inst.AnimState:SetBank("kyno_scarecrow")
    inst.AnimState:SetBuild("kyno_scarecrow")
    inst.AnimState:PlayAnimation("idle")
    
	inst:AddTag("structure")
	inst:AddTag("scarecrow")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "SCARECROW"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("named")
    inst.components.named.possiblenames = { "Fiddlesticks", "Legacy Scarecrow", "reD The Scarecrow", "Thalz The Scarecrow", "Helicalpuma The Legend" }
    inst.components.named:PickNewName()
    inst:DoPeriodicTask(5, rename)
	
	inst:ListenForEvent("onbuilt", onbuilt)
	
	MakeHauntableWork(inst)
	
    return inst
end

return Prefab("sap_scarecrow", fn, assets),
MakePlacer("sap_scarecrow_placer", "kyno_scarecrow", "kyno_scarecrow", "idle")