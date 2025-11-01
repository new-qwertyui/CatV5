local Announcements = {}
local cloneref = cloneref or function(ref) return ref end
local gethui = gethui or function() return game:GetService('Players').LocalPlayer.PlayerGui end

local ScreenGui = Instance.new("ScreenGui", gethui())
ScreenGui.Name = "glob"
ScreenGui.IgnoreGuiInset = true

local MainArea = Instance.new("Frame", ScreenGui)
MainArea.BackgroundTransparency = 1
MainArea.Interactable = false
MainArea.Size = UDim2.fromScale(1, 1)

local Holder = Instance.new("Frame", MainArea)
Holder.BackgroundTransparency = 1
Holder.Interactable = false
Holder.AnchorPoint = Vector2.new(0.5, 0.5)
Holder.Position = UDim2.fromScale(0.5, 0.43)
Holder.Size = UDim2.fromScale(0.8, 0.6)
local layout = Instance.new("UIListLayout", Holder)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

local TweenService = cloneref(game:GetService("TweenService"))
local Camera = workspace.CurrentCamera
local ViewportSize = Camera.ViewportSize
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	ViewportSize = Camera.ViewportSize
end)

local textChatService = cloneref(game:GetService("TextChatService"))
local starterGui = cloneref(game:GetService("StarterGui"))

function Announcements:Announce(user: string, msg: string, duration: number, color: Color3)
	task.spawn(function()
	    if shared.vape and shared.vape.Announce and not shared.vape.Announce.Enabled then
	        if textChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
        		starterGui:SetCore("ChatMakeSystemMessage", {
        			Text = string.format("<font color='rgb(%d,%d,%d)'>[CATVAPE] %s:</font> %s", color.R * 255, color.G * 255, color.B * 255, user, msg),
        			Color = Color3.fromRGB(255,255,255),
        			Font = Enum.Font.SourceSansBold,
        			TextSize = 18
        		})
        	else
        		local chatChannel = textChatService:WaitForChild("TextChannels"):WaitForChild("RBXGeneral")
        		chatChannel:DisplaySystemMessage(string.format("<font color='rgb(%d,%d,%d)'>[CATVAPE] %s:</font> %s", color.R * 255, color.G * 255, color.B * 255, user, msg))
        	end
	        return
	    end
		local announcement = Instance.new("TextLabel", Holder)
		announcement.AutomaticSize = Enum.AutomaticSize.Y
		announcement.BackgroundColor3 = Color3.new(0, 0, 0)
		announcement.BackgroundTransparency = 1
		announcement.FontFace = Font.fromEnum(Enum.Font.GothamSemibold)
		announcement.RichText = true
		announcement.TextWrapped = true
		announcement.TextTransparency = 1
		announcement.TextColor3 = Color3.new(1, 1, 1)
		announcement.Text = string.format("<font color='rgb(%d,%d,%d)'>%s:</font> %s", color.R * 255, color.G * 255, color.B * 255, user, msg)
		local baseScale = math.clamp(ViewportSize.Y / 800, 0.6, 1.4)
		announcement.Size = UDim2.new(1, 0, 0, 50 * baseScale)
		local textConstraint = Instance.new("UITextSizeConstraint", announcement)
		textConstraint.MaxTextSize = math.floor(50 * baseScale)
		textConstraint.MinTextSize = math.floor(30 * baseScale)
		announcement.TextScaled = false
		local corner = Instance.new("UICorner", announcement)
		corner.CornerRadius = UDim.new(0, 10)
		--[[local stroke = Instance.new("UIStroke", announcement)
		stroke.Thickness = 1
		stroke.Transparency = 0.4
		stroke.Color = Color3.new(1, 1, 1)]]

		local tween = TweenService:Create(announcement, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.6,
			TextTransparency = 0
		})
		tween:Play()
		tween.Completed:Wait()
		task.wait(duration)
		tween = TweenService:Create(announcement, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			BackgroundTransparency = 1,
			TextTransparency = 1
		})
		tween:Play()
		tween.Completed:Wait()
		announcement:Destroy()
	end)
end

local HttpService = cloneref(game:GetService("HttpService"))
local ran = isfile("catrewrite/ran") and HttpService:JSONDecode(readfile("catrewrite/ran")) or {}
task.spawn(function()
	repeat
		task.wait(1)
		if not shared.vape then
			Announcements.Announce = nil
			Announcements = nil
			ScreenGui:ClearAllChildren()
			ScreenGui:Destroy()
			return
		end
		local suc, data = pcall(function()
			return game:HttpGet("https://gitea.com/qwertyui-is-back/CatV5/raw/branch/main/Announcement")
		end)
		if suc then
			local suc2, Announcement = pcall(function()
				return HttpService:JSONDecode(data)
			end)
			if suc2 then
				if Announcement.Tick > os.time() and not ran[Announcement.ID] then
					ran[Announcement.ID] = true
					writefile("catrewrite/ran", HttpService:JSONEncode(ran))
					local color = Announcement.Color
					Announcements:Announce(Announcement.User, Announcement.Message, Announcement.Tick - os.time(), Color3.fromRGB(color.R, color.G, color.B))
				end
			end
		end
	until not shared.vape
end)
