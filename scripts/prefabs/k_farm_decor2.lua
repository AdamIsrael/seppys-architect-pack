local function makeassetlist(bankname, buildname)
    return {
        Asset("ANIM", "anim/"..buildname..".zip"),
        Asset("ANIM", "anim/"..bankname..".zip"),
		
		Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
		Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
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

return item("sap_p2_farmrock", "hydroponic_farm_decor", "hydroponic_farm_decor", "1", "pastoral_rock"),
item("sap_p2_farmrocktall", "hydroponic_farm_decor", "hydroponic_farm_decor", "2", "pastoral_rock"),
item("sap_p2_farmrockflat", "hydroponic_farm_decor", "hydroponic_farm_decor", "8", "pastoral_rock"),
item("sap_p2_stick", "hydroponic_farm_decor", "hydroponic_farm_decor", "3"),
item("sap_p2_stickright", "hydroponic_farm_decor", "hydroponic_farm_decor", "6"),
item("sap_p2_stickleft", "hydroponic_farm_decor", "hydroponic_farm_decor", "7"),
item("sap_p2_signleft", "hydroponic_farm_decor", "hydroponic_farm_decor", "4"),
item("sap_p2_signright", "hydroponic_farm_decor", "hydroponic_farm_decor", "10"), -- Nope.
item("sap_p2_fencepost", "hydroponic_farm_decor", "hydroponic_farm_decor", "5"),
item("sap_p2_fencepostright", "hydroponic_farm_decor", "hydroponic_farm_decor", "9"),
item("sap_p2_burntstickleft", "hydroponic_farm_decor", "hydroponic_farm_decor", "11"),
item("sap_p2_burntstick", "hydroponic_farm_decor", "hydroponic_farm_decor", "12"),
item("sap_p2_burntfencepostright", "hydroponic_farm_decor", "hydroponic_farm_decor", "13"),
item("sap_p2_burntfencepost", "hydroponic_farm_decor", "hydroponic_farm_decor", "14"),
item("sap_p2_burntstickright", "hydroponic_farm_decor", "hydroponic_farm_decor", "15"),
MakePlacer("sap_p2_farmrock_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "1"),
MakePlacer("sap_p2_farmrocktall_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "2"),
MakePlacer("sap_p2_farmrockflat_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "8"),
MakePlacer("sap_p2_stick_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "3"),
MakePlacer("sap_p2_stickright_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "6"),
MakePlacer("sap_p2_stickleft_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "7"),
MakePlacer("sap_p2_signleft_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "4"),
MakePlacer("sap_p2_signright_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "10"),
MakePlacer("sap_p2_fencepost_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "5"),
MakePlacer("sap_p2_fencepostright_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "9"),
MakePlacer("sap_p2_burntstick_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "12"),
MakePlacer("sap_p2_burntstickleft_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "11"),
MakePlacer("sap_p2_burntstickright_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "15"),
MakePlacer("sap_p2_burntfencepost_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "14"),
MakePlacer("sap_p2_burntfencepostright_placer", "hydroponic_farm_decor", "hydroponic_farm_decor", "13")