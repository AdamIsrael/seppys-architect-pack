require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/sculpture_pieces.zip"),
	Asset("ANIM", "anim/swap_sculpture_knighthead.zip"),
	Asset("ANIM", "anim/swap_sculpture_bishophead.zip"),
	Asset("ANIM", "anim/swap_sculpture_rooknose.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("anim")
    inst.AnimState:PushAnimation("anim")
end

local function onbuilt(inst)
    inst.AnimState:PushAnimation("anim")
end

local function makepiece(name)
    local assets =
    {
        Asset("ANIM", "anim/sculpture_pieces.zip"),
        Asset("ANIM", "anim/swap_sculpture_"..name..".zip"),
		
		Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
		Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	}
	
	local prefabs =
	{
		"marble",
	}
	
	local function fn()
		local inst = CreateEntity()
	
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()
	
		MakeObstaclePhysics(inst, .1)
	
		inst.AnimState:SetBank("sculpture_pieces")
		inst.AnimState:SetBuild("swap_sculpture_"..name)
		inst.AnimState:PlayAnimation("anim")
    
		inst:AddTag("structure")
		inst:AddTag("sculpture_pieces")
		inst:AddTag("heavy")
	
		inst.entity:SetPristine()
	
		if not TheWorld.ismastersim then
			return inst
		end
	
		inst:AddComponent("lootdropper")
		inst:AddComponent("inspectable")
	
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(2)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)
	
		inst:ListenForEvent("onbuilt", onbuilt)
	
		MakeHauntableWork(inst)
		
		return inst
    end
	
	return Prefab("kyno_sculpture_"..name, fn, assets, prefabs)
end

return makepiece("knighthead"),
makepiece("bishophead"),
makepiece("rooknose"),
MakePlacer("kyno_knighthead_placer", "sculpture_pieces", "swap_sculpture_knighthead", "anim"),
MakePlacer("kyno_bishophead_placer", "sculpture_pieces", "swap_sculpture_bishophead", "anim"),
MakePlacer("kyno_rooknose_placer", "sculpture_pieces", "swap_sculpture_rooknose", "anim")