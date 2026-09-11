require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/pandoras_chest.zip"),
	Asset("ANIM", "anim/pandoras_chest_large.zip"),
	Asset("ANIM", "anim/ui_chest_3x2.zip"),
	Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
}

local prefabs =
{
	"chestupgrade_stacksize_fx",
	"collapse_small"
}

local function OnBurnt(inst)	
	inst.components.upgradeable.upgradetype = nil
    inst.components.inspectable.getstatus = nil
	
	inst:DoTaskInTime(1.2, inst.Remove)
end

local function onopen(inst) 
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("open")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	end
end

local function onclose(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("close")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
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
	inst.AnimState:PlayAnimation("close")
	inst.AnimState:PushAnimation("closed", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/chest_craft")
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

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("pandoraschest.png")
	
	inst.AnimState:SetBank("pandoras_chest")
	inst.AnimState:SetBuild("pandoras_chest")
	inst.AnimState:PlayAnimation("closed", true)
	
	inst:AddTag("structure")
	inst:AddTag("ruinschest")
	inst:AddTag("chest")
	
	inst:SetPrefabNameOverride("pandoraschest")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("treasurechest") end
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("container")
    inst.components.container:WidgetSetup("treasurechest")
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(2)
	
	inst:AddComponent("upgradeable")
	inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
	inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)
   
	inst:ListenForEvent("onbuilt", onbuilt)
	inst:ListenForEvent("onburnt", OnBurnt)
	inst:ListenForEvent("ondeconstructstructure", OnDecontructStructure)
	
	MakeMediumBurnable(inst, nil, nil, true)
	inst.components.burnable.onburnt = OnBurnt
    MakeLargePropagator(inst)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload
	inst.OnLoadPostPass = OnLoadPostPass

	return inst
end

local function largefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("pandoraschest.png")
	
	inst.AnimState:SetBank("pandoras_chest_large")
	inst.AnimState:SetBuild("pandoras_chest_large")
	inst.AnimState:PlayAnimation("closed", true)
	
	inst:AddTag("structure")
	inst:AddTag("ruinschest")
	inst:AddTag("chest")
	
	inst:SetPrefabNameOverride("minotaurchest")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("dragonflychest") end
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	inst:AddComponent("container")
    inst.components.container:WidgetSetup("dragonflychest")

    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("upgradeable")
	inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
	inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)
	
	-- MakeMediumBurnable(inst, nil, nil, true)
    -- MakeLargePropagator(inst)
   
	inst:ListenForEvent("onbuilt", onbuilt)
	inst:ListenForEvent("ondeconstructstructure", OnDecontructStructure)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload
	inst.OnLoadPostPass = OnLoadPostPass

	return inst
end

return Prefab("sap_ornatechest", fn, assets, prefabs),
Prefab("sap_ornatechest_large", largefn, assets, prefabs),
MakePlacer("sap_ornatechest_placer", "pandoras_chest", "pandoras_chest", "closed"),
MakePlacer("sap_ornatechest_large_placer", "pandoras_chest_large", "pandoras_chest_large", "closed")
