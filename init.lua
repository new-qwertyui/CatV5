local license = ({...})[1] or {}
local developer = getgenv().catvapedev or license.Developer or false

local cloneref = cloneref or function(ref) return ref end
local gethui = gethui or function() return game:GetService('Players').LocalPlayer.PlayerGui end

local httpService = cloneref(game:GetService('HttpService'))

local success, commitdata = pcall(function()
    local commitinfo = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/new-qwertyui/CatV5/commits'))[1]
    if commitinfo and type(commitinfo) == 'table' then
        local fullinfo = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/new-qwertyui/CatV5/commits/'.. commitinfo.sha))
        fullinfo.hash = commitinfo.sha:sub(1, 7)
        return fullinfo
    end
end)

if not success or commitdata == nil then
	commitdata = {sha = 'main', files = {}}
end

if not isfile('newcatvapereset.txt') then
	if isfolder('newcatvape') then delfolder('newcatvape') end
	writefile('newcatvapereset.txt', 'true')
end

local downloader = Instance.new('TextLabel', Instance.new('ScreenGui', gethui()))
downloader.Size = UDim2.new(1, 0, 0, 40)
downloader.BackgroundTransparency = 1
downloader.TextStrokeTransparency = 0
downloader.TextSize = 20
downloader.TextColor3 = Color3.new(1, 1, 1)
downloader.Font = Enum.Font.Arial

local function downloadFile2(path: string) : string
	if not isfile(path) or not developer then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/qwertyui-is-back/CatV5/'.. commitdata.sha.. '/'.. path:gsub('newcatvape/', ''))
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		writefile(path, res)
	end
	return readfile(path)
end

local function downloadFile(path: string) : string
	if not developer or not isfile(`newcatvape/{path}`) then
        local suc, res = pcall(function()
            return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..commitdata.sha..'/'..select(1, path:gsub('newcatvape/', '')), true)
        end)
        if (not suc or res == '404: Not Found') then
            return 
        end
        writefile(path, res)
    end
	return readfile(path)
end

local function gitisfolder(path: string) : boolean
    local suc, body = pcall(function()
        return request({
            Url = 'https://raw.githubusercontent.com/qwertyui-is-back/CatV5/'.. commitdata.sha.. '/'.. path:gsub('newcatvape/', ''),
            Method = 'GET'
        })
    end)
    return not suc or body.StatusCode == 404
end

local function yield(path: string) : ()
    downloader.Text = `Downloading newcatvape/{path}`
    if gitisfolder(path) then
        warn('Folder', path)
        makefolder(`newcatvape/{path}`)
        local contents = request({
            Url = `https://api.github.com/repos/new-qwertyui/CatV5/contents/{path}`,
            Method = 'GET'
        }) :: {Body: string, StatusCode: number}
        for _, v: table in httpService:JSONDecode(contents.Body) do
            yield(v.path)
        end
    else
        warn('File', path)
        downloadFile(`newcatvape/{path}`)
    end
end

if not developer then
    if not isfolder('newcatvape') or #listfiles('newcatvape') <= 6 or not isfolder('newcatvape/profiles') or not isfile('newcatvape/profiles/commit.txt') or readfile('newcatvape/profiles/commit.txt') ~= commitdata.sha then
        makefolder('newcatvape')
        local contents = request({
            Url = `https://api.github.com/repos/new-qwertyui/CatV5/contents`,
            Method = 'GET'
        }) :: {Body: string, StatusCode: number}
        for _, v: table in httpService:JSONDecode(contents.Body) do
            if not table.find({'assets', '.vscode', 'README.md'}, v.path) then
                yield(v.path)
            end
        end
        writefile(`newcatvape/profiles/commit.txt`, commitdata.sha)
    end

    if commitdata.sha == 'main' then
		writefile('newcatvape/profiles/commit.txt', 'main')
    end
end

downloader:Destroy()

shared.VapeDeveloper = true
getgenv().used_init = true
getgenv().catvapedev = developer

if not isfolder('newcatvape/communication') then
	makefolder('newcatvape/communication')
end

return loadstring(downloadFile2('newcatvape/main.lua'), 'main')(license)
