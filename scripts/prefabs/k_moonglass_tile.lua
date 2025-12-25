require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/moonglass_charged_tile.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onwork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE*(1/3) then
		inst.AnimState:PlayAnimation("centre_idle3")
	elseif workleft < TUNING.ROCKS_MINE*(2/3) then
		inst.AnimState:PlayAnimation("centre_idle2")
	else
		inst.AnimState:PlayAnimation("centre_idle1")
	end
end

local function onfinish(inst, worker)
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst.components.lootdropper:DropLoot()
	inst:Remove()
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("moonglass_charged")
    inst.AnimState:SetBuild("moonglass_charged_tile")
    inst.AnimState:PlayAnimation("spawn")
    inst.AnimState:PushAnimation("idle1_loop", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)

    inst:AddTag("NOBLOCK")
	inst:AddTag("FX")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
    return inst
end

local function fn2()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("moonglass_charged")
    inst.AnimState:SetBuild("moonglass_charged_tile")
	inst.AnimState:PlayAnimation("centre_idle1")
	
	inst:AddTag("structure")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
	inst.fxprefab =  SpawnPrefab("kyno_moonglass_tile_fx")
	inst.fxprefab.entity:SetParent(inst.entity)
	end
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "MOONSTORM_GLASS"
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnWorkCallback(onwork)
	inst.components.workable:SetOnFinishCallback(onfinish)
	
	inst:DoTaskInTime(FRAMES * 1, createExtras)
	
	return inst
end

return Prefab("kyno_moonglass_tile_fx", fn, assets),
Prefab("kyno_moonglass_tile", fn2, assets),
MakePlacer("kyno_moonglass_tile_placer", "moonglass_charged", "moonglass_charged_tile", "idle1_loop", true)