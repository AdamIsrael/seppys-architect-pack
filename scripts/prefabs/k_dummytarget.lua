local assets =
{
    Asset("ANIM", "anim/kyno_dummytarget.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/minimapimages/tap_minimapicons.tex"),
	Asset("ATLAS", "images/minimapimages/tap_minimapicons.xml"),
}

local function OnHealthDelta(inst, data)
    if data.amount <= 0 then
        -- inst.Label:SetText(data.amount)
        -- inst.Label:SetUIOffset(math.random() * 20 - 10, math.random() * 20 - 10, 0)
		-- inst.components.talker:Say("Dealt: "..data.amount.." of Damage!")
		local DMGTEXT = GetModConfigData("TAP_DUMMYTEXT", KnownModIndex:GetModActualName("The Architect Pack"))
		if DMGTEXT == 0 then
			inst.components.talker:Say(""..data.amount.."")
			inst.SoundEmitter:PlaySound("dontstarve/common/together/meat_effigy_attune/on")
		elseif DMGTEXT == 1 then
			inst.components.talker:Say(""..data.amount.." of Damage!")
			inst.SoundEmitter:PlaySound("dontstarve/common/together/meat_effigy_attune/on")
		elseif DMGTEXT == 2 then
			inst.components.talker:Say("Dealt "..data.amount.." of Damage!")
			inst.SoundEmitter:PlaySound("dontstarve/common/together/meat_effigy_attune/on")
		elseif DMGTEXT == 3 then
			inst.components.talker:Say("Wigfrid took "..data.amount.." of Damage!")
			inst.SoundEmitter:PlaySound("dontstarve_DLC001/characters/wathgrithr/hurt") -- LMAO
		end
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle")
    end
end

local function OnHammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function OnBuilt(inst)
    inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle")
	inst.SoundEmitter:PlaySound("dontstarve/common/together/meat_effigy_attune/on")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	inst.entity:AddLabel()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("kyno_dummytarget.tex")
	
	MakeObstaclePhysics(inst, .3)

    inst.AnimState:SetBank("kyno_dummytarget")
    inst.AnimState:SetBuild("kyno_dummytarget")
    inst.AnimState:PlayAnimation("idle")

	inst:AddTag("monster")
	inst:AddTag("hostile")
	inst:AddTag("damagetester")
	
	inst:AddComponent("talker")
	inst.components.talker.fontsize = 40
	inst.components.talker.font = TALKINGFONT
	inst.components.talker.offset = Vector3(0,-570,0)
	local DUMMYCOLOR = GetModConfigData("TAP_DUMMYCOLOR", KnownModIndex:GetModActualName("The Architect Pack"))
	if DUMMYCOLOR == 0 then -- White.
		inst.components.talker.colour = _G.Vector3(1, 1, 1)
	elseif DUMMYCOLOR == 1 then -- Red.
		inst.components.talker.colour = _G.Vector3(.9, .4, .4)
	elseif DUMMYCOLOR == 2 then -- Yellow.
		inst.components.talker.colour = _G.Vector3(.9, .7, 0)
	elseif DUMMYCOLOR == 3 then -- Cyan.
		inst.components.talker.colour = _G.Vector3(0, .7, .7)
	end

    MakeSnowCoveredPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	-- inst.Label:SetFontSize(50)
    -- inst.Label:SetFont(DEFAULTFONT)
    -- inst.Label:SetWorldOffset(0, 3, 0)
    -- inst.Label:SetUIOffset(0, 0, 0)
    -- inst.Label:SetColour(1, 1, 1)
    -- inst.Label:Enable(true)

    inst:AddComponent("bloomer")
    inst:AddComponent("colouradder")
    inst:AddComponent("inspectable")
    inst:AddComponent("combat")
	inst:AddComponent("lootdropper")
	
    inst:AddComponent("debuffable")
    inst.components.debuffable:SetFollowSymbol("ww_head", 0, -250, 0)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(1000)
    inst.components.health:StartRegen(1000, .1)
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(OnHammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    inst:ListenForEvent("healthdelta", OnHealthDelta)
	inst:ListenForEvent("onbuilt", OnBuilt)
	
	MakeSnowCovered(inst)
	MakeMediumBurnable(inst)
	MakeSmallPropagator(inst)	

    return inst
end

return Prefab("sap_dummytarget", fn, assets),
MakePlacer("sap_dummytarget_placer", "kyno_dummytarget", "kyno_dummytarget", "idle")