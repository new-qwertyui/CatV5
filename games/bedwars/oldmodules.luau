loadstring([[
    getgenv().LPH_NO_VIRTUALIZE = LPH_NO_VIRTUALIZE or function(func) return func end
	getgenv().LPH_JIT = LPH_JIT or function(func) return func end
    getgenv().LPH_JIT_MAX = LPH_JIT_MAX or function(func) return func end
]])()

if not shared.vape.Libraries.Cat or not shared.vape.Libraries.pathfind then
    while true do end
    return
end

--[[
    Variables
]]

local cloneref = cloneref or function(obj)
	return obj
end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local teleportService = cloneref(game:GetService('TeleportService'))
local httpService = cloneref(game:GetService('HttpService'))
local collectionService = cloneref(game:GetService('CollectionService'))

local isnetworkowner = function(base)
	if not base or table.find({'Velocity', 'Xeno'}, ({identifyexecutor()})[1]) then
		return true
	end
	if identifyexecutor() == 'Volcano' then
		local suc, res = pcall(isnetworkowner, base)
		return suc and res or false
	end
	return isnetworkowner(base)
end

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer

local username = getgenv().username
local password = getgenv().password
local catvapedev = getgenv().catvapedev

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction

local run = function(func)
	func()
end

local getproperties = getproperties or function(part)
	local props = {}
	for i,v in {'Color', 'Material', 'MeshId', 'TextureId', 'Transparency', 'Size', 'CanCollide', 'CanTouch', 'CanQuery', 'Anchored', 'Archivable', 'CFrame', 'Parent'} do
		pcall(function()
			props[v] = part[v]
		end)
	end
	return props
end

local function notif(...)
	return vape:CreateNotification(...)
end

getgenv().CancelSwitch = os.clock()

--[[
    Premium & Security
]]

local function jsonencode(tab) --> im NOT rewriting ts
    local def = '{'
    local len = 0
    for i,v in tab do
        len += 1
    end
    local curr = 0
    for i,v in tab do   
        curr += 1
        local string = ''

        if typeof(v) == 'string' then
            string = string .. '"'.. v.. '"'
        else
            string = string.. v
        end
        if curr ~= len then
            string = string .. ','
        end
        def = def.. '\n    "'.. i.. '": '.. string
    end
    def = def.. '\n}'
    return def
end

local math_random = math.random

if math_random(1, 1) ~= math_random(1, 1) then
    while true do end
end

if math_random(1, 1) ~= 1 then
    while true do end
end

if typeof(math_random(1, 1)) ~= 'number' then
    while true do end
end

local trollagegamer18 = false
local isPremium = false
local exec, ver = identifyexecutor()

local config = {
    hash = 8,
    key = 265372253535,
    wrapper = 6,
    blacklisted = {}
}

local custom = {
    hash = math_random(1, 8),
    key = math_random(100, 700123),
    wrapper = math_random(1, 6)
}

local encrypt = function(code, custom)
    custom = custom or config
    
    if typeof(code) ~= 'number' then
        code = tostring(code)
    end

    local keys = {}
    for i = 1, #code do
        local v = code:sub(i, i)
        keys[i] = `{(v:byte() * custom.wrapper) * custom.hash}{custom.key}`
    end
    return table.concat(keys, '')
end

local decrypt = function(code, custom)
    custom = custom or config
	code = code and tostring(code) or code

    warn(custom, '???')

    local keys = code:split(tostring(custom.key));
    for i, v in keys do 
        local int = tonumber(v);
        if int then 
            pcall(function()
                local cal = (int / custom.hash) / custom.wrapper;
                keys[i] = string.char(cal);
            end);
        end;
    end;
    return table.concat(keys, '');
end

local base64 = {
	chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
}

local basedecode = function(input)
	input = input:gsub("[^A-Za-z0-9+/=]", "")
	local bytes = {}

	for i = 1, #input, 4 do
		local c1 = input:sub(i, i)
		local c2 = input:sub(i + 1, i + 1)
		local c3 = input:sub(i + 2, i + 2)
		local c4 = input:sub(i + 3, i + 3)

		local v1 = base64.chars:find(c1, 1, true)
		local v2 = base64.chars:find(c2, 1, true)
		local v3 = base64.chars:find(c3, 1, true)
		local v4 = base64.chars:find(c4, 1, true)

		if not v1 or not v2 then break end
		v1, v2 = v1 - 1, v2 - 1
		v3 = v3 and (v3 - 1) or 0
		v4 = v4 and (v4 - 1) or 0

		local b1 = (v1 * 4) + math.floor(v2 / 16)
		local b2 = ((v2 % 16) * 16) + math.floor(v3 / 4)
		local b3 = ((v3 % 4) * 64) + v4

		bytes[#bytes + 1] = string.char(b1)
		if c3 ~= "=" then bytes[#bytes + 1] = string.char(b2) end
		if c4 ~= "=" then bytes[#bytes + 1] = string.char(b3) end
	end

	return table.concat(bytes)
end

local success, err = false

if true then
    success = true
    isPremium = true
else
    local d = game:GetService('TeleportService'):GetLocalPlayerTeleportData()
    for _ = 1, 2 do
        success, err = pcall(function()
            local result = request({
                Url = 'https://api.catvape.info/login',
                Method = 'POST',
                Headers = {
                    ['Content-Type'] = 'application/json',
                    ['Authorization'] = encrypt(jsonencode({
                        hash = tostring(custom.hash),
                        key = tostring(custom.key),
                        wrapper = tostring(custom.wrapper)
                    }))
                },
                Body = jsonencode({
                    username = encrypt(username or '', custom),
                    password = encrypt(password or '', custom),
                    robloxid = lplr.Name,
                    gameid = game.PlaceId,
                    jobid = typeof(d) == 'table' and d.customMatchHash or game.JobId
                })
            })

            if result.Body:find('{') then
                error('invalid res')
                return
            else
                local __, res = pcall(function()
                    return httpService:JSONDecode(result.Body)
                end)

                if typeof(res) == 'table' then
                    error('invalid res')
                    return
                end
            end

            if result.Body:find('"') then
                if #result.Body < 25 then
                    error('invalid res')
                    return
                else
                    if decrypt(decrypt(({result.Body:gsub('"', '')})[1]), custom) == 'HWID mismatch' then
                        getgenv().catrole = 'HWID MISMATCH'
                        notif('Cat', 'HWID mismatch, Please go into the server and do /resethwid inorder to use premium again', 60, 'alert')
                        return
                    else
                        local chunk = decrypt(({result.Body:gsub('"', '')})[1])
            
                        local premiumstring = chunk:split(`"is_premium": "`)
                        local timestamp = premiumstring[2]:split(`"timestamp":`)[2]:gsub('%}', ''):gsub(`"`, '')

                        if (DateTime.now().UnixTimestamp - tonumber(basedecode(decrypt(timestamp, custom)))) < 25 then
                            isPremium = decrypt(premiumstring[2]:split('"')[1], custom) == 'True'
                            getgenv().catrole = isPremium and 'Premium' or username and password and 'Basic' or 'Guest'
                        else
                            error('Failed')
                        end

                        return
                    end
                end
            end

            
        end)

        warn(success, result)

        if success then
            break
        else
            task.wait(2)
            task.spawn(error, 'auth error -> '.. err)
        end
    end
end

if not success then
    if err and err ~= 200 then
        notif('Cat', 'Authentication is currently down right now, If you just started experiencing this please report the issue to @fuzzydevs or @maxlasertech', 7, 'warning')
    else
        notif('Cat', 'Failed to load userdata, if you think this was a mistake please report it in our server', 7, 'alert')
    end
end

--[[
    Legit
]]

run(function() --> By selunar
	local Shader

	local light = cloneref(game:GetService('Lighting'))
	local shaders = {
		Day = function()
			local terra = workspace.Terrain

			if false then
				task.spawn(function()
					local lowestPart
					local lowestSurface
					local waterHeight = 200
					
					for i,v in workspace.Map:GetDescendants() do
						if v:IsA('BasePart') and math.abs(v.Position.Y) < 2000 then
							local regionBelow = Region3.new(
								v.Position - Vector3.new(v.Size.X/2, 1, v.Size.Z/2),
								v.Position - Vector3.new(-v.Size.X/2, 5, -v.Size.Z/2)
							)
							local partsBelow = workspace:FindPartsInRegion3(regionBelow, v, 1)
					
							local regionAbove = Region3.new(
								v.Position + Vector3.new(-v.Size.X/2, 1, -v.Size.Z/2),
								v.Position + Vector3.new(v.Size.X/2, 5, v.Size.Z/2)
							)
							local partsAbove = workspace:FindPartsInRegion3(regionAbove, v, 1)
					
							if #partsBelow == 0 and #partsAbove > 0 then
								if not lowestPart or v.Position.Y < lowestPart.Position.Y then
									lowestPart = v
								end
							end
					
							if #partsAbove == 0 then
								if not lowestSurface or v.Position.Y < lowestSurface.Position.Y then
									lowestSurface = v
								end
							end
						end
					end
					
					if lowestPart and lowestSurface then
						local cframe = CFrame.new(
							lowestPart.Position.X,
							lowestPart.Position.Y - (waterHeight / 2),
							lowestPart.Position.Z
						)
					
						if lowestPart.Position.Y + (waterHeight / 2) > lowestSurface.Position.Y then
							cframe = CFrame.new(
								lowestPart.Position.X,
								lowestSurface.Position.Y - (waterHeight / 2),
								lowestPart.Position.Z
							)
						end
					
						terra:FillBlock(cframe, Vector3.new(4000, waterHeight, 4000), Enum.Material.Water)
						terra.WaterColor = Color3.fromRGB(0, 5, 40)
						terra.WaterWaveSize = 1
						terra.WaterWaveSpeed = 25
						terra.WaterTransparency = 0.05
					end
				end)
			end

			light.Ambient = Color3.fromRGB(20, 20, 20)
			light.Brightness = 2.5
			light.ColorShift_Top = Color3.fromRGB(206, 206, 206)
			light.ColorShift_Bottom = Color3.fromRGB(231, 231, 231)
			light.ExposureCompensation = -0.5
			light.EnvironmentDiffuseScale = 0.55
			light.EnvironmentSpecularScale = 0.25
			light.OutdoorAmbient = Color3.fromRGB(30, 30, 30)

			local Atmosphere = Instance.new('Atmosphere')
			Atmosphere.Color = Color3.fromRGB(103, 103, 103)
			Atmosphere.Decay = Color3.fromRGB(80, 80, 80)
			Atmosphere.Density = 0.3
			Atmosphere.Glare = 0.8
			Atmosphere.Haze = 0
			Atmosphere.Offset = 0

			local Sky = Instance.new('Sky')
			Sky.CelestialBodiesShown = true
			Sky.SkyboxBk = 'http://www.roblox.com/asset/?id=245710263'
			Sky.SkyboxDn = 'http://www.roblox.com/asset/?id=245710630'
			Sky.SkyboxFt = 'http://www.roblox.com/asset/?id=245710380'
			Sky.SkyboxLf = 'http://www.roblox.com/asset/?id=245710319'
			Sky.SkyboxRt = 'http://www.roblox.com/asset/?id=245710230'
			Sky.SkyboxUp = 'http://www.roblox.com/asset/?id=245710496'

			local Bloom = Instance.new('BloomEffect')
			Bloom.Intensity = 1
			Bloom.Size = 56
			Bloom.Threshold = 0.7

			local Bloom_2 = Instance.new('BloomEffect')
			Bloom_2.Intensity = 0
			Bloom_2.Size = 120
			Bloom_2.Threshold = 1

			local ColorCorrection = Instance.new('ColorCorrectionEffect')
			ColorCorrection.Brightness = 0.15
			ColorCorrection.Contrast = 0.5
			ColorCorrection.Saturation = 0.2
			ColorCorrection.TintColor = Color3.fromRGB(255, 245, 231)
			ColorCorrection.Enabled = false

			local ColorCorrection_2 = Instance.new('ColorCorrectionEffect')
			ColorCorrection_2.Brightness = 0.1
			ColorCorrection_2.Contrast = 0.3
			ColorCorrection_2.Saturation = -0.2

			local ColorCorrection_3 = Instance.new('ColorCorrectionEffect')
			ColorCorrection_3.Brightness = 0
			ColorCorrection_3.Contrast = 0.05
			ColorCorrection_3.Saturation = 0
			ColorCorrection_3.TintColor = Color3.fromRGB(255,255,255)

			local DepthOfField = Instance.new('DepthOfFieldEffect')
			DepthOfField.FarIntensity = 0.1
			DepthOfField.InFocusRadius = 30

			local SunRays = Instance.new('SunRaysEffect')
            SunRays.Intensity = 0.1

			local SunRays_2 = Instance.new('SunRaysEffect')
			SunRays_2.Intensity = 0.1
			SunRays_2.Spread = 0.2

			local SunRays_3 = Instance.new('SunRaysEffect')
			SunRays_3.Intensity = 0.02
			SunRays_3.Spread = 1

			Atmosphere.Parent = light
			Sky.Parent = light
			Bloom.Parent = light
			Bloom_2.Parent = light
			ColorCorrection.Parent = light
			ColorCorrection_2.Parent = light
			ColorCorrection_3.Parent = light
			DepthOfField.Parent = light
			SunRays.Parent = light
			SunRays_2.Parent = light
			SunRays_3.Parent = light

            light.ClockTime = 8

			for _, v in light:GetChildren() do
				if v.ClassName ~= 'Folder' then
					Shader:Clean(v)
				end
			end
		end
	}

	local modified = {}
	
	Shader = vape.Categories.Legit:CreateModule({
		Name = 'Shader',
		Tooltip = 'Gives your game an intersting look',
		Function = function(call)
			if call then
				for _, v in light:GetChildren() do
					if v.ClassName ~= 'Folder' then
						table.insert(modified, {
							Parent = v.Parent,
							Part = v
						})
						v.Parent = game
					end
				end

                if workspace:FindFirstChild('Clouds') then
                    for _, v in workspace.Clouds:GetChildren() do
                        table.insert(modified, {
                            Parent = v.Parent,
                            Part = v
                        })
                        v.Parent = game
                    end
                end

				shaders.Day()
			else
				for _, v in modified do
					v.Part.Parent = v.Parent
				end

				table.clear(modified)
			end
		end
	})
end)

run(function()
    local Aura

    Aura = vape.Categories.Render:CreateModule({
        Name = 'Aura',
        Function = function(call)
            if call then
               
            end
        end
    })
end)

if debug.getinfo and debug.getinfo(print, 's').func or true then
    run(function()
        local Desync  
        local Delay
        local Infinite
        local ShowPos

        local LastTeleported = 0

        local DesyncDisplay = Instance.new('Part')
        DesyncDisplay.Size = Vector3.one * 0.5
        DesyncDisplay.Transparency = 1
        DesyncDisplay.Anchored = true
        DesyncDisplay.CanCollide = false
        DesyncDisplay.CanQuery = false
        DesyncDisplay.CanTouch = false

        local Gui = Instance.new('BillboardGui', DesyncDisplay)
        Gui.LightInfluence = 1
        Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        Gui.Active = true
        Gui.ClipsDescendants = true
        Gui.AlwaysOnTop = true
        Gui.Size = UDim2.fromOffset(30, 30)


        local Image = Instance.new('ImageLabel', Gui)
        Image.Image = 'rbxassetid://94363719989471'
        Image.BackgroundTransparency = 1
        Image.Size = UDim2.new(1, 0, 1, 0)

        local function securefflag()

        end

        Desync = vape.Categories.Utility:CreateModule({
            Name = 'Desync',
            Premium = isPremium,
            Function = function(call)
                if call then
                    local Position, Started = entitylib.character.RootPart.Position, false
                    local RefreshTime, Workable = os.clock(), true
                    local res = false

                    task.spawn(function()
                        repeat
                            res = not res
                            task.wait(0.008)
                        until not Desync.Enabled
                    end)

                    Desync:Clean(runService.PreSimulation:Connect(function()
                        sethiddenproperty(lplr.Character.HumanoidRootPart, 'NetworkIsSleeping', res)

                        DesyncDisplay.Parent = ShowPos.Enabled and Position and workspace or game

                        if DesyncDisplay.Parent == workspace then
                            DesyncDisplay.Position = Position
                        end
                    end))

                    repeat
                        if entitylib.isAlive then
                            if not Infinite.Enabled and (os.clock() - LastTeleported) >= Delay.Value or not Started or os.clock() < RefreshTime then
                                Position = entitylib.character.RootPart.Position
                                Started = true
                                LastTeleported = os.clock()
                                if Workable then
                                    securefflag('NextGenReplicatorEnabledWrite4', 'false')
                                    RefreshTime = os.clock() + 0.2
                                    securefflag('refreshed')
                                end
                                Workable = false
                            else
                                if not Workable then
                                    setfflag('NextGenReplicatorEnabledWrite4', 'true')
                                end
                                Workable = true
                            end                                
                        end
                        task.wait()
                    until not Desync.Enabled
                else
                    LastTeleported = 0
                    setfflag('NextGenReplicatorEnabledWrite4', 'false')
                    DesyncDisplay.Parent = game
                end
            end
        })

        Delay = Desync:CreateSlider({
            Name = 'Delay',
            Min = 0,
            Max = 120,
            Default = 2,
            Suffix = function(val)
                return val <= 1 and 'sec' or 'secs'
            end

        })

        Infinite = Desync:CreateToggle({
            Name = 'Infinite Desync',
            Tooltip = 'Infinitely desyncs without resyncing'
        })

        ShowPos = Desync:CreateToggle({
            Name = 'Show Desynced Position',
            Default = true
        })
    end)
end

if game.GameId == 2619619496 then
    run(function()
        local bedwars = bedwars or lobbybedwars
        local SetEmote
        local EnterMode
        local Emote
        local EmoteBox

        local function dumpController(name)
            for i, v in bedwars.Knit.Controllers do
                if i:lower() == name:lower() then
                    return i, v
                end
            end
        end

        local function dumpString(str)
            str = str or ''

            if str ~= '' then
                for i in bedwars.EmoteType do
                    if i:lower():find(str) or str:find(i:lower()) then
                        return i:lower()
                    end
                end
            end

            return str
        end

        local function dumpEmote(func)
            if not func or typeof(func) ~= 'function' then
                return nil
            end

            for i, v in debug.getupvalues(func) do
                if typeof(v) == 'table' and v.new then
                    return debug.getupvalue(func, i)
                end
            end
        end

        local Custom = {
            nightmare_1 = function()
                local EmoteInstance = replicatedStorage.Assets.Effects.NightmareEmote:Clone()
                EmoteInstance.Parent = workspace
                EmoteInstance:PivotTo(CFrame.new(lplr.Character.LowerTorso.Position) - Vector3.new(0, 2, 0))
                
                bedwars.EmoteController:emote('nightmare_1', lplr)

                bedwars.EffectUtil:playEffects(
                    {EmoteInstance},
                    lplr.Character,
                    {
                        destroyAfterSec = 9e9
                    }
                )

                task.spawn(function()
                    repeat task.wait() until not entitylib.isAlive or entitylib.character.Humanoid.MoveDirection.Magnitude > 0
                    EmoteInstance:Destroy()
                end)
            end
        }

        Custom.nightmare = Custom.nightmare_1

        SetEmote = vape.Categories.Utility:CreateModule({
            Name = 'Set Emote',
            Tooltip = 'Uses selected emote.',
            Function = function(call)
                if call then
                    if entitylib.isAlive then
                        local EmoteValue = EnterMode.Value == 'Text' and dumpString(EmoteBox.Value) or Emote.Value 
                        if Custom[EmoteValue] then
                            Custom[EmoteValue]()
                        else
                            local Controller, Data = dumpController(({EmoteValue:gsub(' ', ''):gsub('_', '')})[1].. 'EmoteController')

                            if Controller then
                                local Emote = dumpEmote(Data.KnitStart)

                                if Emote then
                                    bedwars.EmoteController:emote(EmoteValue, lplr)
                                    bedwars.EmoteHandlerController:registerHandler(EmoteValue, Emote)
                                end
                            else
                                bedwars.EmoteController:emote(EmoteValue, lplr)

                                if bedwars.EmoteMeta[EmoteValue].image then
                                    local roact = bedwars.Roact.mount(bedwars.Roact.createElement(bedwars.EmoteImage, {
                                        Emote = EmoteValue
                                    }), lplr.Character)

                                    task.delay(2, bedwars.Roact.unmount, roact)
                                end
                            end
                        end
                    end

                    SetEmote:Toggle()
                end
            end
        })

        EnterMode = SetEmote:CreateDropdown({
            Name = 'Emote Mode',
            List = {'Dropdown', 'Text'},
            Default = 'Dropdown',
            Function = function(val)
                if Emote then
                    Emote.Object.Visible = val == 'Dropdown'
                end

                if EmoteBox then
                    EmoteBox.Object.Visible = val == 'Text'
                end
            end
        })

        local list = {}

        for i in bedwars.EmoteType do
            table.insert(list, i:lower())
        end

        Emote = SetEmote:CreateDropdown({
            Name = 'Emote',
            List = list,
            Default = 'nightmare_1',
        })

        EmoteBox = SetEmote:CreateTextBox({
            Name = 'Emote',
            Visible = false,
            Placeholder = 'nightmare',
            Default = 'nightmare'
        })
    end)

    if bedwars then
        local sharedConstants = require(replicatedStorage.TS['shared-constants']).CpsConstants
        local moveDirection, allow = Vector3.zero, 0
 
        if canDebug then
            local old = require(lplr.PlayerScripts.PlayerModule).controls.moveFunction

            require(lplr.PlayerScripts.PlayerModule).controls.moveFunction = function(self, vec, face)
                if moveDirection and (moveDirection ~= Vector3.zero or allow > os.clock()) and allow > os.clock() then
                    vec = moveDirection
                end
                return old(self, vec, face)
            end

            vape:Clean(function()
                require(lplr.PlayerScripts.PlayerModule).controls.moveFunction = old
            end)
        end

        --[[
            Premium
        ]]


        if isPremium then
            LPH_JIT_MAX(function()
                if trollagegamer18 then
                    run(function()
                        local AutoWin
                        local Spectate

                        AutoWin = vape.Categories.Minigames:CreateModule({
                            Name = 'Auto Win',
                            Premium = isPremium,
                            Function = function(call)
                                if call then
                                    if not vape.Modules['Player Crasher'] or not vape.Modules['Player Crasher'].Enabled then
                                        notif('Auto Win', 'Player Crasher must be enabled for Auto Win to work.', 7, 'alert')
                                        AutoWin:Toggle()
                                        return
                                    end
                                    
                                    repeat task.wait() until entitylib.isAlive and store.matchstate ~= 0

                                    repeat
                                        entitylib.character.RootPart.CFrame = CFrame.new(9e9, 9e9, 9e9)
                                        task.wait()
                                    until not AutoWin.Enabled or not isnetworkowner(lplr.Character.PrimaryPart)

                                    if AutoWin.Enabled then
                                        notif('Auto Win', 'Successfuly paused all ongoing motions', 240, 'info')

                                        repeat
                                            local plr = playersService:FindFirstChild(Spectate.Value)
                                            if plr and plr ~= lplr and plr.Character and plr.Character:FindFirstChild('HumanoidRootPart') then
                                                entitylib.character.RootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
                                            end
                                            task.wait()
                                        until not AutoWin.Enabled
                                    end
                                end
                            end,
                            Tooltip = 'Automatically wins the game for you',
                        })

                        Spectate = AutoWin:CreateTextBox({
                            Name = 'Spectate Player',
                            Placeholder = '<Name>',
                            Darker = true,
                            Visible = true
                        })
                    end)
                elseif false then
                    run(function()
                        local AutoWin
                        local PlayMode
                        local AutoSuffo
                        local Takegen
                        local MovementMode
                        local GameplayType

                        local pointA = Vector3.new(128.37783813476562, 85.4225845336914, 365.50274658203125)

                        local function getSelfBed()
                            local id = entitylib.isAlive and lplr.Character:GetAttribute('Team')
                            for _, v in collectionService:GetTagged('bed') do
                                if tonumber(id) == tonumber(v:GetAttribute('TeamId')) then
                                    return v
                                end
                            end 
                        end
                            
                        local function getBlocks()
                            local blocks = {}
                            for _, item in store.inventory.inventory.items do
                                if not table.find({'cannon', 'tnt', 'destruction_tnt'}, item.tool.Name) then
                                    local block = bedwars.ItemMeta[item.itemType].block
                                    if block then
                                        table.insert(blocks, {item.itemType, block.health, item.tool})
                                    end
                                end
                            end
                            table.sort(blocks, function(a, b) 
                                return a[2] > b[2]
                            end)
                            return blocks
                        end
                        
                        local function getPyramid(size, grid)
                            local positions = {}
                            for h = size, 0, -1 do
                                for w = h, 0, -1 do
                                    table.insert(positions, Vector3.new(w, (size - h), ((h + 1) - w)) * grid)
                                    table.insert(positions, Vector3.new(w * -1, (size - h), ((h + 1) - w)) * grid)
                                    table.insert(positions, Vector3.new(w, (size - h), (h - w) * -1) * grid)
                                    table.insert(positions, Vector3.new(w * -1, (size - h), (h - w) * -1) * grid)
                                end
                            end
                            return positions
                        end

                        local rayCheck = RaycastParams.new()
                        rayCheck.FilterType = Enum.RaycastFilterType.Exclude
                        rayCheck.RespectCanCollide = true

                        local function moveTo(position, cancelfunc, fast)
                            position = position or pointA
                            cancelfunc = cancelfunc or function() end

                            local path = loadfile('catrewrite/libraries/pathfind.lua')():FindPath(entitylib.character.RootPart.Position, position, {})

                            if path then
                                local index = 0

                                local waypoints = path.Waypoints
                                
                                repeat
                                    index += 1
                                    
                                    local v = waypoints[index]
                                    if not v then
                                        break
                                    end

                                    if typeof(v.Position) ~= 'Vector3' then
                                        index += 1
                                        task.wait()
                                        continue
                                    end

                                    local part = Instance.new('Part', workspace)
                                    part.Anchored = true
                                    part.CanQuery = false
                                    part.CanCollide = false
                                    part.Size = Vector3.one * 0.7
                                    part.Color = Color3.new(1, 1, 1)
                                    part.Position = v.Position + (Vector3.new(0, 2, 0))
                                    part.Shape = Enum.PartType.Ball
                                    part.Material = Enum.Material.Neon

                                    local teleportTime = os.clock() + (failed and 5000 or 5)
                                    local jumpTick = os.clock()

                                    repeat 
                                        if MovementMode.Value == 'Walk' then
                                            if v.Action == Enum.PathWaypointAction.Jump and lplr.Character.Humanoid.FloorMaterial ~= Enum.Material.Air and os.clock() > jumpTick then
                                                lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                                jumpTick = os.clock() + 0.5
                                            end

                                            moveDirection = CFrame.lookAt(entitylib.character.RootPart.Position, v.Position).LookVector
                                        else
                                            moveDirection = nil
                                            entitylib.character.RootPart.CFrame = CFrame.new(v.Position + Vector3.new(0, 2.4, 0))
                                            task.wait(0.2)
                                        end

                                        rayCheck.FilterDescendantsInstances = {lplr.Character}
                                        if not workspace:Raycast((entitylib.character.RootPart.Position + (lplr.Character.Humanoid.MoveDirection * 2)), Vector3.new(0, -500, 0), rayCheck) or not workspace:Raycast(entitylib.character.RootPart.Position, Vector3.new(0, -500, 0), rayCheck) then
                                            if not vape.Modules.Scaffold.Enabled then
                                                vape.Modules.Scaffold:Toggle()
                                            end
                                        else
                                            if vape.Modules.Scaffold.Enabled then
                                                vape.Modules.Scaffold:Toggle()
                                            end
                                        end

                                        task.wait() 
                                    until (entitylib.character.RootPart.Position - Vector3.new(v.Position.X, entitylib.character.RootPart.Position.Y, v.Position.Z)).Magnitude <= 0.1 or os.clock() > teleportTime or cancelfunc() or not AutoWin.Enabled

                                    if os.clock() > teleportTime then
                                        break
                                    end --> so it repath finds

                                    part:Destroy()
                                until index > #waypoints
                                
                                moveDirection = nil
                            end
                        end

                        local function getShopNPC(custom)
                            local localPosition = custom or entitylib.character.RootPart.Position
                            local shop, lastmag, id = nil, 9e9, nil
                            for _, v in store.shop do
                                local mag = (v.RootPart.Position - localPosition).Magnitude 
                                if v.RootPart.Name:find('item') and mag <= (getSelfBed() and 120 or 9e9) and mag <= lastmag then
                                    shop = v
                                    lastmag = mag
                                    id = v.Id
                                end
                            end
                            return shop, lastmag, id
                        end

                        local function fixPosition(pos)
                            return bedwars.BlockController:getBlockPosition(pos) * 3
                        end
                        
                        local suffoCache = os.clock()

                        local function isSuffoable(pos)
                            if suffoCache > os.clock() then
                                return false
                            end

                            local bestMine

                            for _, method in {Vector3.new(0, 6, 0), Vector3.new(6, 0, 0), Vector3.new(0, 0, 6)} do
                                local ray = workspace:Raycast(pos, method, rayCheck)
                                if not ray then
                                    suffoCache = os.clock() + 1
                                    return false
                                else
                                    bestMine = ray
                                end
                            end

                            return bestMine
                        end

                        local rand = Random.new()

                        local pricings = {
                            obsidian = {1, 'emerald', 2},
                            stone_brick = {40, 'iron', 1},
                            ceramic = {16, 'iron', 9},
                            wood_plank_oak = {14, 'iron', 3}
                        }
                        local bedDefending = false
                        
                        local gameplayModes = {
                            ['Bed defender'] = function()
                                local destination = nil;

                                repeat
                                    task.wait(0.1)
                                    local bed = getSelfBed()
                                    if store.matchState ~= 0 and not bed then
                                        notif('Autowin', 'Your bed has been destroyed, This callback is now disabled', 4, 'alert')
                                        break
                                    end

                                    local plr = entitylib.AllPosition({
                                        Origin = bed:GetPivot().Position,
                                        Range = 50,
                                        Part = 'RootPart',
                                        Players = true,
                                        Limit = 1,
                                        Sort = sortmethods.Distance
                                    })[1]

                                    if plr and not bedDefending then
                                        local pos = plr.RootPart.Position
                                        destination = pos
                                        moveTo(pos, function()
                                            return (entitylib.character.RootPart.Position - plr.RootPart.Position).Magnitude <= 14 or destination ~= pos
                                        end)
                                        if AutoSuffo.Enabled then
                                            

                                            local block = isSuffoable(plr.RootPart.Position)
                                            if not block and (entitylib.character.RootPart.Position - plr.RootPart.Position).Magnitude <= 18 then
                                                local item = store.hand.toolType == 'block' and store.hand.tool.Name or getWool()
                                                if item then
                                                    local needPlaced = {}
                    
                                                    for _, side in Enum.NormalId:GetEnumItems() do
                                                        side = Vector3.fromNormalId(side)
                                                        if side.Y ~= 0 then continue end
                            
                                                        side = fixPosition(plr.RootPart.Position + side * 2)
                                                        if not getPlacedBlock(side) then
                                                            table.insert(needPlaced, side)
                                                        end
                                                    end
                            
                                                    if #needPlaced < 4 then
                                                        table.insert(needPlaced, fixPosition(plr.Head.Position))
                                                        table.insert(needPlaced, fixPosition(plr.RootPart.Position - Vector3.new(0, 1, 0)))
                            
                                                        for _, pos in needPlaced do
                                                            if not getPlacedBlock(pos) then
                                                                task.spawn(bedwars.placeBlock, pos, item)
                                                            end
                                                        end
                                                    end
                                                end
                                            elseif block and (entitylib.character.RootPart.Position - block.Instance.Position).Magnitude <= 18 then
                                                local old = getHotbar(store.hand.tool)
                                                bedwars.breakBlock(block.Instance, true, true, nil, true)
                                                task.wait(0.1)
                                                hotbarSwitch(old)
                                            end
                                        end

                                        continue
                                    end

                                    local shopNPC, shopMagnitude, shopId = getShopNPC()

                                    if shopNPC and (not getWool() or ({getWool()})[2] < 32) and getItem('iron') and getItem('iron').amount >= 8 and not bedDefending then
                                        moveTo(shopNPC.RootPart.Position, function()
                                            return ({getShopNPC()})[2] <= 15
                                        end)

                                        if shopNPC and ({getShopNPC()})[2] <= 18 then
                                            for _ = 1, 4 do
                                                if getWool() and ({getWool()})[2] >= 64 then
                                                    break
                                                end
                
                                                if not getItem('iron') or getItem('iron').amount < 8 then
                                                    break
                                                end

                                                bedwars.Client:Get('BedwarsPurchaseItem'):CallServerAsync({
                                                    shopItem = {
                                                        currency = 'iron',
                                                        itemType = 'wool_white',
                                                        amount = 16,
                                                        price = 8,
                                                        category = 'Blocks'
                                                    },
                                                    shopId = shopId
                                                }):andThen(function(suc)
                                                    if suc then
                                                        bedwars.SoundManager:playSound(bedwars.SoundList.BEDWARS_PURCHASE_ITEM)
                                                        bedwars.Store:dispatch({
                                                            type = 'BedwarsAddItemPurchased',
                                                            itemType = 'wool_white'
                                                        })
                                                    end
                                                end)
                                                task.wait(0.05)
                                            end
                                        end
                                    end

                                    if shopNPC and #getBlocks() <= 2 and getItem('iron') and getItem('iron').amount >= 72 and not bedDefending then
                                        moveTo(shopNPC.RootPart.Position, function()
                                            return ({getShopNPC()})[2] <= 18
                                        end)
                                        
                                        local blocks = {'obsidian', 'wood_plank_oak', 'ceramic', 'stone_brick'}

                                        for _, v in store.inventory.inventory.items do
                                            local ind = table.find(blocks, v.tool.Name)
                                            if ind then
                                                table.remove(blocks, ind)
                                            end
                                        end

                                        for _, v in blocks do
                                            if not getItem(pricings[v][2]) or getItem(pricings[v][2]).amount < pricings[v][1] then
                                                continue
                                            end
                                            for __ = 1, pricings[v][3] do
                                                if not getItem(pricings[v][2]) or getItem(pricings[v][2]).amount < pricings[v][1] then
                                                    break
                                                end
                                                bedwars.Client:Get('BedwarsPurchaseItem'):CallServerAsync({
                                                    shopItem = {
                                                        currency = 'iron',
                                                        itemType = v,
                                                        amount = 16,
                                                        price = 8,
                                                        category = 'Blocks'
                                                    },
                                                    shopId = shopId
                                                }):andThen(function(suc)
                                                    if suc then
                                                        bedwars.SoundManager:playSound(bedwars.SoundList.BEDWARS_PURCHASE_ITEM)
                                                        bedwars.Store:dispatch({
                                                            type = 'BedwarsAddItemPurchased',
                                                            itemType = 'wool_white'
                                                        })
                                                    end
                                                end)
                                                task.wait(0.05)
                                            end
                                        end
                                    end

                                    local canbd = #getBlocks() >= 1 and (entitylib.character.RootPart.Position - bed.Position).Magnitude <= 18 and not plr
                                    task.spawn(function()
                                        if canbd and not bedDefending then
                                            local old = store.hand and store.hand.tool or nil
                                            bedDefending = true
                                            for i, block in getBlocks() do
                                                for _, pos in getPyramid(i, 3) do
                                                    if getPlacedBlock(bed.Position + pos) then continue end
                                                    switchItem(block[3], 0.1)
                                                    task.spawn(bedwars.placeBlock, bed.Position + pos, block[1], false)
                                                    task.wait(rand:NextNumber(0.08, 0.12))
                                                end
                                            end
                                            if old then
                                                switchItem(old)
                                            end
                                            bedDefending = false
                                        end
                                    end)
                                    if canbd then
                                        task.wait(0.5)
                                    elseif (entitylib.character.RootPart.Position - bed.Position).Magnitude >= 18 and not canbd then
                                        moveTo(bed.Position, function()
                                            return (entitylib.character.RootPart.Position - bed.Position).Magnitude <= 12
                                        end)
                                    end
                                until not AutoWin.Enabled
                            end
                        }

                        AutoWin = vape.Categories.Minigames:CreateModule({
                            Name = 'Auto Win',
                            Premium = isPremium,
                            Function = function(callback)
                                if callback then
                                    moveTo()
                                    --[[local enabled = false
                                    local missing = ''
                                    for i,v in {'Silent Aura', 'Killaura'} do
                                        if vape.Modules[v].Enabled then
                                            enabled = true
                                            break
                                        else
                                            missing = v
                                        end
                                    end

                                    if not enabled then
                                        AutoWin:Toggle()
                                        return notif('Autowin', missing.. ' is required for autowin to function', 4, 'warning')
                                    end

                                    if PlayMode.Value == 'Legit' then
                                        gameplayModes[GameplayType.Value]()
                                    else
                                        repeat

                                            task.wait()
                                        until not AutoWin.Enabled
                                    end]]
                                end
                            end,
                            Tooltip = 'Automatically plays the game for you, And win 85% of the time'
                        })

                        PlayMode = AutoWin:CreateDropdown({
                            Name = 'Play Mode',
                            List = {'Blatant', 'Legit'},
                            Default = 'Blatant',
                            Function = function(val)
                                if AutoSuffo then
                                    GameplayType.Object.Visible = val == 'Legit'
                                    Takegen.Object.Visible = val == 'Legit'
                                    AutoSuffo.Object.Visible = val == 'Legit'
                                end
                            end
                        })

                        GameplayType = AutoWin:CreateDropdown({
                            Name = 'Gameplay Type',
                            List = {'Juggernaut', 'Bed defender', 'Cycler'},
                            Default = 'Bed defender',
                            Darker = true
                        })
                        Takegen = AutoWin:CreateToggle({
                            Name = 'Take Generator',
                            Default = true,
                            Darker = true
                        })
                        AutoSuffo = AutoWin:CreateToggle({
                            Name = 'Auto Suffocate',
                            Darker = true,
                            Tooltip = 'Suffocates a target if theyre in ur bed defense'
                        })
                        GameplayType.Object.Visible = false
                        Takegen.Object.Visible = false
                        AutoSuffo.Object.Visible = false

                        MovementMode = AutoWin:CreateDropdown({
                            Name = 'Movement Mode',
                            List = {'Teleport', 'Walk'},
                            Default = 'Teleport'
                        })
                    end)
                end

                run(function()
                    local StaffFetcher

                    local NotifyOnline
                    local NotifyIngame
                    local NotifyInServer
                    local NotifyOffline
                    local LoopFetch
                    local FetchDelay

                    local function fetchStaff()
                        local FetchedUserIds = httpService:JSONDecode(game:HttpGet('https://raw.githubusercontent.com/itsFuzzyDev/CatSpyList/main/staffs.json'))
                        local Max = math.floor(#FetchedUserIds / 2)

                        local Staffs = {
                            v1 = {},
                            v2 = {}
                        }

                        for i = 1, Max do
                            table.insert(Staffs.v1, FetchedUserIds[i])
                        end

                        for i = Max, #FetchedUserIds do
                            table.insert(Staffs.v2, FetchedUserIds[i])
                        end

                        local Status = {}

                        notif('StaffFetcher', `Fetching a total of {#FetchedUserIds} Staff accounts`, 25, 'info')

                        for _, v in Staffs do
                            local Response = request({
                                Url = 'https://presence.roblox.com/v1/presence/users',
                                Headers = {
                                    ['Content-Type'] = 'application/json'
                                },
                                Body = httpService:JSONEncode({
                                    userIds = v
                                }),
                                Method = 'POST'
                            }).Body 

                            pcall(function()
                                for _, v2 in httpService:JSONDecode(Response).userPresences do
                                    table.insert(Status, v2)
                                end
                            end)
                        end

                        local offlines = 0

                        if #Status > 10 then
                            for _, v in Status do
                                local name = playersService:GetNameFromUserIdAsync(v.userId)

                                if (NotifyIngame.Enabled or NotifyInServer.Enabled) and (v.userPresenceType == 2 or NotifyInServer.Enabled) then
                                    if NotifyInServer.Enabled and playersService:GetPlayerByUserId(v.userId) then
                                        notif('StaffFetcher', `{name} is in game and in ur server`, 10, 'alert')
                                    elseif NotifyIngame.Enabled and v.userPresenceType == 2 then
                                        notif('StaffFetcher', `{name} is in game and may be in bedwars`, 10, 'info')
                                    end
                                end

                                if NotifyOnline.Enabled and v.userPresenceType == 1 then
                                    notif('StaffFetcher', `{name} is online`, 10, 'info')
                                end

                                if v.userPresenceType == 0 then
                                    offlines += 1
                                end
                            end
                        end

                        if NotifyOffline.Enabled then
                            notif('StaffFetcher', `{#Status} out of {offlines} are offline`, 10, 'alert')
                        end
                    end

                    StaffFetcher = vape.Categories.Utility:CreateModule({
                        Name = 'Staff Fetcher',
                        Tooltip = 'Fetches staff\'s statuses',
                        Premium = isPremium,
                        Function = function(call)
                            if call then
                                fetchStaff()

                                local Clock = os.clock()

                                repeat
                                    if LoopFetch.Enabled and (os.clock() - Clock) >= FetchDelay.Value then
                                        fetchStaff() 
                                        Clock = os.clock()
                                    end
                                    task.wait()
                                until not StaffFetcher.Enabled
                            end
                        end
                    })

                    LoopFetch = StaffFetcher:CreateToggle({
                        Name = 'Loop Fetch',
                        Function = function(call)
                            if FetchDelay then
                                FetchDelay.Object.Visible = call
                            end
                        end
                    })

                    FetchDelay = StaffFetcher:CreateSlider({
                        Name = 'Delay',
                        Min = 2,
                        Max = 240,
                        Default = 120,
                        Suffix = ' secs',
                        Darker = true,
                        Visible = false
                    })

                    NotifyOffline = StaffFetcher:CreateToggle({
                        Name = 'Notify All Offline',
                        Tooltip = 'Notifies if all staffs are offline',
                        Default = true
                    })

                    NotifyIngame = StaffFetcher:CreateToggle({
                        Name = 'Notify In game',
                        Default = true
                    })

                    NotifyInServer = StaffFetcher:CreateToggle({
                        Name = 'Notify In server',
                        Default = true
                    })

                    NotifyOnline = StaffFetcher:CreateToggle({
                        Name = 'Notify Online',
                        Default = false
                    })
                end)
                
                run(function()
                    local BackTrack
                    local RenderPosition
                    local Latency
                    local Color

                    local RootParts = {}

                    local ServerPosition = Instance.new('Part', workspace)
                    ServerPosition.Size = Vector3.new(3, 6, 3)
                    ServerPosition.CanCollide = false
                    ServerPosition.CanQuery = false
                    ServerPosition.Massless = true
                    ServerPosition.Material = Enum.Material.Neon
                    ServerPosition.Transparency = 1

                    local onGoing = {}

                    local function moveTo(character, waypoints)
                        if character then
                            local Hitbox = character.PrimaryPart:Clone()
                            BackTrack:Clean(Hitbox)
                            Hitbox.Size = Vector3.new(3, 6, 3)
                            Hitbox.Parent = character

                            RootParts[Hitbox] = true

                            for _, v in character:GetDescendants() do
                                if v:IsA('Weld') or v:IsA('Motor6D') then
                                    if v.Part0 == character.PrimaryPart then v.Part0 = Hitbox end
                                    if v.Part1 == character.PrimaryPart then v.Part1 = Hitbox end
                                end
                            end

                            task.wait(Latency:GetRandomValue() / 1000)
                            for i,v in waypoints do
                                Hitbox.CFrame = v
                                Hitbox.Velocity = Vector3.zero
                            end	

                            for _, v in character:GetDescendants() do
                                if v:IsA('Weld') or v:IsA('Motor6D') then
                                    if v.Part0 == Hitbox then v.Part0 = character.PrimaryPart end
                                    if v.Part1 == Hitbox then v.Part1 = character.PrimaryPart end
                                end
                            end

                            RootParts[Hitbox] = nil

                            Hitbox:Destroy()
                        end
                    end

                    BackTrack = vape.Categories.Utility:CreateModule({
                        Name = 'Back Track',
                        Premium = isPremium,
                        Function = function(call)
                            if call then
                                repeat
                                    task.spawn(function()
                                        local ents = entitylib.AllPosition({
                                            Range = 50,
                                            Part = 'RootPart',
                                            Players = true,
                                            Limit = 500
                                        })

                                        for i, v in ents do
                                            if not onGoing[v.Player] then
                                                onGoing[v.Player] = true
                                                moveTo(v.Character, {v.RootPart.CFrame})
                                                onGoing[v.Player] = nil
                                            end
                                        end
                                    end)
                                    for i, v in RootParts do
                                        if v then
                                            i.AssemblyLinearVelocity = Vector3.new(0, 1, 0)
                                            i.AssemblyAngularVelocity = Vector3.zero
                                        end
                                    end
                                    task.wait()
                                until not BackTrack.Enabled
                            end
                        end,
                        Tooltip = 'Lags you at certain times to increase attack distance, Essentially a ping spoof'
                    })

                    Latency = BackTrack:CreateTwoSlider({
                        Name = 'Latency',
                        Min = 1,
                        Max = 500,
                        DefaultMin = 30,
                        DefaultMax = 100
                    })

                    RenderPosition = BackTrack:CreateToggle({
                        Name = 'Render server pos',
                        Default = true
                    })

                    Color = BackTrack:CreateColorSlider({
                        Name = 'Color',
                        Default = Color3.new(1, 1, 1)
                    })
                end)

                run(function() --> by max and outer
                    local HackerDetector

                    local Cache = {
                        CFrames = {},
                        Velocities = {},
                        Hackers = {},
                        UpdateTimes = {}
                    }

                    local Damages = {}		

                    local Checks = {
                        --[[CFrame = {
                            YLevel = function(new, old, velo)
                                if velo.Y < -120 then
                                    return false
                                end
                                return (new.Y - old.Y) > 130 or (new.Y - old.Y) < -130 or false
                            end,
                        },
                        Velocity = {
                            YLevel = function(new, old)
                                if new.Y < -20 or old.Y < -20 then
                                    return false
                                end
                                return (new.Y - old.Y) > 90 
                            end
                        },]]
                        Modules = {
                            Killaura = function()
                                local Cooldowns = {}
                                local Excludes = {lplr.Name}

                                HackerDetector:Clean(vapeEvents.EntityDamageEvent.Event:Connect(function(damageTable)
                                    if damageTable.entityInstance == lplr.Character and damageTable.fromEntity and damageTable.fromEntity.Parent == workspace and not table.find(Excludes, damageTable.fromEntity.Name) then
                                        local lastAttack = os.clock() - (Damages[damageTable.fromEntity] or os.clock())
                                        if not Cooldowns[damageTable.fromEntity] then
                                            Cooldowns[damageTable.fromEntity] = {}
                                        end
                                        if lastAttack <= 0.1 then
                                            local res = os.clock() + 0.5
                                            table.insert(Cooldowns[damageTable.fromEntity], res)
                                            
                                            task.delay(0.5, function()
                                                local fr = table.find(Cooldowns[damageTable.fromEntity], res)
                                                if fr then
                                                    table.remove(Cooldowns[damageTable.fromEntity], fr)
                                                end
                                            end)
                                        end
                                        if #Cooldowns[damageTable.fromEntity] >= 4 then
                                            vapeEvents.HackerSignal:Fire(playersService:GetPlayerFromCharacter(damageTable.fromEntity))
                                            table.insert(Excludes, damageTable.fromEntity.Name)
                                        end
                                        Damages[damageTable.fromEntity] = os.clock()
                                    end
                                end))
                            end
                        }
                    }

                    local usernames = {}
                    local nothashed = {}

                    local function fetchCheaters()
                        local url = 'https://api.rblx.date/searchcheaters?hash='.. table.concat(usernames, ',')
                        local result = request({
                            Url = url,
                            Method = 'GET'
                        })

                        if result.StatusCode == 200 then
                            local res = httpService:JSONDecode(result.Body)
                            if res.success and res.data then
                                for configname, v in res.data do
                                    local omg = v.userid and game:HttpGet('https://discordlookup.mesalytic.moe/v1/user/'.. v.userid) or nil
                                    local _, __ = pcall(function()
                                        omg = httpService:JSONDecode(omg)
                                    end)

                                    local discordData = typeof(omg) == 'table' and ' ('.. omg.global_name.. ', @'.. omg.username .. ')' or ''

                                    whitelist.customtags[nothashed[v.hash]] = {{text = configname:upper().. ' WHITELISTED', color = Color3.new(1, 0, 0)}}
                                    notif('HackerDetector', nothashed[v.hash].. ' is whitelisted in '.. configname:upper()..' and may be using exploits'..discordData, 20, 'alert')
                                end
                            end
                        else
                            notif('HackerDetector', 'Failed to fetch cheaters', 8, 'alert')
                        end
                    end

                    HackerDetector = vape.Categories.Utility:CreateModule({
                        Name = 'Hacker Detector',
                        Premium = isPremium,
                        Function = function(call)
                            if call then
                                for _, v in playersService:GetPlayers() do
                                    if not nothashed[v.Name] then
                                        local res = vape.Libraries.hash.sha512(v.Name..v.UserId.. 'SelfReport')
                                        table.insert(usernames, res)
                                        nothashed[res] = v.Name
                                    end
                                end

                                task.spawn(fetchCheaters)

                                HackerDetector:Clean(playersService.PlayerAdded:Connect(function(v)
                                    if not nothashed[v.Name] then
                                        local res = vape.Libraries.hash.sha512(v.Name..v.UserId.. 'SelfReport')
                                        table.insert(usernames, res)
                                        nothashed[res] = v.Name

                                        spawn(fetchCheaters)
                                    end
                                end))
                                
                                HackerDetector:Clean(vapeEvents.HackerSignal.Event:Connect(function(v)
                                    Cache.Hackers[v.Name] = true
                                    whitelist.customtags[v.Name] = {{text = 'CHEATER', color = Color3.new(1, 0, 0)}}
                                    table.insert(shared.vape.hackerTable, v)
                                    notif('HackerDetector', v.Name.. ' is using exploits', 20, 'warning')
                                end))

                                for _, v in Checks.Modules do
                                    v()
                                end
                            else
                                table.clear(Cache.CFrames)
                            end
                        end
                    })
                end)

                run(function() --> by max
                    local ServerHop

                    ServerHop = vape.Categories.World:CreateModule({
                        Name = 'Server Hop',
                        Premium = isPremium,
                        Function = function(call)
                            if call then
                                ServerHop:Toggle()
                                notif('Vape', 'Found! Teleporting.', 5)
                                task.wait(0.5)
                                teleportService:Teleport(game.PlaceId, lplr, teleportService:GetLocalPlayerTeleportData())
                            end
                        end
                    })
                end)
            end)()
        end

        --[[
            Combat
        ]]

        local clutchActive = false
        LPH_NO_VIRTUALIZE(function()
            run(function() --> by max
                local AutoCharge
                local Delay
                
                local start, old = os.clock()

                AutoCharge = vape.Categories.Combat:CreateModule({
                    Name = 'Auto Charge',
                    Function = function(call)
                        if call then
                            old = bedwars.SwordChargeController.startCharging
                            bedwars.SwordChargeController.startCharging = function(args, ...)
                                local res = old(args, ...)
                                args.chargeStartTime = tick() - Delay.Value
                                return res
                            end
                        else
                            bedwars.SwordChargeController.startCharging = old
                            old = nil
                        end
                    end,
                    Tooltip = 'Allows you to get charged hits while spam clicking'
                })

                Delay = AutoCharge:CreateSlider({
                    Name = 'Charge Time',
                    Min = 0,
                    Max = 1,
                    Default = 0,
                    Decimal = 5
                })
            end)

            run(function() --> by max, selunar and monia
                local SilentAura
                local SwingDelay
                local AimMode
                local Targets
                local AimSpeed
                local Attacks
                local IncreaseAttackRange
                local AttackRange
                local ExtraSwingDistance
                local Angle
                local TargetMode
                local Mouse
                local SwingM
                local SwingOnly
                local SwingO
                local ThirdPerson

                local rand = Random.new()
                local AttackRemote = bedwars.Client:Get(remotes.AttackEntity).instance
                local lastAttack = os.clock()
                local lastSwing = os.clock()

                local function getAttackData()
                    if bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then return false end

                    local sword = store.hand
                    if not sword or not sword.tool then return false end

                    local meta = bedwars.ItemMeta[sword.tool.Name]
                    if store.hand.toolType ~= 'sword' or bedwars.DaoController.chargingMaid then return false end
                    
                    if SwingOnly.Enabled and (tick() - bedwars.SwordController.lastSwing) > 0.33 then
                        return false
                    end

                    if Mouse.Enabled then
                        if not inputService:IsMouseButtonPressed(0) then return false end
                    end

                    return sword, meta
                end

                SilentAura = vape.Categories.Combat:CreateModule({
                    Name = 'Silent Aura',
                    Function = function(callback)
                        if callback then
                            local newIndex = 1
                            local canSwitch = os.clock()
                            local entity
                            local expire = os.clock()

                            SilentAura:Clean(runService.PreRender:Connect(function(dt)
                                if not clutchActive and not vape.Modules['Block-In'].Enabled then
                                    if entitylib.isAlive and lplr.Character:FindFirstChild('Humanoid') then
                                        if expire > os.clock() then
                                            lplr.Character.Humanoid.AutoRotate = (not ThirdPerson.Enabled or AimMode.Value ~= 'Player')
                                        else
                                            lplr.Character.Humanoid.AutoRotate = true
                                        end
                                    end
                                    if expire > os.clock() and entity then
                                        if AimMode.Value ~= 'None' then
                                            if ThirdPerson.Enabled then
                                                entitylib.character.RootPart.CFrame = entitylib.character.RootPart.CFrame:Lerp(CFrame.lookAt(entitylib.character.RootPart.Position, Vector3.new(entity.RootPart.Position.X, entitylib.character.RootPart.Position.Y, entity.RootPart.Position.Z)), AimSpeed.Value * dt)
                                            else
                                                gameCamera.CFrame = gameCamera.CFrame:Lerp(CFrame.lookAt(gameCamera.CFrame.p, entity.RootPart.Position), AimSpeed.Value * runService.PostSimulation:Wait())
                                            end
                                        end
                                    end
                                end
                            end))

                            repeat
                                task.wait()
                                if entitylib.isAlive then
                                    local reach = bedwars.CombatConstant.RAYCAST_SWORD_CHARACTER_DISTANCE
                                    local localPosition = entitylib.character.RootPart.Position

                                    local ent, sword, meta = entitylib.AllPosition({
                                        Origin = localPosition,
                                        Range = reach + ExtraSwingDistance.Value,
                                        Wallcheck = Targets.Walls.Enabled or nil,
                                        Part = 'RootPart',
                                        Players = Targets.Players.Enabled,
                                        NPCs = Targets.NPCs.Enabled,
                                        Limit = 1,
                                        Sort = sortmethods[TargetMode.Value]
                                    })[newIndex], getAttackData()

                                    store.KillauraTarget = sword and ent
                                    entity = sword and ent or nil

                                    if entity and sword then
                                        expire = os.clock() + 0.11								
                                    end

                                    if (os.clock() - lastAttack) >= (0.1 / Attacks:GetRandomValue()) then
                                        if ent and sword then
                                            local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
                                            local delta = (ent.RootPart.Position - localPosition)
                                            local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
                                            if angle > (math.rad(Angle.Value) / 2) then 
                                                continue 
                                            end

                                            targetinfo.Targets[ent] = os.clock() + 1

                                            if (os.clock() - lastSwing) >= SwingDelay.Value and (not Mouse.Enabled or SwingM.Enabled) and (not SwingOnly.Enabled or SwingO.Enabled) then
                                                bedwars.SwordController:playSwordEffect(meta, false)
                                                bedwars.SwordController.lastSwing = tick()
                                                lastSwing = os.clock()
                                            end

                                            if delta.Magnitude > (math.random(11, reach) + (IncreaseAttackRange.Enabled and AttackRange.Value or 0)) then 
                                                continue
                                            end

                                            if (os.clock() - canSwitch) > 0.22 then
                                                canSwitch = os.clock()
                                                newIndex += 1
                                            end
                                            
                                            if (os.clock() - lastAttack) >= (0.8 / Attacks:GetRandomValue()) then
                                                local dir = CFrame.lookAt(localPosition, ent.RootPart.Position + Vector3.new(rand:NextNumber(0, 1.5), 0, rand:NextNumber(0, 2.5))).LookVector
                                                local pos = localPosition + dir * math.max(delta.Magnitude - reach, 0)

                                                local blatant = false
                                                local offset = {value = Vector3.new(0/0, 0/0, 0/0)}

                                                bedwars.SwordController.lastAttack = workspace:GetServerTimeNow()
                                                lastAttack = os.clock()
                                                AttackRemote:FireServer({
                                                    weapon = sword.tool,
                                                    chargedAttack = {chargeRatio = 0},
                                                    entityInstance = ent.Character,
                                                    validate = {
                                                        raycast = {
                                                            cameraPosition = blatant and offset or {value = pos},
                                                            cursorDirection = blatant and offset or {value = dir}
                                                        },
                                                        targetPosition = blatant and offset or {
                                                            value = ent.RootPart.Position
                                                        },
                                                        selfPosition = blatant and offset or {value = pos}
                                                    }
                                                })
                                            end
                                        else
                                            newIndex = 1
                                            lastAttack = os.clock() - 0.01
                                            canSwitch = os.clock()
                                        end	
                                    end
                                end
                            until not SilentAura.Enabled
                        else
                            lplr.Character.Humanoid.AutoRotate = true
                        end
                    end,
                    Tooltip = 'Simulates feel of Killaura\nAttacks and aim safely using built in AutoClicker to click, and Silent Aim system to aim'
                })

                Targets = SilentAura:CreateTargets({
                    Players = true, 
                    NPCs = false
                })

                local methods = {'Damage', 'Distance'}
                for i in sortmethods do
                    if not table.find(methods, i) then
                        table.insert(methods, i)
                    end
                end

                TargetMode = SilentAura:CreateDropdown({
                    Name = 'Target Mode',
                    List = methods,
                    Default = 'Distance'
                })

                AimMode = SilentAura:CreateDropdown({
                    Name = 'Aim Mode',
                    List = {'Camera', 'Player', 'None'},
                    Default = 'Player',
                    Function = function(val)
                        if ThirdPerson then
                            ThirdPerson.Object.Visible = val ~= 'None'
                        end
                    end
                })

                Attacks = SilentAura:CreateTwoSlider({
                    Name = 'Attacks per Second',
                    Min = 1,
                    Max = 22,
                    DefaultMin = 10.5,
                    DefaultMax = 14.5,
                    Decimal = 5
                })

                AimSpeed = SilentAura:CreateSlider({
                    Name = 'Aim Speed',
                    Min = 1,
                    Max = 20,
                    Default = 6
                })

                SwingDelay = SilentAura:CreateSlider({
                    Name = 'Swing Delay',
                    Min = 0,
                    Max = 1,
                    Default = 0.29,
                    Decimal = 6
                })

                IncreaseAttackRange = SilentAura:CreateToggle({
                    Name = 'Increase attack range',
                    Function = function(call)
                        if AttackRange then
                            AttackRange.Object.Visible = call
                        end
                    end
                })

                AttackRange = SilentAura:CreateSlider({
                    Name = 'Attack range',
                    Min = 0,
                    Max = 4,
                    Default = 1,
                    Decimal = 5
                })

                ExtraSwingDistance = SilentAura:CreateSlider({
                    Name = 'Extra Swing Distance',
                    Min = 1,
                    Max = 6,
                    Default = 4,
                    Decimal = 5
                })

                Angle = SilentAura:CreateSlider({
                    Name = 'Max angle',
                    Min = 0,
                    Max = 360,
                    Default = 120
                })

                Mouse = SilentAura:CreateToggle({
                    Name = 'Require Mouse down',
                    Function = function(call)
                        if SwingM then
                            SwingM.Object.Visible = call
                        end
                    end
                })
                SwingM = SilentAura:CreateToggle({Name = 'Play animation', Default = true, Darker = true})
                SwingM.Object.Visible = false

                SwingOnly = SilentAura:CreateToggle({
                    Name = 'Swing Only',
                    Function = function(call)
                        if SwingO then
                            SwingO.Object.Visible = call
                        end
                    end
                })
                SwingO = SilentAura:CreateToggle({Name = 'Play animation', Darker = true})
                SwingO.Object.Visible = false

                ThirdPerson = SilentAura:CreateToggle({Name = '3rd person aim view'})

                AttackRange.Object.Visible = false
            end)
        end)()

        --[[
            Blatant
        ]]

        local Attacking
        local canShoot
        local shootFunc
        local getProjectiles

        LPH_JIT_MAX(function()
            run(function() --> by max
                local Killaura
                local FastHits
                local Targets
                local Sort
                local SwingRange
                local AttackRange
                local ChargeTime
                local SyncHitreg
                local UpdateRate
                local AngleSlider
                local MaxTargets
                local Mouse
                local Attach
                local Swing
                local GUI
                local BoxAttackSpeedEnd
                local BoxAttackSpeed
                local BoxAttackTween
                local BoxSwingColor
                local BoxAttackColor
                local ParticleTexture
                local ParticleColor1
                local ParticleColor2
                local ParticleSize
                local Face
                local Animation
                local AnimationMode
                local AnimationSpeed
                local AnimationTween
                local Limit
                local LegitAura = {}
                local Particles, Boxes = {}, {}
                local RangeVisualiser
                local anims, AnimDelay, AnimTween, armC0 = vape.Libraries.auraanims, tick()
                local AttackRemote = {FireServer = function() end}
                task.spawn(function()
                    AttackRemote = bedwars.Client:Get(remotes.AttackEntity).instance
                end)

                local function getAttackData()
                    if Mouse.Enabled then
                        if not inputService:IsMouseButtonPressed(0) then return false end
                    end

                    if GUI.Enabled then
                        if bedwars.AppController:isLayerOpen(bedwars.UILayers.MAIN) then return false end
                    end

                    local sword = Limit.Enabled and store.hand or store.tools.sword
                    if not sword or not sword.tool then return false end

                    local meta = bedwars.ItemMeta[sword.tool.Name]
                    if Limit.Enabled then
                        if store.hand.toolType ~= 'sword' or bedwars.DaoController.chargingMaid then return false end
                    end

                    if LegitAura.Enabled then
                        if (tick() - bedwars.SwordController.lastSwing) > (ChargeTime.Value > 0.25 and ChargeTime.Value or 0.11) then return false end
                    end

                    return sword, meta
                end

                Killaura = vape.Categories.Blatant:CreateModule({
                    Name = 'Killaura',
                    Function = function(callback)
                        if callback then
                            if inputService.TouchEnabled then
                                pcall(function()
                                    lplr.PlayerGui.MobileUI['2'].Visible = Limit.Enabled
                                end)
                            end

                            local lastShot = tick()

                            if Animation.Enabled then
                                local fake = {
                                    Controllers = {
                                        ViewmodelController = {
                                            isVisible = function()
                                                return not Attacking
                                            end,
                                            playAnimation = function(...)
                                                if not getgenv().Attacking then
                                                    bedwars.ViewmodelController:playAnimation(select(2, ...))
                                                end
                                            end
                                        }
                                    }
                                }
                                pcall(function()
                                    debug.setupvalue(oldSwing or bedwars.SwordController.playSwordEffect, 6, fake)
                                end)
                                pcall(function()
                                    debug.setupvalue(bedwars.ScytheController.playLocalAnimation, 3, fake)
                                end)

                                task.spawn(function()
                                    local started = false
                                    repeat
                                        if getgenv().Attacking then
                                            if not armC0 then
                                                armC0 = gameCamera.Viewmodel.RightHand.RightWrist.C0
                                            end
                                            local first = not started
                                            started = true

                                            if AnimationMode.Value == 'Random' then
                                                anims.Random = {{CFrame = CFrame.Angles(math.rad(math.random(1, 360)), math.rad(math.random(1, 360)), math.rad(math.random(1, 360))), Time = 0.12}}
                                            end

                                            for _, v in anims[AnimationMode.Value] do
                                                AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(first and (AnimationTween.Enabled and 0.001 or 0.1) or v.Time / AnimationSpeed.Value, Enum.EasingStyle.Linear), {
                                                    C0 = armC0 * v.CFrame
                                                })
                                                AnimTween:Play()
                                                AnimTween.Completed:Wait()
                                                first = false
                                                if (not Killaura.Enabled) or (not getgenv().Attacking) then break end
                                            end
                                        elseif started then
                                            started = false
                                            AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
                                                C0 = armC0
                                            })
                                            AnimTween:Play()
                                        end

                                        if not started then
                                            task.wait(1 / UpdateRate.Value)
                                        end
                                    until (not Killaura.Enabled) or (not Animation.Enabled)
                                end)
                            end

                            Killaura:Clean(runService.PreRender:Connect(function()  
                                if entitylib.isAlive and RangeVisualiser then
                                    RangeVisualiser.Parent = gameCamera
                                    RangeVisualiser.Position = entitylib.character.RootPart.Position - Vector3.new(0, entitylib.character.Humanoid.HipHeight, 0)
                                end
                            end))

                            local swingCooldown, BoxData, Usage = 0, {}, 1
                            local lastSwang = tick() - 20
                            repeat
                                local attacked, sword, meta = {}, getAttackData()
                                getgenv().Attacking = false
                                store.KillauraTarget = nil
                                if sword and store.matchState ~= 0 then
                                    local plrs = entitylib.AllPosition({
                                        Range = SwingRange.Value,
                                        Wallcheck = Targets.Walls.Enabled or nil,
                                        Part = 'RootPart',
                                        Players = Targets.Players.Enabled,
                                        NPCs = Targets.NPCs.Enabled,
                                        Limit = MaxTargets.Value,
                                        Sort = sortmethods[Sort.Value]
                                    })

                                    if #plrs > 0 then
                                        switchItem(sword.tool, 0)
                                        local selfpos = entitylib.character.RootPart.Position
                                        local localfacing = entitylib.character.RootPart.CFrame.LookVector * Vector3.new(1, 0, 1)

                                        for i, v in plrs do
                                            local delta = (v.RootPart.Position - selfpos)
                                            local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
                                            if angle > (math.rad(AngleSlider.Value) / 2) then continue end

                                            table.insert(attacked, {
                                                Entity = v,
                                                Check = delta.Magnitude > AttackRange.Value and BoxSwingColor or BoxAttackColor
                                            })
                                            targetinfo.Targets[v] = os.clock() + 1

                                            if not getgenv().Attacking then
                                                getgenv().Attacking = true
                                                store.KillauraTarget = v
                                                if not Swing.Enabled and AnimDelay < tick() and not LegitAura.Enabled then
                                                    AnimDelay = tick() + math.max(ChargeTime.Value, 0.11)
                                                    lastSwang = tick()
                                                    pcall(function(...)
                                                        bedwars.SwordController:playSwordEffect(meta, false)
                                                    end)

                                                    if meta.displayName:find(' Scythe') then
                                                        bedwars.ScytheController:playLocalAnimation()
                                                    end

                                                    if vape.ThreadFix then
                                                        setthreadidentity(8)
                                                    end
                                                end
                                            end

                                            if delta.Magnitude > AttackRange.Value then continue end
                                            local actualRoot = v.Character.PrimaryPart
                                            if Attach.Enabled then
                                                local newcf = (entitylib.character.RootPart.CFrame - CFrame.lookAt(actualRoot.Position, selfpos).LookVector * math.max((selfpos - actualRoot.Position).Magnitude - 20.4, 0))
                                                entitylib.character.RootPart.CFrame = newcf
                                                selfpos = entitylib.character.RootPart.Position
                                            end
                                            if (tick() - swingCooldown) < (0.5 / Killaura.Options.Hitreg.Value) and Killaura.Options.Hitreg.Value <= 37 then continue end

                                            if actualRoot then

                                                local prediction = CFrame.lookAt(actualRoot.Position, selfpos).LookVector * math.max((selfpos - actualRoot.Position).Magnitude / 10, 0)
                                                local targetpos = actualRoot.Position + (prediction or Vector3.zero)

                                                local dir = CFrame.lookAt(selfpos, targetpos).LookVector
                                                local pos = selfpos + dir * math.max(delta.Magnitude - 14.399, 0)
                                                swingCooldown = tick()
                                                bedwars.SwordController.lastAttack = workspace:GetServerTimeNow()
                                                store.attackReach = (delta.Magnitude * 100) // 1 / 100
                                                store.attackReachUpdate = tick() + 1
      
                                                AttackRemote:FireServer({
                                                    weapon = sword.tool,
                                                    chargedAttack = {chargeRatio = 0},
                                                    entityInstance = v.Character,
                                                    validate = {
                                                        raycast = {
                                                            cameraPosition = {value = pos},
                                                            cursorDirection = {value = dir}
                                                        },
                                                        targetPosition = {value = targetpos},
                                                        selfPosition = {value = pos}
                                                    }
                                                })

                                                if (tick() - lastShot) >= (0.2 + lplr:GetNetworkPing()) and i <= 1 and FastHits.Enabled then
                                                    local projectiles = getProjectiles()

                                                    Usage += 1

                                                    if not projectiles[Usage] then
                                                        Usage = 1
                                                    end

                                                    if projectiles and projectiles[Usage] and canShoot(projectiles[Usage]) then
                                                        local item, ammo, projectile, itemMeta = unpack(projectiles[Usage])
                                                        
                                                        shootFunc(item, ammo, projectile, itemMeta, selfpos, v, true)

                                                        lastShot = tick()
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        if (tick() - lastSwang) < Killaura.Options['Continue Swinging']:GetRandomValue() and not Swing.Enabled and AnimDelay < tick() and not LegitAura.Enabled then
                                            AnimDelay = tick() + math.max(ChargeTime.Value, 0.11)
                                            pcall(function(...)
                                                bedwars.SwordController:playSwordEffect(meta, false)
                                            end)

                                            if meta.displayName:find(' Scythe') then
                                                bedwars.ScytheController:playLocalAnimation()
                                            end

                                            if vape.ThreadFix then
                                                setthreadidentity(8)
                                            end
                                        end
                                    end
                                end

                                for i, v in Boxes do
                                    if BoxData[v] == nil and attacked[i] then
                                        tweenService:Create(v, TweenInfo.new(BoxAttackSpeed.Value, Enum.EasingStyle[BoxAttackTween.Value]), {
                                            Size = Vector3.new(5, 7, 5)
                                        }):Play()
                                    elseif BoxData[v] and not attacked[i] then
                                        tweenService:Create(v, TweenInfo.new(BoxAttackSpeedEnd.Value, Enum.EasingStyle[BoxAttackTween.Value]), {
                                            Size = Vector3.zero
                                        }):Play()
                                    end
                                    BoxData[v] = attacked[i] or nil
                                    if attacked[i] then
                                        v.CFrame = attacked[i].Entity.RootPart.CFrame
                                        v.Color = Color3.fromHSV(attacked[i].Check.Hue, attacked[i].Check.Sat, attacked[i].Check.Value)
                                        v.Transparency = 1 - attacked[i].Check.Opacity
                                    end
                                end

                                for i, v in Particles do
                                    v.Position = attacked[i] and attacked[i].Entity.RootPart.Position or Vector3.new(9e9, 9e9, 9e9)
                                    v.Parent = attacked[i] and gameCamera or nil
                                end

                                if Face.Enabled and attacked[1] then
                                    local vec = attacked[1].Entity.RootPart.Position * Vector3.new(1, 0, 1)
                                    entitylib.character.RootPart.CFrame = CFrame.lookAt(entitylib.character.RootPart.Position, Vector3.new(vec.X, entitylib.character.RootPart.Position.Y + 0.001, vec.Z))
                                end

                                --#attacked > 0 and #attacked * 0.02 or
                                task.wait(1 / UpdateRate.Value)
                            until not Killaura.Enabled
                        else
                            store.KillauraTarget = nil
                            for _, v in Boxes do
                                v.Parent = nil
                            end
                            for _, v in Particles do
                                v.Parent = nil
                            end
                            if inputService.TouchEnabled then
                                pcall(function()
                                    lplr.PlayerGui.MobileUI['2'].Visible = true
                                end)
                            end
                            pcall(function()
                                debug.setupvalue(oldSwing or bedwars.SwordController.playSwordEffect, 6, bedwars.Knit)
                            end)
                            pcall(function()
                                debug.setupvalue(bedwars.ScytheController.playLocalAnimation, 3, bedwars.Knit)
                            end)
                            getgenv().Attacking = false
                            RangeVisualiser.Parent = replicatedStorage
                            if armC0 then
                                AnimTween = tweenService:Create(gameCamera.Viewmodel.RightHand.RightWrist, TweenInfo.new(AnimationTween.Enabled and 0.001 or 0.3, Enum.EasingStyle.Exponential), {
                                    C0 = armC0
                                })
                                AnimTween:Play()
                            end
                        end
                    end,
                    Tooltip = 'Attack players around you\nwithout aiming at them.'
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
                Killaura:CreateTwoSlider({
                    Name = 'Continue Swinging',
                    Min = 0,
                    Max = 10,
                    Decimal = 5,
                    DefaultMin = 0,
                    DefaultMax = 1,
                    Suffix = function(val)
                        return val <= 1 and 'sec' or 'secs'
                    end
                })
                SwingRange = Killaura:CreateSlider({
                    Name = 'Swing range',
                    Min = 1,
                    Max = 30,
                    Default = 30,
                    Function = function(val)
                        if RangeVisualiser then
                            RangeVisualiser.Size = Vector3.new(val * 0.7, 0.01, val  * 0.7)
                        end
                    end,
                    Suffix = function(val)
                        return val == 1 and 'stud' or 'studs'
                    end
                })
                AttackRange = Killaura:CreateSlider({
                    Name = 'Attack range',
                    Min = 1,
                    Max = 30,
                    Default = 30,
                    Suffix = function(val)
                        return val == 1 and 'stud' or 'studs'
                    end
                })
                Killaura:CreateSlider({
                    Name = 'Hitreg',
                    Min = 1,
                    Max = 36.5,
                    Default = 36.5,
                    Suffix = function()
                        return 'reg'
                    end
                })
                ChargeTime = Killaura:CreateSlider({
                    Name = 'Swing time',
                    Min = 0,
                    Max = 0.5,
                    Default = 0.42,
                    Decimal = 100
                })
                AngleSlider = Killaura:CreateSlider({
                    Name = 'Max angle',
                    Min = 1,
                    Max = 360,
                    Default = 360
                })
                UpdateRate = Killaura:CreateSlider({
                    Name = 'Update rate',
                    Min = 1,
                    Max = 240,
                    Default = 120,
                    Suffix = 'hz'
                })
                MaxTargets = Killaura:CreateSlider({
                    Name = 'Max targets',
                    Min = 1,
                    Max = 5,
                    Default = 5
                })
                Sort = Killaura:CreateDropdown({
                    Name = 'Target Mode',
                    List = methods
                })
                Attach = Killaura:CreateToggle({Name = 'Player Attach'})
                Mouse = Killaura:CreateToggle({Name = 'Require mouse down'})
                Swing = Killaura:CreateToggle({Name = 'No Swing'})
                GUI = Killaura:CreateToggle({Name = 'GUI check'})
                FastHits = Killaura:CreateToggle({
                    Name = 'Fast Hits',
                    Tooltip = 'Deals more damage quicker using projectiles',
                    Default = true
                })
                Killaura:CreateToggle({
                    Name = 'Show target',
                    Function = function(callback)
                        BoxSwingColor.Object.Visible = callback
                        BoxAttackColor.Object.Visible = callback
                        BoxAttackTween.Object.Visible = callback
                        BoxAttackSpeed.Object.Visible = callback
                        BoxAttackSpeedEnd.Object.Visible = callback
                        if callback then
                            for i = 1, 10 do
                                local box = Instance.new('Part')
                                box.Size = Vector3.zero
                                box.Transparency = 1
                                box.Parent = workspace
                                box.Material = Enum.Material.Neon
                                box.Anchored = true
                                box.CanCollide = false
                                box.CanQuery = false
                                Boxes[i] = box
                            end
                        else
                            for _, v in Boxes do
                                v:Destroy()
                            end
                            table.clear(Boxes)
                        end
                    end
                })
                local animlist = {}

                for i,v in Enum.EasingStyle:GetEnumItems() do
                    local item = tostring(v):gsub('Enum.EasingStyle.', '')
                    table.insert(animlist, item)
                end

                BoxAttackTween = Killaura:CreateDropdown({
                    Name = 'Box Animation',
                    List = animlist,
                    Darker = true,
                    Visible = false,
                    Default = 'Bounce'
                })
                BoxAttackSpeed = Killaura:CreateSlider({
                    Name = 'Start Animation Speed',
                    Min = 0,
                    Max = 10,
                    Default = 0.9,
                    Darker = true,
                    Decimal = 30,
                    Visible = false
                })
                BoxAttackSpeedEnd = Killaura:CreateSlider({
                    Name = 'End Animation Speed',
                    Min = 0,
                    Max = 10,
                    Default = 1.4,
                    Darker = true,
                    Decimal = 30,
                    Visible = false
                })

                BoxSwingColor = Killaura:CreateColorSlider({
                    Name = 'Target Color',
                    Darker = true,
                    DefaultHue = 0.6,
                    DefaultOpacity = 0.5,
                    Function = function(hue, sat, val, opacity)
                        if RangeVisualiser then
                            RangeVisualiser.Color = Color3.fromHSV(hue, sat, val)
                        end
                    end,
                    Visible = false
                })
                BoxAttackColor = Killaura:CreateColorSlider({
                    Name = 'Attack Color',
                    Darker = true,
                    DefaultOpacity = 0.5,
                    Visible = false
                })
                Killaura:CreateToggle({
                    Name = 'Target particles',
                    Function = function(callback)
                        ParticleTexture.Object.Visible = callback
                        ParticleColor1.Object.Visible = callback
                        ParticleColor2.Object.Visible = callback
                        ParticleSize.Object.Visible = callback
                        if callback then
                            for i = 1, 10 do
                                local part = Instance.new('Part')
                                part.Size = Vector3.new(2, 4, 2)
                                part.Anchored = true
                                part.CanCollide = false
                                part.Transparency = 1
                                part.CanQuery = false
                                part.Parent = Killaura.Enabled and gameCamera or nil
                                local particles = Instance.new('ParticleEmitter')
                                particles.Brightness = 1.5
                                particles.Size = NumberSequence.new(ParticleSize.Value)
                                particles.Shape = Enum.ParticleEmitterShape.Sphere
                                particles.Texture = ParticleTexture.Value
                                particles.Transparency = NumberSequence.new(0)
                                particles.Lifetime = NumberRange.new(0.4)
                                particles.Speed = NumberRange.new(16)
                                particles.Rate = 128
                                particles.Drag = 16
                                particles.ShapePartial = 1
                                particles.Color = ColorSequence.new({
                                    ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
                                    ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
                                })
                                particles.Parent = part
                                Particles[i] = part
                            end
                        else
                            for _, v in Particles do
                                v:Destroy()
                            end
                            table.clear(Particles)
                        end
                    end
                })
                ParticleTexture = Killaura:CreateTextBox({
                    Name = 'Texture',
                    Default = 'rbxassetid://14736249347',
                    Function = function()
                        for _, v in Particles do
                            v.ParticleEmitter.Texture = ParticleTexture.Value
                        end
                    end,
                    Darker = true,
                    Visible = false
                })
                ParticleColor1 = Killaura:CreateColorSlider({
                    Name = 'Color Begin',
                    Function = function(hue, sat, val)
                        for _, v in Particles do
                            v.ParticleEmitter.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, sat, val)),
                                ColorSequenceKeypoint.new(1, Color3.fromHSV(ParticleColor2.Hue, ParticleColor2.Sat, ParticleColor2.Value))
                            })
                        end
                    end,
                    Darker = true,
                    Visible = false
                })
                ParticleColor2 = Killaura:CreateColorSlider({
                    Name = 'Color End',
                    Function = function(hue, sat, val)
                        for _, v in Particles do
                            v.ParticleEmitter.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromHSV(ParticleColor1.Hue, ParticleColor1.Sat, ParticleColor1.Value)),
                                ColorSequenceKeypoint.new(1, Color3.fromHSV(hue, sat, val))
                            })
                        end
                    end,
                    Darker = true,
                    Visible = false
                })
                ParticleSize = Killaura:CreateSlider({
                    Name = 'Size',
                    Min = 0,
                    Max = 1,
                    Default = 0.2,
                    Decimal = 100,
                    Function = function(val)
                        for _, v in Particles do
                            v.ParticleEmitter.Size = NumberSequence.new(val)
                        end
                    end,
                    Darker = true,
                    Visible = false
                })
                Face = Killaura:CreateToggle({Name = 'Face target'})
                Killaura:CreateToggle({
                    Name = 'Range Visualizer',
                    Function = function(call)
                        if call then
                            RangeVisualiser = Instance.new('MeshPart')
                            RangeVisualiser.MeshId = 'rbxassetid://3726303797'
                            RangeVisualiser.Color = Color3.fromHSV(BoxSwingColor.Hue, BoxSwingColor.Sat, BoxSwingColor.Value)
                            RangeVisualiser.CanCollide = false
                            RangeVisualiser.Anchored = true
                            RangeVisualiser.Material = Enum.Material.Neon
                            RangeVisualiser.Size = Vector3.new(SwingRange.Value * 0.7, 0.01, SwingRange.Value * 0.7)
                            if Killaura.Enabled then
                                RangeVisualiser.Parent = gameCamera
                            end
                            bedwars.QueryUtil:setQueryIgnored(RangeVisualiser, true)
                        else
                            if RangeVisualiser then
                                RangeVisualiser:Destroy()
                                RangeVisualiser = nil
                            end
                        end
                    end
                })
                Animation = Killaura:CreateToggle({
                    Name = 'Custom Animation',
                    Function = function(callback)
                        AnimationMode.Object.Visible = callback
                        AnimationTween.Object.Visible = callback
                        AnimationSpeed.Object.Visible = callback
                        if Killaura.Enabled then
                            Killaura:Toggle()
                            Killaura:Toggle()
                        end
                    end
                })
                local animnames = {}
                for i in anims do
                    table.insert(animnames, i)
                end
                AnimationMode = Killaura:CreateDropdown({
                    Name = 'Animation Mode',
                    List = animnames,
                    Darker = true,
                    Visible = false
                })
                AnimationSpeed = Killaura:CreateSlider({
                    Name = 'Animation Speed',
                    Min = 0,
                    Max = 2,
                    Default = 1,
                    Decimal = 10,
                    Darker = true,
                    Visible = false
                })
                AnimationTween = Killaura:CreateToggle({
                    Name = 'No Tween',
                    Darker = true,
                    Visible = false
                })
                Limit = Killaura:CreateToggle({
                    Name = 'Limit to items',
                    Function = function(callback)
                        if inputService.TouchEnabled and Killaura.Enabled then
                            pcall(function()
                                lplr.PlayerGui.MobileUI['2'].Visible = callback
                            end)
                        end
                    end,
                    Tooltip = 'Only attacks when the sword is held'
                })
                LegitAura = Killaura:CreateToggle({
                    Name = 'Swing only',
                    Tooltip = 'Only attacks while swinging manually'
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
                
                getProjectiles = function(custom)
                    local items = {}
                    for _, item in store.inventory.inventory.items do
                        local proj = bedwars.ItemMeta[item.itemType].projectileSource
                        local ammo = proj and getAmmo(proj)
                        if ammo and (table.find(List.ListEnabled, ammo) or custom and table.find(custom, ammo)) then
                            local callback = canDebug and proj.projectileType or function(res)
                                return 'arrow'
                            end
                            table.insert(items, {
                                item,
                                ammo,
                                callback(ammo),
                                proj
                            })
                        end
                    end
                    return items
                end

                canShoot = function(item)
                    return tick() > (FireDelays[item[1].itemType] or 0)
                end

                shootFunc = function(item, ammo, projectile, itemMeta, pos, ent, ign)
                    rayCheck.FilterDescendantsInstances = {workspace.Map}
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
                                        if getItem('raven') and ent then
                                            bedwars.Client:Get(remotes.SpawnRaven):CallServerAsync():andThen(function(projectile)
                                                if projectile then
                                                    local bodyforce = Instance.new('BodyForce')
                                                    bodyforce.Force = Vector3.new(0, projectile.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
                                                    bodyforce.Parent = projectile.PrimaryPart
                            
                                                    if ent then
                                                        task.spawn(function()
                                                            for _ = 1, 20 do
                                                                if ent.RootPart and projectile then
                                                                    projectile:SetPrimaryPartCFrame(CFrame.lookAlong(ent.RootPart.Position, gameCamera.CFrame.LookVector))
                                                                end
                                                                task.wait(0.05)
                                                            end
                                                        end)
                                                        task.wait(0.3)
                                                        bedwars.RavenController:detonateRaven()
                                                    end
                                                end
                                            end)
                                        end

                                        local pos = entitylib.character.RootPart.Position
                                        for _, data in getProjectiles() do
                                            local item, ammo, projectile, itemMeta = unpack(data)
                                            if canShoot(data) then
                                                shootFunc(item, ammo, projectile, itemMeta, pos, ent)
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

            run(function() --> by max, selunar and monia
                local MouseTP
                local Targets
                local TargetMode
                local Mode

                local rayCheck = RaycastParams.new()
                rayCheck.RespectCanCollide = true

                local function findItem()
                    for _, v in {'telepearl'} do
                        local item = getItem(v)
                        if item then return item, v end
                    end
                end

                local TpKits = {
                    elektra = function(cframe)
                        replicatedStorage['events-@easy-games/game-core:shared/game-core-networking@getEvents.Events'].useAbility:FireServer('ELECTRIC_DASH')
                        --bedwars.AbilityController:useAbility('ELECTRIC_DASH')
                        bedwars.Client:Get('ElectricDash'):CallServerAsync({
                            destCFrame = cframe,
                            electricDasher = lplr.Character,
                            startCFrame = cframe,
                            cameraCFrame = gameCamera.CFrame
                        })
                    end,
                    davey = function(cframe)
                        local cannon

                        for _, v in collectionService:GetTagged('block') do
                            if v.Name == 'cannon' and (entitylib.character.RootPart.Position - v.Position).Magnitude <= 12 then
                                cannon = v
                                break
                            end
                        end

                        if not cannon and getItem('cannon') then
                            local pos = entitylib.character.RootPart.Position - Vector3.new(0, (entitylib.character.HipHeight + (entitylib.character.RootPart.Size.Y / 2)) - 3, 0)
                            local rounded = Vector3.new(math.round(pos.X / 3) * 3, math.round(pos.Y / 3) * 3, math.round(pos.Z / 3) * 3)
                            bedwars.placeBlock(rounded, 'cannon', false)

                            cannon = getPlacedBlock(rounded)
                        end

                        if cannon then
                            local blockpos = bedwars.BlockController:getBlockPosition(cannon.Position)

                            local calc = prediction.SolveTrajectory(cannon.Position, 100, 0, cframe.Position, Vector3.zero, workspace.Gravity, 0, 0)
                            local dir = CFrame.lookAt(cannon.Position, (calc or cframe.Position)).LookVector * 2

                            bedwars.Client:Get(remotes.CannonAim):SendToServer({
                                cannonBlockPos = blockpos,
                                lookVector = dir
                            })

                            task.delay(0.5, function()
                                bedwars.CannonHandController:launchSelf(cannon)
                            end)
                        end
                    end
                }

                MouseTP = vape.Categories.Blatant:CreateModule({
                    Name = 'Mouse TP',
                    Tooltip = 'Teleports you to the nearest target.',
                    Function = function(call)
                        if call then
                            local entity
                            if TargetMode.Value == 'Target' then
                                entity = entitylib.EntityMouse({
                                    Range = math.huge,
                                    Part = 'RootPart',
                                    Players = Targets.Players.Enabled,
                                    NPCs = Targets.NPCs.Enabled,
                                })
                            else
                                local ray = cloneref(lplr:GetMouse()).UnitRay
                                rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
                                ray = workspace:Raycast(ray.Origin, ray.Direction * 1000000, rayCheck)
                                if ray then
                                    entity = {
                                        RootPart = {
                                            Position = ray and ray.Position + Vector3.new(0, entitylib.character.HipHeight or 2, 0),
                                            CFrame = ray and CFrame.new(ray.Position) + Vector3.new(0, entitylib.character.HipHeight or 2, 0)
                                        }
                                    }
                                end
                            end
                            if entity then
                                if Mode.Value == 'Item' then
                                    local item = findItem()
                                    if item then
                                        getgenv().CancelSwitch = os.clock() + 0.3
                                        switchItem(item.tool)

                                        local meta = bedwars.ProjectileMeta[item.tool.Name]
                                        local calc = prediction.SolveTrajectory(entitylib.character.RootPart.Position, meta.launchVelocity, meta.gravitationalAcceleration, entity.RootPart.Position, Vector3.zero, workspace.Gravity, 0, 0)
                                        local projSpeed = meta.launchVelocity

                                        if calc then
                                            local shootpos = entitylib.character.RootPart.Position + Vector3.new(0, 2, 0)
                                            local dir = CFrame.lookAt(entitylib.character.RootPart.Position, calc).LookVector * projSpeed

                                            bedwars.Client:Get(remotes.FireProjectile).instance:InvokeServer(
                                                item.tool, 
                                                item.tool.Name, 
                                                item.tool.Name, 
                                                shootpos, 
                                                entitylib.character.RootPart.Position, 
                                                dir, 
                                                httpService:GenerateGUID(), 
                                                {
                                                    drawDurationSeconds = 1, 
                                                    shotId = httpService:GenerateGUID(false)
                                                },
                                                workspace:GetServerTimeNow() - 0.045
                                            )
                                        end
                                    else
                                        notif('MouseTP', 'No pearls', 5, 'warning')
                                    end
                                elseif Mode.Value == 'Kit' then
                                    if TpKits[store.equippedKit] then
                                        TpKits[store.equippedKit](entity.RootPart.CFrame)
                                    else
                                        notif('MouseTP', 'No kit matched for mousetp', 8, 'warning')
                                    end
                                else
                                    lplr.Character:PivotTo(CFrame.new(entity.RootPart.Position))
                                end
                            end
                            if MouseTP.Enabled then
                                MouseTP:Toggle()
                            end
                        end
                    end
                })

                Targets = MouseTP:CreateTargets({
                    Players = true,
                    NPCs = true
                })

                TargetMode = MouseTP:CreateDropdown({
                    Name = 'Position',
                    List = {'Target', 'Mouse'},
                    Default = 'Target',
                    Function = function(val) 
                        Targets.Object.Visible = val == 'Target'
                    end
                })

                Mode = MouseTP:CreateDropdown({
                    Name = 'Mode',
                    List = {'Item', 'Normal', 'Kit'},
                    Default = 'Item',
                    Function = function() end
                })
            end)

            getgenv().FlyLandTick = os.clock()

            run(function() --> max
                local AutoDodge
                local Mode
                local DodMelees
                local ShowRoot
                local Projectiles

                local Range, Sync, Targets, AirTime, GroundTime = nil, {}

                local Blacklist = {}

                local rayCheck, oldroot, clone, hip = RaycastParams.new()
                local Hitting

                local function createClone()
                    if entitylib.isAlive and entitylib.character.Humanoid.Health > 0 and (not oldroot or not oldroot.Parent) then
                        repeat task.wait() until not store.rootpart or not store.rootpart.Parent
                        hip = entitylib.character.Humanoid.HipHeight
                        local lastvelo = entitylib.character.RootPart.Velocity
                        oldroot = entitylib.character.HumanoidRootPart
                        if not lplr.Character.Parent then return false end
                        lplr.Character.Parent = game
                        clone = oldroot:Clone()
                        clone.Parent = lplr.Character
                        if ShowRoot.Enabled then
                            oldroot.Transparency = 0
                            Instance.new('Highlight', oldroot)
                        end
                        oldroot.Parent = workspace.Terrain
                        lplr.Character.PrimaryPart = clone
                        lplr.Character.Parent = workspace
                        for _, v in lplr.Character:GetDescendants() do
                            if v:IsA('Weld') or v:IsA('Motor6D') then
                                if v.Part0 == oldroot then v.Part0 = clone end
                                if v.Part1 == oldroot then v.Part1 = clone end
                            end
                        end
                        store.rootpart = oldroot
                        oldroot.Velocity = lastvelo
                        return true
                    end
                    return false
                end
                
                local function destroyClone()
                    if not oldroot or not oldroot.Parent or not entitylib.isAlive then return false end
                    local lastcf = clone.CFrame
                    lplr.Character.Parent = game
                    oldroot.Parent = lplr.Character
                    lplr.Character.PrimaryPart = oldroot
                    lplr.Character.Parent = workspace
                    oldroot.CanCollide = true
                    for _, v in lplr.Character:GetDescendants() do
                        if v:IsA('Weld') or v:IsA('Motor6D') then
                            if v.Part0 == clone then v.Part0 = oldroot end
                            if v.Part1 == clone then v.Part1 = oldroot end
                        end
                    end
                    local oldcf = clone.CFrame
                    if clone then
                        clone:Destroy()
                        clone = nil
                    end
                    oldroot.Transparency = 1
                    oldroot = nil
                    if workspace:Raycast(entitylib.character.RootPart.Position, Vector3.new(0, -7, 0), rayCheck) then
                        entitylib.character.RootPart.CFrame = oldcf + Vector3.new(0, 12, 0)
                    end
                    task.spawn(function()
                        for i = 1, 12 do
                            entitylib.character.RootPart.AssemblyLinearVelocity = Vector3.new(entitylib.character.RootPart.AssemblyLinearVelocity.X, 1, entitylib.character.RootPart.AssemblyLinearVelocity.Z)
                            task.wait()
                        end
                    end)
                    entitylib.character.Humanoid.HipHeight = hip or 2
                    store.rootpart = nil
                    repeat
                        entitylib.character.RootPart.CFrame = lastcf
                        task.wait(0.1)
                    until (entitylib.character.RootPart.CFrame.Position - lastcf.Position).Magnitude <= 10
                end

                local function getProjectile(name)
                    for i,v in workspace:GetChildren() do
                        if not table.find(Blacklist, v) and v.Name == name then
                            table.insert(Blacklist, v)
                            return v
                        end
                    end
                end

                local lastGround, lastAir = 0, 0
                
                AutoDodge = vape.Categories.Blatant:CreateModule({
                    Name = 'Auto Dodge',
                    Tooltip = 'Dodges attacks and incoming projectiles.',
                    Function = function(call)
                        if call then
                            for _, v in workspace:GetChildren() do
                                table.insert(Blacklist, v)
                            end

                            local Target = nil
                            local CanSync = false

                            AutoDodge:Clean(runService.PreSimulation:Connect(function()
                                if entitylib.isAlive and os.clock() > FlyLandTick then
                                    local cf = clone and clone.Parent and {clone.CFrame:GetComponents()} or {entitylib.character.HumanoidRootPart.CFrame:GetComponents()}
                                    if store.KillauraTarget and not Hitting then
                                        cf[2] = store.KillauraTarget.RootPart.CFrame.Y
                                    end
                                    if oldroot and oldroot.Parent then
                                        oldroot.CFrame = Hitting and not pingSpiking and CFrame.lookAlong(Vector3.new(clone.CFrame.X, oldroot.CFrame.Y, clone.CFrame.Z), clone.CFrame.LookVector) or (Sync.Enabled and CanSync and Target.RootPart and CFrame.lookAlong(Vector3.new(clone.CFrame.X, Target.RootPart.CFrame.Y, clone.CFrame.Z), clone.CFrame.LookVector) or clone.CFrame)
                                        oldroot.Velocity = Vector3.new(oldroot.Velocity.X, Random.new():NextNumber(0, 1), oldroot.Velocity.Z)
                                    end
                                end
                            end))

                            AutoDodge:Clean(vapeEvents.ProjectileLaunch.Event:Connect(function(projectile)
                                local instance = getProjectile(projectile.projectileType.Name)
                                if instance and projectile.fromEntity ~= lplr.Character and Projectiles.Enabled then
                                    local handle = instance:WaitForChild('Handle', 5)
                                    if handle then
                                        local localfacing = handle.CFrame.LookVector * Vector3.new(1, 0, 1)

                                        local delta = (entitylib.character.RootPart.Position - handle.Position)
                                        local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
                                        if angle > (math.rad(75) / 2) then return end

                                        local con; con = runService.PostSimulation:Connect(function()
                                            if not instance or not instance.Parent then
                                                return con:Disconnect()
                                            end
                                            if (entitylib.character.RootPart.Position - handle.Position).Magnitude <= (bedwars.ProjectileMeta[projectile.projectileType.Name] and (bedwars.ProjectileMeta[projectile.projectileType.Name].launchVelocity / 2) or 55) then
                                                if Mode.Value == 'Legit' then
                                                    moveDirection = Vector3.zero
                                                    allow = os.clock() + 0.5
                                                    lplr.Character.Humanoid:MoveTo(entitylib.character.RootPart.Position - Vector3.new(2, 0, 0))
                                                else
                                                    entitylib.character.RootPart.CFrame = entitylib.character.RootPart.CFrame + Vector3.new(0, 40, 0)
                                                end
                                                con:Disconnect()
                                            end
                                        end)
                                        AutoDodge:Clean(con)
                                    end
                                end
                            end))

                            if Mode.Value == 'Normal' then
                                local cooldown = 0

                                repeat
                                    if DodMelees.Enabled and entitylib.isAlive and store.matchState ~= 0 and os.clock() > FlyLandTick and isnetworkowner(lplr.Character.PrimaryPart) and (oldroot and oldroot.Parent and isnetworkowner(oldroot) or not oldroot or not oldroot.Parent) then
                                        rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}

                                        local ent = entitylib.AllPosition({
                                            Range = Range.Value,
                                            Part = 'RootPart',
                                            Players = Targets.Players.Enabled,
                                            NPCs = Targets.NPCs.Enabled,
                                            Limit = 1
                                        })[1] or store.KillauraTarget

                                        local airleft = (tick() - entitylib.character.AirTime)
                                        if ent and airleft < 1.5 and not pingSpiking and cooldown < 10 then
                                            rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera, ent.Character}

                                            getgenv().antihitclone = true
                                            Target = ent
                                            createClone()

                                            if not Hitting and (os.clock() - lastGround) >= GroundTime.Value then
                                                getgenv().antihitting = true
                                                Hitting = true
                                                getgenv().AntiHitOnGround = false

                                                oldroot.CFrame = oldroot.CFrame - Vector3.new(0, 200, 0)
                                                lastAir = os.clock()
                                            elseif Hitting and (os.clock() - lastAir) >= AirTime.Value then
                                                CanSync = ent.RootPart.Velocity.Y > -50 and (ent.RootPart.CFrame.Y - clone.CFrame.Y) < 40 and workspace:Raycast(entitylib.character.RootPart.Position, Vector3.new(0, (Target.RootPart.CFrame.Y - entitylib.character.RootPart.CFrame.Y), 0), rayCheck) == nil

                                                getgenv().antihitting = false
                                                Hitting = false
                                                getgenv().AntiHitOnGround = true

                                                lastGround = os.clock()
                                            end

                                            cooldown = cooldown + 0.02

                                            if not Sync.Enabled or not workspace:Raycast(Vector3.new(entitylib.character.RootPart.Position.X, ent.RootPart.Position.Y, entitylib.character.RootPart.Position.Z), Vector3.new(0, -100, 0), rayCheck) then
                                                cooldown = 0
                                            end
                                        else
                                            destroyClone()

                                            getgenv().AntiHitOnGround = true
                                            getgenv().antihitclone = false

                                            if ent and (airleft > 1.5 or cooldown >= 10) then
                                                notif('AutoDodge', 'Prevented a flagging attempt', 5.1, 'warning')
                                                task.wait(0.3)
                                                cooldown = 0
                                            end
                                        end
                                    else
                                        destroyClone()
                                        getgenv().AntiHitOnGround = true
                                        getgenv().antihitclone = false
                                    end
                                    task.wait()
                                until not AutoDodge.Enabled
                            end
                        else
                            destroyClone()
                            getgenv().AntiHitOnGround = true
                            getgenv().antihitclone = false
                        end
                    end
                })

                Targets = AutoDodge:CreateTargets({
                    Players = true, 
                    NPCs = false
                })

                Mode = AutoDodge:CreateDropdown({
                    Name = 'Mode',
                    List = {'Normal', 'Legit'},
                    Default = 'Normal',
                    Function = function(val)
                        if Projectiles then
                            GroundTime.Object.Visible = val == 'Normal'
                            AirTime.Object.Visible = val == 'Normal'
                            ShowRoot.Object.Visible = val == 'Normal'
                            DodMelees.Object.Visible = val == 'Normal'
                        end

                        if AutoDodge.Enabled then
                            AutoDodge:Toggle()
                            AutoDodge:Toggle()
                        end
                    end
                })

                Range = AutoDodge:CreateSlider({
                    Name = 'Range',
                    Min = 1,
                    Max = 40,
                    Default = 25
                })

                GroundTime = AutoDodge:CreateSlider({
                    Name = 'Ground Time',
                    Decimal = 15,
                    Min = 0,
                    Max = 2,
                    Default = 0.17
                })

                AirTime = AutoDodge:CreateSlider({
                    Name = 'Air Time',
                    Decimal = 15,
                    Min = 0,
                    Max = 2,
                    Default = 0.3
                })

                ShowRoot = AutoDodge:CreateToggle({
                    Name = 'Show Root'
                })

                DodMelees = AutoDodge:CreateToggle({
                    Name = 'Dodge Melee Attacks',
                    Default = true,
                    Function = function() end
                })

                Projectiles = AutoDodge:CreateToggle({
                    Name = 'Dodge Projectiles',
                    Default = true,
                    Function = function() end
                })
            end)

            run(function() --> by max, monia and selunar
                local InfiniteFly
                local FlySpeed
                local VerticalSpeed

                local rayCheck = RaycastParams.new()
                local oldroot
                local clone

                local hip = 2.6

                local function createClone()
                    if entitylib.isAlive and entitylib.character.Humanoid.Health > 0 and (not oldroot or not oldroot.Parent) then
                        hip = entitylib.character.Humanoid.HipHeight
                        oldroot = entitylib.character.HumanoidRootPart
                        if not lplr.Character.Parent then return false end
                        lplr.Character.Parent = game
                        clone = oldroot:Clone()
                        clone.Parent = lplr.Character
                        oldroot.Transparency = 0
                        --Instance.new('Highlight', oldroot)
                        oldroot.Parent = workspace.Terrain
                        if oldroot.Velocity.Y > 0 then
                            clone.Velocity -= Vector3.new(0, oldroot.Velocity.Y, 0)
                        end
                        store.rootpart = oldroot
                        lplr.Character.PrimaryPart = clone
                        lplr.Character.Parent = workspace			
                        for _, v in lplr.Character:GetDescendants() do
                            if v:IsA('Weld') or v:IsA('Motor6D') then
                                if v.Part0 == oldroot then v.Part0 = clone end
                                if v.Part1 == oldroot then v.Part1 = clone end
                            end
                        end
                        return true
                    end
                    return false
                end

                local function destroyClone()
                    if not oldroot or not oldroot.Parent or not entitylib.isAlive then return false end
                    lplr.Character.Parent = game
                    oldroot.Parent = lplr.Character
                    lplr.Character.PrimaryPart = oldroot
                    lplr.Character.Parent = workspace
                    for _, v in lplr.Character:GetDescendants() do
                        if v:IsA('Weld') or v:IsA('Motor6D') then
                            if v.Part0 == clone then v.Part0 = oldroot end
                            if v.Part1 == clone then v.Part1 = oldroot end
                        end
                    end
                    oldroot.CanCollide = true
                    if clone then
                        clone:Destroy()
                        clone = nil
                    end
                    entitylib.character.Humanoid.HipHeight = hip or 2.6
                    oldroot.Transparency = 1
                    oldroot = nil
                    store.rootpart = nil
                    getgenv().FlyLandTick = os.clock() + 0.01
                end

                local up = 0
                local down = 0
                local startTick = os.clock()

                InfiniteFly = vape.Categories.Blatant:CreateModule({
                    Name = 'Infinite Fly',
                    Tooltip = 'Makes you go zoom.',
                    Function = function(call)
                        if call then
                            task.wait()
                            startTick = os.clock()
                            if not entitylib.isAlive or FlyLandTick > os.clock() or not isnetworkowner(entitylib.character.RootPart) then
                                return InfiniteFly:Toggle()
                            end
                            destroyClone()
                            local a, b = pcall(createClone)
                            if not a then
                                return InfiniteFly:Toggle()
                            end
                            rayCheck.FilterDescendantsInstances = {lplr.Character, oldroot, clone, gameCamera}
                            InfiniteFly:Clean(inputService.InputBegan:Connect(function(input)
                                if not inputService:GetFocusedTextBox() then
                                    if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
                                        up = 1
                                    elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
                                        down = -1
                                    end
                                end
                            end))
                            InfiniteFly:Clean(inputService.InputEnded:Connect(function(input)
                                if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
                                    up = 0
                                elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL2 then
                                    down = 0
                                end
                            end))

                            local lastY = entitylib.character.RootPart.Position.Y
                            local lastVelo = 0
                            local cancelThread = false
                            local tped = false
                            InfiniteFly:Clean(runService.PreSimulation:Connect(function(delta)
                                if not entitylib.isAlive or not clone or not clone.Parent or not isnetworkowner(oldroot) or (workspace:GetServerTimeNow() - lplr:GetAttribute('LastTeleported')) < 2 then
                                    return InfiniteFly:Toggle()
                                end
                                oldroot.CanCollide = false
                                getgenv().FlyLandTick = os.clock() + 0.1
                                local mass = 1.3 + ((up + down) * VerticalSpeed.Value)
                                local moveDir = entitylib.character.Humanoid.MoveDirection
                                local velo = getSpeed()
                                local destination = (moveDir * math.max(FlySpeed.Value - velo, 0) * delta)
                                clone.CFrame = clone.CFrame + destination
                                clone.AssemblyLinearVelocity = (moveDir * velo) + Vector3.new(0, mass, 0)

                                rayCheck.FilterDescendantsInstances = {lplr.Character, oldroot, clone, gameCamera, store.antifallpart}

                                local raycast = workspace:Blockcast(oldroot.CFrame + Vector3.new(0, 250, 0), Vector3.new(3, 3, 3), Vector3.new(0, -500, 0), rayCheck)
                                local groundcast = workspace:Blockcast(clone.CFrame, Vector3.new(3, 3, 3), Vector3.new(0, -3, 0), rayCheck)
                                local upperRay = not workspace:Blockcast(oldroot.CFrame + (oldroot.CFrame.LookVector * 17), Vector3.new(3, 3, 3), Vector3.new(0, -150, 0), rayCheck) and workspace:Blockcast(oldroot.CFrame + (oldroot.CFrame.LookVector * 17), Vector3.new(3, 3, 3), Vector3.new(0, 150, 0), rayCheck)

                                local changeYLevel = 300
                                local yLevel = 0

                                if lastVelo - oldroot.AssemblyLinearVelocity.Y > 1200 then
                                    oldroot.CFrame = oldroot.CFrame + Vector3.new(0, 200, 0)
                                end

                                for i,v in {50, 1000, 2000, 3000, 4000, 5000, 6000, 7000} do
                                    if oldroot.AssemblyLinearVelocity.Y < -v then
                                        changeYLevel = changeYLevel + 100
                                        yLevel = yLevel - 15
                                    end
                                end

                                lastVelo = oldroot.AssemblyLinearVelocity.Y

                                if raycast then
                                    local suc = workspace:Raycast(oldroot.Position, Vector3.new(0, -12, 0), rayCheck) and oldroot.AssemblyLinearVelocity.Y >= 0
                                    oldroot.AssemblyLinearVelocity = Vector3.new(0, entitylib.character.RootPart.Size.Y / 2 + entitylib.character.Humanoid.HipHeight + 0.25 * 3, 0)
                                    tped = false
                                        oldroot.CFrame = groundcast and clone.CFrame or CFrame.lookAlong(Vector3.new(clone.Position.X, raycast.Position.Y + 2.5, clone.Position.Z), clone.CFrame.LookVector)
                                elseif (oldroot.Position.Y < (lastY - (86 + yLevel)))then
                                    if not cancelThread and (oldroot.AssemblyLinearVelocity.Y < -200 or not upperRay) then
                                        oldroot.CFrame = oldroot.CFrame + Vector3.new(0, changeYLevel, 0)
                                    else
                                        oldroot.AssemblyLinearVelocity = Vector3.new(oldroot.AssemblyLinearVelocity.X, -86, oldroot.AssemblyLinearVelocity.Z)
                                    end
                                end

                                oldroot.CFrame = CFrame.lookAlong(Vector3.new(clone.Position.X, oldroot.Position.Y, clone.Position.Z), clone.CFrame.LookVector)
                            end))
                        else
                            local thread = task.spawn(function()
                                repeat
                                    oldroot.AssemblyLinearVelocity = Vector3.new(0, entitylib.character.RootPart.Size.Y / 2 + entitylib.character.Humanoid.HipHeight + 0.25 * 3, 0)
                                    task.wait()
                                until false
                            end)

                            oldroot.CanCollide = true

                            notif('InfiniteFly', 'Waiting 1.2s to land', 1, 'info')
                            local landCFrame = oldroot.CFrame
                            task.delay(0.4, function()
                                pcall(task.cancel, thread)
                                destroyClone()
                                notif('InfiniteFly', 'Landed', 1, 'info')
                                lplr.Character.PrimaryPart.CFrame = landCFrame
                            end)
                        end
                    end,
                    ExtraText = function()
                        return 'Heatseeker'
                    end
                })
                FlySpeed = InfiniteFly:CreateSlider({
                    Name = 'Speed',
                    Min = 1,
                    Max = 23,
                    Default = 23
                })
                VerticalSpeed = InfiniteFly:CreateSlider({
                    Name = 'Vertical Speed',
                    Min = 1,
                    Max = 150,
                    Default = 70
                })
            end)

            run(function() --> by max, idea from blank
                local PlayerAttach
                local Range
                local Targets

                local rayCheck = RaycastParams.new()
                rayCheck.FilterType = Enum.RaycastFilterType.Exclude

                PlayerAttach = vape.Categories.Blatant:CreateModule({
                    Name = 'Player Attach',
                    Tooltip = 'Attachs you to the nearest target',
                    Function = function(call)
                        if call then
                            LPH_NO_VIRTUALIZE(function()
                                repeat
                                    if entitylib.isAlive then
                                        local plr = entitylib.AllPosition({
                                            Range = Range.Value,
                                            Wallcheck = Targets.Walls.Enabled or nil,
                                            Part = 'RootPart',
                                            Players = Targets.Players.Enabled,
                                            NPCs = Targets.NPCs.Enabled,
                                            Limit = 1,
                                            Sort = function(a, b)
                                                return a.Entity.Health < b.Entity.Health
                                            end
                                        })[1]
                                        if plr then
                                            rayCheck.FilterDescendantsInstances = {plr.RootPart.Parent, lplr.Character}

                                            entitylib.character.RootPart.AssemblyLinearVelocity = Vector3.new(0, entitylib.character.RootPart.Size.Y / 2 + entitylib.character.Humanoid.HipHeight + 0.25 * 3, 0)
                                            entitylib.character.RootPart.CFrame = plr.RootPart.CFrame + (not workspace:Raycast(plr.RootPart.Position, plr.RootPart.CFrame.LookVector, rayCheck) and (plr.RootPart.CFrame.LookVector * 1.4) or Vector3.zero)
                                        end
                                    end
                                    task.wait()
                                until not PlayerAttach.Enabled
                            end)()
                        end
                    end
                })

                Targets = PlayerAttach:CreateTargets({
                    Players = true,
                    NPCs = true
                })

                Range = PlayerAttach:CreateSlider({
                    Name = 'Range',
                    Min = 1,
                    Max = 35,
                    Default = 23
                })
            end)
            
            run(function() --> by max
                local DamageBoost
                local Duration
                local Value
                local Auto

                DamageBoost = vape.Categories.Blatant:CreateModule({
                    Name = 'Damage Boost',
                    Tooltip = 'Makes you go faster whenever you take knockback.',
                    Function = function(callback)
                        if callback then
                            local handle = os.clock()

                            DamageBoost:Clean(vapeEvents.EntityDamageEvent.Event:Connect(function(damageTable)
                                if os.clock() > handle then
                                    local player = damageTable.entityInstance and playersService:GetPlayerFromCharacter(damageTable.entityInstance)
                                    if player and player == lplr and (damageTable.knockbackMultiplier and damageTable.knockbackMultiplier.horizontal and damageTable.knockbackMultiplier.horizontal > 0 or playersService:GetPlayerFromCharacter(damageTable.fromEntity) ~= nil) and not vape.Modules['Long Jump'].Enabled then
                                        local knockbackBoost = bedwars.KnockbackUtil.calculateKnockbackVelocity(Vector3.one, 1, {
                                            vertical = 0,
                                            horizontal = damageTable.knockbackMultiplier and damageTable.knockbackMultiplier.horizontal
                                        }).Magnitude * 0.9

                                        local secs = damageTable.knockbackMultiplier and damageTable.knockbackMultiplier.horizontal or 1

                                        if secs then
                                            secs /= 3
                                        end
                                        
                                        handle = os.clock() + lplr:GetNetworkPing()

                                        getgenv().damagedata.Value = Auto.Enabled and knockbackBoost or Value.Value
                                        getgenv().damagedata.lastHit = os.clock() + (Auto.Enabled and secs or Duration.Value)
                                    end
                                end
                            end))
                        end
                    end
                })
                Value = DamageBoost:CreateSlider({
                    Name = 'Speed Value',
                    Min = 0,
                    Max = 50,
                    Decimal = 20,
                    Default = 20,
                })
                Duration = DamageBoost:CreateSlider({
                    Name = 'Duration',
                    Min = 0,
                    Max = 2,
                    Decimal = 20,
                    Default = 0.4,
                })
                Auto = DamageBoost:CreateToggle({
                    Name = 'Auto Set',
                    Default = true,
                    Function = function(call)
                        Duration.Object.Visible = not call
                        Value.Object.Visible = not call
                    end
                })

                Duration.Object.Visible = false
                Value.Object.Visible = false
            end)

            run(function() --> by max
                local Invisible
                local clone, oldroot, hip, valid
                local animtrack
                local proper = true

                local function animationTrickery()
                    if entitylib.isAlive then 
                        local anim = Instance.new('Animation')
                        anim.AnimationId = 'http://www.roblox.com/asset/?id=104767795538635'
                        animtrack = entitylib.character.Humanoid:LoadAnimation(anim)
                        animtrack:Play(0, 1, 0)
                        animtrack.TimePosition = 1
                        anim:Destroy()
                        LPH_NO_VIRTUALIZE(function()
                            Invisible:Clean(runService.PreRender:Connect(function()
                                animtrack:Play(0, 1, 0)
                                animtrack.TimePosition = 1

                                for _, v in lplr.Character:GetDescendants() do
                                    if (v:IsA('BasePart') or v:IsA('MeshPart')) and not v:IsDescendantOf(lplr.Character.HumanoidRootPart) then
                                        v.CanCollide = false
                                    end
                                end
                            end))
                        end)()
                    end
                end
                
                Invisible = vape.Categories.Blatant:CreateModule({
                    Name = 'Invisible',
                    Function = function(callback)
                        if callback then 
                            if not proper then
                                notif('Invisible', 'Broken state detected', 3, 'alert')
                                Invisible:Toggle()
                                return
                            end
                
                            animationTrickery()

                            Invisible:Clean(entitylib.Events.LocalAdded:Connect(function(char)
                                local animator = char.Humanoid:WaitForChild('Animator', 1)
                                if animator and Invisible.Enabled then 
                                    oldroot = nil
                                    Invisible:Toggle()
                                    Invisible:Toggle()
                                end
                            end))
                        else
                            if animtrack then 
                                animtrack:Stop()
                                animtrack:Destroy()
                            end
                            if entitylib.isAlive then
                                entitylib.character.RootPart.CanCollide = true
                            end
                        end
                    end,
                    Tooltip = 'Turns you invisible.'
                })
            end)
        end)()

        --[[
            Render
        ]]

        LPH_NO_VIRTUALIZE(function()
            run(function() --> by max
                local ViewmodelVisuals
                local StrokeColor
                local Color

                local Instances = {}

                ViewmodelVisuals = vape.Categories.Render:CreateModule({
                    Name = 'Viewmodel Visuals',
                    Function = function(call)
                        if call then
                            local viewmodel = gameCamera:WaitForChild('Viewmodel', math.huge)

                            if not ViewmodelVisuals.Enabled then
                                return
                            end

                            for i,v in viewmodel:GetChildren() do
                                if v:IsA('Accessory') then
                                    local highlight = v.Handle:FindFirstChildOfClass('Highlight') or Instance.new('Highlight', v.Handle)
                                    highlight.FillColor = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
                                    highlight.FillTransparency = Color.Opacity
                                    highlight.OutlineTransparency = StrokeColor.Opacity
                                    highlight.OutlineColor = Color3.fromHSV(StrokeColor.Hue, StrokeColor.Sat, StrokeColor.Value)

                                    ViewmodelVisuals:Clean(highlight)
                                    table.insert(Instances, highlight)

                                    break
                                end
                            end

                            ViewmodelVisuals:Clean(viewmodel.ChildAdded:Connect(function(visual)
                                if visual:IsA('Accessory') then
                                    local highlight = visual.Handle:FindFirstChildOfClass('Highlight') or Instance.new('Highlight', visual.Handle)
                                    highlight.FillColor = Color3.fromHSV(Color.Hue, Color.Sat, Color.Value)
                                    highlight.FillTransparency = Color.Opacity
                                    highlight.OutlineTransparency = StrokeColor.Opacity
                                    highlight.OutlineColor = Color3.fromHSV(StrokeColor.Hue, StrokeColor.Sat, StrokeColor.Value)
                                    
                                    ViewmodelVisuals:Clean(highlight)
                                    table.insert(Instances, highlight)
                                end
                            end))

                            ViewmodelVisuals:Clean(gameCamera.ChildAdded:Connect(function(visual)
                                if visual.Name == 'Viewmodel' then
                                    ViewmodelVisuals:Toggle()
                                    ViewmodelVisuals:Toggle()
                                end
                            end))
                        end
                    end
                })

                Color = ViewmodelVisuals:CreateColorSlider({
                    Name = 'Color',
                    Default = Color3.new(1, 1, 1),
                    Function = function(hue, sat, val, opacity)
                        for _, v in Instances do
                            v.FillColor = Color3.fromHSV(hue, sat, val)
                            v.FillTransparency = opacity
                        end
                    end
                })

                StrokeColor = ViewmodelVisuals:CreateColorSlider({
                    Name = 'Stroke Color',
                    Default = Color3.new(),
                    Function = function(hue, sat, val, opacity)
                        for _, v in Instances do
                            v.OutlineColor = Color3.fromHSV(hue, sat, val)
                            v.OutlineTransparency = opacity
                        end
                    end
                })
            end)

            run(function() --> by max
                local ArmorHighlight
                local Boots, Helmet, Chestplate, UseParts

                local Instances, Decoys = {}, {}
                local Properties = {
                    OutlineTransparency = 'Slider',
                    FillTransparency = 'Slider',
                    FillColor = 'ColorSlider',
                    OutlineColor = 'ColorSlider'
                }
                
                local function getArmor(v)
                    if v:GetAttribute('ArmorSlot') == 0 and Helmet.Enabled then
                        return 'Helmet'
                    elseif v:GetAttribute('ArmorSlot') == 1 and Chestplate.Enabled then
                        return 'Chestplate'
                    elseif v:GetAttribute('ArmorSlot') == 2 and Boots.Enabled then
                        return 'Boots'
                    end
                end

                ArmorHighlight = vape.Categories.Render:CreateModule({
                    Name = 'Armor Highlight',
                    Function = function(call)
                        if call then
                            ArmorHighlight:Clean(lplr.CharacterAdded:Connect(function(char)
                                ArmorHighlight:Clean(char.ChildAdded:Connect(function(part)
                                    task.wait(1)
                                    local armor = getArmor(part)
                                    if armor then
                                        if UseParts.Enabled then
                                            local v = Instance.new('Part')
                                            v.CanCollide = false
                                            for name, prop in getproperties(part:WaitForChild('Handle')) do
                                                pcall(function()
                                                    v[name] = prop
                                                end)
                                            end
                                            v.Anchored = true
                                            part.Handle.Transparency = 1
                                            v.Material = Enum.Material.Neon
                                            for _, child in part.Handle:GetChildren() do
                                                child.Parent = v
                                            end
                                            v.Parent = part
                                            table.insert(Decoys, {
                                                TP = part.Handle,
                                                Main = v
                                            })
                                        else
                                            local highlight = Instance.new('Highlight', part:WaitForChild('Handle'))
                                            for i,v in Properties do
                                                highlight[i] = typeof(v.Hue) == 'number' and Color3.fromHSV(v.Hue, v.Sat, v.Value) or v.Value
                                            end
                                            
                                            table.insert(Instances, highlight)
                                        end
                                    end
                                end))
                                for _, part in char:GetChildren() do
                                    local armor = getArmor(part)
                                    if armor then
                                        if UseParts.Enabled then
                                            local v = Instance.new('Part')
                                            v.CanCollide = false
                                            for name, prop in getproperties(part:WaitForChild('Handle')) do
                                                pcall(function()
                                                    v[name] = prop
                                                end)
                                            end
                                            part.Handle.Transparency = 1
                                            v.Anchored = true
                                            v.Material = Enum.Material.Neon
                                            for _, child in part.Handle:GetChildren() do
                                                child.Parent = v
                                            end
                                            table.insert(Decoys, {
                                                TP = part.Handle,
                                                Main = v
                                            })
                                        else
                                            local highlight = Instance.new('Highlight', part:WaitForChild('Handle'))
                                            for i,v in Properties do
                                                highlight[i] = typeof(v.Hue) == 'number' and Color3.fromHSV(v.Hue, v.Sat, v.Value) or v.Value
                                            end
                                            
                                            table.insert(Instances, highlight)
                                        end
                                    end
                                end
                            end))

                            ArmorHighlight:Clean(runService.PreRender:Connect(function()
                                for _, data in Decoys do
                                    if data.Main and data.Main.Parent and data.TP and data.TP.Parent then
                                        data.Main.Velocity = Vector3.new(0, 1, 0)
                                        data.Main.CFrame = data.TP.CFrame
                                    end
                                end
                            end))

                            if entitylib.isAlive then
                                ArmorHighlight:Clean(lplr.Character.ChildAdded:Connect(function(part)
                                    task.wait(1)
                                    local armor = getArmor(part)
                                    if armor then
                                        if UseParts.Enabled then
                                            local v = Instance.new('Part')
                                            v.CanCollide = false
                                            for name, prop in getproperties(part:WaitForChild('Handle')) do
                                                pcall(function()
                                                    v[name] = prop
                                                end)
                                            end
                                            v.Anchored = true
                                            part.Handle.Transparency = 1
                                            v.Material = Enum.Material.Neon
                                            for _, child in part.Handle:GetChildren() do
                                                child.Parent = v
                                            end
                                            v.Parent = part
                                            table.insert(Decoys, {
                                                TP = part.Handle,
                                                Main = v
                                            })
                                        else
                                            local highlight = Instance.new('Highlight', part:WaitForChild('Handle'))
                                            for i,v in Properties do
                                                highlight[i] = typeof(v.Hue) == 'number' and Color3.fromHSV(v.Hue, v.Sat, v.Value) or v.Value
                                            end
                                            
                                            table.insert(Instances, highlight)
                                        end
                                    end
                                end))
                                for _, part in lplr.Character:GetChildren() do
                                    local armor = getArmor(part)
                                    if armor then
                                        if UseParts.Enabled then
                                            local v = Instance.new('Part')
                                            v.CanCollide = false
                                            for name, prop in getproperties(part:WaitForChild('Handle')) do
                                                pcall(function()
                                                    v[name] = prop
                                                end)
                                            end
                                            part.Handle.Transparency = 1
                                            v.Anchored = true
                                            v.Material = Enum.Material.Neon
                                            for _, child in part.Handle:GetChildren() do
                                                child.Parent = v
                                            end
                                            table.insert(Decoys, {
                                                TP = part.Handle,
                                                Main = v
                                            })
                                        else
                                            local highlight = Instance.new('Highlight', part:WaitForChild('Handle'))
                                            for i,v in Properties do
                                                highlight[i] = typeof(v.Hue) == 'number' and Color3.fromHSV(v.Hue, v.Sat, v.Value) or v.Value
                                            end
                                            
                                            table.insert(Instances, highlight)
                                        end
                                    end
                                end
                            end
                        else
                            for i,v in Instances do
                                v:Destroy()
                            end
                            table.clear(Decoys)
                            table.clear(Instances)
                        end
                    end
                })

                for i,v in Properties do
                    local name = i

                    Properties[name] = ArmorHighlight['Create'.. v](ArmorHighlight, {
                        Name = i,
                        Min = 0,
                        Max = 1,
                        Decimal = 35,
                        Function = function(hue, sat, val)
                            pcall(function()
                                for _, ins in Instances do
                                    ins[name] = sat and Color3.fromHSV(hue, sat, val) or hue
                                end
                            end)

                            if sat then
                                for _, ins in Decoys do
                                    ins.Main.Color = Color3.fromHSV(hue, sat, val)
                                end
                            end
                        end
                    })
                end

                Helmet = ArmorHighlight:CreateToggle({
                    Name = 'Helmet',
                    Function = function()
                        if ArmorHighlight.Enabled then
                            ArmorHighlight:Toggle()
                            ArmorHighlight:Toggle()
                        end
                    end
                })

                Chestplate = ArmorHighlight:CreateToggle({
                    Name = 'Chestplate',
                    Function = function()
                        if ArmorHighlight.Enabled then
                            ArmorHighlight:Toggle()
                            ArmorHighlight:Toggle()
                        end
                    end
                })

                Boots = ArmorHighlight:CreateToggle({
                    Name = 'Boots',
                    Default = true,
                    Function = function()
                        if ArmorHighlight.Enabled then
                            ArmorHighlight:Toggle()
                            ArmorHighlight:Toggle()
                        end
                    end
                })

                UseParts = ArmorHighlight:CreateToggle({
                    Name = 'Use Parts',
                    Default = true,
                    Function = function()
                        if ArmorHighlight.Enabled then
                            ArmorHighlight:Toggle()
                            ArmorHighlight:Toggle()
                        end
                    end
                })
            end)
        end)()

        --[[
            Utility
        ]]
              
        LPH_JIT_MAX(function()
            run(function() -- CATVAPE FEATURE
                local AutoKit
                local Legit
                local Toggles = {}
                
                local function kitCollection(id, func, range, specific)
                    local objs = type(id) == 'table' and id or collection(id, AutoKit)
                    LPH_NO_VIRTUALIZE(function()
                        repeat
                            if entitylib.isAlive then
                                local localPosition = entitylib.character.RootPart.Position
                                for _, v in objs do
                                    if not AutoKit.Enabled then break end
                                    local part = not v:IsA('Model') and v or v.PrimaryPart
                                    if part and (part.Position - localPosition).Magnitude <= (not Legit.Enabled and specific and math.huge or range) then
                                        func(v)
                                    end
                                end
                            end
                            task.wait(0.1)
                        until not AutoKit.Enabled
                    end)()
                end

                local function shieldFunc()
                    local shield = getItem('infernal_shield')
                    if shield then
                        local hotbar = getHotbar(shield.tool)
                        local old = getHotbar(store.hand.tool)
                        if hotbar then
                            hotbarSwitch(hotbar)
                            task.wait(0.45)
                            hotbarSwitch(old)
                        end
                    end
                end

                local Blacklist
                local AutoKitFunctions = {
                    alchemist = function()
                        kitCollection('alchemist_ingedients', function(v)
                            bedwars.Client:Get('CollectCollectableEntity'):SendToServer({
                                id = v:GetAttribute('Id'),
                                collectableName = v.Name
                            })
                        end, 30, true)
                    end,
                    battery = function()
                        repeat
                            if entitylib.isAlive then
                                local localPosition = entitylib.character.RootPart.Position
                                for i, v in bedwars.BatteryEffectsController.liveBatteries do
                                    if (v.position - localPosition).Magnitude <= 10 then
                                        local BatteryInfo = bedwars.BatteryEffectsController:getBatteryInfo(i)
                                        if not BatteryInfo or BatteryInfo.activateTime >= workspace:GetServerTimeNow() or BatteryInfo.consumeTime + 0.1 >= workspace:GetServerTimeNow() then continue end
                                        BatteryInfo.consumeTime = workspace:GetServerTimeNow()
                                        bedwars.Client:Get(remotes.ConsumeBattery):SendToServer({batteryId = i})
                                    end
                                end
                            end
                            task.wait(0.1)
                        until not AutoKit.Enabled
                    end,
                    blood_assassin = function()
                        AutoKit:Clean(vapeEvents.EntityDamageEvent.Event:Connect(function(damageTable)
                            if damageTable.fromEntity == lplr.Character and damageTable.entityInstance.Humanoid.Health < 50 then
                                local plr = playersService:GetPlayerFromCharacter(damageTable.entityInstance)
                                if plr then
                                    for i,v in store.contracts do
                                        if v.target == plr then
                                            bedwars.Client:Get('BloodAssassinSelectContract'):SendToServer({
                                                contractId = v.id
                                            })
                                            break
                                        end
                                    end
                                end
                            end
                        end))
                    end,
                    beekeeper = function()
                        kitCollection('bee', function(v)
                            bedwars.Client:Get(remotes.BeePickup):SendToServer({beeId = v:GetAttribute('BeeId')})
                        end, 18, false)
                    end,
                    bigman = function()
                        kitCollection('treeOrb', function(v)
                            if bedwars.Client:Get(remotes.ConsumeTreeOrb):CallServer({treeOrbSecret = v:GetAttribute('TreeOrbSecret')}) then
                                v:Destroy()
                            end
                        end, 12, false)
                    end,
                    block_kicker = function()
                        local old = bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition
                        bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition = function(...)
                            local origin, dir = select(2, ...)
                            local plr = entitylib.EntityMouse({
                                Part = 'RootPart',
                                Range = 1000,
                                Origin = origin,
                                Players = true,
                                Wallcheck = true
                            })
                
                            if plr then
                                local calc = prediction.SolveTrajectory(origin, 100, 20, plr.RootPart.Position, plr.RootPart.Velocity, workspace.Gravity, plr.HipHeight, plr.Jumping and 42.6 or nil)
                
                                if calc then
                                    for i, v in debug.getstack(2) do
                                        if v == dir then
                                            debug.setstack(2, i, CFrame.lookAt(origin, calc).LookVector)
                                        end
                                    end
                                end
                            end
                
                            return old(...)
                        end
                
                        AutoKit:Clean(function()
                            bedwars.BlockKickerKitController.getKickBlockProjectileOriginPosition = old
                        end)
                    end,
                    cat = function()
                        local old = bedwars.CatController.leap
                        bedwars.CatController.leap = function(...)
                            vapeEvents.CatPounce:Fire()
                            return old(...)
                        end
                
                        AutoKit:Clean(function()
                            bedwars.CatController.leap = old
                        end)
                    end,
                    --[[davey = function()
                        local old = bedwars.CannonHandController.launchSelf
                        bedwars.CannonHandController.launchSelf = function(...)
                            local res = {old(...)}
                            local self, block = ...
                
                            if block:GetAttribute('PlacedByUserId') == lplr.UserId and (block.Position - entitylib.character.RootPart.Position).Magnitude < 30 then
                                task.spawn(bedwars.breakBlock, block, false, nil, true)
                            end
                
                            return unpack(res)
                        end
                
                        AutoKit:Clean(function()
                            bedwars.CannonHandController.launchSelf = old
                        end)
                    end,]]
                    drill = function()
                        repeat
                            for i,v in collectionService:GetTagged('Drill') do
                                bedwars.Client:Get('ExtractFromDrill'):SendToServer({
                                    drill = v
                                })
                            end
                            task.wait(0.5)
                        until not AutoKit.Enabled
                    end,
                    dragon_slayer = function()
                        kitCollection('KaliyahPunchInteraction', function(v)
                            bedwars.DragonSlayerController:deleteEmblem(v)
                            bedwars.DragonSlayerController:playPunchAnimation(Vector3.zero)
                            bedwars.Client:Get(remotes.KaliyahPunch):SendToServer({
                                target = v
                            })
                        end, 18, true)
                    end,
                    dragon_sword = function()
                        repeat
                            if (lplr:GetAttribute('SwordCount') or 0) > 0 then
                                local plr = entitylib.EntityPosition({
                                    Range = Legit.Enabled and Range.Value or math.huge,
                                    Part = 'RootPart',
                                    Players = true
                                })
                                if plr then
                                    bedwars.Client:Get('DragonSwordFire'):SendToServer({
                                        target = plr.Character
                                    })
                                end
                            end
                            task.wait(0.1)
                        until not AutoKit.Enabled
                    end,
                    farmer_cletus = function()
                        kitCollection('HarvestableCrop', function(v)
                            if bedwars.Client:Get(remotes.HarvestCrop):CallServer({position = bedwars.BlockController:getBlockPosition(v.Position)}) then
                                bedwars.GameAnimationUtil:playAnimation(lplr.Character, bedwars.AnimationType.PUNCH)
                                bedwars.SoundManager:playSound(bedwars.SoundList.CROP_HARVEST)
                            end
                        end, 10, false)
                    end,
                    frost_hammer_kit = function()
                        repeat
                            if getItem('frost_crystal') then
                                for i, v in bedwars.AdetundeUtil.getUpgradesFromHammer(lplr) do
                                    if not getItem('frost_crystal') then
                                        break
                                    end

                                    local nextUpgrade = bedwars.AdetundeUpgradeMeta[i].tiers[v + 1]
                                    if nextUpgrade then
                                        if getItem('frost_crystal').amount >= nextUpgrade.price then
                                            bedwars.Client:Get('UpgradeFrostyHammer'):CallServer(i)
                                            task.wait(0.1)
                                        end
                                    end
                                end
                            end
                            task.wait(0.5)
                        until not AutoKit.Enabled
                    end,
                    fisherman = function()
                        local old = bedwars.FishingMinigameController.startMinigame
                        bedwars.FishingMinigameController.startMinigame = function(_, _, result)
                            result({win = true})
                        end
                
                        AutoKit:Clean(function()
                            bedwars.FishingMinigameController.startMinigame = old
                        end)
                    end,
                    gingerbread_man = function()
                        local old = bedwars.LaunchPadController.attemptLaunch
                        bedwars.LaunchPadController.attemptLaunch = function(...)
                            local res = {old(...)}
                            local self, block = ...
                
                            if (workspace:GetServerTimeNow() - self.lastLaunch) < 0.4 then
                                if block:GetAttribute('PlacedByUserId') == lplr.UserId and (block.Position - entitylib.character.RootPart.Position).Magnitude < 30 then
                                    task.spawn(bedwars.breakBlock, block, false, nil, true)
                                end
                            end
                
                            return unpack(res)
                        end
                
                        AutoKit:Clean(function()
                            bedwars.LaunchPadController.attemptLaunch = old
                        end)
                    end,
                    hatter = function()
                        AutoKit:Clean(replicatedStorage['events-@easy-games/game-core:shared/game-core-networking@getEvents.Events'].abilityUsed.OnClientEvent:Connect(function(player, ability)
                            if ability == 'HATTER_TARGET_ALERT' and player:GetAttribute('Team') == lplr:GetAttribute('Team') and bedwars.AbilityController:canUseAbility('HATTER_TELEPORT') then
                                moveDirection = Vector3.zero
                                allow = os.clock() + 1
                                task.wait(0.2)
                                bedwars.AbilityController:useAbility('HATTER_TELEPORT')
                            end
                        end))
                    end,
                    hannah = function()
                        kitCollection('HannahExecuteInteraction', function(v)
                            local billboard = bedwars.Client:Get(remotes.HannahKill):CallServer({
                                user = lplr,
                                victimEntity = v
                            }) and v:FindFirstChild('Hannah Execution Icon')
                
                            if billboard then
                                billboard:Destroy()
                            end
                        end, 30, true)
                    end,
                    jailor = function()
                        kitCollection('jailor_soul', function(v)
                            bedwars.JailorController:collectEntity(lplr, v, 'JailorSoul')
                        end, 20, false)
                    end,
                    grim_reaper = function()
                        kitCollection(bedwars.GrimReaperController.soulsByPosition, function(v)
                            if entitylib.isAlive and lplr.Character:GetAttribute('Health') <= (lplr.Character:GetAttribute('MaxHealth') / 4) and (not lplr.Character:GetAttribute('GrimReaperChannel')) then
                                bedwars.Client:Get(remotes.ConsumeSoul):CallServer({
                                    secret = v:GetAttribute('GrimReaperSoulSecret')
                                })
                            end
                        end, 120, false)
                    end,
                    melody = function()
                        repeat
                            local mag, hp, ent = 30, math.huge
                            if entitylib.isAlive then
                                local localPosition = entitylib.character.RootPart.Position
                                for _, v in entitylib.List do
                                    if v.Player and v.Player:GetAttribute('Team') == lplr:GetAttribute('Team') then
                                        local newmag = (localPosition - v.RootPart.Position).Magnitude
                                        if newmag <= mag and v.Health < hp and v.Health < v.MaxHealth then
                                            mag, hp, ent = newmag, v.Health, v
                                        end
                                    end
                                end
                            end
                
                            if ent and getItem('guitar') then
                                bedwars.Client:Get(remotes.GuitarHeal):SendToServer({
                                    healTarget = ent.Character
                                })
                            end
                
                            task.wait(0.1)
                        until not AutoKit.Enabled
                    end,
                    metal_detector = function()
                        kitCollection('hidden-metal', function(v)
                            bedwars.Client:Get(remotes.PickupMetal):SendToServer({
                                id = v:GetAttribute('Id')
                            })
                        end, 20, false)
                    end,
                    mage = function()
                        kitCollection('ElementTome', function(v)
                            bedwars.Client:Get('LearnElementTome'):SendToServer({
                                secret = v:GetAttribute('TomeSecret')
                            })
                            task.wait(0.2)
                            v:Destroy()
                        end, nil, false)
                    end,
                    miner = function()
                        kitCollection('petrified-player', function(v)
                            bedwars.Client:Get(remotes.MinerDig):SendToServer({
                                petrifyId = v:GetAttribute('PetrifyId')
                            })
                        end, 6, true)
                    end,
                    pinata = function()
                        kitCollection(lplr.Name..':pinata', function(v)
                            if getItem('candy') then
                                bedwars.Client:Get(remotes.DepositPinata):CallServer(v)
                            end
                        end, 6, true)
                    end,
                    spirit_assassin = function()
                        kitCollection('EvelynnSoul', function(v)
                            bedwars.SpiritAssassinController:useSpirit(lplr, v)
                        end, 120, true)
                    end,
                    styx = function()
                        AutoKit:Clean(bedwars.Client:Get('StyxSpawnExitPortalFromServer'):Connect(function(data)
                            bedwars.Client:Get('StyxTryOpenExitPortalFromClient'):CallServer(data.exitPortalData.uuid)
                        end))
                    end,
                    star_collector = function()
                        kitCollection('stars', function(v)
                            bedwars.StarCollectorController:collectEntity(lplr, v, v.Name)
                        end, 20, false)
                    end,
                    summoner = function()
                        local clock = os.clock() - 0.65
                        repeat
                            local plr = entitylib.EntityPosition({
                                Range = Legit.Enabled and Range.Value or 41,
                                Part = 'RootPart',
                                Players = true,
                                NPCs = true,
                                Sort = sortmethods.Health
                            })
                
                            if plr and (not Legit.Enabled or (lplr.Character:GetAttribute('Health') or 0) > 0) and store.hand and store.hand.tool and store.hand.tool.Name:find('summoner_claw') then
                                local localPosition = entitylib.character.RootPart.Position
                                local shootDir = CFrame.lookAt(localPosition, plr.RootPart.Position).LookVector
                                localPosition += shootDir * math.max((localPosition - plr.RootPart.Position).Magnitude - 18, 0)
                
                                if (os.clock() - clock) >= 0.65 then
                                    bedwars.SummonerClawController:clawAttack(lplr, localPosition, shootDir, store.hand.tool and store.hand.tool.Name or 'summoner_claw_1')
                                    clock = os.clock()
                                end

                                bedwars.Client:Get(remotes.SummonerClawAttack):SendToServer({
                                    position = localPosition,
                                    direction = shootDir,
                                    clientTime = workspace:GetServerTimeNow()
                                })
                            end
                
                            task.wait(0.1)
                        until not AutoKit.Enabled
                    end,
                    void_knight = function()
                        repeat
                            if bedwars.AbilityController:canUseAbility('void_knight_consume_emerald') then
                                bedwars.AbilityController:useAbility('void_knight_consume_emerald')
                            end
                            if bedwars.AbilityController:canUseAbility('void_knight_consume_iron') then
                                bedwars.AbilityController:useAbility('void_knight_consume_iron')
                            end
                            task.wait(0.1)
                        until not AutoKit.Enabled
                    end,
                    void_dragon = function()
                        local oldflap = bedwars.VoidDragonController.flapWings
                        local flapped
                
                        bedwars.VoidDragonController.flapWings = function(self)
                            if not flapped and bedwars.Client:Get(remotes.DragonFly):CallServer() then
                                local modifier = bedwars.SprintController:getMovementStatusModifier():addModifier({
                                    blockSprint = true,
                                    constantSpeedMultiplier = 2
                                })
                                self.SpeedMaid:GiveTask(modifier)
                                self.SpeedMaid:GiveTask(function()
                                    flapped = false
                                end)
                                flapped = true
                            end
                        end
                
                        AutoKit:Clean(function()
                            bedwars.VoidDragonController.flapWings = oldflap
                        end)
                
                        repeat
                            if bedwars.VoidDragonController.inDragonForm then
                                local plr = entitylib.EntityPosition({
                                    Range = 30,
                                    Part = 'RootPart',
                                    Players = true
                                })
                
                                if plr then
                                    bedwars.Client:Get(remotes.DragonBreath):SendToServer({
                                        player = lplr,
                                        targetPoint = plr.RootPart.Position
                                    })
                                end
                            end
                            task.wait(0.1)
                        until not AutoKit.Enabled
                    end,
                    warlock = function()
                        local lastTarget
                        repeat
                            if store.hand.tool and store.hand.tool.Name == 'warlock_staff' then
                                local plr = entitylib.EntityPosition({
                                    Range = 30,
                                    Part = 'RootPart',
                                    Players = true,
                                    NPCs = true
                                })
                
                                if plr and plr.Character ~= lastTarget then
                                    if not bedwars.Client:Get(remotes.WarlockTarget):CallServer({
                                        target = plr.Character
                                    }) then
                                        plr = nil
                                    end
                                end
                
                                lastTarget = plr and plr.Character
                            else
                                lastTarget = nil
                            end
                
                            task.wait(0.1)
                        until not AutoKit.Enabled
                    end,
                    wizard = function()
                        repeat
                            local ability = lplr:GetAttribute('WizardAbility')
                            if ability and bedwars.AbilityController:canUseAbility(ability) then
                                local plr = entitylib.EntityPosition({
                                    Range = 50,
                                    Part = 'RootPart',
                                    Players = true,
                                    Sort = sortmethods.Health
                                })
                
                                if plr then
                                    bedwars.AbilityController:useAbility(ability, newproxy(true), {target = plr.RootPart.Position})
                                end
                            end
                
                            task.wait(0.1)
                        until not AutoKit.Enabled
                    end,
                    taliyah = function()
                        kitCollection('HarvestableCrop', function(v)
                            if bedwars.Client:Get(remotes.HarvestCrop):CallServer({position = bedwars.BlockController:getBlockPosition(v.Position)}) then
                                bedwars.GameAnimationUtil:playAnimation(lplr.Character, bedwars.AnimationType.PUNCH)
                                bedwars.SoundManager:playSound(bedwars.SoundList.CROP_HARVEST)
                            end
                        end, 10, false)
                    end,
                    shielder = function()
                        Blacklist = workspace:GetChildren()

                        AutoKit:Clean(vapeEvents.ProjectileLaunch.Event:Connect(function(projectile)
                            local instance = getProjectile(projectile.projectileType.Name)
                            if instance and projectile.fromEntity ~= lplr.Character then
                                local handle = instance:WaitForChild('Handle', 5)
                                if handle then
                                    local localfacing = handle.CFrame.LookVector * Vector3.new(1, 0, 1)

                                    local delta = (entitylib.character.RootPart.Position - handle.Position)
                                    local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
                                    if angle > (math.rad(90) / 2) then return end
                                    
                                    local con; con = runService.PostSimulation:Connect(function()
                                        if not instance or not instance.Parent then
                                            return con:Disconnect()
                                        end
                                        if (entitylib.character.RootPart.Position - handle.Position).Magnitude <= (bedwars.ProjectileMeta[projectile.projectileType.Name] and (bedwars.ProjectileMeta[projectile.projectileType.Name].launchVelocity / 2) or 55) then
                                            task.spawn(shieldFunc)
                                            con:Disconnect()
                                        end
                                    end)
                                    AutoKit:Clean(con)
                                end
                            end
                        end))
                    end,
                    pyro = function()
                        repeat
                            local flamethrower = getItem('flamethrower')
                            if flamethrower then
                                for _, v in {'range', 'heat', 'power'} do
                                    local value = flamethrower.tool:GetAttribute(v) or -1
                                    if value < 3 then
                                        local nextUpgrade = bedwars.PyroUpgradeMeta[v].tiers[value + 2]
                                        if nextUpgrade then
                                            local currency = getItem(nextUpgrade.currency)
                                            if currency and currency.amount >= nextUpgrade.price then
                                                bedwars.Client:Get('UpgradeFlamethrower'):CallServer(v)
                                                task.wait(0.1)
                                            end
                                        end
                                    end
                                end
                            end
                            task.wait(0.5)
                        until not AutoKit.Enabled
                    end,
                    ember = function()
                        repeat
                            if entitylib.EntityPosition({
                                Range = 25,
                                Part = 'RootPart',
                                Players = true,
                                NPCs = true,
                                Sort = sortmethods.Health
                            }) then
                                local item = store.hand
                                if item and item.tool and item.tool.Name == 'infernal_saber' then
                                    bedwars.Client:Get('HellBladeRelease'):SendToServer({
                                        chargeTime = 2,
                                        player = lplr,
                                        weapon = item.tool
                                    })
                                end
                            end
                            task.wait(Legit.Enabled and 0.45 or 0)
                        until not AutoKit.Enabled
                    end,
                    falconer = function()
                        repeat
                            if entitylib.isAlive then
                                local plr = entitylib.EntityPosition({
                                    Range = Legit.Enabled and Range.Value or math.huge,
                                    Part = 'RootPart',
                                    Players = true
                                })
                                if plr then
                                    local calc = prediction.SolveTrajectory(entitylib.character.RootPart.Position, 140, 20, plr.RootPart.Position, plr.RootPart.Velocity, workspace.Gravity, plr.HipHeight, plr.Jumping and 42.6 or nil, false, 0)
                                    bedwars.Client:Get('SendFalconRequested'):SendToServer({
                                        strikeZoneEpicenter = calc or plr.RootPart.Position
                                    })
                                else
                                    bedwars.Client:Get('SendFalconRequested'):SendToServer({
                                        strikeZoneEpicenter = entitylib.character.RootPart.Position
                                    })
                                end
                            end
                            task.wait(0.5)
                        until not AutoKit.Enabled
                    end,
                }
                
                AutoKit = vape.Categories.Utility:CreateModule({
                    Name = 'Auto Kit',
                    Function = function(callback)
                        if callback then
                            repeat task.wait(1) until store.equippedKit ~= '' and store.matchState ~= 0 or (not AutoKit.Enabled)
                            if AutoKit.Enabled and AutoKitFunctions[store.equippedKit] and Toggles[store.equippedKit].Enabled then
                                AutoKitFunctions[store.equippedKit]()
                            end
                        end
                    end,
                    Tooltip = 'Automatically uses kit abilities.'
                })
                Legit = AutoKit:CreateToggle({Name = 'Legit Range'})
                local sortTable = {}
                for i in AutoKitFunctions do
                    table.insert(sortTable, i)
                end
                table.sort(sortTable, function(a, b)
                    return bedwars.BedwarsKitMeta[a].name < bedwars.BedwarsKitMeta[b].name
                end)
                for _, v in sortTable do
                    Toggles[v] = AutoKit:CreateToggle({
                        Name = bedwars.BedwarsKitMeta[v].name,
                        Default = true
                    })
                end
            end)

            run(function()
                local AntiDeath
                local StopThreshold
                local Threshold
                local Notify
                local Delay
                local Mode

                local oldroot, clone, hip

                local function createClone()
                    if entitylib.isAlive and entitylib.character.Humanoid.Health > 0 and (not oldroot or not oldroot.Parent) then
                        repeat task.wait() until not store.rootpart or not store.rootpart.Parent
                        hip = entitylib.character.Humanoid.HipHeight
                        oldroot = entitylib.character.HumanoidRootPart
                        lplr.Character.Parent = game
                        clone = oldroot:Clone()
                        clone.Parent = lplr.Character
                        oldroot.Transparency = 0
                        Instance.new('Highlight', oldroot)
                        oldroot.Parent = workspace.Terrain
                        lplr.Character.PrimaryPart = clone
                        lplr.Character.Parent = workspace
                        for _, v in lplr.Character:GetDescendants() do
                            if v:IsA('Weld') or v:IsA('Motor6D') then
                                if v.Part0 == oldroot then v.Part0 = clone end
                                if v.Part1 == oldroot then v.Part1 = clone end
                            end
                        end
                        store.rootpart = oldroot
                        return true
                    end
                    return false
                end
                
                local function destroyClone()
                    if not oldroot or not oldroot.Parent or not entitylib.isAlive then return false end
                    lplr.Character.Parent = game
                    oldroot.Parent = lplr.Character
                    lplr.Character.PrimaryPart = oldroot
                    lplr.Character.Parent = workspace
                    oldroot.CanCollide = true
                    for _, v in lplr.Character:GetDescendants() do
                        if v:IsA('Weld') or v:IsA('Motor6D') then
                            if v.Part0 == clone then v.Part0 = oldroot end
                            if v.Part1 == clone then v.Part1 = oldroot end
                        end
                    end
                    if clone then
                        clone:Destroy()
                        clone = nil
                    end
                    oldroot.Transparency = 1
                    oldroot = nil
                    entitylib.character.Humanoid.HipHeight = hip or 2 
                    store.rootpart = nil
                end
                
                local Paused, Activated = 0, 0

                AntiDeath = vape.Categories.Utility:CreateModule({
                    Name = 'Anti Death',
                    Function = function(call)
                        if call then
                            local FloatTime = tick();

                            LPH_JIT_MAX(function()
                                AntiDeath:Clean(runService.PreSimulation:Connect(function()
                                    if oldroot and oldroot.Parent then
                                        if (tick() - entitylib.character.AirTime) > 1.7 then
                                            FloatTime = tick() + 0.1
                                        end
                                        oldroot.Velocity = Vector3.new(0, 1, 0)
                                        oldroot.CFrame = clone.CFrame - (tick() > FloatTime and Vector3.new(0, 200, 0) or Vector3.zero)
                                    end
                                end))
                            end)()

                            LPH_NO_VIRTUALIZE(function()
                                repeat
                                    if os.clock() > Paused and entitylib.isAlive and (entitylib.character.Humanoid.Health <= Threshold.Value) then
                                        if (os.clock() - Activated) >= Delay.Value then
                                            Activated = os.clock()

                                            if Notify.Enabled then
                                                notif('AntiDeath', `Triggered callback, Health at {math.floor(entitylib.character.Humanoid.Health)}`, 12, 'warning')
                                            end

                                            if Mode.Value == 'Teleport' then
                                                lplr.Character.PrimaryPart.CFrame += Vector3.new(0, 100, 0)
                                                Paused = os.clock() + 5
                                            elseif Mode.Value == 'Invincibility' then
                                                if createClone() then
                                                    task.delay(0, function()
                                                        repeat task.wait() until not entitylib.isAlive or (entitylib.character.Humanoid.Health >= StopThreshold.Value)
                                                        destroyClone()

                                                        if Notify.Enabled then
                                                            notif('AntiDeath', `You are now visible again`, 12, 'info')
                                                        end
                                                    end)
                                                end
                                                Paused = os.clock() + 5
                                            end
                                        end
                                    end
                                    task.wait()
                                until not AntiDeath.Enabled
                            end)()
                        end
                    end,
                    Tooltip = 'Prevents you from dying',
                })

                Mode = AntiDeath:CreateDropdown({
                    Name = 'Mode',
                    List = {'Teleport', 'Invincibility'},
                    Default = 'Invincibility'
                })

                StopThreshold = AntiDeath:CreateSlider({
                    Name = 'Stop Threshold',
                    Min = 1,
                    Max = 100,
                    Default = 30,
                    Suffix = function()
                        return '%'
                    end,
                    Tooltip = 'Health percentage to untrigger at'
                })

                Threshold = AntiDeath:CreateSlider({
                    Name = 'Threshold',
                    Min = 1,
                    Max = 100,
                    Default = 30,
                    Suffix = function()
                        return '%'
                    end,
                    Tooltip = 'Health percentage to trigger at'
                })

                Delay = AntiDeath:CreateSlider({
                    Name = 'Delay',
                    Min = 1,
                    Max = 20,
                    Default = 5,
                    Suffix = function(val)
                        return val <= 1 and 'sec' or 'secs'
                    end,
                    Tooltip = 'Delay between triggers'
                })

                Notify = AntiDeath:CreateToggle({
                    Name = 'Notify on trigger',
                    Default = true
                })
            end)

            run(function()
                local AntiSuffocate

                AntiSuffocate = vape.Categories.Utility:CreateModule({
                    Name = 'Anti Suffocate',
                    Premium = isPremium,
                    Function = function(call)
                        if call then
                            repeat
                                if entitylib.isAlive then
                                    if 
                                        getPlacedBlock(entitylib.character.RootPart.Position) 
                                        and (getPlacedBlock(entitylib.character.RootPart.Position + Vector3.new(0, 2, 0))
                                        or getPlacedBlock(entitylib.character.RootPart.Position - Vector3.new(0, 2, 0)))
                                    then
                                        entitylib.character.RootPart.CFrame += Vector3.new(0, 2.5, 0)
                                        entitylib.character.RootPart.Velocity = Vector3.zero
                                    end
                                end
                                task.wait(0.05)
                            until not AntiSuffocate.Enabled
                        end
                    end,
                    Tooltip = 'Prevents you from suffocating in blocks'
                })
            end)
        end)()

        local namecall
        local rng = Random.new()
        local num = rng:NextNumber()
        local lastpacket = os.clock()
        local nigger = os.clock()

        LPH_NO_VIRTUALIZE(function()
            run(function() --> by max
                local FakeLag
                local TransmissionOffset
                local Mode
                local Delay

                FakeLag = vape.Categories.Utility:CreateModule({
                    Name = 'Fake Lag',
                    Function = function(callback)
                        if callback then
                            local clock = os.clock()
                            local restore = os.clock()

                            repeat
                                local ms = Delay.Value / 1000

                                if Mode.Value == 'Dynamic' then
                                    if (os.clock() - clock) >= ms or restore > os.clock() then
                                        if clock ~= 9e9 then
                                            restore = os.clock() + TransmissionOffset.Value
                                            clock = 9e9
                                        end
                                        setfflag('PhysicsSenderMaxBandwidthBps', '38760')
                                    else
                                        if clock == 9e9 then
                                            clock = os.clock()
                                            restore = 0
                                        end
                                        setfflag('PhysicsSenderMaxBandwidthBps', '0')
                                    end
                                elseif Mode.Value == 'Repel' then
                                    
                                    if lastpacket > os.clock() then
                                        notif('Vape', 'Packet delayed', 2, 'info')
                                        setfflag('PhysicsSenderMaxBandwidthBps', '0')
                                        setfflag('S2PhysicsSenderRate', '0')
                                        setfflag('DataSenderRate', '-1')
                                        task.wait(rng:NextNumber(70, 150) / 1000)
                                        setfflag('PhysicsSenderMaxBandwidthBps', '38760')
                                        setfflag('DataSenderRate', '60')
                                        setfflag('S2PhysicsSenderRate', '15')
                                        nigger = os.clock() + rng:NextNumber(0.001, (Delay.Value / 1000))
                                        lastpacket = os.clock()
                                        num = rng:NextNumber()
                                    end
                                    if os.clock() > nigger then
                                        num = rng:NextNumber()
                                        nigger = os.clock() + rng:NextNumber(0.001, (Delay.Value / 1000))
                                    end

                                elseif Mode.Value == 'Latency' then
                                    setfflag('PhysicsSenderMaxBandwidthBps', '0')
                                    task.wait(Delay.Value / 1500)
                                    setfflag('PhysicsSenderMaxBandwidthBps', '38760')
                                    task.wait(ms)
                                end
                                runService.PreRender:Wait()
                            until not FakeLag.Enabled
                        else
                            setfflag('DataSenderRate', '60')
                            setfflag('PhysicsSenderMaxBandwidthBps', '38760')
                        end
                    end,
                    Tooltip = 'Delays packets, simulating lag',
                    ExtraText = function()
                        return Mode and Mode.Value or 'Dynamic'
                    end
                })

                TransmissionOffset = FakeLag:CreateSlider({
                    Name = 'Transmission Offset',
                    Min = 1,
                    Max = 10,
                    Default = 3,
                    Decimal = 5,
                    Darker = true
                })

                Mode = FakeLag:CreateDropdown({
                    Name = 'Mode',
                    List = {'Dynamic', 'Repel', 'Latency'},
                    Default = 'Dynamic',
                    Function = function(val)
                        TransmissionOffset.Object.Visible = val == 'Dynamic'
                        setfflag('PhysicsSenderMaxBandwidthBps', '38760')
                    end
                })

                Delay = FakeLag:CreateSlider({
                    Name = 'Delay',
                    Suffix = function()
                        return 'ms'
                    end,
                    Min = 1,
                    Max = 500,
                    Default = 100
                })
            end)
        end)()

        LPH_NO_VIRTUALIZE(function()
            if hookmetamethod then
                namecall = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
                    if not vape or not vape.Modules then
                        return namecall(self, ...)
                    end

                    if 
                        getnamecallmethod() ~= 'FireServer'
                        or typeof(self) == 'Instance'
                        and tostring(self.Parent) ~= '_NetManaged'
                    then
                        return namecall(self, ...)
                    end

                    if tostring(self) == 'SwordHit' then
                        if num < 0.35 then
                            lastpacket = os.clock() + 1
                        end
                    end
                
                    return namecall(self, ...)
                end))
            end
        end)()

        LPH_JIT_MAX(function()
            run(function() --> by max
                local Deflect
                local Mode
                local Range
                local Legit

                Deflect = vape.Categories.Legit:CreateModule({
                    Name = 'Deflect',
                    Tooltip = 'Deflects placed tnts',
                    Function = function(call)
                        if call then
                            local TNTs = {}

                            LPH_NO_VIRTUALIZE(function()
                                collection('block', Deflect, function(tab, obj)
                                    if obj.Name == 'tnt' then
                                        TNTs[obj] = true
                                    end
                                end)
                            
                                repeat
                                    if Mode.Value == 'On key' then
                                        Deflect:Toggle()
                                    end
                                    for v, i in TNTs do
                                        if i == true and v.Name == 'tnt' and (entitylib.character.RootPart.Position - v.Position).Magnitude <= Range.Value then
                                            for _, v2 in getProjectiles() do
                                                if os.clock() > (FireDelays[v2[1].itemType] or 0) then
                                                    TNTs[v] = false
                                                    local old = store.hand and store.hand.tool
                                                    shootFunc(v2, {
                                                        RootPart = v,
                                                        Humanoid = {Health = 10, MaxHealth = 10},
                                                        Character = v,
                                                        Health = 10,	
                                                        MaxHealth = 10
                                                    }, entitylib.character.RootPart.Position, Vector3.zero)
                                                    if Legit.Enabled and old then
                                                        switchItem(old)
                                                    end
                                                    break
                                                end
                                            end
                                        end
                                    end
                                    task.wait()
                                until not Deflect.Enabled
                            end)()
                        end
                    end
                })

                Mode = Deflect:CreateDropdown({
                    Name = 'Mode',
                    List = {'Toggle', 'On key'},
                    Default = 'Toggle'
                })

                Range = Deflect:CreateSlider({
                    Name = 'Range',
                    Min = 1,
                    Max = 50,
                    Default = 35
                })

                Legit = Deflect:CreateToggle({Name = 'Legit', Default = true})
            end)

            LPH_NO_VIRTUALIZE(function() --> by max and selunar
                local Clutch
                local SilentAim
                local AutoSwitch
                local Return
                local ReturnMs
                local Limit
                local Falling
                local Void
                local OnMore	
                local BlockCount
                local UseBlacklist 
                local Blacklist

                
                local rayCheck = RaycastParams.new()
                rayCheck.RespectCanCollide = true
                rayCheck.FilterType = Enum.RaycastFilterType.Exclude

                local function getBlocks()
                    local blocks = {}
                    for _, item in store.inventory.inventory.items do
                        local block = bedwars.ItemMeta[item.itemType].block
                        if block and (not UseBlacklist.Enabled or not table.find(Blacklist.ListEnabled, item.tool.Name)) and (not AutoSwitch.Enabled or getHotbar(item.tool)) then
                            table.insert(blocks, {item.itemType, block.health, item.tool})
                        end
                    end
                    table.sort(blocks, function(a, b) return a[2] < b[2] end)
                    return blocks
                end

                local function isBlock(pos)
                    return getPlacedBlock(pos) ~= nil
                end

                local function hasAdjacentBlock(pos)
                    local dirs = {
                        Vector3.new(3, 0, 0),
                        Vector3.new(-3, 0, 0),
                        Vector3.new(0, 3, 0),
                        Vector3.new(0, -3, 0),
                        Vector3.new(0, 0, 3),
                        Vector3.new(0, 0, -3)
                    }
                    for _, v in dirs do
                        if isBlock(pos + v) then
                            return true
                        end
                    end
                    return false
                end

                local function findNearestBlock(startPos, radius)
                    local nearestBlock, nearestDist = nil, radius
                    for x = -radius, radius, 3 do
                        for y = -3, 3, 3 do
                            for z = -radius, radius, 3 do
                                local checkPos = startPos + Vector3.new(x, y, z)
                                if isBlock(checkPos) then
                                    local dist = (checkPos - startPos).Magnitude
                                    if dist < nearestDist and checkPos.Y <= (startPos.Y + 0.5) then
                                        nearestBlock, nearestDist = checkPos, dist
                                    end
                                end
                            end
                        end
                    end
                    return nearestBlock
                end

                local function snapToSide(pos, radius)
                    local nearest = findNearestBlock(pos, radius)
                    if not nearest then return nil end
                    local dirs = {
                        Vector3.new(3, 0, 0),
                        Vector3.new(-3, 0, 0),
                        Vector3.new(0, 3, 0),
                        Vector3.new(0, -3, 0),
                        Vector3.new(0, 0, 3),
                        Vector3.new(0, 0, -3)
                    }
                    local best, dist = nil, math.huge
                    for _, v in dirs do
                        local cand = nearest + v
                        if not isBlock(cand) then
                            local d = (cand - pos).Magnitude
                            if d < dist then
                                dist = d
                                best = cand
                            end
                        end
                    end
                    return best
                end

                local function predictPlacement(pos, moveDir)
                    if moveDir.Magnitude == 0 then return pos end
                    local diag = Vector3.new(moveDir.X, 0, moveDir.Z).Unit * 3
                    local down = Vector3.new(0, -3, 0)
                    local diagPos = pos + diag
                    if hasAdjacentBlock(diagPos) then
                        return diagPos
                    elseif hasAdjacentBlock(diagPos + down) then
                        return diagPos + down
                    elseif hasAdjacentBlock(pos + down) then
                        return pos + down
                    end
                    local snapped = snapToSide(diagPos, 12)
                    return snapped or pos
                end

                local function findNearestBlock(startPos, radius)
                    local nearestBlock, nearestDist = nil, radius
                    local check = 0

                    for x = -radius, radius, 3 do
                        for y = -radius, radius, 3 do
                            for z = -radius, radius, 3 do
                                local checkPos = startPos + Vector3.new(x, y, z)
                                if isBlock(checkPos) then
                                    check += 1
                                    local dist = (checkPos - startPos).Magnitude
                                    if dist < nearestDist and checkPos.Y <= (startPos.Y + 0.5) then
                                        nearestBlock, nearestDist = checkPos, dist
                                    end
                                end
                            end
                        end
                    end
                    return nearestBlock, check
                end

                Clutch = vape.Categories.Utility:CreateModule({
                    Name = 'Clutch',
                    Function = function(call)
                        if call then
                            local lookAt, lastpos = nil, Vector3.zero
                            local expire, startY = os.clock()
                            local startyclock = os.clock()
                            local clutching, lastClutch, lastTool = os.clock()

                            Clutch:Clean(runService.PreRender:Connect(function(dt)
                                if entitylib.isAlive and not vape.Modules['Block-In'].Enabled and os.clock() > expire then
                                    if lplr.Character:FindFirstChild('Humanoid') then
                                        lplr.Character.Humanoid.AutoRotate = os.clock() > expire
                                        clutchActive = not lplr.Character.Humanoid.AutoRotate
                                    end
                                    if clutchActive then
                                        entitylib.character.RootPart.CFrame =
                                            entitylib.character.RootPart.CFrame:Lerp(
                                                CFrame.lookAt(
                                                    entitylib.character.RootPart.Position,
                                                    Vector3.new(lastpos.X, entitylib.character.RootPart.Position.Y, lastpos.Z)
                                                ),
                                                20 * dt
                                            )
                                    end
                                end
                            end))

                            repeat
                                task.wait()
                                if entitylib.isAlive then
                                    local root, wool
                                    local suc = pcall(function()
                                        root = entitylib.character.RootPart
                                        wool =
                                            (Limit.Enabled and not AutoSwitch.Enabled)
                                                and store.hand.tool
                                                and { store.hand.tool.Name, 1, store.hand.tool }
                                            or (not Limit.Enabled or AutoSwitch.Enabled)
                                                and getBlocks()[1]
                                    end)
                                    if not suc then continue end

                                    local ray = Void.Enabled
                                            and (workspace:Raycast(
                                                entitylib.character.RootPart.Position + (entitylib.character.Humanoid.MoveDirection * 2),
                                                Vector3.new(0, -100, 0),
                                                rayCheck
                                            ))
                                        or (not Void.Enabled and true or nil)
                                    local fallingdown = Falling.Enabled and entitylib.character.RootPart.Velocity.Y < -50
                                        

                                    if (not ray or (fallingdown) or (
                                        OnMore.Enabled
                                        and ({findNearestBlock(root.Position, 5)})[2] <= BlockCount.Value
                                    )) and wool then
                                        if Clutch.Options['Adjust CPS'].Enabled then
                                            sharedConstants.BLOCK_PLACE_CPS = 17 
                                        end
    
                                        if store.hand.tool ~= wool[3] and AutoSwitch.Enabled then
                                            lastTool = getHotbar(store.hand.tool) or 2
                                            hotbarSwitch(getHotbar(wool[3]))
                                        end
                                        
                                        lastClutch = true
                                        clutching = os.clock() + (AutoSwitch.Enabled and (ReturnMs:GetRandomValue() / 10) or 0.2)
                                        if SilentAim.Enabled then
                                            expire = os.clock() + 0.1
                                        end

                                        local moveDir = entitylib.character.Humanoid.MoveDirection
                                        local rootPos = root.Position
                                        local negative = 0
                                        if os.clock() > startyclock then
                                            if fallingdown then
                                                startyclock = os.clock() + 0.1
                                                negative = rootPos.Y - (entitylib.character.RootPart.Velocity.Y * -1) / 10
                                            else
                                                negative = rootPos.Y
                                            end
                                        end

                                        for _ = 3, 1, -1 do
                                            local currentpos = roundPos((Vector3.new(rootPos.X, negative, rootPos.Z) + (fallingdown and Vector3.zero or (moveDir * 2))) - Vector3.new(0, entitylib.character.Humanoid.HipHeight + 2.5, 0))
                                            if not isBlock(currentpos) then
                                                local targetPos = predictPlacement(currentpos, Vector3.zero)
                                                if targetPos and hasAdjacentBlock(targetPos) then
                                                    task.spawn(bedwars.placeBlock, targetPos, wool[1], false)
                                                else
                                                    local snapped = snapToSide(currentpos, 12)
                                                    if snapped and hasAdjacentBlock(snapped) then
                                                        task.spawn(bedwars.placeBlock, snapped, wool[1], false)
                                                    else
                                                        local near = findNearestBlock(currentpos, 21)
                                                        if near then
                                                            local dirs = {
                                                                Vector3.new(0, -3, 0),
                                                                Vector3.new(3, 0, 0),
                                                                Vector3.new(-3, 0, 0),
                                                                Vector3.new(0, 0, 3),
                                                                Vector3.new(0, 0, -3)
                                                            }
                                                            local best, dist = nil, math.huge
                                                            for _, v in dirs do
                                                                local cand = near + v
                                                                if not isBlock(cand) and hasAdjacentBlock(cand) then
                                                                    local d = (cand - currentpos).Magnitude
                                                                    if d < dist and d <= 21 then
                                                                        dist = d
                                                                        best = cand
                                                                    end
                                                                end
                                                            end
                                                            if best then
                                                                task.spawn(bedwars.placeBlock, best, wool[1], false)
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            lastpos = currentpos
                                        end
                                    end

                                    if os.clock() > clutching and lastClutch then
                                        lastClutch = false
                                        sharedConstants.BLOCK_PLACE_CPS = 12
                                        if Return.Enabled then
                                            hotbarSwitch(lastTool)
                                        end
                                    end
                                end
                            until not Clutch.Enabled
                        end
                    end,
                    Tooltip = 'Performs clutches when certain action happens'
                })

                Void = Clutch:CreateToggle({ Name = 'On void' })
                Falling = Clutch:CreateToggle({ Name = 'On lethal fall', Default = true })

                AutoSwitch = Clutch:CreateToggle({
                    Name = 'Auto Switch',
                    Default = true,
                    Function = function(call)
                        if Limit then Limit.Object.Visible = not call end
                        if Return then Return.Object.Visible = call end
                        if not call then ReturnMs.Object.Visible = false end
                    end
                })

                Return = Clutch:CreateToggle({
                    Name = 'Return to last slot',
                    Default = true,
                    Function = function(callback)
                        if ReturnMs then ReturnMs.Object.Visible = callback end
                    end
                })

                ReturnMs = Clutch:CreateTwoSlider({
                    Name = 'Return Delay',
                    Min = 1,
                    Max = 10,
                    DefaultMin = 3,
                    DefaultMax = 6,
                    Darker = true
                })

                Limit = Clutch:CreateToggle({ Name = 'Limit to items' })
                Limit.Object.Visible = false

                OnMore = Clutch:CreateToggle({
                    Name = 'On more than X blocks'
                })

                Clutch:CreateToggle({
                    Name = 'Adjust CPS'
                })

                BlockCount = Clutch:CreateSlider({
                    Name = 'Blocks',
                    Darker = true,
                    Min = 1,
                    Max = 10
                })

                SilentAim = Clutch:CreateToggle({
                    Name = 'Silent aim',
                    Tooltip = 'Aims you serversidedly and won’t affect your client'
                })

                UseBlacklist = Clutch:CreateToggle({
                    Name = 'Use blacklist',
                    Default = true,
                    Function = function(call)
                        if Blacklist then Blacklist.Object.Visible = call end
                    end
                })

                Blacklist = Clutch:CreateTextList({
                    Name = 'Blacklists',
                    Placeholder = 'block',
                    Default = { 'cannon', 'tnt', 'siege_tnt' }
                })
            end)()

            run(function() --> by max
                local AutoDavey
                local Switch
                local Break
                local Jump

                local old

                AutoDavey = vape.Categories.Utility:CreateModule({
                    Name = 'Auto Davey',
                    Tooltip = 'Automatically breaks cannon/jump on launch',
                    Function = function(call)
                        if call then
                            old = bedwars.CannonHandController.launchSelf
                            bedwars.CannonHandController.launchSelf = function(...)
                                local res = {old(...)}
                                local self, block = ...
                    
                                if Break.Enabled then
                                    if block:GetAttribute('PlacedByUserId') == lplr.UserId and (block.Position - entitylib.character.RootPart.Position).Magnitude < 30 then
                                        for i = 1, 2 do
                                            task.spawn(bedwars.breakBlock, block, false, nil, true, Switch.Enabled)
                                        end
                                    end	
                                end

                                if Jump.Enabled then
                                    lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                                end
                    
                                return unpack(res)
                            end
                        else
                            bedwars.CannonHandController.launchSelf = old
                        end
                    end
                })

                Jump = AutoDavey:CreateToggle({Name = 'Jump on impact'})
                Break = AutoDavey:CreateToggle({Name = 'Break on impact'})
                Switch = AutoDavey:CreateToggle({Name = 'Legit switch'})
            end)

            run(function() --> by max
                local AutoWhisper
                local Heal
                local Threshold
                local Fly
                local Level

                AutoWhisper = vape.Categories.Utility:CreateModule({
                    Name = 'Auto Whisper',
                    Function = function(callback)
                        if callback then
                            LPH_NO_VIRTUALIZE(function()
                                repeat
                                    local liftReady = Fly.Enabled and (workspace:GetServerTimeNow() - (lplr:GetAttribute('OwlLiftReadyTime') or 0)) > 0
                                    local healReady = Heal.Enabled and (workspace:GetServerTimeNow() - (lplr:GetAttribute('OwlLiftReadyTime') or 0)) > 0
                                    
                                    if liftReady or healReady then
                                        for _, v in collectionService:GetTagged('Owl') do
                                            if v:GetAttribute('Owner') == lplr.UserId then
                                                local plr = playersService:GetPlayerByUserId(v:GetAttribute('Target'))
                                                if plr then
                                                    if liftReady and plr.Character.HumanoidRootPart.Velocity.Y < -Level.Value then
                                                        local lowestpoint = math.huge
                                                        for _, v in store.blocks do
                                                            local point = (v.Position.Y - (v.Size.Y / 2)) - 50
                                                            if point < lowestpoint then 
                                                                lowestpoint = point 
                                                            end
                                                        end

                                                        if entitylib.character.RootPart.Position.Y < lowestpoint then
                                                            bedwars.AbilityController:useAbility('OWL_LIFT')
                                                        end
                                                    end
                                                    if healReady and (Threshold.Value >= 100 or (plr.Character:GetAttribute('Health') / plr.Character:GetAttribute('MaxHealth')) <= (Threshold.Value / 100)) then
                                                        bedwars.AbilityController:useAbility('OWL_HEAL')
                                                    end
                                                end
                                                break
                                            end
                                        end
                                    end
                                    task.wait()
                                until not AutoWhisper.Enabled
                            end)()
                        end
                    end,
                    Tooltip = 'Automatically uses whisper abilities'
                })

                Heal = AutoWhisper:CreateToggle({
                    Name = 'Heal',
                    Default = true,
                    Function = function(call)
                        if Threshold then
                            Threshold.Object.Visible = call
                        end
                    end
                })

                Threshold = AutoWhisper:CreateSlider({
                    Name = 'Health',
                    Min = 1,
                    Max = 100,
                    Default = 99,
                    Suffix = '%',
                    Darker = true
                })

                Fly = AutoWhisper:CreateToggle({
                    Name = 'Fly',
                    Default = true,
                    Function = function(call)
                        if Level then
                            Level.Object.Visible = call
                        end
                    end
                })

                Level = AutoWhisper:CreateSlider({
                    Name = 'Level',
                    Min = 1,
                    Max = 200,
                    Default = 100,
                    Suffix = 'y'
                })
            end)

            run(function() --> by max
                local BowHit
                local SwapDelay

                local shooting, old
                
                local function getCrossbows()
                    local crossbows = {}
                    for i, v in store.inventory.hotbar do
                        if v.item and v.item.itemType:find('crossbow') and i ~= (store.inventory.hotbarSlot + 1) then 
                            table.insert(crossbows, i - 1) 
                        end
                    end
                    return crossbows
                end

                BowHit = vape.Categories.Utility:CreateModule({
                    Name = 'Auto Shoot',
                    Function = function(callback)
                        if callback then
                            old = bedwars.ProjectileController.createLocalProjectile
                            bedwars.ProjectileController.createLocalProjectile = function(...)
                                local source, data, proj = ...
                                if source and (proj == 'arrow' or proj == 'fireball') and not shooting then
                                    task.spawn(function()
                                        local bows = getCrossbows()
                                        if #bows > 0 then
                                            shooting = true
                                            task.wait(SwapDelay.Value / 5000)
                                            local selected = store.inventory.hotbarSlot
                                            for _, v in getCrossbows() do
                                                if hotbarSwitch(v) then
                                                    task.wait()
                                                    getgenv().swapping = os.clock()
                                                    mouse1click()
                                                    task.wait(SwapDelay.Value / 5000)
                                                    if mouse1press then
                                                        mouse1press()
                                                    end
                                                end
                                            end
                                            hotbarSwitch(selected)
                                            shooting = false
                                        end
                                    end)
                                end
                                return old(...)
                            end

                            local canShoot = os.clock() + 0.75

                            LPH_NO_VIRTUALIZE(function()
                                repeat
                                    if (tick() - bedwars.SwordController.lastSwing) < 0.33 and os.clock() > canShoot then
                                        local projectiles = getProjectiles({
                                            'fireball',
                                            'snowball'
                                        })

                                        local oldhotbar = getHotbar(store.hand.tool)

                                        for i,v in projectiles do
                                            local item = v[1]
                                            local newhotbar = getHotbar(item.tool)

                                            if newhotbar then
                                                getgenv().swapping = os.clock()
                                                hotbarSwitch(newhotbar)
                                                task.wait()
                                            end

                                            if mouse1click then
                                                mouse1click()
                                            end

                                            canShoot = os.clock() + 1.25
                                            task.wait()
                                        end

                                        if oldhotbar then
                                            task.wait(SwapDelay.Value / 1000)
                                            if mouse1press then
                                                mouse1press()
                                            end
                                            hotbarSwitch(oldhotbar)
                                            getgenv().swapping = os.clock() - 1
                                        end

                                    elseif (tick() - bedwars.SwordController.lastSwing) > 0.33 then
                                        canShoot = os.clock() + 1.25
                                    end
                                    task.wait()
                                until not BowHit.Enabled
                            end)()
                        else
                            bedwars.ProjectileController.createLocalProjectile = old
                            old = nil
                        end
                    end,
                    Tooltip = 'Automatically swaps to ur bows whenever ur swinging'
                })

                SwapDelay = BowHit:CreateSlider({
                    Name = 'Swap delay',
                    Min = 50,
                    Max = 1500,
                    Default = 150,
                    Suffix = 'ms'
                })
            end)

            run(function() --> by max
                local AutoLassy
                local SwapDelay

                local LassoCooldown, Cancel = tick(), tick()

                AutoLassy = vape.Categories.Utility:CreateModule({
                    Name = 'Auto Lasso',
                    Function = function(callback)
                        if callback then
                            LPH_NO_VIRTUALIZE(function()
                                repeat
                                    if (tick() - bedwars.SwordController.lastSwing) < 0.33 and tick() > LassoCooldown then
                                        local lasso = getItem('lasso')

                                        if lasso then
                                            local oldhotbar = getHotbar(store.hand.tool)

                                            getgenv().swapping = os.clock()

                                            local newhotbar = getHotbar(lasso.tool)

                                            if newhotbar then
                                                hotbarSwitch(newhotbar)
                                                task.wait()
                                            end

                                            if mouse1click then
                                                mouse1click()
                                            end

                                            LassoCooldown = tick() + 5.5
                                            task.wait()

                                            if oldhotbar then
                                                task.wait(SwapDelay.Value / 1000)
                                                if mouse1press then
                                                    mouse1press()
                                                end
                                                hotbarSwitch(oldhotbar)
                                            end
                                        end

                                    elseif (tick() - bedwars.SwordController.lastSwing) > 0.33 then
                                        LassoCooldown = tick() + 1.25
                                    end
                                    task.wait()
                                until not AutoLassy.Enabled
                            end)()
                        end
                    end,
                    Tooltip = 'Automatically swaps to lasso whenever youre swinging ur sword'
                })

                SwapDelay = AutoLassy:CreateSlider({
                    Name = 'Swap delay',
                    Min = 50,
                    Max = 1500,
                    Default = 150,
                    Suffix = 'ms'
                })
            end)

            run(function() --> by max
                local AutoMount
                local LegitRange

                local Tags = {'dodo-bird'}

                AutoMount = vape.Categories.Utility:CreateModule({
                    Name = 'Auto Mount',
                    Function = function(callback)
                        if callback then
                            for _, tag in Tags do
                                for __, v in collectionService:GetTagged(tag) do
                                    if LegitRange.Enabled then
                                        if (entitylib.character.RootPart.Position - v:GetPivot().Position).Magnitude >= 8 then
                                            return
                                        end
                                    else
                                        local clock = os.clock() + 0.5
                                        repeat
                                            v:PivotTo(entitylib.character.RootPart.CFrame)
                                            task.wait()
                                        until os.clock() > clock
                                    end
                                    bedwars.Client:Get('InteractDodoBird'):SendToServer({
                                        action = 'Mount',
                                        dodoBird = v
                                    })
                                end

                                AutoMount:Clean(collectionService:GetInstanceAddedSignal(tag):Connect(function(v)
                                    if LegitRange.Enabled then
                                        if (entitylib.character.RootPart.Position - v:GetPivot().Position).Magnitude >= 8 then
                                            return
                                        end
                                    else
                                        local clock = os.clock() + 0.5
                                        repeat
                                            v:PivotTo(entitylib.character.RootPart.CFrame)
                                            task.wait()
                                        until os.clock() > clock
                                    end
                                    bedwars.Client:Get('InteractDodoBird'):SendToServer({
                                        action = 'Mount',
                                        dodoBird = v
                                    })
                                end))
                            end
                        end
                    end,
                    Tooltip = 'Automatically mounts stuff in the map, ex: dodo bird'
                })

                LegitRange = AutoMount:CreateToggle({
                    Name = 'Legit Range'
                })
            end)

            run(function() --> by max
                local Disabler
                local MomentumUpdate = bedwars.Client:Get('MomentumUpdate')
                local Killable = false

                local BridgeData = {
                    Enabled = false
                }

                local envs = {
                    glacial_skater = require(replicatedStorage.TS.games.bedwars.kit.kits['glacial-skater']['glacial-skater-balance']).GlacialSkaterBalance
                }

                Disabler = vape.Categories.Blatant:CreateModule({
                    Name = 'Disabler',
                    Tooltip = 'Uses various methods to bypass the anticheat',
                    Function = function(call)
                        if call then
                            Disabler:Clean(bedwars.Client:Get('SpiritBridgeCreate').instance.OnClientEvent:Connect(function(args)
                                if args.newBridgeInfo[1] and args.newBridgeInfo[1].creator == lplr then
                                    BridgeData.Id = args.newBridgeInfo[1].bridge.id
                                    BridgeData.Enabled = true
                                end
                            end))

                            Disabler:Clean(bedwars.Client:Get('SpiritBridgeExit').instance.OnClientEvent:Connect(function(args)
                                if args[1].bridgeId == BridgeData.Id then
                                    BridgeData.Enabled = false
                                end
                            end))

                            local found = false 
                            Disabler:Clean(vapeEvents.DisablerEnabled.Event:Connect(function()
                                found = true
                            end))
                            
                            LPH_JIT_MAX(function()
                                repeat
                                    if BridgeData.Enabled then
                                        bedwars.Client:Get('SpiritBridgeEnter'):SendToServer(BridgeData.Id, 9e9)
                                        if not found then
                                            vapeEvents.DisablerEnabled:Fire()
                                        end
                                        getgenv().speedBoosts.Value = 50
                                    elseif store.equippedKit == 'glacial_skater' then
                                        MomentumUpdate:SendToServer({
                                            momentumValue = 10000000000000
                                        })
                                        for i, v in envs.glacial_skater do
                                            if typeof(v) == 'number' then
                                                envs.glacial_skater[i] = math.huge
                                            end
                                        end

                                        if not found then
                                            vapeEvents.DisablerEnabled:Fire()
                                        end
                                        getgenv().speedBoosts.Value = 50			
                                    else
                                        getgenv().speedBoosts.Value = 0
                                    end
                                    runService.PreRender:Wait()
                                until not Disabler.Enabled
                            end)()
                        else
                            getgenv().speedBoosts.Value = 0
                        end
                    end
                })
            end)
        end)()

        --[[
            World
        ]]

        run(function() --> by max
			local MLG
			local old

			local methods = {
				balloon = function()
					bedwars.BalloonController:inflateBalloon()
					
					task.delay(0.5, bedwars.BalloonController.deflateBalloon, bedwars.BalloonController)
				end,
				gumdrop_bounce_pad = function(item)
					task.spawn(bedwars.placeBlock, entitylib.character.RootPart.Position - Vector3.new(0, entitylib.character.HipHeight, 0), item.itemType)
				end,
                telepearl = function(item)

                end,
			}

			MLG = vape.Categories.World:CreateModule({
				Name = 'MLG',
                Tooltip = 'Uses selected item to prevent fall damage',
				Function = function(call)
					if call then
                        local tracked, velo, r = 0, 0, 0
                        old = bedwars.LaunchPadController.attemptLaunch
                        bedwars.LaunchPadController.attemptLaunch = function(...)
                            local res = {old(...)}
                            local self, block = ...
                
                            if (workspace:GetServerTimeNow() - self.lastLaunch) < 0.4 then
                                if block:GetAttribute('PlacedByUserId') == lplr.UserId and (block.Position - entitylib.character.RootPart.Position).Magnitude < 30 then
                                    task.delay(0, bedwars.breakBlock, block, false, nil, true)
                                end
                            end
                
                            return unpack(res)
                        end

                        LPH_NO_VIRTUALIZE(function()
                            MLG:Clean(runService.PreSimulation:Connect(function()
                                if entitylib.isAlive then
                                    tracked = velo
                                    
                                    if tracked < -86 and entitylib.character.Humanoid.FloorMaterial ~= Enum.Material.Air and os.clock() > r then
                                        for item, callback in methods do
                                            if MLG.Options[item].Enabled then
                                                local i = getItem(item)
                                                if i then
                                                    callback(i)
                                                    break
                                                end
                                            end
                                        end
                                        
                                        r = os.clock() + 1.25
                                    end

                                    velo = entitylib.character.RootPart.Velocity.Y
                                end
                            end))
                        end)()
					else
						bedwars.LaunchPadController.attemptLaunch = old
					end
				end
			})

            for i in methods do
                MLG:CreateToggle({
                    Name = i,
                    Default = true
                })
            end
		end)

        run(function() --> by max
			local FastPlace
			local HeldItem

			local old
			local Callbacks = {
				All = function(self, enable)
					for _, v in self do
						if _ ~= 'All' then
							v(self, enable)
						end
					end
				end,
				Blocks = function(self, enable)
					sharedConstants.BLOCK_PLACE_CPS = enable and 12.5 or 12
				end,
				Sword = function(self, enable)
					debug.setconstant(bedwars.SwordController.isClickingTooFast, 4, enable and 0.10 or 0.1111111111111111) 
				end,
				Projectiles = function(self, enable)
					if enable then
						old = bedwars.ProjectileController.calculateImportantLaunchValues
						bedwars.ProjectileController.calculateImportantLaunchValues = function(a, cons, ...)
							cons.drawDurationSeconds += 0.2
							return old(a, cons, ...)
						end
					else
						bedwars.ProjectileController.calculateImportantLaunchValues = old
					end
				end
			}

			FastPlace = vape.Categories.World:CreateModule({
				Name = 'Fast Place',
				Tooltip = 'Changes the item\'s usage delay',
				Function = function(call)
					if call then
						Callbacks[HeldItem.Value](Callbacks, true)
					else
						for i,v in Callbacks do
							v(Callbacks, false)
						end
					end
				end
			})

			HeldItem = FastPlace:CreateDropdown({
				Name = 'Held Item',
				List = {'All', 'Blocks', 'Projectiles'},
				Tooltip = 'What kind of items should FastPlace function with?\nAll - All items/blocks\nBlocks - All blocks\nProjectiles - every projectile sources',
				Function = function()
					if FastPlace.Enabled then
						FastPlace:Toggle()
						FastPlace:Toggle()
					end
				end
			})
		end)

        run(function() --> by max
            local AntiAFK
            local Start
            local Frequency
            local KeepClose
            local Rotation
            local SilentAim
            local Yaw

            local rand = Random.new()

            local rayCheck = RaycastParams.new()
            rayCheck.RespectCanCollide = true
            rayCheck.FilterType = Enum.RaycastFilterType.Exclude

            local function walkTo(position)
                local oldCFrame = entitylib.character.RootPart.CFrame
                local lookVector = oldCFrame.LookVector

                local dir = CFrame.lookAt(oldCFrame.Position, position).LookVector

                local localfacing = dir * Vector3.new(1, 0, 1)
                
                local delta = (entitylib.character.RootPart.Position - position)
                local angle = math.acos(localfacing:Dot((delta * Vector3.new(1, 0, 1)).Unit))
                local declineRotation-- = angle > (math.rad(Yaw.Value) / 2)

                repeat
                    allow = os.clock() + 0.1
                    moveDirection = dir

                    if not Rotation.Enabled or declineRotation then
                        lplr.Character.Humanoid.AutoRotate = false
                        entitylib.character.RootPart.CFrame = CFrame.lookAt(entitylib.character.RootPart.Position, entitylib.character.RootPart.Position + lookVector)
                    end
                    task.wait()
                    if not workspace:Raycast(entitylib.character.RootPart.Position + entitylib.character.Humanoid.MoveDirection, Vector3.new(0, -6, 0), rayCheck) or (entitylib.character.RootPart.Position - oldCFrame.Position).Magnitude >= (KeepClose.Enabled and 4 or 9) then
                        break
                    end
                    if workspace:Raycast(entitylib.character.RootPart.Position - Vector3.new(0, 1, 0), entitylib.character.RootPart.CFrame.LookVector * 2, rayCheck) ~= nil then
                        allow = os.clock() + 0.2
                        task.wait(0.2)
                        break
                    end
                until false

                allow = os.clock()
            end
            
            AntiAFK = vape.Categories.World:CreateModule({
                Name = 'Anti-AFK',
                Function = function(callback)
                    if callback then
                        task.spawn(function()
                            for _, v in getconnections(lplr.Idled) do
                                v:Disconnect()
                            end
                
                            for _, v in getconnections(runService.Heartbeat) do
                                if type(v.Function) == 'function' and table.find(debug.getconstants(v.Function), remotes.AfkStatus) then
                                    v:Disconnect()
                                end
                            end
                
                            bedwars.Client:Get(remotes.AfkStatus):SendToServer({
                                afk = false
                            })
                        end)

                        local lastInput = os.clock()
                        AntiAFK:Clean(inputService.InputBegan:Connect(function()
                            lastInput = os.clock()
                        end))

                        local afkpos = entitylib.character.RootPart.Position

                        LPH_NO_VIRTUALIZE(function()
                            repeat
                                if (os.clock() - lastInput) >= Start:GetRandomValue() and rand:NextNumber(0, 20) < Frequency.Value then
                                    local root = entitylib.character.RootPart

                                    rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}
                                    rayCheck.CollisionGroup = root.CollisionGroup

                                    local ray = workspace:Raycast(afkpos, Vector3.new(rand:NextNumber(-6, 6), -10, rand:NextNumber(-6, 6)), rayCheck)
                                    if ray then
                                        walkTo(ray.Position)
                                    end
                                end
                                task.wait(0.5)
                            until not AntiAFK.Enabled
                        end)()
                    end
                end,
                Tooltip = 'Moves your character around to prevent from being kicked'
            })

            Start = AntiAFK:CreateTwoSlider({
                Name = 'Start delay',
                Tooltip = 'How long to wait after moving to start',
                Min = 0,
                Max = 60,
                DefaultMin = 10,
                DefaultMax = 10
            })

            Frequency = AntiAFK:CreateSlider({
                Name = 'Frequency',
                Min = 1,
                Max = 20,
                Default = 10,
                Tooltip = 'How often you should move'
            })

            KeepClose = AntiAFK:CreateToggle({
                Name = 'Keep close',
                Default = true,
                Tooltip = 'Keeps your position and rotation close to the original'
            })

            Rotation = AntiAFK:CreateToggle({
                Name = 'Rotation',
                Default = true,
                Function = function(call)
                    if Yaw then
                        SilentAim.Object.Visible = call
                        Yaw.Object.Visible = call
                    end
                end,
                Tooltip = 'Moves your camera around'
            })

            SilentAim = AntiAFK:CreateToggle({
                Name = 'Silent aim',
                Darker = true,
                Default = true
            })

            Yaw = AntiAFK:CreateSlider({
                Name = 'Max yaw change',
                Min =  1,
                Max = 180,
                Tooltip = 'Max you will turn left and right',
                Default = 45,
                Suffix = '°',
                Darker = true
            })
        end)

        run(function() --> by max and selunar
            local BlockIn

            local rayCheck = RaycastParams.new()
            rayCheck.RespectCanCollide = true
            rayCheck.FilterType = Enum.RaycastFilterType.Exclude
            
            local PlaceMode
            local AimSpeed
            local PlaceDelay
            local SilentAim
            local Bedfinder
            local UseBlacklist
            local Blacklist

            local function getBlocks()
                local blocks = {}
                for _, item in store.inventory.inventory.items do
                    local block = bedwars.ItemMeta[item.itemType].block
                    if block and (not UseBlacklist.Enabled or not table.find(Blacklist.ListEnabled, item.tool.Name)) then
                        table.insert(blocks, {item.itemType, block.health, item.tool})
                    end
                end
                table.sort(blocks, function(a, b) 
                    return a[2] > b[2]
                end)
                return blocks
            end

            local function getBed()
                local localPosition = entitylib.isAlive and entitylib.character.RootPart.Position or Vector3.zero
                for _, v in collectionService:GetTagged('bed') do
                    if not v:GetAttribute('Team'..(lplr:GetAttribute('Team') or -1)..'NoBreak') and (localPosition - v.Position).Magnitude <= 30 then
                        return v
                    end
                end
            end

            local function getPyramid()
                local pattern = {
                    Vector3.new(3, 0, 0),
                    Vector3.new(0, 0, 3),
                    Vector3.new(-3, 0, 0),
                    Vector3.new(0, 0, -3),
                    Vector3.new(3, 3, 0),
                    Vector3.new(0, 3, 3),
                    Vector3.new(-3, 3, 0),
                    Vector3.new(0, 3, -3),
                }
                
                local rng = Random.new()
                
                if rng:NextNumber() < 0.95 then
                    local extraCount = rng:NextInteger(1, 3)
                    for _ = 1, extraCount do
                        local dirX = (rng:NextInteger(0, 1) == 1 and 1 or -1)
                        local dirZ = (rng:NextInteger(0, 1) == 1 and 1 or -1)
                        local y = ({0, 3})[rng:NextInteger(1, 2)]
                    
                        offset = Vector3.new(3 * dirX, y, 3 * dirZ)
                        
                        if table.find(pattern, offset) then continue end
                        table.insert(pattern, offset)
                    end
                end
                
                local axis = rng:NextInteger(0,1) == 1 and 'X' or 'Z'
                local dir = rng:NextInteger(0,1) == 1 and 1 or -1
                local extraPos = axis == 'X' and Vector3.new(3 * dir, 6, 0) or Vector3.new(0, 6, 3 * dir)
                table.insert(pattern, extraPos)
                table.insert(pattern, Vector3.new(0, 6, 0))
                
                return pattern
            end

            BlockIn = vape.Categories.World:CreateModule({
                Name = 'Block-In',
                Function = function(callback)
                    if callback then
                        local lookAt = nil
                        local selfpos = entitylib.isAlive and entitylib.character.RootPart.Position or nil
                        
                        BlockIn:Clean(runService.PreRender:Connect(function(dt)
                            if entitylib.isAlive and lplr.Character:FindFirstChild('Humanoid') then
                                lplr.Character.Humanoid.AutoRotate = (not SilentAim.Enabled or lookAt == nil)
                                if lookAt then
                                    entitylib.character.RootPart.CFrame = entitylib.character.RootPart.CFrame:Lerp(CFrame.lookAt(entitylib.character.RootPart.Position, Vector3.new(lookAt.Position.X, entitylib.character.RootPart.Position.Y, lookAt.Position.Z)), AimSpeed.Value * dt)
                                end
                            end
                        end))

                        LPH_NO_VIRTUALIZE(function()
                            if selfpos then
                                rayCheck.FilterDescendantsInstances = {lplr.Character, gameCamera}

                                moveDirection = Vector3.zero
                                allow = os.clock() + 4
                                if Bedfinder.Enabled and not getBed() then
                                    notif('BlockIn', 'No bed found', 2, 'warning')
                                else
                                    if PlaceMode.Value == 'Smart' then
                                        local placement = workspace:Raycast(selfpos - Vector3.new(0, 1, 0), entitylib.character.RootPart.CFrame.LookVector * 4, rayCheck)

                                        if placement then
                                            local pos = placement.Instance.Position
                                            local rounded = roundPos(pos)
                                            local oldSlot = store.hand and store.hand.tool and getHotbar(store.hand.tool)

                                            repeat
                                                task.spawn(bedwars.breakBlock, placement.Instance, false, nil, true, true)
                                                task.wait(0.25)
                                            until not getPlacedBlock(rounded) or not BlockIn.Enabled

                                            if oldSlot then
                                                hotbarSwitch(oldSlot)
                                            end

                                            if BlockIn.Enabled then
                                                repeat
                                                    moveDirection = CFrame.lookAt(entitylib.character.RootPart.Position, Vector3.new(pos.X, entitylib.character.RootPart.Position.Y, pos.Z)).LookVector
                                                    task.wait()
                                                until (entitylib.character.RootPart.Position - Vector3.new(pos.X, entitylib.character.RootPart.Position.Y, pos.Z)).Magnitude <= 0.5
                                                
                                                moveDirection = Vector3.zero

                                                selfpos = entitylib.character.RootPart.Position
                                                suc = true
                                            end
                                        end
                                    end

                                    local blocks = getBlocks()
                                    for i, block in blocks do
                                        for index, v in store.inventory.hotbar do
                                            if v.item and v.item.tool == block[3] and index ~= (store.inventory.hotbarSlot + 1) then 
                                                hotbarSwitch(index - 1)
                                                break
                                            end
                                        end
                                        local pattern = getPyramid()

                                        for _, pos in pattern do
                                            if getPlacedBlock(selfpos + pos) and _ ~= 10 then continue end
                                            if SilentAim.Enabled then
                                                lookAt = CFrame.new(selfpos + pos)
                                                task.wait()
                                            else
                                                task.wait()
                                            end
                                            task.spawn(bedwars.placeBlock, selfpos + pos, block[1], false)
                                            local delay = PlaceDelay:GetRandomValue()
                                            if delay > 0 then
                                                task.wait(delay)
                                            end
                                            lookAt = nil
                                        end
                                    end

                                    if #blocks < 1 then
                                        notif('BlockIn', 'Missing blocks', 4, 'warning')
                                    end
                                end
                            end
                            allow = 0
                            if BlockIn.Enabled then 
                                BlockIn:Toggle() 
                            end
                        end)()
                    end
                end,
                Tooltip = 'Automatically places strong blocks around yourself.'
            })

            AimSpeed = BlockIn:CreateSlider({
                Name = 'Aim Speed',
                Min = 1,
                Max = 50,
                Default = 6,
                Darker = true
            })

            PlaceMode = BlockIn:CreateDropdown({
                Name = 'Placement Mode',
                List = {'Normal', 'Smart'},
                Default = 'Raycast'
            })

            PlaceDelay = BlockIn:CreateTwoSlider({
                Name = 'Place Delay',
                Min = 1,
                Max = 5,
                DefaultMin = 0.1,
                DefaultMax = 0.12,
                Decimal = 5
            })

            SilentAim = BlockIn:CreateToggle({Name = 'SilentAim'})
            Bedfinder = BlockIn:CreateToggle({Name = 'Bed finder'})
            UseBlacklist = BlockIn:CreateToggle({
                Name = 'Use blacklist', 
                Default = true, 
                Function = function(call)
                    if Blacklist then
                        Blacklist.Object.Visible = call
                    end
                end
            })
            Blacklist = BlockIn:CreateTextList({
                Name = 'Blacklists',
                Placeholder = 'block',
                Default = {
                    'cannon',
                    'tnt',
                    'siege_tnt'
                }
            })
        end)

        run(function() --> by max
            local BedAssist
            local AimSpeed
            local Range
            local Limit

            local function attemptBreak(tab, localPosition)
                if not tab then return end
                table.sort(tab, function(a, b)
                    return (a.Position - localPosition).Magnitude >= (b.Position - localPosition).Magnitude
                end)
                for _, v in tab do
                    if (v.Position - localPosition).Magnitude < Range.Value and bedwars.BlockController:isBlockBreakable({blockPosition = v.Position / 3}, lplr) then
                        if (v:GetAttribute('BedShieldEndTime') or 0) > workspace:GetServerTimeNow() then continue end
                        if Limit.Enabled and not (store.hand.tool and bedwars.ItemMeta[store.hand.tool.Name].breakBlock) then continue end
            
                        local target, path, endpos = bedwars.breakBlock(v, true, true, nil, true, false, true)
                    
                        return target or nil
                    end
                end
            
                return nil
            end

            BedAssist = vape.Categories.World:CreateModule({
                Name = 'Bed Assist',
                Function = function(call)
                    if call then
                        local beds = collection('bed', BedAssist)
                        local last = {}

                        LPH_NO_VIRTUALIZE(function()
                            BedAssist:Clean(runService.PreRender:Connect(function(delta)
                                if entitylib.isAlive and store.hand.tool and bedwars.ItemMeta[store.hand.tool.Name].breakBlock then
                                    local res = attemptBreak(beds, entitylib.character.RootPart.Position)
                                    if res then
                                        gameCamera.CFrame = gameCamera.CFrame:Lerp(CFrame.lookAt(gameCamera.CFrame.p, res), AimSpeed.Value * delta)
                                    end
                                end
                            end))
                        end)()
                    end
                end,
                Tooltip = 'Assists you bed breaking by automatically aims the nearest block'
            })

            AimSpeed = BedAssist:CreateSlider({
                Name = 'Aim Speed',
                Min = 1,
                Max = 20,
                Default = 20
            })

            Range = BedAssist:CreateSlider({
                Name = 'Range',
                Min = 1,
                Max = 30,
                Default = 20
            })

            Limit = BedAssist:CreateToggle({Name = 'Limit to item'})
        end)

        run(function() -- by max, selunar and monia
            local BedProtector
            local PlaceRange
            local Blacklist
            local Mode
            local Smart
            local Switch

            local function getBedNear()
                local localPosition = entitylib.isAlive and entitylib.character.RootPart.Position or Vector3.zero
                for _, v in collectionService:GetTagged('bed') do
                    if (localPosition - v.Position).Magnitude < 14 and v:GetAttribute('Team'..(lplr:GetAttribute('Team') or -1)..'NoBreak') then
                        return v
                    end
                end
            end
            
            local function getBlocks()
                local blocks = {}
                for _, item in store.inventory.inventory.items do
                    local block = bedwars.ItemMeta[item.itemType].block
                    if block and not table.find(Blacklist.ListEnabled, item.itemType) then
                        table.insert(blocks, {item.itemType, block.health, item.tool})
                    end
                end
                table.sort(blocks, function(a, b) 
                    return a[2] > b[2]
                end)
                return blocks
            end
            
            local function getPyramid(size, grid)
                local positions = {}
                for h = size, 0, -1 do
                    for w = h, 0, -1 do
                        table.insert(positions, Vector3.new(w, (size - h), ((h + 1) - w)) * grid)
                        table.insert(positions, Vector3.new(w * -1, (size - h), ((h + 1) - w)) * grid)
                        table.insert(positions, Vector3.new(w, (size - h), (h - w) * -1) * grid)
                        table.insert(positions, Vector3.new(w * -1, (size - h), (h - w) * -1) * grid)
                    end
                end
                return positions
            end
            
            BedProtector = vape.Categories.World:CreateModule({
                Name = 'Bed Protector',
                Function = function(callback)
                    if callback then
                        local bed

                        LPH_NO_VIRTUALIZE(function()
                            repeat
                                bed = getBedNear()

                                if bed then
                                    for i, block in getBlocks() do
                                        local switch, old = Switch.Enabled, store.hand and store.hand.tool and getHotbar(store.hand.tool) or nil
                                        local hotbar = nil

                                        if switch then
                                            hotbar = getHotbar(block[3])
                                        end
                                        
                                        for _, pos in getPyramid(i, 3) do
                                            if not BedProtector.Enabled then break end
                                            local pos = (bed.CFrame * CFrame.new(pos)).Position
                                            if getPlacedBlock(pos) then continue end
                                            if (entitylib.character.RootPart.Position - pos).Magnitude > PlaceRange.Value then
                                                continue
                                            end
                                            if hotbar and hotbarSwitch(hotbar) then
                                                task.wait()
                                            end
                                            task.spawn(bedwars.placeBlock, pos, block[1], false)
                                            task.wait(0.1)
                                        end

                                        if switch and old and hotbarSwitch(old) then
                                            task.wait()
                                        end
                                    end
                                else
                                    if Mode.Value == 'On Key' then
                                        notif('BedProtector', 'Unable to locate bed', 5)
                                        BedProtector:Toggle()
                                    end
                                end
                                task.wait(0.5)
                                if Mode.Value == 'On Key' then
                                    BedProtector:Toggle()
                                    break
                                end
                            until not BedProtector.Enabled
                        end)()
                    end
                end,
                Tooltip = 'Automatically places strong blocks around the bed.'
            })

            Mode = BedProtector:CreateDropdown({
                Name = 'Mode',
                List = {'Toggle', 'On Key'},
                Default = 'Toggle',
                Function = function(val)
                    if Smart then
                        Smart.Object.Visible = val == 'Toggle'
                    end
                end
            })
            Blacklist = BedProtector:CreateTextList({
                Name = 'Blacklist',
                Default = {'siege_tnt', 'tnt'}	
            })
            PlaceRange = BedProtector:CreateSlider({
                Name = 'Place Range',
                Min = 1,
                Max = 30,
                Default = 15
            })
            Switch = BedProtector:CreateToggle({Name = 'Auto Switch'})
            Smart = BedProtector:CreateToggle({Name = 'Smart', Default = true})
        end)

        --[[
            Inventory
        ]]

        --[[
            Minigames
        ]]

        --[[
            Legit
        ]]

        run(function() --> by max
            local NoCollision

            local last = {}

            NoCollision = vape.Categories.Legit:CreateModule({
                Name = 'No Collision',
                Tooltip = 'Removes player\'s collision when ur near a bed',
                Function = function(callback)
                    if callback then
                        LPH_NO_VIRTUALIZE(function()
                            NoCollision:Clean(runService.PreSimulation:Connect(function()
                                local plrs = {}

                                for i, v in entitylib.List do
                                    if not v.NPC then
                                        table.insert(plrs, v)
                                    end
                                end

                                for _, v in last do
                                    local found = false

                                    for _, v2 in plrs do
                                        if v.Player == v2.Player then
                                            found = true
                                            break
                                        end
                                    end

                                    if not found and v.Character then
                                        for i,v in v.Character:GetDescendants() do
                                            if v.ClassName == 'Part' or v.ClassName == 'MeshPart' then
                                                v.CanQuery = true
                                            end
                                        end
                                    end
                                end

                                for _, v in plrs do
                                    if v.Character then
                                        for i,v in v.Character:GetDescendants() do
                                            if v.ClassName == 'Part' or v.ClassName == 'MeshPart' then
                                                v.CanQuery = false
                                                v.CanTouch = false
                                                v.CanCollide = false
                                            end
                                        end
                                    end
                                end
                                
                                last = plrs
                            end))
                        end)()
                    end
                end
            })
        end)

        run(function() --> by max, idea from monia
            local BedAlarm

            local function getBed()
                if entitylib.isAlive then
                    local id = lplr.Character:GetAttribute('Team')
                    for i,v in collectionService:GetTagged('bed') do
                        if tonumber(id) == tonumber(v:GetAttribute('TeamId')) then
                            return v
                        end
                    end
                end
            end
            
            BedAlarm = vape.Categories.Legit:CreateModule({
                Name = 'Bed Alarm',
                Function = function(callback)
                    if callback then
                        local Notifytick = os.clock()

                        LPH_JIT_MAX(function()
                            repeat
                                local bed, localpos = getBed(), nil
                                if bed then
                                    localpos = bed:GetPivot().Position
                                end

                                if localpos then
                                    local entity = localpos and entitylib.EntityPosition({
                                        Origin = localpos,
                                        Range = 65,
                                        Part = 'RootPart',
                                        Players = true
                                    })

                                    if entity and os.clock() > Notifytick then
                                        Notifytick = os.clock() + 3.05
                                        bedwars.NotificationController:sendInfoNotification({
                                            message = '[Bed Alarm]: An intruder is near your bed!',
                                        })
                                        bedwars.SoundManager:playSound(bedwars.SoundList.BED_ALARM, {
                                            volumeMultiplier = 1.4
                                        })
                                    end
                                end
                                task.wait(0.25)
                            until not BedAlarm.Enabled
                        end)()
                    end 
                end,
                Tooltip = 'Notifies when theres an enemy near bed'
            })
        end)

        run(function()
            local KitDisplay

            local function getPlayerFromDraft(render, name)
                for i,v in playersService:GetPlayers() do
                    if render == `rbxthumb://type=AvatarHeadShot&id={v.UserId}&w=352&h=352` then
                        return v
                    elseif v.DisplayName == name or v.Name == name or (v:GetAttribute('DisguiseDisplayName') or '') == name then
                        return v
                    end
                end
            end

            local function callback(v)
                local render = v:FindFirstChild('PlayerRender')
                local player = getPlayerFromDraft(render and render.Image or '', v.TextBackgroundBar.PlayerName.Text)

                if player then
                    local kitImage = bedwars.BedwarsKitMeta[player:GetAttribute('PlayingAsKits')] or bedwars.BedwarsKitMeta.none

                    local roact = v:FindFirstChild('KitImage')
                    
                    if not roact then
                        roact = Instance.new('ImageLabel', v)
                        roact.BackgroundTransparency = 1
                        roact.AnchorPoint = Vector2.new(1, 0.5)
                        roact.Position = UDim2.fromScale(1.05, 0.5)
                        roact.Name = 'KitImage'
                        roact.Size = UDim2.fromScale(1.5, 1.5)
                        roact.ZIndex = 1
                        roact.ImageTransparency = 0.4
                        roact.SliceCenter = Rect.new(0, 0, 0, 0)
                        roact.SliceScale = 1
                        roact.ScaleType = 'Crop'

                        KitDisplay:Clean(roact)

                        local ratio = Instance.new('UIAspectRatioConstraint', roact)
                        ratio.Name = '1'
                        ratio.AspectRatio = 1
                        ratio.AspectType = Enum.AspectType.FitWithinMaxSize
                        ratio.DominantAxis = Enum.DominantAxis.Width
                    end

                    roact.Image = kitImage.renderImage
                    roact.Position = UDim2.fromScale(1.05, 0)
                    tweenService:Create(roact, TweenInfo.new(0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
                        Position = UDim2.fromScale(1.05, 0.4)
                    }):Play()

                    KitDisplay:Clean(player:GetAttributeChangedSignal('PlayingAsKits'):Connect(function()
                        callback(v)
                    end))
                end
            end

            KitDisplay = vape.Categories.Legit:CreateModule({
                Name = 'Kit Display',
                Tooltip = 'Allows you to see the other opponent team\'s kits',
                Function = function(call)
                    if call then
                        lplr.PlayerGui.MatchDraftApp.DraftAppBackground.BodyContainer.Team2Column.ChildAdded:Connect(function()
                            task.wait(2)
                            
                            if KitDisplay.Enabled then
                                KitDisplay:Toggle()
                                KitDisplay:Toggle()
                            end
                        end)

                        for _, v in lplr.PlayerGui.MatchDraftApp.DraftAppBackground.BodyContainer.Team2Column:GetChildren() do
                            if v:IsA('Frame') then
                                v = v['1']:FindFirstChild('MatchDraftPlayerCard', true)
                                callback(v)
                            end
                        end
                    end
                end
            })
        end)

        run(function()
            local AntiDisguise
            
            local function callback(player)
                for i, v in {'DisguiseDisplayName', 'DisguiseUsername'} do
                    player:SetAttribute(v, i == 1 and player.DisplayName or player.Name)

                    AntiDisguise:Clean(player:GetAttributeChangedSignal(v):Connect(function()
                        player:SetAttribute(v, i == 1 and player.DisplayName or player.Name)
                    end))
                end
            end

            AntiDisguise = vape.Categories.Legit:CreateModule({
                Name = 'No Disguise',
                Tooltip = 'Disables player\'s streamer mode clientsidedly',
                Function = function(call)
                    if call then
                        for _, v in playersService:GetPlayers() do
                            callback(v)
                        end

                        AntiDisguise:Clean(playersService.PlayerAdded:Connect(callback))
                    end
                end
            })
        end)

        run(function() --> by qwerty
            local TexturePacks
            local Pack

            TexturePacks = vape.Categories.Legit:CreateModule({
                Name = 'Texture Pack',
                Function = function(call)
                    if call then
                        loadstring(game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/TexturePacks/main/'.. Pack.Value.. '.lua'), Pack.Value)()
                    else
                        if getgenv().texturepack then
                            getgenv().texturepack:Disconnect()
                            getgenv().texturepack = nil
                        end
                    end
                end
            })

            Pack = TexturePacks:CreateDropdown({
                Name = 'Pack',
                List = {'Acidic', 'Devourer', 'Enlightened', 'FatCat', 'Fury', 'Makima', 'Marin-Kitsawaba', 'Moon4Real', 'Nebula', 'Onyx', 'Prime', 'Simply', 'Vile', 'VioletsDreams', 'Wichtiger'}
            })
        end)
    end

    if isPremium then
        pcall(function()
            local Flamework = require(replicatedStorage.rbxts_include.node_modules['@flamework'].core.out).Flamework
            local moderationApp = require(lplr.PlayerScripts.TS.controllers.global['match-history'].ui['match-history-moderation-app']).MatchHistoryModerationApp

            local View
            View = vape.Categories.Inventory:CreateModule({
                Name = 'View match-history',
                Premium = isPremium,
                Tooltip = 'Opens match history moderation app',
                Function = function(call)
                    if call then
                        Flamework.resolveDependency('@easy-games/game-core:client/controllers/app-controller@AppController'):openApp({
                            app = moderationApp,
                            appId = 'MatchHistoryApp'
                        }, {
                            player = lplr,
                            matchHistory = {}
                        })

                        View:Toggle()
                    end
                end
            })
        end)
    end
end