local Args = ... or {}
shared.VapeDeveloper = shared.VapeDeveloper or Args.Developer

local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local cloneref = cloneref or function(ref) return ref end
local httpService = cloneref(game:GetService('HttpService'))

local downloader = Instance.new('TextLabel')
downloader.Size = UDim2.new(1, 0, 0, 40)
downloader.BackgroundTransparency = 1
downloader.TextStrokeTransparency = 0
downloader.TextSize = 20
downloader.TextColor3 = Color3.new(1, 1, 1)
downloader.Font = Enum.Font.Arimo
downloader.Parent = gethui and gethui() or cloneref(game:GetService('Players')).LocalPlayer:WaitForChild('PlayerGui', 9e9)

local function downloadFile(path, func)
	if not isfile(path) then
		if path ~= 'catrewrite/main.lua' then
			downloader.Text = `Downloading {path}`
		end

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
	downloader.Text = ''
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') or file:find('init') then continue end
		if isfile(file) then
			delfile(file)
		end
	end
end

local new = false
for _, folder in {'catrewrite', 'catrewrite/games', 'catrewrite/profiles', 'catrewrite/assets', 'catrewrite/libraries', 'catrewrite/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
		new = true
	end
end

getgenv().used_init = true

if not shared.VapeDeveloper then
	local _, subbed = pcall(game.HttpGet, game, 'https://github.com/new-qwertyui/CatV5')
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'

	if commit == 'main' or (isfile('catrewrite/profiles/commit.txt') and readfile('catrewrite/profiles/commit.txt') or '') ~= commit then
		wipeFolder('catrewrite')
		wipeFolder('catrewrite/games')
		wipeFolder('catrewrite/guis')
		wipeFolder('catrewrite/libraries')
	end

	writefile('catrewrite/profiles/commit.txt', commit)
	
	if new or #listfiles('catrewrite/profiles') <= 2 then
		local preloaded = pcall(function()
			local req = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/new-qwertyui/CatV5/contents/profiles'))

			for _, v in req do
				if v.path ~= 'profiles/commit.txt' then
					pcall(downloadFile, `catrewrite/{v.path}`)
				end
			end
		end)

		if not preloaded then
			task.wait(2)
		end
	end
end

return loadstring(downloadFile('catrewrite/main.lua'), 'main')(Args)