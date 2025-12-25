require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/porkalypse_clock_01.zip"),
	Asset("ANIM", "anim/porkalypse_clock_02.zip"),
	Asset("ANIM", "anim/porkalypse_clock_03.zip"),
	Asset("ANIM", "anim/porkalypse_clock_marker.zip"),
	Asset("ANIM", "anim/porkalypse_totem.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),

	Asset("SOUNDPACKAGE", "sound/dontstarve_DLC003.fev"),
	Asset("SOUND", "sound/DLC003_sfx.fsb"),
}

local prefabs =
{
	"kyno_aporkalypse_clock1",
	"kyno_aporkalypse_clock2",
	"kyno_aporkalypse_clock3",
}

local function OnNight(inst, isnight)
	if isnight then
		inst.AnimState:PlayAnimation("idle_pre")
		inst.AnimState:PushAnimation("idle_on", true)
		inst:DoTaskInTime(1/30, function()
		inst.SoundEmitter:KillSound("base_sound")
		inst.SoundEmitter:KillSound("totem_sound")
		end)
	end
end

local function OnNightFX(inst, isnight)
	if isnight then
		inst.AnimState:PlayAnimation("on_shake")
		inst.AnimState:PushAnimation("on_idle", true)
	end
end

local function OnDay(inst, isday)
	if isday then
		inst.AnimState:PlayAnimation("idle_pst")
		inst.AnimState:PushAnimation("idle_loop", true)
	end
end

local function onnear(inst, isday)
	if isday then
		inst:DoTaskInTime(1/30, function()
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/aporkalypse_clock/totem_LP", "totem_sound")
		inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/aporkalypse_clock/base_LP", "base_sound")
		end)
	end
end

local function onfar(inst)
	inst:DoTaskInTime(1/30, function()
	inst.SoundEmitter:KillSound("base_sound")
	inst.SoundEmitter:KillSound("totem_sound")
	end)
end

local function OnDayFX(inst, isday)
	if isday then
		inst.AnimState:PlayAnimation("off_shake")
		inst.AnimState:PushAnimation("off_idle", true)
	end
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("idle_off")
	inst.AnimState:PushAnimation("idle_off", false)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_aporkalypse_clock.tex")
	
	MakeObstaclePhysics(inst, 1)
	
	inst.AnimState:SetBank("totem")
	inst.AnimState:SetBuild("porkalypse_totem")
	inst.AnimState:PlayAnimation("idle_loop", true)
	
	inst:AddTag("structure")
	inst:AddTag("kynoclock")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createExtras(inst)
		inst.clockprefab1 = SpawnPrefab("kyno_aporkalypse_clock1")
		inst.clockprefab2 = SpawnPrefab("kyno_aporkalypse_clock2")
		inst.clockprefab3 = SpawnPrefab("kyno_aporkalypse_clock3")
	
		inst.clockprefab1.entity:SetParent(inst.entity)
		inst.clockprefab2.entity:SetParent(inst.entity)
		inst.clockprefab3.entity:SetParent(inst.entity)
	end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("savedrotation")
	
	inst:DoTaskInTime(FRAMES * 1, createExtras)
	
	inst:WatchWorldState("isday", OnDay)
    OnDay(inst, TheWorld.state.isday)

    inst:WatchWorldState("isnight", OnNight)
    OnNight(inst, TheWorld.state.isnight)

	return inst
end

local function clockfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    inst.AnimState:SetBank("clock_01")
    inst.AnimState:SetBuild("porkalypse_clock_01")
    inst.AnimState:PlayAnimation("off_idle")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetSortOrder(1)
	
	inst.persists = false

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
    inst:AddTag("structure")
	inst:AddTag("kynoclock_01")
	inst:AddTag("NOCLICK")
	
	inst:AddComponent("savedrotation")
	
	inst:WatchWorldState("isday", OnDayFX)
    OnDayFX(inst, TheWorld.state.isday)

    inst:WatchWorldState("isnight", OnNightFX)
    OnNightFX(inst, TheWorld.state.isnight)
   
    return inst
end

local function clock2fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    inst.AnimState:SetBank("clock_02")
    inst.AnimState:SetBuild("porkalypse_clock_02")
    inst.AnimState:PlayAnimation("off_idle")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetSortOrder(2)
	
	inst:AddTag("structure")
	inst:AddTag("kynoclock_02")
	inst:AddTag("NOCLICK")
	
	inst.persists = false

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")
	
	inst:WatchWorldState("isday", OnDayFX)
    OnDayFX(inst, TheWorld.state.isday)

    inst:WatchWorldState("isnight", OnNightFX)
    OnNightFX(inst, TheWorld.state.isnight)
   
    return inst
end

local function clock3fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    inst.AnimState:SetBank("clock_03")
    inst.AnimState:SetBuild("porkalypse_clock_03")
    inst.AnimState:PlayAnimation("off_idle")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("kynoclock_03")
	inst:AddTag("NOCLICK")
	
	inst.persists = false

	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("savedrotation")
	
	inst:WatchWorldState("isday", OnDayFX)
    OnDayFX(inst, TheWorld.state.isday)

    inst:WatchWorldState("isnight", OnNightFX)
    OnNightFX(inst, TheWorld.state.isnight)
   
    return inst
end

local PS = 1
local function calendarplacerfn(inst)
    local placer2 = CreateEntity()

    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    local s = 1 / PS
    placer2.Transform:SetScale(s, s, s)

    placer2.AnimState:SetBank("totem")
    placer2.AnimState:SetBuild("porkalypse_totem")
    placer2.AnimState:PlayAnimation("idle_loop", true)
    placer2.AnimState:SetLightOverride(1)
	
    placer2.entity:SetParent(inst.entity)
    inst.components.placer:LinkEntity(placer2)
	
	local placer3 = CreateEntity()

    placer3.entity:SetCanSleep(false)
    placer3.persists = false

    placer3.entity:AddTransform()
    placer3.entity:AddAnimState()

    placer3:AddTag("CLASSIFIED")
    placer3:AddTag("NOCLICK")
    placer3:AddTag("placer")

    local s = 1 / PS
    placer3.Transform:SetScale(s, s, s)

    placer3.AnimState:SetBank("clock_02")
    placer3.AnimState:SetBuild("porkalypse_clock_02")
    placer3.AnimState:PlayAnimation("off_idle")
	placer3.AnimState:SetLayer(LAYER_BACKGROUND)
	placer3.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    placer3.AnimState:SetSortOrder(2)
    placer3.AnimState:SetLightOverride(1)
	
    placer3.entity:SetParent(inst.entity)
    inst.components.placer:LinkEntity(placer3)
	
	local placer4 = CreateEntity()

    placer4.entity:SetCanSleep(false)
    placer4.persists = false

    placer4.entity:AddTransform()
    placer4.entity:AddAnimState()

    placer4:AddTag("CLASSIFIED")
    placer4:AddTag("NOCLICK")
    placer4:AddTag("placer")

    local s = 1 / PS
    placer4.Transform:SetScale(s, s, s)

    placer4.AnimState:SetBank("clock_01")
    placer4.AnimState:SetBuild("porkalypse_clock_01")
    placer4.AnimState:PlayAnimation("off_idle")
	placer4.AnimState:SetLayer(LAYER_BACKGROUND)
	placer4.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    placer4.AnimState:SetSortOrder(1)
    placer4.AnimState:SetLightOverride(1)
	
    placer4.entity:SetParent(inst.entity)
    inst.components.placer:LinkEntity(placer4)
end

return Prefab("kyno_aporkalypse_calendar", fn, assets, prefabs),
Prefab("kyno_aporkalypse_clock1", clockfn, assets, prefabs),
Prefab("kyno_aporkalypse_clock2", clock2fn, assets, prefabs),
Prefab("kyno_aporkalypse_clock3", clock3fn, assets, prefabs),
MakePlacer("kyno_aporkalypse_calendar_placer", "clock_03", "porkalypse_clock_03", "off_idle", true, nil, nil, PS, 90, nil, calendarplacerfn)