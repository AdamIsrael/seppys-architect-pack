require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/treasure_chest_roottrunk.zip"),	
	Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
	
	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs =
{
	"chestupgrade_stacksize_fx",
	"collapse_small"
}

local function OnOpen(inst) 
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("open")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/root_trunk/open")
	end
end

local function OnClose(inst)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("close")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/root_trunk/open")
	end
end

local function OnHammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
	
	inst.components.lootdropper:DropLoot()
	
	if inst.components.container ~= nil then 
		inst.components.container:DropEverything() 
	end
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function OnHit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("hit")
		inst.AnimState:PushAnimation("closed", true)
	if inst.components.container then 
		inst.components.container:DropEverything() 
		inst.components.container:Close()
		end
	end
	if inst.components.container_proxy ~= nil then
		inst.components.container_proxy:Close()
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("close")
	inst.AnimState:PushAnimation("closed", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/crafted/root_trunk/place")
end	

local function OnSave(inst, data)
	if inst:HasTag("burnt") or inst:HasTag("fire") then
		data.burnt = true
	end
end

local function OnLoad(inst, data)
	if data and data.burnt then
		inst.components.burnable.onburnt(inst)
	end
end

local function AttachRootContainer(inst)
	inst.components.container_proxy:SetMaster(TheWorld:GetPocketDimensionContainer("roots"))
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
	minimap:SetIcon("kyno_roottrunk.tex")
	
	inst.AnimState:SetBank("roottrunk")
	inst.AnimState:SetBuild("treasure_chest_roottrunk")
	inst.AnimState:PlayAnimation("closed", true)
	
	inst:AddTag("structure")
	inst:AddTag("root_trunk")
	inst:AddTag("chest")
	
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
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
	inst.components.container.skipclosesnd = true
	inst.components.container.skipopensnd = true
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(2)
	
	inst:AddComponent("upgradeable")
	inst.components.upgradeable.upgradetype = UPGRADETYPES.CHEST
	inst.components.upgradeable:SetOnUpgradeFn(OnUpgrade)
	
	MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)
   
	inst:ListenForEvent("onbuilt", OnBuilt)
	inst:ListenForEvent("ondeconstructstructure", OnDecontructStructure)
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	inst.OnLoadPostPass = OnLoadPostPass
	
	return inst
end

local function truefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_roottrunk.tex")
	
	inst.AnimState:SetBank("roottrunk")
	inst.AnimState:SetBuild("treasure_chest_roottrunk")
	inst.AnimState:PlayAnimation("closed", true)
	
	inst:AddTag("structure")
	inst:AddTag("root_trunk")
	
	inst:AddComponent("container_proxy")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.components.container_proxy:SetOnOpenFn(OnOpen)
	inst.components.container_proxy:SetOnCloseFn(OnClose)
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	inst.components.workable:SetOnWorkCallback(OnHit)
	inst.components.workable:SetWorkLeft(2)
	
	MakeSnowCovered(inst, .01)
	
	MakeMediumBurnable(inst, nil, nil, true)
    MakeLargePropagator(inst)
   
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	inst.OnLoadPostPass = AttachRootContainer

	if not POPULATING then
		AttachRootContainer(inst)
	end
	
	return inst
end

return Prefab("sap_rootchest", fn, assets, prefabs),
Prefab("sap_truerootchest", truefn, assets, prefabs),
MakePlacer("sap_rootchest_placer", "roottrunk", "treasure_chest_roottrunk", "closed")
