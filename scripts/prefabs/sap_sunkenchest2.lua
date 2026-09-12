require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/kyno_sunkchest.zip"),
	Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
}

local prefabs =
{
	"chestupgrade_stacksize_fx",
	"collapse_small"
}

local function onopen(inst) 
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("open")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/cork_chest/open")
	end
end

local function onclose(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("close")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/cork_chest/close")
	end
end

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
	inst.components.lootdropper:DropLoot()
	if inst.components.container then inst.components.container:DropEverything() end
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("closed", true)
		if inst.components.container then 
			inst.components.container:DropEverything() 
			inst.components.container:Close()
		end
	end
end

local function onbuilt(inst)
	-- inst.AnimState:PlayAnimation("unlock")
	inst.AnimState:PushAnimation("closed", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/cork_chest/place")
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


local function GetStatus(inst, viewer)
    if inst._chestupgrade_stacksize then
        return "UPGRADED_STACKSIZE"
    end

    return "GENERIC"
end

local function OnUpgrade(inst, performer, upgraded_from_item)
    local numupgrades = inst.components.upgradeable.numupgrades
	
    if numupgrades == 1 then
        inst._chestupgrade_stacksize = true
		
        if inst.components.container ~= nil then
            inst.components.container:Close()
            inst.components.container:EnableInfiniteStackSize(true)
            inst.components.inspectable.getstatus = GetStatus
        end
		
        if upgraded_from_item then
            local x, y, z = inst.Transform:GetWorldPosition()
            local fx = SpawnPrefab("chestupgrade_stacksize_fx")
            fx.Transform:SetPosition(x, y, z)
        end
    end
	
    inst.components.upgradeable.upgradetype = nil
	
	if inst.components.lootdropper ~= nil then
        inst.components.lootdropper:SetLoot({"alterguardianhatshard"})
    end
end

local function OnLoadPostPass(inst, newents, data)
    if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
        OnUpgrade(inst)
    end
end

local function OnDecontructStructure(inst, caster)
    if inst.components.upgradeable ~= nil and inst.components.upgradeable.numupgrades > 0 then
        if inst.components.lootdropper ~= nil then
            inst.components.lootdropper:SpawnLootPrefab("alterguardianhatshard")
        end
    end
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	MakeObstaclePhysics(inst, .45)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_sunkchest.tex")
	
	inst.AnimState:SetBank("sunken_treasurechest")
	inst.AnimState:SetBuild("kyno_sunkchest")
	inst.AnimState:PlayAnimation("closed", true)
	
	inst:AddTag("structure")
	inst:AddTag("sunk_chest")
	inst:AddTag("chest")
	
	inst:SetPrefabNameOverride("sunkenchest")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("dragonflychest") end
        return inst
    end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("container")
    inst.components.container:WidgetSetup("dragonflychest")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("upgradeable")
	inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
	inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)
   
	inst:ListenForEvent("onbuilt", onbuilt)
	inst:ListenForEvent("ondeconstructstructure", OnDecontructStructure)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload
	inst.OnLoadPostPass = OnLoadPostPass

	return inst
end

local function sunkchestplacerfn(inst)
	inst.AnimState:Hide("chain01")
	inst.AnimState:Hide("chain02")
	inst.AnimState:Hide("chain03")
	inst.AnimState:Hide("chain03_0")
	inst.AnimState:Hide("chain03_1")
	inst.AnimState:Hide("lock")
end

return Prefab("sap_sunkchest", fn, assets, prefabs),
MakePlacer("sap_sunkchest_placer", "sunken_treasurechest", "sap_sunkchest", "closed")
