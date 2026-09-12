local function makeassetlist(bankname, buildname)
    return {
        Asset("ANIM", "anim/"..buildname..".zip"),
        Asset("ANIM", "anim/"..bankname..".zip"),
    }
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	if inst:HasTag("pastoral_rock") then
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_stone")
	else
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	end
	inst:Remove()
end

local function makefn(bankname, buildname, animname, tag)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddNetwork()

        inst.AnimState:SetBank(bankname)
        inst.AnimState:SetBuild(buildname)
        inst.AnimState:PlayAnimation(animname)
		
		inst:AddTag("pastoral")
		inst:AddTag("structure")
		
		inst.entity:SetPristine()
	
		if not TheWorld.ismastersim then
			return inst
		end
		
		inst:AddComponent("lootdropper")
		inst:AddComponent("inspectable")
	
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(1)
		inst.components.workable:SetOnFinishCallback(onhammered)
	
		inst:AddComponent("hauntable")
		inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
		
		MakeHauntableWork(inst)

        return inst
    end
end

local function item(name, bankname, buildname, animname, tag)
    return Prefab(name, makefn(bankname, buildname, animname, tag), makeassetlist(bankname, buildname))
end

return item("sap_p_farmrock", "farm_decor", "farm_decor", "1", "pastoral_rock"),
item("sap_p_farmrocktall", "farm_decor", "farm_decor", "2", "pastoral_rock"),
item("sap_p_farmrockflat", "farm_decor", "farm_decor", "8", "pastoral_rock"),
item("sap_p_stick", "farm_decor", "farm_decor", "3"),
item("sap_p_stickright", "farm_decor", "farm_decor", "6"),
item("sap_p_stickleft", "farm_decor", "farm_decor", "7"),
item("sap_p_signleft", "farm_decor", "farm_decor", "4"),
item("sap_p_signright", "farm_decor", "farm_decor", "10"),
item("sap_p_fencepost", "farm_decor", "farm_decor", "5"),
item("sap_p_fencepostright", "farm_decor", "farm_decor", "9"),
item("sap_p_burntstickleft", "farm_decor", "farm_decor", "11"),
item("sap_p_burntstick", "farm_decor", "farm_decor", "12"),
item("sap_p_burntfencepostright", "farm_decor", "farm_decor", "13"),
item("sap_p_burntfencepost", "farm_decor", "farm_decor", "14"),
item("sap_p_burntstickright", "farm_decor", "farm_decor", "15"),
MakePlacer("sap_p_farmrock_placer", "farm_decor", "farm_decor", "1"),
MakePlacer("sap_p_farmrocktall_placer", "farm_decor", "farm_decor", "2"),
MakePlacer("sap_p_farmrockflat_placer", "farm_decor", "farm_decor", "8"),
MakePlacer("sap_p_stick_placer", "farm_decor", "farm_decor", "3"),
MakePlacer("sap_p_stickright_placer", "farm_decor", "farm_decor", "6"),
MakePlacer("sap_p_stickleft_placer", "farm_decor", "farm_decor", "7"),
MakePlacer("sap_p_signleft_placer", "farm_decor", "farm_decor", "4"),
MakePlacer("sap_p_signright_placer", "farm_decor", "farm_decor", "10"),
MakePlacer("sap_p_fencepost_placer", "farm_decor", "farm_decor", "5"),
MakePlacer("sap_p_fencepostright_placer", "farm_decor", "farm_decor", "9"),
MakePlacer("sap_p_burntstick_placer", "farm_decor", "farm_decor", "12"),
MakePlacer("sap_p_burntstickleft_placer", "farm_decor", "farm_decor", "11"),
MakePlacer("sap_p_burntstickright_placer", "farm_decor", "farm_decor", "15"),
MakePlacer("sap_p_burntfencepost_placer", "farm_decor", "farm_decor", "14"),
MakePlacer("sap_p_burntfencepostright_placer", "farm_decor", "farm_decor", "13")