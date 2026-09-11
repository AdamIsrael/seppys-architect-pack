local assets =
{
    Asset("ANIM", "anim/archive_moon_statue.zip"),
    Asset("ANIM", "anim/archive_runes.zip"),
	Asset("ANIM", "anim/archive_security_desk.zip"),
	Asset("ANIM", "anim/archive_knowledge_dispensary.zip"),
	Asset("ANIM", "anim/archive_knowledge_dispensary_b.zip"),
    Asset("ANIM", "anim/archive_knowledge_dispensary_c.zip"),
	Asset("ANIM", "anim/archive_knowledge_dispensary_d.zip"),
	Asset("ANIM", "anim/archive_knowledge_dispensary_e.zip"),
	Asset("ANIM", "anim/archive_switch.zip"),
	Asset("ANIM", "anim/archive_switch_ground.zip"),
	Asset("ANIM", "anim/archive_switch_ground_small.zip"),
	Asset("ANIM", "anim/archive_portal.zip"),
    Asset("ANIM", "anim/archive_portal_base.zip"),
	Asset("ANIM", "anim/archive_orchestrina_main.zip"),
    Asset("ANIM", "anim/archive_sigil.zip"),
    
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages.xml"),
	
	Asset("IMAGE", "images/inventoryimages/tap_buildingimages2.tex"),
	Asset("ATLAS", "images/inventoryimages/tap_buildingimages2.xml"),
}

local prefabs =
{
	"archive_dispencer_sfx",
	"archive_lockbox",
	"collapse_small",
	"kyno_archive_orchestrina_base",
	"kyno_archive_portal_base",
	"kyno_archive_switch_pad",
	"opalpreciousgem",
	"rock_break_fx"
}

local _storyprogress = 0
local NUM_STORY_LINES = 5

local function getstatus(inst)
    if inst.storyprogress == nil then
        _storyprogress = (_storyprogress % NUM_STORY_LINES) + 1
        inst.storyprogress = _storyprogress
    end

    return "LINE_"..tostring(inst.storyprogress)
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onwork1(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PushAnimation("idle_low_1")
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PushAnimation("idle_med_1")
    else
        inst.AnimState:PushAnimation("idle_full_1")
    end
end

local function onwork2(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PushAnimation("idle_low_2")
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PushAnimation("idle_med_2")
    else
        inst.AnimState:PushAnimation("idle_full_2")
    end
end

local function onwork3(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PushAnimation("idle_low_3")
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PushAnimation("idle_med_3")
    else
        inst.AnimState:PushAnimation("idle_full_3")
    end
end

local function onwork4(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PushAnimation("idle_low_4")
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PushAnimation("idle_med_4")
    else
        inst.AnimState:PushAnimation("idle_full_4")
    end
end

local function onwork_rune1(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PushAnimation("idle")
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PushAnimation("idle")
    else
        inst.AnimState:PushAnimation("idle")
    end
end

local function onwork_rune2(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PushAnimation("idle2")
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PushAnimation("idle2")
    else
        inst.AnimState:PushAnimation("idle2")
    end
end

local function onwork_rune3(inst, worker, workleft)
    if workleft <= 0 then
        local pos = inst:GetPosition()
        SpawnPrefab("rock_break_fx").Transform:SetPosition(pos:Get())
        inst.components.lootdropper:DropLoot(pos)
        inst:Remove()
    elseif workleft < TUNING.MARBLEPILLAR_MINE / 3 then
        inst.AnimState:PushAnimation("idle3")
    elseif workleft < TUNING.MARBLEPILLAR_MINE * 2 / 3 then
        inst.AnimState:PushAnimation("idle3")
    else
        inst.AnimState:PushAnimation("idle3")
    end
end

local function onfar(inst)
	inst.AnimState:PlayAnimation("leave")
	inst.AnimState:PushAnimation("idle_leave", true)
	inst.Light:Enable(false)
	
	inst.SoundEmitter:KillSound("loop")
end

local function onnear(inst)
	inst.AnimState:PlayAnimation("appear")
	inst.AnimState:PushAnimation("idle", true)
	inst.Light:Enable(true)
	
	inst.SoundEmitter:PlaySound("grotto/common/archive_security_desk/appear")     
	inst.SoundEmitter:PlaySound("grotto/common/archive_security_desk/contained_LP","loop")
end

local function onfar_fountain(inst)
	inst.AnimState:PlayAnimation("use_pre")
	inst.AnimState:PushAnimation("idle", true)
	
	-- inst.SoundEmitter:PlaySound("grotto/common/archive_lockbox/taunt")
end

local function onnear_fountain(inst)
	inst.AnimState:PlayAnimation("use_pre")
	inst.AnimState:PushAnimation("taunt1", true)
	
	-- inst.SoundEmitter:PlaySound("grotto/common/archive_lockbox/LP", "loopsound")
end

local function ItemTradeTestSwitch(inst, item)
    if item == nil then
        return false
    elseif item.prefab ~= "opalpreciousgem" then
        return false, string.sub(item.prefab, -3) == "gem" and "WRONGGEM" or "NOTGEM"
    end
    return true
end

local GEM_SOCKET_MUST_TAGS = {"gemsocket","archive_switch"}
local CHANDELIER_MUST_TAGS = {"archive_chandelier"}
local function checkforgems(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 6, GEM_SOCKET_MUST_TAGS )

    for i=#ents,1,-1 do
        local ent = ents[i]
        if not ent.gem then
            table.remove(ents,i)
        end
    end
end

local function OnGemGiven(inst, giver, item)

    inst.SoundEmitter:PlaySound("dontstarve/common/telebase_gemplace")    
    
    inst.components.trader:Disable()
    inst.components.pickable:SetUp("opalpreciousgem", 1000000)
    inst.components.pickable:Pause()
    inst.components.pickable.caninteractwith = true
    inst.gem = true

    if not inst.entity:IsAwake() then
        inst.AnimState:PlayAnimation("idle_full",false)
        checkforgems(inst)
    else
        if not inst.AnimState:IsCurrentAnimation("idle_full") then
            if not inst.AnimState:IsCurrentAnimation("activate") then
                inst:DoTaskInTime(11/30, function() 
                    local pos = Vector3(inst.Transform:GetWorldPosition())
                    ShakeAllCameras(CAMERASHAKE.SIDE, 2, .02, .05, pos, 50)
                end)
                inst.AnimState:PlayAnimation("activate",false)
                inst.SoundEmitter:PlaySound("grotto/common/archive_switch/on")
            end        
        end 
    end   
end

local function OnGemTaken(inst)

    inst.components.trader:Enable()
    inst.components.pickable.caninteractwith = false
    inst.gem = false 

    if not inst.AnimState:IsCurrentAnimation("idle_empty") then
        if not inst.AnimState:IsCurrentAnimation("deactivate") then
           
            local pos = Vector3(inst.Transform:GetWorldPosition())
            ShakeAllCameras(CAMERASHAKE.SIDE, 20/30, .02, .05, pos, 50)
          
            inst.AnimState:PlayAnimation("deactivate",false)
            inst.SoundEmitter:PlaySound("grotto/common/archive_switch/off")
        end        
    end
end

local function ShatterGem(inst) 
    inst.SoundEmitter:KillSound("hover_loop")
    inst.AnimState:ClearBloomEffectHandle()
    inst.AnimState:PlayAnimation("shatter")
    inst.AnimState:PushAnimation("idle_empty")
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
end

local function DestroyGem(inst)
    inst.components.trader:Enable()
    inst.components.pickable.caninteractwith = false
    inst:DoTaskInTime(math.random() * 0.5, ShatterGem)
end

local function OnSaveSwitch(inst, data)
    if inst.shadowwartask then
        data.startwar = true
    end
end

local function OnLoadPostPassSwitch(inst, newents, data)

    if data and data.spawnopal then
        local opal = SpawnPrefab("opalpreciousgem")
        inst.components.trader:AcceptGift(nil,opal,1)
    end

    if not inst.components.pickable.caninteractwith then
        OnGemTaken(inst)  
    else
        OnGemGiven(inst)
    end
	
end

local function getstatusSwitch(inst)
    return inst.components.pickable.caninteractwith and "VALID" or "GEMS"
end

local RADIUS = 10
local INC = PI/20

local function mastermind(lock,key)

    local result = {exact=0,close=0}

    for i=#lock,1,-1 do
        if lock[i] == key[i] then
            result.exact = result.exact +1
            table.remove(lock,i)
            table.remove(key,i)
        end
    end

    for i=#key,1,-1 do
        for t=#lock,1,-1 do
            if key[i] == lock[t] then
                result.close = result.close +1
                table.remove(lock,t)
                table.remove(key,i)
                break
            end
        end
    end   
    return result
end

local SOCKETTEST_MUST = {"resonator_socket"}
local LOCKBOX_MUST = {"archive_lockbox"}
local RESONATORTEST_CAN = {"archive_resonator","singingshell"}
local OCHESTRINA_MAIN_MUST = {"kyno_archive_orchestrina_main"}

local function findlockbox(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
    local lockboxents = TheSim:FindEntities(x,y,z, 3, LOCKBOX_MUST)
    if #lockboxents > 0 then
        for i=#lockboxents,1,-1 do
                if lockboxents[i].components.inventoryitem and lockboxents[i].components.inventoryitem.owner then
                table.remove(lockboxents,i)
            end
        end
    end     
    return lockboxents
end

local function testforlockbox(inst)    
    local lockboxes= findlockbox(inst)
    local x,y,z = inst.Transform:GetWorldPosition()
    if #lockboxes == 1 and not inst.failed then   
        if inst.status == "off" then
            if not inst.AnimState:IsCurrentAnimation("big_activation") and not inst.AnimState:IsCurrentAnimation("big_on") then
                inst.AnimState:PlayAnimation("big_on_pre")
                inst.AnimState:PushAnimation("big_on",true)
                inst.SoundEmitter:PlaySound("grotto/common/archive_orchestrina/0", "machine0")
            end
        end
        inst.status = "on"
    else
        if inst.status == "on" then            
            if not inst.AnimState:IsCurrentAnimation("big_activation") and not inst.AnimState:IsCurrentAnimation("big_idle") then
                inst.AnimState:PlayAnimation("big_on_pst")
                inst.AnimState:PushAnimation("big_idle",true)                    
            end
        end
        inst.status = "off" 

        inst.SoundEmitter:KillSound("machine0")

        -- turn off the outer circles
        if inst.oldlockboxes and inst.oldlockboxes > 0 and not inst.busy then
            local ents = TheSim:FindEntities(x,y,z, 10, SOCKETTEST_MUST)
            for i, ent in ipairs(ents)do
                --ent:testforplayers(ent)
                ent:smallOff(false)
            end
        end

        if inst.numcount then
            inst.numcount = nil
        end        
    end    

    if inst.failed then

        -- reset if player is not on a socket
        local close = false
        local sockets = TheSim:FindEntities(x,y,z, 10, SOCKETTEST_MUST)

        for i,socket in ipairs(sockets) do
            if socket.close then
                close = true
            end
        end
        if not close then
            inst.failed = nil
        end
    end
    inst.oldlockboxes = #lockboxes
end

local function testforcompletion(inst)
    local blank = true
    local x,y,z = inst.Transform:GetWorldPosition()    
    local ents = TheSim:FindEntities(x,y,z, 10, SOCKETTEST_MUST)
    
    local sockets = {}
    for i=#ents,1,-1 do
        table.insert(sockets,ents[i])
    end
    table.sort(sockets, function(a,b) return a.GUID < b.GUID end)
    
    local lockboxents = findlockbox(inst)   
    local archive = TheWorld.components.archivemanager
    if archive then
        archive.puzzlepaused = nil
    end
    
    inst.busy = false

    local pass = true
    if #lockboxents == 1 then        
        local puzzle = lockboxents[1].puzzle
        if puzzle then
            blank = false
            inst.AnimState:PlayAnimation("big_on",true)

            local lock = deepcopy(puzzle)
            local key = {9,9,9,9,9,9,9,9}

            local order = {}
            for i,socket in ipairs(sockets)do
                if socket.order then
                    key[i] = socket.order
                    table.insert(order,i)
                end
            end             

            for i,idx in ipairs(order) do
                if key[idx] ~= lock[idx] then
                    pass = false
                end
            end

            if pass and #order > 0 and #order < 8 then
                inst.SoundEmitter:PlaySound("grotto/common/archive_orchestrina/"..  #order .."_LP", "machine"..#order)
            end
            if pass and #order == 8 then
                for i=1,7 do
                    inst.SoundEmitter:KillSound("machine"..i)
                end
                inst.SoundEmitter:PlaySound("grotto/common/archive_orchestrina/8")                
                inst.busy = true

                inst.AnimState:PlayAnimation("big_activation")
                inst.AnimState:PushAnimation("big_idle")

                for i,socket in ipairs(sockets)do
                    if socket.set == true then                       
                        if socket.order == 1 then                            
                            socket.AnimState:PlayAnimation("one_activation")
                            socket.AnimState:PushAnimation("small_idle",true)
                        elseif socket.order == 2 then
                            socket.AnimState:PlayAnimation("two_activation")
                            socket.AnimState:PushAnimation("small_idle",true)
                        elseif socket.order == 3 then
                            socket.AnimState:PlayAnimation("three_activation")
                            socket.AnimState:PushAnimation("small_idle",true)
                        elseif socket.order == 4 then
                            socket.AnimState:PlayAnimation("four_activation")
                            socket.AnimState:PushAnimation("small_idle",true)
                        elseif socket.order == 5 then
                            socket.AnimState:PlayAnimation("five_activation")
                            socket.AnimState:PushAnimation("small_idle",true)
                        elseif socket.order == 6 then
                            socket.AnimState:PlayAnimation("six_activation")
                            socket.AnimState:PushAnimation("small_idle",true)
                        elseif socket.order == 7 then
                            socket.AnimState:PlayAnimation("seven_activation")
                            socket.AnimState:PushAnimation("small_idle",true)
                        elseif socket.order == 8 then
                            socket.AnimState:PlayAnimation("eight_activation")
                            socket.AnimState:PushAnimation("small_idle",true)
                        end 
                    end                    
                end 

                inst:DoTaskInTime(5,function() inst.busy = nil end)
            end

            if pass and #order == 8 then                
                if lockboxents[1].product_orchestrina then
                    inst:DoTaskInTime(1/3,function() 
                        lockboxents[1]:PushEvent("onteach")
                    end)
                end
                
                pass = false
            end
        end
    end

    if pass == false then       
        for i=1,7 do
            inst.SoundEmitter:KillSound("machine"..i)
        end
        inst.SoundEmitter:PlaySound("grotto/common/archive_orchestrina/stop")
        inst.failed = true        
    end
end

local function smallOff(inst,fail)    
    if fail then
        inst.AnimState:PlayAnimation("small_error")
        inst.AnimState:PushAnimation("small_idle",true)
    else
        if inst.set == true then
            if inst.order == 1 then
                if inst.AnimState:IsCurrentAnimation("one") then
                    inst.AnimState:PlayAnimation("one_pst")
                    inst.AnimState:PushAnimation("small_idle",true)
                end
            elseif inst.order == 2 then
                if inst.AnimState:IsCurrentAnimation("two") then
                    inst.AnimState:PlayAnimation("two_pst")
                    inst.AnimState:PushAnimation("small_idle",true)
                end
            elseif inst.order == 3 then
                if inst.AnimState:IsCurrentAnimation("three") then
                    inst.AnimState:PlayAnimation("three_pst")
                    inst.AnimState:PushAnimation("small_idle",true)
                end
            elseif inst.order == 4 then
                if inst.AnimState:IsCurrentAnimation("four") then
                    inst.AnimState:PlayAnimation("four_pst")
                    inst.AnimState:PushAnimation("small_idle",true)
                end
            elseif inst.order == 5 then
                if inst.AnimState:IsCurrentAnimation("five") then                    
                    inst.AnimState:PlayAnimation("five_pst")
                    inst.AnimState:PushAnimation("small_idle",true)
                end                    
            elseif inst.order == 6 then
                if inst.AnimState:IsCurrentAnimation("six") then
                    inst.AnimState:PlayAnimation("six_pst")
                    inst.AnimState:PushAnimation("small_idle",true)
                end
            elseif inst.order == 7 then
                if inst.AnimState:IsCurrentAnimation("seven") then
                    inst.AnimState:PlayAnimation("seven_pst")
                    inst.AnimState:PushAnimation("small_idle",true)
                end
            elseif inst.order == 8 then
                if inst.AnimState:IsCurrentAnimation("eight") then
                    inst.AnimState:PlayAnimation("eight_pst")
                    inst.AnimState:PushAnimation("small_idle",true)
                end
            end 
        end 
    end       
    inst.set = false
    inst.order = nil 
end


local function testforplayers(inst)
    inst.close = false
    local x,y,z = inst.Transform:GetWorldPosition()
    local main = TheSim:FindEntities(x,y,z, 10, OCHESTRINA_MAIN_MUST)[1]

    if main and not main.busy then
        local failed = main.failed
        local lockboxents = findlockbox( main )    
        local dist = inst:GetDistanceSqToClosestPlayer(true)
        if dist < 1.7*1.7 then
            inst.close = true   
        end

        if #lockboxents == 1 and inst.close and not main.failed and not inst.set then
            if not main.numcount then
                main.numcount = 0
            end
            main.numcount = main.numcount + 1
            if main.numcount == 1 then
                inst.AnimState:PlayAnimation("one_pre")
                inst.AnimState:PushAnimation("one",true)
                inst.order = 1
            elseif main.numcount == 2 then
                inst.AnimState:PlayAnimation("two_pre")
                inst.AnimState:PushAnimation("two",true)
                inst.order = 2
            elseif main.numcount == 3 then
                inst.AnimState:PlayAnimation("three_pre")
                inst.AnimState:PushAnimation("three",true)                    
                inst.order = 3
            elseif main.numcount == 4 then
                inst.AnimState:PlayAnimation("four_pre")
                inst.AnimState:PushAnimation("four",true)                    
                inst.order = 4
            elseif main.numcount == 5 then
                inst.AnimState:PlayAnimation("five_pre")
                inst.AnimState:PushAnimation("five",true)                    
                inst.order = 5
            elseif main.numcount == 6 then
                inst.AnimState:PlayAnimation("six_pre")
                inst.AnimState:PushAnimation("six",true)                    
                inst.order = 6
            elseif main.numcount == 7 then
                inst.AnimState:PlayAnimation("seven_pre")
                inst.AnimState:PushAnimation("Seven",true)                    
                inst.order = 7
            elseif main.numcount == 8 then
                inst.AnimState:PlayAnimation("eight_pre")
                inst.AnimState:PushAnimation("eight",true)
                inst.order = 8
            end
            inst.set= true        
            testforcompletion(main)            
        end
        if main.failed and not main.busy then
            inst:smallOff(failed ~= main.failed )
        end
    end
end

local function movesound(inst, baseangle, pos)
    local sound = {angle = 0, dist=0}
    if inst.soundlist and inst.soundlist[1] then
        sound = inst.soundlist[1]
        table.remove(inst.soundlist,1)
    end
    local radius = sound.dist
    local theta = sound.angle + baseangle
    local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))       

    inst.Transform:SetPosition(offset.x+pos.x,0,offset.z+pos.z)
    inst.SoundEmitter:PlaySound("grotto/common/archive_lockbox/hit")
end

local function OnActivateFountain(inst, doer)  
	if not inst.AnimState:IsCurrentAnimation("use_pre") and not inst.AnimState:IsCurrentAnimation("use_loop") and not inst.AnimState:IsCurrentAnimation("use_post") then
		inst.AnimState:PlayAnimation("use_pre",false)

		inst.sfx = SpawnPrefab("archive_dispencer_sfx")
		inst.sfx.SoundEmitter:PlaySound("grotto/common/archive_lockbox/LP", "loopsound")
		local baserotation = math.random()*PI*2
		local pos = Vector3(inst.Transform:GetWorldPosition())
		inst.sfx.soundlist = { 
			{angle=0,dist=20},
			{angle=PI/6,dist=15},
			{angle=-PI/12,dist=10},
			{angle=-PI/2.3,dist=8},
			{angle=0,dist=4},                
		}
		movesound(inst.sfx, baserotation, pos)
	
		inst.sfx:DoTaskInTime(1,function() movesound(inst.sfx, baserotation, pos) end)        
		inst.sfx:DoTaskInTime(1.7,function() movesound(inst.sfx, baserotation, pos) end)        
		inst.sfx:DoTaskInTime(2.7,function() movesound(inst.sfx, baserotation, pos) end)        
		inst.sfx:DoTaskInTime(3.8,function() movesound(inst.sfx, baserotation, pos) end)        
		inst.sfx:DoTaskInTime(4.5,function() movesound(inst.sfx, baserotation, pos) end)        
	end
	
	inst:ListenForEvent("animover", function()
   
        if inst.AnimState:IsCurrentAnimation("idle") then
            if  math.random()< 1/30 then
                local rand = math.random(1,3)
                inst.AnimState:PlayAnimation("taunt"..rand)
                inst.SoundEmitter:PlaySound("grotto/common/archive_lockbox/taunt")
                inst.AnimState:PushAnimation("idle")
            else
                inst.AnimState:PlayAnimation("idle")
            end
        end

        if inst.AnimState:IsCurrentAnimation("use_pre") then
            inst.AnimState:PlayAnimation("use_loop",true)        				
            inst:DoTaskInTime((45/30) * 2,function()
                inst.SoundEmitter:PlaySound("grotto/common/archive_lockbox/use")
            end)
            inst:DoTaskInTime((45/30) * 3,function()
                inst.AnimState:PlayAnimation("use_post")
                inst:DoTaskInTime(21/30,function()
                    if inst.sfx then
                        inst.sfx:Remove()
                    end                
                    local lockbox = SpawnPrefab("archive_lockbox")
					local pt = Vector3(inst.Transform:GetWorldPosition()) + Vector3(0,2,0)
					lockbox.Transform:SetPosition(pt:Get())
					local down = TheCamera:GetDownVec()
					local angle = math.atan2(down.z, down.x) + (math.random()*60)*DEGREES
					local sp = 3 + math.random()
					lockbox.Physics:SetVel(sp*math.cos(angle), math.random()*2+8, sp*math.sin(angle))
                    inst.components.activatable.inactive = true            
                end)             
            end)  
        end

        if inst.AnimState:IsCurrentAnimation("use_post") then
            inst.AnimState:PlayAnimation("idle")
        end            
    end)
end

local function statue1fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.66)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("archive_moon_statue1.png")

    inst.AnimState:SetBank("archive_moon_statue")
    inst.AnimState:SetBuild("archive_moon_statue")
    inst.AnimState:PlayAnimation("idle_full_1")

    inst:AddTag("structure")
    inst:AddTag("statue")

    inst:SetPrefabNameOverride("archive_moon_statue")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeHauntableWork(inst)

    return inst
end

local function statue2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.66)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("archive_moon_statue2.png")

    inst.AnimState:SetBank("archive_moon_statue")
    inst.AnimState:SetBuild("archive_moon_statue")
    inst.AnimState:PlayAnimation("idle_full_2")

    inst:AddTag("structure")
    inst:AddTag("statue")

    inst:SetPrefabNameOverride("archive_moon_statue")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork2)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeHauntableWork(inst)

    return inst
end

local function statue3fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.66)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("archive_moon_statue3.png")

    inst.AnimState:SetBank("archive_moon_statue")
    inst.AnimState:SetBuild("archive_moon_statue")
    inst.AnimState:PlayAnimation("idle_full_3")

    inst:AddTag("structure")
    inst:AddTag("statue")

    inst:SetPrefabNameOverride("archive_moon_statue")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork3)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeHauntableWork(inst)

    return inst
end

local function statue4fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.66)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("archive_moon_statue4.png")

    inst.AnimState:SetBank("archive_moon_statue")
    inst.AnimState:SetBuild("archive_moon_statue")
    inst.AnimState:PlayAnimation("idle_full_4")

    inst:AddTag("structure")
    inst:AddTag("statue")

    inst:SetPrefabNameOverride("archive_moon_statue")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork4)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeHauntableWork(inst)

    return inst
end

local function rune1fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.66)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("archive_runes.png")

    inst.AnimState:SetBank("archive_rune")
    inst.AnimState:SetBuild("archive_runes")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddTag("statue")

    inst:SetPrefabNameOverride("archive_rune_statue")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus
	
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork_rune1)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeHauntableWork(inst)

    return inst
end

local function rune2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.66)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("archive_runes.png")

    inst.AnimState:SetBank("archive_rune")
    inst.AnimState:SetBuild("archive_runes")
    inst.AnimState:PlayAnimation("idle2")

    inst:AddTag("structure")
    inst:AddTag("statue")

    inst:SetPrefabNameOverride("archive_rune_statue")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus
	
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork_rune2)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeHauntableWork(inst)

    return inst
end

local function rune3fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 0.66)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("archive_runes.png")

    inst.AnimState:SetBank("archive_rune")
    inst.AnimState:SetBuild("archive_runes")
    inst.AnimState:PlayAnimation("idle3")

    inst:AddTag("structure")
    inst:AddTag("statue")

    inst:SetPrefabNameOverride("archive_rune_statue")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
	inst.components.inspectable.getstatus = getstatus
	
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.MARBLEPILLAR_MINE)
	inst.components.workable:SetOnWorkCallback(onwork_rune3)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    MakeHauntableWork(inst)

    return inst
end

local function deskfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.5)
    inst.Light:SetRadius(0.5)
    inst.Light:SetColour(237/255, 237/255, 209/255)
    inst.Light:Enable(false)

	MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("archive_security_desk")
    inst.AnimState:SetBuild("archive_security_desk")
    inst.AnimState:PlayAnimation("idle_leave")

	inst:AddTag("structure")
	inst:AddTag("desk")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3, 4)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    return inst
end

local function fountain1fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("archive_knowledge_dispensary.png")
	
	MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("knowledge_dispensary")
    inst.AnimState:SetBuild("archive_knowledge_dispensary")
    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("moss")

	inst:AddTag("structure")
	inst:AddTag("fountain")
	
	inst:SetPrefabNameOverride("archive_lockbox_dispencer")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("activatable")
    inst.components.activatable.quickaction = true
    inst.components.activatable.OnActivate = OnActivateFountain
	
	--[[
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3, 4)
    inst.components.playerprox:SetOnPlayerNear(onnear_fountain)
    inst.components.playerprox:SetOnPlayerFar(onfar_fountain)
	]]--
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    return inst
end

local function fountain2fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("archive_knowledge_dispensary_b.png")
	
	MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("knowledge_dispensary")
    inst.AnimState:SetBuild("archive_knowledge_dispensary")
	inst.AnimState:AddOverrideBuild("archive_knowledge_dispensary_b")
    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("moss")

	inst:AddTag("structure")
	inst:AddTag("fountain")
	
	inst:SetPrefabNameOverride("archive_lockbox_dispencer")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("activatable")
    inst.components.activatable.quickaction = true
    inst.components.activatable.OnActivate = OnActivateFountain
	
	--[[
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3, 4)
    inst.components.playerprox:SetOnPlayerNear(onnear_fountain)
    inst.components.playerprox:SetOnPlayerFar(onfar_fountain)
	]]--
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    return inst
end

local function fountain3fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("archive_knowledge_dispensary_c.png")
	
	MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("knowledge_dispensary")
    inst.AnimState:SetBuild("archive_knowledge_dispensary")
	inst.AnimState:AddOverrideBuild("archive_knowledge_dispensary_c")
    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("moss")

	inst:AddTag("structure")
	inst:AddTag("fountain")
	
	inst:SetPrefabNameOverride("archive_lockbox_dispencer")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("activatable")
    inst.components.activatable.quickaction = true
    inst.components.activatable.OnActivate = OnActivateFountain
	
	--[[
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3, 4)
    inst.components.playerprox:SetOnPlayerNear(onnear_fountain)
    inst.components.playerprox:SetOnPlayerFar(onfar_fountain)
	]]--
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    return inst
end

local function fountain4fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("archive_knowledge_dispensary_d.png")
	
	MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("knowledge_dispensary")
    inst.AnimState:SetBuild("archive_knowledge_dispensary")
	inst.AnimState:AddOverrideBuild("archive_knowledge_dispensary_d")
    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("moss")

	inst:AddTag("structure")
	inst:AddTag("fountain")
	
	inst:SetPrefabNameOverride("archive_lockbox_dispencer")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("activatable")
    inst.components.activatable.quickaction = true
    inst.components.activatable.OnActivate = OnActivateFountain
	
	--[[
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3, 4)
    inst.components.playerprox:SetOnPlayerNear(onnear_fountain)
    inst.components.playerprox:SetOnPlayerFar(onfar_fountain)
	]]--
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    return inst
end

local function fountain5fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("archive_knowledge_dispensary_e.png")
	
	MakeObstaclePhysics(inst, 0.66)

    inst.AnimState:SetBank("knowledge_dispensary")
    inst.AnimState:SetBuild("archive_knowledge_dispensary")
	inst.AnimState:AddOverrideBuild("archive_knowledge_dispensary_e")
    inst.AnimState:PlayAnimation("idle", true)
	inst.AnimState:Hide("moss")

	inst:AddTag("structure")
	inst:AddTag("fountain")
	
	inst:SetPrefabNameOverride("archive_lockbox_dispencer")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
	
	inst:AddComponent("activatable")
    inst.components.activatable.quickaction = true
    inst.components.activatable.OnActivate = OnActivateFountain
	
	--[[
	inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3, 4)
    inst.components.playerprox:SetOnPlayerNear(onnear_fountain)
    inst.components.playerprox:SetOnPlayerFar(onfar_fountain)
	]]--
	
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
    return inst
end

local function switchfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
	local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("archive_power_switch.png")

    inst.AnimState:SetBank("archive_switch")
    inst.AnimState:SetBuild("archive_switch")
    inst.AnimState:PlayAnimation("idle_empty")

    inst:AddTag("gemsocket")
    inst:AddTag("structure")
    inst:AddTag("trader")
	
	inst:SetPrefabNameOverride("archive_switch")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

	inst:AddComponent("lootdropper")
	
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatusSwitch

    inst:AddComponent("pickable")
    inst.components.pickable.caninteractwith = false
    inst.components.pickable.onpickedfn = OnGemTaken

    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(ItemTradeTestSwitch)
    inst.components.trader.onaccept = OnGemGiven
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetWorkLeft(4)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst.DestroyGemFn = DestroyGem

    inst:ListenForEvent("animover", function() 
        if inst.AnimState:IsCurrentAnimation("activate") then
            inst.AnimState:PlayAnimation("idle_full")
            checkforgems(inst)
        end
        if inst.AnimState:IsCurrentAnimation("deactivate") then
            inst.AnimState:PlayAnimation("idle_empty")
        end        
    end)
	
	local function createExtras(inst)
	inst.towerprefab =  SpawnPrefab("kyno_archive_switch_pad")
	inst.towerprefab.entity:SetParent(inst.entity)
	end
	
	inst:DoTaskInTime(FRAMES * 1, createExtras)

    inst.OnSave = OnSaveSwitch
    inst.OnLoadPostPass = OnLoadPostPassSwitch

    return inst
end


local function switchpadfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("archive_switch_ground_small")
    inst.AnimState:SetBuild("archive_switch_ground_small")
    inst.AnimState:PlayAnimation("idle") 
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst    
end

local SWITCH_MUST_TAGS = {"archive_switch"}
local function switchbasefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("archive_switch_ground")
    inst.AnimState:SetBuild("archive_switch_ground")
    inst.AnimState:PlayAnimation("idle") 
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:DoTaskInTime(0,function()
        local x,y,z = inst.Transform:GetWorldPosition()
        local ents = TheSim:FindEntities(x,y,z, 10, SWITCH_MUST_TAGS)
        if #ents > 0 then
            local target = ents[1]
            local pos = Vector3(target.Transform:GetWorldPosition())
            local angle = inst:GetAngleToPoint(pos.x, 0, pos.z)
            inst.Transform:SetRotation(angle-90)
        end
    end)

    return inst    
end

local function portalfn()
	local inst = CreateEntity()
	
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("archive_portal.png")
	
    inst.AnimState:SetBank("archive_portal")
    inst.AnimState:SetBuild("archive_portal")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
    inst.AnimState:SetFinalOffset(2) 
	
	inst.Transform:SetEightFaced()
    
	inst:AddTag("structure")
	inst:AddTag("notarget")
	inst:AddTag("NOBLOCK")
	inst:AddTag("the_gorge_gateway")
	
	inst:SetPrefabNameOverride("archive_portal")
	
	inst.entity:SetPristine()
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createBase(inst)
	inst.baseprefab =  SpawnPrefab("kyno_archive_portal_base")
	inst.baseprefab.entity:SetParent(inst.entity)
	end
	
	inst:AddComponent("lootdropper")
	inst:AddComponent("inspectable")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
	inst:DoTaskInTime(FRAMES * 1, createBase)
	
    return inst
end

local function basefn()
    local inst = CreateEntity()
	
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()
    
    inst.AnimState:SetBank("archive_portal_base")
    inst.AnimState:SetBuild("archive_portal_base")
    inst.AnimState:PlayAnimation("idle")
	inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
	inst.AnimState:SetLayer(LAYER_BACKGROUND)
	inst.AnimState:SetSortOrder(1)
    inst.persists = false
	
	inst.Transform:SetEightFaced()
	
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	inst:AddTag("DECOR")
	inst:AddTag("notarget")
	
	inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    return inst
end

local function mainfn(pondtype)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("archive_orchestrina_main.png")

    inst.AnimState:SetBuild("archive_orchestrina_main")
    inst.AnimState:SetBank("archive_orchestrina_main")
    inst.AnimState:PlayAnimation("big_idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(2)

    inst:AddTag("structure")
	inst:AddTag("kyno_archive_orchestrina_main")
	inst:AddTag("NOBLOCK")
	
	inst.status = "off"

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	local function createBase2(inst)
	inst.baseprefab2 =  SpawnPrefab("kyno_archive_orchestrina_base")
	inst.baseprefab2.entity:SetParent(inst.entity)
	end
	
	inst.task = inst:DoPeriodicTask(0.10, function()      
        local archive = TheWorld.components.archivemanager
        if not archive or archive:GetPowerSetting() then    
            testforlockbox(inst) 
        end
    end)
	
    inst.testforlockbox = testforlockbox
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
	inst:DoTaskInTime(FRAMES * 1, createBase2)

    return inst
end

local function basefn2(pondtype)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("archive_orchestrina_main")
    inst.AnimState:SetBank("archive_orchestrina_main")
    inst.AnimState:PlayAnimation("floor_idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)

    inst:AddTag("NOCLICK")
	inst:AddTag("DECOR")
	inst:AddTag("notarget")
	inst:AddTag("NOBLOCK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    return inst
end

local function smallfn(pondtype)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    inst.AnimState:SetBuild("archive_orchestrina_main")
    inst.AnimState:SetBank("archive_orchestrina_main")
    inst.AnimState:PlayAnimation("small_idle", true)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)
	
	inst:AddTag("resonator_socket")
	inst:AddTag("NOBLOCK")

    inst:DoTaskInTime(0,function() 
        local x,y,z = inst.Transform:GetWorldPosition()
        local main = TheSim:FindEntities(x,y,z, 10, OCHESTRINA_MAIN_MUST)[1]
        if main then
            local mx,my,mz = main.Transform:GetWorldPosition()
            local angle = inst:GetAngleToPoint(mx,my,mz)
            angle = angle -180
            inst.Transform:SetRotation(angle)
        end
    end)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.task = inst:DoPeriodicTask(0.10, function() 
        local archive = TheWorld.components.archivemanager
        if not archive or archive:GetPowerSetting() then 
            testforplayers(inst) 
        end
    end)
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	
	inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)
	
	MakeHauntableWork(inst)
	
    inst.smallOff = smallOff

    return inst
end

return Prefab("kyno_archive_statue1", statue1fn, assets, prefabs),
Prefab("kyno_archive_statue2", statue2fn, assets, prefabs),
Prefab("kyno_archive_statue3", statue3fn, assets, prefabs),
Prefab("kyno_archive_statue4", statue4fn, assets, prefabs),
Prefab("kyno_archive_rune1", rune1fn, assets, prefabs),
Prefab("kyno_archive_rune2", rune2fn, assets, prefabs),
Prefab("kyno_archive_rune3", rune3fn, assets, prefabs),
Prefab("kyno_archive_desk", deskfn, assets, prefabs),
Prefab("kyno_archive_fountain1", fountain1fn, assets, prefabs),
Prefab("kyno_archive_fountain2", fountain2fn, assets, prefabs),
Prefab("kyno_archive_fountain3", fountain3fn, assets, prefabs),
Prefab("kyno_archive_fountain4", fountain4fn, assets, prefabs),
Prefab("kyno_archive_fountain5", fountain5fn, assets, prefabs),
Prefab("kyno_archive_switch", switchfn, assets, prefabs),
Prefab("kyno_archive_switch_pad", switchpadfn, assets, prefabs),
Prefab("kyno_archive_switch_base", switchbasefn, assets, prefabs),
Prefab("kyno_archive_portal", portalfn, assets, prefabs),
Prefab("kyno_archive_portal_base", basefn, assets, prefabs),
Prefab("kyno_archive_orchestrina_main", mainfn, assets, prefabs),
Prefab("kyno_archive_orchestrina_small", smallfn, assets, prefabs),
Prefab("kyno_archive_orchestrina_base", basefn2, assets, prefabs),
MakePlacer("kyno_archive_statue1_placer", "archive_moon_statue", "archive_moon_statue", "idle_full_1"),
MakePlacer("kyno_archive_statue2_placer", "archive_moon_statue", "archive_moon_statue", "idle_full_2"),
MakePlacer("kyno_archive_statue3_placer", "archive_moon_statue", "archive_moon_statue", "idle_full_3"),
MakePlacer("kyno_archive_statue4_placer", "archive_moon_statue", "archive_moon_statue", "idle_full_4"),
MakePlacer("kyno_archive_rune1_placer", "archive_rune", "archive_runes", "idle"),
MakePlacer("kyno_archive_rune2_placer", "archive_rune", "archive_runes", "idle2"),
MakePlacer("kyno_archive_rune3_placer", "archive_rune", "archive_runes", "idle3"),
MakePlacer("kyno_archive_desk_placer", "archive_security_desk", "archive_security_desk", "idle_leave"),
MakePlacer("kyno_archive_fountain1_placer", "knowledge_dispensary", "archive_knowledge_dispensary", "idle"),
MakePlacer("kyno_archive_fountain2_placer", "knowledge_dispensary", "archive_knowledge_dispensary_b", "idle"),
MakePlacer("kyno_archive_fountain3_placer", "knowledge_dispensary", "archive_knowledge_dispensary_c", "idle"),
MakePlacer("kyno_archive_fountain4_placer", "knowledge_dispensary", "archive_knowledge_dispensary_d", "idle"),
MakePlacer("kyno_archive_fountain5_placer", "knowledge_dispensary", "archive_knowledge_dispensary_e", "idle"),
MakePlacer("kyno_archive_switch_placer", "archive_switch", "archive_switch", "idle_empty"),
MakePlacer("kyno_archive_portal_placer", "archive_portal", "archive_portal", "idle", true),
MakePlacer("kyno_archive_orchestrina_main_placer", "archive_orchestrina_main", "archive_orchestrina_main", "floor_idle", true),
MakePlacer("kyno_archive_orchestrina_small_placer", "archive_orchestrina_main", "archive_orchestrina_main", "small_idle", true)