require "prefabutil"

local prefabs =
{
	"collapse_small"
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

local PHYSICS_RADIUS = .1

local function makepiece(name)
    local assets =
    {
        Asset("ANIM", "anim/moon_altar_pieces.zip"),
        Asset("ANIM", "anim/swap_altar_"..name.."piece.zip"),
		
		Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
		Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	}
	
	local piece_prefabs =
	{
		"moonrocknugget",
	}

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

		local minimap = inst.entity:AddMiniMapEntity()
		minimap:SetIcon("moon_altar_"..name.."_piece.png")

        MakeSmallHeavyObstaclePhysics(inst, PHYSICS_RADIUS)
        inst:SetPhysicsRadiusOverride(PHYSICS_RADIUS)

        inst.AnimState:SetBank("moon_altar_pieces")
        inst.AnimState:SetBuild("swap_altar_"..name.."piece")
        inst.AnimState:PlayAnimation("anim")

        inst:AddTag("structure")
		inst:AddTag("celestial_pieces")
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
	
	return Prefab("kyno_altar_"..name, fn, assets, piece_prefabs)
end

return makepiece("idol"),
makepiece("glass", "moon_altar"),
makepiece("seed"),	
makepiece("crown", "moon_altar_cosmic"),
makepiece("ward"),
makepiece("icon", "moon_altar_astral"),
MakePlacer("kyno_altar_idol_placer", "moon_altar_pieces", "swap_altar_idolpiece", "anim"),
MakePlacer("kyno_altar_glass_placer", "moon_altar_pieces", "swap_altar_glasspiece", "anim"),
MakePlacer("kyno_altar_seed_placer", "moon_altar_pieces", "swap_altar_seedpiece", "anim"),
MakePlacer("kyno_altar_crown_placer", "moon_altar_pieces", "swap_altar_crownpiece", "anim"),
MakePlacer("kyno_altar_ward_placer", "moon_altar_pieces", "swap_altar_wardpiece", "anim"),
MakePlacer("kyno_altar_icon_placer", "moon_altar_pieces", "swap_altar_iconpiece", "anim")