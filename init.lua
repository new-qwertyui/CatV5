repeat
	task.wait()
until game:IsLoaded()

print('fr')

local license = ({...})[1] or {}
local developer = getgenv().catvapedev or license.Developer or false
local closet = getgenv().closet or license.Closet or false

if license.User then
    getgenv().catuser = license.User
end

local cloneref = cloneref or function(ref) return ref end
local gethui = gethui or function() return game:GetService('Players').LocalPlayer.PlayerGui end

local downloader = Instance.new('TextLabel', Instance.new('ScreenGui', gethui()))
downloader.Size = UDim2.new(1, 0, -0.08, 0)
downloader.BackgroundTransparency = 1
downloader.TextStrokeTransparency = closet and 1 or 0
downloader.TextTransparency = closet and 1 or 0
downloader.TextSize = 20
downloader.Text = 'Downloading Nothing.'
downloader.TextColor3 = Color3.new(1, 1, 1)
downloader.Font = Enum.Font.Arial

local httpService = cloneref(game:GetService('HttpService'))

local success, commitdata = pcall(function()
    local commitinfo = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/new-qwertyui/CatV5/commits'))[1]
    if commitinfo and type(commitinfo) == 'table' then
        local fullinfo = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/new-qwertyui/CatV5/commits/'.. commitinfo.sha))
        fullinfo.hash = commitinfo.sha:sub(1, 7)
        return fullinfo
    end
end)

if not success or typeof(commitdata) ~= 'table' or commitdata.sha == nil then
	commitdata = {sha = 'main', files = {}}
end

writefile('catreset', 'True')

local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			local subbed = path:gsub('catrewrite/', '')
			subbed = subbed:gsub(' ', '%%20')
			return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..readfile('catrewrite/profiles/commit.txt')..'/'..subbed, true)
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

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end 

for _, folder in {'catrewrite', 'catrewrite/communication', 'catrewrite/games', 'catrewrite/games/bedwars', 'catrewrite/profiles', 'catrewrite/assets', 'catrewrite/libraries', 'catrewrite/libraries/Enviroments', 'catrewrite/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if not isfolder('catrewrite') or #listfiles('catrewrite') <= 6 or not isfolder('catrewrite/profiles') or not isfile('catrewrite/profiles/commit.txt') then
    makefolder('catrewrite/profiles')
    writefile('catrewrite/profiles/commit.txt', commitdata.sha)
    local req = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/new-qwertyui/CatV5/contents/profiles'))
    for _, v in req do
        if v.path ~= 'profiles/commit.txt' then
			downloader.Text = `Downloading catrewrite/{v.path}`
            downloadFile(`catrewrite/{v.path}`)
        end
    end
    task.spawn(function()
        local req = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/new-qwertyui/CatV5/contents/translations'))
        for _, v in req do
            downloadFile(`catrewrite/{v.path}`)
        end
    end)
end

shared.VapeDeveloper = developer
getgenv().used_init = true
getgenv().catvapedev = developer
getgenv().closet = closet

if closet then
	task.spawn(function()
		repeat
			for _, v in getconnections(game:GetService('LogService').MessageOut) do
				v:Disable()
			end

			for _, v in getconnections(game:GetService('ScriptContext').Error) do
				v:Disable()
			end

			task.wait(0.5)
		until not shared.VapeDeveloper or not getgenv().closet
	end)
end

downloader.Text = 'Loading Cat Rewrite'

if not shared.VapeDeveloper then
	local commit = commitdata.sha or 'main'
	if commit == 'main' or (isfile('catrewrite/profiles/commit.txt') and readfile('catrewrite/profiles/commit.txt') or '') ~= commit then
		wipeFolder('catrewrite')
		wipeFolder('catrewrite/games')
		wipeFolder('catrewrite/guis')
		wipeFolder('catrewrite/libraries')
	end
    writefile('catrewrite/cheaters.json', '{}')
	writefile('catrewrite/profiles/commit.txt', commit)
end

loadstring(downloadFile('catrewrite/main.lua'), 'main')()

downloader:Destroy()