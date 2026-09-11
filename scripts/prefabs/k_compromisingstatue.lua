require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/nosweatresurrectionstone.zip"),
}

local prefabs =
{
	"sap_compromisingstatue_broken",
}

local COOLDOWN = 20 
local TIMEOUT = 10 
local CHANGED_CANT_TAGS = {"FX", "NOCLICK", "DECOR", "INLIMBO", "playerghost", "ghost", "flying"}

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	SpawnPrefab("sap_compromisingstatue_broken").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	
	inst:Remove()
end

local function OnHammeredBroken(inst, worker)
	inst.components.lootdropper:DropLoot()
	
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	
	inst:Remove()
end

local function OnTimeout(inst)
    inst._task = nil
	
    if inst.AnimState:IsCurrentAnimation("idle_broken") or
        inst.AnimState:IsCurrentAnimation("idle_broken") then
        inst.AnimState:PlayAnimation("repair")
        inst.AnimState:PushAnimation("idle_activate", false)
        
		inst.SoundEmitter:PlaySound("dontstarve/common/resurrectionstone_activate")
    end
end

local function OnHaunt(inst, haunter)
    if inst._task == nil and haunter:CanUseTouchStone(inst) and inst.AnimState:IsCurrentAnimation("idle_activate") then
        inst.AnimState:PlayAnimation("idle_activate")
        inst.AnimState:PushAnimation("idle_broken", false)
		
        inst.SoundEmitter:PlaySound("dontstarve/common/resurrectionstone_break")
        inst._task = inst:DoTaskInTime(TIMEOUT, OnTimeout)
		
        return true
    end
end

local function OnStartCharging(inst)
    if not inst.AnimState:IsCurrentAnimation("idle_broken") then
        inst.AnimState:PlayAnimation("idle_brokenf", false)
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)

        inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
        inst.Physics:ClearCollisionMask()
        inst.Physics:CollidesWith(COLLISION.WORLD)
        inst.Physics:CollidesWith(COLLISION.ITEMS)

        if inst.components.hauntable ~= nil then
            inst:RemoveComponent("hauntable")
        end
    end
end

local function HasPhysics(obj)
    return obj.Physics ~= nil
end

local function OnCharged(inst)
    if inst.AnimState:IsCurrentAnimation("idle_broken") then
        local x, y, z = inst.Transform:GetWorldPosition()
        if FindEntity(inst, inst:GetPhysicsRadius(0), HasPhysics, nil, { "FX", "NOCLICK", "DECOR", "INLIMBO", "playerghost", "ghost", "flying" }) ~= nil then
            inst.components.cooldown:StartCharging(math.random(5, 8))
            return
        end

        inst.AnimState:PlayAnimation("activate")
        inst.AnimState:PushAnimation("idle_activate", false)
        inst.AnimState:SetLayer(LAYER_WORLD)
        inst.AnimState:SetSortOrder(0)
		
        inst.Physics:CollidesWith(COLLISION.CHARACTERS)
		
        inst.SoundEmitter:PlaySound("dontstarve/common/resurrectionstone_activate")
    end
end

local function OnAnimOver(inst)
    if inst.components.hauntable == nil and inst.AnimState:IsCurrentAnimation("idle_activate") then
        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
        inst.components.hauntable:SetOnHauntFn(OnHaunt)
    end
end

local function OnActivateResurrection(inst, guy)
    if inst._task ~= nil then
        inst._task:Cancel()
        inst._task = nil
    end
	
    TheWorld:PushEvent("ms_sendlightningstrike", inst:GetPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/resurrectionstone_break")
	
	inst.components.cooldown:StartCharging()
	
    guy:PushEvent("usedtouchstone", inst)
end

local NEXT_ID = 1
local USED_IDS = {}

local function SetTouchStoneID(inst, id)
    if id > 0 then
        if USED_IDS[id] then
            print("Duplicate Touch Stone ID: "..tostring(id))
        end
		
        inst._touchstoneid:set(id)
        USED_IDS[id] = true
    end
end

local function GetTouchStoneID(inst)
    return inst._touchstoneid:value()
end

local function OnSave(inst, data)
    data.touchstoneid = inst._touchstoneid:value()
end

local function OnLoad(inst, data)
    if data ~= nil and data.touchstoneid ~= nil then
        SetTouchStoneID(inst, data.touchstoneid)
    end
end

local function OnInit(inst)
    if TheWorld.ismastersim then
        if inst._touchstoneid:value() <= 0 then
            while USED_IDS[NEXT_ID] do
                NEXT_ID = NEXT_ID + 1
            end

            if NEXT_ID < 64 then
                SetTouchStoneID(inst, NEXT_ID)
                NEXT_ID = NEXT_ID + 1
            else
                print("Too many touchstones!")
            end
        end
    end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("repair")
	inst.AnimState:PushAnimation("idle_activate")
end

local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_compromisingstatue.tex")
	
    MakeObstaclePhysics(inst, .5)
	
	inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	
    inst.AnimState:SetBank("nosweatresurrectionstone")
    inst.AnimState:SetBuild("nosweatresurrectionstone")
    inst.AnimState:PlayAnimation("idle_activate", false)
    
	inst:AddTag("structure")
	inst:AddTag("nosweatresurrectionstone")
	inst:AddTag("antlion_sinkhole_blocker")
	inst:AddTag("resurrector")
	
	inst._touchstoneid = net_smallbyte(inst.GUID, "resurrectionstone._touchstoneid")
    inst.GetTouchStoneID = GetTouchStoneID
	
	inst.entity:SetPristine()
	
	inst:DoTaskInTime(0, OnInit)
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	
	inst:AddComponent("cooldown")
    inst.components.cooldown.cooldown_duration = COOLDOWN
    inst.components.cooldown.onchargedfn = OnCharged
    inst.components.cooldown.startchargingfn = OnStartCharging
    inst.components.cooldown.charged = true
	
	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    inst._task = nil
	
	inst.OnSave = OnSave
    inst.OnLoad = OnLoad

	inst:ListenForEvent("onbuilt", OnBuilt)
    inst:ListenForEvent("animover", OnAnimOver)
    inst:ListenForEvent("activateresurrection", OnActivateResurrection)
	
    return inst
end

local function brokenfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("kyno_compromisingstatue.tex")
	
    MakeObstaclePhysics(inst, .5)
	
	inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
	
    inst.AnimState:SetBank("nosweatresurrectionstone")
    inst.AnimState:SetBuild("nosweatresurrectionstone")
    inst.AnimState:PlayAnimation("idle_broken", false)
    
	inst:AddTag("structure")
	inst:AddTag("antlion_sinkhole_blocker")
	
	inst:SetPrefabNameOverride("sap_compromisingstatue")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "KYNO_COMPROMISINGSTATUE"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(1)
	inst.components.workable:SetOnFinishCallback(OnHammeredBroken)
	
    return inst
end

return Prefab("sap_compromisingstatue", fn, assets, prefabs),
Prefab("sap_compromisingstatue_broken", brokenfn, assets, prefabs),
MakePlacer("sap_compromisingstatue_placer", "nosweatresurrectionstone", "nosweatresurrectionstone", "idle_activate")