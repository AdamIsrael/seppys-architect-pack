require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/topiary.zip"),
    Asset("ANIM", "anim/topiary01_build.zip"),    
    Asset("ANIM", "anim/topiary02_build.zip"),    
    Asset("ANIM", "anim/topiary03_build.zip"),    
    Asset("ANIM", "anim/topiary04_build.zip"),    
    Asset("ANIM", "anim/topiary05_build.zip"),    
    Asset("ANIM", "anim/topiary06_build.zip"),    
    Asset("ANIM", "anim/topiary07_build.zip"),   
}

local prefabs =
{
	"collapse_small"
}

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_straw")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("idle", false)
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")
end

local function onsave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end
end

local function onload(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
	end
end

local function makeitem(name, frame)
	local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_lawnornament_"..frame..".tex")
	
	inst.AnimState:SetBank("topiary")
	inst.AnimState:SetBuild("topiary0".. frame .."_build")
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("SNOW") 
	
	MakeObstaclePhysics(inst, .5)
	
	inst:AddTag("structure")
	inst:AddTag("lawnornament")
	inst:AddTag("rotatableobject")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(2)
   
	MakeSmallBurnable(inst, nil, nil, true)
	MakeSmallPropagator(inst)
   
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload
	return inst
end
	return Prefab( name, fn, assets, prefabs)
end

local function ornamentplacetestfn(inst)    
    inst.AnimState:Hide("SNOW")
    return true
end

return makeitem("sap_lawnornament_1", "1"),
makeitem("sap_lawnornament_2", "2"),
makeitem("sap_lawnornament_3", "3"),
makeitem("sap_lawnornament_4", "4"),
makeitem("sap_lawnornament_5", "5"),
makeitem("sap_lawnornament_6", "6"),
makeitem("sap_lawnornament_7", "7"),
MakePlacer("sap_lawnornament_1_placer", "topiary", "topiary01_build", "idle", false, nil, nil, nil, nil, nil, ornamentplacetestfn),
MakePlacer("sap_lawnornament_2_placer", "topiary", "topiary02_build", "idle", false, nil, nil, nil, nil, nil, ornamentplacetestfn),
MakePlacer("sap_lawnornament_3_placer", "topiary", "topiary03_build", "idle", false, nil, nil, nil, nil, nil, ornamentplacetestfn),
MakePlacer("sap_lawnornament_4_placer", "topiary", "topiary04_build", "idle", false, nil, nil, nil, nil, nil, ornamentplacetestfn),
MakePlacer("sap_lawnornament_5_placer", "topiary", "topiary05_build", "idle", false, nil, nil, nil, nil, nil, ornamentplacetestfn),
MakePlacer("sap_lawnornament_6_placer", "topiary", "topiary06_build", "idle", false, nil, nil, nil, nil, nil, ornamentplacetestfn),
MakePlacer("sap_lawnornament_7_placer", "topiary", "topiary07_build", "idle", false, nil, nil, nil, nil, nil, ornamentplacetestfn)
