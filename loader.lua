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

local function downloadFile(path, func)
	if not isfile(path) then
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

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'catrewrite', 'catrewrite/games', 'catrewrite/profiles', 'catrewrite/assets', 'catrewrite/libraries', 'catrewrite/guis'} do
	if not isfolder(folder) then
		makefolder(folder)
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
end

Args.Key = script_key or 'none'

return loadstring(downloadFile('catrewrite/main.lua'), 'main')(Args)