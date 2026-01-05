
local loadonscreen = not game:IsLoaded()

repeat
	task.wait()
until game:IsLoaded()

if loadonscreen then
    task.wait(4)
end

if shared.vape then
	shared.vape:Uninject()
end

local license = ({...})[1] or {}
local developer =  license.Developer or getgenv().catvapedev or false
local closet = license.Closet or getgenv().closet or false
local commit = license.Commit or nil -- not meant to be downgradable

local loadstring = function(...)
	local res, err = loadstring(...)
	if err then
		error(err)
	end
	return res
end

if not commit or commit == 'main' then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/new-qwertyui/CatV5')
	end)
	commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'

	if #commit > 7 then
		commit = commit:sub(1, 7)
	end
end

local cloneref = cloneref or function(ref) return ref end
local gethui = gethui or function() return game:GetService('Players').LocalPlayer.PlayerGui end

local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local guiService = cloneref(game:GetService('GuiService'))
local httpService = cloneref(game:GetService('HttpService'))

local gui : ScreenGui = Instance.new('ScreenGui', gethui())
gui.Enabled = false

local Connections: {RBXScriptConnection} = {}

local stages = {
	UDim2.new(0, 50, 1, 0),
	UDim2.new(0, 100, 1, 0),
	UDim2.new(0, 160, 1, 0),
	UDim2.new(0, 200, 1, 0),
	UDim2.new(0, 240, 1, 0)
}

local function createinstance(class : string, properties : {[string] : any})
	local res = Instance.new(class)
	
	for property, value in properties do
		res[property] = value
	end

	return res
end

local function addCallback(image : ImageLabel | ImageButton, ...)
	local Original = image.ImageColor3
	
	table.insert(Connections, image.MouseEnter:Connect(function()  
		tweenService:Create(image, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
			ImageColor3 = Color3.fromRGB(44, 43, 44)
		}):Play()
	end))

	table.insert(Connections, image.MouseLeave:Connect(function()  
		tweenService:Create(image, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
			ImageColor3 = Original
		}):Play()
	end))

	table.insert(Connections, image.MouseButton1Click:Connect(...))
end

if closet then
	task.spawn(function()
		repeat
			for _, v in getconnections(game:GetService('LogService').MessageOut) do
				v:Disable()
			end

			for _, v in getconnections(game:GetService('ScriptContext').Error) do
				v:Disable()
			end

			task.wait(1)
		until not getgenv().closet
	end)
end

if gui.Enabled then
	local window = createinstance('ImageLabel', {
		Name = 'Main',
		Parent = gui,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(685, 399),
		ZIndex = 1,
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ScaleType = Enum.ScaleType.Fit,
		Image = 'rbxassetid://93496634716737'
	})

	-- DRAG --

	local scale
	
	window.InputBegan:Connect(function(inputObj)
		if
			(inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
			and (inputObj.Position.Y - window.AbsolutePosition.Y < 40)
		then
			local dragPosition = Vector2.new(
				window.AbsolutePosition.X - inputObj.Position.X,
				window.AbsolutePosition.Y - inputObj.Position.Y + guiService:GetGuiInset().Y
			) / scale.Scale

			local changed = inputService.InputChanged:Connect(function(input)
				if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					local position = input.Position
					if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
						dragPosition = (dragPosition // 3) * 3
						position = (position // 3) * 3
					end
					window.Position = UDim2.fromOffset((position.X / scale.Scale) + dragPosition.X, (position.Y / scale.Scale) + dragPosition.Y)
				end
			end)

			local ended
			ended = inputObj.Changed:Connect(function()
				if inputObj.UserInputState == Enum.UserInputState.End then
					if changed then
						changed:Disconnect()
					end
					if ended then
						ended:Disconnect()
					end
				end
			end)
		end
	end)

	-- EXIT BUTTON --

	local exit = createinstance('ImageButton', {
		Name = 'Exit',
		Parent = gui.Main,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(624, 23),
		Size = UDim2.fromOffset(40, 30),
		AutoButtonColor = false,
		ZIndex = 2,
		ImageColor3 = Color3.fromRGB(34, 33, 34),
		Image = 'rbxassetid://110629770884920',
		ScaleType = Enum.ScaleType.Fit
	})

	addCallback(exit, function()
		gui.Enabled = false
	end)

	createinstance('ImageLabel', {
		Name = 'Icon',
		Parent = gui.Main.Exit,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		ZIndex = 2,
		AnchorPoint = Vector2.new(0, 0.5),
		ImageTransparency = 0.4,
		ImageColor3 = Color3.new(1, 1, 1),
		Image = 'rbxassetid://128518278755224',
		ScaleType = Enum.ScaleType.Fit
	})

	-- MINIMIZE BUTTON --

	local minimize = createinstance('ImageButton', {
		Name = 'Minimize',
		Parent = gui.Main,
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(582, 23),
		ZIndex = 2,
		Size = UDim2.fromOffset(40, 30),
		AutoButtonColor = false,
		ImageColor3 = Color3.fromRGB(34, 33, 34),
		Image = 'rbxassetid://133363055871405',
		ScaleType = Enum.ScaleType.Fit
	})

	addCallback(minimize, function() end)

	createinstance('ImageLabel', {
		Name = 'Icon',
		Parent = gui.Main.Minimize,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 14, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(0, 0.5),
		ImageTransparency = 0.4,
		ImageColor3 = Color3.new(1, 1, 1),
		Image = 'rbxassetid://83568668289707',
		ScaleType = Enum.ScaleType.Fit
	})

	-- VAPE LOGO --

	createinstance('ImageLabel', {
		Name = 'textvape',
		Parent = gui.Main,
		AnchorPoint = Vector2.new(0.48, 0.31),
		BackgroundTransparency = 1,
		ZIndex = 2,
		Position = UDim2.fromScale(0.48, 0.31),
		Size = UDim2.fromOffset(70, 70),
		Image = 'rbxassetid://84228868064393',
		ScaleType = Enum.ScaleType.Fit
	})

	createinstance('ImageLabel', {
		Name = 'version',
		Parent = gui.Main.textvape,
		BackgroundTransparency = 1,
		ZIndex = 2,
		Position = UDim2.fromScale(1, 0.3),
		Size = UDim2.fromOffset(29, 29),
		Image = 'rbxassetid://138794287840926',
		ImageColor3 = Color3.fromRGB(98, 198, 158),
		ScaleType = Enum.ScaleType.Fit
	})

	-- LOAD BAR --

	createinstance('Frame', {
		Name = 'loadbar',
		Parent = gui.Main,
		AnchorPoint = Vector2.new(0.5, 0.53),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
		ZIndex = 2,
		Position = UDim2.fromScale(0.5, 0.53),
		Size = UDim2.fromOffset(240, 6)
	})

	createinstance('Frame', {
		Name = 'fullbar',
		Parent = gui.Main.loadbar,
		BackgroundColor3 = Color3.fromRGB(3, 102, 79),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 1, 0),
		ZIndex = 2
	})

	-- ACTION TEXT --

	createinstance('TextLabel', {
		Name = 'action',
		Parent = gui.Main,
		BackgroundTransparency = 1,
		Position = UDim2.fromScale(0.353284657, 0.556391001),
		Size = UDim2.fromOffset(200, 15),
		Font = Enum.Font.Arial,
		ZIndex = 2,
		Text = '',
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 12,
		TextTransparency = 0.3
	})

	Instance.new('UICorner', gui.Main.loadbar)
	Instance.new('UICorner', gui.Main.loadbar.fullbar)
	
	scale = Instance.new('UIScale', gui.Main)
	scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.485)

	task.spawn(function()
		repeat task.wait() until shared.vape and shared.vape.Loaded

		task.wait(2)

		gui:Destroy()
	end)
end;

local debug = debug

if table.find({'Xeno', 'Solara'}, ({identifyexecutor()})[1]) then
	debug = table.clone(debug)
	debug.getupvalue = nil
	debug.getconstant = nil
	debug.setstack = nil

	getgenv().debug = debug
end

local canDebug = debug.getupvalue ~= nil

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			local subbed = path:gsub('catrewrite/', '')
			subbed = subbed:gsub(' ', '%%20')
			return game:HttpGet('https://raw.githubusercontent.com/new-qwertyui/CatV5/'..commit..'/'..subbed, true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('init') then continue end
		if isfile(file) then
			delfile(file)
		end
	end
end 

local function makestage(stage, package)
	if gui.Enabled then
		tweenService:Create(gui.Main.loadbar.fullbar, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
			Size = stages[stage]
		}):Play()
		gui.Main.action.Text = package or ''
	end
end

makestage(1, 'Downloading packages')

for _, folder in {'catrewrite', 'catrewrite/communication', 'catrewrite/translations', 'catrewrite/games', 'catrewrite/cache', 'catrewrite/games/bedwars', 'catrewrite/profiles', 'catrewrite/assets', 'catrewrite/libraries', 'catrewrite/libraries/Enviroments', 'catrewrite/guis', 'catrewrite/libraries/Weather', 'catrewrite/libraries/LightningLib', 'catrewrite/libraries/LightningLib/Sparks'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

if (not license.Developer and not shared.VapeDeveloper) then
	local Updated: boolean = (commit == 'main' or (isfile('catrewrite/profiles/commit.txt') and readfile('catrewrite/profiles/commit.txt') or '') ~= commit)

	if Updated then
		wipeFolder('catrewrite')
		wipeFolder('catrewrite/games')
		wipeFolder('catrewrite/guis')
		wipeFolder('catrewrite/cache')
		wipeFolder('catrewrite/libraries')
	end
	
	if #listfiles('catrewrite/profiles') <= 2 then
		makestage(2, 'Downloading config, This may take up to 20s')

		local preloaded = pcall(function()
			local req = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/new-qwertyui/CatV5/contents/profiles'))

			for _, v in req do
				if v.path ~= 'profiles/commit.txt' then
					downloadFile(`catrewrite/{v.path}`)
				end
			end
		end)

		if not preloaded then
			makestage(2, `Failed to download preset config ({identifyexecutor()}), Will recontinue in 2 seconds.`)
			task.wait(2)
		end
	end

	if #listfiles('catrewrite/translations') <= 2 then
		makestage(2, 'Downloading languages, this may take a bit')
	
		local req = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/new-qwertyui/CatV5/contents/translations'))

		for _, v in req do
			makestage(2, `Downloading {v.name} language`)
			pcall(downloadFile, `catrewrite/{v.path}`)
		end
	end
	
	if not canDebug and Updated then
		makestage(2, `Downloading {({identifyexecutor()})[1]} support, this may take a bit`)
	
		local req = httpService:JSONDecode(game:HttpGet('https://api.github.com/repos/new-qwertyui/CatV5/contents/cache'))

		for _, v in req do
			pcall(downloadFile, `catrewrite/{v.path}`)
		end
	end
end

writefile('catrewrite/profiles/commit.txt', commit)
pcall(downloadFile, 'catrewrite/libraries/pathfind.lua')
pcall(downloadFile, 'catrewrite/init.lua')
pcall(downloadFile, 'catrewrite/libraries/oldpath.lua')

shared.VapeDeveloper = developer
getgenv().used_init = true
getgenv().catvapedev = developer
getgenv().closet = closet
getgenv().makestage = makestage
getgenv().canDebug = canDebug

getgenv().username = license.Username or getgenv().username
getgenv().password = license.Password or getgenv().password

local success, err = pcall(function()
	loadstring(downloadFile('catrewrite/main.lua'), 'main')()
end)

for _, v in Connections do
	v:Disconnect()
end

table.clear(Connections)

if not success then
	error('Failed to initalize catvape: '.. err, 8)
elseif not closet then
	loadstring(downloadFile('catrewrite/libraries/annc.lua'), 'announcements.lua')() 
end