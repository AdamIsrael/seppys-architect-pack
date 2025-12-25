require("prefabutil")

local assets =
{
	Asset("ANIM", "anim/icefishing_hole.zip"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"ice",
	"pondfish",
	"splash_green_large",
}

local function BuildCollision(radius, height, segment_count)
    local triangles = {}
    local y0 = 0
    local y1 = height

    local segment_span = math.pi * 2 / segment_count
    for segment_idx = 0, segment_count do

        local angle = segment_idx * segment_span
        local angle0 = angle - segment_span / 2
        local angle1 = angle + segment_span / 2

        local x0 = math.cos(angle0) * radius
        local z0 = math.sin(angle0) * radius

        local x1 = math.cos(angle1) * radius
        local z1 = math.sin(angle1) * radius

        table.insert(triangles, x0)
        table.insert(triangles, y0)
        table.insert(triangles, z0)

        table.insert(triangles, x0)
        table.insert(triangles, y1)
        table.insert(triangles, z0)

        table.insert(triangles, x1)
        table.insert(triangles, y0)
        table.insert(triangles, z1)

        table.insert(triangles, x1)
        table.insert(triangles, y0)
        table.insert(triangles, z1)

        table.insert(triangles, x0)
        table.insert(triangles, y1)
        table.insert(triangles, z0)

        table.insert(triangles, x1)
        table.insert(triangles, y1)
        table.insert(triangles, z1)
    end

	return triangles
end

local function CheckForFixed(player, inst)
    player._icefishing_hole_task = nil
	
    if inst:IsValid() then
        local x, _, z = inst.Transform:GetWorldPosition()
        if player:GetDistanceSqToInst(inst) < inst._hole_radius * inst._hole_radius then
            local ex, ey, ez = player.Transform:GetWorldPosition()
            local dx, dz = ex - x, ez - z
            local dist = math.sqrt(dx * dx + dz * dz)
            local player_radius = (player.Physics:GetRadius() or 1) + .2
            if dist == 0 then
                dist = 1
                dx = player_radius
            else
                dx, dz = (player_radius + inst._hole_radius) * dx / dist, (player_radius + inst._hole_radius) * dz / dist
            end
            player.Transform:SetPosition(x + dx, 0, z + dz)
        end
    end
end

local function OnPlayerNear(inst, player)
    local x, _, z = inst.Transform:GetWorldPosition()
    SpawnPrefab("splash_green_large").Transform:SetPosition(x, 0, z)
    
    player:PushEvent("attacked", { attacker = inst, damage = 0, redirected = player })
    player:PushEvent("knockback", { knocker = inst, radius = inst._hole_radius + 1 + math.random(), disablecollision = true })
	
    if player._icefishing_hole_task ~= nil then
        player._icefishing_hole_task:Cancel()
        player._icefishing_hole_task = nil
    end
	
    player._icefishing_hole_task = player:DoTaskInTime(1, CheckForFixed, inst)
end

local function OnWork(inst, worker, workleft)
	if workleft < TUNING.ROCKS_MINE * (1/3) then
		inst.AnimState:PlayAnimation("idle", true)
	elseif workleft < TUNING.ROCKS_MINE * (2/3) then
		inst.AnimState:PlayAnimation("idle", true)
	else
		inst.AnimState:PlayAnimation("idle", true)
	end
end

local function OnWorked(inst, worker)
	inst.components.lootdropper:DropLoot()
	worker.SoundEmitter:PlaySound("dontstarve_DLC001/common/iceboulder_smash")
	
	inst:Remove()
end

local function OnBuilt(inst)
    inst.AnimState:PushAnimation("idle", true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddPhysics()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("icefishing_hole.png")
	
	local RADIUS = 1.7
	
    inst.Physics:SetMass(0)
    inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.ITEMS)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)
    inst.Physics:CollidesWith(COLLISION.GIANTS)
    inst.Physics:SetTriangleMesh(BuildCollision(RADIUS, 6, 16))

    inst.AnimState:SetBuild("icefishing_hole")
    inst.AnimState:SetBank("icefishing_hole")
	inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("structure")
	inst:AddTag("pond")
	inst:AddTag("watersource")
    inst:AddTag("antlion_sinkhole_blocker")
    inst:AddTag("birdblocker")
    inst:AddTag("groundhole")
    inst:AddTag("ignorewalkableplatforms")

    inst:SetDeployExtraSpacing(2)
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst._hole_radius = RADIUS

	inst:AddComponent("lootdropper")
	inst:AddComponent("watersource")
	
	inst:AddComponent("fishable")
	inst.components.fishable:AddFish("pondfish")
    inst.components.fishable:SetRespawnTime(TUNING.FISH_RESPAWN_TIME)
	
	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "POND"
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst.components.workable:SetOnFinishCallback(OnWorked)

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetTargetMode(inst.components.playerprox.TargetModes.AllPlayers)
    inst.components.playerprox:SetOnPlayerNear(OnPlayerNear)
    inst.components.playerprox:SetDist(RADIUS, RADIUS)
	
	inst:ListenForEvent("onbuilt", OnBuilt)

	return inst
end

local function PlaceTestFn(inst)
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGroundFixed)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
end

return Prefab("kyno_sharkboi_hole", fn, assets, prefabs),
MakePlacer("kyno_sharkboi_hole_placer", "icefishing_hole", "icefishing_hole", "idle", false, nil, nil, nil, nil, nil, PlaceTestFn)