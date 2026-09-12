local function makeassetlist(bankname, buildname)
    return {
        Asset("ANIM", "anim/"..buildname..".zip"),
        Asset("ANIM", "anim/"..bankname..".zip"),
    }
end

local function makefn(bankname, buildname, animname, tag)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        inst:AddTag("DECOR")
        if tag ~= nil then
            inst:AddTag(tag)
        end
        
        inst.persists = false

        inst.AnimState:SetBank(bankname)
        inst.AnimState:SetBuild(buildname)
        inst.AnimState:PlayAnimation(animname)

        return inst
    end
end

local function item(name, bankname, buildname, animname, tag)
    return Prefab(name, makefn(bankname, buildname, animname, tag), makeassetlist(bankname, buildname))
end

return item("sap_hydro_farmrock", "hydroponic_farm_decor", "hydroponic_farm_decor", "11"),
item("sap_hydro_farmrocktall", "hydroponic_farm_decor", "hydroponic_farm_decor", "12"),
item("sap_hydro_farmrockflat", "hydroponic_farm_decor", "hydroponic_farm_decor", "13"),
item("sap_hydro_stick", "hydroponic_farm_decor", "hydroponic_farm_decor", "3", "NOCLICK"),
item("sap_hydro_stickright", "hydroponic_farm_decor", "hydroponic_farm_decor", "6", "NOCLICK"),
item("sap_hydro_stickleft", "hydroponic_farm_decor", "hydroponic_farm_decor", "7", "NOCLICK"),
item("sap_hydro_signleft", "hydroponic_farm_decor", "hydroponic_farm_decor", "4", "NOCLICK"),
item("sap_hydro_fencepost", "hydroponic_farm_decor", "hydroponic_farm_decor", "5"),
item("sap_hydro_fencepostright", "hydroponic_farm_decor", "hydroponic_farm_decor", "9"),
item("sap_hydro_signright", "hydroponic_farm_decor", "hydroponic_farm_decor", "10", "NOCLICK"),
-- We don't have animations for burnt versions. Said that I removed the burnt function from the hydro farms.
item("sap_hydro_burntstickleft", "hydroponic_farm_decor", "hydroponic_farm_decor", "11", "NOCLICK"),
item("sap_hydro_burntstick", "hydroponic_farm_decor", "hydroponic_farm_decor", "12", "NOCLICK"),
item("sap_hydro_burntfencepostright", "hydroponic_farm_decor", "hydroponic_farm_decor", "13"),
item("sap_hydro_burntfencepost", "hydroponic_farm_decor", "hydroponic_farm_decor", "14"),
item("sap_hydro_burntstickright", "hydroponic_farm_decor", "hydroponic_farm_decor", "15", "NOCLICK")
