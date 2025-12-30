local cloneref = cloneref or function(obj)
	return obj
end

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

local performanceStats = game:GetService('Stats'):FindFirstChild('PerformanceStats')

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

local bedwars, store = {}, {}

run(function()
    local Tiers = {
        Wooden = 1,
        Stone = 2,
        Iron = 3,
        Diamond = 4,
        Emerald = 5
    }

    bedwars = setmetatable({
        ArmorData = require(replicatedStorage.Modules.ArmorData),
        getBestPickaxe = function(self)
            local pickaxes = {}

            for i,v in lplr.ServerBackpackFolder:GetChildren() do
                if v.Name:find('Pickaxe') then
                    table.insert(pickaxes, v.Name)
                end
            end

            table.sort(pickaxes, function(a, b)
                local a, b = a:gsub(' Pickaxe', ''), b:gsub(' Pickaxe', '')
                return Tiers[a] > Tiers[b]
            end)

            return pickaxes[1]
        end,
        getSword = function()
            local swords = {}

            for i,v in lplr.ServerBackpackFolder:GetChildren() do
                if v.Name:find('Sword') then
                    table.insert(swords, v.Name)
                end
            end

            table.sort(swords, function(a, b)
                local a, b = a:gsub(' Sword', ''), b:gsub(' Sword', '')
                return Tiers[a] > Tiers[b]
            end)

            return swords[1]
        end
    }, {
        __index = function(self, index)
            local module = replicatedStorage.Modules:FindFirstChild(index.. 'Module') or replicatedStorage.Modules:FindFirstChild(index)
            if module then
                self[index] = require(module)
            end
            return self[index]
        end
    })
end)

run(function()
	local Velocity
	local Horizontal
	local Vertical
	local Chance
	local TargetCheck
	local rand = Random.new()
	
	Velocity = vape.Categories.Combat:CreateModule({
		Name = 'Velocity',
		Function = function(callback)
			if callback then
                hooksignal(replicatedStorage.Remotes.ToolRemotes.Knockback.OnClientEvent, function(old, attachment, value)
                    if rand:NextNumber(0, 100) > Chance.Value then return end

                    local horizontals = {value.X, value.Z}
                    local vertical = value.Y       
                    
					local check = (not TargetCheck.Enabled) or entitylib.EntityPosition({
						Range = 50,
						Part = 'RootPart',
						Players = true
					})

                    if check then
                        if Horizontal.Value == 0 and Vertical.Value == 0 then return end
						horizontals[1] = (horizontals[1] or 1) * (Horizontal.Value / 100)
                        horizontals[2] = (horizontals[2] or 1) * (Horizontal.Value / 100)
						vertical = (vertical or 1) * (Vertical.Value / 100)
                    end

                    return old(attachment, Vector3.new(horizontals[1], vertical, horizontals[2]))
                end)
			else
				restoresignal(replicatedStorage.Remotes.ToolRemotes.Knockback.OnClientEvent)
			end
		end,
		Tooltip = 'Reduces knockback taken'
	})
	Horizontal = Velocity:CreateSlider({
		Name = 'Horizontal',
		Min = 0,
		Max = 100,
		Default = 0,
		Suffix = '%'
	})
	Vertical = Velocity:CreateSlider({
		Name = 'Vertical',
		Min = 0,
		Max = 100,
		Default = 0,
		Suffix = '%'
	})
	Chance = Velocity:CreateSlider({
		Name = 'Chance',
		Min = 0,
		Max = 100,
		Default = 100,
		Suffix = '%'
	})
	TargetCheck = Velocity:CreateToggle({Name = 'Only when targeting'})
end)

run(function()
    local KillAura
    local Look
    local Range

    KillAura = vape.Categories.Blatant:CreateModule({
        Name = 'Killaura',
        Function = function(call)
            if call then
                repeat
                    if entitylib.isAlive then
                        local plr = entitylib.AllPosition({
                            Range = Range.Value,
                            Part = 'RootPart',
                            Players = true,
                            Limit = 1
                        })[1]
                        local sword = bedwars:getSword()
                        if plr and sword then
                            local vec = plr.RootPart.Position * Vector3.new(1, 0, 1)
                            replicatedStorage.Remotes.ToolRemotes.OnSwordHit:FireServer(sword, CFrame.lookAt(entitylib.character.RootPart.Position, Vector3.new(vec.X, entitylib.character.RootPart.Position.Y + 0.001, vec.Z)).LookVector * 1.5, plr.Player.Character, workspace:GetServerTimeNow(), '9d')

                            task.wait(0.12)
                        end
                    end
                    task.wait()
                until not KillAura.Enabled
            end
        end
    })

    Range = KillAura:CreateSlider({
        Name = 'Range',
        Min = 1,
        Max = 18,
        Default = 18
    })
end)

run(function()
    local Breaker
    local Range

    local function getBed()
        local beds = {}

        for _, v in workspace.Beds:GetChildren() do
            if v.Name ~= lplr.Team.Name then
                table.insert(beds, {
                    Instance = v,
                    Magnitude = (entitylib.character.RootPart.Position - v.BedHitbox.Position).Magnitude
                })
            end
        end

        table.sort(beds, function(a, b)
            return a.Magnitude < b.Magnitude
        end)

        return beds[1]
    end

    Breaker = vape.Categories.Minigames:CreateModule({
        Name = 'Breaker',
        Function = function(call)
            if call then
                repeat
                    if entitylib.isAlive then
                        local bed = getBed()
                        if bed and bed.Magnitude <= Range.Value then
                            replicatedStorage.Remotes.ToolRemotes.DamageBlock:FireServer(bedwars:getBestPickaxe(), bed.Instance.BedHitbox, workspace:GetServerTimeNow())
                            task.wait(0.2)
                        end
                    end
                    task.wait()
                until not Breaker.Enabled
            end
        end
    })

    Range = Breaker:CreateSlider({
        Name = 'Range',
        Min = 1,
        Max = 35,
        Default = 35
    })
end)