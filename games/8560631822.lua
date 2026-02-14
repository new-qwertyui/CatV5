print('fr')
local vape = shared.vape
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then 
		vape:CreateNotification('Vape', 'Failed to load : '..err, 30, 'alert') 
	end
	return res
end
local isfile = isfile or function(file)
	local suc, res = pcall(function() 
		return readfile(file) 
	end)
	return suc and res ~= nil and res ~= ''
end
local function downloadFile(path, func)
	if not isfile(path) or not shared.VapeDeveloper then
		local suc, res = pcall(function() 
			return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..readfile('catrewrite/profiles/commit.txt')..'/'..select(1, path:gsub('catrewrite/', '')), true) 
		end)
		if not suc or res == '404: Not Found' then 
			error(res) 
		end
		if path:find('.lua') then 
			res = '\n'..res 
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local Place = 6872274481
vape.Place = Place
print('yo')
if isfile('catrewrite/games/'..Place..'.lua') then
	warn('w', tostring(Place))
	loadstring(readfile('catrewrite/games/'..Place..'.lua'), 'bedwars')()
else
	warn('Noo', tostring(Place))
	if not shared.VapeDeveloper then
		local suc, res = pcall(function() 
			return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..readfile('catrewrite/profiles/commit.txt')..'/games/'..vape.Place..'.lua', true) 
		end)
		if suc and res ~= '404: Not Found' then
			loadstring(downloadFile('catrewrite/games/'..Place..'.lua'), 'bedwars')()
		end
	end
end