repeat task.wait() until game:IsLoaded()
if shared.vape then shared.vape:Uninject() end

getgenv().run = task.spawn
getgenv().setthreadidentity = nil

local vape
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
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function finishLoading()
	vape.Init = nil
	vape:Load()
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
				loadstring(game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/main/init.lua'), 'init.lua')()
			]]
			if shared.VapeDeveloper then
				teleportScript = 'shared.VapeDeveloper = true\n'..teleportScript
			end
			if getgenv().catvapedev then
				teleportScript = 'getgenv().catvapedev = true\n'.. teleportScript
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
		pcall(function()
			if vape.Categories.Main.Options['GUI bind indicator'].Enabled then
				vape:CreateNotification('Finished Loading', vape.VapeButton and 'Press the button in the top right to open GUI' or 'Press '..table.concat(vape.Keybind, ' + '):upper()..' to open GUI', 3)
				task.wait(3.5)
				vape:CreateNotification('Cat', `Initialized as {(catuser or 'Guest')} with role {catrole or 'Basic'}`, 2.5, 'info')
				task.wait(1)
				if not isfile('newusercat2') then
					vape:CreateNotification('Cat', 'You have been redirected to cat\'s discord server', 3, 'warning')
					writefile('newusercat2', 'True')
					if not table.find({'Wave', 'Velocity', 'Krnl'}, ({identifyexecutor()})[1]) then
						task.spawn(pcall, function()
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
						end)
					end
				end
			end
		end)
	end
end

if not isfile('catrewrite/profiles/gui.txt') then
	writefile('catrewrite/profiles/gui.txt', 'new')
end
local gui = readfile('catrewrite/profiles/gui.txt')

if gui == nil or gui == '' then
	gui = 'new'
end

if not isfolder('catrewrite/assets/'..gui) then
	makefolder('catrewrite/assets/'..gui)
end
vape = loadstring(downloadFile('catrewrite/guis/'..gui..'.lua'), 'gui')()
shared.vape = vape

if not shared.VapeIndependent then
	loadstring(downloadFile('catrewrite/games/universal.lua'), 'universal')()
	shared.vape.Libraries.Cat = true
	loadstring(downloadFile('catrewrite/libraries/whitelist.lua'), 'whitelist.lua')()
	if isfile('catrewrite/games/'..game.PlaceId..'.lua') and shared.VapeDeveloper then
		loadstring(downloadFile('catrewrite/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
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
	finishLoading()
	loadstring(downloadFile('catrewrite/libraries/update.lua'), 'update.lua')()
else
	vape.Init = finishLoading
	return vape
end