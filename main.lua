local vape
local closet = getgenv().closet
local makestage = getgenv().makestage or function() end
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		vape:CreateNotification('Vape', 'Failed to load : '..err, 30, 'alert')
	end
	return res
end
local queue_on_teleport = queue_on_teleport or function() end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local cloneref = cloneref or function(obj)
	return obj
end
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))

local function downloadFile(path, func)
	if not isfile(path) or not shared.VapeDeveloper then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..readfile('catrewrite/profiles/commit.txt')..'/'..select(1, path:gsub('catrewrite/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function finishLoading()
	vape.Init = nil
	vape:Load()
	makestage(5, 'Finished!')

	task.spawn(function()
		repeat
			vape:Save()
			task.wait(10)
		until not vape.Loaded
	end)

	local teleportedServers
	vape:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
		if (not teleportedServers) and (not shared.VapeIndependent) then
			teleportedServers = true
			local teleportScript = [[
				shared.vapereload = true
				loadstring(readfile('catrewrite/init.lua'), 'init.lua')({
					Username = "tpusername",
					Password = "tppassword"
				})
			]]
			if getgenv().catvapedev then
				teleportScript = 'getgenv().catvapedev = true\n'.. teleportScript
			end
			if shared.VapeDeveloper then
				teleportScript = 'shared.VapeDeveloper = true\n'..teleportScript
			end
			if getgenv().username then
				teleportScript = teleportScript:gsub('tpusername', getgenv().username)
			end
			if getgenv().password then
				teleportScript = teleportScript:gsub('tppassword', getgenv().password)
			end
			if getgenv().closet then
				teleportScript = 'getgenv().closet = true\n'.. teleportScript
			end
			if shared.VapeCustomProfile then
				teleportScript = 'shared.VapeCustomProfile = "'..shared.VapeCustomProfile..'"\n'..teleportScript
			end
			vape:Save()
			queue_on_teleport(teleportScript)
		end
	end))

	if not shared.vapereload then
		if not vape.Categories then return end
		task.spawn(pcall, function()
			if vape.Categories.Main.Options['GUI bind indicator'].Enabled then
				vape:CreateNotification('Finished Loading', cloneref(game:GetService('UserInputService')).TouchEnabled and 'Press the button in the top right to open GUI' or 'Press '..table.concat(vape.Keybind, ' + '):upper()..' to open GUI', 3)
				task.wait(3.5)
				vape:CreateNotification('Cat', `Initialized as {(getgenv().username or 'Guest')} with role {getgenv().catrole or 'Basic'}`, 2.5, 'info')
				task.wait(1)
				if not isfile('newusercat2') then
					vape:CreateNotification('Cat', 'You have been redirected to cat\'s discord server', 3, 'warning')
					writefile('newusercat2', 'True')
					request({
						Url = 'http://127.0.0.1:6463/rpc?v=1',
						Method = 'POST',
						Headers = {
							['Content-Type'] = 'application/json',
							Origin = 'https://discord.com'
						},
						Body = cloneref(game:GetService('HttpService')):JSONEncode({
							invlink = 'catvape',
							cmd = 'INVITE_BROWSER',
							args = {
								code = 'catvape'
							},
							nonce = cloneref(game:GetService('HttpService')):GenerateGUID(true)
						})
					})
				end
			end
		end)
	end
end

if not isfile('catrewrite/profiles/gui.txt') then
	writefile('catrewrite/profiles/gui.txt', 'new')
end
local gui = readfile('catrewrite/profiles/gui.txt')

if gui == nil or gui == '' or not table.find({'rise', 'new', 'old'}, gui) then
	gui = 'new'
end

if not isfolder('catrewrite/assets/'..gui) then
	makefolder('catrewrite/assets/'..gui)
end

if shared.vape then
	shared.vape:Uninject()
end

vape = loadstring(downloadFile('catrewrite/guis/'..gui..'.lua'), 'gui')()
shared.vape = vape

local function callback(func)
	local success, result

	task.spawn(function()
		success, result = pcall(func)
	end)

	local Start = os.clock()

	repeat task.wait() until success ~= nil or (os.clock() - Start) >= 10

	return success, result
end

if not shared.VapeIndependent then
	loadstring(downloadFile('catrewrite/games/universal.lua'), 'universal')()
	shared.vape.Libraries.Cat = true
	makestage(4, 'Launching packages')
	callback(function()
		loadstring(downloadFile('catrewrite/libraries/whitelist.lua'), 'whitelist.lua')()
	end)
	local success, result = callback(function(...)
		if isfile('catrewrite/games/'..game.PlaceId..'.lua') then
			loadstring(readfile('catrewrite/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
		else
			if not shared.VapeDeveloper then
				local suc, res = pcall(function()
					return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..readfile('catrewrite/profiles/commit.txt')..'/games/'..game.PlaceId..'.lua', true)
				end)
				if suc and res ~= '404: Not Found' then
					loadstring(downloadFile('catrewrite/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
				end
			end
		end
	end)

	if success or not canDebug then
		loadstring(downloadFile('catrewrite/games/bedwars/modules.luau'), 'games/bedwars/init')()
		callback(function() vape:Remove('Float Disabler') end)
		finishLoading()
	else
		task.spawn(error, result)
		if not closet then
			callback(function()
				if setthreadidentity then
					setthreadidentity(8)
				end

				local errorPrompt = getrenv().require(game:GetService('CoreGui').RobloxGui.Modules.ErrorPrompt)
				local game = cloneref(game)

				local gui = Instance.new('ScreenGui', cloneref(game:GetService('CoreGui')))
				gui.OnTopOfCoreBlur = true


				local prompt = errorPrompt.new('Default')
				prompt._hideErrorCode = true
				prompt:setErrorTitle('Loading Failure')

				prompt:updateButtons({
					{
						Text = 'Ok',
						Callback = function()
							prompt:_close()
						end,
						Primary = true
					}
				}, 'Default')

				prompt:setParent(gui)
				prompt:_open('Failed to load catvape with this error code, Please report this to the discord server\n\n'.. result.. '\n(Error Code: 0)')
			end)
		end
	end
else
	vape.Init = finishLoading
	return vape
end
