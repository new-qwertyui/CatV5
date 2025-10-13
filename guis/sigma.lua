local mainapi = setmetatable({
	Categories = {},
	GUIColor = {
		Hue = 1,
		Sat = 1,
		Value = 1
	},
	HeldKeybinds = {},
	Keybind = {'RightShift'},
	Loaded = false,
	Libraries = {},
	Legit = {
		Modules = {}
	},
	Modules = {},
	Place = game.PlaceId,
	Profile = 'default',
	Profiles = {},
	RainbowSpeed = {Value = 1},
	RainbowUpdateSpeed = {Value = 60},
	RainbowTable = {},
	Scale = {Value = 1},
	ThreadFix = setthreadidentity and true or false,
	ToggleNotifications = {},
	Version = '5.0',
	Visible = false,
	Windows = {},
	Options = {}
}, {
	__index = function(self, index)
		self[index] = {}
		return self[index]
	end
})

local cloneref = cloneref or function(obj)
	return obj
end
local tweenService = cloneref(game:GetService('TweenService'))
local inputService = cloneref(game:GetService('UserInputService'))
local textService = cloneref(game:GetService('TextService'))
local guiService = cloneref(game:GetService('GuiService'))
local httpService = cloneref(game:GetService('HttpService'))
local fpsmode = true

local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge
local notifications = Instance.new('Folder')
notifications.Name = 'Notifications'
local assetfunction = getcustomasset
local getcustomasset
local clickgui
local moduleinfos
local scaledgui
local mainframe
local mainscale
local sidebar
local categoryholder
local categoryhighlight
local lastSelected
local guiTween1
local guiTween2
local scale
local gui
local hud

local color = {}
local tween = {
	tweens = {},
	tweenstwo = {}
}

local uipallet = {
	Main = Color3.fromRGB(254, 254, 254),
	MainColor = Color3.fromRGB(41, 166, 255),
	TextLight = Color3.new(1, 1, 1),
	TextDark = Color3.new(0, 0, 0),
	Tween1 = TweenInfo.new(0.1, Enum.EasingStyle.Linear),
	Tween2 = TweenInfo.new(0.2, Enum.EasingStyle.Linear),
}

local getcustomassets = {
    ["catrewrite/assets/sigma/check.png"] = "rbxassetid://105451289257415",
    ["catrewrite/assets/sigma/circleblur.png"] = "rbxassetid://70471624673038",
    ['catrewrite/assets/sigma/blur.png'] = 'rbxassetid://14898786664',
    ['catrewrite/assets/sigma/alert.png'] = 'rbxasset://catrewrite/assets/sigma/alert.png',
    ['catrewrite/assets/sigma/cancel.png'] = 'rbxasset://catrewrite/assets/sigma/cancel.png',
    ['catrewrite/assets/sigma/done.png'] = 'rbxasset://catrewrite/assets/sigma/done.png',
    ['catrewrite/assets/sigma/gingerbread.png'] = 'rbxasset://catrewrite/assets/sigma/gingerbread.png',
    ['catrewrite/assets/sigma/info.png'] = 'rbxasset://catrewrite/assets/sigma/info.png',
    ['catrewrite/assets/sigma/play.png'] = 'rbxasset://catrewrite/assets/sigma/play.png',
    ['catrewrite/assets/sigma/warn.png'] = 'rbxasset://catrewrite/assets/sigma/warn.png'
}

local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end

local getfontsize = function(text, size, font)
	fontsize.Text = text
	fontsize.Size = size
	if typeof(font) == 'Font' then
		fontsize.Font = font
	end
	return textService:GetTextBoundsAsync(fontsize)
end

local function addBlur(parent, notif)
	local blur = Instance.new('ImageLabel')
	blur.Name = 'Blur'
	blur.Size = UDim2.new(1, 89, 1, 52)
	blur.Position = UDim2.fromOffset(-48, -31)
	blur.ImageColor3 = parent.BackgroundColor3
	blur.BackgroundTransparency = 1
	blur.Image = getcustomasset('catrewrite/assets/sigma/blur.png')
	blur.ScaleType = Enum.ScaleType.Slice
	blur.SliceCenter = Rect.new(52, 31, 261, 502)
	blur.Parent = parent

	return blur
end

local function checkKeybinds(compare, target, key)
	if type(target) == 'table' then
		if table.find(target, key) then
			for i, v in target do
				if not table.find(compare, v) then
					return false
				end
			end
			return true
		end
	end

	return false
end

local function addCorner(parent, radius)
	local corner = Instance.new('UICorner')
	corner.CornerRadius = radius or UDim.new(0, 5)
	corner.Parent = parent

	return corner
end

local function addMaid(object)
	object.Connections = {}
	function object:Clean(callback)
		if typeof(callback) == 'Instance' then
			table.insert(mainapi.Connections, {
				Disconnect = function()
					callback:ClearAllChildren()
					callback:Destroy()
				end
			})
		elseif type(callback) == 'function' then
			table.insert(mainapi.Connections, {
				Disconnect = callback
			})
		else
			table.insert(mainapi.Connections, callback)
		end
	end
end

local function createMobileButton(buttonapi, position)
	if not inputService.TouchEnabled then return end
	local heldbutton = false
	local button = Instance.new('TextButton')
	button.Size = UDim2.fromOffset(40, 40)
	button.Position = UDim2.fromOffset(position.X, position.Y)
	button.AnchorPoint = Vector2.new(0.5, 0.5)
	button.BackgroundColor3 = buttonapi.Enabled and Color3.new(0, 0.7, 0) or Color3.new()
	button.BackgroundTransparency = 0.5
	button.Text = buttonapi.Name
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextScaled = true
	button.Font = Enum.Font.Gotham
	button.Parent = mainapi.gui
	local buttonconstraint = Instance.new('UITextSizeConstraint')
	buttonconstraint.MaxTextSize = 16
	buttonconstraint.Parent = button
	addCorner(button, UDim.new(0.1, 0))

	button.MouseButton1Down:Connect(function()
		heldbutton = true
		local holdtime, holdpos = tick(), inputService:GetMouseLocation()
		repeat
			heldbutton = (inputService:GetMouseLocation() - holdpos).Magnitude < 6
			task.wait()
		until (tick() - holdtime) > 1 or not heldbutton
		if heldbutton then
			buttonapi.Bind = {}
			button:Destroy()
		end
	end)
	button.MouseButton1Up:Connect(function()
		heldbutton = false
	end)
	button.MouseButton1Click:Connect(function()
		buttonapi:Toggle()
		button.BackgroundColor3 = buttonapi.Enabled and Color3.new(0, 0.7, 0) or Color3.new()
	end)

	buttonapi.Bind = {Button = button}
end

local function downloadFile(path, func)
	if not isfile(path) then
		pcall(function()
			createDownloader(path)
		end)
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

getcustomasset = not inputService.TouchEnabled and assetfunction and function(path)
	return downloadFile(path, assetfunction)
end or identifyexecutor():lower():find("delta") and assetfunction and function(path)
	return downloadFile(path, assetfunction)
end or function(path)
	return getcustomassets[path] or ''
end

local function writeSffont()
	if not assetfunction then return 'rbxasset://fonts/roboto.json' end
	writefile('catrewrite/assets/sigma/sfdisplay.json', httpService:JSONEncode({
		name = 'SF-UI Display',
		faces = {
			--{style = 'normal', assetId = getcustomasset('catrewrite/assets/sigma/fonts/Geomanist-Regular.otf'), name = 'Geomanist', weight = 400},
			--{style = 'normal', assetId = getcustomasset('catrewrite/assets/sigma/fonts/HelveticaNeue-Light.ttf'), name = 'HelveticaNeueLight', weight = 300},
			{style = 'normal', assetId = getcustomasset('catrewrite/assets/sigma/fonts/SF-UI-Display-Bold.otf'), name = 'Bold', weight = 600},
			{style = 'normal', assetId = getcustomasset('catrewrite/assets/sigma/fonts/SF-UI-Display-Light.otf'), name = 'Light', weight = 300},
			{style = 'normal', assetId = getcustomasset('catrewrite/assets/sigma/fonts/SF-UI-Display-Medium.otf'), name = 'Medium', weight = 500},
			{style = 'normal', assetId = getcustomasset('catrewrite/assets/sigma/fonts/SF-UI-Display-Regular.otf'), name = 'Regular', weight = 400},
			{style = 'normal', assetId = getcustomasset('catrewrite/assets/sigma/fonts/SF-UI-Display-Semibold.otf'), name = 'SemiBold', weight = 550},
			{style = 'normal', assetId = getcustomasset('catrewrite/assets/sigma/fonts/SF-UI-Display-Semibold-1.otf'), name = 'Black', weight = 550},
			{style = 'normal', assetId = getcustomasset('catrewrite/assets/sigma/fonts/SF-UI-Display-Thin.otf'), name = 'Thin', weight = 350},
		}
	}))
	return getcustomasset('catrewrite/assets/sigma/sfdisplay.json')
end
local function writeSigmafont()
	if not assetfunction then return 'rbxasset://fonts/roboto.json' end
	writefile('catrewrite/assets/sigma/sigmafont.json', httpService:JSONEncode({
		name = 'Sigma',
		faces = {
			{style = 'normal', assetId = getcustomasset('catrewrite/assets/sigma/fonts/Geomanist-Regular.otf'), name = 'Regular', weight = 400},
			{style = 'normal', assetId = getcustomasset('catrewrite/assets/sigma/fonts/HelveticaNeue-Light.ttf'), name = 'Light', weight = 300},
    	}
	}))
	return getcustomasset('catrewrite/assets/sigma/sigmafont.json')
end

local function getTableSize(tab)
	local ind = 0
	for _ in tab do ind += 1 end
	return ind
end

local function loopClean(tab)
	for i, v in tab do
		if type(v) == 'table' then
			loopClean(v)
		end
		tab[i] = nil
	end
end

local function loadJson(path)
	local suc, res = pcall(function()
		return httpService:JSONDecode(readfile(path))
	end)
	return suc and type(res) == 'table' and res or nil
end

local function makeDraggable(gui, window)
	gui.InputBegan:Connect(function(inputObj)
		if window and not window.Visible then return end
		if
			(inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch)
			and (inputObj.Position.Y - gui.AbsolutePosition.Y < 40 or window)
		then
			local dragPosition = Vector2.new(
				gui.AbsolutePosition.X - inputObj.Position.X,
				gui.AbsolutePosition.Y - inputObj.Position.Y + guiService:GetGuiInset().Y
			) / scale.Scale

			local changed = inputService.InputChanged:Connect(function(input)
				if input.UserInputType == (inputObj.UserInputType == Enum.UserInputType.MouseButton1 and Enum.UserInputType.MouseMovement or Enum.UserInputType.Touch) then
					local position = input.Position
					if inputService:IsKeyDown(Enum.KeyCode.LeftShift) then
						dragPosition = (dragPosition // 3) * 3
						position = (position // 3) * 3
					end
					gui.Position = UDim2.fromOffset((position.X / scale.Scale) + dragPosition.X, (position.Y / scale.Scale) + dragPosition.Y)
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
end

local function randomString()
	local array = {}
	for i = 1, math.random(10, 100) do
		array[i] = string.char(math.random(32, 126))
	end
	return table.concat(array)
end

local function removeTags(str)
	str = str:gsub('<br%s*/>', '\n')
	return str:gsub('<[^<>]->', '')
end

do
    local sfdisplayfont = writeSffont()
	uipallet.Font = Font.new(sfdisplayfont, Enum.FontWeight.Regular)
	uipallet.FontMedium = Font.new(sfdisplayfont, Enum.FontWeight.Medium)
	uipallet.FontSemiBold = Font.new(sfdisplayfont, Enum.FontWeight.SemiBold)
	uipallet.FontLight = Font.new(sfdisplayfont, Enum.FontWeight.Light)
	uipallet.FontBold = Font.new(sfdisplayfont, Enum.FontWeight.Bold)
	local sigmafont = writeSigmafont()
	uipallet.FontGeomanist = Font.new(sigmafont, Enum.FontWeight.Regular)
	uipallet.FontHelvetica = Font.new(sigmafont, Enum.FontWeight.Light)
	local res = isfile('catrewrite/profiles/color.txt') and loadJson('catrewrite/profiles/color.txt')
	fontsize.Font = uipallet.Font
end

do
	function color.Dark(col, num)
		local h, s, v = col:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(select(3, uipallet.Main:ToHSV()) > 0.5 and v + num or v - num, 0, 1))
	end

	function color.Light(col, num)
		local h, s, v = col:ToHSV()
		return Color3.fromHSV(h, s, math.clamp(select(3, uipallet.Main:ToHSV()) > 0.5 and v - num or v + num, 0, 1))
	end

	function mainapi:Color(h)
		local s = 0.75 + (0.15 * math.min(h / 0.03, 1))
		if h > 0.57 then
			s = 0.9 - (0.4 * math.min((h - 0.57) / 0.09, 1))
		end
		if h > 0.66 then
			s = 0.5 + (0.4 * math.min((h - 0.66) / 0.16, 1))
		end
		if h > 0.87 then
			s = 0.9 - (0.15 * math.min((h - 0.87) / 0.13, 1))
		end
		return h, s, 1
	end

	function mainapi:TextColor(h, s, v)
		if v >= 0.7 and (s < 0.6 or h > 0.04 and h < 0.56) then
			return Color3.new(0.19, 0.19, 0.19)
		end
		return Color3.new(1, 1, 1)
	end
end

do
	function tween:Tween(obj, tweeninfo, goal, tab)
		tab = tab or tween.tweens
		if tab[obj] then
			tab[obj]:Cancel()
		end

		if obj.Parent and obj.Visible then
			tab[obj] = tweenService:Create(obj, tweeninfo, goal)
			tab[obj].Completed:Once(function()
				if tab then
					tab[obj] = nil
					tab = nil
				end
			end)
			tab[obj]:Play()
		else
			for i, v in goal do
				obj[i] = v
			end
		end
	end

	function tween:Cancel(obj)
		if mainapi.tweens[obj] then
			mainapi.tweens[obj]:Cancel()
			mainapi.tweens[obj] = nil
		end
	end
end

mainapi.Libraries = {
	color = color,
	getcustomasset = getcustomasset,
	getfontsize = getfontsize,
	tween = tween,
	uipallet = uipallet,
	base64 = loadstring(downloadFile("catrewrite/libraries/base64.lua"), "base64")(),
	spotify = loadstring(downloadFile("catrewrite/libraries/spotify.lua"), "spotify")()
}

local components
local dropdowns = 0
components = {
	Button = function(optionsettings, children, api)
	    
    end,
	ColorSlider = function(optionsettings, children, api)
	    
    end,
	Dropdown = function(optionsettings, children, api)
		local optionapi = {
			Type = 'Dropdown',
			Value = optionsettings.List[1] or optionsettings.List[optionsettings.Default] 'None',
			Index = 0
		}
		print("dropdown -", optionapi.Value)
		dropdowns += 1
		local dropdown = Instance.new('TextLabel', children['ScrollingFrame'])
		dropdown.FontFace = uipallet.FontHelvetica
		dropdown.BackgroundTransparency = 1
		dropdown.Size = UDim2.fromScale(1, 0.065)
		dropdown.TextScaled = true
		dropdown.TextColor3 = uipallet.TextDark
		dropdown.Text = optionsettings.Name
		dropdown.TextXAlignment = Enum.TextXAlignment.Left
		dropdown.ZIndex = 900 / dropdowns --> NEEDED
		dropdown.Visible = (optionsettings.Visible ~= nil and optionsettings.Visible or true) or false

		local modholder = Instance.new('ScrollingFrame', dropdown)
		modholder.BackgroundTransparency = 1
		modholder.Position = UDim2.fromScale(0.72, 0.24)
		modholder.Size = UDim2.fromOffset(123, 27)
		modholder.SizeConstraint = Enum.SizeConstraint.RelativeYY
		modholder.ScrollBarThickness = 0
		modholder.ZIndex = 3
		local butt = Instance.new('TextButton', dropdown)
		butt.BackgroundTransparency = 1
		butt.Position = UDim2.fromScale(0.72, 0)
		butt.Size = UDim2.fromOffset(123, 35)
		butt.SizeConstraint = Enum.SizeConstraint.RelativeYY
		butt.TextTransparency = 1
		butt.BorderSizePixel = 0
		butt.ZIndex = 4
		butt.BackgroundTransparency = 0.99

		local dropdowntext = Instance.new('TextLabel', dropdown)
		dropdowntext.BackgroundTransparency = 1
		dropdowntext.Position = UDim2.fromScale(0.948, 0.428)
		dropdowntext.Size = UDim2.fromOffset(17, 17)
		dropdowntext.ZIndex = 1000 / dropdowns
		dropdowntext.FontFace = uipallet.FontHelvetica
		dropdowntext.TextColor3 = Color3.fromRGB(190, 190, 190)
		dropdowntext.Text = '>'
		dropdowntext.TextScaled = true
		
		local dropdownopen = Instance.new('TextButton', dropdowntext)
		dropdownopen.TextTransparency = 1
		dropdownopen.BackgroundTransparency = 1
		dropdownopen.Text = ''
		dropdownopen.Position = UDim2.fromScale(-0.647, -0.316)
		dropdownopen.Size = UDim2.fromOffset(40, 34)
		dropdownopen.ZIndex = 6000 / dropdowns
		dropdownopen.MouseButton1Click:Connect(function()
			if dropdowntext.Text == '>' then
				dropdowntext.Text = 'v'
				modholder.Size = UDim2.fromOffset(123, 27 * #modholder:GetChildren() - 1)
			else
				dropdowntext.Text = '>'
				modholder.Size = UDim2.fromOffset(123, 27)
			end
		end)
		butt.MouseButton1Click:Connect(function()
			if dropdowntext.Text == '>' then
				dropdowntext.Text = 'v'
				modholder.Size = UDim2.fromOffset(123, 27 * #modholder:GetChildren() - 1)
			else
				dropdowntext.Text = '>'
				modholder.Size = UDim2.fromOffset(123, 27)
			end
		end)

		Instance.new('UIListLayout', modholder).VerticalAlignment = Enum.VerticalAlignment.Top
		
		optionapi.Object = dropdown
		local frames = {}
		
		function optionapi:Save(tab)
			tab[optionsettings.Name] = {Value = self.Value}
		end
		
		function optionapi:Load(tab)
			if self.Value ~= tab.Value then
				self:SetValue(tab.Value)
			end
		end
		
		optionsettings.Function = optionsettings.Function or function() end
		function optionapi:SetValue(val, child)
			frames[1].qwerty.Text = table.find(optionsettings.List, val) and val or optionsettings.List[1] or 'None'
			self.Value = table.find(optionsettings.List, val) and val or optionsettings.List[1] or 'None'
			task.spawn(optionsettings.Function, self.Value)
		end

		local first = true
		function optionapi:Change(list)
			optionsettings.List = list or {}
			if not table.find(optionsettings.List, self.Value) then
				self:SetValue(self.Value)
			end
			local list2 = {
				[1] = optionsettings.List[1] or 'None'
			}
			for i,v in list do
				table.insert(list2, v)
			end
			list = list2
			if not first then
				optionsettings.List = list or {}
			end
			first = false
			for i,v in modholder:GetChildren() do
				if v.ClassName ~= 'UIListLayout' and v.ClassName ~= 'ImageLabel' then
					v:Remove()
				end
			end
			for i,v in list do
				local frame = Instance.new('Frame', modholder)
				frame.BackgroundColor3 = uipallet.Main
				frame.Size = UDim2.fromOffset(123, 27)
				frame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
				frame.BorderSizePixel = 0
				frames[#modholder:GetChildren() - 1] = frame
				frame.ZIndex = (#modholder:GetChildren() - 1) * 50

				local selectbutton = Instance.new('TextButton', frame)
				selectbutton.Position = UDim2.fromScale(0.05, 0.185)
				selectbutton.Size = UDim2.fromScale(1, 0.625)
				selectbutton.Name = 'qwerty'
				selectbutton.FontFace = uipallet.FontHelvetica
				selectbutton.BackgroundTransparency = 1
				selectbutton.BorderSizePixel = 0
				selectbutton.Text = v
				selectbutton.TextXAlignment = Enum.TextXAlignment.Left
				selectbutton.ZIndex = 9000
				selectbutton.TextScaled = true
				selectbutton.TextColor3 = i == 1 and Color3.fromRGB(48, 48, 48) or Color3.fromRGB(110, 110, 110)
				if i ~= 1 then selectbutton.MouseButton1Click:Connect(function()
					optionapi:SetValue(selectbutton.Text, frame)
					modholder.Size = UDim2.fromOffset(123, 27)
					dropdowntext.Text = '>'
				end) end
			end
		end

		optionapi:Change(optionsettings.List)

		return optionapi
	end,
	Font = function(optionsettings, children, api)
	    local fonts = {
			optionsettings.Blacklist,
			'Custom'
		}
		for _, v in Enum.Font:GetEnumItems() do
			if not table.find(fonts, v.Name) then
				table.insert(fonts, v.Name)
			end
		end
		
		local optionapi = {Value = Font.fromEnum(Enum.Font[fonts[1]])}
		local fontdropdown
		local fontbox
		optionsettings.Function = optionsettings.Function or function() end
		
		fontdropdown = components.Dropdown({
			Name = optionsettings.Name,
			List = fonts,
			Function = function(val)
				fontbox.Object.Visible = val == 'Custom' and fontdropdown.Object.Visible
				if val ~= 'Custom' then
					optionapi.Value = Font.fromEnum(Enum.Font[val])
					optionsettings.Function(optionapi.Value)
				else
					pcall(function()
						optionapi.Value = Font.fromId(tonumber(fontbox.Value))
					end)
					optionsettings.Function(optionapi.Value)
				end
			end,
			Darker = optionsettings.Darker,
			Visible = optionsettings.Visible
		}, children, api)
		optionapi.Object = fontdropdown.Object
		fontbox = components.TextBox({
			Name = optionsettings.Name..' Asset',
			Placeholder = 'font (rbxasset)',
			Function = function()
				if fontdropdown.Value == 'Custom' then
					pcall(function()
						optionapi.Value = Font.fromId(tonumber(fontbox.Value))
					end)
					optionsettings.Function(optionapi.Value)
				end
			end,
			Visible = false,
			Darker = true
		}, children, api)
		
		fontdropdown.Object:GetPropertyChangedSignal('Visible'):Connect(function()
			fontbox.Object.Visible = fontdropdown.Object.Visible and fontdropdown.Value == 'Custom'
		end)
		
		return optionapi
	end,
	Slider = function(optionsettings, children, api)
		local optionapi = {
			Type = 'Slider',
			Value = optionsettings.Default or optionsettings.Min,
			Max = optionsettings.Max,
			Index = getTableSize(api.Options)
		}
		
		local slider = Instance.new('TextLabel', children['ScrollingFrame'])
		slider.FontFace = uipallet.FontHelvetica
		slider.BackgroundTransparency = 1
		slider.Size = UDim2.fromScale(1, 0.065)
		slider.TextScaled = true
		slider.TextColor3 = uipallet.TextDark
		slider.Text = optionsettings.Name or 'Slider'
		slider.TextXAlignment = Enum.TextXAlignment.Left
		slider.Visible = (optionsettings.Visible ~= nil and optionsettings.Visible or true) or false
		slider.ZIndex = 3

		local bg = Instance.new('Frame', slider)
		bg.BackgroundColor3 = Color3.fromRGB(215, 234, 254)
		bg.Position = UDim2.fromScale(0.72, 0.36)
		bg.Size = UDim2.fromOffset(111, 6)
		bg.ZIndex = 3
		
		addCorner(bg, UDim.new(250, 100))

		local bar = Instance.new('Frame', bg)
		bar.BackgroundColor3 = Color3.fromRGB(59, 153, 253)
		bar.BorderSizePixel = 0
		bar.Size = UDim2.fromScale(math.clamp((optionapi.Value + 1 - optionsettings.Min) / optionsettings.Max, 0.243, 1), 1)
		bar.ZIndex = 3

		local shadow = Instance.new('ImageLabel', bg)
		shadow.Image = getcustomasset('catrewrite/assets/sigma/circleblur.png')
		shadow.ImageTransparency = 0.4
		shadow.BorderSizePixel = 0
		shadow.BackgroundTransparency = 1
		shadow.SizeConstraint = Enum.SizeConstraint.RelativeXX
		shadow.Size = UDim2.fromScale(0.3, 0.3)
		shadow.ZIndex = 3

		local circle = Instance.new('TextButton', bg)
		circle.BackgroundColor3 = uipallet.Main
		circle.Position = UDim2.fromScale(math.clamp((optionapi.Value + 1 - optionsettings.Min) / optionsettings.Max, 0.243, 1) - 0.1, -1.5)
		circle.BorderSizePixel = 0
		circle.Size = UDim2.fromScale(0.2, 0.2)
		circle.SizeConstraint = Enum.SizeConstraint.RelativeXX
		circle.Text = ''
		circle.TextTransparency = 1
		circle.ZIndex = 3
		circle.BackgroundTransparency = 0
		addCorner(circle, UDim.new(250, 100))
		addMaid(optionapi)
		addCorner(bar, UDim.new(250, 100))

		shadow.Position = circle.Position + UDim2.fromScale(-0.06, -0.5)
		
		optionapi.Object = slider

		local function getpos(val, val2)
			return val - (val % val2)
		end
				
		function optionapi:SetValue(value, pos, final)
			if tonumber(value) == math.huge or value ~= value then return end
			local check = self.Value ~= value
			self.Value = value
			tween:Tween(bar, TweenInfo.new(0.05), {
				Size = UDim2.fromScale(math.clamp((pos and pos.X.Scale) or math.clamp(value / optionsettings.Max, 0, 1), 0.04, 0.96), 1)
			})
			tween:Tween(circle, TweenInfo.new(0.05), {
				Position = UDim2.fromScale(math.clamp((pos and pos.X.Scale) or math.clamp(value / optionsettings.Max, 0, 1), 0.04, 0.96) - 0.1, circle.Position.Y.Scale)
			})
			tween:Tween(shadow, TweenInfo.new(0.05), {
				Position = UDim2.fromScale(math.clamp((pos and pos.X.Scale) or math.clamp(value / optionsettings.Max, 0, 1), 0.04, 0.96) - 0.1, circle.Position.Y.Scale) + UDim2.fromScale(-0.06, -0.5)
			})
			--valuetext.Text = self.Value..(optionsettings.Suffix and ' '..(type(optionsettings.Suffix) == 'function' and optionsettings.Suffix(self.Value) or optionsettings.Suffix) or '')
			optionsettings.Function = optionsettings.Function or function() end
			if check or final then
				optionsettings.Function(value, final)
			end
		end

		circle.InputBegan:Connect(function(inputObj)
			print(inputObj.UserInputType == Enum.UserInputType.MouseButton1)
			if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) then
				local lastSelected
				local lastPosition
				local lastValue = optionapi.Value
				local changed = inputService.InputChanged:Connect(function(input)
					local percentage = math.round(getpos(math.clamp((game.Players.LocalPlayer:GetMouse().X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1), .02) * 100) / 100
					bar.Size = UDim2.fromScale(percentage, bar.Size.Y.Scale)
					local newPosition = UDim2.fromScale(percentage - 0.1, circle.Position.Y.Scale)
					lastPosition = newPosition
					circle.Position = newPosition
					shadow.Position = circle.Position + UDim2.fromScale(-0.06, -0.5)
                    local value = (optionsettings.Max * (optionsettings.Decimal and optionsettings.Decimal > 0 and optionsettings.Decimal or 1)) * percentage, 
                        math.clamp((game.Players.LocalPlayer:GetMouse().X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
					optionapi:SetValue(
                        value
                    )
                    warn(value, 'Slider')
					lastValue = optionapi.Value
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
						optionapi:SetValue(lastValue, lastPosition, true)
					end
				end)
		
			end
		end)

		return optionapi
	end,
	Targets = function(optionsettings, children, api)
	    
	end,
	TargetsButton = function(optionsettings, children, api)
	    
	end,
	TextBox = function(optionsettings, children, api)
		local optionapi = {
			Type = 'TextBox',
			Value = optionsettings.Default or '',
			Index = 0
		}
		local textbox = Instance.new('TextLabel', children['ScrollingFrame'])
		textbox.FontFace = uipallet.FontHelvetica
		textbox.BackgroundTransparency = 1
		textbox.Size = UDim2.fromScale(1, 0.065)
		textbox.TextScaled = true
		textbox.TextColor3 = uipallet.TextDark
		textbox.Text = optionsettings.Name
		textbox.TextXAlignment = Enum.TextXAlignment.Left
		textbox.ZIndex = 3
		textbox.Visible = (optionsettings.Visible ~= nil and optionsettings.Visible or true) or false

		local underscore = Instance.new('Frame', textbox)
		underscore.BorderSizePixel = 0
		underscore.BackgroundColor3 = Color3.fromRGB(162, 162, 162)
		underscore.BackgroundTransparency = 0.5
		underscore.Position = UDim2.fromScale(0.719, 1)
		underscore.Size = UDim2.fromOffset(123, 2)
		underscore.ZIndex = 3
		
		local box = Instance.new('TextBox', underscore)
		box.BackgroundTransparency = 1
		box.Position = UDim2.fromScale(-0.049, -11.302)
		box.Size = UDim2.fromOffset(123, 19)
		box.FontFace = uipallet.FontHelvetica
		box.ClearTextOnFocus = false
		box.TextScaled = true
		box.Text = 'None'
		box.TextColor3 = Color3.fromRGB(15, 15, 15)
		box.ZIndex = 3
		
		optionapi.Object = textbox
		
		function optionapi:Save(tab)
			tab[optionsettings.Name] = {Value = self.Value}
		end
		
		function optionapi:Load(tab)
			if self.Value ~= tab.Value then
				self:SetValue(tab.Value)
			end
		end
		
		optionsettings.Function = optionsettings.Function or function() end
		function optionapi:SetValue(val, enter)
			self.Value = val
			box.Text = val
			optionsettings.Function(val, enter)
		end
		
		box.Focused:Connect(function()
			underscore.BackgroundTransparency = 0
			box.TextColor3 = Color3.fromRGB(15, 15, 15)
			box:CaptureFocus()
		end)
		box.FocusLost:Connect(function(enter)
			optionapi:SetValue(box.Text, enter)
			box.TextColor3 = Color3.fromRGB(25, 25, 25)
			underscore.BackgroundTransparency = 0.5
		end)
		box:GetPropertyChangedSignal('Text'):Connect(function()
			optionapi:SetValue(box.Text)
		end)

		if optionapi.Value ~= '' then
			optionapi:SetValue(optionapi.Value)
		end

		return optionapi
	end,
	TextList = function(optionsettings, children, api)

	end,
	Toggle = function(optionsettings, children, api)
		local optionapi = {
			Type = 'Toggle',
			Enabled = false,
			Index = getTableSize(api.Options)
		}
		local toggle = Instance.new('TextLabel', children['ScrollingFrame'])
		toggle.FontFace = uipallet.FontHelvetica
		toggle.BackgroundTransparency = 1
		toggle.Size = UDim2.fromScale(1, 0.065)
		toggle.TextScaled = true
		toggle.TextColor3 = uipallet.TextDark
		toggle.Text = optionsettings.Name
		toggle.TextXAlignment = Enum.TextXAlignment.Left
		toggle.ZIndex = 3
		toggle.Visible = (optionsettings.Visible ~= nil and optionsettings.Visible or true) or false

		local button = Instance.new('ImageButton', toggle)
		button.AutoButtonColor = false
		button.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
		button.Position = UDim2.fromScale(0.937, 0)
		button.BorderSizePixel = 0
		button.Size = UDim2.fromScale(0.055, 0.055)
		button.HoverImage = ''
		button.Image = getcustomasset('catrewrite/assets/sigma/check.png')
		button.ImageTransparency = 1
		button.ImageColor3 = Color3.new(1, 1, 1)
		button.SizeConstraint = Enum.SizeConstraint.RelativeXX
		button.ZIndex = 3

		addCorner(button, UDim.new(250, 100))
		
		optionapi.Object = toggle

		function optionapi:Save(tab)
			tab[optionsettings.Name] = {Enabled = self.Enabled}
		end
		
		function optionapi:Load(tab)
			if self.Enabled ~= tab.Enabled then
				self:Toggle()
			end
		end

		optionsettings.Function = optionsettings.Function or function() end
		function optionapi:Toggle()
			self.Enabled = not self.Enabled
			tween:Tween(button, TweenInfo.new(0.01), {
				ImageTransparency = self.Enabled and 0 or 1,
				BackgroundColor3 = self.Enabled and uipallet.MainColor or Color3.fromRGB(230, 230, 230)
			})
			task.spawn(optionsettings.Function, self.Enabled)
		end

		button.MouseButton1Click:Connect(function()
			optionapi:Toggle()
		end)

		button.MouseEnter:Connect(function()
			tween:Tween(button, uipallet.Tween1, {
				BackgroundTransparency = 0.3
			})
		end)
		button.MouseLeave:Connect(function()
			tween:Tween(button, uipallet.Tween1, {
				BackgroundTransparency = 0
			})
		end)

		return optionapi
	end,
	TwoSlider = function(optionsettings, children, api)
	    
	end,
	Divider = function(children, text)
	    
	end
}

mainapi.Components = setmetatable(components, {
	__newindex = function(self, ind, func)
		for _, v in mainapi.Modules do
			rawset(v, 'Create'..ind, function(_, settings)
				return func(settings, v.Children, v)
			end)
		end

		if mainapi.Legit then
			for _, v in mainapi.Legit.Modules do
				rawset(v, 'Create'..ind, function(_, settings)
					return func(settings, v.Children, v)
				end)
			end
		end

		rawset(self, ind, func)
	end
})

addMaid(mainapi)

notifications.ChildRemoved:Connect(function()
	for i,v in notifications:GetChildren() do
		
	end	
end)
function mainapi:CreateNotification(...)
	local args = {...} 
	local notifs = #notifications:GetChildren() + 1
	local frame = Instance.new('Frame', notifications)
	frame.BackgroundTransparency = 0.15
	frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	frame.Position = UDim2.fromScale(0.773, 0.926 - (0.079 * (notifs == 1 and 0 or notifs)))
	frame.Size = UDim2.fromOffset(338, 62)
	addBlur(frame)

	local stroke = Instance.new('UIStroke', frame)
	stroke.LineJoinMode = Enum.LineJoinMode.Miter
	stroke.Thickness = 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 
	stroke.LineJoinMode = Enum.LineJoinMode.Miter
	stroke.Color = Color3.fromRGB(32, 32, 32)

	local icon2 = args[4]
	if not icon2 then
		icon2 = 'info'
	end
	local icon = Instance.new('ImageLabel', frame)
	icon.BackgroundTransparency = 1
	icon.Position = UDim2.fromScale(-0.008, 0.04)
	icon.Size = UDim2.fromOffset(57, 57)
	icon.Image = getcustomasset(`catrewrite/assets/sigma/{icon2}.png`)

	local label = Instance.new('TextLabel', frame)
	label.BackgroundTransparency = 1
	label.Position = UDim2.fromScale(0.211, 0.196)
	label.Size = UDim2.fromOffset(200, 21)
	label.FontFace = uipallet.FontHelvetica
	label.TextScaled = true
	label.TextTransparency = 0.07
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = args[1]
	label.TextColor3 = uipallet.TextLight

	local desc = label:Clone()
	desc.Parent = frame
	desc.Text = args[2] or args[1]
	desc.Position = UDim2.fromScale(0.208, 0.552)
	desc.Size = UDim2.fromOffset(200, 18)

	task.delay(args[3] or 2, function()
		frame:Remove()
	end)

end

mainapi:CreateNotification('Sigma', 'ur black sorry', 3, 'info')

local categories = 0
function mainapi:CreateGUI()
    local categoryapi = {
		Type = 'MainWindow',
		Buttons = {},
		Options = {}
	}
	
	local autosize = math.max(gui.AbsoluteSize.X / 1920, 0.68)
	hud = Instance.new("Frame", gui)
	hud.Size = UDim2.fromScale(1 / autosize, 1 / autosize)
	hud.Position = UDim2.fromOffset(0, 0)
	hud.Name = "ScaledHUD"
	hud.BackgroundTransparency = 1
	hud.BorderSizePixel = 0
	hud.Active = false
	hud.InputBegan:Connect(function(inputType)
		if inputType.UserInputType == Enum.UserInputType.Touch and hud.BackgroundTransparency ~= 1 then
			hud.BackgroundTransparency = 1
			for i, v in mainapi.Options do
				v.Visible = false
			end
		end
	end)
	local watermark = Instance.new("ImageLabel", hud)
	watermark.Size = UDim2.new(0, 170, 0, 104)
	watermark.Position = UDim2.fromOffset(0, 60)
	watermark.BorderSizePixel = 0
	watermark.BackgroundTransparency = 1
	watermark.Image = getcustomasset("catrewrite/assets/sigma/watermark.png")
	categoryapi.Object = hud
	
	function categoryapi:CreateButton()
        
	end
    
	function categoryapi:CreateDivider(text)
		return components.Divider(children, text)
	end
	
	function categoryapi:CreateOverlayBar()
        
	end
    
    function categoryapi:CreateSettingsDivider()
        return components.Divider(settingschildren)
    end
    
    function categoryapi:CreateSettingsPane()
        
    end
    
    function categoryapi:CreateGUISlider()
        
    end
    return categoryapi
end

function mainapi:CreateCategory(categorysettings)
	local categoryapi = {
		Type = 'Category',
		Expanded = false
	}
	
	local function calculatePosition(layout)
		local x, y = 0, 0
        if layout < 5 then
            x = 210 * categories
			y = 90
		elseif layout >= 5 then
			x = 210 * (categories - 4)
			y = 420
        end
        return x, y
	end
	
    local window = Instance.new("Frame", clickgui)
	window.Name = categorysettings.Name.."Category"
	window.Position = UDim2.fromOffset(calculatePosition(categorysettings.Layout or categories))
	window.BackgroundColor3 = uipallet.Main
	window.Size = UDim2.fromOffset(200, 60)
	window.BackgroundTransparency = 0.07
	window.BorderSizePixel = 0
	makeDraggable(window)
	local windowname = Instance.new("TextLabel", window)
	windowname.Position = UDim2.new(0.091, 2, 0.238, 2)
	windowname.Size = UDim2.fromOffset(150, 30)
	windowname.FontFace = uipallet.FontHelvetica
	windowname.Text = categorysettings.Name
	windowname.BackgroundTransparency = 1
	windowname.TextScaled = true
	windowname.TextSize = 30
	windowname.TextColor3 = Color3.fromRGB(160, 160, 160)
	windowname.TextXAlignment = "Left"
	local moduleholder = Instance.new("ScrollingFrame", window)
	moduleholder.Name = "ModuleHolder"
	moduleholder.BackgroundColor3 = uipallet.Main
	moduleholder.Position = UDim2.fromScale(0, 1)
	moduleholder.Size = UDim2.new(1, 0, 0, 260)
	moduleholder.BorderSizePixel = 0
	moduleholder.BottomImage = ""
	moduleholder.AutomaticCanvasSize = Enum.AutomaticSize.Y
	moduleholder.ScrollingDirection = "Y"
	moduleholder.ScrollBarThickness = 0
	local layout = Instance.new("UIListLayout", moduleholder)
	categoryapi.Object = window
	--[[local shadow = moduleholder:Clone()
	shadow:ClearAllChildren()
	shadow.Size = UDim2.new(1, 0, 0, 320)
	shadow.Active = false
	shadow.BackgroundTransparency = 1
	shadow.Parent = window
	shadow.Position = UDim2.fromScale(0, 0)
	addBlur(shadow)]]

	addMaid(categoryapi)
	categoryapi:Clean(window:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
		local transparency = window.BackgroundTransparency - 0.1
		windowname.TextTransparency = transparency
		moduleholder.BackgroundTransparency = transparency
	end))
	mainapi.Categories[categorysettings.RealName or categorysettings.Name] = categoryapi
	
	function categoryapi:CreateModule(modulesettings)
		task.spawn(pcall, function()
			mainapi:Remove(modulesettings.Name)
		end)
		local moduleapi = {
			Enabled = false,
			Options = {},
			Bind = {},
			Index = getTableSize(mainapi.Modules),
			ExtraText = modulesettings.ExtraText,
			Name = modulesettings.Name,
			Connections = {},
			Category = categorysettings.Name
		}
		
		local modulebutton = Instance.new("TextButton", moduleholder)
		modulebutton.Size = UDim2.fromOffset(200, 30)
		modulebutton.Position = UDim2.fromScale(0, 0)
		modulebutton.BorderSizePixel = 0
		modulebutton.BackgroundColor3 = uipallet.Main
		modulebutton.Text = ""
		modulebutton.Name = modulesettings.Name
		modulebutton.AutoButtonColor = false
		local modulename = Instance.new("TextLabel", modulebutton)
		modulename.Size = UDim2.fromScale(0.884, 0.8)
		modulename.Position = UDim2.new(0.091, 2, 0.15, 0)
		modulename.FontFace = uipallet.FontHelvetica
		modulename.Text = modulesettings.Name
		modulename.BackgroundTransparency = 1
		modulename.TextScaled = true
		modulename.TextColor3 = uipallet.TextDark
		modulename.TextXAlignment = 'Left'
		
		local hovershadow = modulebutton:Clone()
		hovershadow.Name = modulebutton.Name.."Shadow"
		hovershadow.Size = UDim2.fromScale(1, 1)
		hovershadow.Position = UDim2.fromScale(0, 0)
		hovershadow.BackgroundColor3 = Color3.new(0, 0, 0)
		hovershadow.BackgroundTransparency = 1
		hovershadow.Parent = modulebutton
		hovershadow.Active = false
		hovershadow.Visible = false

		local moduleoptions = Instance.new('Frame', moduleinfos)
		moduleoptions.BackgroundColor3 = uipallet.Main
		moduleoptions.Name = modulesettings.Name
		moduleoptions.Size = UDim2.fromOffset(500 * 1.2, 600 * 1.2)
		moduleoptions.Position = UDim2.fromScale(0.335, 0.161)
		moduleoptions.Visible = false
		moduleoptions.ZIndex = 3
		mainapi.Options[moduleoptions] = moduleoptions

		moduleapi.Children = moduleoptions

		addCorner(moduleoptions, UDim.new(0, 16))

		local optionslabel = Instance.new('TextLabel', moduleoptions)
		optionslabel.BackgroundTransparency = 1
		optionslabel.Position = UDim2.fromScale(-0.001, -0.039)
		optionslabel.Size = UDim2.fromScale(1.023, -0.067)
		optionslabel.TextColor3 = uipallet.Main
		optionslabel.FontFace = uipallet.FontBold
		optionslabel.Text = modulesettings.Name
		optionslabel.TextScaled = true
		optionslabel.ZIndex = 3
		optionslabel.TextXAlignment = Enum.TextXAlignment.Left

		local moduleToolTip = Instance.new('TextLabel', moduleoptions)
		moduleToolTip.BackgroundTransparency = 1
		moduleToolTip.Position = UDim2.fromScale(0.046, 0.046)
		moduleToolTip.Size = UDim2.fromScale(0.879, 0.037)
		moduleToolTip.TextColor3 = Color3.fromRGB(91, 91, 91)
		moduleToolTip.TextScaled = true
		moduleToolTip.TextXAlignment = Enum.TextXAlignment.Left
		moduleToolTip.FontFace = uipallet.FontHelvetica
		moduleToolTip.ZIndex = 3
		moduleToolTip.Text = modulesettings.Tooltip or 'No tooltip'

		local optionsholder = Instance.new('ScrollingFrame', moduleoptions)
		optionsholder.BackgroundTransparency = 1
		optionsholder.Position = UDim2.fromScale(0.046, 0.139)
		optionsholder.Size = UDim2.fromScale(0.912, 0.709)
		optionsholder.ScrollBarThickness = 0
		optionsholder.BorderSizePixel = 0
		optionsholder.AutomaticCanvasSize = Enum.AutomaticSize.Y
		optionsholder.ScrollingDirection = Enum.ScrollingDirection.Y
		optionsholder.ZIndex = 3

		local layout = Instance.new('UIListLayout', optionsholder)
		layout.VerticalAlignment = Enum.VerticalAlignment.Top
		layout.Padding = UDim.new(0, 10)

		addMaid(moduleapi)
		
		moduleapi:Clean(moduleholder:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
			local transparency = moduleholder.BackgroundTransparency
			modulename.TextTransparency = transparency
			modulebutton.BackgroundTransparency = transparency
		end))
		
		function moduleapi:SetBind(tab)
			if tab.Mobile then
			    createMobileButton(moduleapi, Vector2.new(tab.X, tab.Y))
				return
			end

			mainapi.Bind = table.clone(tab)
		end
		
		local hovered = false
		function moduleapi:Toggle(multiple)
			if mainapi.ThreadFix then
				setthreadidentity(8)
			end
			mainapi.Enabled = not mainapi.Enabled
			hovershadow.BackgroundColor3 = mainapi.Enabled and uipallet.MainColor or uipallet.TextDark
			modulename.TextColor3 = mainapi.Enabled and uipallet.TextLight or uipallet.TextDark
			modulebutton.BackgroundColor3 = mainapi.Enabled and uipallet.MainColor or uipallet.Main
			modulename.Position = mainapi.Enabled and UDim2.new(0.091, 10, 0.15, 0) or UDim2.new(0.091, 2, 0.15, 0)
			hovershadow.TextLabel.TextColor3 = modulename.TextColor3
			hovershadow.TextLabel.Position = modulename.Position
			if not mainapi.Enabled then
				for _, v in mainapi.Connections do
					pcall(function()
						v:Disconnect()
					end)
				end
				table.clear(mainapi.Connections)
			end
			if not multiple then
				--mainapi:UpdateTextGUI()
			end
			task.spawn(modulesettings.Function, mainapi.Enabled)
		end
		modulebutton.MouseEnter:Connect(function()
			hovered = true
			tween:Tween(hovershadow, uipallet.Tween1, {
				BackgroundTransparency = 0.9,
			})
		end)
		modulebutton.MouseLeave:Connect(function()
			hovered = false
			tween:Tween(hovershadow, uipallet.Tween1, {
				BackgroundTransparency = 1
			})
		end)
		modulebutton.MouseButton1Click:Connect(function()
			moduleapi:Toggle()
		end)
		modulebutton.MouseButton2Click:Connect(function()
			local visible = not moduleoptions.Visible
			if visible then
				moduleoptions.Visible = true
				tweenService:Create(hud, TweenInfo.new(0.15), {
					BackgroundTransparency = 0.5
				}):Play()
				hud.BackgroundColor3 = Color3.new(0,0,0)
				tweenService:Create(moduleoptions, TweenInfo.new(0.15), {
					Size = UDim2.fromOffset(500, 600),
					BackgroundTransparency = 0
				}):Play()
			else
				hud.BackgroundTransparency = 1
				moduleoptions.BackgroundTransparency = 1
				moduleoptions.Visible = false
			end
		end)

		for i, v in components do
			moduleapi['Create'..i] = function(_, optionsettings)
				return v(optionsettings, moduleapi.Children, moduleapi)
			end
		end
		
		if inputService.TouchEnabled then
            local optionbutton = Instance.new("TextButton", modulebutton)
            optionbutton.Size = UDim2.fromScale(0.09, 0.09)
            optionbutton.Position = UDim2.fromScale(0.85, 0.3)
            optionbutton.BackgroundColor3 = Color3.new(0,0,0)
            optionbutton.BackgroundTransparency = 0.9
            optionbutton.Text = ""
            optionbutton.SizeConstraint = "RelativeXX"
            addCorner(optionbutton, UDim.new(0, 500))
            
            optionbutton.MouseButton1Click:Connect(function()
                local visible = not moduleoptions.Visible
				if visible then
					moduleoptions.Visible = true
					tweenService:Create(hud, TweenInfo.new(0.15), {
						BackgroundTransparency = 0.5
					}):Play()
					hud.BackgroundColor3 = Color3.new(0,0,0)
					tweenService:Create(moduleoptions, TweenInfo.new(0.15), {
						Size = UDim2.fromOffset(500, 600),
						BackgroundTransparency = 0
					}):Play()
				else
					hud.BackgroundTransparency = 1
					moduleoptions.BackgroundTransparency = 1
					moduleoptions.Visible = false
				end
            end)
            
			local heldbutton = false
			modulebutton.MouseButton1Down:Connect(function()
				heldbutton = true
				local holdtime, holdpos = tick(), inputService:GetMouseLocation()
				repeat
					heldbutton = (inputService:GetMouseLocation() - holdpos).Magnitude < 3
					task.wait()
				until (tick() - holdtime) > 1 or not heldbutton or not clickgui.Visible
				if heldbutton and clickgui.Visible then
					if mainapi.ThreadFix then
						setthreadidentity(8)
					end
					clickgui.Visible = mainapi.Visible
					if guiTween1 then
						guiTween1:Cancel()
					end
					mainapi.Visible = not mainapi.Visible
					guiTween1 = tweenService:Create(scale, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
						Scale = mainapi.Visible and math.max(gui.AbsoluteSize.X / 1920, 0.68) or 0
					})
					guiTween1:Play()
					if guiTween2 then
						guiTween2:Cancel()
					end
					guiTween2 = tweenService:Create(clickgui, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
						Position = mainapi.Visible and UDim2.fromScale(0, 0) or UDim2.fromScale(0.5, 0.5)
					})
					guiTween2:Play()
					for _, mobileButton in mainapi.Modules do
						if mobileButton.Bind.Button then
							mobileButton.Bind.Button.Visible = true
						end
					end

					local touchconnection
					touchconnection = inputService.InputBegan:Connect(function(inputType)
						if inputType.UserInputType == Enum.UserInputType.Touch then
							if mainapi.ThreadFix then
								setthreadidentity(8)
							end
							clickgui.Visible = mainapi.Visible
							if guiTween1 then
								guiTween1:Cancel()
							end
							mainapi.Visible = not mainapi.Visible
							guiTween1 = tweenService:Create(scale, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
								Scale = mainapi.Visible and math.max(gui.AbsoluteSize.X / 1920, 0.68) or 0
							})
							guiTween1:Play()
							for _, mobileButton in mainapi.Modules do
								if mobileButton.Bind.Button then
									mobileButton.Bind.Button.Visible = false
								end
							end
							touchconnection:Disconnect()
						end
					end)
				end
			end)
			modulebutton.MouseButton1Up:Connect(function()
				heldbutton = false
			end)
		end
		
		mainapi.Modules[modulesettings.Name] = moduleapi
		return moduleapi
	end
	
	categories += 1
	return categoryapi
end
function mainapi:CreateLegit()
	local legitapi = {Modules = {}}

	function legitapi:CreateModule(modulesettings)
		modulesettings.Function = modulesettings.Function or function() end
		local module
		module = mainapi.Categories.Render:CreateModule({
			Name = modulesettings.Name,
			Function = function(callback)
				if module.Children then
					module.Children.Visible = callback
				end
				task.spawn(modulesettings.Function, callback)
			end,
			Tooltip = modulesettings.Tooltip
		})
		table.insert(legitapi.Modules, module)
		table.insert(mainapi.Legit.Modules, module)
		--[[if modulesettings.Size then
			local modulechildren = Instance.new('Frame')
			modulechildren.Size = modulesettings.Size
			modulechildren.BackgroundTransparency = 1
			modulechildren.Visible = false
			modulechildren.Parent = scaledgui
			makeDraggable(modulechildren, clickgui)
			module.Children = modulechildren
		end]]

		return module
	end

	return legitapi
end

function mainapi:Load(skipgui, profile)
	local guidata = {}
	local savecheck = true

	if isfile('catrewrite/profiles/'..game.GameId..'.gui.txt') then
		guidata = loadJson('catrewrite/profiles/'..game.GameId..'.gui.txt')
		if not guidata then
			guidata = {Categories = {}}
			mainapi:CreateNotification('Vape', 'Failed to load GUI settings.', 10, 'alert')
			savecheck = false
		end

		if not skipgui then
			mainapi.Keybind = guidata.Keybind
			for i, v in guidata.Categories do
				local object = mainapi.Categories[i]
				if not object or object.Type ~= 'Overlay' and object.Type ~= 'CategoryTheme' then continue end
				if v.Theme then
					object:SetTheme(v.Theme)
				end
				if v.Position then
					object.Children.Position = UDim2.fromOffset(v.Position.X, v.Position.Y)
				end
			end
		end
	end

	mainapi.Profile = profile or guidata.Profile or 'default'
	mainapi.Profiles = guidata.Profiles or {{
		Name = 'default',
		Bind = {}
	}}
	--mainapi.Categories.Profiles:ChangeValue()

	if isfile('catrewrite/profiles/'..mainapi.Profile..mainapi.Place..'.txt') then
		local savedata = loadJson('catrewrite/profiles/'..mainapi.Profile..mainapi.Place..'.txt')
		if not savedata then
			savedata = {
				Categories = {},
				Modules = {},
				Legit = {}
			}
			mainapi:CreateNotification('Vape', 'Failed to load '..mainapi.Profile..' profile.', 10, 'alert')
			savecheck = false
		end

		for i, v in savedata.Modules do
			local object = mainapi.Modules[i]
			if not object then continue end
			if object.Options and v.Options then
				mainapi:LoadOptions(object, v.Options)
			end
			if v.Enabled ~= object.Enabled then
				if skipgui then
					if mainapi.ToggleNotifications.Enabled then
						mainapi:CreateNotification('Toggled', 'Toggled '..i..' '..(v.Enabled and 'on' or 'off'), 1)
					end
				end
				object:Toggle(true)
			end
			object:SetBind(v.Bind)
		end

		for i, v in savedata.Legit do
			local object = mainapi.Legit.Modules[i]
			if not object then continue end
			if object.Options and v.Options then
				mainapi:LoadOptions(object, v.Options)
			end
			if object.Enabled ~= v.Enabled then
				object:Toggle()
			end
			if v.Position and object.Children then
				object.Children.Position = UDim2.fromOffset(v.Position.X, v.Position.Y)
			end
		end

		--mainapi:UpdateTextGUI(true)
	else
		mainapi:Save()
	end

	--[[if mainapi.Downloader then
		mainapi.Downloader:Destroy()
		mainapi.Downloader = nil
	end]]
	mainapi.Loaded = savecheck
	if inputService.TouchEnabled and #mainapi.Keybind == 1 and mainapi.Keybind[1] == 'RightShift' then
		local button = Instance.new('TextButton')
		button.Size = UDim2.fromOffset(32, 32)
		button.Position = UDim2.new(1, -90, 0, 4)
		button.BackgroundColor3 = Color3.new()
		button.BackgroundTransparency = 0.5
		button.Text = ''
		button.Parent = gui
		local image = Instance.new('ImageLabel')
		image.Size = UDim2.fromOffset(26, 26)
		image.Position = UDim2.fromOffset(3, 3)
		image.BackgroundTransparency = 1
		image.Image = getcustomasset('catrewrite/assets/sigma/logo.png')
		image.Parent = button
		local buttoncorner = Instance.new('UICorner')
		buttoncorner.Parent = button
		mainapi.VapeButton = button
		button.MouseButton1Click:Connect(function()
			if mainapi.ThreadFix then
				setthreadidentity(8)
			end
			for _, mobileButton in mainapi.Modules do
				if mobileButton.Bind.Button then
					mobileButton.Bind.Button.Visible = mainapi.Visible
				end
			end
			clickgui.Visible = mainapi.Visible
			mainapi.Visible = not mainapi.Visible
			focused = mainapi.Visible
			--mainapi:ChangeFocus(mainapi.Visible and true or false)
			if guiTween1 then
				guiTween1:Cancel()
			end
			guiTween1 = tweenService:Create(scale, uipallet.Tween1, {
				Scale = focused and math.max(gui.AbsoluteSize.X / 1920, 0.68) or math.max(gui.AbsoluteSize.X / 1920, 0.68) + 0.2
			})
			guiTween1:Play()
			if guiTween2 then
				guiTween2:Cancel()
			end
			guiTween2 = tweenService:Create(clickgui, uipallet.Tween1, {
				Position = focused and UDim2.fromScale(0, 0) or UDim2.fromScale(-0.2, -0.2)
			})
			guiTween2:Play()
			for i, v in mainapi.Categories do
				if v.Tween then
					v.Tween:Cancel()
				end
				if v.Object then
					v.Tween = tweenService:Create(v.Object, uipallet.Tween1, {
						BackgroundTransparency = focused and 0.1 or 1.1
					})
					v.Tween:Play()
				end
			end
			if mainapi.Visible then
				clickgui.Visible = mainapi.Visible
			else
				guiTween1.Completed:Connect(function()
					clickgui.Visible = mainapi.Visible
				end)
			end
			--tooltip.Visible = false
			--mainapi:BlurCheck()
		end)
	end
end

function mainapi:LoadOptions(object, savedoptions)
	for i, v in savedoptions do
		local option = object.Options[i]
		if not option then continue end
		option:Load(v)
	end
end

function mainapi:Remove(obj)
	local tab = (mainapi.Modules[obj] and mainapi.Modules or mainapi.Legit.Modules[obj] and mainapi.Legit.Modules or mainapi.Categories)
	if tab and tab[obj] then
		local newobj = tab[obj]
		for _, v in {'Object', 'Children', 'Toggle', 'Button'} do
			local childobj = typeof(newobj[v]) == 'table' and newobj[v].Object or newobj[v]
			if typeof(childobj) == 'Instance' then
				childobj:Destroy()
				childobj:ClearAllChildren()
			end
		end
		loopClean(newobj)
		tab[obj] = nil
	end
end

function mainapi:Save(newprofile)
	if not mainapi.Loaded then return end
	local guidata = {
		Categories = {},
		Profile = newprofile or mainapi.Profile,
		Profiles = mainapi.Profiles,
		Keybind = mainapi.Keybind
	}
	local savedata = {
		Modules = {},
		Categories = {},
		Legit = {}
	}

	for i, v in mainapi.Categories do
		if v.Type ~= 'Overlay' and v.Type ~= 'CategoryTheme' then continue end
		guidata.Categories[i] = {
			Position = v.Children and {X = v.Children.Position.X.Offset, Y = v.Children.Position.Y.Offset} or nil,
			Theme = v.Theme
		}
	end

	for i, v in mainapi.Modules do
		savedata.Modules[i] = {
			Enabled = v.Enabled,
			Bind = v.Bind.Button and {Mobile = true, X = v.Bind.Button.Position.X.Offset, Y = v.Bind.Button.Position.Y.Offset} or v.Bind,
			Options = mainapi:SaveOptions(v, true)
		}
	end

	for i, v in mainapi.Legit.Modules do
		savedata.Legit[i] = {
			Enabled = v.Enabled,
			Position = v.Children and {X = v.Children.Position.X.Offset, Y = v.Children.Position.Y.Offset} or nil,
			Options = mainapi:SaveOptions(v, v.Options)
		}
	end

	writefile('catrewrite/profiles/'..game.GameId..'.gui.txt', httpService:JSONEncode(guidata))
	writefile('catrewrite/profiles/'..mainapi.Profile..mainapi.Place..'.txt', httpService:JSONEncode(savedata))
end

function mainapi:SaveOptions(object, savedoptions)
	if not savedoptions then return end
	savedoptions = {}
	for _, v in object.Options do
		if not v.Save then continue end
		v:Save(savedoptions)
	end
	return savedoptions
end

function mainapi:Uninject()
	mainapi:Save()
	mainapi.Loaded = nil
	for _, v in mainapi.Modules do
		if v.Enabled then
			v:Toggle()
		end
		v.Button = nil
		v.Options = {}
	end
	for _, v in mainapi.Legit.Modules do
		if v.Enabled then
			v:Toggle()
		end
	end
	for _, v in mainapi.Categories do
		if v.Type == 'Overlay' and v.Button.Enabled then
			v.Button:Toggle()
		end
	end
	for _, v in mainapi.Connections do
		pcall(function()
			v:Disconnect()
		end)
	end
	if mainapi.ThreadFix then
		setthreadidentity(8)
		clickgui.Visible = false
	end
	mainapi.gui:ClearAllChildren()
	mainapi.gui:Destroy()
	table.clear(mainapi.Libraries)
	loopClean(mainapi)
	shared.vape = nil
	shared.vapereload = nil
	shared.VapeIndependent = nil
end

gui = Instance.new('ScreenGui')
gui.Name = randomString()
gui.DisplayOrder = 9999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.IgnoreGuiInset = true
gui.OnTopOfCoreBlur = true
gui.Parent = gethui()
gui.ResetOnSpawn = false
mainapi.gui = gui
scaledgui = Instance.new('Frame')
scaledgui.Name = 'ScaledGui'
scaledgui.Size = UDim2.fromScale(1, 1)
scaledgui.BackgroundTransparency = 1
scaledgui.Parent = gui
clickgui = Instance.new('Frame')
clickgui.Name = 'ClickGui'
clickgui.Size = UDim2.fromScale(1, 1)
clickgui.BackgroundTransparency = 1
clickgui.Visible = false
clickgui.Parent = scaledgui
notifications.Parent = scaledgui
moduleinfos = Instance.new('Folder', scaledgui)
local modal = Instance.new('TextButton')
modal.BackgroundTransparency = 1
modal.Modal = true
modal.Text = ''
modal.Parent = clickgui
scale = Instance.new('UIScale')
scale.Scale = math.max(gui.AbsoluteSize.X / 1920, 0.68)
scale.Parent = scaledgui
mainapi.guiscale = scale
scaledgui.Size = UDim2.fromScale(1 / scale.Scale, 1 / scale.Scale)
clickgui.Size = UDim2.fromScale(0, 0)

mainapi:Clean(scale:GetPropertyChangedSignal('Scale'):Connect(function()
	scaledgui.Size = UDim2.fromScale(1 / scale.Scale, 1 / scale.Scale)
	hud.Size = UDim2.fromScale(1 / scale.Scale, 1 / scale.Scale)
	for _, v in scaledgui:GetDescendants() do
		if v:IsA('GuiObject') and v.Visible then
			v.Visible = false
			v.Visible = true
		end
	end
	for _, v in hud:GetDescendants() do
		if v:IsA('GuiObject') and v.Visible then
			v.Visible = false
			v.Visible = true
		end
	end
end))

mainapi:CreateGUI()
mainapi.Legit = mainapi:CreateLegit()
mainapi:CreateCategory({
	Name = "Gui",
	Layout = 1
})
mainapi:CreateCategory({
    Name = "Combat",
    Layout = 2,
	RealName = 'Combat'
})
mainapi:CreateCategory({
    Name = "Render",
    Layout = 3,
	RealName = 'Render'
})
mainapi:CreateCategory({
    Name = "World",
    Layout = 4,
	RealName = 'World'
})
mainapi:CreateCategory({
    Name = "Misc",
    RealName = "Minigames",
    Layout = 5
})
mainapi:CreateCategory({
    Name = "Player",
    RealName = "Utility",
    Layout = 6
})
mainapi:CreateCategory({
    Name = "Item",
    RealName = "Inventory",
    Layout = 7
})
mainapi:CreateCategory({
    Name = "Movement",
    RealName = "Blatant",
    Layou5 = 8
})
mainapi.Categories["Legit"] = mainapi.Categories.Minigames
mainapi["Legit"] = mainapi.Categories.Minigames
mainapi["Legit"].Modules = {}

mainapi:Clean(inputService.InputBegan:Connect(function(inputObj)
	if not inputService:GetFocusedTextBox() and inputObj.KeyCode ~= Enum.KeyCode.Unknown then
		table.insert(mainapi.HeldKeybinds, inputObj.KeyCode.Name)
		--if mainapi.Binding then return end

		if checkKeybinds(mainapi.HeldKeybinds, mainapi.Keybind, inputObj.KeyCode.Name) then
			if mainapi.ThreadFix then
				setthreadidentity(8)
			end
			for _, v in mainapi.Windows do
				v.Visible = false
			end
			for i,v in mainapi.Options do
				v.Visible = false
			end
			clickgui.Visible = not clickgui.Visible
			--mainapi:BlurCheck()
		end
	end
end))

mainapi.Categories.Friends = {
	Options = {
		['Use friends'] = {Enabled = false}
	},
	Update = Instance.new('BindableEvent')
}

mainapi.Categories.Targets = {
	ListEnabled = {},
	Update = Instance.new('BindableEvent')
}

mainapi.Categories.Main = {
	Options = {
		['Teams by server'] = {
			Enabled = false
		},
		['GUI bind indicator'] = {
			Enabled = true
		}
	}
}

function mainapi:CreateOverlay() end
mainapi.Legit = mainapi.Categories.Render
mainapi.Legit.Modules = {}

(function()
    local positions = {
        A = UDim2.fromScale(-0.001, 0.338),
        S = UDim2.fromScale(0.339, 0.34),
        D = UDim2.fromScale(0.679, 0.338),
        L = UDim2.fromScale(-0.002, 0.683),
        R = UDim2.fromScale(0.507, 0.683)
    }
end)()

return mainapi