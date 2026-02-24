local Args = select(1, ...) or {}
local _, subbed = pcall(function()
	return game:HttpGet('https://github.com/new-qwertyui/CatV5')
end)

local commit = subbed:find('currentOid')
commit = commit and subbed:sub(commit + 13, commit + 52) or nil
commit = commit and #commit == 40 and commit or 'main'

if not isfolder('catrewrite') then
	makefolder('catrewrite')
end
if not isfolder('catrewrite/libraries') then
	makefolder('catrewrite/libraries')
end

shared.VapeDeveloper = Args.Developer or false
if Args.Developer then
	loadstring(readfile('catrewrite/libraries/run.lua'), 'run.lua')(Args, commit)
else
	loadstring(game:HttpGet(`https://raw.githubusercontent.com/new-qwertyui/CatV5/{commit}/libraries/run.lua`), 'run.lua')(Args, commit)
end
