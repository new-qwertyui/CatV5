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

local downloader = Instance.new('TextLabel', Instance.new('ScreenGui', gethui()))
downloader.Size = UDim2.new(1, 0, -0.08, 0)
downloader.BackgroundTransparency = 1
downloader.TextStrokeTransparency = 0
downloader.TextSize = 20
downloader.Text = 'Downloading newcatvape'
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
            return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..commitdata.sha..'/'..path:gsub('newcatvape/', ''):gsub(' ', '%%20'), true)
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
    if path == nil then
        downloader.Text = 'You have exceeded the limit, Please try again in 30 mins!'
        repeat task.wait() until false
    end
    downloader.Text = `{isfile('newcatvape/path') and 'Updating' or 'Downloading'} newcatvape/{path}`
    if gitisfolder(path) then
        makefolder(`newcatvape/{path}`)
        local contents = request({
            Url = `https://api.github.com/repos/new-qwertyui/CatV5/contents/{path}`,
            Method = 'GET'
        }) :: {Body: string, StatusCode: number}
        for _, v: table in httpService:JSONDecode(contents.Body) do
            yield(v.path)
        end
    else
        downloadFile(`newcatvape/{path}`)
    end
end

if not developer and commitdata.sha ~= 'main' then
    if not isfolder('newcatvape') or #listfiles('newcatvape') <= 6 or not isfolder('newcatvape/profiles') or not isfile('newcatvape/profiles/commit.txt') or readfile('newcatvape/profiles/commit.txt') ~= commitdata.sha or not isfile('newcatvapereset') then
        makefolder('newcatvape')
        local contents = request({
            Url = `https://api.github.com/repos/new-qwertyui/CatV5/contents`,
            Method = 'GET'
        }) :: {Body: string, StatusCode: number}
        for _, v: table in httpService:JSONDecode(contents.Body) do
            if not table.find({'assets', '.vscode', 'README.md', 'translations'}, v.path) then
                yield(v.path)
            end
        end
    end
end

writefile('newcatvape/profiles/commit.txt', commitdata.sha)
writefile('newcatvapereset', 'True')

downloader:Destroy()

shared.VapeDeveloper = true
getgenv().used_init = true
getgenv().catvapedev = developer

if not isfolder('newcatvape/communication') then
	makefolder('newcatvape/communication')
end

return loadstring(downloadFile2('newcatvape/main.lua'), 'main')(license)