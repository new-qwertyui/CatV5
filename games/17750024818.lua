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

local bedwars, store, vapeEvents = {}, {}, setmetatable({}, {
    __index = function(self, index)
        self[index] = Instance.new('BindableEvent')
        return self[index]
    end
})

run(function()
    bedwars = setmetatable({
        Client = {Cache = {}, Get = function(self, remote)
            local event = self.Cache[remote]
            if event then
                return event
            else
                local rem = replicatedStorage.Remotes:FindFirstChild(remote)
                if rem then
                    self.Cache[remote] = rem.ClassName == 'RemoteFunction' and {CallServer = function(self, ...)
                        return rem:InvokeServer(...)
                    end} or {SendToServer = function(self, ...)
                        rem:FireServer(...)
                    end}
                    self.Cache[remote].instance = rem
                end
            end
            return self.Cache[remote]
        end}
    }, {})

    bedwars.Client.__index = bedwars.Client

    -- signals init

    vape:Clean(bedwars.Client:Get('SendNotification').instance.OnClientEvent:Connect(function(text)
        text = text and string.gsub(text, '<[^>]+>', '')
        if text and text:find('BED DESTROYED') then
            local team = text:sub(0, 1)
            for i = 2, #text do
                if text:sub(1, i):find(' ') then
                    break
                else
                    team = text:sub(1, i):lower()
                end
            end
            team = team:sub(0, 1):upper().. team:sub(2, #team):lower()
            warn('bed broken!', team)
            vapeEvents.BedwarsBedBreak:Fire({
                brokenBedTeam = {
                    id = team
                },
                player = nil
            })
        end
    end))

    vape:Clean(bedwars.Client:Get('DisplayWinner').instance.OnClientEvent:Connect(function(team, players)
        vapeEvents.MatchEndEvent:Fire({
            teamWinner = team,
            winners = players
        })
    end))

    vape:Clean(bedwars.Client:Get('KillFeed').instance.OnClientEvent:Connect(function(from, died, cause)
        vapeEvents.EntityDeathEvent:Fire({
            fromEntity = died,
            entityInstance = from,
            Cause = cause
        })
    end))
end)

run(function()
	local AutoToxic
	local GG
	local Toggles, Lists, said, dead = {}, {}, {}
	
	local function sendMessage(name, obj, default)
		local tab = Lists[name].ListEnabled
		local custommsg = #tab > 0 and tab[math.random(1, #tab)] or default
		if not custommsg then return end
		if #tab > 1 and custommsg == said[name] then
			repeat 
				task.wait() 
				custommsg = tab[math.random(1, #tab)] 
			until custommsg ~= said[name]
		end
		said[name] = custommsg
	
		custommsg = custommsg and custommsg:gsub('<obj>', obj or '') or ''
		if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
			textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync(custommsg)
		else
			replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(custommsg, 'All')
		end
	end
	
	AutoToxic = vape.Categories.Utility:CreateModule({
		Name = 'Auto Toxic',
		Function = function(callback)
			if callback then
				AutoToxic:Clean(vapeEvents.BedwarsBedBreak.Event:Connect(function(bedTable)
					if Toggles.BedDestroyed.Enabled and bedTable.brokenBedTeam.id == lplr:GetAttribute('Team') then
						sendMessage('BedDestroyed', (bedTable.player.DisplayName or bedTable.player.Name), ':( | <obj>')
					elseif Toggles.Bed.Enabled and bedTable.player.UserId == lplr.UserId then
						local team = bedwars.QueueMeta[store.queueType].teams[tonumber(bedTable.brokenBedTeam.id)]
						sendMessage('Bed', team and team.displayName:lower() or 'white', 'cat v5 ate ur bed, sorry it was hungry | <obj>')
					end
				end))
				AutoToxic:Clean(vapeEvents.EntityDeathEvent.Event:Connect(function(deathTable)
					if deathTable.finalKill then
						local killer = playersService:GetPlayerFromCharacter(deathTable.fromEntity)
						local killed = playersService:GetPlayerFromCharacter(deathTable.entityInstance)
						if not killed or not killer then return end
						if killed == lplr then
							if (not dead) and killer ~= lplr and Toggles.Death.Enabled then
								dead = true
								sendMessage('Death', (killer.DisplayName or killer.Name), 'my gaming chair subscription expired :( | <obj>')
							end
						elseif killer == lplr and Toggles.Kill.Enabled then
							sendMessage('Kill', (killed.DisplayName or killed.Name), 'catvape is just simply better <obj>')
						end
					end
				end))
				AutoToxic:Clean(vapeEvents.MatchEndEvent.Event:Connect(function(winstuff)
					if GG.Enabled then
						if textChatService.ChatVersion == Enum.ChatVersion.TextChatService then
							textChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('gg')
						else
							replicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('gg', 'All')
						end
					end
					
					if table.find(winstuff.winners, lplr) then
						if Toggles.Win.Enabled then 
							sendMessage('Win', nil, 'no way i won') 
						end
					end
				end))
			end
		end,
		Tooltip = 'Says a message after a certain action'
	})
	GG = AutoToxic:CreateToggle({
		Name = 'AutoGG',
		Default = true
	})
	for _, v in {'Kill', 'Death', 'Bed', 'BedDestroyed', 'Win'} do
		Toggles[v] = AutoToxic:CreateToggle({
			Name = v..' ',
			Function = function(callback)
				if Lists[v] then
					Lists[v].Object.Visible = callback
				end
			end
		})
		Lists[v] = AutoToxic:CreateTextList({
			Name = v,
			Darker = true,
			Visible = false
		})
	end
end)