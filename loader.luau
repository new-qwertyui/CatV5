local commit = select(2, ...)

repeat
	task.wait()
until game:IsLoaded()

if shared.vape then
	shared.vape:Uninject()
end

local license = ({...})[1] or {}
local developer =  license.Developer or getgenv().catvapedev or false
local closet = license.Closet or getgenv().closet or false

shared.catdata = license

local loadstring = function(...)
	local res, err = loadstring(...)
	if err then
		error(err)
	end
	return res
end

local cloneref = cloneref or function(ref) return ref end
local gethui = function() return cloneref(game:GetService('Players')).LocalPlayer:WaitForChild('PlayerGui', 9e9) end

local httpService: HttpService = cloneref(game:GetService('HttpService'))

local gui : ScreenGui = Instance.new('ScreenGui', gethui())
gui.Enabled = true
gui.DisplayOrder = 9999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.IgnoreGuiInset = true

local Connections: {RBXScriptConnection} = {}

local downloader

local function createDownloader(text: string): ()
	if not license.Closet then
		if not downloader then
			downloader = Instance.new('TextLabel')
			downloader.Size = UDim2.new(1, 0, 0, 40)
			downloader.BackgroundTransparency = 1
			downloader.TextStrokeTransparency = 0
			downloader.TextSize = 20
			downloader.TextColor3 = Color3.new(1, 1, 1)
			downloader.Font = Enum.Font.Arimo
			downloader.Parent = gui
		end
		getgenv().catdownloader = downloader

		if text == '' then
			downloader.Visible = false
		else
			downloader.Visible = true
			downloader.Text = `Downloading {text}`
		end
	end
end

createDownloader('')

local debug = debug
local Executor = identifyexecutor()

if table.find({'Xeno', 'Solara'}, Executor) then
	debug = table.clone(debug)
	debug.getupvalue = nil
	debug.getconstant = nil
	debug.setstack = nil

	getgenv().debug = debug
	--cloneref(game:GetService('Players')).LocalPlayer:Kick(`{Executor} is not supported :(\nTry again tomorrow..`)
end

local canDebug = debug.getupvalue ~= nil

local function downloadFile(path, func)
	if not isfile(path) then
		createDownloader(path)
		local suc, res = pcall(function()
			local subbed = path:gsub('catrewrite/', '')
			subbed = subbed:gsub(' ', '%%20')
			return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..commit..'/'..subbed, true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		writefile(path, res)
		createDownloader('')
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('init') then continue end
		if isfile(file) then
			delfile(file)
		end
	end
end 

local writefile = writefile
if writefile and not table.find({'Volt', 'Xeno'}, Executor) then
	getgenv().writefile = newcclosure(function(dict, code)
		local text, path = {}, dict:split('/')
		for index, v in path do
			if index ~= #path then
				table.insert(text, v)
				if not isfolder(table.concat(text, '/')) then
					makefolder(table.concat(text, '/'))
				end
			end
		end
		return writefile(dict, code)
	end)
end

for _, folder in {'assets', 'games', 'guis', 'libraries', 'profiles', 'scripts'} do
	folder = `catrewrite/{folder}`
	if not isfolder(folder) then
		shared.newcat = true
		makefolder(folder)
	end
end

if (not license.Developer and not shared.VapeDeveloper) then
	local Updated: boolean = (commit == 'main' or (isfile('catrewrite/profiles/commit.txt') and readfile('catrewrite/profiles/commit.txt') or '') ~= commit)

	if Updated then
		wipeFolder('catrewrite')
		wipeFolder('catrewrite/games')
		wipeFolder('catrewrite/guis')
		wipeFolder('catrewrite/scripts')
		wipeFolder('catrewrite/libraries')
	end
	
	if #listfiles('catrewrite/profiles') <= 2 then
		local preloaded = pcall(function()
			local req = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/new-qwertyui/CatV5/contents/profiles'))

			for _, v in req do
				if v.path ~= 'profiles/commit.txt' then
					downloadFile(`catrewrite/{v.path}`)
				end
			end
		end)

		if not preloaded then
			task.wait(2)
		end
	end
end

writefile('catrewrite/profiles/commit.txt', commit)

shared.VapeDeveloper = developer
getgenv().used_init = true
getgenv().catvapedev = developer
getgenv().closet = closet
getgenv().canDebug = canDebug
getgenv().getgenv().catpremium = license.Premium

getgenv().username = license.Username or getgenv().username
getgenv().password = license.Password or getgenv().password 

if table.find({'Velocity', 'ChocoSploit'}, Executor) then
	getgenv().isnetworkowner = function() return true end
end

local success, err = pcall(function()
	loadstring(downloadFile('catrewrite/main.lua'), 'main')()
end)

createDownloader('')

for _, v in Connections do
	v:Disconnect()
end

table.clear(Connections)
gui:Destroy()

if not success then
	error('Failed to initalize catvape: '.. err, 8)
end