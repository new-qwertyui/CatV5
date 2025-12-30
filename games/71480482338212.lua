local cloneref = cloneref or function(obj)
	return obj
end

local vapeEvents = setmetatable({}, {
    __index = function(self, index)
        self[index] = Instance.new('BindableEvent')
        return self[index]
    end
})

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local collectionService = cloneref(game:GetService('CollectionService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local starterGui = cloneref(game:GetService('StarterGui'))

local isnetworkowner = not inputService.TouchEnabled and not table.find({'Velocity', 'Xeno', 'Volcano'}, ({identifyexecutor()})[1]) and isnetworkowner or function(base)
	if identifyexecutor() == 'Volcano' then
		local suc, res = pcall(isnetworkowner, base)
		return suc and res or false
	end
	return true
end

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local assetfunction = getcustomasset

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local uipallet = vape.Libraries.uipallet
local tween = vape.Libraries.tween
local color = vape.Libraries.color
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local getfontsize = vape.Libraries.getfontsize
local getcustomasset = vape.Libraries.getcustomasset

local run = function(func)
	func()
end

local function notif(...)
	return vape:CreateNotification(...)
end

local bedwars, store = {}, {
    inventories = {},
    matchState = 0
}

local function getSword()
    local sword, damage = nil, 0

    for i, v in store.inventories do
        if bedwars.SwordMeta[i] and bedwars.SwordMeta[i].Damage > damage then
            sword, damage = v, bedwars.SwordMeta[i].Damage
        end
    end

    return sword, damage
end

local switch = os.clock();
local function switchItem(tool)
    if switch > os.clock() then return end

    replicatedStorage.Remotes.ItemsRemotes.EquipTool:FireServer(tool.Name)
    switch = os.clock() + 0.05

    return true
end

local sortmethods = {
    Damage = function(a, b)
        return a.Entity.Character:GetAttribute('LastDamageTakenTime') < b.Entity.Character:GetAttribute('LastDamageTakenTime')
    end,
    Health = function(a, b)
        return a.Entity.Health < b.Entity.Health
    end,
    Angle = function(a, b)
        local selfrootpos = entitylib.character.RootPart.Position
        local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
        local angle = math.acos(localfacing:Dot(((a.Entity.RootPart.Position - selfrootpos) * Vector3.new(1, 0, 1)).Unit))
        local angle2 = math.acos(localfacing:Dot(((b.Entity.RootPart.Position - selfrootpos) * Vector3.new(1, 0, 1)).Unit))
        return angle < angle2
    end
}

run(function()
    bedwars = setmetatable({
        SwordController = require(replicatedStorage.ToolHandlers.Sword),
        SwordMeta = require(replicatedStorage.Modules.DataModules.SwordsData),
        ProjectileMeta = require(replicatedStorage.ToolHandlers.Ranged),
        AnimationUtils = require(replicatedStorage.Modules.AnimationsUtils),
        AnimationMeta = require(replicatedStorage.Modules.DataModules.AnimationsData),
        ViewmodelUtil = require(replicatedStorage.Modules.ViewModelHandler),
        InventoryUtil = require(replicatedStorage.Modules.InventoryHandler), --> gonna be used later for my inventory handler
        Client = {}
    }, {
        __index = function(self, index)
            rawset(self, index, require(replicatedStorage.Modules[({index:gsub('Controller', '')})[1]]))
            return rawget(self, index)
        end
    })

    function bedwars.Client:SendProjectile(projectile, pos) 
        replicatedStorage.ItemRemotes.ShootProjectile:FireServer(bedwars.ProjectileMeta.TrajectoryData:Play(), projectile, Vector3.zero, pos, false)
    end

    vape:Clean(lplr.Inventory.ChildAdded:Connect(function(v) -- this is very poorly coded, sorry :c
        store.inventories[v.Name] = {   
            tool = v,
            name = v.Name,
            amount = v.Value,
            class = v:GetAttribute('Class') or 'Unknown'
        }
        
        vape:Clean(v:GetPropertyChangedSignal('Value'):Connect(function()
            store.inventories[v.Name].amount = v.Value
        end))
    end))

    vape:Clean(lplr.Inventory.ChildRemoved:Connect(function(v)
        store.inventories[v.Name] = nil
    end))

    vape:Clean(lplr:GetAttributeChangedSignal('PVP'):Connect(function()
        store.matchState = lplr:GetAttribute('PVP') and 1 or 0 
    end))

    for _, v in lplr.Inventory:GetChildren() do
        store.inventories[v.Name] = {   
            tool = v,
            name = v.Name,
            amount = v.Value,
            class = v:GetAttribute('Class') or 'Unknown'
        }
        
        vape:Clean(v:GetPropertyChangedSignal('Value'):Connect(function()
            store.inventories[v.Name].amount = v.Value
        end))
    end
end)

run(function()
    local Killaura
    local Targets
    local Sort
    local SwingRange
    local AttackRange
    local SwingDelay
    local SwingOnly

    local function getSwordData()
        local sword = getSword()

        return sword
    end

    local vm = bedwars.AnimationMeta.Swords.Swing.ViewModel
    local anim = bedwars.AnimationMeta.Swords.Swing.Animation

    warn(anim.ClassName)

    Killaura = vape.Categories.Blatant:CreateModule({
        Name = 'Killaura',
        Tooltip = 'Automatically attacks entities around you.',
        Function = function(call) 
            if call then
                local swingTime = os.clock()
                
                repeat
                    local sword = getSwordData()
                    
                    if sword then
                        local plrs = entitylib.AllPosition({
                            Range = SwingRange.Value,
                            Wallcheck = Targets.Walls.Enabled or nil,
                            Part = 'RootPart',
                            Players = Targets.Players.Enabled,
                            NPCs = Targets.NPCs.Enabled,
                            Limit = 10,
                            Sort = sortmethods[Sort.Value]
                        })

                        for _, plr in plrs do
                            if switchItem(sword.tool) then
                                if swingTime < os.clock() then
                                    warn(bedwars.SwordController.Animations)
                                    bedwars.SwordController.LastDamage = time()
                                    lplr.Character.Humanoid:LoadAnimation(anim):Play()
                                    bedwars.ViewmodelUtil.LoadAnimation(vm):Play()

                                    swingTime = os.clock() + math.max(SwingDelay.Value, 0.1)
                                end
                                
                                replicatedStorage.Remotes.ItemsRemotes.SwordHit:FireServer(plr.Character, sword.name)
                            end
                        end
                    end
                    task.wait()
                until not Killaura.Enabled
            end
        end
    })

    Targets = Killaura:CreateTargets({
        Players = true,
        NPCs = true
    })
    local methods = {'Damage', 'Distance'}
    for i in sortmethods do
        if not table.find(methods, i) then
            table.insert(methods, i)
        end
    end
    Sort = Killaura:CreateDropdown({
        Name = 'Target Mode',
        List = methods
    })

    SwingRange = Killaura:CreateSlider({
        Name = 'Swing range',
        Min = 1,
        Max = 20,
        Default = 20,
        Suffix = function(val)
            return val == 1 and 'stud' or 'studs'
        end
    })

    AttackRange = Killaura:CreateSlider({
        Name = 'Attack range',
        Min = 1,
        Max = 14,
        Default = 14,
        Suffix = function(val)
            return val == 1 and 'stud' or 'studs'
        end
    })
    SwingDelay = Killaura:CreateSlider({
        Name = 'Swing time',
        Min = 0,
        Max = 0.5,
        Default = 0.42,
        Decimal = 100
    })
end)

run(function() --> by max and monia
    local ProjectileAura
    local Targets
    local Range
    local List
    local rayCheck = RaycastParams.new()
    rayCheck.FilterType = Enum.RaycastFilterType.Include
    local projectileRemote = {InvokeServer = function() end}
    local FireDelays = {}
    task.spawn(function()
        projectileRemote = bedwars.Client:Get(remotes.FireProjectile).instance
    end)
    
    local function getAmmo(check)
        for _, item in store.inventory.inventory.items do
            if check.ammoItemTypes and table.find(check.ammoItemTypes, item.itemType) then
                return item.itemType
            end
        end
    end

    canShoot = function(item)
        print(item[1].itemType)
        return 
    end
    
    ProjectileAura = vape.Categories.Blatant:CreateModule({
        Name = 'Projectile Aura',
        Function = function(callback)
            if callback then
                repeat
                    if (workspace:GetServerTimeNow() - bedwars.SwordController.lastAttack) > 0.2 then
                        local ent = entitylib.EntityPosition({
                            Part = 'RootPart',
                            Range = Range.Value,
                            Players = Targets.Players.Enabled,
                            NPCs = Targets.NPCs.Enabled,
                            Wallcheck = Targets.Walls.Enabled
                        })
    
                        if ent then
                            local pos = entitylib.character.RootPart.Position
                            for _, data in projectiles do
                                local item, ammo, projectile, itemMeta = unpack(data)
                                if tick() > (FireDelays[item.itemType] or 0) then
                                    rayCheck.FilterDescendantsInstances = {}
                                    local meta = bedwars.ProjectileMeta[projectile]
                                    local projSpeed, gravity = meta.launchVelocity, meta.gravitationalAcceleration or 196.2
                                    local switched = switchItem(item.tool, 0.05)
                                    local calc = prediction.SolveTrajectory(pos, projSpeed, gravity, ent.RootPart.Position, ent.RootPart.Velocity, workspace.Gravity, ent.HipHeight, ent.Jumping and 42.6 or nil, rayCheck, nil, lplr:GetNetworkPing())
                                    if calc then
                                        targetinfo.Targets[ent] = tick() + 1

                                        task.spawn(function()
                                            local dir, id = CFrame.lookAt(pos, calc).LookVector, httpService:GenerateGUID(true)
                                            local shootPosition = (CFrame.new(pos, calc) * CFrame.new(Vector3.new(-bedwars.BowConstantsTable.RelX, -bedwars.BowConstantsTable.RelY, -bedwars.BowConstantsTable.RelZ))).Position
                                            --bedwars.ProjectileController:createLocalProjectile(meta, ammo, projectile, shootPosition, id, dir * projSpeed, {drawDurationSeconds = 1})
                                            local res = projectileRemote:InvokeServer(item.tool, ammo, projectile, shootPosition, pos, dir * projSpeed, id, {drawDurationSeconds = 1, shotId = httpService:GenerateGUID(false)}, workspace:GetServerTimeNow() - 0.045)
                                            if not res then
                                                FireDelays[item.itemType] = tick()
                                            else
                                                local shoot = itemMeta.launchSound
                                                shoot = shoot and shoot[math.random(1, #shoot)] or nil
                                                if shoot then
                                                    bedwars.SoundManager:playSound(shoot)
                                                end
                                            end
                                        end)

                                        FireDelays[item.itemType] = tick() + itemMeta.fireDelaySec

                                        if switched and not ign then
                                            task.wait(0.05)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                until not ProjectileAura.Enabled
            end
        end,
        Tooltip = 'Shoots people around you'
    })
    Targets = ProjectileAura:CreateTargets({
        Players = true,
        Walls = true
    })
    List = ProjectileAura:CreateTextList({
        Name = 'Projectiles',
        Default = {'arrow', 'snowball'}
    })
    Range = ProjectileAura:CreateSlider({
        Name = 'Range',
        Min = 1,
        Max = 50,
        Default = 50,
        Suffix = function(val)
            return val == 1 and 'stud' or 'studs'
        end
    })
end)