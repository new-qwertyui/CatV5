if shared.catloading then
	return
end
shared.catloading = true
local loaded = game:IsLoaded()
repeat task.wait() until game:IsLoaded()
if not loaded then
	task.wait(5)
end
if not isfolder('catrewrite') then
    makefolder('catrewrite')
end

if shared.vape then
	shared.vape:Uninject()
end
shared.start = tick()

local arg = ... or {}

local function downloadFile(path, comm, func)
	if not arg.Developer or not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet(`https://raw.githubusercontent.com/new-qwertyui/CatV5/{comm}/{({path:gsub('catrewrite', '')})[1]}`, true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		writefile(path, res)
	end
		
	return (func or readfile)(path)
end

local _, subbed = pcall(function()
	return game:HttpGet('https://github.com/new-qwertyui/CatV5')
end)
commit = subbed:find('currentOid')
commit = commit and subbed:sub(commit + 13, commit + 52) or nil
commit = commit and #commit == 40 and commit or 'main'
commit = commit:sub(1, 7)

pcall(function()
	loadstring(downloadFile('catrewrite/loader.luau', commit), 'loader.luau')(arg, commit, nil, nil)
end)
shared.catloading = false