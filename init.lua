if not isfolder('catrewrite') then
    makefolder('catrewrite')
end

local function downloadFile(path, comm, func)
	local suc, res = pcall(function()
		return game:HttpGet(`https://raw.githubusercontent.com/new-qwertyui/CatV5/{comm}/{({path:gsub('catrewrite', '')})[1]}`, true)
	end)
	if not suc or res == '404: Not Found' then
		error(res)
	end
	writefile(path, res)
	
	return (func or readfile)(path)
end

local _, subbed = pcall(function()
	return game:HttpGet('https://github.com/new-qwertyui/CatV5')
end)
commit = subbed:find('currentOid')
commit = commit and subbed:sub(commit + 13, commit + 52) or nil
commit = commit and #commit == 40 and commit or 'main'
commit = commit:sub(1, 7)

return loadstring(downloadFile('catrewrite/loader.luau', commit), 'loader.luau')(..., commit)