local Args, commit = ...
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
getgenv().catdownloader = downloader

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
	repeat pcall(delfolder, path); task.wait() until not isfolder(path)
	makefolder(path)
end

for _, folder in {'catrewrite', 'catrewrite/games', 'catrewrite/profiles', 'catrewrite/assets', 'catrewrite/libraries', 'catrewrite/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

getgenv().used_init = true

if not shared.VapeDeveloper then
	if not isfile('catrewrite/profiles/commit.txt') or readfile('catrewrite/profiles/commit.txt') ~= commit then
		wipeFolder('catrewrite')
		wipeFolder('catrewrite/games')
		wipeFolder('catrewrite/guis')
		wipeFolder('catrewrite/libraries')
	end

	writefile('catrewrite/profiles/commit.txt', commit)
end

return loadstring(downloadFile('catrewrite/main.lua'), 'main')(Args)