require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/dung_pile.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local prefabs =
{
	"flies",
}

local anims = {"idle_low", "idle_med", "idle_full"}

local function dig_up(inst, worker, workleft)
    print("workleft", workleft)

    if workleft == 0 then
        local pt = Vector3(inst.Transform:GetWorldPosition())
        local hispos = Vector3(worker.Transform:GetWorldPosition())

        local he_right = ((hispos - pt):Dot(TheCamera:GetRightVec()) > 0)
        
        if he_right then
            inst.components.lootdropper:DropLoot(pt - (TheCamera:GetRightVec()*(.5+math.random())))
        else
            inst.components.lootdropper:DropLoot(pt + (TheCamera:GetRightVec()*(.5+math.random())))
        end
        inst:Remove()
		inst.SoundEmitter:PlaySound("dontstarve/common/food_rot")
		if inst.flies ~= nil then
        inst.flies:Remove()
		end
    else
        print("PlayAnimation", workleft, anims[workleft])
        inst.AnimState:PlayAnimation(anims[workleft])
		inst.SoundEmitter:PlaySound("dontstarve/common/food_rot")
    end
end

local function onbuilt(inst)
	if inst.flies == nil then
        inst.flies = inst:SpawnChild("flies")
    end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_dungpile.tex")
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("dung_pile")
	inst.AnimState:SetBuild("dung_pile")
	inst.AnimState:PlayAnimation(anims[#anims])
	
	inst:AddTag("structure")
	inst:AddTag("dungpile")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.flies = inst:SpawnChild("flies")
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("lootdropper")
    
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.DIG)
	inst.components.workable:SetOnWorkCallback(dig_up)
	inst.components.workable:SetWorkLeft(#anims)
	
	return inst
end

return Prefab("kyno_dungpile", fn, assets, prefabs),
MakePlacer("kyno_dungpile_placer", "dung_pile", "dung_pile", "idle_full")