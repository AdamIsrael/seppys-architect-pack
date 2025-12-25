require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/tornado_weather.zip"),
	Asset("ANIM", "anim/tornado_weather_base.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs = {
	"kyno_tornadohazard_base",
}

local PS = 1

local function RemoveBase(inst)
	inst.AnimState:PlayAnimation("tornado_base_pst")
	inst:ListenForEvent("animover", function() inst:Remove() end)
end

local function HealthChange(inst)
	if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("tornado_pst")
		inst.components.lootdropper:DropLoot()
		inst:ListenForEvent("animover", function() inst:Remove() end)
	end
end

local function OnLoad(inst)
    if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("tornado_pst")
		inst.components.lootdropper:DropLoot()
		inst:ListenForEvent("animover", function() inst:Remove() end)
	end
end

local function OnBuilt(inst)
	inst.AnimState:PlayAnimation("tornado_pre")
	inst.AnimState:PushAnimation("tornado_loop", true)
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("tornado_weather")
    inst.AnimState:SetBuild("tornado_weather")
    inst.AnimState:PlayAnimation("tornado_loop", true)
	
	inst:AddTag("structure")
	inst:AddTag("tornadohazard")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tornado", "spinLoop")
	
	local function CreateExtras(inst)
		inst.baseprefab = SpawnPrefab("kyno_tornadohazard_base")
		inst.baseprefab.entity:SetParent(inst.entity)
	end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(300)
	inst.components.health.ondelta = HealthChange
	inst.components.health.nofadeout = true
	inst.components.health.canheal = true
	
	inst.OnLoad = OnLoad
	
    inst:ListenForEvent("onbuilt", OnBuilt)
	inst:DoTaskInTime(FRAMES * 1, CreateExtras)
	
    return inst
end

local function basefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("tornado_base_fx")
    inst.AnimState:SetBuild("tornado_weather_base")
    inst.AnimState:PlayAnimation("tornado_base_pre")
	inst.AnimState:PlayAnimation("tornado_base_loop", true)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(3)
	
	inst.persists = false
	
	inst:AddTag("tornadohazardbase")
	inst:AddTag("NOCLICK")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:ListenForEvent("onremove", RemoveBase)
	
	return inst
end

local function tornadoplacerfn(inst)
	local placer2 = CreateEntity()

    placer2.entity:SetCanSleep(false)
    placer2.persists = false

    placer2.entity:AddTransform()
    placer2.entity:AddAnimState()

    placer2:AddTag("CLASSIFIED")
    placer2:AddTag("NOCLICK")
    placer2:AddTag("placer")

    local s = PS
    placer2.Transform:SetScale(s, s, s)

    placer2.AnimState:SetBank("tornado_weather")
    placer2.AnimState:SetBuild("tornado_weather")
    placer2.AnimState:PlayAnimation("tornado_loop", true)
    placer2.AnimState:SetLightOverride(1)
	
    placer2.entity:SetParent(inst.entity)
    inst.components.placer:LinkEntity(placer2)
end

return Prefab("kyno_tornadohazard", fn, assets, prefabs),
Prefab("kyno_tornadohazard_base", basefn, assets, prefabs),
MakePlacer("kyno_tornadohazard_placer", "tornado_base_fx", "tornado_weather_base", "tornado_base_loop", true, nil, nil, PS, nil, nil, tornadoplacerfn)