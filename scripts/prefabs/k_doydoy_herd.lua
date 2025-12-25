local assets =
{
}

local prefabs = 
{
}

local function AddMember(inst, member)
end

local function OnEmpty(inst)
	inst:Remove()
end

local function OnFull(inst)
end
   
local function fn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	inst:AddTag("herd")
	inst:AddTag("waterproofer")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	-- inst:AddComponent("herd")
	-- inst.components.herd:SetMemberTag("doydoy")
	-- inst.components.herd:SetMaxSize(TUNING.DOYDOY_HERD_SIZE)
	-- inst.components.herd:SetGatherRange(TUNING.DOYDOY_HERD_GATHER_RANGE)
	-- inst.components.herd:SetUpdateRange(20)
	-- inst.components.herd:SetOnEmptyFn(OnEmpty)
	-- inst.components.herd:SetOnFullFn(OnFull)
	-- inst.components.herd:SetAddMemberFn(AddMember)
		
	-- looking for the babyspawner? it's the global doydoyspawner component.
	
	return inst
end

return Prefab("kyno_doydoyherd", fn, assets, prefabs) 