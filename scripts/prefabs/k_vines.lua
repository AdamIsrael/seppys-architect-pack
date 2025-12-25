require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/cave_exit_rope.zip"),
	Asset("ANIM", "anim/copycreep_build.zip"),
	Asset("ANIM", "anim/waterforest_vines.zip"),
	Asset("ANIM", "anim/vine01_build.zip"),
	Asset("ANIM", "anim/vine02_build.zip"),	
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs = {
	"kyno_canopy_shadow",
}

local function onhealthchange(inst)
	if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("death")
		inst:ListenForEvent("animover", function(inst) inst:Remove() end)
		inst.components.lootdropper:DropLoot()
	end
end

local function keeptargetfn()
    return false
end

local function onsave2(inst, data)
	data.animnum = inst.animnum
end

local function onload2(inst, data)
    if data then
        inst.animnum = data.animnum
        inst.AnimState:PlayAnimation("idle_"..inst.animnum,true)
    end
end

local function onload(inst, data)
    if inst.components.health:IsDead() then
		inst.AnimState:PlayAnimation("death")
        inst:ListenForEvent("animover", function(inst) inst:Remove() end)
		inst.components.lootdropper:DropLoot()
    end
end

local function onhit(inst)
	local healthpercent = inst.components.health:GetPercent()
        if healthpercent > 0 then
		inst.AnimState:PlayAnimation("hit")
	end
end

local function onhit2(inst)
	local healthpercent = inst.components.health:GetPercent()
        if healthpercent > 0 then
		inst.AnimState:PlayAnimation("idle_"..inst.animnum)
	end
end

local function vinefn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
	
	inst.AnimState:SetBank("exitrope")
	inst.AnimState:SetBuild("copycreep_build")
	inst.AnimState:PlayAnimation("idle_loop", true)
	
	local color = 0.7 + math.random() * 0.3
    inst.AnimState:SetMultColour(color, color, color, 1)  
	
	inst:AddTag("structure")
	inst:AddTag("shelter")
	inst:AddTag("NOBLOCK")
	inst:AddTag("flying")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(100)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = false
	inst.components.health.canheal = false

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	
	inst.OnLoad = onload
	
	return inst
end

local function hangingfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
	
	inst.AnimState:SetBank("exitrope")
	inst.AnimState:SetBuild("vine01_build")
	inst.AnimState:PlayAnimation("idle_loop")
	
	local color = 0.7 + math.random() * 0.3
    inst.AnimState:SetMultColour(color, color, color, 1)  
	
	inst:AddTag("structure")
	inst:AddTag("shelter")
	inst:AddTag("NOBLOCK")
	inst:AddTag("flying")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(100)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = false
	inst.components.health.canheal = false

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit
	
	inst.OnLoad = onload
	
	return inst
end

local function borderfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
	
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize(1.5, .75)
	
	inst.AnimState:SetBank("vine_rainforest_border")
	inst.AnimState:SetBuild("waterforest_vines")
	inst.animnum = math.random(1,6)
	inst.AnimState:PlayAnimation("idle_"..inst.animnum,true)
	
	local color = 0.7 + math.random() * 0.3
    inst.AnimState:SetMultColour(color, color, color, 1)  
	
	inst:AddTag("structure")
	inst:AddTag("shelter")
	inst:AddTag("NOBLOCK")
	inst:AddTag("flying")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
		
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(100)
	inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
	inst.components.health.ondelta = onhealthchange
	inst.components.health.nofadeout = false
	inst.components.health.canheal = false

	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat.onhitfn = onhit2
	
	inst.OnLoad = onload
	-- inst.OnSave = onsave2

	return inst
end
	
return Prefab("kyno_vine1", vinefn, assets, prefabs),
Prefab("kyno_vine2", hangingfn, assets, prefabs),
Prefab("kyno_vine3", borderfn, assets, prefabs),
MakePlacer("kyno_vineone_placer", "exitrope", "copycreep_build", "idle_loop"),
MakePlacer("kyno_vinetwo_placer", "exitrope", "vine01_build", "idle_loop"),
MakePlacer("kyno_vinethree_placer", "vine_rainforest_border", "waterforest_vines", "idle_1")