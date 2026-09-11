require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/pig_ruins_well.zip"),      
}

local prefabs =
{
	"collapse_small",
	"purplegem"
}

local function onhammered(inst, worker)
    if inst:HasTag("fire") and inst.components.burnable then
        inst.components.burnable:Extinguish()
    end
	inst.components.lootdropper:DropLoot()
	if inst.components.container then inst.components.container:DropEverything() end
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	inst:Remove()
end

local function onhit(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("idle_full")
		inst.AnimState:PushAnimation("idle_full", true)
	end
end

local function onhit_vortex(inst, worker)
	if not inst:HasTag("burnt") then
		inst.AnimState:PlayAnimation("vortex_idle_full")
		inst.AnimState:PushAnimation("vortex_idle_full", true)
	end
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("fill")
	inst.AnimState:PushAnimation("idle_full", true)
end	

local function onbuilt_vortex(inst)
	inst.AnimState:PlayAnimation("vortex_fill")
	inst.AnimState:PushAnimation("vortex_idle_full", true)
end

local function onfar(inst)
	inst.SoundEmitter:KillSound("doom")
end

local function onnear(inst)
	inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/endswell/hum_LP","doom")
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

local function ShouldAcceptItem(inst, item)
    if not inst:HasTag("endwell") then
        local can_accept = item.prefab == "goldnugget" or item.prefab == "opalpreciousgem" or item.prefab == "sap_oinc1" or item.prefab == "sap_oinc10" or item.prefab == "sap_oinc100"
    
        return can_accept 
    else
        return true         
    end
end

local function OnRefuseItem(inst, item)
end

local function OnGetItemFromPlayer(inst, giver, item)
    if not inst:HasTag("endwell") then
        local value = 0
        if item.prefab == "sap_oinc1" then
            value = 1
        elseif item.prefab == "sap_oinc10" then
            value = 10
        elseif item.prefab == "sap_oinc100" then
            value = 100        
        elseif item.prefab == "goldnugget" then
            value = 20
        elseif item.prefab == "opalpreciousgem" then
            value = 500
        end

        inst.AnimState:PlayAnimation("splash")
        inst.AnimState:PushAnimation("idle_full", true)   

        inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/item_sink") 

        inst:DoTaskInTime(1, function()
                if math.random() * 25 < value then
                    if giver.components.health and  giver.components.health:GetPercent() < 1 then
                        giver.components.health:DoDelta(value, false, inst.prefab)
                        -- giver:PushEvent("emote", "happy")
						-- giver.sg:GoToState("powerup")
						-- giver.AnimState:PlayAnimation("emote_happy")
                    end           
                end
            end)
    else
        inst.AnimState:PlayAnimation("vortex_splash")
        inst.AnimState:PushAnimation("vortex_idle_full",true)   
        inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/endswell/splash") 

        local value = 1
        if item.prefab == "nightmarefuel" then
            value = 100
        elseif item.prefab == "redgem" or item.prefab == "bluegem" or item.prefab == "orangegem" or item.prefab == "yellowgem" or item.prefab == "greengem" then
            value = 50               
        end

        value = value + math.random()*100

        inst:DoTaskInTime(1, function()
                local gems = 0
                if value < 100 then
                    if math.random() <= 0.6 then
                        SpawnAt("crawlingnightmare",inst)
                    else
                        SpawnAt("nightmarebeak",inst)
                    end
                elseif value < 150 then
                        gems = 1
                elseif value < 200 then
                       gems = 3
                end

                if gems > 0 then
                    inst.AnimState:PlayAnimation("vortex_splash")
                    inst.AnimState:PushAnimation("vortex_idle_full",true)   
                    inst.SoundEmitter:PlaySound("dontstarve_DLC003/common/objects/endswell/splash")                     
                    for k = 1, gems do
                        local nug = SpawnPrefab("purplegem")
                        local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0,4.5,0)
                        
                        nug.Transform:SetPosition(pt:Get())
                        local down = TheCamera:GetDownVec()
                        local angle = math.atan2(down.z, down.x) + (math.random()*60-30)*DEGREES
                        -- local angle = (-TUNING.CAM_ROT-90 + math.random()*60-30)/180*PI
                        local sp = math.random()*4+2
                        nug.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
                        -- nug.components.inventoryitem:OnStartFalling()
                    end
                end
        end)

    end
end

local function wellfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_well.tex")
	
	inst.AnimState:SetBank("pig_ruins_well")
	inst.AnimState:SetBuild("pig_ruins_well")
	inst.AnimState:PlayAnimation("idle_full", true)
	
	MakeObstaclePhysics(inst, 2)
	
	inst:AddTag("structure")
	inst:AddTag("well")
	inst:AddTag("watersource")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("watersource")
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
   
	inst:ListenForEvent("onbuilt", onbuilt)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

local function endfn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_pigruins_vortex.tex")
	
	inst.AnimState:SetBank("pig_ruins_well")
	inst.AnimState:SetBuild("pig_ruins_well")
	inst.AnimState:PlayAnimation("vortex_idle_full", true)
	
	MakeObstaclePhysics(inst, 2)
	
	inst:AddTag("structure")
	inst:AddTag("endwell")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(5, 7)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
	inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit_vortex)
	inst.components.workable:SetWorkLeft(3)
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
   
	inst:ListenForEvent("onbuilt", onbuilt_vortex)
	
	inst.OnSave = onsave 
    inst.OnLoad = onload

	return inst
end

return Prefab("sap_wishingwell", wellfn, assets, prefabs),
MakePlacer("sap_wishingwell_placer", "pig_ruins_well", "pig_ruins_well", "idle_full"),

Prefab("sap_endwell", endfn, assets, prefabs),
MakePlacer("sap_endwell_placer", "pig_ruins_well", "pig_ruins_well", "vortex_idle_full")
