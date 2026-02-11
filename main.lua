if isnetworkowner then
	if table.find({'Velocity', 'ChocoSploit'}, ({identifyexecutor()})[1]) then
		getgenv().isnetworkowner = nil
	end
end

local listfiles = listfiles
if listfiles then
	getgenv().listfiles = function(...)
		local res, new = listfiles(...), {}
		for i, v in res do
			new[i] = v:gsub('\\', '/')
		end
		return new
	end
end

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
local httpService = cloneref(game:GetService('HttpService'))

local function run(func)
	func()
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..readfile('catrewrite/profiles/commit.txt')..'/'..select(1, path:gsub('catrewrite/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function loadJson()
	local suc, tab = pcall(function()
		return httpService:JSONDecode(downloadFile('catrewrite/version.json'))
	end)
	
	return suc and typeof(tab) == 'table' and tab.version or 'null'
end

local function compileTable(tab)
	local json = '{'
	for i, v in tab do
		json = `{json}\n					    {i} = {typeof(v) == 'string' and '"'.. v.. '"' or v},`
	end
	return `{json}\n}`
end

local version = loadJson()
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
				if shared.VapeDeveloper then
					loadstring(readfile('catrewrite/init.lua'), 'loader')(scriptdata)
				else
					loadstring(game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..readfile('catrewrite/profiles/commit.txt')..'/init.lua', true), 'loader')(scriptdata)
				end
			]]
			teleportScript = teleportScript:gsub('scriptdata', compileTable(shared.catdata or {}))
			if shared.VapeCustomProfile then
				teleportScript = 'shared.VapeCustomProfile = "'..shared.VapeCustomProfile..'"\n'..teleportScript
			end
			vape:Save()
			queue_on_teleport(teleportScript)
		end
	end))

	if not shared.vapereload then
		if not vape.Categories then return end
		if vape.Categories.Main.Options['GUI bind indicator'].Enabled then
			if shared.maincat then
				vape:CreateNotification('Finished Loading', vape.VapeButton and 'Press the button in the top right to open GUI' or 'Press '..table.concat(vape.Keybind, ' + '):upper()..' to open GUI', 5)
			else
				vape:CreateNotification('Cat', 'Your currently using an outdated loader of catvape, Please go to our discord server and get a new one', 120, 'warning')
			end
			local last = isfile('kitty_version') and readfile('kitty_version') or '5.49'
			if last ~= version then
				writefile('kitty_version', tostring(version))
				vape:CreateNotification('Cat', `We have updated from v{last} to v{version}, Check the discord for more detail!`, 12, 'info')
			end
		end
	end
end

if not isfile('catrewrite/profiles/gui.txt') then
	writefile('catrewrite/profiles/gui.txt', 'new')
end
local gui = readfile('catrewrite/profiles/gui.txt')

if not isfolder('catrewrite/assets/'..gui) then
	makefolder('catrewrite/assets/'..gui)
end
vape = loadstring(downloadFile('catrewrite/guis/'..gui..'.lua'), 'gui')(version)
shared.vape = vape

if not shared.VapeIndependent then
	loadstring(downloadFile('catrewrite/games/universal.lua'), 'universal')()
	if not canDebug then
		vape:CreateNotification('Cat', 'This may take up to 3 minutes to load', 30, 'warning')
		loadstring(downloadFile('catrewrite/libraries/login.lua'), 'login')()
	end

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
	if table.find({'Xeno', 'Solara', 'Potassium', 'Velocity', 'Hydrogen'}, ({identifyexecutor()})[1]) then
		loadstring(downloadFile('catrewrite/scripts/psmscript.luau'), `performance {game.PlaceId}`)(...)
	else
		loadstring(downloadFile('catrewrite/scripts/script.luau'), `script {game.PlaceId}`)(...)
	end
	finishLoading()
else
	vape.Init = finishLoading
	return vape
end