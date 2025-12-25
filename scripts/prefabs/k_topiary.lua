require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/topiary.zip"),
    Asset("ANIM", "anim/topiary_pigman_build.zip"),
    Asset("ANIM", "anim/topiary_werepig_build.zip"),
    Asset("ANIM", "anim/topiary_beefalo_build.zip"),
    Asset("ANIM", "anim/topiary_pigking_build.zip"), 
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
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

local function makeitem(name, build, frame)
	local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	inst.Transform:SetTwoFaced()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_topiary_".. frame ..".tex")
	
	inst.AnimState:SetBank("topiary")
	inst.AnimState:SetBuild(build)
	inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("SNOW") 
	
	MakeObstaclePhysics(inst, .5)
	
	inst:AddTag("structure")
	inst:AddTag("lawnornament")
	inst:AddTag("topiary")
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

return makeitem("kyno_topiary_1", "topiary_pigman_build", "1"),
makeitem("kyno_topiary_2", "topiary_werepig_build", "2"),
makeitem("kyno_topiary_3", "topiary_beefalo_build", "3"),
makeitem("kyno_topiary_4", "topiary_pigking_build", "4"),     
MakePlacer("kyno_topiary_1_placer", "topiary", "topiary_pigman_build", "idle", false, nil, nil, nil, nil, nil, ornamentplacetestfn),
MakePlacer("kyno_topiary_2_placer", "topiary", "topiary_werepig_build", "idle", false, nil, nil, nil, nil, nil, ornamentplacetestfn),
MakePlacer("kyno_topiary_3_placer", "topiary", "topiary_beefalo_build", "idle", false, nil, nil, nil, nil, nil, ornamentplacetestfn),
MakePlacer("kyno_topiary_4_placer", "topiary", "topiary_pigking_build", "idle", false, nil, nil, nil, nil, nil, ornamentplacetestfn)