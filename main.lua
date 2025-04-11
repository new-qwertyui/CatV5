repeat task.wait() until game:IsLoaded()
if shared.vape then shared.vape:Uninject() end

getgenv().void = function() end
getgenv().inf = math.huge
local request = request or http and http.request or syn and syn.request or function() end;
getgenv().request = request --> lmao
getgenv().run = function(func)
	local a, b = pcall(func)
	if not a then
		if shared.catvapedev then
			if shared.vape then
				shared.vape:CreateNotification('Vape', b, 12, 'alert')
			end
			task.spawn(error, `Vape | {b}`);
		end
	end
end

if identifyexecutor and identifyexecutor and table.find({'Argon', 'Wave'}, ({identifyexecutor()})[1]) then
	getgenv().setthreadidentity = nil
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
local httpService = cloneref(game:GetService('HttpService'))
local playersService = cloneref(game:GetService('Players'))

local httpasync = function(url, ...)
	return game:HttpGet(url, ...);
end

local function getcommit(sub: number): ()
	sub = sub or 7;
	local commitinfo: table = httpService:JSONDecode(httpasync('https://api.github.com/repos/qwertyui-is-back/CatV5/commits'))[1];
	if commitinfo and type(commitinfo) == 'table' then
		commitinfo.hash = commitinfo.sha:sub(1, sub);
		return commitinfo
	end;
	return nil;
end;

local function downloadFile(path, func, bypass)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/qwertyui-is-back/CatV5/'..readfile('newcatvape/profiles/commit.txt')..'/'..select(1, path:gsub('newcatvape/', '')), true)
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
				loadfile('newcatvape/init.lua')()
			]]
			if shared.VapeDeveloper then
				teleportScript = 'shared.VapeDeveloper = true\n'..teleportScript
			end
			if shared.VapeCustomProfile then
				teleportScript = 'shared.VapeCustomProfile = "'..shared.VapeCustomProfile..'"\n'..teleportScript
			end
			if shared.catvapedev then
				teleportScript = 'shared.catvapedev = true\n'..teleportScript
			end
			teleportScript = 'shared.username = "'..username..'"\n'..teleportScript
			teleportScript = 'shared.password = "'..password..'"\n'..teleportScript
			vape:Save()
			queue_on_teleport(teleportScript)
		end
	end))

	if not shared.vapereload then
		if not vape.Categories then return end
		if vape.Categories.Main.Options['GUI bind indicator'].Enabled then
			vape:CreateNotification('Finished Loading', vape.VapeButton and 'Press the button in the top right to open GUI' or 'Press '..table.concat(vape.Keybind, ' + '):upper()..' to open GUI', 5)
		end
	end
end

if not isfile('newcatvape/profiles/gui.txt') then
	writefile('newcatvape/profiles/gui.txt', 'new');
end;

local gui = readfile('newcatvape/profiles/gui.txt');

vape = loadstring(downloadFile('newcatvape/guis/'..gui..'.lua'), 'gui')();
shared.vape = vape;

loadstring(downloadFile('newcatvape/libraries/login.lua'))()

if not isfolder('newcatvape/assets/'..gui) then
	makefolder('newcatvape/assets/'..gui)
end

if not shared.VapeIndependent then
	loadstring(downloadFile('newcatvape/games/universal.lua'))()
	pcall(function()
		loadstring(downloadFile('newcatvape/games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))()
	end)
	finishLoading()
else
	vape.Init = finishLoading
	return vape
end
