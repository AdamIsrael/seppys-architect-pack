local assets =
{
    Asset("ANIM", "anim/kyno_mudclod.zip"),
}

local prefabs =
{
    "cutreeds",
	"cutgrass",
	"twigs",
}

local function dig_up(inst, chopper)
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_mudclod.tex")

    inst.AnimState:SetBank("kyno_mudclod")
    inst.AnimState:SetBuild("kyno_mudclod")
    inst.AnimState:PlayAnimation("idle", true)
	
	inst:AddTag("plant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.AnimState:SetTime(math.random() * 2)
    local color = 0.75 + math.random() * 0.25
    inst.AnimState:SetMultColour(color, color, color, 1)

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnFinishCallback(dig_up)
	inst.components.workable:SetWorkLeft(1)

    MakeSmallBurnable(inst, TUNING.SMALL_FUEL)
    MakeSmallPropagator(inst)
    MakeHauntableIgnite(inst)

    return inst
end

return Prefab("sap_mudclod", fn, assets, prefabs),
MakePlacer("sap_mudclod_placer", "kyno_mudclod", "kyno_mudclod", "idle")