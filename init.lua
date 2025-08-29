if true then
    error('catvape is temporaily down')    
end

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

if not success or typeof(commitdata) ~= 'table' or commitdata.sha == nil then
	commitdata = {sha = 'main', files = {}}
end

local downloader = Instance.new('TextLabel', Instance.new('ScreenGui', gethui()))
downloader.Size = UDim2.new(1, 0, -0.08, 0)
downloader.BackgroundTransparency = 1
downloader.TextStrokeTransparency = 0
downloader.TextSize = 20
downloader.Text = 'Downloading catrewrite'
downloader.TextColor3 = Color3.new(1, 1, 1)
downloader.Font = Enum.Font.Arial

local function downloadFile2(path: string) : string
	if not isfile(path) or not developer then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/qwertyui-is-back/CatV5/'.. commitdata.sha.. '/'.. path:gsub('catrewrite/', ''))
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		writefile(path, res)
	end
	return readfile(path)
end

local function downloadFile(path: string) : string
	if not developer or not isfile(`catrewrite/{path}`) then
        local suc, res = pcall(function()
            return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..commitdata.sha..'/'..path:gsub('catrewrite/', ''):gsub(' ', '%%20'), true)
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
            Url = 'https://raw.githubusercontent.com/qwertyui-is-back/CatV5/'.. commitdata.sha.. '/'.. path:gsub('catrewrite/', ''),
            Method = 'GET'
        })
    end)
    return not suc or body.StatusCode == 404
end

local function yield(path: string) : ()
    if path == nil then
        downloader.Text = 'Failed to install catvape, Rejoin and try again!'
        repeat task.wait() until false
    end
    downloader.Text = `{isfile('catrewrite/'.. path) and 'Updating' or 'Downloading'} catrewrite/{path}`
    if gitisfolder(path) then
        makefolder(`catrewrite/{path}`)
        local contents = request({
            Url = `https://api.github.com/repos/new-qwertyui/CatV5/contents/{path}`,
            Method = 'GET'
        }) :: {Body: string, StatusCode: number}
        for _, v: table in httpService:JSONDecode(contents.Body) do
            yield(v.path)
        end
    else
        downloadFile(`catrewrite/{path}`)
    end
end

if not developer and commitdata.sha ~= 'main' then
    local newuser = not isfolder('catrewrite') or #listfiles('catrewrite') <= 6 or not isfolder('catrewrite/profiles') or not isfile('catrewrite/profiles/commit.txt')
    local blacklist = {'assets', '.vscode', 'README.md', 'games'}
    if newuser or readfile('catrewrite/profiles/commit.txt') ~= commitdata.sha or not isfile('catrewritereset2') then
        makefolder('catrewrite')
        if newuser then
            table.insert(blacklist, 'profiles')
            if not isfolder('catrewrite/profiles') then
                makefolder('catrewrite/profiles')
            end
            if isfolder('newcatvape') and isfolder('newcatvape/profiles') then
                for _, v: string in listfiles('newcatvape/profiles') do
                    writefile(({v:gsub('newcatvape', 'catrewrite')})[1], readfile(v))
                end
                delfolder('newcatvape')
            end
        end
        local contents = request({
            Url = `https://api.github.com/repos/new-qwertyui/CatV5/contents`,
            Method = 'GET'
        }) :: {Body: string, StatusCode: number}
        for _, v: table in httpService:JSONDecode(contents.Body) do
            if not table.find(blacklist, v.path) then
                yield(v.path)
            end
        end
    end
end

writefile('catrewrite/profiles/commit.txt', commitdata.sha)
writefile('catrewritereset2', 'True')

downloader:Destroy()

shared.VapeDeveloper = developer
getgenv().used_init = true
getgenv().catvapedev = developer

if not isfolder('catrewrite/communication') then
	makefolder('catrewrite/communication')
end

return loadstring(downloadFile2('catrewrite/main.lua'), 'main')(license)