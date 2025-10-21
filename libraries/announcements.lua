local Announcements = {}

local cloneref = cloneref or function(ref) return ref end
local gethui = gethui or function() return game:GetService('Players').LocalPlayer.PlayerGui end

local ScreenGui = Instance.new("ScreenGui", gethui())
ScreenGui.Name = "glob"
local MainArea = Instance.new("Frame", ScreenGui)
MainArea.BackgroundTransparency = 1
MainArea.Interactable = false
MainArea.Size = UDim2.fromScale(1, 1)
local Holder = Instance.new("Frame", MainArea)
Holder.BackgroundTransparency = 1
Holder.Interactable = false
Holder.Size = UDim2.fromScale(0.8, 0.8)
Holder.Position = UDim2.fromScale(0.5, 0.45)
Holder.AnchorPoint = Vector2.new(0.5, 0.5)
Instance.new("UIListLayout", Holder).Padding = UDim.new(0, 5)

local TweenService = cloneref(game:GetService("TweenService"))
function Announcements:Announce(user: string, msg: string, duration: number, color: Color3)
    task.spawn(function()
        local announcement = Instance.new("TextLabel", Holder)
        announcement.Size = UDim2.fromScale(1, 0.085)
        announcement.BackgroundColor3 = Color3.new(0, 0, 0)
        announcement.BackgroundTransparency = 1
        Instance.new("UICorner", announcement)
        
        announcement.FontFace = Font.fromEnum(Enum.Font.Arimo)
        announcement.RichText = true
        announcement.TextScaled = true
        announcement.TextTransparency = 1
        announcement.TextColor3 = Color3.new(1, 1, 1)
        announcement.Text = string.format("<font color='rgb(%d,%d,%d)'>"..user.."</font>: "..msg, color.R * 255, color.G * 255, color.B * 255)
        
        local tween = TweenService:Create(announcement, TweenInfo.new(0.3), {
            BackgroundTransparency = 0.6,
            TextTransparency = 0
        })
        tween:Play()
        tween.Completed:Wait()
        task.wait(duration)
        
        tween = TweenService:Create(announcement, TweenInfo.new(0.3), {
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
warn("global announcements loaded")
