local mainapi = {
    Connections = {},
	Categories = {},
	GUIColor = {Hue = 0.46, Sat = 0.96, Value = 0.52},
	Keybind = Enum.KeyCode.RightShift,
	Loaded = false,
	Libraries = {},
	Modules = {},
	Notifications = {Enabled = true},
	Place = game.PlaceId,
	Profile = 'default',
	Profiles = {},
	RainbowSpeed = {Value = 1},
	RainbowUpdateSpeed = {Value = 60},
	RainbowTable = {},
	Scale = {Value = 1},
	ToggleNotifications = {Enabled = true},
	ThreadFix = setthreadidentity and true or false,
	Version = '1.1.7a2',
	Windows = {}
};

local cloneref = cloneref or function(obj) return obj end
local tweenService = cloneref(game:GetService('TweenService'))
local inputService = cloneref(game:GetService('UserInputService'))
local textService = cloneref(game:GetService('TextService'))
local guiService = cloneref(game:GetService('GuiService'))
local runService = cloneref(game:GetService('RunService'))
local httpService = cloneref(game:GetService('HttpService'))

local fontsize = Instance.new('GetTextBoundsParams')
fontsize.Width = math.huge
local notifications
local getcustomasset
local clickgui
local expanded
local moduleholder
local scaledgui
local toolblur
local tooltip
local scale
local gui

local color = {}
local tween = {tweens = {}, tweenstwo = {}}
local uipallet = {
	Main = Color3.fromRGB(64, 64, 64),
	Text = Color3.new(1, 1, 1),
}

local function makeDraggable(gui, window)
	gui.InputBegan:Connect(function(inputObj)
		if window and not window.Visible then return end
		if (inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch) and (inputObj.Position.Y - gui.AbsolutePosition.Y < 40 or window) then
			local dragPosition = Vector2.new(gui.AbsolutePosition.X - inputObj.Position.X, gui.AbsolutePosition.Y - inputObj.Position.Y + guiService:GetGuiInset().Y) / scale.Scale
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
					if changed then changed:Disconnect() end
					if ended then ended:Disconnect() end
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

gui = Instance.new('ScreenGui')
gui.Name = randomString()
gui.DisplayOrder = 9999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
gui.IgnoreGuiInset = true
gui.OnTopOfCoreBlur = true
if mainapi.ThreadFix then
	gui.Parent = (gethui and gethui()) or cloneref(game:GetService('CoreGui'))
else
	gui.Parent = cloneref(game:GetService('Players')).LocalPlayer.PlayerGui
	gui.ResetOnSpawn = false
end
mainapi.gui = gui
scaledgui = Instance.new('Frame')
scaledgui.Name = 'ScaledGui'
scaledgui.Size = UDim2.fromScale(1, 1)
scaledgui.BackgroundTransparency = 1
scaledgui.Parent = gui
clickgui = Instance.new('TextButton')
clickgui.Name = 'ClickGui'
clickgui.Size = UDim2.fromScale(1, 1)
clickgui.BackgroundTransparency = 1
clickgui.Text = ''
clickgui.Visible = false
clickgui.Parent = scaledgui

local components = {};

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

function mainapi:CreateGUI()
    local categoryapi = {
		Type = 'MainWindow',
		Buttons = {},
		Options = {}
	}

    return categoryapi
end

task.spawn(function()
	repeat
		local hue = tick() * (0.2 * mainapi.RainbowSpeed.Value) % 1
		for _, v in mainapi.RainbowTable do
			if v.Type == 'GUISlider' then
				v:SetValue(mainapi:Color(hue))
			else
				v:SetValue(hue)
			end
		end
		task.wait(1 / mainapi.RainbowUpdateSpeed.Value)
	until mainapi.Loaded == nil
end)

function mainapi:CreateNotification() end
function mainapi:UpdateTextGUI() end
function mainapi:UpdateGUI() end
function mainapi:Save() end
function mainapi:Load() 
    
    mainapi.Loaded = true
end

function mainapi:Clean(obj)
	if typeof(obj) == 'Instance' then
		table.insert(self.Connections, {Disconnect = function()
			obj:ClearAllChildren()
			obj:Destroy()
		end})
		return
	elseif type(obj) == 'function' then
		table.insert(self.Connections, {Disconnect = obj})
		return
	end
	table.insert(self.Connections, obj)
end

mainapi.Legit = mainapi

return mainapi;