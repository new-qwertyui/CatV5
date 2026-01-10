loadstring([[
    function LPH_NO_VIRTUALIZE(f) return f end;
]])();
--
if not game:IsLoaded() then
    game.Loaded:Wait()
end
--
if Library and Library.Unload then
    Library:Unload()
end
--
local cloneref = cloneref or function(...) return ... end
--
local Workspace = cloneref(game:GetService("Workspace"))
local HttpService = cloneref(game:GetService("HttpService"))
local Debris = cloneref(game:GetService("Debris"))
local Players = cloneref(game:GetService("Players"))
local TweenService = cloneref(game:GetService("TweenService"))
local CollectionService = cloneref(game:GetService("CollectionService"))
local RunService = cloneref(game:GetService("RunService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local TeleportService = cloneref(game:GetService("TeleportService"))
local Lighting = cloneref(game:GetService("Lighting"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Stats = cloneref(game:GetService("Stats"))
local GuiService = cloneref(game:GetService("GuiService"))
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
local ContextActionService = cloneref(game:GetService("ContextActionService"))
--
local Client = Players.LocalPlayer
local Camera = Workspace:FindFirstChildWhichIsA("Camera")
local Viewport = Camera.ViewportSize
--
do -- Folders
    if not isfolder("gamesense") then
        makefolder("gamesense")
    end
    --
    if not isfolder("gamesense/configs") then
        makefolder("gamesense/configs")
    end
end
--
do -- Library
    getgenv().Library = {
        Connections = {},
        Errors = {},
        Tweens = {},
        Objects = {},
        Sections = {},
        ThemeSections = {},
        Flags = {},
        UnnamedFlags = 0,
        Build = "Beta",
        UID = "1",
        UnsafeMode = false,
        InitTime = os.clock(),
        Folder = "gamesense",
        ConfigFolder = "gamesense/configs",
        UI = {
            Name = "gamesense",
            CloseBind = Enum.KeyCode.Insert,
            SectionResizeIncrements = 1,
            WatermarkRefreshRate = 1,
            MainUI = nil,
            Initialized = false,
            OnInitialized = nil,
            Faded = false,
            LastCopiedColor = nil,
            TabIndex = 0,
            Viewing = false,
            CurrentSelectedColorPicker = nil,
            CurrentSelectedColorPickerExtra = nil,
            CurrentSelectedKeybindMode = nil,
            TotalColorPickers = 0,
            TotalKeybindModes = 0,
            WatermarkPosition = "Top Right",
            SectionZIndex = 100,
            Resizing = false,
            DropdownZIndex = 1,
            OpenColorFrames = 0,
            ScreenGUI = nil,
            TweenSpeed = 0.15,
            NewFont = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            FontSize = 13,
            DraggingGui = nil,
            Notifications = {TopLeft = {}, Middle = {}},
            Keys = {
                [Enum.KeyCode.LeftShift] = "LSHF",
                [Enum.KeyCode.RightShift] = "RSHF",
                [Enum.KeyCode.LeftControl] = "LCTR",
                [Enum.KeyCode.RightControl] = "RCTR",
                [Enum.KeyCode.LeftAlt] = "LALT",
                [Enum.KeyCode.RightAlt] = "RALT",
                [Enum.KeyCode.CapsLock] = "CAPS",
                [Enum.KeyCode.Space] = "SPCE",
                [Enum.KeyCode.One] = "ONE",
                [Enum.KeyCode.Two] = "TWO",
                [Enum.KeyCode.Three] = "THREE",
                [Enum.KeyCode.Four] = "FOUR",
                [Enum.KeyCode.Five] = "FIVE",
                [Enum.KeyCode.Six] = "SIX",
                [Enum.KeyCode.Seven] = "SEVEN",
                [Enum.KeyCode.Eight] = "EIGHT",
                [Enum.KeyCode.Nine] = "NINE",
                [Enum.KeyCode.Zero] = "ZERO",
                [Enum.KeyCode.KeypadOne] = "NUM1",
                [Enum.KeyCode.KeypadTwo] = "NUM2",
                [Enum.KeyCode.KeypadThree] = "NUM3",
                [Enum.KeyCode.KeypadFour] = "NUM4",
                [Enum.KeyCode.KeypadFive] = "NUM5",
                [Enum.KeyCode.KeypadSix] = "NUM6",
                [Enum.KeyCode.KeypadSeven] = "NUM7",
                [Enum.KeyCode.KeypadEight] = "NUM8",
                [Enum.KeyCode.KeypadNine] = "NUM9",
                [Enum.KeyCode.KeypadZero] = "NUM0",
                [Enum.KeyCode.Insert] = "INS",
                [Enum.KeyCode.Minus] = "-",
                [Enum.KeyCode.Equals] = "=",
                [Enum.KeyCode.Tilde] = "~",
                [Enum.KeyCode.LeftBracket] = "[",
                [Enum.KeyCode.RightBracket] = "]",
                [Enum.KeyCode.RightParenthesis] = ")",
                [Enum.KeyCode.LeftParenthesis] = "(",
                [Enum.KeyCode.Semicolon] = ",",
                [Enum.KeyCode.Quote] = "'",
                [Enum.KeyCode.BackSlash] = "\\",
                [Enum.KeyCode.Comma] = ",",
                [Enum.KeyCode.Period] = ".",
                [Enum.KeyCode.Slash] = "/",
                [Enum.KeyCode.Asterisk] = "*",
                [Enum.KeyCode.Plus] = "+",
                [Enum.KeyCode.Backquote] = "`",
                [Enum.UserInputType.MouseButton1] = "M1",
                [Enum.UserInputType.MouseButton2] = "M2",
                [Enum.UserInputType.MouseButton3] = "M3"
            },
        },
        Theme = {
            Objects = {},
            Default = {
                Accent = Color3.fromRGB(153, 196, 39),
                SecondAccent = Color3.fromRGB(124, 158, 32),
                TextColor = Color3.fromRGB(205, 205, 205),
                Risky = Color3.fromRGB(165, 165, 120),
            }
        }
    }
    --
    function Library:Validate(Defaults, Options)
        for Index, Value in Defaults do
            if Options[Index] == nil then
                Options[Index] = Value
            end
        end
        --
        return Options
    end
    --
    function Library:Connection(Signal, Func, Name, Table)
        Name = Name or "Unknown"
        Table = Table or Library.Connections
        --
        local Connection; Connection = Signal:Connect(function(...)
            local Args = {...}
            --
            local Success, Message = pcall(function() coroutine.wrap(Func)(unpack(Args)) end)
            --
            if not Success and not Library.Errors[Message] then
                if Library.Notify then
                    Library:Notify({Message = ("[ERROR] | An error has occurred:\n%s\nName: %s"):format(Message, Name), Delay = math.huge})
                else
                    warn(("[ERROR] | An error has occurred:\n%s\nName: %s"):format(Message, Name))
                end
                --
                Library.Errors[Message] = Message
                --
                if Table[Connection] then
                    Table[Connection] = nil
                end
                --
                return Connection and Connection:Disconnect()
            end
        end)
        --
        if Connection and Table then
            table.insert(Table, Connection)
        end
        --
        return Connection
    end
    --
    function Library:TweenObject(Object, Info, Goal, Callback)
        if not Object then 
            return 
        end
        --
        local Tween = TweenService:Create(Object, Info, Goal)
        --
        Library:Connection(Tween.Completed, Callback or function() end)
        --
        Tween:Play()
        --
        Library.Tweens[#Library.Tweens + 1] = Tween
    end
    --
    function Library:NewFlag()
        Library.UnnamedFlags += 1
        --
        return ("UnknownFlag%s"):format(tostring(Library.UnnamedFlags))
    end
    --
    function Library:ClampString(String, MaxWidth)
        local Clamped = String
        --
        local TextLabel = Library:CreateObject("TextLabel", {
            FontFace = Library.UI.NewFont,
            TextStrokeTransparency = 0,
            Text = String,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextScaled = false,
            TextWrapped = false,
            Visible = false,
            TextSize = Library.UI.FontSize,
            Parent = Client.PlayerGui
        })
        --
        if TextLabel.TextBounds.X <= MaxWidth then
            TextLabel:Destroy()
            --
            return String
        end
        --
        while TextLabel.TextBounds.X > MaxWidth and #Clamped > 0 do
            Clamped = Clamped:sub(1, #Clamped - 1)
            --
            TextLabel.Text = Clamped .. "..."
            --
            task.wait()
        end
        --
        TextLabel:Destroy()
        --
        return Clamped .. "..."
    end
    --
    function Library:GetConfig()
        local Config = {}
        --
        for Index, Value in Library.Flags do
            if Value.Get and not string.find(Index, "_Status") then
                if typeof(Value:Get()) == "table" and Value:Get().Color and Value:Get().Transparency then
                    local Transparency = Value:Get().Transparency
                    local Hue, Saturation, Value = Value:Get().Color:ToHSV()
                    --
                    Config[Index] = {Hue, Saturation, Value, Transparency}
                else
                    Config[Index] = Value:Get()
                end
            end
        end
        --
        return HttpService:JSONEncode(Config)
    end
    --
    function Library:LoadConfig(Config)
        local Config = HttpService:JSONDecode(Config)
        --
        for i,v in Config do 
            if Library.Flags[i] and Library.Flags[i].Set then
                task.spawn(function()
                    Library.Flags[i]:Set(v)
                end)
            end
        end
    end
    --
    function Library:SectionDragging(Frame)
        local MousePosition = UserInputService:GetMouseLocation()
        local Position = Frame.AbsolutePosition
        local Size = Frame.AbsoluteSize
        --
        local InsideX = MousePosition.X >= Position.X and MousePosition.X <= Position.X + Size.X
        local InsideY = MousePosition.Y >= Position.Y and MousePosition.Y <= Position.Y + Size.Y
        --
        return InsideX and InsideY
    end
    --
    function Library:CreateObject(Type, Properties, Hidden)
        local Hidden = Hidden or false
        local Object = Instance.new(Type)
        --
        for Index, Value in Properties do
            if (not RunService:IsStudio()) and Index == "Name" and not string.match(Value, "%d") then
                Value = "\0"
            end
            --
            if Index == "TextStrokeTransparency" and Value == 0 then
                local Stroke = Instance.new("UIStroke")
                --
                Stroke.Parent = Object
                Stroke.LineJoinMode = Enum.LineJoinMode.Miter
                --
                Library.Objects[Stroke] = {Stroke, {Parent = Object, LineJoinMode = Enum.LineJoinMode.Miter}, Hidden}
            else
                Object[Index] = Value
            end
        end
        --
        Library.Objects[Object] = {Object, Properties, Hidden}
        --
        return Object
    end
    --
    function Library:AddTheme(Object, Properties)
        for Index, Value in Properties do
            Library.Theme.Objects[Object] = Library.Theme.Objects[Object] or {}
            Library.Theme.Objects[Object][Index] = Value
        end
    end
    --
    function Library:GetTableIndexes(Table, Custom)
        local Table2 = {}
        --
        for Index, Value in Table do
            Table2[Custom and Value[1] or #Table2 + 1] = Index 
        end
        --
        return Table2
    end
    --
    function Library:UpdateConfigList(List, Type)
        for _, File in listfiles("gamesense/configs") do
            local FileName = File:gsub("\\", "/"):gsub("gamesense/configs/", ""):gsub(".cfg", "")
            --
            if Type == "Remove" then
                List:RemoveValue(FileName)
            else
                List:AddValue(FileName)
            end
        end
    end
    --
    function Library:GetObjectsTable(MainUI, AddMain, Ignored)
        local AddMain = AddMain or false
        local Ignored = Ignored or {}
        local DescendantTable = {}
        local NewTable = {}
        --
        for _, Descendant in MainUI:GetDescendants() do
            if table.find(Ignored, Descendant) then continue end
            --
            DescendantTable[#DescendantTable + 1] = Descendant
        end
        --
        if AddMain then
            DescendantTable[#DescendantTable + 1] = MainUI
        end
        --
        for _, Descendant in DescendantTable do
            local Found = Library.Objects[Descendant]
            --
            if Found then
                local Properties = Found[2]
                local HiddenValue = Found[3]
                --
                NewTable[#NewTable + 1] = {Descendant, Properties, HiddenValue}
            end
        end
        --
        return NewTable
    end
    --
    function Library:SetTableVisible(Table, State, Ignored)
        local Ignored = Ignored or {}
        --
        for _, Object in Table do
            if table.find(Ignored, Object) then continue end
            --
            if typeof(Object) == "table" and Object.SetVisible then 
                Object:SetVisible(State)
            end
        end
    end
    --
    function Library:UpdateColor(ColorType, ColorValue)
        Library.Theme.Default[ColorType] = ColorValue
        --
        for Object, Properties in Library.Theme.Objects do
            for Property, ThemeKeys in Properties do
                if typeof(ThemeKeys) == "table" then
                    if Object:IsA("UIGradient") and Property == "Color" then
                        if Library.Theme.Default[ThemeKeys[1]] then
                            Object.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Library.Theme.Default[ThemeKeys[1]]), ColorSequenceKeypoint.new(1, Library.Theme.Default[ThemeKeys[2]])}
                        end
                    end
                else
                    if ThemeKeys == ColorType then
                        Object[Property] = Library.Theme.Default[ThemeKeys]
                    end
                end
            end
        end
        --
        if ColorType == "Accent" then
            for _, obj in pairs(Library.UI.ScreenGUI:GetDescendants()) do
                if obj:IsA("TextLabel") and obj.Text:match("^<b>.*</b>$") and obj.TextColor3 ~= ColorValue then

                    local isDropdownItem = false
                    local parent = obj.Parent
                    while parent and not isDropdownItem do
                        if parent.Name == "Dropdown_Items" then
                            isDropdownItem = true
                        end
                        parent = parent.Parent
                    end
                    
                    if isDropdownItem then
                        Library:TweenObject(obj, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = ColorValue})
                    end
                end
            end
        end
    end
    --
    function Library:ViewPlayer(Player)
        if not Library.UI.Viewing then
            Camera.CameraSubject = Player.Character.Humanoid
        else
            Camera.CameraSubject = Client.Character.Humanoid
        end
        --
        Library.UI.Viewing = not Library.UI.Viewing
    end
    --
    function Library:GetTableLength(Table)
        local Length = 0
        --
        for Index, Value in pairs(Table) do
            Length += 1
        end
        --
        return Length
    end
    --
    function Library:ScrollingCheck(ScrollingFrame, Frame)
        if not ScrollingFrame:IsA("ScrollingFrame") then return true end
        --
        local VisibleTopLeft = ScrollingFrame.CanvasPosition
        local VisibleBottomRight = VisibleTopLeft + ScrollingFrame.AbsoluteWindowSize
        --
        local FrameTopLeft = Frame.AbsolutePosition - ScrollingFrame.AbsolutePosition + ScrollingFrame.CanvasPosition
        local FrameBottomRight = FrameTopLeft + Frame.AbsoluteSize
        --
        return FrameBottomRight.X > VisibleTopLeft.X and FrameTopLeft.X < VisibleBottomRight.X and FrameBottomRight.Y > VisibleTopLeft.Y and FrameTopLeft.Y < VisibleBottomRight.Y
    end
    --
    function Library:ClampPosition(Object, Position, Offset)
        local ClampedX = math.clamp(Position.X.Offset, Offset, Viewport.X - Object.AbsoluteSize.X - Offset)
        local ClampedY = math.clamp(Position.Y.Offset, Offset, Viewport.Y - Object.AbsoluteSize.Y - Offset)
        --
        return UDim2.new(Position.X.Scale, ClampedX, Position.Y.Scale, ClampedY)
    end
    --
    function Library:Fade(State, Table, MainUI, Speed)
        local IsMainUI = Table == Library.Objects
        --
        MainUI.Active = State
        --
        if State then
            MainUI.Visible = true
        end
        --
        if IsMainUI then
            Library.UI.Faded = not State
        end
        --  handle toggle transparency when fading out since im not using fade out for now as it causes fps issues
        if not State and IsMainUI then
            -- find all toggle elements and force them transparent immediately instead of waiting since some things may not leave instantly
            for _, obj in pairs(MainUI:GetDescendants()) do
                if obj.ClassName == "Frame" then
                    if obj.Name == "ToggleMain" then
                        obj.BackgroundTransparency = 1
                    end
                end
            end
        end
        --
        for _, Object in Table do
            if not Object[3] then
                if Object[1].ClassName == "Frame" and (Object[2]["BackgroundTransparency"] or 0) ~= 1 then
                    -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1})
                    Object[1].BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1
                elseif Object[1].ClassName == "ImageLabel" or Object[1].ClassName == "ImageButton" then
                    if (Object[2]["BackgroundTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1})
                        Object[1].BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1
                    end
                    --
                    if (Object[2]["ImageTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {ImageTransparency = State and (Object[2]["ImageTransparency"] or 0) or 1})
                        Object[1].ImageTransparency = State and (Object[2]["ImageTransparency"] or 0) or 1
                    end
                elseif Object[1].ClassName == "TextLabel" or Object[1].ClassName == "TextButton" or Object[1].ClassName == "TextBox" then
                    if (Object[2]["BackgroundTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1})
                        Object[1].BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1
                    end
                    --
                    if (Object[2]["TextTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {TextTransparency = State and (Object[2]["TextTransparency"] or 0) or 1})
                        Object[1].TextTransparency = State and (Object[2]["TextTransparency"] or 0) or 1
                    end
                elseif Object[1].ClassName == "ScrollingFrame" then
                    if (Object[2]["BackgroundTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1})
                        Object[1].BackgroundTransparency = State and (Object[2]["BackgroundTransparency"] or 0) or 1
                    end
                    --
                    if (Object[2]["ScrollBarImageTransparency"] or 0) ~= 1 then
                        -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {ScrollBarImageTransparency = State and (Object[2]["ScrollBarImageTransparency"] or 0) or 1})
                        Object[1].ScrollBarImageTransparency = State and (Object[2]["ScrollBarImageTransparency"] or 0) or 1
                    end
                elseif Object[1].ClassName == "UIStroke" then
                    -- Library:TweenObject(Object[1], TweenInfo.new(Speed, Enum.EasingStyle.Linear, State and Enum.EasingDirection["Out"] or Enum.EasingDirection["In"]), {Transparency = State and (Object[2]["Transparency"] or 0) or 1})
                    Object[1].Transparency = State and (Object[2]["Transparency"] or 0) or 1
                end
            end
        end
        --
        if not State then
            task.delay(Speed, function()
                if not MainUI.Parent then return end
                MainUI.Visible = false
            end)
        end
    end
    --
    function Library:CheckFrameFirst(FrameA, FrameB)
        local Parent = FrameA.Parent
        local Frames = {}
        local IndexA, IndexB
        --
        for _, Child in Parent:GetChildren() do
            if Child:IsA("Frame") then
                table.insert(Frames, Child)
            end
        end
        --
        table.sort(Frames, function(a, b)
            if a.LayoutOrder == b.LayoutOrder then
                for _, Child in Parent:GetChildren() do
                    if Child == a then return true end
                    if Child == b then return false end
                end
            end
            --
            return a.LayoutOrder < b.LayoutOrder
        end)
        --
        for i, Frame in Frames do
            if Frame == FrameA then IndexA = i end
            if Frame == FrameB then IndexB = i end
        end
        --
        return IndexA and IndexB and IndexA < IndexB
    end
    --
    function Library:Resizable(Object, DragFrame, MinResize, MaxResize, Increments, UseIcon, UseParent, Delay)
        local StartingSize, ObjectSize, Dragging, MouseLocation, PerformanceDragUI, NewMouse, Hovering
        --
        local function UpdateSize()
            if not MouseLocation then return end
            --
            Library.UI.Resizing = true
            --
            local CurrentMousePosition = UserInputService:GetMouseLocation()
            local Delta = CurrentMousePosition - MouseLocation
            local NewSizeX = StartingSize.X.Offset + Delta.X
            local NewSizeY = StartingSize.Y.Offset + Delta.Y
            local Parent = Object.Parent
            local ParentSize = Parent.AbsoluteSize
            --
            if UseParent then
                local OccupiedSpaceY = 0
                local FrameCount = 0
                --
                for _, Child in Parent:GetChildren() do
                    if Child:IsA("Frame") and Child ~= Object then
                        FrameCount += 1
                        --
                        if Library:CheckFrameFirst(Object, Child) then
                            if Child.AbsoluteSize.Y >= (ParentSize.Y - Object.AbsoluteSize.Y) - 57 then
                                Child.Size = UDim2.new(Child.Size.X.Scale, Child.Size.X.Offset, 0, math.max(50, (ParentSize.Y - Object.AbsoluteSize.Y) - 57))
                            end
                        else
                            OccupiedSpaceY += Child.AbsoluteSize.Y + 19
                        end
                    end
                end
                --
                if OccupiedSpaceY == 0 then
                    MaxResize = UDim2.new(0, 0, 0, (ParentSize.Y - OccupiedSpaceY) - (FrameCount * (50 + 19)) - 38)
                else
                    MaxResize = UDim2.new(0, 0, 0, (ParentSize.Y - OccupiedSpaceY) - 38)
                end
            end
            --
            if Increments then
                NewSizeY = math.clamp(math.round(NewSizeY / Increments) * Increments, MinResize.Y.Offset, MaxResize.Y.Offset)
            else
                NewSizeY = math.clamp(NewSizeY, MinResize.Y.Offset, MaxResize.Y.Offset)
                NewSizeX = math.clamp(NewSizeX, MinResize.X.Offset, MaxResize.X.Offset)
            end
            --
            return UseParent and UDim2.new(1, 0, 0, NewSizeY) or UDim2.new(0, NewSizeX, 0, NewSizeY)
        end
        
        --
        Library:Connection(DragFrame.MouseEnter, function()
            Hovering = true
        end)
        --
        Library:Connection(DragFrame.MouseLeave, function()
            if NewMouse then NewMouse:Destroy() NewMouse = nil end
            --
            UserInputService.MouseIconEnabled = true
            Hovering = false
        end)
        --
        Library:Connection(DragFrame.InputBegan, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                MouseLocation = UserInputService:GetMouseLocation()
                StartingSize = Object.Size
            end
        end)
        --
        Library:Connection(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseMovement then
                if (Hovering or Dragging) and UseIcon then
                    local MousePosition = UserInputService:GetMouseLocation()
                    --
                    UserInputService.MouseIconEnabled = false
                    --
                    if not NewMouse then
                        NewMouse = Library:CreateObject("ImageLabel", {
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            Image = "rbxassetid://87982048533100",
                            BackgroundTransparency = 1,
                            AnchorPoint = Vector2.new(0.5, 0.5),
                            Name = "Transparency",
                            Size = UDim2.new(0, 35, 0, 35),
                            ZIndex = 10000000,
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = Library.UI.ScreenGUI
                        }, true)
                    end
                    --
                    NewMouse.Position = UDim2.new(0, MousePosition.X, 0, MousePosition.Y)
                end
                --
                if Dragging then
                    if Delay then task.delay(Delay, function()
                            Object.Size = UpdateSize()
                        end)
                    else
                        Object.Size = UpdateSize()
                    end
                end
            end
        end))
        --
        Library:Connection(UserInputService.InputEnded, function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 and Dragging then
                if NewMouse then NewMouse:Destroy(); NewMouse = nil end
                --
                if UseParent then
                    for _, Child in Object.Parent:GetChildren() do
                        if Child:IsA("Frame") and Child ~= Object then
                            if Library:CheckFrameFirst(Object, Child) then
                                if Child.AbsoluteSize.Y >= (Object.Parent.AbsoluteSize.Y - Object.AbsoluteSize.Y) - 57 then
                                    Child.Size = UDim2.new(Child.Size.X.Scale, Child.Size.X.Offset, 0, math.max(50, (Object.Parent.AbsoluteSize.Y - Object.AbsoluteSize.Y) - 57))
                                end
                            end
                        end
                    end
                end
                --
                UserInputService.MouseIconEnabled = true
                Dragging = false
                Library.UI.Resizing = false
            end
        end)
    end
    --
    Library.__index = Library
    Library.Sections.__index = Library.Sections
    --
    local Sections = Library.Sections
    --
    function Library:ColorPicker(Options)
        Options = Library:Validate({
            Name = "Preview Color Picker",
            Default = Library.Theme.Default.Accent,
            Alpha = 0,
            AlphaBar = true,
            Parent = nil,
            MainUI = nil,
            TabUI = nil,
            Count = 1,
            Keybind = false,
            Flag = Library:NewFlag(),
            Callback = function() end,
        }, Options or {})
        --
        local Hue, Saturation, Value = Options.Default:ToHSV()
        --
        local ColorPicker = {
            Hover = false,
            Active = false,
            MouseDown = false,
            MainFrameHover = false,
            Color = Options.Default,
            SecondColor = Color3.fromRGB(math.max(math.floor(Options.Default.R * 255) - 14, 0), math.max(math.floor(Options.Default.G * 255) - 14, 0), math.max(math.floor(Options.Default.B * 255) - 14, 0)),
            Saturation = {Saturation, Value},
            Alpha = Options.Alpha,
            Hue = Hue,
            ActiveFrame = false,
            LastCopiedColor = {self.Color, self.Alpha},
            FrameOpened = false,
        }
        --
        Library.Flags[Options.Flag] = ColorPicker
        --
        Library.UI.TotalColorPickers += 1
        --
        if Options.Keybind then
            Options.Count += 1
        end
        --
        local ColorPickerOutline_1 = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            Name = "ColorPickerOutline" .. Library.UI.TotalColorPickers,
            Position = UDim2.new(1, 0 - (Options.Count - 1) * 22, 0, 0),
            Size = UDim2.new(0, 17, 0, 9),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = Options.Parent
        })
        --
        local ColorPickerChecker = Library:CreateObject("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 0, 1, 4),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            Visible = false,
            BorderSizePixel = 0,
            Parent = ColorPickerOutline_1
        })
        --
        local Button_9 = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_9",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ColorPickerOutline_1
        })
        --
        local ColorPickerTransparency = Library:CreateObject("ImageLabel", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Image = "rbxassetid://18249241978",
            ImageColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Name = "Transparency",
            Size = UDim2.new(1, -2, 1, -2),
            Position = UDim2.new(0, 1, 0, 1),
            BorderSizePixel = 0,
            ZIndex = 3,
            ScaleType = Enum.ScaleType.Tile,
            TileSize = UDim2.new(0, 6, 0, 6),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ColorPickerOutline_1
        })
        --
        local ColorPickerInline_1 = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ColorPickerInline_1",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundTransparency = Options.Alpha,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ColorPickerOutline_1
        })
        --
        local UIGradient_24 = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, ColorPicker.Color),
                ColorSequenceKeypoint.new(1, ColorPicker.SecondColor)
            },
            Parent = ColorPickerInline_1
        })
        --
        do -- Functions
            function ColorPicker:SetVisible(Bool)
                ColorPickerOutline_1.Visible = Bool
                --
                if Bool == false then
                    ColorPicker:RemoveFrame()
                end
            end
            --
            function ColorPicker:AddFrame()
                Library.UI.CurrentSelectedColorPicker = {ColorPicker = ColorPicker, ColorPickerOutline = ColorPickerOutline_1, Parent = Options.Parent}
                --
                Library.UI.OpenColorFrames += 1
                --
                local ColorPickerOutline = Library:CreateObject("Frame", {
                    Size = UDim2.new(0, 180, 0, 175),
                    Name = "ColorPickerFrame" .. Library.UI.TotalColorPickers,
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Library.UI.ScreenGUI
                })
                --
                ColorPickerOutline.BackgroundTransparency = 1
                --
                local ColorPickerInline = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "ColorPickerInline",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    Parent = ColorPickerOutline
                })
                --
                ColorPickerInline.BackgroundTransparency = 1
                --
                local ColorPickerMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "ColorPickerMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    Parent = ColorPickerInline
                })
                --
                ColorPickerMain.BackgroundTransparency = 1
                --
                local MainPicker = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -24, 1, -19),
                    Name = "MainPicker",
                    Position = UDim2.new(0, 2, 0, 2),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = ColorPickerMain
                })
                --
                MainPicker.BackgroundTransparency = 1
                --
                local Button_91 = Library:CreateObject("TextButton", {
                    FontFace = Library.UI.NewFont,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_9",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    ZIndex = 250,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = MainPicker
                })
                --
                local MainPickerColor = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "MainPickerColor",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = MainPicker
                })
                --
                MainPickerColor.BackgroundTransparency = 1
                --
                local UIGradient_20 = Library:CreateObject("UIGradient", {
                    Rotation = 180,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 4)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                    },
                    Parent = MainPickerColor
                })
                --
                local BackImage = Library:CreateObject("ImageLabel", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Image = "rbxassetid://13966897785",
                    BackgroundTransparency = 1,
                    Name = "BackImage",
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    Parent = MainPickerColor
                })
                --
                BackImage.ImageTransparency = 1
                --
                local DraggingMainOutline = Library:CreateObject("Frame", {
                    Size = UDim2.new(0, 4, 0, 4),
                    Name = "DraggingMainOutline",
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = MainPicker
                })
                --
                DraggingMainOutline.BackgroundTransparency = 1
                --
                local DraggingMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "DraggingMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = DraggingMainOutline
                })
                --
                DraggingMain.BackgroundTransparency = 1
                --
                local SaturationSlider = Library:CreateObject("Frame", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(0, 1),
                    Name = "SaturationSlider",
                    Position = UDim2.new(0, 2, 1, -2),
                    Size = UDim2.new(1, -24, 0, 12),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = ColorPickerMain
                })
                --
                SaturationSlider.BackgroundTransparency = 1
                --
                local Button_915241 = Library:CreateObject("TextButton", {
                    FontFace = Library.UI.NewFont,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_9",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    ZIndex = 250,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = SaturationSlider
                })
                --
                local SaturationColor = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "SaturationColor",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = SaturationSlider
                })
                --
                SaturationColor.BackgroundTransparency = 1
                --
                local UIGradient_21 = Library:CreateObject("UIGradient", {
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 4)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
                    },
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 0.10000000149011612),
                        NumberSequenceKeypoint.new(0.5, 0.800000011920929),
                        NumberSequenceKeypoint.new(1, 1)
                    },
                    Rotation = 180,
                    Parent = SaturationColor
                })
                --
                local BackImage_1 = Library:CreateObject("ImageLabel", {
                    ScaleType = Enum.ScaleType.Tile,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "BackImage_1",
                    TileSize = UDim2.new(0, 12, 0, 12),
                    Image = "rbxassetid://18249241978",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    Parent = SaturationSlider
                })
                --
                BackImage_1.ImageTransparency = 1
                --
                local DraggingSatOutline = Library:CreateObject("Frame", {
                    Size = UDim2.new(0, 4, 1, 0),
                    Name = "DraggingSatOutline",
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = SaturationSlider
                })
                --
                DraggingSatOutline.BackgroundTransparency = 1
                --
                local DraggingSatMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "DraggingSatMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = DraggingSatOutline
                })
                --
                DraggingSatMain.BackgroundTransparency = 1
                --
                local HueSlider = Library:CreateObject("Frame", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(1, 0),
                    Name = "HueSlider",
                    Position = UDim2.new(1, -2, 0, 2),
                    Size = UDim2.new(0, 17, 1, -19),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = ColorPickerMain
                })
                --
                HueSlider.BackgroundTransparency = 1
                --
                local Button_9141 = Library:CreateObject("TextButton", {
                    FontFace = Library.UI.NewFont,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_9",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    ZIndex = 250,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = HueSlider
                })
                --
                local BackImage_2 = Library:CreateObject("ImageLabel", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "BackImage_2",
                    TileSize = UDim2.new(0, 12, 0, 12),
                    Image = "rbxassetid://8180989234",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(1, -2, 1, -2),
                    ZIndex = 250,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    Parent = HueSlider
                })
                --
                BackImage_2.ImageTransparency = 1
                --
                local DraggingHueOutline = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, 0, 0, 4),
                    Name = "DraggingHueOutline",
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = HueSlider
                })
                --
                DraggingHueOutline.BackgroundTransparency = 1
                --
                local DraggingHueMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "DraggingHueMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 251,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = DraggingHueOutline
                })
                --
                DraggingHueMain.BackgroundTransparency = 1
                --
                do -- Functions
                    function ColorPicker:UpdateSize()
                        ColorPickerOutline.Position = UDim2.new(0, ColorPickerOutline_1.AbsolutePosition.X, 0, (ColorPickerOutline_1.AbsolutePosition.Y + ColorPickerOutline_1.AbsoluteSize.Y + GuiService:GetGuiInset().Y + 2))
                    end
                    --
                    ColorPicker:UpdateSize()
                    --
                    Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsolutePosition"), ColorPicker.UpdateSize)
                    --
                    local StartingY = ColorPickerOutline_1.AbsolutePosition.Y
                    local MainUIStartingY = Options.MainUI.AbsolutePosition.Y
                    local StartingCanvasPosition = Options.Parent.Parent.CanvasPosition
                    --
                    Library:Connection(ColorPickerOutline_1:GetPropertyChangedSignal("AbsolutePosition"), function()
                        local CurrentY = ColorPickerOutline_1.AbsolutePosition.Y
                        local MainUICurrentY = Options.MainUI.AbsolutePosition.Y
                        local CurrentCanvasPosition = Options.Parent.Parent.CanvasPosition
                        --
                        if MainUICurrentY ~= MainUIStartingY then
                            MainUIStartingY = MainUICurrentY
                            StartingY = CurrentY
                            --
                            return
                        end
                        --
                        if CurrentCanvasPosition ~= StartingCanvasPosition then
                            StartingCanvasPosition = CurrentCanvasPosition
                            StartingY = CurrentY
                            --
                            return
                        end
                        --
                        if Library.UI.Resizing then
                            return
                        end
                        --
                        if CurrentY ~= StartingY then
                            ColorPicker:RemoveFrame(true)
                        end
                        --
                        StartingY = CurrentY
                    end)
                    --
                    Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsoluteSize"), function()
                        if ColorPicker.Active then
                            ColorPickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, ColorPickerChecker)
                        end
                        --
                        ColorPicker:UpdateSize()
                    end)
                    --
                    if Options.Parent.Parent:IsA("ScrollingFrame") then
                        Library:Connection(Options.Parent.Parent:GetPropertyChangedSignal("CanvasPosition"), function()
                            ColorPicker:UpdateSize()
                            --
                            if ColorPicker.Active then
                                ColorPickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, ColorPickerChecker)
                            end
                        end)
                    end
                    --
                    Library:Connection(Options.MainUI:GetPropertyChangedSignal("Visible"), function()
                        if not Options.MainUI.Visible then
                            ColorPickerOutline.Visible = false
                        else
                            ColorPickerOutline.Visible = ColorPicker.Active
                        end
                    end)
                    --
                    Library:Connection(Options.Parent.Parent:GetPropertyChangedSignal("Visible"), function()
                        if not Options.Parent.Parent.Visible then
                            ColorPickerOutline.Visible = false
                        else
                            ColorPickerOutline.Visible = ColorPicker.Active
                        end
                    end)
                    --
                    function ColorPicker:Update()
                        ColorPicker.Color = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Saturation[1], ColorPicker.Saturation[2])
                        ColorPicker.SecondColor = Color3.fromRGB(math.max(math.floor(ColorPicker.Color.R * 255) - 40, 0), math.max(math.floor(ColorPicker.Color.G * 255) - 40, 0), math.max(math.floor(ColorPicker.Color.B * 255) - 40, 0))
                        --
                        UIGradient_24.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorPicker.Color), ColorSequenceKeypoint.new(1, ColorPicker.SecondColor)}
                        UIGradient_20.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorPicker.Color), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))}
                        UIGradient_21.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ColorPicker.Color), ColorSequenceKeypoint.new(1, ColorPicker.Color)}
                        UIGradient_20.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.000, Color3.fromHSV(ColorPicker.Hue, 1, 1)), ColorSequenceKeypoint.new(1.000, Color3.fromRGB(255, 255, 255))}
                        --
                        local MaxSaturationX = math.max(0, MainPickerColor.AbsoluteSize.X - DraggingMainOutline.AbsoluteSize.X) / MainPickerColor.AbsoluteSize.X
                        local MaxSaturationY = math.max(0, MainPickerColor.AbsoluteSize.Y - DraggingMainOutline.AbsoluteSize.Y) / MainPickerColor.AbsoluteSize.Y
                        local MaxAlpha = math.max(0, SaturationColor.AbsoluteSize.X - DraggingSatOutline.AbsoluteSize.X) / SaturationColor.AbsoluteSize.X
                        local MaxHue = math.max(0, BackImage_2.AbsoluteSize.Y - DraggingHueOutline.AbsoluteSize.Y) / BackImage_2.AbsoluteSize.Y
                        --
                        Library:TweenObject(DraggingMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.fromScale(math.clamp(ColorPicker.Saturation[1], 0, MaxSaturationX), math.clamp(1 - ColorPicker.Saturation[2], 0, MaxSaturationY))})
                        Library:TweenObject(DraggingSatOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(math.clamp(1 - ColorPicker.Alpha, 0, MaxAlpha), 0, 0, 0)})
                        Library:TweenObject(DraggingHueOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, math.clamp(ColorPicker.Hue, 0, MaxHue), 0)})
                        --
                        DraggingMain.BackgroundColor3 = ColorPicker.Color
                        DraggingSatMain.BackgroundColor3 = ColorPicker.Color
                        DraggingHueMain.BackgroundColor3 = ColorPicker.Color
                        ColorPickerInline_1.BackgroundTransparency = ColorPicker.Alpha
                        UIGradient_21.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0.304 + (0.604 - 0.304) * ColorPicker.Alpha), NumberSequenceKeypoint.new(0.5, 0.7), NumberSequenceKeypoint.new(1, 1)}
                        --
                        Options.Callback(ColorPicker.Color, ColorPicker.Alpha)
                        Library.Flags[Options.Flag] = ColorPicker
                    end
                    --
                    function ColorPicker:Set(Color, Transparency)
                        if typeof(Color) == "table" then
                            ColorPicker.Color = Color3.fromHSV(Color[1], Color[2], Color[3])
                            ColorPicker.Alpha = Color[4]
                            ColorPicker.Hue = Color[1]
                            ColorPicker.Saturation[1] = Color[2]
                            ColorPicker.Saturation[2] = Color[3]
                            ColorPicker:Update()
                            Options.Callback(ColorPicker.Color, ColorPicker.Alpha)
                        elseif typeof(Color) == "Color3" then
                            local h, s, v = Color:ToHSV()
                            --
                            ColorPicker.Color = Color3.fromHSV(h, s, v)
                            ColorPicker.Alpha = Transparency or 1
                            ColorPicker.Hue = h
                            ColorPicker.Saturation[1] = s
                            ColorPicker.Saturation[2] = v
                            ColorPicker:Update()
                            Options.Callback(ColorPicker.Color, ColorPicker.Alpha)
                        end
                    end
                    --
                    function ColorPicker:Get()
                        return {Color = ColorPicker.Color, Transparency = ColorPicker.Alpha}
                    end
                    --
                    function ColorPicker:UpdateHue(Percentage)
                        local Percentage = typeof(Percentage == "number") and math.clamp(Percentage, 0, 1) or 0
                        --
                        ColorPicker.Hue = Percentage
                        --
                        ColorPicker:Update()
                    end
                    --
                    function ColorPicker:UpdateAlpha(Percentage)
                        local Percentage = typeof(Percentage == "number") and math.clamp(Percentage, 0, 1) or 0
                        --
                        ColorPicker.Alpha = Percentage
                        --
                        ColorPicker:Update()
                    end
                    --
                    function ColorPicker:UpdateSaturation(PercentageX, PercentageY)
                        local PercentageX = typeof(PercentageX == "number") and math.clamp(PercentageX, 0, 1) or 0
                        local PercentageY = typeof(PercentageY == "number") and math.clamp(PercentageY, 0, 1) or 0
                        --
                        ColorPicker.Saturation[1] = PercentageX
                        ColorPicker.Saturation[2] = 1 - PercentageY
                        --
                        ColorPicker:Update()
                    end
                end
                --
                do -- Connections
                    Library:Connection(Button_91.InputBegan, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Library.UI.DraggingGui = MainPickerColor
                            --
                            local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
                            local Percentage = (InputPosition - MainPickerColor.AbsolutePosition) / MainPickerColor.AbsoluteSize
                            --
                            ColorPicker:UpdateSaturation(Percentage.X, Percentage.Y)
                        end
                    end)
                    --
                    Library:Connection(Button_915241.InputBegan, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Library.UI.DraggingGui = SaturationColor
                            --
                            local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
                            local GuiPosition = SaturationColor.AbsolutePosition.X
                            local GuiSize = SaturationColor.AbsoluteSize.X
                            local Percentage = ((GuiPosition + GuiSize - InputPosition.X) / GuiSize)
                            --
                            ColorPicker:UpdateAlpha(Percentage)
                        end
                    end)
                    --
                    Library:Connection(Button_9141.InputBegan, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            Library.UI.DraggingGui = BackImage_2
                            --
                            local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
                            local Percentage = (InputPosition - BackImage_2.AbsolutePosition) / BackImage_2.AbsoluteSize
                            --
                            ColorPicker:UpdateHue(Percentage.Y)
                        end
                    end)
                    --
                    Library:Connection(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function(Input)
                        if (Library.UI.DraggingGui ~= SaturationColor and Library.UI.DraggingGui ~= MainPickerColor and Library.UI.DraggingGui ~= BackImage_2) then return end
                        --
                        if not (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
                            Library.UI.DraggingGui = nil
                            return
                        end
                        --
                        local InputPosition = Vector2.new(Input.Position.X, Input.Position.Y)
                        --
                        if (Input.UserInputType == Enum.UserInputType.MouseMovement) then
                            if Library.UI.DraggingGui == MainPickerColor then
                                local Percentage = (InputPosition - MainPickerColor.AbsolutePosition) / MainPickerColor.AbsoluteSize
                                --
                                ColorPicker:UpdateSaturation(Percentage.X, Percentage.Y)
                            end
                            --
                            if Library.UI.DraggingGui == SaturationColor then
                                local GuiPosition = SaturationColor.AbsolutePosition.X
                                local GuiSize = SaturationColor.AbsoluteSize.X
                                local Percentage = ((GuiPosition + GuiSize - InputPosition.X) / GuiSize)
                                --
                                ColorPicker:UpdateAlpha(Percentage)
                            end
                            --
                            if Library.UI.DraggingGui == BackImage_2 then
                                local Percentage = (InputPosition - BackImage_2.AbsolutePosition) / BackImage_2.AbsoluteSize
                                --
                                ColorPicker:UpdateHue(Percentage.Y)
                            end
                        end
                    end))
                end
                --
                ColorPicker:Update()
                Library:Fade(true, Library:GetObjectsTable(ColorPickerOutline, true), ColorPickerOutline, 0.1)
            end
            --
            function ColorPicker:RemoveFrame(Fast)
                local Fast = Fast or false
                --
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "ColorPickerFrame" .. Library.UI.TotalColorPickers then
                        if Fast then
                            Value:Destroy()
                        else
                            Library:Fade(false, Library:GetObjectsTable(Value, true), Value, 0.1)
                            --
                            task.delay(Library.UI.TweenSpeed, function()
                                Value:Destroy()
                            end)
                        end
                    end
                end
            end
            --
            function ColorPicker:FindFrame()
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "ColorPickerFrame" .. Library.UI.TotalColorPickers then
                        return true
                    end
                end
                --
                return false
            end
            --
            function ColorPicker:Toggle()
                if Library.UI.CurrentSelectedColorPicker and Library.UI.CurrentSelectedColorPicker.ColorPickerOutline.Name ~= ColorPickerOutline_1.Name then
                    Library.UI.CurrentSelectedColorPicker.ColorPicker:RemoveFrame()
                end
                --
                if not ColorPicker:FindFrame() then
                    ColorPicker.Active = true
                    ColorPicker:AddFrame()
                else
                    ColorPicker.Active = false
                    ColorPicker:RemoveFrame()
                end
            end
            --
            function ColorPicker:AddOtherFrame()
                Library.UI.CurrentSelectedColorPickerExtra = {ColorPicker = ColorPicker, ColorPickerObject = ColorPickerOutline_1, Parent = Options.Parent}
                --
                local KeybindModePickerOutline = Library:CreateObject("Frame", {
                    Name = "ColorPickerOutline" .. Library.UI.TotalColorPickers,
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0, 100, 0, 55),
                    BorderSizePixel = 0,
                    ZIndex = 25,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Library.UI.ScreenGUI
                })
                --
                local KeybindModePickerMain = Library:CreateObject("Frame", {
                    Name = "KeybindModePickerMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    ZIndex = 25,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = KeybindModePickerOutline
                })
                --
                KeybindModePickerOutline.BackgroundTransparency = 1
                KeybindModePickerMain.BackgroundTransparency = 1
                --
                local UIListLayout_9 = Library:CreateObject("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = KeybindModePickerMain
                })
                --
                function ColorPicker:UpdateSize()
                    KeybindModePickerOutline.Position = UDim2.new(0, ColorPickerOutline_1.AbsolutePosition.X - 2, 0, ColorPickerOutline_1.AbsolutePosition.Y + ColorPickerOutline_1.AbsoluteSize.Y + KeybindModePickerOutline.AbsoluteSize.Y - 4)
                end
                --
                ColorPicker:UpdateSize()
                --
                Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsolutePosition"), ColorPicker.UpdateSize)
                --
                local StartingY = ColorPickerOutline_1.AbsolutePosition.Y
                local MainUIStartingY = Options.MainUI.AbsolutePosition.Y
                local StartingCanvasPosition = Options.Parent.Parent.CanvasPosition
                --
                Library:Connection(ColorPickerOutline_1:GetPropertyChangedSignal("AbsolutePosition"), function()
                    local CurrentY = ColorPickerOutline_1.AbsolutePosition.Y
                    local MainUICurrentY = Options.MainUI.AbsolutePosition.Y
                    local CurrentCanvasPosition = Options.Parent.Parent.CanvasPosition
                    --
                    if MainUICurrentY ~= MainUIStartingY then
                        MainUIStartingY = MainUICurrentY
                        StartingY = CurrentY
                        --
                        return
                    end
                    --
                    if CurrentCanvasPosition ~= StartingCanvasPosition then
                        StartingCanvasPosition = CurrentCanvasPosition
                        StartingY = CurrentY
                        --
                        return
                    end
                    --
                    if Library.UI.Resizing then
                        return
                    end
                    --
                    if CurrentY ~= StartingY then
                        ColorPicker:RemoveOtherFrame(true)
                    end
                    --
                    StartingY = CurrentY
                end)
                --
                Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsoluteSize"), function()
                    if ColorPicker.ActiveFrame then
                        KeybindModePickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, ColorPickerChecker)
                    end
                    --
                    ColorPicker:UpdateSize()
                end)
                --
                if Options.Parent.Parent:IsA("ScrollingFrame") then
                    Library:Connection(Options.Parent.Parent:GetPropertyChangedSignal("CanvasPosition"), function()
                        ColorPicker:UpdateSize()
                        --
                        if ColorPicker.ActiveFrame then
                            KeybindModePickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, ColorPickerChecker)
                        end
                    end)
                end
                --
                for Index, Value in {"Copy", "Paste", "Reset"} do
                    local ModeItem = {
                        Active = false,
                        Hovering = false,
                    }
                    --
                    local Inactive = Library:CreateObject("TextLabel", {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        TextColor3 = Color3.fromRGB(208, 208, 208),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = Value,
                        Text = Value,
                        RichText = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.new(1, 0, 0, 17),
                        BorderSizePixel = 0,
                        TextSize = Library.UI.FontSize,
                        ZIndex = 25,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = KeybindModePickerMain
                    })
                    --
                    local Button_4 = Library:CreateObject("TextButton", {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = "Button_4",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        TextTransparency = 1,
                        TextSize = Library.UI.FontSize,
                        ZIndex = 25,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = Inactive
                    })
                    --
                    local UIPadding_48 = Library:CreateObject("UIPadding", {
                        PaddingLeft = UDim.new(0, 8),
                        Parent = Inactive
                    })
                    --
                    Inactive.TextTransparency = 1
                    --
                    do -- Functions
                        function ModeItem:Activate()
                            if not ModeItem.Active then
                                ModeItem.Active = true
                                --
                                Inactive.Text = "<b>" .. Value .. "</b>"
                                Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Default.Accent})
                                --
                                if Value == "Copy" then
                                    Library.UI.LastCopiedColor = {Color = ColorPicker.Color, Alpha = ColorPicker.Alpha}
                                elseif Value == "Paste" then
                                    if Library.UI.LastCopiedColor then
                                        ColorPicker:Set(Library.UI.LastCopiedColor.Color, Library.UI.LastCopiedColor.Alpha)
                                    end
                                elseif Value == "Reset" then
                                    ColorPicker:Set(Options.Default, Options.Alpha)
                                end
                                --
                                ColorPicker:RemoveOtherFrame()
                            end
                        end
                        --
                        function ModeItem:Deactivate()
                            if ModeItem.Active then
                                ModeItem.Active = false
                                ModeItem.Hovering = false
                                Inactive.Text = Value
                                Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                            end
                        end
                    end
                    --
                    do -- Connections
                        Library:Connection(Button_4.MouseButton1Click, function()
                            ModeItem:Activate()
                        end)
                        --
                        Library:Connection(Inactive.MouseEnter, function()
                            Inactive.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                            --
                            if ModeItem.Active then return end
                            --
                            Inactive.Text = "<b>" .. Value .. "</b>"
                        end)
                        --
                        Library:Connection(Inactive.MouseLeave, function()
                            Inactive.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                            --
                            if ModeItem.Active then return end
                            --
                            Inactive.Text = Value
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                        end)
                    end
                end
                --
                Library:Fade(true, Library:GetObjectsTable(KeybindModePickerOutline, true), KeybindModePickerOutline, 0.1)
            end
            --
            function ColorPicker:RemoveOtherFrame(Fast)
                local Fast = Fast or false
                --
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "ColorPickerOutline" .. Library.UI.TotalColorPickers then
                        if Fast then
                            Value:Destroy()
                        else
                            Library:Fade(false, Library:GetObjectsTable(Value, true), Value, 0.1)
                            --
                            task.delay(Library.UI.TweenSpeed, function()
                                Value:Destroy()
                            end)
                        end
                    end
                end
            end
            --
            function ColorPicker:FindOtherFrame()
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "ColorPickerOutline" .. Library.UI.TotalColorPickers then
                        return true
                    end
                end
                --
                return false
            end
            --
            function ColorPicker:ToggleOtherFrame()
                if Library.UI.CurrentSelectedColorPickerExtra and Library.UI.CurrentSelectedColorPickerExtra.ColorPickerObject.Name ~= ColorPickerOutline_1.Name then
                    Library.UI.CurrentSelectedColorPickerExtra.ColorPicker:RemoveFrame()
                end
                --
                if not ColorPicker:FindOtherFrame() then
                    ColorPicker.ActiveFrame = true
                    ColorPicker:AddOtherFrame()
                else
                    ColorPicker.ActiveFrame = false
                    ColorPicker:RemoveOtherFrame()
                end
            end
        end
        --
        do -- Connections
            Library:Connection(Button_9.MouseButton2Click, function()
                ColorPicker:ToggleOtherFrame()
            end)
            --
            Library:Connection(Button_9.MouseButton1Click, function()
                ColorPicker:Toggle()
            end)
        end
        --
        ColorPicker:AddFrame()
        ColorPicker:Update()
        ColorPicker:RemoveFrame()
        --
        return ColorPicker
    end
    --
    function Library:Keybind(Options)
        Options = Library:Validate({
            Default = Enum.KeyCode.Backspace,
            Mode = "Toggle",
            UseMode = true,
            HideFromList = false,
            Blacklisted = {},
            Parent = nil,
            Toggle = nil,
            MainUI = nil,
            Hiding = false,
            ToggleState = false,
            Flag = Library.NewFlag(),
            Count = 1,
            Callback = function() end,
        }, Options or {})
        --
        if Options.Toggle == nil then return end
        --
        local Keybind = {
            Hover = false,
            ActiveFrame = false,
            Keybind = Options.Default,
            RegKeybind = nil,
            State = false,
            SelectingKeybind = false,
            Toggle = false,
            Connection = nil,
            Mode = Options.Mode,
            ConfigKeybind = nil,
            Current = {},
            CurrentMode = nil,
            Hiding = false,
        }
        --
        Library.Flags[Options.Flag] = Keybind
        Library.UI.TotalKeybindModes += 1
        --
        local KeybindObject = Library:CreateObject("TextLabel", {
            FontFace = Font.new("rbxassetid://12187371840", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(117, 117, 117),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "[-]",
            Name = "KeybindOutline" .. Library.UI.TotalKeybindModes,
            AnchorPoint = Vector2.new(1, 0),
            BorderSizePixel = 0,
            Size = UDim2.new(0, 16, 0, 7),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0 - (Options.Count - 1) * 22, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 3,
            TextStrokeTransparency = 0,
            TextSize = 9,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local KeybindChecker = Library:CreateObject("Frame", {
            Position = UDim2.new(0, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            Visible = false,
            BorderSizePixel = 0,
            Parent = KeybindObject
        })
        --
        local Button_4 = Library:CreateObject("TextButton", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_4",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = KeybindObject
        })
        --
        local UserInputTypeBinds = {"MouseButton1", "MouseButton2", "MouseButton3"}
        --
        do -- Functions
            function Keybind:SetVisible(Bool)
                local OldValues = Library.Objects[KeybindObject]
                --
                Keybind.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[KeybindObject] = {KeybindObject, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(KeybindObject), KeybindObject, 0.075)
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and UDim2.new(1, 0, 0, 8) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[KeybindObject] = {KeybindObject, OldValues[2], false}
                    end
                end)
            end
            --
            function Keybind:Set(Key)
                if Keybind.Hiding then return end
                if typeof(Key) == "boolean" then return end
                --
                if typeof(Key) == "EnumItem" then
                    Keybind.RegKeybind = Key
                elseif typeof(Key) == "string" then
                    if table.find(UserInputTypeBinds, Key) then
                        Keybind.RegKeybind = Enum.UserInputType[Key]
                        Key = Enum.UserInputType[Key]
                    else
                        Keybind.RegKeybind = Enum.KeyCode[Key]
                        Key = Enum.KeyCode[Key]
                    end
                end
                --
                if typeof(Key) == "string" then
                    if Key:find("KEY") then
                        Key = Enum.KeyCode[Key:gsub("KEY_", "")]
                    elseif Key:find("Input") then
                        Key = Enum.UserInputType[Key:gsub("Input_", "")]
                    end
                end
                --
                local ValidKey = false
                local KeyString = ""
                --
                if table.find(Options.Blacklisted, Key) then
                    Key = nil
                end
                --
                if Key then
                    if ((Key.EnumType == Enum.KeyCode and UserInputService:GetStringForKeyCode(Key) ~= "") or Library.UI.Keys[Key]) then
                        ValidKey = true
                        KeyString = Library.UI.Keys[Key] or UserInputService:GetStringForKeyCode(Key)
                    end
                end
                --
                if ValidKey then
                    Keybind.Keybind = KeyString
                    KeybindObject.Text = "[" .. KeyString:upper() .. "]"
                    --
                    Options.Callback(Key)
                    Library.Flags[Options.Flag] = Keybind
                else
                    Keybind.Keybind = "[-]"
                    KeybindObject.Text = Keybind.Keybind
                end
                --
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(117, 117, 117)})
                KeybindObject.Size = UDim2.new(0, KeybindObject.TextBounds.X + 2, 0, 7)
            end
            --
            function Keybind:Toggle(Bool)
                if Keybind.Hiding then return end
                --
                if Options.Toggle.State then
                    if Bool == nil then
                        Keybind.State = not Keybind.State
                    else
                        Keybind.State = Bool
                    end
                    --
                    if not Options.HideFromList then
                        if Keybind.State then
                            --Library:AddKeybindFrame(Keybind.Mode, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                        else
                            --Library:RemoveKeybindFrame(Options.Toggle:GetName(), Options.Toggle:GetSection())
                        end
                    end
                    --
                    if Options.Toggle.GetFlag then
                        Library.Flags[Options.Toggle:GetFlag()] = Keybind
                    end
                    --
                    Options.Toggle:GetCallback(Keybind.State)
                end
            end
            -- task.delay(1, function()
            --     Keybind:Set(Options.Default)
            -- end)
            Keybind:Set(Options.Default)
            --
            function Keybind:Get()
                local KeyString = Keybind.RegKeybind.EnumType == Enum.KeyCode and tostring(Keybind.RegKeybind):match("^Enum%.KeyCode%.(.+)$") or tostring(Keybind.RegKeybind):match("^Enum%.UserInputType%.(.+)$")
                --
                return KeyString
            end
            --
            function Keybind:Active()
                return (Keybind.Keybind:lower() == "[-]" and true or Keybind.State)
            end
            --
            if Options.Mode == "Always on" then
                Keybind:Toggle(true)
            end
            --
            function Keybind:SetMode(Mode)
                Keybind.Mode = Mode
                --
                if Mode == "Always on" then
                    if Mode == "Always on" then
                        Keybind:Toggle(true)
                    end
                    --
                    if not Keybind.State then
                        Keybind.State = true
                        --
                        --Library:AddKeybindFrame(Mode, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                    else
                        --Library:UpdateKeybindFrame(Mode, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                    end
                elseif Mode == "Toggle" then
                    if Keybind.State then
                        --Library:UpdateKeybindFrame(Mode, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                    end
                elseif Mode == "On hotkey" then
                    Keybind.State = false
                    --
                    --Library:RemoveKeybindFrame(Options.Toggle:GetName(), Options.Toggle:GetSection())
                end
            end
            --
            function Keybind:AddFrame()
                Library.UI.CurrentSelectedKeybindMode = {Keybind = Keybind, KeybindObject = KeybindObject, Parent = Options.Parent}
                --
                local KeybindModePickerOutline = Library:CreateObject("Frame", {
                    Name = "KeybindModePickerOutline" .. Library.UI.TotalKeybindModes,
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(0, 100, 0, 55),
                    BorderSizePixel = 0,
                    ZIndex = 25,
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Library.UI.ScreenGUI
                })
                --
                local KeybindModePickerMain = Library:CreateObject("Frame", {
                    Name = "KeybindModePickerMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    ZIndex = 25,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = KeybindModePickerOutline
                })
                --
                KeybindModePickerOutline.BackgroundTransparency = 1
                KeybindModePickerMain.BackgroundTransparency = 1
                --
                local UIListLayout_9 = Library:CreateObject("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = KeybindModePickerMain
                })
                --
                function Keybind:UpdateSize()
                    KeybindModePickerOutline.Position = UDim2.new(0, KeybindObject.AbsolutePosition.X , 0, KeybindObject.AbsolutePosition.Y + KeybindObject.AbsoluteSize.Y + KeybindModePickerOutline.AbsoluteSize.Y - 2)
                end
                --
                Keybind:UpdateSize()
                --
                Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsolutePosition"), Keybind.UpdateSize)
                --
                local StartingY = KeybindObject.AbsolutePosition.Y
                local MainUIStartingY = Options.MainUI.AbsolutePosition.Y
                local StartingCanvasPosition = Options.Parent.Parent.CanvasPosition
                --
                Library:Connection(KeybindObject:GetPropertyChangedSignal("AbsolutePosition"), function()
                    local CurrentY = KeybindObject.AbsolutePosition.Y
                    local MainUICurrentY = Options.MainUI.AbsolutePosition.Y
                    local CurrentCanvasPosition = Options.Parent.Parent.CanvasPosition
                    --
                    if MainUICurrentY ~= MainUIStartingY then
                        MainUIStartingY = MainUICurrentY
                        StartingY = CurrentY
                        --
                        return
                    end
                    --
                    if CurrentCanvasPosition ~= StartingCanvasPosition then
                        StartingCanvasPosition = CurrentCanvasPosition
                        StartingY = CurrentY
                        --
                        return
                    end
                    --
                    if Library.UI.Resizing then
                        return
                    end
                    --
                    if CurrentY ~= StartingY then
                        Keybind:RemoveFrame(true)
                    end
                    --
                    StartingY = CurrentY
                end)
                --
                Library:Connection(Options.MainUI:GetPropertyChangedSignal("AbsoluteSize"), function()
                    if Keybind.ActiveFrame then
                        KeybindModePickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, KeybindChecker)
                    end
                    --
                    Keybind:UpdateSize()
                end)
                --
                Library:Connection(KeybindObject:GetPropertyChangedSignal("AbsoluteSize"), function()
                    Keybind:UpdateSize()
                end)
                --
                if Options.Parent.Parent:IsA("ScrollingFrame") then
                    Library:Connection(Options.Parent.Parent:GetPropertyChangedSignal("CanvasPosition"), function()
                        Keybind:UpdateSize()
                        --
                        if Keybind.ActiveFrame then
                            KeybindModePickerOutline.Visible = Library:ScrollingCheck(Options.Parent.Parent, KeybindChecker)
                        end
                    end)
                end
                --
                for Index, Value in {"Always on", "On hotkey", "Toggle"} do
                    local ModeItem = {
                        Active = false,
                        Hovering = false,
                    }
                    --
                    local Inactive = Library:CreateObject("TextLabel", {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        TextColor3 = Color3.fromRGB(208, 208, 208),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = Value,
                        Text = Value,
                        RichText = true,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        Size = UDim2.new(1, 0, 0, 17),
                        BorderSizePixel = 0,
                        TextSize = Library.UI.FontSize,
                        ZIndex = 25,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = KeybindModePickerMain
                    })
                    --
                    local Button_4 = Library:CreateObject("TextButton", {
                        FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = "Button_4",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        TextTransparency = 1,
                        TextSize = Library.UI.FontSize,
                        ZIndex = 25,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = Inactive
                    })
                    --
                    local UIPadding_48 = Library:CreateObject("UIPadding", {
                        PaddingLeft = UDim.new(0, 8),
                        Parent = Inactive
                    })
                    --
                    Inactive.TextTransparency = 1
                    --
                    do -- Functions
                        function ModeItem:Activate()
                            if not ModeItem.Active then
                                if Keybind.CurrentMode ~= nil then
                                    Keybind.CurrentMode:Deactivate()
                                end
                                --
                                ModeItem.Active = true
                                --
                                Keybind.Mode = Value
                                Keybind.CurrentMode = ModeItem
                                --
                                Inactive.Text = "<b>" .. Value .. "</b>"
                                Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Default.Accent})
                                --
                                if Value == "Always on" then
                                    if Keybind.Mode == "Always on" then
                                        Keybind:Toggle(true)
                                    end
                                    --
                                    if not Keybind.State then
                                        Keybind.State = true
                                        --
                                        --Library:AddKeybindFrame(Value, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                                    else
                                        --Library:UpdateKeybindFrame(Value, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                                    end
                                elseif Value == "Toggle" then
                                    if Keybind.State then
                                        --Library:UpdateKeybindFrame(Value, Options.Toggle:GetName(), Keybind.Keybind, Options.Toggle:GetSection())
                                    end
                                elseif Value == "On hotkey" then
                                    Keybind.State = false
                                    --
                                    --Library:RemoveKeybindFrame(Options.Toggle:GetName(), Options.Toggle:GetSection())
                                end
                            end
                        end
                        --
                        function ModeItem:Deactivate()
                            if ModeItem.Active then
                                ModeItem.Active = false
                                ModeItem.Hovering = false
                                Inactive.Text = Value
                                Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                            end
                        end
                    end
                    --
                    do -- Connections
                        Library:Connection(Button_4.MouseButton1Click, function()
                            ModeItem:Activate()
                        end)
                        --
                        Library:Connection(Inactive.MouseEnter, function()
                            Inactive.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                            --
                            if ModeItem.Active then return end
                            --
                            Inactive.Text = "<b>" .. Value .. "</b>"
                        end)
                        --
                        Library:Connection(Inactive.MouseLeave, function()
                            Inactive.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                            --
                            if ModeItem.Active then return end
                            --
                            Inactive.Text = Value
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                        end)
                    end
                    --
                    if Value == Keybind.Mode then
                        ModeItem:Activate()
                    end
                end
                --
                Library:Fade(true, Library:GetObjectsTable(KeybindModePickerOutline, true), KeybindModePickerOutline, 0.1)
            end
            --
            function Keybind:RemoveFrame(Fast)
                local Fast = Fast or false
                --
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "KeybindModePickerOutline" .. Library.UI.TotalKeybindModes then
                        if Fast then
                            Value:Destroy()
                        else
                            Library:Fade(false, Library:GetObjectsTable(Value, true), Value, 0.1)
                            --
                            task.delay(Library.UI.TweenSpeed, function()
                                Value:Destroy()
                            end)
                        end
                    end
                end
            end
            --
            function Keybind:FindFrame()
                for Index, Value in Library.UI.ScreenGUI:GetChildren() do
                    if Value:IsA("Frame") and Value.Name == "KeybindModePickerOutline" .. Library.UI.TotalKeybindModes then
                        return true
                    end
                end
                --
                return false
            end
            --
            function Keybind:ToggleFrame()
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(176, 176, 176)})
                --
                if Library.UI.CurrentSelectedKeybindMode and Library.UI.CurrentSelectedKeybindMode.KeybindObject.Name ~= KeybindObject.Name then
                    Library.UI.CurrentSelectedKeybindMode.Keybind:RemoveFrame()
                    --
                    Library:TweenObject(Library.UI.CurrentSelectedKeybindMode.KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(117, 117, 117)})
                end
                --
                if not Keybind:FindFrame() then
                    Keybind.ActiveFrame = true
                    Keybind:AddFrame()
                else
                    Keybind.ActiveFrame = false
                    Keybind:RemoveFrame()
                end
            end
        end
        --
        do -- Connections
            Library:Connection(KeybindObject.MouseEnter, function()
                if Keybind.SelectingKeybind then return end
                --
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(176, 176, 176)})
            end)
            --
            Library:Connection(KeybindObject.MouseLeave, function()
                if Keybind.SelectingKeybind then return end
                --
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(117, 117, 117)})
            end)
            --
            Library:Connection(Button_4.MouseButton2Click, function()
                if not Options.UseMode then return end
                --
                Keybind:ToggleFrame()
            end)
            --
            Library:Connection(Button_4.MouseButton1Click, function()
                if Keybind.Connection then
                    Keybind.Connection:Disconnect()
                end
                --
                Keybind.SelectingKeybind = true
                --
                Library:TweenObject(KeybindObject, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(255, 0, 0)})
                --
                Keybind.Connection = Library:Connection(UserInputService.InputBegan, function(Input)
                    Keybind:Set(Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode or Input.UserInputType)
                    --
                    if Keybind.Connection then
                        Keybind.Connection:Disconnect()
                        --
                        task.delay(0.1, function()
                            Keybind.Connection = nil
                            Keybind.SelectingKeybind = false
                        end)
                    end
                end)
            end)
            --
            Library:Connection(UserInputService.InputBegan, function(Input, Proccessed)
                if Proccessed then return end
                --
                if (Input.UserInputType == Enum.UserInputType.Keyboard and Keybind.Keybind ~= "[-]" and Input.KeyCode == Keybind.RegKeybind) or (Input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.Keybind == "MB1") or (Input.UserInputType == Enum.UserInputType.MouseButton2 and Keybind.Keybind == "MB2") or (Input.UserInputType == Enum.UserInputType.MouseButton3 and Keybind.Keybind == "MMB") then
                    if Keybind.Mode == "Always on" then
                        Keybind:Toggle(true)
                    else
                        Keybind:Toggle()
                    end
                end
            end)
            --
            Library:Connection(UserInputService.InputEnded, function(Input, Proccessed)
                if Proccessed then return end
                --
                if Keybind.Mode == "On hotkey" then
                    if (Input.UserInputType == Enum.UserInputType.Keyboard and Keybind.Keybind ~= "[-]" and Input.KeyCode == Keybind.RegKeybind) or (Input.UserInputType == Enum.UserInputType.MouseButton1 and Keybind.Keybind == "MB1") or (Input.UserInputType == Enum.UserInputType.MouseButton2 and Keybind.Keybind == "MB2") or (Input.UserInputType == Enum.UserInputType.MouseButton3 and Keybind.Keybind == "MMB") then
                        Keybind:Toggle()
                    end
                end
            end)
        end
        --
        if Options.Hiding then
            Keybind:SetVisible(false)
        end
        --
        return Keybind
    end
    --
    function Library:MultiBox(Options)
        Options = Library:Validate({
            Default = "None",
            Name = "Preview MultiBox",
            Content = {},
            Parent = nil,
            MainUI = nil,
            Hiding = false,
            TabUI = nil,
            Risky = false,
            Flag = Library.NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local MultiBox = {
            Open = false,
            Hover = false,
            Items = Options.Content,
            Scrollable = false,
            Value = {},
            SelectedOrder = {},
            AllItems = {},
        }
        --
        Library.Flags[Options.Flag] = MultiBox
        Options.Callback(Options.Default)
        --
        local PreviewMultiBox_5 = Library:CreateObject("Frame", {
            Name = "PreviewMultiBox_5",
            BackgroundTransparency = 1,
            Size = Options.Name == "" and UDim2.new(1, 0, 0, 20) or UDim2.new(1, 0, 0, 31),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local MultiBoxOutline_5 = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0, 1),
            Name = "MultiBoxOutline_5",
            Position = UDim2.new(0, -1, 1, 0),
            Size = UDim2.new(1, -19, 0, 20),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewMultiBox_5
        })
        --
        local MultiBoxChecker = Library:CreateObject("Frame", {
            Name = "MultiBoxChecker",
            Position = UDim2.new(0, 0, 1, 0),
            Visible = false,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BorderSizePixel = 0,
            Parent = MultiBoxOutline_5
        })
        --
        local MultiBoxBack_5 = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "MultiBoxBack_5",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(220, 220, 220),
            Parent = MultiBoxOutline_5
        })
        --
        local MultiBoxArrow = Library:CreateObject("ImageLabel", {
            ImageColor3 = Color3.fromRGB(151, 151, 151),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "MultiBoxArrow",
            Image = "rbxassetid://15556784588",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -11, 0, 6),
            Size = UDim2.new(0, 5, 0, 4),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = MultiBoxBack_5
        })
        --
        local UIGradient_34 = Library:CreateObject("UIGradient", {
            Rotation = -90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 39, 39)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
            },
            Parent = MultiBoxBack_5
        })
        --
        local MultiBoxValue_5 = Library:CreateObject("TextLabel", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(152, 152, 152),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "None",
            Name = "MultiBoxValue_5",
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 3,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = MultiBoxBack_5
        })
        --
        local UIPadding_87 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 5),
            Parent = MultiBoxValue_5
        })
        --
        local Button_44 = Library:CreateObject("TextButton", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_44",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = 14,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = MultiBoxOutline_5
        })
        --
        local MultiBoxName_5 = Library:CreateObject("TextLabel", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Library.Theme.Default.TextColor,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = Options.Name,
            Name = "MultiBoxName_5",
            ZIndex = 3,
            Size = UDim2.new(1, -19, 1, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 0, 0, -4),
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewMultiBox_5
        })
        --
        local UIPadding_88 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewMultiBox_5
        })
        --
        local MultiBoxMainOutline = Library:CreateObject("Frame", {
            Name = "MultiBoxMainOutline",
            Position = UDim2.new(0, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 10,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = Library.UI.ScreenGUI
        })
        --
        local MultiBoxMain = Library:CreateObject("Frame", {
            Name = "MultiBoxMain",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            ZIndex = 10,
            ClipsDescendants = true,
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Parent = MultiBoxMainOutline
        })
        --
        MultiBoxMainOutline.BackgroundTransparency = 1
        MultiBoxMain.BackgroundTransparency = 1
        --
        local UIListLayout_9 = Library:CreateObject("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = MultiBoxMain
        })
        --
        do -- Functions
            function MultiBox:Set(Values)
                for index, Item in MultiBox.Items do
                    local newitem = Item
                    local name = index
                    if typeof(newitem) ~= "table" then
                        name = Item
                        newitem = MultiBox.Items[Item]
                    end
                    if newitem then
                        if not table.find(Values, name) then
                            newitem:Deactivate()
                        else
                            newitem:Activate()
                        end
                    end
                end
            end
            --
            function MultiBox:Get()
                return MultiBox.Value
            end
            --
            function MultiBox:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewMultiBox_5]
                --
                MultiBox.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[PreviewMultiBox_5] = {PreviewMultiBox_5, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewMultiBox_5), PreviewMultiBox_5, 0.075)
                Library:TweenObject(PreviewMultiBox_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and (Options.Name == "" and UDim2.new(1, 0, 0, 20) or UDim2.new(1, 0, 0, 31)) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewMultiBox_5] = {PreviewMultiBox_5, OldValues[2], false}
                    end
                end)
            end
            --
            function MultiBox:AddValue(Value)
                local Item = {
                    Active = false,
                    Hovering = false,
                }
                --
                MultiBox.Items[Value] = Item
                --
                local Inactive = Library:CreateObject("TextLabel", {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(208, 208, 208),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = Value,
                    Text = Value,
                    RichText = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = Library.UI.FontSize,
                    ZIndex = 10,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = MultiBoxMain
                })
                --
                local Button_4 = Library:CreateObject("TextButton", {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_4",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    TextSize = Library.UI.FontSize,
                    ZIndex = 11,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Inactive
                })
                --
                local UIPadding_48 = Library:CreateObject("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    Parent = Inactive
                })
                --
                Inactive.TextTransparency = 1

                local Theme = Library.Theme.Objects[Inactive]
                if Theme and Theme.TextColor3 then
                    Inactive.TextColor3 = Theme.TextColor3
                end
                --
                do -- Functions
                    function Item:GetSelectedItems()
                        local SelectedItems = {}
                        --
                        for _, Item in MultiBox.SelectedOrder do
                            if MultiBox.Items[Item] then
                                table.insert(SelectedItems, Item)
                            end
                        end
                        --
                        return SelectedItems
                    end
                    --
                    function MultiBox:UpdateValue()
                        MultiBox.Value = Item:GetSelectedItems()
                        --
                        local displayText = #MultiBox.Value > 0 and table.concat(MultiBox.Value, ", ") or "None"
                        MultiBoxValue_5.Text = Library:ClampString(displayText, MultiBoxMain.AbsoluteSize.X - MultiBoxArrow.AbsoluteSize.X - 4)
                    end
                    --
                    function Item:SelectItem(Item)
                        if not table.find(MultiBox.SelectedOrder, Item) then
                            table.insert(MultiBox.SelectedOrder, Item)
                        end
                        --
                        MultiBox:UpdateValue()
                    end

                    function Item:DeselectItem(Item)
                        for Index, Value in MultiBox.SelectedOrder do
                            if Value == Item then
                                table.remove(MultiBox.SelectedOrder, Index)
                                --
                                break
                            end
                        end
                        --
                        MultiBox:UpdateValue()
                    end
                    --
                    function Item:Activate()
                        if not Item.Active then
                            Item.Active = true
                            MultiBox.CurrentItem = Item
                            MultiBox.Items[Value].Active = true
                            Library.Flags[Options.Flag] = MultiBox
                            Item:SelectItem(Value)
                            Options.Callback(MultiBox.Value)
                            --
                            Inactive.Text = "<b>" .. Value .. "</b>"
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Default.Accent})
                            Library:AddTheme(Inactive, {
                                TextColor3 = "Accent",
                            })
                        end
                    end
                    --
                    function Item:Deactivate()
                        if Item.Active then
                            Item.Active = false
                            Item.Hovering = false
                            MultiBox.CurrentItem = nil
                            Library.Flags[Options.Flag] = MultiBox
                            MultiBox.Items[Value].Active = false
                            Item:DeselectItem(Value)
                            Options.Callback(MultiBox.Value)
                            --
                            Inactive.Text = Value
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                            Library:AddTheme(Inactive, {
                                TextColor3 = "TextColor",
                            })
                        end
                    end
                    --
                    function Item:Toggle()
                        if not MultiBox.Items[Value].Active then
                            Item:Activate()
                        else
                            Item:Deactivate()
                        end
                    end
                end
                --
                do -- Connections
                    Library:Connection(Button_4.MouseButton1Click, function()
                        if MultiBox.Hiding then return end
                        --
                        Item:Toggle()
                    end)
                    --
                    Library:Connection(Inactive.MouseEnter, function()
                        Inactive.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                        --
                        if Item.Active then return end
                        --
                        Inactive.Text = "<b>" .. Value .. "</b>"
                    end)
                    --
                    Library:Connection(Inactive.MouseLeave, function()
                        Inactive.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        --
                        if Item.Active then return end
                        --
                        Inactive.Text = Value
                        Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                    end)
                end
                --
                if typeof(Options.Default) == "table" and table.find(Options.Default, Value) then
                    Item:Activate()
                    Item:SelectItem(Value)
                else
                    MultiBox.Items[Value].Active = false
                end
            end
            --
            function MultiBox:Toggle(Fast)
                local Fast = Fast or false
                local OldValues = Library.Objects[MultiBoxMainOutline]
                --
                if MultiBox.Open then
                    if Fast then
                        Library:Fade(false, Library:GetObjectsTable(MultiBoxMainOutline, true), MultiBoxMainOutline, 0)
                        MultiBoxMainOutline.Size = UDim2.new(0, MultiBoxOutline_5.AbsoluteSize.X, 0, 0)
                        Library.Objects[MultiBoxMainOutline] = {MultiBoxMainOutline, OldValues[2], true}
                    else
                        Library:Fade(false, Library:GetObjectsTable(MultiBoxMainOutline, true), MultiBoxMainOutline, 0.1)
                        Library:TweenObject(MultiBoxMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, MultiBoxOutline_5.AbsoluteSize.X, 0, 0)}, function()
                            Library.Objects[MultiBoxMainOutline] = {MultiBoxMainOutline, OldValues[2], true}
                        end)
                    end
                else
                    Library.Objects[MultiBoxMainOutline] = {MultiBoxMainOutline, OldValues[2], false}
                    --
                    if Fast then
                        Library:Fade(true, Library:GetObjectsTable(MultiBoxMainOutline, true), MultiBoxMainOutline, 0)
                        MultiBoxMainOutline.Size = UDim2.new(0, MultiBoxOutline_5.AbsoluteSize.X, 0, (#Options.Content * 20) + 2)
                    else
                        Library:Fade(true, Library:GetObjectsTable(MultiBoxMainOutline, true), MultiBoxMainOutline, 0.1)
                        Library:TweenObject(MultiBoxMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, MultiBoxOutline_5.AbsoluteSize.X, 0, (#Options.Content * 20) + 2)})
                    end	
                end
                --
                MultiBox.Open = not MultiBox.Open
            end
            --
            function MultiBox:Update()
                MultiBoxMainOutline.Size = UDim2.new(0, MultiBoxOutline_5.AbsoluteSize.X, 0, MultiBoxMainOutline.AbsoluteSize.Y)
                MultiBoxMainOutline.Position = UDim2.new(0, MultiBoxOutline_5.AbsolutePosition.X, 0, ((MultiBoxOutline_5.AbsolutePosition.Y + MultiBoxOutline_5.AbsoluteSize.Y) + GuiService:GetGuiInset().Y + 2))
                --
                if MultiBox.Open then
                    MultiBoxMainOutline.Visible = Library:ScrollingCheck(Options.Parent, MultiBoxChecker)
                end
            end
            --
            MultiBox:Update()
            --
            Library:Connection(MultiBoxOutline_5:GetPropertyChangedSignal("AbsolutePosition"), MultiBox.Update)
            Library:Connection(MultiBoxOutline_5:GetPropertyChangedSignal("AbsoluteSize"), MultiBox.Update)
            --
            local StartingX = PreviewMultiBox_5.AbsolutePosition.X
            local StartingY = PreviewMultiBox_5.AbsolutePosition.Y
            local MainUIStartingX = Options.MainUI.AbsolutePosition.X
            local MainUIStartingY = Options.MainUI.AbsolutePosition.Y
            local StartingCanvasPosition = Options.Parent.CanvasPosition
            --
            Library:Connection(PreviewMultiBox_5:GetPropertyChangedSignal("AbsolutePosition"), function()
                if not MultiBox.Open then return end
                --
                local CurrentX = PreviewMultiBox_5.AbsolutePosition.X
                local CurrentY = PreviewMultiBox_5.AbsolutePosition.Y
                local MainUICurrentX = Options.MainUI.AbsolutePosition.X
                local MainUICurrentY = Options.MainUI.AbsolutePosition.Y
                local CurrentCanvasPosition = Options.Parent.CanvasPosition
                --
                if MainUICurrentX ~= MainUIStartingX or MainUICurrentY ~= MainUIStartingY then
                    MainUIStartingX = MainUICurrentX
                    MainUIStartingY = MainUICurrentY
                    StartingX = CurrentX
                    StartingY = CurrentY
                    --
                    return
                end
                --
                if CurrentCanvasPosition ~= StartingCanvasPosition then
                    StartingCanvasPosition = CurrentCanvasPosition
                    StartingX = CurrentX
                    StartingY = CurrentY
                    --
                    return
                end
                --
                if Library.UI.Resizing then
                    return
                end
                --
                if CurrentX ~= StartingX or CurrentY ~= StartingY then
                    MultiBox:Toggle(true)
                end
                --
                StartingX = CurrentX
                StartingY = CurrentY
            end)
            --
            if Options.Parent:IsA("ScrollingFrame") then
                Library:Connection(Options.Parent:GetPropertyChangedSignal("CanvasPosition"), function()
                    MultiBox:Update()
                end)
            end
        end
        --
        do -- Connections
            Library:Connection(Button_44.MouseButton1Click, function()
                if MultiBox.Hiding then return end
                --
                MultiBox:Toggle()
            end)
            --
            Library:Connection(MultiBoxOutline_5.MouseEnter, function()
                if Library.UI.Faded then return end
                --
                if not MultiBox.Open then
                    MultiBox.Hovering = true
                    Library:TweenObject(MultiBoxBack_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                end	
            end)
            --
            Library:Connection(MultiBoxOutline_5.MouseLeave, function()
                if Library.UI.Faded then return end
                --
                if not MultiBox.Open then
                    MultiBox.Hovering = false
                    Library:TweenObject(MultiBoxBack_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
                end	
            end)
        end
        --
        for Index, Value in Options.Content do
            if typeof(Value) == "boolean" or typeof(Value) == "table" then continue end
            --
            MultiBox:AddValue(Value)
        end
        --
        Library:Fade(false, Library:GetObjectsTable(MultiBoxMainOutline, true), MultiBoxMainOutline, 0.1)
        --
        if Options.Hiding then
            MultiBox:SetVisible(false)
        end
        --
        MultiBox:Toggle(true)
        --
        return MultiBox
    end
    --
    function Library:Dropdown(Options)
        Options = Library:Validate({
            Default = "None",
            Name = "Preview Dropdown",
            Content = {},
            Parent = nil,
            MainUI = nil,
            Hiding = false,
            TabUI = nil,
            Risky = false,
            Flag = Library.NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local Dropdown = {
            Open = false,
            Active = false,
            Hovering = false,
            CurrentItem = nil,
            Scrollable = false,
            Hiding = false,
            Items = {},
            Value = Options.Default,
        }
        --
        Library.Flags[Options.Flag] = Dropdown
        --
        local PreviewDropdown_5 = Library:CreateObject("Frame", {
            Name = "PreviewDropdown_5",
            BackgroundTransparency = 1,
            Size = Options.Name == "" and UDim2.new(1, 0, 0, 20) or UDim2.new(1, 0, 0, 31),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local DropdownOutline_5 = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0, 1),
            Name = "DropdownOutline_5",
            Position = UDim2.new(0, -1, 1, 0),
            Size = UDim2.new(1, -19, 0, 20),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewDropdown_5
        })
        --
        local DropdownChecker = Library:CreateObject("Frame", {
            Name = "DropdownChecker",
            Position = UDim2.new(0, 0, 1, 0),
            Visible = false,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BorderSizePixel = 0,
            Parent = DropdownOutline_5
        })
        --
        local DropdownBack_5 = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "DropdownBack_5",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(220, 220, 220),
            Parent = DropdownOutline_5
        })
        --
        local DropdownArrow = Library:CreateObject("ImageLabel", {
            ImageColor3 = Color3.fromRGB(151, 151, 151),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "DropdownArrow",
            Image = "rbxassetid://15556784588",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -11, 0, 6),
            Size = UDim2.new(0, 5, 0, 4),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = DropdownBack_5
        })
        --
        local UIGradient_34 = Library:CreateObject("UIGradient", {
            Rotation = -90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 39, 39)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
            },
            Parent = DropdownBack_5
        })
        --
        local DropdownValue_5 = Library:CreateObject("TextLabel", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(152, 152, 152),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = Options.Default ~= "None" and table.find(Options.Content, Options.Default) and Options.Default or "None",
            Name = "DropdownValue_5",
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 3,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = DropdownBack_5
        })
        --
        local UIPadding_87 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 5),
            Parent = DropdownValue_5
        })
        --
        local Button_44 = Library:CreateObject("TextButton", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_44",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = 14,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = DropdownOutline_5
        })
        --
        local DropdownName_5 = Library:CreateObject("TextLabel", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Library.Theme.Default.TextColor,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = Options.Name,
            Name = "DropdownName_5",
            ZIndex = 3,
            Position = UDim2.new(0, 0, 0, -4),
            Size = UDim2.new(1, -19, 1, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewDropdown_5
        })
        --
        local UIPadding_88 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewDropdown_5
        })
        --
        local DropdownMainOutline = Library:CreateObject("Frame", {
            Name = "DropdownMainOutline",
            Position = UDim2.new(0, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 10,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = Library.UI.ScreenGUI
        })
        --
        local DropdownMain = Library:CreateObject("Frame", {
            Name = "DropdownMain",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            ZIndex = 10,
            ClipsDescendants = true,
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Parent = DropdownMainOutline
        })
        --
        DropdownMainOutline.BackgroundTransparency = 1
        DropdownMain.BackgroundTransparency = 1

        --
        local UIListLayout_9 = Library:CreateObject("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = DropdownMain
        })
        --
        do -- Functions
            function Dropdown:Set(State)
                for Index, Value in Dropdown.Items do
                    if Index == State then
                        Value:Activate()
                    else
                        Value:Deactivate()
                    end
                end
            end
            --
            function Dropdown:Get()
                return Dropdown.Value
            end
            --
            function Dropdown:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewDropdown_5]
                --
                Dropdown.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[PreviewDropdown_5] = {PreviewDropdown_5, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewDropdown_5), PreviewDropdown_5, 0.075)
                Library:TweenObject(PreviewDropdown_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and (Options.Name == "" and UDim2.new(1, 0, 0, 20) or UDim2.new(1, 0, 0, 31)) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewDropdown_5] = {PreviewDropdown_5, OldValues[2], false}
                    end
                end)
            end
            --
            function Dropdown:AddValue(Value)
                local Item = {
                    Active = false,
                    Hovering = false,
                }
                --
                Dropdown.Items[Value] = Item
                --
                local Inactive = Library:CreateObject("TextLabel", {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(208, 208, 208),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = Value,
                    Text = Value,
                    RichText = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderSizePixel = 0,
                    TextSize = Library.UI.FontSize,
                    ZIndex = 10,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = DropdownMain
                })
                --
                local Button_4 = Library:CreateObject("TextButton", {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_4",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    TextSize = Library.UI.FontSize,
                    ZIndex = 10,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = Inactive
                })
                --
                local UIPadding_48 = Library:CreateObject("UIPadding", {
                    PaddingLeft = UDim.new(0, 8),
                    Parent = Inactive
                })
                --
                Inactive.TextTransparency = 1
                --
                do -- Functions
                    function Item:Activate()
                        if not Item.Active then
                            if Dropdown.CurrentItem ~= nil then
                                Dropdown.CurrentItem:Deactivate()
                            end
                            --
                            Item.Active = true
                            Dropdown.CurrentItem = Item
                            Dropdown.Value = Value
                            Library.Flags[Options.Flag] = Dropdown
                            Options.Callback(Value)
                            DropdownValue_5.Text = Value
                            --
                            Inactive.Text = "<b>" .. Value .. "</b>"
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Default.Accent})
                            Library:AddTheme(Inactive, {
                                TextColor3 = "Accent",
                            })
                        end
                    end
                    --
                    function Item:Deactivate()
                        if Item.Active then
                            Item.Active = false
                            Item.Hovering = false
                            Inactive.Text = Value
                            Inactive.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                            Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                            Library:AddTheme(Inactive, {
                                TextColor3 = "TextColor",
                            })
                        end
                    end
                end
                --
                do -- Connections
                    Library:Connection(Button_4.MouseButton1Click, function()
                        if Dropdown.Hiding then return end
                        --
                        Item:Activate()
                        Dropdown:Toggle()
                    end)
                    --
                    Library:Connection(Inactive.MouseEnter, function()
                        Inactive.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                        --
                        if Item.Active then return end
                        --
                        Inactive.Text = "<b>" .. Value .. "</b>"
                    end)
                    --
                    Library:Connection(Inactive.MouseLeave, function()
                        Inactive.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        --
                        if Item.Active then return end
                        --
                        Inactive.Text = Value
                        Library:TweenObject(Inactive, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(205, 205, 205)})
                    end)
                end
                --
                if Value == Options.Default then
                    Item:Activate()
                end
            end
            --
            function Dropdown:Toggle(Fast)
                local Fast = Fast or false
                local OldValues = Library.Objects[DropdownMainOutline]
                --
                if Dropdown.Open then
                    if Fast then
                        Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0)
                        DropdownMainOutline.Size = UDim2.new(0, DropdownOutline_5.AbsoluteSize.X, 0, 0)
                        Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], true}
                    else
                        Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
                        Library:TweenObject(DropdownMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownOutline_5.AbsoluteSize.X, 0, 0)}, function()
                            Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], true}
                        end)
                    end
                else
                    Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], false}
                    --
                    if Fast then
                        Library:Fade(true, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0)
                        DropdownMainOutline.Size = UDim2.new(0, DropdownOutline_5.AbsoluteSize.X, 0, (#Options.Content * 20) + 2)
                    else
                        Library:Fade(true, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
                        Library:TweenObject(DropdownMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownOutline_5.AbsoluteSize.X, 0, (#Options.Content * 20) + 2)})
                    end	
                end
                --
                Dropdown.Open = not Dropdown.Open
            end
            --
            function Dropdown:Update()
                DropdownMainOutline.Size = UDim2.new(0, DropdownOutline_5.AbsoluteSize.X, 0, DropdownMainOutline.AbsoluteSize.Y)
                DropdownMainOutline.Position = UDim2.new(0, DropdownOutline_5.AbsolutePosition.X, 0, ((DropdownOutline_5.AbsolutePosition.Y + DropdownOutline_5.AbsoluteSize.Y) + GuiService:GetGuiInset().Y + 2))
                --
                if Dropdown.Open then
                    DropdownMainOutline.Visible = Library:ScrollingCheck(Options.Parent, DropdownChecker)
                end
            end
            --
            Dropdown:Update()
            --
            Library:Connection(DropdownOutline_5:GetPropertyChangedSignal("AbsolutePosition"), Dropdown.Update)
            Library:Connection(DropdownOutline_5:GetPropertyChangedSignal("AbsoluteSize"), Dropdown.Update)
            --
            local StartingX = PreviewDropdown_5.AbsolutePosition.X
            local StartingY = PreviewDropdown_5.AbsolutePosition.Y
            local MainUIStartingX = Options.MainUI.AbsolutePosition.X
            local MainUIStartingY = Options.MainUI.AbsolutePosition.Y
            local StartingCanvasPosition = Options.Parent.CanvasPosition
            --
            Library:Connection(PreviewDropdown_5:GetPropertyChangedSignal("AbsolutePosition"), function()
                if not Dropdown.Open then return end
                --
                local CurrentX = PreviewDropdown_5.AbsolutePosition.X
                local CurrentY = PreviewDropdown_5.AbsolutePosition.Y
                local MainUICurrentX = Options.MainUI.AbsolutePosition.X
                local MainUICurrentY = Options.MainUI.AbsolutePosition.Y
                local CurrentCanvasPosition = Options.Parent.CanvasPosition
                --
                if MainUICurrentX ~= MainUIStartingX or MainUICurrentY ~= MainUIStartingY then
                    MainUIStartingX = MainUICurrentX
                    MainUIStartingY = MainUICurrentY
                    StartingX = CurrentX
                    StartingY = CurrentY
                    --
                    return
                end
                --
                if CurrentCanvasPosition ~= StartingCanvasPosition then
                    StartingCanvasPosition = CurrentCanvasPosition
                    StartingX = CurrentX
                    StartingY = CurrentY
                    --
                    return
                end
                --
                if Library.UI.Resizing then
                    return
                end
                --
                if CurrentX ~= StartingX or CurrentY ~= StartingY then
                    Dropdown:Toggle(true)
                end
                --
                StartingX = CurrentX
                StartingY = CurrentY
            end)
            --
            if Options.Parent:IsA("ScrollingFrame") then
                Library:Connection(Options.Parent:GetPropertyChangedSignal("CanvasPosition"), function()
                    Dropdown:Update()
                end)
            end
        end
        --
        do -- Connections
            Library:Connection(Button_44.MouseButton1Click, function()
                if Dropdown.Hiding then return end
                --
                Dropdown:Toggle()
            end)
            --
            Library:Connection(DropdownOutline_5.MouseEnter, function()
                if Library.UI.Faded then return end
                --
                if not Dropdown.Open then
                    Dropdown.Hovering = true
                    Library:TweenObject(DropdownBack_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                end	
            end)
            --
            Library:Connection(DropdownOutline_5.MouseLeave, function()
                if Library.UI.Faded then return end
                --
                if not Dropdown.Open then
                    Dropdown.Hovering = false
                    Library:TweenObject(DropdownBack_5, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
                end	
            end)
        end
        --
        for _, Value in Options.Content do
            Dropdown:AddValue(Value)
        end
        --
        Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
        --
        if Options.Hiding then
            Dropdown:SetVisible(false)
        end
        --
        Dropdown:Toggle(true)
        --
        return Dropdown
    end
    --
    function Library:Slider(Options)
        Options = Library:Validate({
            Name = "Preview Slider",
            Min = 0,
            Max = 100,
            Default = 1,
            Decimal = 1,
            UseIcons = true,
            Ending = "",
            Disable = {},
            Hidden = false,
            Risky = false,
            Parent = nil,
            OverrideLimit = false, -- new parameter to allow values beyond max
            Flag = Library.NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local Slider = {
            MouseDown = false,
            Hiding = false,
            Hovering = false,
            Connection = nil,
            CurrentValue = -9999,
            LeftControlDown = false,
        }
        --
        Library.Flags[Options.Flag] = Slider
        --
        local PreviewSlider = Library:CreateObject("Frame", {
            Name = "PreviewSlider",
            BackgroundTransparency = 1,
            Size = Options.Name == "" and UDim2.new(1, 0, 0, 7) or UDim2.new(1, 0, 0, 20),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local SliderOutline = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0, 1),
            Name = "SliderOutline",
            Position = UDim2.new(0, -1, 1, 0),
            Size = UDim2.new(1, -19, 0, 7),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewSlider
        })
        --
        local SliderBack = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "SliderBack",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(205, 205, 205),
            Parent = SliderOutline
        })
        --
        local UIGradient_2 = Library:CreateObject("UIGradient", {
            Rotation = -90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(81, 81, 81)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(68, 68, 68))
            },
            Parent = SliderBack
        })
        --
        local SliderDrag = Library:CreateObject("Frame", {
            Name = "Slider",
            Size = UDim2.new(0.5, 0, 1, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = SliderBack
        })
        --
        local UIGradient_3 = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Library.Theme.Default.Accent),
                ColorSequenceKeypoint.new(1, Library.Theme.Default.SecondAccent)
            },
            Parent = SliderDrag
        })
        --
        Library:AddTheme(UIGradient_3, {
            Color = {"Accent", "SecondAccent"},
        })
        --
        local Button_4 = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_4",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = SliderOutline
        })
        --
        local SliderName = Library:CreateObject("TextLabel", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Options.Risky and Library.Theme.Default.Risky or Library.Theme.Default.TextColor,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = Options.Name,
            Name = "SliderName",
            ZIndex = 3,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewSlider
        })
        --
        if Options.Risky then
            Library:AddTheme(SliderName, {
                TextColor3 = "Risky",
            })
        end
        --
        local UIPadding_3 = Library:CreateObject("UIPadding", {
            PaddingTop = UDim.new(0, -4),
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewSlider
        })
        --
        local SliderValue = Library:CreateObject("TextBox", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(198, 198, 198),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = Options.Default,
            Name = "SliderValue",
            ZIndex = 3,
            AnchorPoint = Vector2.new(1, 0),
            Size = UDim2.new(0, 10, 0, 10),
            Position = UDim2.new(0, 100, 0, 0),
            BackgroundTransparency = 1,
            RichText = true,
            BorderSizePixel = 0,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextSize = Library.UI.FontSize,
            TextStrokeTransparency = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = SliderDrag
        })
        --
        local AddButton = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(1, 1),
            Name = "AddButton",
            Position = UDim2.new(1, -13, 1, -3),
            Size = UDim2.new(0, 3, 0, 1),
            ZIndex = 3,
            BorderSizePixel = 0,
            Visible = Options.UseIcons,
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            Parent = PreviewSlider
        })
        --
        local AddButton2 = Library:CreateObject("Frame", {
            Size = UDim2.new(0, 1, 0, 3),
            Name = "AddButton2",
            Position = UDim2.new(0, 1, 0, -1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            Visible = Options.UseIcons,
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            Parent = AddButton
        })
        --
        local AddActualButton = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "AddActualButton",
            TextTransparency = 1,
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 11, 0, 7),
            Visible = Options.UseIcons,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -9, 1, 1),
            BorderSizePixel = 0,
            ZIndex = 3,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewSlider
        })
        --
        local MinusActualButton = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "MinusActualButton",
            TextTransparency = 1,
            Visible = Options.UseIcons,
            AnchorPoint = Vector2.new(0, 1),
            Size = UDim2.new(0, 11, 0, 7),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, -12, 1, 0),
            BorderSizePixel = 0,
            ZIndex = 3,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewSlider
        })
        --
        local MinusButton = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Vector2.new(0, 1),
            Name = "MinusButton",
            Visible = Options.UseIcons,
            Position = UDim2.new(0, -8, 1, -3),
            Size = UDim2.new(0, 3, 0, 1),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(100, 100, 100),
            Parent = PreviewSlider
        })
        --
        local function GetValue(Value)
            return typeof(Value) == "string" and Value or ("%.14g"):format(Value)
        end
        --
        local function SetValue(Value, IgnoreLimit)
            if (not Value) or Slider.Hiding then return end
            --
            local OriginalValue = Value
            -- check if we should allow values beyond the max
            if Options.OverrideLimit and IgnoreLimit then
                -- allow any value (still enforce min and decimal rounding)
                Value = Value and math.max(Options.Decimal * math.round(tonumber(Value) / Options.Decimal), Options.Min) or 0
            else
                -- default behavior: clamp between min and max
                Value = Value and math.clamp(Options.Decimal * math.round(tonumber(Value) / Options.Decimal), Options.Min, Options.Max) or 0
            end
            
            local ValueText = Options.Disable[1] and ((Value <= Options.Disable[2] or Value >= Options.Disable[3]) and Options.Disable[1]) or tostring(GetValue(Value)) .. Options.Ending
            --
            SliderValue.Text = "<b>" .. ValueText .. "</b>"
            --
            if Value ~= Slider.CurrentValue then
                Slider.CurrentValue = Value
                -- always display the slider within bounds, even if the value is beyond max
                local DisplayValue = math.min(Value, Options.Max)
                Library:TweenObject(SliderDrag, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new((DisplayValue - Options.Min) / (Options.Max - Options.Min), 0, 1, 0)})
                --
                SliderValue.Size = UDim2.fromOffset(SliderValue.TextBounds.X, SliderValue.TextBounds.Y)
                SliderValue.Position = UDim2.new(1, SliderValue.TextBounds.X / 2, 0, 1)
            end
            --
            Library.Flags[Options.Flag] = Slider
            Options.Callback(tonumber(GetValue(Value)))
        end
        --
        SetValue(Options.Default)
        --
        function Slider:Get()
            return tonumber(GetValue(Slider.CurrentValue))
        end
        --
        function Slider:Max()
            return Options.Max
        end
        --
        function Slider:Min()
            return Options.Min
        end
        --
        function Slider:Set(Value)
            if not Value then return end
            --
            SetValue(Value, Options.OverrideLimit) -- allow overriding limits for api calls too
        end
        --
        function Slider:GetName()
            return Options.Name
        end
        --
        function Slider:SetVisible(Bool)
            local OldValues = Library.Objects[PreviewSlider]
            --
            Slider.Hiding = not Bool
            SliderValue.Visible = Bool
            --
            if Bool then
                Library.Objects[PreviewSlider] = {PreviewSlider, OldValues[2], true}
            end
            --
            Library:Fade(Bool, Library:GetObjectsTable(PreviewSlider), PreviewSlider, 0.075)
            Library:TweenObject(PreviewSlider, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and (Options.Name == "" and UDim2.new(1, 0, 0, 7) or UDim2.new(1, 0, 0, 20)) or UDim2.new(1, 0, 0, -10)}, function()
                if not Bool then
                    Library.Objects[PreviewSlider] = {PreviewSlider, OldValues[2], false}
                end
            end)
        end
        --
        local function SlideBar(Input)
            local SizeX = (Input.Position.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X
            local Value = math.clamp((Options.Max - Options.Min) * SizeX + Options.Min, Options.Min, Options.Max)
            --
            SetValue(Value)
        end
        --
        do -- Connections
            Library:Connection(SliderOutline.MouseEnter, function()
                if Library.UI.Faded then return end
                --
                Library:TweenObject(SliderBack, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
            end)
            --
            Library:Connection(SliderOutline.MouseLeave, function()
                if Library.UI.Faded then return end
                --
                Library:TweenObject(SliderBack, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(205, 205, 205)})
            end)
            --
            Library:Connection(MinusActualButton.MouseButton1Click, function()
                if Library.UI.Faded then return end
                --
                Slider:Set(Slider.CurrentValue - Options.Decimal)
            end)
            --
            Library:Connection(AddActualButton.MouseButton1Click, function()
                if Library.UI.Faded then return end
                --
                Slider:Set(Slider.CurrentValue + Options.Decimal)
            end)
            --
            Library:Connection(Button_4.MouseButton1Down, function()
                if Library.UI.Faded then return end
                --
                Library.UI.DraggingGui = SliderDrag
                Slider.MouseDown = true
                SlideBar({Position = UserInputService:GetMouseLocation()})
            end)
            --
            Library:Connection(SliderValue.FocusLost, function()
                local NewValue = tonumber(SliderValue.Text)
                --
                if NewValue then
                    SetValue(NewValue, Options.OverrideLimit) -- pass true to allow exceeding max
                else
                    SetValue(Options.Min)
                end
            end)
            --
            Library:Connection(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function(Input)
                if Library.UI.Faded then return end
                --
                if Library.UI.DraggingGui ~= SliderDrag and not (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)) then
                    return
                end
                --
                if Slider.MouseDown and Input.UserInputType == Enum.UserInputType.MouseMovement then
                    SlideBar(Input)
                end
            end))
            --
            Library:Connection(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Slider.MouseDown = false
                end
            end)
        end
        --
        if Options.Hidden then
            Slider:SetVisible(false)
        end
        --
        return Slider
    end
    --
    function Library:Toggle(Options)
        Options = Library:Validate({
            Default = false,
            Name = "Preview Toggle",
            Risky = false,
            SectionName = nil,
            Parent = nil,
            Hidden = false,
            AnchorPoint = Vector2.new(0, 0),
            MainUI = nil,
            Size = UDim2.new(1, 0, 0, 8),
            Position = UDim2.new(0, 0, 0, 0),
            UseToggleOutline = false,
            ZIndex = 2,
            Flag = Library:NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local Toggle = {
            Active = false,
            Hovering = false,
            State = false,
            Hiding = false,
            MainUI = Options.MainUI,
            TabUI = Options.TabUI,
            ColorPickers = {},
            KeybindState = false,
        }
        --
        Library.Flags[Options.Flag] = Toggle
        --
        local PreviewToggle = Library:CreateObject("Frame", {
            Name = "PreviewToggle",
            BackgroundTransparency = 1,
            Size = Options.Size,
            Position = Options.Position,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            AnchorPoint = Options.AnchorPoint,
            ZIndex = Options.ZIndex or 2,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local ToggleOutline = Library:CreateObject("Frame", {
            Name = "ToggleOutline",
            Size = UDim2.new(0, 8, 0, 8),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = Options.ZIndex or 2,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewToggle
        })
        --
        if Options.UseToggleOutline then
            ToggleOutline.AnchorPoint = Options.AnchorPoint
            ToggleOutline.Position = Options.Position
        end
        --
        local ToggleInline = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ToggleInline",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = Options.ZIndex or 2,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(227, 227, 227),
            Parent = ToggleOutline
        })
        --
        local UIGradient_3 = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(84, 84, 84)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(74, 74, 74))
            },
            Parent = ToggleInline
        })
        --
        local ToggleMain = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ToggleInline",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = Options.ZIndex or 2,
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ToggleOutline
        })
        --
        Library.Objects[ToggleMain] = {ToggleMain, {BackgroundTransparency = ToggleMain.BackgroundTransparency}, false}
        --
        local UIGradient_32 = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Library.Theme.Default.Accent),
                ColorSequenceKeypoint.new(1, Library.Theme.Default.SecondAccent)
            },
            Parent = ToggleMain
        })
        --
        Library:AddTheme(UIGradient_32, {
            Color = {"Accent", "SecondAccent"},
        })
        --
        local ToggleName = Library:CreateObject("TextLabel", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "ToggleName",
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = Options.ZIndex or 2,
            FontFace = Library.UI.NewFont,
            RichText = true,
            Text = Options.Name,
            TextColor3 = Options.Risky and Library.Theme.Default.Risky or Library.Theme.Default.TextColor,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewToggle
        })
        --
        if Options.Risky then
            Library:AddTheme(ToggleName, {
                TextColor3 = "Risky",
            })
        end
        --
        local UIPadding_7 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = ToggleName
        })
        --
        local Button_9 = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_9",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewToggle
        })
        --
        do -- Functions
            function Toggle:ToggleGUI(Bool)
                if Bool == nil then
                    Toggle.State = not Toggle.State
                else
                    Toggle.State = Bool
                end
                --
                Library:TweenObject(ToggleMain, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = Toggle.State and 0 or 1})
                
                -- update the stored transparency value in the objects table, this is for the temp fix for the toggle out and toggle in 
                -- since this uses instant out and instant in instead of the normal fade in and fade out
                if Library.Objects[ToggleMain] then
                    Library.Objects[ToggleMain][2].BackgroundTransparency = Toggle.State and 0 or 1
                end
                
                --
                Library.Flags[Options.Flag] = Toggle
                Options.Callback(Toggle.State)
            end
            --
            function Toggle:GetName()
                return Options.Name
            end
            --
            function Toggle:GetFlag()
                return Options.Flag
            end
            --
            function Toggle:GetSection()
                return Options.SectionName
            end
            --
            function Toggle:GetState()
                return Toggle.State
            end
            --
            function Toggle:GetCallback(b)
                Options.Callback(b)
            end
            --
            function Toggle:Set(Value)
                Toggle:ToggleGUI(Value)
            end
            --
            function Toggle:SetName(Name)
                Options.Name = Name
                ToggleName.Text = Name
            end
            --
            function Toggle:Get()
                return Toggle.State
            end
            --
            function Toggle:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewToggle]
                --
                Toggle.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[PreviewToggle] = {PreviewToggle, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewToggle), PreviewToggle, 0.075)
                Library:TweenObject(PreviewToggle, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and UDim2.new(1, 0, 0, 8) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewToggle] = {PreviewToggle, OldValues[2], false}
                    end
                end)
            end
            --
            function Toggle:ColorPicker(Options)
                Options = Library:Validate({
                    Name = "Preview Color Picker",
                    Default = Library.Theme.Default.Accent,
                    Flag = Library.NewFlag(),
                    Alpha = 0,
                    AlphaBar = true,
                    Callback = function() end,
                }, Options or {})
                --
                local ColorPicker = {}
                --
                Toggle.ColorPickers[#Toggle.ColorPickers + 1] = ColorPicker
                --
                local ColorPickerFrame = Library:ColorPicker({
                    Name = Options.Name,
                    Default = Options.Default,
                    Flag = Options.Flag,
                    Alpha = Options.Alpha,
                    AlphaBar = Options.AlphaBar,
                    MainUI = Toggle.MainUI,
                    TabUI = Toggle.TabUI,
                    Callback = Options.Callback,
                    Parent = PreviewToggle,
                    Keybind = Toggle.KeybindState,
                    Count = #Toggle.ColorPickers,
                })
                --
                return ColorPickerFrame
            end
            --
            function Toggle:Keybind(Options)
                Options = Library:Validate({
                    Default = Enum.KeyCode.Backspace,
                    Mode = "Toggle",
                    UseMode = true,
                    HideFromList = false,
                    Blacklisted = {},
                    Hiding = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end,
                }, Options or {})
                --
                local Keybind = {}
                --
                Toggle.KeybindState = true
                --
                Library:Keybind({
                    Default = Options.Default,
                    Mode = Options.Mode,
                    HideFromList = Options.HideFromList,
                    Blacklisted = Options.Blacklisted,
                    Parent = PreviewToggle,
                    UseMode = Options.UseMode,
                    Toggle = Toggle,
                    MainUI = Toggle.MainUI,
                    TabUI = Toggle.TabUI,
                    Hiding = Options.Hiding,
                    ToggleState = Toggle.State,
                    Flag = Options.Flag,
                    Callback = Options.Callback,
                    Count = #Toggle.ColorPickers + 1,
                })
                --
                return Keybind
            end
        end
        --
        do -- Connections
            Library:Connection(PreviewToggle.MouseEnter, function()
                if Library.UI.Faded then return end
                --
                Library:TweenObject(ToggleInline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
            end)
            --
            Library:Connection(PreviewToggle.MouseLeave, function()
                if Library.UI.Faded then return end
                --
                Library:TweenObject(ToggleInline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(227, 227, 227)})
            end)
            --
            Library:Connection(Button_9.MouseButton1Click, function()
                if Library.UI.Faded then return end
                --
                if Toggle.Hiding then return end
                --
                Toggle:ToggleGUI()
            end)
        end
        --
        Toggle:ToggleGUI(Options.Default)
        --
        if Options.Hidden then
            Toggle:SetVisible(false)
        end
        --
        return Toggle
    end
    --
    function Library:Label(Options)
        Options = Library:Validate({
            Message = "Preview Label",
            Side = "Left",
            Risky = false,
            Parent = nil,
            MainUI = nil,
            SectionName = nil,
            Hidden = false,
            TabUI = nil,
            Callback = function() end
        }, Options or {})
        --
        local Label = {
            ColorPickers = {},
            KeybindState = false,
            Hiding = false,
            MainUI = Options.MainUI,
            TabUI = Options.TabUI,
            State = true,
        }
        --
        local PreviewLabel = Library:CreateObject("Frame", {
            Name = "PreviewLabel",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 7),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 2,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local LabelText = Library:CreateObject("TextLabel", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "ToggleName",
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment[Options.Side],
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 0, 0, -1),
            ZIndex = 2,
            FontFace = Library.UI.NewFont,
            RichText = true,
            Text = Options.Message,
            TextColor3 = Color3.fromRGB(198, 198, 198),
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PreviewLabel
        })
        --
        local UIPadding_7 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = LabelText
        })
        --
        do -- Functions
            function Label:GetName()
                return Options.Message
            end
            --
            function Label:GetState()
                return Label.State
            end
            --
            function Label:GetSection()
                return Options.SectionName
            end
            --
            function Label:GetCallback(Bool)
                Options.Callback(Bool)
            end
            --
            function Label:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewLabel]
                --
                Label.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[PreviewLabel] = {PreviewLabel, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewLabel), PreviewLabel, 0.075)
                Library:TweenObject(PreviewLabel, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and UDim2.new(1, 0, 0, 8) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewLabel] = {PreviewLabel, OldValues[2], false}
                    end
                end)
            end
            --
            function Label:ColorPicker(Options)
                Options = Library:Validate({
                    Name = "Preview Color Picker",
                    Default = Library.Theme.Default.Accent,
                    Flag = Library.NewFlag(),
                    Alpha = 0,
                    AlphaBar = true,
                    MainUI = nil,
                    Callback = function() end,
                }, Options or {})
                --
                local ColorPicker = {}
                --
                Label.ColorPickers[#Label.ColorPickers + 1] = ColorPicker
                --
                local ColorPickerFrame = Library:ColorPicker({
                    Name = Options.Name,
                    Default = Options.Default,
                    Flag = Options.Flag,
                    Alpha = Options.Alpha,
                    AlphaBar = Options.AlphaBar,
                    MainUI = Label.MainUI,
                    TabUI = Label.TabUI,
                    Callback = Options.Callback,
                    Parent = PreviewLabel,
                    Keybind = Label.KeybindState,
                    Count = #Label.ColorPickers,
                })
                --
                return ColorPickerFrame
            end
            --
            function Label:Keybind(Options)
                Options = Library:Validate({
                    Default = Enum.KeyCode.Backspace,
                    Mode = "Toggle",
                    UseMode = true,
                    HideFromList = false,
                    Blacklisted = {},
                    Hiding = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end,
                }, Options or {})
                --
                local Keybind = {}
                --
                Label.KeybindState = true
                --
                Library:Keybind({
                    Default = Options.Default,
                    Mode = Options.Mode,
                    HideFromList = Options.HideFromList,
                    Blacklisted = Options.Blacklisted,
                    Parent = PreviewLabel,
                    Toggle = Label,
                    UseMode = Options.UseMode,
                    MainUI = Label.MainUI,
                    TabUI = Label.TabUI,
                    Hiding = Options.Hiding,
                    ToggleState = Label.State,
                    Flag = Options.Flag,
                    Callback = Options.Callback,
                    Count = #Label.ColorPickers + 1,
                })
                --
                return Keybind
            end
            --
            --[[function Label:Update()
                LabelText.Size = UDim2.new(LabelText.Size.X.Scale, LabelText.Size.X.Offset, 0, math.huge)
                LabelText.Size = UDim2.new(LabelText.Size.X.Scale, LabelText.Size.X.Offset, 0, LabelText.TextBounds.Y)
                PreviewLabel.Size = UDim2.new(PreviewLabel.Size.X.Scale, PreviewLabel.Size.X.Offset, 0, LabelName.TextBounds.Y + 6)
            end]]
        end
        --
        --Label:Update()
        --
        if Options.Hidden then
            Label:SetVisible(false)
        end
        --
        return Label
    end
    --
    function Library:TextBox(Options)
        Options = Library:Validate({
            Default = "",
            Name = "Preview TextBox",
            Max = 32,
            Parent = nil,
            Size = UDim2.new(1, 0, 0, 19),
            Position = UDim2.new(0, 0, 0, 0),
            NumbersOnly = false,
            ClearOnFocus = false,
            Hidden = false,
            TypedCheck = false,
            CheckIfPressedEnter = false,
            Risky = false,
            Flag = Library.NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local TextBox = {
            Focused = false,
            Hovering = false,
            Hiding = false,
        }
        --
        Library.Flags[Options.Flag] = TextBox
        --
        local PreviewTextBox = Library:CreateObject("Frame", {
            Name = "PreviewTextBox",
            BackgroundTransparency = 1,
            Size = Options.Size,
            Position = Options.Position,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local TextBoxOutline = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "TextBoxOutline",
            Position = UDim2.new(0, -1, 0, 0),
            Size = UDim2.new(1, -19, 0, 19),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewTextBox
        })
        --
        local TextBoxInline = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "TextBoxInline",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Parent = TextBoxOutline
        })
        --
        local TextBoxMain = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "TextBoxMain",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(24, 24, 24),
            Parent = TextBoxInline
        })
        --
        local TextBoxObject = Library:CreateObject("TextBox", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Library.Theme.Default.TextColor,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = "",
            ZIndex = 3,
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundTransparency = 1,
            SelectionStart = 1,
            ClearTextOnFocus = Options.ClearOnFocus,
            PlaceholderColor3 = Library.Theme.Default.TextColor,
            TextXAlignment = Enum.TextXAlignment.Left,
            PlaceholderText = "_",
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = TextBoxMain
        })
        --
        TextBox.Object = TextBoxObject
        --
        local UIPadding_6 = Library:CreateObject("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 5),
            Parent = TextBoxObject
        })
        --
        local UIPadding_7 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewTextBox
        })
        --
        do -- Functions
            function TextBox:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewTextBox]
                --
                TextBox.Hiding = not Bool
                TextBoxObject.Visible = Bool
                --
                if Bool then
                    Library.Objects[PreviewTextBox] = {PreviewTextBox, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewTextBox), PreviewTextBox, 0.075)
                Library:TweenObject(PreviewTextBox, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and Options.Size or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewTextBox] = {PreviewTextBox, OldValues[2], false}
                    end
                end)
            end
            --
            function TextBox:Get()
                return TextBoxObject.Text
            end
        end
        --
        do -- Connections
            Library:Connection(TextBoxObject:GetPropertyChangedSignal("Text"), function()
                TextBoxObject.Text = TextBoxObject.Text:sub(1, Options.Max)
                --
                if Options.NumbersOnly then
                    TextBoxObject.Text = TextBoxObject.Text:gsub('[^%d%.%-]+', '')
                end
                --
                if Options.TypedCheck then
                    Library.Flags[Options.Flag] = TextBox
                    Options.Callback(TextBoxObject.Text)
                end
                --
                TextBox.Focused = true
            end)
            --
            Library:Connection(TextBoxObject.Focused, function()
                if Library.UI.Faded then return end
                --
                if TextBox.Hiding then
                    TextBoxObject:ReleaseFocus()
                    --
                    return
                end
                --
                TextBox.Focused = true
                --
                TextBoxObject.TextColor3 = Library.Theme.Default.Accent
                --
                Library:AddTheme(TextBoxObject, {
                    TextColor3 = "Accent",
                })
                --
                TextBoxObject.PlaceholderText = ""
            end)
            --
            Library:Connection(TextBoxObject.FocusLost, function(EnterPressed)
                if Options.CheckIfPressedEnter and not EnterPressed then return end
                --
                TextBox.Focused = false
                TextBoxObject.PlaceholderText = "_"
                --
                TextBoxObject.TextColor3 = Library.Theme.Default.TextColor
                --
                Library:AddTheme(TextBoxObject, {
                    TextColor3 = "TextColor",
                })
                --
                Library.Flags[Options.Flag] = TextBox
                Options.Callback(TextBoxObject.Text)
            end)
        end
        --
        if Options.Hidden then
            TextBox:SetVisible(false)
        end
        --
        return TextBox
    end
    --
    function Library:List(Options)
        Options = Library:Validate({
            Size = 100,
            Hidden = false,
            Flag = Library.NewFlag(),
            Callback = function() end
        }, Options or {})
        --
        local List = {
            CurrentValue = nil,
            CurrentValueName = nil,
        }
        --
        Library.Flags[Options.Flag] = List
        --
        local PreviewList = Library:CreateObject("Frame", {
            Name = "PreviewList",
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Options.Size),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local UIPadding_11 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewList
        })
        --
        local ListOutline = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -19, 1, -18),
            Name = "ListOutline",
            Position = UDim2.new(0, -1, 0, 18),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewList
        })
        --
        local ListMain = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ListMain",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 4,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            Parent = ListOutline
        })
        --
        local DownArrow = Library:CreateObject("ImageButton", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "DownArrow",
            Image = "rbxassetid://15540867448",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -10, 1, -9),
            Size = UDim2.new(0, 5, 0, 4),
            ZIndex = 7,
            Visible = false,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ListMain
        })
        --
        local UpArrow = Library:CreateObject("ImageButton", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "UpArrow",
            Image = "rbxassetid://15540851994",
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -10, 0, 5),
            Size = UDim2.new(0, 5, 0, 4),
            ZIndex = 7,
            Visible = false,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ListMain
        })
        --
        local ListScrolling = Library:CreateObject("ScrollingFrame", {
            ScrollBarImageColor3 = Color3.fromRGB(65, 65, 65),
            MidImage = "rbxassetid://158362264",
            Active = true,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ScrollBarThickness = 5,
            Name = "ListScrolling",
            ZIndex = 3,
            TopImage = "rbxassetid://158362264",
            Position = UDim2.new(0, 1, 0, 1),
            Size = UDim2.new(1, -2, 1, -2),
            BottomImage = "rbxassetid://158362264",
            BorderSizePixel = 0,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            CanvasPosition = Vector2.new(0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Parent = ListOutline
        })
        --
        local UIListLayout_2 = Library:CreateObject("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ListScrolling
        })
        --
        local TextBox = Library:TextBox({Parent = PreviewList, TypedCheck = true, Size = UDim2.new(1, 20, 0, 19), Position = UDim2.new(0, -20, 0, 0), Callback = function(Text)
            List:UpdateSection()
            --
            for _, Frame in ListScrolling:GetChildren() do
                if Frame:IsA("Frame") then
                    Frame.Visible = string.find(Frame.Name:lower(), Text:lower()) and true or false
                end
            end
        end})
        --
        do -- Functions
            function List:Get()
                return List.CurrentValueName
            end
            --
            function List:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewList]
                --
                TextBox.Object.Visible = Bool
                --
                if Bool then
                    Library.Objects[PreviewList] = {PreviewList, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewList, false), PreviewList, 0.075)
                Library:TweenObject(PreviewList, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and UDim2.new(1, 0, 0, Options.Size) or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewList] = {PreviewList, OldValues[2], false}
                    end
                end)
            end
            --
            function List:AddValue(Value, Icon)
                if ListScrolling:FindFirstChild(Value) then return end
                --
                local ListValue = {
                    Active = false,
                    Hovering = false,
                }
                --
                local InactiveValue = Library:CreateObject("Frame", {
                    Name = Value .. "1",
                    Size = UDim2.new(1, 0, 0, 20),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 5,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = ListScrolling
                })
                --
                local Button_912 = Library:CreateObject("TextButton", {
                    FontFace = Library.UI.NewFont,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_9",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = InactiveValue
                })
                --
                local ValueName_1 = Library:CreateObject("TextLabel", {
                    FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                    TextColor3 = Color3.fromRGB(208, 208, 208),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "ValueName_1",
                    BorderSizePixel = 0,
                    Text = Value,
                    RichText = true,
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, 0, 1, 0),
                    ZIndex = 5,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = InactiveValue
                })
                --
                if Icon then
                    local Color = Icon.Color or Color3.fromRGB(255, 255, 255)
                    --
                    local IconImage = Library:CreateObject("ImageLabel", {
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Image = Icon.Image,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = Icon.Position or UDim2.new(0, 7, 0.5, 0),
                        BackgroundTransparency = 1,
                        Name = "BackImage",
                        Size = Icon.Size or UDim2.new(0, 13, 0, 13),
                        ZIndex = 5,
                        BorderSizePixel = 0,
                        ImageColor3 = Color,
                        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                        Parent = InactiveValue
                    })
                    --
                    local UIPadding_135 = Library:CreateObject("UIPadding", {
                        PaddingLeft = UDim.new(0, 10),
                        Parent = IconImage
                    })
                end
                --
                ValueName_1.Text = Library:ClampString(Value, ValueName_1.AbsoluteSize.X - 25)
                --
                local UIPadding_13 = Library:CreateObject("UIPadding", {
                    PaddingLeft = UDim.new(0, (Icon and 25 or 10)),
                    Parent = ValueName_1
                })
                --
                do -- Functions
                    function ListValue:Activate()
                        if not ListValue.Active then
                            --
                            if List.CurrentValue then
                                List.CurrentValue:Deactivate()
                            end
                            --
                            ListValue.Active = true
                            --
                            ValueName_1.TextColor3 = Library.Theme.Default.Accent
                            ValueName_1.Text = "<b>" .. Value .. "</b>"
                            --
                            Library:AddTheme(ValueName_1, {
                                TextColor3 = "Accent",
                            })
                            --
                            List.CurrentValue = ListValue
                            List.CurrentValueName = Value
                            Library.Flags[Options.Flag] = List
                            Options.Callback(Value)
                        end
                    end
                    --
                    function ListValue:Deactivate()
                        if ListValue.Active then
                            ListValue.Active = false
                            ListValue.Hovering = false
                            ValueName_1.TextColor3 = Library.Theme.Default.TextColor
                            --
                            Library:AddTheme(ValueName_1, {
                                TextColor3 = "TextColor",
                            })
                        end
                    end
                end
                --
                do -- Connections
                    local OldText = ValueName_1.Text
                    --
                    Library:Connection(PreviewList:GetPropertyChangedSignal("AbsoluteSize"), function()
                        ValueName_1.Text = Library:ClampString(Value, ValueName_1.AbsoluteSize.X - 25)
                    end)
                    --
                    Library:Connection(InactiveValue.MouseEnter, function()
                        if Library.UI.Faded then return end
                        --
                        InactiveValue.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                        OldText = ValueName_1.Text
                        --
                        if not ListValue.Active then
                            ValueName_1.Text = "<b>" .. OldText .. "</b>"
                        end
                    end)
                    --
                    Library:Connection(InactiveValue.MouseLeave, function()
                        if Library.UI.Faded then return end
                        --
                        InactiveValue.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        --
                        if not ListValue.Active then
                            ValueName_1.Text = OldText
                        end
                    end)
                    --
                    Library:Connection(Button_912.MouseButton1Click, function()
                        if Library.UI.Faded then return end
                        --
                        ListValue:Activate()
                    end)
                end
            end
            --
            function List:RemoveValue(Value)
                for _, Object in ListScrolling:GetChildren() do
                    if Object.Name == Value .. "1" then
                        Object:Destroy()
                    end
                end
            end
            --
            function List:UpdateSection()
                local CanvasSize = ListScrolling.AbsoluteCanvasSize.Y
                local AbsoluteSize = ListMain.AbsoluteSize.Y
                --
                if CanvasSize > AbsoluteSize then
                    ListMain.Size = UDim2.new(1, -8, 1, -2)
                    UpArrow.Visible = not List:CheckArrows("Up")
                    DownArrow.Visible = not List:CheckArrows("Down")
                elseif CanvasSize == AbsoluteSize then
                    ListMain.Size = UDim2.new(1, -2, 1, -2)
                    UpArrow.Visible = false
                    DownArrow.Visible = false
                end
            end
            --
            function List:CheckArrows(Type)
                if Type == "Up" then
                    return ListScrolling.CanvasPosition == Vector2.new(0, 0)
                elseif Type == "Down" then
                    return ListScrolling.CanvasPosition == Vector2.new(0, ListScrolling.AbsoluteCanvasSize.Y - ListScrolling.AbsoluteSize.Y)
                else
                    return false
                end
            end
        end
        --
        List:UpdateSection()
        --
        do -- Connections
            Library:Connection(ListScrolling.ChildAdded, function()
                List:UpdateSection()
            end)
            --
            Library:Connection(ListScrolling.ChildRemoved, function()
                List:UpdateSection()
            end)
            --
            Library:Connection(ListOutline:GetPropertyChangedSignal("AbsoluteSize"), function()
                List:UpdateSection()
            end)
            --
            Library:Connection(ListScrolling:GetPropertyChangedSignal("AbsoluteSize"), function()
                List:UpdateSection()
            end)
            --
            Library:Connection(ListScrolling:GetPropertyChangedSignal("CanvasPosition"), function()
                List:UpdateSection()
            end)
            --
            Library:Connection(UpArrow.MouseButton1Click, function()
                if Library.UI.Faded then return end
                --
                if not UpArrow.Visible then return end
                --
                Library:TweenObject(ListScrolling, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, 0)})
            end)
            --
            Library:Connection(DownArrow.MouseButton1Click, function()
                if Library.UI.Faded then return end
                --
                if not DownArrow.Visible then return end
                --
                Library:TweenObject(ListScrolling, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, ListScrolling.AbsoluteCanvasSize.Y - ListScrolling.AbsoluteSize.Y)})
            end)
        end
        --
        if Options.Hidden then
            List:SetVisible(false)
        end
        --
        return List
    end
    --
    function Library:Button(Options)
        Options = Library:Validate({
            Name = "Preview Button",
            Confirmation = false,
            Parent = nil,
            Hidden = false,
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 0, 0, 0),
            Risky = false,
            Callback = function() end
        }, Options or {})
        --
        local Button = {
            MouseDown = false,
            Hovering = false,
            WaitingForConfirm = false,
            Hiding = false,
            ConfirmationTime = 0,
            ConfirmationConnection = nil,
        }
        --
        local PreviewButton = Library:CreateObject("Frame", {
            Name = "PreviewButton",
            BackgroundTransparency = 1,
            Size = Options.Size,
            Position = Options.Position,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Options.Parent
        })
        --
        local ButtonOutline = Library:CreateObject("Frame", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "ButtonOutline",
            Position = UDim2.new(0, -1, 0, 0),
            Size = UDim2.new(1, -19, 0, 25),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = PreviewButton
        })
        --
        local ButtonInline = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ButtonInline",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(50, 50, 50),
            Parent = ButtonOutline
        })
        --
        local ButtonMain_1 = Library:CreateObject("Frame", {
            Size = UDim2.new(1, -2, 1, -2),
            Name = "ButtonMain_1",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(220, 220, 220),
            Parent = ButtonInline
        })
        --
        local UIGradient_4 = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 39, 39)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
            },
            Parent = ButtonMain_1
        })
        --
        local Button_6 = Library:CreateObject("TextButton", {
            FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
            TextColor3 = Options.Risky and Library.Theme.Default.Risky or Library.Theme.Default.TextColor,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button_6",
            RichText = true,
            Text = "<b>" .. Options.Name .. "</b>",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 1, 0),
            ZIndex = 3,
            TextSize = Library.UI.FontSize,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = ButtonOutline
        })
        --
        if Options.Risky then
            Library:AddTheme(Button_6, {
                TextColor3 = "Risky",
            })
        end
        --
        local UIPadding_8 = Library:CreateObject("UIPadding", {
            PaddingLeft = UDim.new(0, 20),
            Parent = PreviewButton
        })
        --
        do -- Functions
            function Button:UpdateSize(Size)
                ButtonOutline.Size = Size
            end
            --
            function Button:UpdatePosition(Position)
                PreviewButton.Position = Position
            end
            --
            function Button:SetVisible(Bool)
                local OldValues = Library.Objects[PreviewButton]
                --
                Button.Hiding = not Bool
                --
                if Bool then
                    Library.Objects[PreviewButton] = {PreviewButton, OldValues[2], true}
                end
                --
                Library:Fade(Bool, Library:GetObjectsTable(PreviewButton), PreviewButton, 0.075)
                Library:TweenObject(PreviewButton, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = Bool and Options.Size or UDim2.new(1, 0, 0, -10)}, function()
                    if not Bool then
                        Library.Objects[PreviewButton] = {PreviewButton, OldValues[2], false}
                    end
                end)
            end
            --
            function Button:ConfirmationStart()
                Button.MouseDown = true
                Button.WaitingForConfirm = true
                Button.ConfirmationTime = 3
                Button_6.Text = "<b>Are you sure?</b>"
                --
                if Button.ConfirmationConnection then
                    coroutine.close(Button.ConfirmationConnection)
                    Button.ConfirmationConnection = nil
                end
                --
                Button.ConfirmationConnection = coroutine.create(function()
                    for i = 1, 3 do 
                        task.wait(1)
                        --
                        Button.ConfirmationTime = Button.ConfirmationTime - 1
                        --
                        if Button.ConfirmationTime <= 0 then
                            Button_6.Text = "<b>" .. Options.Name .. "</b>"
                            --
                            if Button.MouseDown then
                                Library:TweenObject(Button_6, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextColor3 = Library.Theme.Default.TextColor})
                                --
                                Button.MouseDown = false
                                Button.WaitingForConfirm = false
                            end
                            --
                            break
                        end
                    end
                end)
                --
                coroutine.resume(Button.ConfirmationConnection)
            end
        end
        --
        do -- Connections
            Library:Connection(Button_6.MouseButton1Down, function()
                if Library.UI.Faded then return end
                --
                if Button.Hiding then return end
                --
                Library:TweenObject(ButtonMain_1, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(180, 180, 180)})
                --
                if Options.Confirmation then
                    if not Button.WaitingForConfirm then
                        Button:ConfirmationStart()
                    else
                        if Button.ConfirmationConnection then
                            coroutine.close(Button.ConfirmationConnection)
                            Button.ConfirmationConnection = nil
                        end
                        --
                        Options.Callback()
                        Button.MouseDown = true
                        Button.Hovering = false
                        Button.WaitingForConfirm = false
                        --
                        Library:TweenObject(ButtonMain_1, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(180, 180, 180)})
                        --
                        Button_6.Text = "<b>" .. Options.Name .. "</b>"
                    end
                else
                    Options.Callback()
                    Button.MouseDown = true
                end
            end)
            --
            Library:Connection(UserInputService.InputEnded, function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1 and Button.MouseDown and not Button.WaitingForConfirm then
                    Button.Hovering = false
                    Button.MouseDown = false
                end
                --
                Library:TweenObject(ButtonMain_1, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
            end)
            --
            Library:Connection(ButtonOutline.MouseEnter, function()
                if Library.UI.Faded then return end
                --
                if not Button.MouseDown then
                    Button.Hovering = true
                    Library:TweenObject(ButtonMain_1, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)})
                end	
            end)
            --
            Library:Connection(ButtonOutline.MouseLeave, function()
                if Library.UI.Faded then return end
                --
                if not Button.MouseDown then
                    Button.Hovering = false
                    Library:TweenObject(ButtonMain_1, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(220, 220, 220)})
                end	
            end)
        end
        --
        if Options.Hidden then
            Button:SetVisible(false)
        end
        --
        return Button
    end
    --
    function Library:Window(Options)
        Options = Library:Validate({
            Name = "gamesense",
            Size = UDim2.new(0, 700, 0, 612),
            MinResize = UDim2.new(0, 500, 0, 400),
            MaxResize = UDim2.new(0, 10000, 0, 10000),
            CloseBind = Enum.KeyCode.Insert,
        }, Options or {})
        --
        local Window = {
            Visible = true,
            CurrentTab = nil,
            Tabs = {},
        }
        --
        local MainUI = Library:CreateObject("ScreenGui", {
            ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
            DisplayOrder = 1000,
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            Name = "\0",
            Parent = gethui()
        })
        --
        Library.UI.ScreenGUI = MainUI
        --
        local Outline = Library:CreateObject("Frame", {
            Name = "Outline",
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = Options.Size,
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            Parent = MainUI
        })
        --
        Outline:SetAttribute("g", Window.CurrentTab)
        Library.UI.MainUI = Outline
        --
        Outline.Position = UDim2.fromOffset((Viewport.X / 2) - (Outline.Size.X.Offset / 2), (Viewport.Y / 2) - (Outline.Size.Y.Offset / 2))
        Outline.Active = true
        Outline.Draggable = true
        --
        local Inline = Library:CreateObject("Frame", {
            Name = "Inline",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            Parent = Outline
        })
        --
        local Inner = Library:CreateObject("Frame", {
            Name = "Inner",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Parent = Inline
        })
        --
        local Outline_1 = Library:CreateObject("Frame", {
            Name = "Outline_1",
            Position = UDim2.new(0, 3, 0, 3),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -6, 1, -6),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(60, 60, 60),
            Parent = Inner
        })
        --
        local PatternHolder = Library:CreateObject("Frame", {
            Name = "PatternHolder",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            Parent = Outline_1
        })
        --
        local Pattern = Library:CreateObject("ImageLabel", {
            ImageColor3 = Color3.fromRGB(12, 12, 12),
            ScaleType = Enum.ScaleType.Tile,
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Image = "rbxassetid://8547666218",
            BackgroundTransparency = 1,
            Name = "Pattern",
            Size = UDim2.new(1, 0, 1, 0),
            TileSize = UDim2.new(0, 8, 0, 8),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = PatternHolder
        })
        --
        local TopBarGradientHolder = Library:CreateObject("Frame", {
            Name = "TopBarGradientHolder",
            Position = UDim2.new(0, 1, 0, 1),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, -2, 0, 4),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Outline_1
        })
        --
        local GradientBar = Library:CreateObject("ImageLabel", {
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Image = "rbxassetid://8508019876",
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 1, 0, 1),
            Name = "GradientBar",
            Size = UDim2.new(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = TopBarGradientHolder
        })
        --
        local UIGradient = Library:CreateObject("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0.550000011920929)
            },
            Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 12)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
            },
            Parent = TopBarGradientHolder
        })
        --
        local SideBarMain = Library:CreateObject("Frame", {
            Name = "SideBarMain",
            Position = UDim2.new(0, 1, 0, 5),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(0, 75, 1, -6),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
            ClipsDescendants = true,
            Parent = Outline_1
        })
        --
        local Outline_2 = Library:CreateObject("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            Name = "Outline_2",
            Position = UDim2.new(1, 0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(0, 1, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            Parent = SideBarMain
        })
        --
        local Holder = Library:CreateObject("Frame", {
            BackgroundTransparency = 1,
            Name = "Holder",
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = SideBarMain
        })
        --
        local UIListLayout = Library:CreateObject("UIListLayout", {
            Padding = UDim.new(0, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Holder
        })
        --
        local UIPadding = Library:CreateObject("UIPadding", {
            PaddingTop = UDim.new(0, 10),
            Parent = Holder
        })
        --
        local Inline_4 = Library:CreateObject("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            Name = "Inline_4",
            Position = UDim2.new(1, -1, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Size = UDim2.new(0, 1, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            Parent = SideBarMain
        })
        --
        local ResizeButton = Library:CreateObject("TextButton", {
            FontFace = Library.UI.NewFont,
            TextColor3 = Color3.fromRGB(0, 0, 0),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Name = "Button",
            AnchorPoint = Vector2.new(1, 1),
            Size = UDim2.new(0, 20, 0, 20),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, 0, 1, 0),
            BorderSizePixel = 0,
            TextTransparency = 1,
            TextSize = Library.UI.FontSize,
            ZIndex = 5,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            Parent = Outline
        })
        --
        do -- Functions
            function Window:SetTab(Number)
                for Index, Tab in Window.Tabs do
                    if Index == Number then
                        if Window.CurrentTab ~= nil then
                            Window.CurrentTab:Deactivate()
                        end
                        --
                        Tab:Activate()
                    end
                end
            end
        end
        --
        do -- Connections
            Library:Connection(UserInputService.InputBegan, function(Input)
                if Input.KeyCode == Library.UI.CloseBind then
                    Window.Visible = not Window.Visible
                    --
                    Library:Fade(Window.Visible, Library.Objects, Outline, 0.2)
                    --
                    if Window.Visible then
                        for Index, Value in Library.Flags do
                            if Value.Color and Value.Alpha and Value.Alpha > 0 then
                                if Value.Update then
                                    Value:Update()
                                end
                            end
                        end
                    end
                end
            end)
            --
            Library:Resizable(Outline, ResizeButton, Options.MinResize, Options.MaxResize)
        end
        --
        function Window:CreateTab(Options)
            Options = Library:Validate({
                Icon = "rbxassetid://8547236654",
            }, Options or {})
            --
            local Tab = {
                Hovering = false,
                Active = false,
                Index = Library.UI.TabIndex + 1,
                SubSectionEnabled = false,
                DropdownSectionEnabled = false,
                Position = "Bottom",
                Sides = {
                    Left = {
                        Sections = {},
                        Sizes = 0,
                    },
                    Right = {
                        Sections = {},
                        Sizes = 0,
                    }
                }
            }
            --
            Library.UI.TabIndex = Tab.Index
            --
            local TabActive = Library:CreateObject("Frame", {
                BackgroundTransparency = 1,
                Name = "TabActive",
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, -2, 0, 64),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = Holder
            })
            --
            local Outline_3 = Library:CreateObject("Frame", {
                Name = "Outline_3",
                Size = UDim2.new(1, 0, 1, 0),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Visible = false,
                Parent = TabActive
            })
            --
            local Inline_1 = Library:CreateObject("Frame", {
                Size = UDim2.new(1, 1, 1, -2),
                Name = "Inline_1",
                Position = UDim2.new(0, 0, 0, 1),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                Parent = Outline_3
            })
            --
            local Main = Library:CreateObject("Frame", {
                Size = UDim2.new(1, 1, 1, -2),
                Name = "Main",
                Position = UDim2.new(0, 0, 0, 1),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(20, 20, 20),
                Parent = Inline_1
            })
            --
            local Pattern_1 = Library:CreateObject("ImageLabel", {
                ImageColor3 = Color3.fromRGB(12, 12, 12),
                ScaleType = Enum.ScaleType.Tile,
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Name = "Pattern_1",
                Image = "rbxassetid://8547666218",
                BackgroundTransparency = 1,
                TileSize = UDim2.new(0, 8, 0, 8),
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 2,
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Parent = Main
            })
            --
            local Button = Library:CreateObject("TextButton", {
                FontFace = Font.new("rbxasset://fonts/families/Zekton.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Name = "Button",
                Text = Options.Icon,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                TextColor3 = Color3.fromRGB(90, 90, 90),
                BorderSizePixel = 0,
                TextTransparency = 1,
                TextSize = Library.UI.FontSize,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = TabActive
            })
            --
            local Icon = Library:CreateObject("ImageLabel", {
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Name = "Button",
                Image = Options.Icon,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                ImageColor3 = Color3.fromRGB(109, 109, 109),
                BorderSizePixel = 0,
                ZIndex = 3,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = TabActive
            })
            --
            local SectionsHolder = Library:CreateObject("Frame", {
                Name = "SectionsHolder",
                BackgroundTransparency = 1,
                Visible = true,
                Position = UDim2.new(0, 76, 0, 5),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, -78, 1, -6),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ClipsDescendants = true,
                Parent = Outline_1
            })
            --
            local Left = Library:CreateObject("Frame", {
                BackgroundTransparency = 1,
                Name = "Left",
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 1, 0, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ClipsDescendants = true,
                Parent = SectionsHolder
            })
            --
            local UIPadding_1 = Library:CreateObject("UIPadding", {
                PaddingTop = UDim.new(0, 19),
                PaddingBottom = UDim.new(0, 19),
                PaddingRight = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 21),
                Parent = Left
            })
            --
            local UIListLayout12 = Library:CreateObject("UIListLayout", {
                Padding = UDim.new(0, 19),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Left
            })
            --
            local Right = Library:CreateObject("Frame", {
                Name = "Right",
                BackgroundTransparency = 1,
                Position = UDim2.new(0.5, 1, 0, 0),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0.5, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ClipsDescendants = true,
                Parent = SectionsHolder
            })
            --
            local UIPadding_2 = Library:CreateObject("UIPadding", {
                PaddingTop = UDim.new(0, 19),
                PaddingBottom = UDim.new(0, 19),
                PaddingRight = UDim.new(0, 19),
                PaddingLeft = UDim.new(0, 10),
                Parent = Right
            })
            --
            local UIListLayout52 = Library:CreateObject("UIListLayout", {
                Padding = UDim.new(0, 19),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = Right
            })
            --
            local SectionsHolder2 = Library:CreateObject("Frame", {
                Name = "SectionsHolder",
                BackgroundTransparency = 1,
                Visible = true,
                Position = UDim2.new(0, 76, 0, 5),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, -78, 1, -6),
                BorderSizePixel = 0,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                ClipsDescendants = true,
                Parent = Outline_1
            })
            --
            local SubSectionHolder = Library:CreateObject("Frame", {
                Name = "SubSectionHolder",
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(1, -39, 0, 61),
                BorderSizePixel = 0,
                ZIndex = 1,
                Visible = false,
                BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                Parent = SectionsHolder2
            })
            --
            Left.Position = UDim2.new(0, 0, 0, Left.AbsoluteSize.Y)
            Right.Position = UDim2.new(0.5, 1, 0, Right.AbsoluteSize.Y)
            SubSectionHolder.Position = UDim2.new(0, 21, 0, SectionsHolder2.AbsoluteSize.Y + SubSectionHolder.AbsoluteSize.Y)
            --
            do -- Functions
                function Tab:MoveSides(State)
                    task.spawn(function()
                        if State then
                            if Tab.Position == "Bottom" then
                                Left.Position = UDim2.new(0, 0, 0, Left.AbsoluteSize.Y)
                                Right.Position = UDim2.new(0.5, 1, 0, Right.AbsoluteSize.Y)
                                SubSectionHolder.Position = UDim2.new(0, 21, 0, SectionsHolder2.AbsoluteSize.Y + SubSectionHolder.AbsoluteSize.Y)
                            else
                                Left.Position = UDim2.new(0, 0, 0, -Left.AbsoluteSize.Y)
                                Right.Position = UDim2.new(0.5, 1, 0, -Right.AbsoluteSize.Y)
                                SubSectionHolder.Position = UDim2.new(0, 21, 0, -(SectionsHolder2.AbsoluteSize.Y + SubSectionHolder.AbsoluteSize.Y))
                            end
                            --
                            Library:TweenObject(SubSectionHolder, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 21, 0, 19)})
                            Library:TweenObject(Left, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
                            Library:TweenObject(Right, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 1, 0, 0)})
                        else
                            task.wait(0.001)
                            --
                            local SubSectionPosition = Tab.Position == "Bottom" and SectionsHolder2.AbsoluteSize.Y + 10 or -SectionsHolder2.AbsoluteSize.Y
                            local LeftPosition = Tab.Position == "Bottom" and Left.AbsoluteSize.Y + 10 or -Left.AbsoluteSize.Y
                            local RightPosition = Tab.Position == "Bottom" and Right.AbsoluteSize.Y + 10 or -Right.AbsoluteSize.Y
                            --
                            Library:TweenObject(SubSectionHolder, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 21, 0, SubSectionPosition)})
                            Library:TweenObject(Left, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, LeftPosition)})
                            Library:TweenObject(Right, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 1, 0, RightPosition)})
                        end
                    end)
                end
                --
                function Tab:Activate()
                    if not Tab.Active then
                        --
                        if Window.CurrentTab ~= nil then
                            Window.CurrentTab:Deactivate()
                        end
                        --
                        Tab.Active = true
                        Tab:MoveSides(true)
                        --
                        Library:TweenObject(Icon, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(210, 210, 210)})
                        Outline_3.Visible = true
                        --
                        Window.CurrentTab = Tab
                        Outline:SetAttribute("g", table.find(Window.Tabs, Tab))
                    end
                end
                --
                function Tab:Deactivate()
                    if Tab.Active then
                        Tab.Active = false
                        Tab.Hovering = false
                        Outline_3.Visible = false
                        Library:TweenObject(Icon, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(90, 90, 90)})
                        --
                        Tab:MoveSides(false)
                    end
                end
            end
            --
            do -- Connections
                Library:Connection(Outline:GetAttributeChangedSignal("g"), function()
                    if Outline:GetAttribute("g") > Tab.Index then
                        Tab.Position = "Top"
                    elseif Outline:GetAttribute("g") < Tab.Index then
                        Tab.Position = "Bottom"
                    end
                end)
                --
                Library:Connection(Outline:GetPropertyChangedSignal("AbsoluteSize"), function()
                    if not Tab.Active then
                        SubSectionHolder.Position = UDim2.new(0, 21, 0, SectionsHolder2.AbsoluteSize.Y + SubSectionHolder.AbsoluteSize.Y)
                        Left.Position = UDim2.new(0, 0, 0, Left.AbsoluteSize.Y)
                        Right.Position = UDim2.new(0.5, 1, 0, Right.AbsoluteSize.Y)
                    else
                        Left.Position = UDim2.new(0, 0, 0, 0)
                        Right.Position = UDim2.new(0.5, 1, 0, 0)
                    end
                end)
                --
                Library:Connection(Button.MouseButton1Click, function()
                    Tab:Activate()
                end)
                --
                Library:Connection(TabActive.MouseEnter, function()
                    if not Tab.Active then
                        Tab.Hovering = true
                        Library:TweenObject(Icon, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(168, 168, 168)})
                    end
                end)
                --
                Library:Connection(TabActive.MouseLeave, function()
                    if not Tab.Active then
                        Tab.Hovering = false
                        Library:TweenObject(Icon, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageColor3 = Color3.fromRGB(90, 90, 90)})
                    end
                end)
            end
            --
            Window.Tabs[#Window.Tabs + 1] = Tab
            --
            function Tab:Section(Options)
                Options = Library:Validate({
                    Name = "Preview Section",
                    Side = "Left",
                    Fill = false,
                    Size = UDim2.new(1, 0, 0, 40),
                    ParentOptions = {},
                    Icon = nil,
                    Parent = nil,
                }, Options or {})
                --
                local Section = {
                    Elements = {},
                    SizeButton = nil,
                    Hovering = false,
                    DragConnection = nil,
                    Left = {
                        Order = 1,
                    },
                    Right = {
                        Order = 1,
                    },
                }
                --
                local Parent = Options.Side == "Left" and Left or Right
                --
                local SectionOutline = Library:CreateObject("Frame", {
                    Name = "SectionOutline",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, Options.Size),
                    AutomaticSize = Options.Fill and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
                    BorderSizePixel = 0,
                    ZIndex = 1,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Options.Parent or Parent
                })
                --
                table.insert(Tab.Sides[Options.Side].Sections, SectionOutline)
                --
                task.delay(0.01, function()
                    if Options.Fill == false then
                        Tab.Sides[Options.Side].Sizes += SectionOutline.AbsoluteSize.Y + 19
                    end
                    --
                    if Options.Fill then
                        SectionOutline.Size = UDim2.new(1, 0, 1, -(Tab.Sides[Options.Side].Sizes))
                    else
                        SectionOutline.Size = UDim2.new(1, 0, 0, Options.Size)
                    end
                end)
                --
                local SectionInline = Library:CreateObject("Frame", {
                    Name = "SectionInline",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    Parent = SectionOutline
                })
                --
                local SectionScrolling = Library:CreateObject("ScrollingFrame", {
                    ScrollBarImageColor3 = Color3.fromRGB(65, 65, 65),
                    MidImage = "rbxassetid://158362264",
                    Active = true,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ScrollBarThickness = 5,
                    Size = UDim2.new(1, -2, 1, -2),
                    TopImage = "rbxassetid://158362264",
                    Position = UDim2.new(0, 1, 0, 1),
                    CanvasSize = UDim2.new(0, 0, 0, 0),
                    CanvasPosition = Vector2.new(0, 0),
                    BottomImage = "rbxassetid://158362264",
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    AutomaticCanvasSize = Enum.AutomaticSize.Y,
                    Parent = SectionInline
                })
                --
                local UIListLayout_3 = Library:CreateObject("UIListLayout", {
                    Padding = UDim.new(0, 10),
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = SectionScrolling
                })
                --
                local UIPadding_8 = Library:CreateObject("UIPadding", {
                    PaddingTop = UDim.new(0, 19),
                    PaddingBottom = UDim.new(0, 10),
                    PaddingRight = UDim.new(0, 18),
                    PaddingLeft = UDim.new(0, 18),
                    Parent = SectionScrolling
                })
                --
                local SectionMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "SectionMain_1",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 1,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
                    Parent = SectionInline
                })
                --
                local SectionFader = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, 0, 0, 20),
                    AnchorPoint = Vector2.new(0, 1),
                    Name = "SectionFader",
                    Position = UDim2.new(0, 0, 1, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
                    Parent = SectionMain
                })
                --
                local DownArrow = Library:CreateObject("ImageButton", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "DownArrow",
                    Image = "rbxassetid://15540867448",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -10, 1, -9),
                    Size = UDim2.new(0, 5, 0, 4),
                    ZIndex = 4,
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = SectionMain
                })
                --
                local UpArrow = Library:CreateObject("ImageButton", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "UpArrow",
                    Image = "rbxassetid://15540851994",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -10, 0, 5),
                    Size = UDim2.new(0, 5, 0, 4),
                    ZIndex = 4,
                    BorderSizePixel = 0,
                    Visible = false,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = SectionMain
                })
                --
                local UIGradient = Library:CreateObject("UIGradient", {
                    Rotation = -90,
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1)
                    },
                    Parent = SectionFader
                })
                --
                local SectionFader2 = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, 0, 0, 20),
                    Name = "SectionFader",
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 3,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
                    Parent = SectionMain
                })
                --
                local UIGradient = Library:CreateObject("UIGradient", {
                    Rotation = 90,
                    Transparency = NumberSequence.new{
                        NumberSequenceKeypoint.new(0, 0),
                        NumberSequenceKeypoint.new(1, 1)
                    },
                    Parent = SectionFader2
                })
                --
                local TitleInline = Library:CreateObject("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "TitleInline",
                    BorderSizePixel = 0,
                    Parent = SectionOutline,
                    Position = UDim2.new(0, 9, 0, 0),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 5
                })
                --
                local UIGradient2 = Library:CreateObject("UIGradient", {
                    Rotation = 90,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 19, 19)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 24))
                    },
                    Parent = TitleInline
                })
                --
                local Title = Library:CreateObject("TextButton", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Parent = SectionOutline,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -26, 0, 15),
                    ZIndex = 5,
                    FontFace = Library.UI.NewFont,
                    RichText = true,
                    Text = "<b>" .. Options.Name .. "</b>",
                    TextColor3 = Color3.fromRGB(198, 198, 198),
                    TextSize = Library.UI.FontSize,
                    TextStrokeTransparency = 1,
                    TextXAlignment = "Left"
                })
                --
                local ResizableButton_6 = Library:CreateObject("ImageButton", {
                    ImageColor3 = Color3.fromRGB(40, 40, 40),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    AnchorPoint = Vector2.new(1, 1),
                    Image = "http://www.roblox.com/asset/?id=127012144286347",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -2, 1, -2),
                    Name = "ResizableButton_6",
                    Size = UDim2.new(0, 6, 0, 6),
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = SectionOutline
                })
                --
                Section.Elements = {
                    Name = Title,
                    ContentHolder = SectionScrolling,
                }
                --
                Title.Size = UDim2.fromOffset(Title.TextBounds.X, 15)
                TitleInline.Size = UDim2.new(0, Title.TextBounds.X + 6, 0, 2)
                --
                do -- Functions
                    function Section:UpdateSection()
                        local CanvasSizeFloored = math.floor(SectionScrolling.AbsoluteCanvasSize.Y)
                        local AbsoluteSizeFloored = math.floor(SectionMain.AbsoluteSize.Y)
                        --
                        if CanvasSizeFloored > AbsoluteSizeFloored then
                            SectionMain.Size = UDim2.new(1, -8, 1, -2)
                            UpArrow.Visible = not Section:CheckArrows("Up")
                            DownArrow.Visible = not Section:CheckArrows("Down")
                        elseif CanvasSizeFloored == AbsoluteSizeFloored then
                            SectionMain.Size = UDim2.new(1, -2, 1, -2)
                            UpArrow.Visible = false
                            DownArrow.Visible = false
                        end
                    end
                    --
                    function Section:CheckArrows(Type)
                        if Type == "Up" then
                            return SectionScrolling.CanvasPosition == Vector2.new(0, 0)
                        elseif Type == "Down" then
                            return SectionScrolling.CanvasPosition == Vector2.new(0, SectionScrolling.AbsoluteCanvasSize.Y - SectionScrolling.AbsoluteSize.Y)
                        else
                            return false
                        end
                    end
                    --
                    function Section:CalculateHeight(Section, Container)
                        local Padding = 10
                        local Height = 0
                        --
                        for _, Child in Container:GetChildren() do
                            if Child:IsA("GuiObject") and Child.Visible then
                                Height = Height + Child.AbsoluteSize.Y + Padding
                            end
                        end
                        --
                        Section.Size = UDim2.new(Section.Size.X.Scale, Section.Size.X.Offset, 0, math.clamp(Height + 31, 50, SectionOutline.Parent.AbsoluteSize.Y))
                    end
                    --
                    function Section:CalculateButton(Position)
                        if Section.SizeButton then return end
                        --
                        local ButtonOutline = Library:CreateObject("Frame", {
                            Name = "SectionOutline",
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            Size = UDim2.new(0, 30, 0, 25),
                            BorderSizePixel = 0,
                            Position = Position,
                            ZIndex = 5,
                            BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                            Parent = Library.UI.ScreenGUI
                        })
                        --
                        local ButtonMain = Library:CreateObject("Frame", {
                            Size = UDim2.new(1, -2, 1, -2),
                            Name = "SectionMain_1",
                            Position = UDim2.new(0, 1, 0, 1),
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            ZIndex = 5,
                            BorderSizePixel = 0,
                            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                            Parent = ButtonOutline
                        })
                        --
                        local ButtonText = Library:CreateObject("TextLabel", {
                            AnchorPoint = Vector2.new(0, 0.5),
                            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                            BackgroundTransparency = 1,
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            BorderSizePixel = 0,
                            Parent = ButtonOutline,
                            Position = UDim2.new(0, 0, 0.5, -1),
                            Size = UDim2.new(1, 0, 1, 0),
                            ZIndex = 5,
                            FontFace = Library.UI.NewFont,
                            RichText = true,
                            Text = "Calculate height",
                            TextColor3 = Color3.fromRGB(198, 198, 198),
                            TextSize = Library.UI.FontSize,
                            TextStrokeTransparency = 1,
                            TextXAlignment = "Left"
                        })
                        --
                        local UIPadding_82 = Library:CreateObject("UIPadding", {
                            PaddingLeft = UDim.new(0, 8),
                            Parent = ButtonText
                        })
                        --
                        local Button_945 = Library:CreateObject("TextButton", {
                            FontFace = Library.UI.NewFont,
                            TextColor3 = Color3.fromRGB(0, 0, 0),
                            BorderColor3 = Color3.fromRGB(0, 0, 0),
                            Name = "Button_9",
                            BackgroundTransparency = 1,
                            ZIndex = 5,
                            Size = UDim2.new(1, 0, 1, 0),
                            BorderSizePixel = 0,
                            TextTransparency = 1,
                            TextSize = Library.UI.FontSize,
                            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                            Parent = ButtonOutline
                        })
                        --
                        Section.SizeButton = ButtonOutline
                        ButtonOutline.Size = UDim2.fromOffset(ButtonText.TextBounds.X + 16, 25)
                        ButtonOutline.BackgroundTransparency = 1
                        ButtonMain.BackgroundTransparency = 1
                        ButtonText.TextTransparency = 1
                        Button_945.TextTransparency = 1
                        --
                        do -- Connections
                            Library:Connection(Button_945.MouseEnter, function()
                                Section.Hovering = true
                            end)
                            --
                            Library:Connection(Button_945.MouseLeave, function()
                                Section.Hovering = false
                            end)
                            --
                            Library:Connection(Button_945.MouseButton1Click, function()
                                Section:CalculateHeight(SectionOutline, SectionScrolling)
                                Library:Fade(false, Library:GetObjectsTable(ButtonOutline, true), ButtonOutline, 0.1)
                                --
                                task.delay(Library.UI.TweenSpeed, function()
                                    for _, Value in ButtonOutline:GetDescendants() do
                                        Value:Destroy()
                                    end
                                    --
                                    ButtonOutline:Destroy()
                                    Section.SizeButton = nil
                                end)
                            end)
                        end
                        --
                        Library:Fade(true, Library:GetObjectsTable(ButtonOutline, true), ButtonOutline, 0.1)
                    end
                end
                --
                do -- Connections
                    Library:Connection(SectionScrolling.ChildAdded, function()
                        Section:UpdateSection()
                    end)
                    --
                    Library:Connection(SectionScrolling.ChildRemoved, function()
                        Section:UpdateSection()
                    end)
                    --
                    Library:Connection(SectionOutline:GetPropertyChangedSignal("AbsoluteSize"), function()
                        Section:UpdateSection()
                    end)
                    --
                    Library:Connection(SectionScrolling:GetPropertyChangedSignal("AbsoluteCanvasSize"), function()
                        Section:UpdateSection()
                    end)
                    --
                    Library:Connection(SectionScrolling:GetPropertyChangedSignal("CanvasPosition"), function()
                        UpArrow.Visible = not Section:CheckArrows("Up")
                        DownArrow.Visible = not Section:CheckArrows("Down")
                    end)
                    --
                    Library:Connection(UpArrow.MouseButton1Click, function()
                        if not UpArrow.Visible then return end
                        --
                        Library:TweenObject(SectionScrolling, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, 0)})
                    end)
                    --
                    Library:Connection(DownArrow.MouseButton1Click, function()
                        if not DownArrow.Visible then return end
                        --
                        Library:TweenObject(SectionScrolling, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(0, SectionScrolling.AbsoluteCanvasSize.Y - SectionScrolling.AbsoluteSize.Y)})
                    end)
                    --
                    do -- Dragging
                        Library:Connection(Title.MouseButton1Down, function()
                            Title.TextColor3 = Library.Theme.Default.Accent
                            --
                            Section.DragConnection = Library:Connection(UserInputService.InputChanged, LPH_NO_VIRTUALIZE(function(Input)
                                if Input.UserInputType == Enum.UserInputType.MouseMovement then
                                    local SelectedOptions = {["SubSection"] = Options.ParentOptions, ["Other"] = {Left, Right}}
                                    local Selected = Tab.SubSectionEnabled and "SubSection" or "Other"
                                    local NewLeft, NewRight = SelectedOptions[Selected][1], SelectedOptions[Selected][2]
                                    local Parent2 = Library:SectionDragging(NewLeft) and NewLeft or Library:SectionDragging(NewRight) and NewRight
                                    local ParentName = Parent2 == NewLeft and "Left" or "Right"
                                    local TopHalf = Parent2 and Input.Position.Y < Parent2.AbsoluteSize.Y / 2
                                    --
                                    if not Parent2 then return end
                                    --
                                    SectionOutline.Parent = Parent2
                                    --
                                    for _, SectionChild in Parent2:GetChildren() do
                                        if SectionChild:IsA("Frame") and SectionChild.Visible then
                                            if SectionChild == SectionOutline then
                                                if TopHalf then
                                                    SectionChild.LayoutOrder = (Tab.DropdownSectionEnabled and Parent2 == NewLeft and 2) or 1
                                                else
                                                    SectionChild.LayoutOrder = Section[ParentName].Order + 1
                                                end
                                            else
                                                if SectionChild.Name == "DropdownSection1" then
                                                    SectionChild.LayoutOrder = 1
                                                else
                                                    SectionChild.LayoutOrder = Section[ParentName].Order
                                                    Section[ParentName].Order = 3
                                                end
                                            end
                                        end
                                    end
                                end
                            end))
                        end)
                    end
                    --
                    do -- Resizing
                        Library:Connection(ResizableButton_6.MouseButton2Click, function()
                            Section:CalculateButton(UDim2.fromOffset(ResizableButton_6.AbsolutePosition.X + ResizableButton_6.AbsoluteSize.X + 4, ResizableButton_6.AbsolutePosition.Y + ResizableButton_6.AbsoluteSize.Y + GuiService:GetGuiInset().Y))
                        end)
                        --
                        Library:Connection(ResizableButton_6.MouseButton1Down, function()
                            ResizableButton_6.ImageColor3 = Library.Theme.Default.Accent
                            SectionInline.BackgroundColor3 = Library.Theme.Default.Accent
                            --
                            SectionOutline.Size = UDim2.new(SectionOutline.Size.X.Scale, SectionOutline.Size.X.Offset, 0, SectionOutline.AbsoluteSize.Y)
                        end)
                        --
                        Library:Connection(UserInputService.InputBegan, function(Input)
                            if Input.UserInputType == Enum.UserInputType.MouseButton1 and Section.SizeButton and not Section.Hovering then
                                Library:Fade(false, Library:GetObjectsTable(Section.SizeButton, true), Section.SizeButton, 0.1)
                                --
                                task.delay(Library.UI.TweenSpeed, function()
                                    for _, Value in Section.SizeButton:GetDescendants() do
                                        Value:Destroy()
                                    end
                                    --
                                    Section.SizeButton:Destroy()
                                    Section.SizeButton = nil
                                end)
                            end
                        end)
                        --
                        Library:Resizable(SectionOutline, ResizableButton_6, UDim2.fromOffset(200, 50), UDim2.fromOffset(SectionOutline.Parent.AbsoluteSize.X - 29, SectionOutline.Parent.AbsoluteSize.Y - 38), Library.UI.SectionResizeIncrements, false, true, 0.01)
                    end
                    --
                    Library:Connection(UserInputService.InputEnded, function(Input)
                        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                            if Section.DragConnection then Section.DragConnection:Disconnect() Section.DragConnection = nil end
                            Section.Left.Order = 1
                            Section.Right.Order = 1
                            Title.TextColor3 = Color3.fromRGB(198, 198, 198)
                            --
                            ResizableButton_6.ImageColor3 = Color3.fromRGB(40, 40, 40)
                            SectionInline.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        end
                    end)
                end
                --
                return setmetatable(Section, Library.Sections)
            end
            --
            function Tab:SubSection(Options)
                Options = Library:Validate({
                    Name = "Preview Sub Section",
                    Options = {},
                    Flag = Library:NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local SubSection = {
                    CurrentSection = nil,
                    Sections = {},
                    List = {},
                    Elements = {},
                }
                --
                SubSectionHolder.Visible = true
                Tab.SubSectionEnabled = true
                Tab.Sides.Right.Sizes = 0
                Tab.Sides.Left.Sizes = 0
                --
                local SectionOutline = Library:CreateObject("Frame", {
                    Name = "SectionOutline",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    ZIndex = 1,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = SubSectionHolder
                })
                --
                SectionOutline:SetAttribute("g", 0)
                --
                local SectionInline = Library:CreateObject("Frame", {
                    Name = "SectionInline",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    Parent = SectionOutline
                })
                --
                local SectionMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "SectionMain_1",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
                    Parent = SectionInline
                })
                --
                local UIPadding_81 = Library:CreateObject("UIPadding", {
                    PaddingRight = UDim.new(0, 10),
                    PaddingLeft = UDim.new(0, 10),
                    Parent = SectionMain
                })
                --
                local UIListLayout52 = Library:CreateObject("UIListLayout", {
                    Padding = UDim.new(0, -0),
                    FillDirection = Enum.FillDirection.Horizontal,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    HorizontalAlignment = Enum.HorizontalAlignment.Left,
                    Parent = SectionMain
                })
                --
                local TitleInline = Library:CreateObject("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "TitleInline",
                    BorderSizePixel = 0,
                    Parent = SectionOutline,
                    Position = UDim2.new(0, 9, 0, 0),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 5
                })
                --
                local UIGradient2 = Library:CreateObject("UIGradient", {
                    Rotation = 90,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 19, 19)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 24))
                    },
                    Parent = TitleInline
                })
                --
                local Title = Library:CreateObject("TextLabel", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Parent = SectionOutline,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -26, 0, 15),
                    ZIndex = 5,
                    FontFace = Library.UI.NewFont,
                    RichText = true,
                    Text = "<b>" .. Options.Name .. "</b>",
                    TextColor3 = Color3.fromRGB(198, 198, 198),
                    TextSize = Library.UI.FontSize,
                    TextStrokeTransparency = 1,
                    TextXAlignment = "Left"
                })
                --
                for Index, Value in Options.Options do
                    local SectionItem = {
                        Active = false,
                        Hovering = false,
                        Position = "Bottom",
                        Elements = {},
                    }
                    --
                    local SectionsHolder2 = Library:CreateObject("Frame", {
                        Name = "SectionsHolder",
                        BackgroundTransparency = 1,
                        Visible = false,
                        Position = UDim2.new(0, 97, 0, 33),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(1, -112, 1, -34),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        ClipsDescendants = true,
                        Parent = Outline_1
                    })
                    --
                    local UIPadding_141 = Library:CreateObject("UIPadding", {
                        PaddingTop = UDim.new(0, 52),
                        Parent = SectionsHolder2
                    })
                    --
                    local Left2 = Library:CreateObject("Frame", {
                        BackgroundTransparency = 1,
                        Name = "Left2",
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(0.5, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = SectionsHolder2
                    })
                    --
                    local UIPadding_11 = Library:CreateObject("UIPadding", {
                        PaddingTop = UDim.new(0, 19),
                        PaddingBottom = UDim.new(0, 19),
                        PaddingRight = UDim.new(0, 12),
                        Parent = Left2
                    })
                    --
                    local UIListLayout12 = Library:CreateObject("UIListLayout", {
                        Padding = UDim.new(0, 19),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Parent = Left2
                    })
                    --
                    local Right2 = Library:CreateObject("Frame", {
                        Name = "Right2",
                        BackgroundTransparency = 1,
                        Position = UDim2.new(0.5, 0, 0, 0),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(0.5, 0, 1, 0),
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = SectionsHolder2
                    })
                    --
                    local UIPadding_21 = Library:CreateObject("UIPadding", {
                        PaddingTop = UDim.new(0, 19),
                        PaddingBottom = UDim.new(0, 19),
                        PaddingRight = UDim.new(0, 6),
                        PaddingLeft = UDim.new(0, 6),
                        Parent = Right2
                    })
                    --
                    local UIListLayout521 = Library:CreateObject("UIListLayout", {
                        Padding = UDim.new(0, 19),
                        SortOrder = Enum.SortOrder.LayoutOrder,
                        Parent = Right2
                    })
                    --
                    local Icon = Library:CreateObject("ImageButton", {
                        ImageColor3 = Color3.fromRGB(100, 100, 100),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = "Icon",
                        Image = Value,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(0, 75, 0, 57),
                        ZIndex = 2,
                        BorderSizePixel = 0,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = SectionMain
                    })
                    --
                    Left2.Position = UDim2.new(0, -(Left2.AbsoluteSize.X * 2), 0, 0)
                    Right2.Position = UDim2.new(0.5, -(Right2.AbsoluteSize.X * 2), 0, 0)
                    --
                    do -- Functions
                        function SectionItem:MoveSides(State)
                            task.spawn(function()
                                if State then
                                    if SectionItem.Position == "Bottom" then
                                        Left2.Position = UDim2.new(0, (Left2.AbsoluteSize.X * 2), 0, 0)
                                        Right2.Position = UDim2.new(0.5, (Right2.AbsoluteSize.X * 2), 0, 0)
                                    else
                                        Left2.Position = UDim2.new(0, -(Left2.AbsoluteSize.X * 2), 0, 0)
                                        Right2.Position = UDim2.new(0.5, -(Right2.AbsoluteSize.X * 2), 0, 0)
                                    end
                                    --
                                    SectionsHolder2.Visible = Outline:GetAttribute("g") == table.find(Window.Tabs, Tab)
                                    Library:TweenObject(Left2, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, 1, 0, 0)})
                                    Library:TweenObject(Right2, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 1, 0, 0)})
                                else
                                    task.wait(0.001)
                                    --
                                    local LeftPosition = SectionItem.Position == "Bottom" and (Left2.AbsoluteSize.X * 2) + 10 or -(Left2.AbsoluteSize.X * 2)
                                    local RightPosition = SectionItem.Position == "Bottom" and (Right2.AbsoluteSize.X * 2) + 10 or -(Right2.AbsoluteSize.X * 2)
                                    --
                                    Library:TweenObject(Left2, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0, LeftPosition, 0, 0)})
                                    Library:TweenObject(Right2, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, RightPosition, 0, 0)})
                                end
                            end)
                        end
                        --
                        function SectionItem:Activate()
                            if not SectionItem.Active then
                                if SubSection.CurrentSection ~= nil then
                                    SubSection.CurrentSection:Deactivate()
                                end
                                --
                                SectionItem.Active = true
                                --
                                SectionItem:MoveSides(true)
                                Icon.ImageColor3 = Color3.fromRGB(188, 188, 188)
                                --
                                SubSection.CurrentSection = SectionItem
                                SectionOutline:SetAttribute("g", Index)
                            end
                        end
                        --
                        function SectionItem:Deactivate()
                            if SectionItem.Active then
                                SectionItem.Active = false
                                SectionItem.Hovering = false
                                --
                                SectionItem:MoveSides(false)
                                Icon.ImageColor3 = Color3.fromRGB(93, 93, 93)
                            end
                        end
                        --
                        function SectionItem:Section(Options)
                            Options = Library:Validate({
                                Name = "Preview Section",
                                Side = "Left",
                                Size = 40,
                            }, Options or {})
                            --
                            local Section = Tab:Section({
                                Name = Options.Name,
                                Side = Options.Side,
                                Fill = Options.Fill,
                                Size = Options.Size,
                                Parent = Options.Side == "Left" and Left2 or Right2,
                                ParentOptions = {Left2, Right2},
                                Icon = Icon,
                            })
                            --
                            return Section
                        end
                    end
                    --
                    do -- Connections
                        Library:Connection(Outline:GetPropertyChangedSignal("AbsoluteSize"), function()
                            if not SectionItem.Active then
                                Left2.Position = UDim2.new(0, Left2.AbsoluteSize.X * 2, 0, 0)
                                Right2.Position = UDim2.new(0.5, Right2.AbsoluteSize.X * 2, 0, 0)
                            end
                        end)
                        --
                        Library:Connection(Outline:GetAttributeChangedSignal("g"), function()
                            if Outline:GetAttribute("g") == table.find(Window.Tabs, Tab) then
                                SectionsHolder2.Visible = true
                            end
                        end)
                        --
                        Library:Connection(SectionOutline:GetAttributeChangedSignal("g"), function()
                            if SectionOutline:GetAttribute("g") > Index then
                                SectionItem.Position = "Top"
                            elseif SectionOutline:GetAttribute("g") < Index then
                                SectionItem.Position = "Bottom"
                            end
                        end)
                        --
                        Library:Connection(Left:GetPropertyChangedSignal("AbsolutePosition"), function()
                            if SectionItem.Active then
                                Left2.Position = Left.Position
                            end
                        end)
                        --
                        Library:Connection(Right:GetPropertyChangedSignal("AbsolutePosition"), function()
                            if SectionItem.Active then
                                Right2.Position = Right.Position
                            end
                        end)
                        --
                        Library:Connection(Icon.MouseButton1Click, function()
                            SectionItem:Activate()
                        end)
                        --
                        Library:Connection(Icon.MouseEnter, function()
                            if not SectionItem.Active then
                                SectionItem.Hovering = true
                                Icon.ImageColor3 = Color3.fromRGB(124, 124, 124)
                            end
                        end)
                        --
                        Library:Connection(Icon.MouseLeave, function()
                            if not SectionItem.Active then
                                SectionItem.Hovering = false
                                Icon.ImageColor3 = Color3.fromRGB(93, 93, 93)
                            end
                        end)
                    end
                    --
                    if SubSection.CurrentSection == nil then
                        task.defer(function()
                            SectionItem:Activate()
                        end)
                    end
                    --
                    SubSection.Sections[#SubSection.Sections + 1] = setmetatable(SectionItem, Library.Sections)
                end
                --
                task.defer(function()
                    if SubSection.Sections[1] then
                        SubSection.Sections[1]:Activate()
                    end
                end)
                --
                SubSection.Elements = {
                    Name = Title,
                    ContentHolder = SectionMain,
                }
                --
                TitleInline.Size = UDim2.new(0, Title.TextBounds.X + 6, 0, 2)
                --
                return table.unpack(SubSection.Sections)
            end
            --
            function Tab:ImageDropdown(Options)
                Options = Library:Validate({
                    Name = "Weapon Type",
                    Options = {},
                    Default = nil,
                    Flag = Library:NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local ImageDropdown = {
                    Open = false,
                    Active = false,
                    Hovering = false,
                    CurrentItem = nil,
                    Scrollable = false,
                    Hiding = false,
                    ContentLength = Library:GetTableLength(Options.Options),
                }
                --
                Tab.DropdownSectionEnabled = true
                Tab.Sides.Left.Sizes = 70
                --
                local DropdownImageOutline = Library:CreateObject("Frame", {
                    Name = "DropdownSection1",
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 51),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Left
                })
                --
                local DropdownChecker = Library:CreateObject("Frame", {
                    Name = "DropdownChecker",
                    Position = UDim2.new(0, 0, 1, 0),
                    Visible = false,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, 0, 0, 1),
                    BorderSizePixel = 0,
                    Parent = DropdownImageOutline
                })
                --
                local DropdownImageInline = Library:CreateObject("Frame", {
                    Name = "DropdownImageInline",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    Parent = DropdownImageOutline
                })
                --
                local DropdownImageMain = Library:CreateObject("Frame", {
                    Size = UDim2.new(1, -2, 1, -2),
                    Name = "DropdownImageMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
                    Parent = DropdownImageInline
                })
                --
                local Button_92 = Library:CreateObject("TextButton", {
                    FontFace = Library.UI.NewFont,
                    TextColor3 = Color3.fromRGB(0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Button_9",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0,
                    TextTransparency = 1,
                    TextSize = Library.UI.FontSize,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = DropdownImageMain
                })
                --
                local DownArrow = Library:CreateObject("ImageLabel", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "DownArrow",
                    Size = UDim2.new(0, 5, 0, 4),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://15540867448",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -6, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    ImageColor3 = Color3.fromRGB(210, 210, 210),
                    Parent = DropdownImageMain
                })
                --
                local Icon = Library:CreateObject("ImageLabel", {
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "Icon",
                    Size = UDim2.new(0, 50, 1, -6),
                    AnchorPoint = Vector2.new(1, 0.5),
                    Image = "rbxassetid://18657040454",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -14, 0.5, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    ImageColor3 = Color3.fromRGB(210, 210, 210),
                    Parent = DropdownImageMain
                })
                --
                local ToggleHolder = Library:CreateObject("Frame", {
                    Name = "ToggleHolder",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 100, 1, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 2,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Parent = DropdownImageMain
                })
                --
                local ActualToggleButton = Library:Toggle({
                    Default = false,
                    Name = "Global",
                    SectionName = "ToggleHolder",
                    Parent = ToggleHolder,
                    Risky = false,
                    MainUI = Outline,
                    ZIndex = 2,
                    TabUI = SideBarMain,
                    AnchorPoint = Vector2.new(0, 0.5),
                    Size = UDim2.new(1, 0, 1, 0),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    UseToggleOutline = true,
                    Hidden = false,
                    Flag = Options.Flag .. "Extra",
                    Callback = function(State)
                        if ImageDropdown.CurrentItem then
                            ImageDropdown.CurrentItem:SetValue(State)
                            Library.Flags[Options.Flag] = ImageDropdown.CurrentItem
                            Options.Callback(ImageDropdown.CurrentItem.Name, ImageDropdown.CurrentItem.CurrentValue)
                        end
                    end,
                })
                --
                local UIPadding = Library:CreateObject("UIPadding", {
                    PaddingLeft = UDim.new(0, 18),
                    Parent = ToggleHolder
                })
                --
                local TitleInline = Library:CreateObject("Frame", {
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Name = "TitleInline",
                    BorderSizePixel = 0,
                    Parent = DropdownImageOutline,
                    Position = UDim2.new(0, 9, 0, 0),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 5
                })
                --
                local UIGradient2 = Library:CreateObject("UIGradient", {
                    Rotation = 90,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(19, 19, 19)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(24, 24, 24))
                    },
                    Parent = TitleInline
                })
                --
                local Title = Library:CreateObject("TextButton", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 1,
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    BorderSizePixel = 0,
                    Parent = DropdownImageOutline,
                    Position = UDim2.new(0, 12, 0, 0),
                    Size = UDim2.new(1, -26, 0, 15),
                    ZIndex = 5,
                    FontFace = Library.UI.NewFont,
                    RichText = true,
                    Text = "<b>" .. Options.Name .. "</b>",
                    TextColor3 = Color3.fromRGB(198, 198, 198),
                    TextSize = Library.UI.FontSize,
                    TextStrokeTransparency = 1,
                    TextXAlignment = "Left"
                })
                --
                local DropdownMainOutline = Library:CreateObject("Frame", {
                    Name = "DropdownMainOutline",
                    Position = UDim2.new(0, 0, 0, 0),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    ZIndex = 50,
                    BorderSizePixel = 0,
                    BackgroundColor3 = Color3.fromRGB(12, 12, 12),
                    Parent = Library.UI.ScreenGUI
                })
                --
                local DropdownMain = Library:CreateObject("Frame", {
                    Name = "DropdownMain",
                    Position = UDim2.new(0, 1, 0, 1),
                    BorderColor3 = Color3.fromRGB(0, 0, 0),
                    Size = UDim2.new(1, -2, 1, -2),
                    BorderSizePixel = 0,
                    ZIndex = 50,
                    ClipsDescendants = true,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                    Parent = DropdownMainOutline
                })
                --
                DropdownMainOutline.BackgroundTransparency = 1
                DropdownMain.BackgroundTransparency = 1
                --
                local UIListLayout_9 = Library:CreateObject("UIListLayout", {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = DropdownMain
                })
                --
                Title.Size = UDim2.fromOffset(Title.TextBounds.X, 15)
                TitleInline.Size = UDim2.new(0, Title.TextBounds.X + 6, 0, 2)
                --
                for Index, Value in Options.Options do
                    local DropdownOption = {
                        Hovering = false,
                        Active = false,
                        CurrentValue = false,
                        Name = Index,
                    }
                    --
                    local ButtonMain = Library:CreateObject("Frame", {
                        Name = "DropdownMain",
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Size = UDim2.new(1, 0, 0, 30),
                        BorderSizePixel = 0,
                        ZIndex = 50,
                        ClipsDescendants = true,
                        LayoutOrder = Value.Order,
                        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                        Parent = DropdownMain
                    })
                    --
                    local Button_925 = Library:CreateObject("TextButton", {
                        FontFace = Library.UI.NewFont,
                        TextColor3 = Color3.fromRGB(0, 0, 0),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = "Button_9",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        BorderSizePixel = 0,
                        ZIndex = 50,
                        TextTransparency = 1,
                        TextSize = Library.UI.FontSize,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        Parent = ButtonMain
                    })
                    --
                    ButtonMain.BackgroundTransparency = 1
                    --
                    local ToggleButton = Library:Toggle({
                        Default = false,
                        Name = Index,
                        SectionName = "ImageDropdown",
                        Parent = ButtonMain,
                        Risky = false,
                        MainUI = Outline,
                        ZIndex = 50,
                        TabUI = SideBarMain,
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 15, 0.5, 0),
                        Hidden = false,
                        Callback = function(State)

                        end,
                    })
                    --
                    local IconButton = Library:CreateObject("ImageLabel", {
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Name = "Icon",
                        Size = UDim2.new(0, 35, 1, 0),
                        AnchorPoint = Vector2.new(1, 0.5),
                        Image = Value.Icon,
                        BackgroundTransparency = 1,
                        Position = UDim2.new(1, -10, 0.5, 0),
                        ZIndex = 50,
                        BorderSizePixel = 0,
                        ImageColor3 = Color3.fromRGB(124, 124, 124),
                        Parent = ButtonMain
                    })
                    --
                    do -- Functions
                        function DropdownOption:Activate()
                            if not DropdownOption.Active then
                                if ImageDropdown.CurrentItem ~= nil then
                                    ImageDropdown.CurrentItem:Deactivate()
                                end
                                --
                                DropdownOption.Active = true
                                ImageDropdown.CurrentItem = DropdownOption
                                --
                                IconButton.ImageColor3 = Color3.fromRGB(210, 210, 210)
                                Icon.Image = Value.Icon
                                ActualToggleButton:SetName(Index)
                            end
                        end
                        --
                        function DropdownOption:Deactivate()
                            if DropdownOption.Active then
                                DropdownOption.Active = false
                                DropdownOption.Hovering = false
                                ImageDropdown.CurrentItem = nil
                                --
                                ButtonMain.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                                IconButton.ImageColor3 = Color3.fromRGB(124, 124, 124)
                            end
                        end
                        --
                        function DropdownOption:SetValue(Value)
                            ToggleButton:Set(Value)
                            DropdownOption.CurrentValue = Value
                        end
                        --
                        function DropdownOption:Get()
                            return {Name = DropdownOption.Name, Value = DropdownOption.CurrentValue}
                        end
                    end
                    --
                    do -- Connections
                        Library:Connection(ButtonMain.MouseEnter, function()
                            ButtonMain.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
                            IconButton.ImageColor3 = Color3.fromRGB(210, 210, 210)
                        end)
                        --
                        Library:Connection(ButtonMain.MouseLeave, function()
                            ButtonMain.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                            --
                            if DropdownOption.Active then return end
                            --
                            IconButton.ImageColor3 = Color3.fromRGB(124, 124, 124)
                        end)
                        --
                        Library:Connection(Button_925.MouseButton1Click, function()
                            DropdownOption:Activate()
                            ActualToggleButton:Set(DropdownOption.CurrentValue)
                        end)
                    end
                    --
                    if Options.Default == Index then
                        DropdownOption:Activate()
                    end
                    --
                    Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
                end
                --
                do -- Functions
                    function ImageDropdown:Toggle(Fast)
                        local Fast = Fast or false
                        local OldValues = Library.Objects[DropdownMainOutline]
                        --
                        if ImageDropdown.Open then
                            if Fast then
                                Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0)
                                DropdownMainOutline.Size = UDim2.new(0, DropdownImageOutline.AbsoluteSize.X, 0, 0)
                                Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], true}
                            else
                                Library:Fade(false, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
                                Library:TweenObject(DropdownMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownImageOutline.AbsoluteSize.X, 0, 0)}, function()
                                    Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], true}
                                end)
                            end
                        else
                            Library.Objects[DropdownMainOutline] = {DropdownMainOutline, OldValues[2], false}
                            --
                            if Fast then
                                Library:Fade(true, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0)
                                DropdownMainOutline.Size = UDim2.new(0, DropdownImageOutline.AbsoluteSize.X, 0, (ImageDropdown.ContentLength * 30) + 2)
                            else
                                Library:Fade(true, Library:GetObjectsTable(DropdownMainOutline, true), DropdownMainOutline, 0.1)
                                Library:TweenObject(DropdownMainOutline, TweenInfo.new(Library.UI.TweenSpeed, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, DropdownImageOutline.AbsoluteSize.X, 0, (ImageDropdown.ContentLength * 30) + 2)})
                            end	
                        end
                        --
                        ImageDropdown.Open = not ImageDropdown.Open
                    end
                    --
                    function ImageDropdown:Update()
                        DropdownMainOutline.Size = UDim2.new(0, DropdownImageOutline.AbsoluteSize.X, 0, DropdownMainOutline.AbsoluteSize.Y)
                        DropdownMainOutline.Position = UDim2.new(0, DropdownImageOutline.AbsolutePosition.X, 0, ((DropdownImageOutline.AbsolutePosition.Y + DropdownImageOutline.AbsoluteSize.Y) + GuiService:GetGuiInset().Y + 2))
                    end
                end
                --
                do -- Dropdown Connections
                    ImageDropdown:Update()
                    --
                    Library:Connection(DropdownImageOutline:GetPropertyChangedSignal("AbsolutePosition"), ImageDropdown.Update)
                    Library:Connection(DropdownImageOutline:GetPropertyChangedSignal("AbsoluteSize"), ImageDropdown.Update)
                    --
                    local StartingY = DropdownImageOutline.AbsolutePosition.Y
                    local MainUIStartingY = Outline.AbsolutePosition.Y
                    --
                    Library:Connection(DropdownImageOutline:GetPropertyChangedSignal("AbsolutePosition"), function()
                        if not ImageDropdown.Open then return end
                        --
                        local CurrentY = DropdownImageOutline.AbsolutePosition.Y
                        local MainUICurrentY = Outline.AbsolutePosition.Y
                        --
                        if MainUICurrentY ~= MainUIStartingY then
                            MainUIStartingY = MainUICurrentY
                            StartingY = CurrentY
                            --
                            return
                        end
                        --
                        if Library.UI.Resizing then
                            return
                        end
                        --
                        if CurrentY ~= StartingY then
                            ImageDropdown:Toggle(true)
                        end
                        --
                        StartingY = CurrentY
                    end)
                end
                --
                do -- Connections
                    Library:Connection(Button_92.MouseButton1Click, function()
                        ImageDropdown:Toggle()
                    end)
                end
            end
            --
            function Sections:Dropdown(Options)
                Options = Library:Validate({
                    Default = "None",
                    Name = "Preview Dropdown",
                    Content = {},
                    Hiding = false,
                    Risky = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local Dropdown = Library:Dropdown({
                    Default = Options.Default,
                    Name = Options.Name,
                    Content = Options.Content,
                    MainUI = Outline,
                    TabUI = SideBarMain,
                    Hiding = Options.Hiding,
                    Risky = Options.Risky,
                    Flag = Options.Flag,
                    Callback = Options.Callback,
                    Parent = self.Elements.ContentHolder
                })
                --
                return Dropdown
            end
            --
            function Sections:MultiBox(Options)
                Options = Library:Validate({
                    Default = {},
                    Name = "Preview MultiBox",
                    Content = {},
                    Hiding = false,
                    Risky = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local Dropdown = Library:MultiBox({
                    Default = Options.Default,
                    Name = Options.Name,
                    Content = Options.Content,
                    MainUI = Outline,
                    TabUI = SideBarMain,
                    Hiding = Options.Hiding,
                    Risky = Options.Risky,
                    Flag = Options.Flag,
                    Callback = Options.Callback,
                    Parent = self.Elements.ContentHolder
                })
                --
                return Dropdown
            end
            --
            function Sections:Toggle(Options)
                Options = Library:Validate({
                    Default = false,
                    Name = "Preview Toggle",
                    Risky = false,
                    Hidden = false,
                    Flag = Library:NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local Toggle = Library:Toggle({
                    Default = Options.Default,
                    Name = Options.Name,
                    SectionName = self.Elements.Name,
                    Parent = self.Elements.ContentHolder,
                    Risky = Options.Risky,
                    MainUI = Outline,
                    TabUI = SideBarMain,
                    Hidden = Options.Hidden,
                    Flag = Options.Flag,
                    Callback = Options.Callback
                })
                --
                return Toggle
            end
            --
            function Sections:Slider(Options)
                Options = Library:Validate({
                    Name = "Preview Slider",
                    Min = 0,
                    Max = 100,
                    Default = 1,
                    Decimal = 1,
                    Ending = "",
                    Hidden = false,
                    UseIcons = true,
                    Disable = {},
                    Risky = false,
                    OverrideLimit = false, -- new parameter to allow values beyond max
                    Flag = Library.NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local Slider = Library:Slider({
                    Name = Options.Name,
                    Min = Options.Min,
                    Max = Options.Max,
                    Default = Options.Default,
                    Decimal = Options.Decimal,
                    Ending = Options.Ending,
                    Hidden = Options.Hidden,
                    Parent = self.Elements.ContentHolder,
                    Risky = Options.Risky,
                    Disable = Options.Disable,
                    OverrideLimit = Options.OverrideLimit, -- pass the parameter
                    Flag = Options.Flag,
                    UseIcons = Options.UseIcons,
                    Callback = Options.Callback
                })
                --
                return Slider
            end
            --
            function Sections:Label(Options)
                Options = Library:Validate({
                    Message = "Preview Label",
                    Risky = false,
                    Side = "Left",
                    Hidden = false,
                }, Options or {})
                --
                local Label = Library:Label({
                    Message = Options.Message,
                    Side = Options.Side,
                    Risky = Options.Risky,
                    MainUI = Outline,
                    Hidden = Options.Hidden,
                    TabUI = SideBarMain,
                    SectionName = self.Elements.Name,
                    Callback = Options.Callback,
                    Parent = self.Elements.ContentHolder
                })
                --
                return Label
            end
            --
            function Sections:TextBox(Options)
                Options = Library:Validate({
                    Default = "",
                    Name = "Preview TextBox",
                    Max = 32,
                    NumbersOnly = false,
                    ClearOnFocus = false,
                    CheckIfPressedEnter = false,
                    Risky = false,
                    Hidden = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local TextBox = Library:TextBox({
                    Default = Options.Default,
                    Name = Options.Name,
                    Max = Options.Max,
                    NumbersOnly = Options.NumbersOnly,
                    ClearOnFocus = Options.ClearOnFocus,
                    CheckIfPressedEnter = Options.CheckIfPressedEnter,
                    Risky = Options.Risky,
                    Hidden = Options.Hidden,
                    Parent = self.Elements.ContentHolder,
                    Flag = Options.Flag,
                    Callback = Options.Callback
                })
                --
                return TextBox
            end
            --
            function Sections:List(Options)
                Options = Library:Validate({
                    Size = 100,
                    Hidden = false,
                    Flag = Library.NewFlag(),
                    Callback = function() end
                }, Options or {})
                --
                local TextBox = Library:List({
                    Size = Options.Size,
                    Hidden = Options.Hidden,
                    Parent = self.Elements.ContentHolder,
                    Flag = Options.Flag,
                    Callback = Options.Callback
                })
                --
                return TextBox
            end
            --
            function Sections:Button(Options)
                Options = Library:Validate({
                    Name = "Preview Button",
                    Confirmation = false,
                    Risky = false,
                    Hidden = false,
                    Callback = function() end
                }, Options or {})
                --
                local Button = Library:Button({
                    Name = Options.Name,
                    Confirmation = Options.Confirmation,
                    Risky = Options.Risky,
                    Hidden = Options.Hidden,
                    Parent = self.Elements.ContentHolder,
                    Callback = Options.Callback
                })
                --
                return Button
            end
            --
            return Tab
        end
        --
        function Library:CreateWatermark()
            local Watermark = {
                CanUse = true,
                Tick = tick(),
                RefreshTick = tick(),
            }
            --
            local MainWatermark = Library:CreateObject("Frame", {
                Name = "Watermark",
                Position = UDim2.new(0, 0, 0, 0),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0, 400, 0, 20),
                BorderSizePixel = 0,
                ZIndex = 10000,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Parent = Library.UI.ScreenGUI
            }, true)
            --
            local UIGradient = Library:CreateObject("UIGradient", {
                Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.25, 0.6119999885559082),
                    NumberSequenceKeypoint.new(0.5, 0.625),
                    NumberSequenceKeypoint.new(0.75, 0.625),
                    NumberSequenceKeypoint.new(1, 1)
                },
                Parent = MainWatermark
            }, true)
            --
            local UIStroke = Library:CreateObject("UIStroke", {
                Parent = MainWatermark
            }, true)
            --
            local UIGradient_1 = Library:CreateObject("UIGradient", {
                Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.232, 0.4000000059604645),
                    NumberSequenceKeypoint.new(0.5, 0.4000000059604645),
                    NumberSequenceKeypoint.new(0.75, 0.4000000059604645),
                    NumberSequenceKeypoint.new(1, 1)
                },
                Parent = UIStroke
            }, true)
            --
            local WatermarkText = Library:CreateObject("TextLabel", {
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                TextColor3 = Color3.fromRGB(208, 208, 208),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Text = "gamesense",
                Name = "Text",
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                ZIndex = 10000,
                RichText = true,
                TextSize = 14,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = MainWatermark
            }, true)
            --
            local Stroke = Library:CreateObject("UIStroke", {
                Parent = WatermarkText,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Color = Color3.fromRGB(50, 50, 50),
            }, true)
            --
            local UIPadding = Library:CreateObject("UIPadding", {
                PaddingRight = UDim.new(0, 22),
                PaddingLeft = UDim.new(0, 22),
                Parent = WatermarkText
            }, true)
            --
            do -- Functions
                function Library:ToggleWatermark(State)
                    Watermark.CanUse = State
                    MainWatermark.Visible = State
                end
                --
                function Library:UpdateWatermark(Text)
                    if Watermark.CanUse and not MainWatermark.Visible then MainWatermark.Visible = true end
                    --
                    WatermarkText.Text = tostring(Text)
                    MainWatermark.Size = UDim2.new(0, WatermarkText.TextBounds.X + 44, 0, MainWatermark.Size.Y.Offset)
                    MainWatermark.Position = UDim2.new(1, -(MainWatermark.Size.X.Offset) - 5, 0, 40)
                end
            end
            --
            local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
            --
            Library:UpdateWatermark(("game<font color='rgb(%d, %d, %d)'>sense</font>  <font color='rgb(%d, %d, %d)'>%s</font> <font size='10'>FPS</font>  %s"):format(R, G, B, R, G, B, "60", os.date("%X")))
            --
            Library:Notify({
                Message = ("You are using <font color='rgb(%d, %d, %d)'>gamesense</font>. Join <font color='rgb(%d, %d, %d)'>@</font> https://discord.gg/j3JpXqqXKB"):format(R, G, B, R, G, B),
                Position = "Top Left",
                Delay = 15
            })
            --
            do -- Connections
                Library:Connection(RunService.PostSimulation, LPH_NO_VIRTUALIZE(function()
                    if Library.UI.Initialized and MainWatermark.Visible then
                        local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
                        local FPS = math.floor(1 / math.abs(Watermark.Tick - tick()))
                        --
                        Watermark.Tick = tick()
                        --
                        if (tick() - Watermark.RefreshTick) > Library.UI.WatermarkRefreshRate then
                            Library:UpdateWatermark(("game<font color='rgb(%d, %d, %d)'>sense</font>  <font color='rgb(%d, %d, %d)'>%s</font> <font size='10'>FPS</font>  %s"):format(R, G, B, R, G, B, FPS, os.date("%X")))
                            --
                            Watermark.RefreshTick = tick()
                        end
                    end
                end))
            end
        end
        --
        function Library:Notify(Options)
            Options = Library:Validate({
                Message = "Notification",
                Delay = 3,
                Position = "Top Left",
            }, Options or {})
            --
            local Notification = {}
            local Path = Options.Position == "Top Left" and Library.UI.Notifications.TopLeft or Library.UI.Notifications.Middle
            --
            local NotificationFrameObject = Library:CreateObject("Frame", {
                Name = "Watermark",
                Position = UDim2.new(0, 0, 0, 0),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Size = UDim2.new(0, 400, 0, 20),
                BorderSizePixel = 0,
                ZIndex = 10000,
                BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                Parent = Library.UI.ScreenGUI
            }, true)
            --
            NotificationFrameObject.BackgroundTransparency = 1
            --
            local UIGradient = Library:CreateObject("UIGradient", {
                Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.25, 0.6119999885559082),
                    NumberSequenceKeypoint.new(0.5, 0.625),
                    NumberSequenceKeypoint.new(0.75, 0.625),
                    NumberSequenceKeypoint.new(1, 1)
                },
                Parent = NotificationFrameObject
            }, true)
            --
            local UIStroke = Library:CreateObject("UIStroke", {
                Parent = NotificationFrameObject
            }, true)
            --
            UIStroke.Transparency = 1
            --
            local UIGradient_1 = Library:CreateObject("UIGradient", {
                Transparency = NumberSequence.new{
                    NumberSequenceKeypoint.new(0, 1),
                    NumberSequenceKeypoint.new(0.232, 0.4000000059604645),
                    NumberSequenceKeypoint.new(0.5, 0.4000000059604645),
                    NumberSequenceKeypoint.new(0.75, 0.4000000059604645),
                    NumberSequenceKeypoint.new(1, 1)
                },
                Parent = UIStroke
            }, true)
            --
            local NotificationText = Library:CreateObject("TextLabel", {
                FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
                TextColor3 = Color3.fromRGB(208, 208, 208),
                BorderColor3 = Color3.fromRGB(0, 0, 0),
                Text = Options.Message,
                Name = "Text",
                Size = UDim2.new(1, 0, 1, 0),
                ZIndex = 10000,
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                RichText = true,
                TextSize = 14,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Parent = NotificationFrameObject
            }, true)
            --
            local Stroke = Library:CreateObject("UIStroke", {
                Parent = NotificationText,
                LineJoinMode = Enum.LineJoinMode.Miter,
                Color = Color3.fromRGB(50, 50, 50),
            }, true)
            --
            Stroke.Transparency = 1
            --
            NotificationText.TextTransparency = 1
            --
            local UIPadding = Library:CreateObject("UIPadding", {
                PaddingRight = UDim.new(0, 22),
                PaddingLeft = UDim.new(0, 22),
                Parent = NotificationText
            }, true)
            --
            local NotificationFrame = {
                Class = "Notification",
                Object = NotificationFrameObject,
                Text = NotificationText,
            }
            --
            NotificationFrameObject.Position = Options.Position == "Top Left" and UDim2.new(0, -70, 0, 80 + (#Path * 24)) or UDim2.new(0, Viewport.X / 2 - (NotificationText.TextBounds.X + 4) / 2, 1, -150)
            --
            do -- Functions
                function Notification:UpdatePositions()
                    local TotalHeight = 80
                    local Padding = 6
                    --
                    for Index = #Path, 1, -1 do
                        local Value = Path[Index]
                        local NewPosition
                        --
                        if Options.Position == "Top Left" then
                            NewPosition = UDim2.new(0, 5, 0, TotalHeight)
                            TotalHeight = TotalHeight + Value.Object.AbsoluteSize.Y + Padding
                        else
                            NewPosition = UDim2.new(0, Viewport.X / 2 - (Value.Text.TextBounds.X + 4) / 2, 1, -150 - (Index * 24))
                        end
                        --
                        Library:TweenObject(Value.Object, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = NewPosition})
                    end
                end
                --
                function Notification:RemoveFrame()
                    Library:TweenObject(NotificationFrameObject, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 1})
					Library:TweenObject(NotificationText, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 1})
					Library:TweenObject(UIStroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1})
					Library:TweenObject(Stroke, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 1})
                    --
                    task.delay(0.25, function()
                        NotificationFrameObject:Destroy()

                        table.remove(Path, table.find(Path, NotificationFrame))

                        Notification:UpdatePositions()
                    end)
                end
                --
                function Notification:UpdateText(Text)
                    NotificationText.Text = Text
                    NotificationFrameObject.Size = UDim2.new(NotificationFrameObject.Size.X.Scale, NotificationText.TextBounds.X + 44, 0, NotificationText.TextBounds.Y + 4)
                end
                --
                function Notification:Update()
                    local TotalHeight = 50
                    local Padding = 6
                    --
					Library:TweenObject(NotificationFrameObject, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
					Library:TweenObject(NotificationText, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {TextTransparency = 0})
					Library:TweenObject(UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0})
					Library:TweenObject(Stroke, TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Transparency = 0})
                    NotificationFrameObject.Size = UDim2.new(NotificationFrameObject.Size.X.Scale, NotificationText.TextBounds.X + 44, 0, NotificationText.TextBounds.Y + 4)
                    --
                    for _, Value in Path do
                        TotalHeight = TotalHeight + Value.Object.AbsoluteSize.Y + Padding
                    end
                    --
                    local NewPosition = Options.Position == "Top Left" and UDim2.new(0, 5, 0, TotalHeight) or UDim2.new(0, Viewport.X / 2 - (NotificationText.TextBounds.X + 4) / 2, 1, -150)
                    --
                    Library:TweenObject(NotificationFrameObject, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = NewPosition}, function()
                        if Options.Delay ~= math.huge then
                            task.delay(Options.Delay, Notification.RemoveFrame)
                        end
                    end)
                end
            end
            --
            Notification:Update()
            --
            table.insert(Path, 1, NotificationFrame)
            --
            Notification:UpdatePositions()
            --
            return Notification
        end
        --
        function Library:Init()
            Library.UI.Initialized = true
            --
            Library:CreateWatermark()
            --
            Library:Connection(Camera:GetPropertyChangedSignal("ViewportSize"), function()
                Viewport = Camera.ViewportSize
                --
                Outline.Position = UDim2.fromOffset((Viewport.X / 2) - (Outline.Size.X.Offset / 2), (Viewport.Y / 2) - (Outline.Size.Y.Offset / 2))
            end)
            --
            if Library.UI.OnInitialized then
                Library.UI.OnInitialized()
            end
        end
        -- 
        function Library:Unload()
            Camera.CameraSubject = Client.Character.Humanoid
            --
            for Index, Value in Library.Connections do
                Value:Disconnect()
            end
            --
            for _, Objects in Library.Objects do
                Objects[1]:Destroy()
            end
            --
            MainUI:Destroy()
        end
        --
        function Library:Disable()
            for Index, Value in Library.Flags do
                if Value.State ~= nil and Value.Keybind and Value.Toggle then
                    task.spawn(function()
                        Value.State = false
                    end)
                end
            end
            for Index, Value in Library.Flags do
                if Value.Set then
                    if Value.ToggleGUI then
                        task.spawn(function()
                            Value:Set(false)
                        end)
                    end
                end
            end
        end
        --
        return setmetatable(Window, Library)
    end
end
--------------------------------------------
local success, result
repeat 
    success, result = pcall(function() return getgenv().Library end)
    loaded = success and result ~= nil
until loaded
Library = result
--
local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
local ThemeColor = Color3.fromRGB(R, G, B)
--
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera
--
local Knit = require(ReplicatedStorage.rbxts_include.node_modules["@easy-games"].knit.src).KnitClient
local Flamework = require(ReplicatedStorage.rbxts_include.node_modules["@flamework"].core.out).Flamework
--
repeat task.wait() until Knit and Knit.Controllers and debug.getupvalue(Knit.Start, 1)
--
local BlockEngine = require(ReplicatedStorage.rbxts_include.node_modules["@easy-games"]["block-engine"].out)
local GameData = {
    Utils = {
        Remotes = require(ReplicatedStorage.TS.remotes).default.Client,
        Network = require(LocalPlayer.PlayerScripts.TS.lib.network),
        DamageTypes = require(ReplicatedStorage.TS.damage["damage-type"]).DamageType,
        ItemMeta = require(ReplicatedStorage.TS.item["item-meta"]).items,
        Store = require(LocalPlayer.PlayerScripts.TS.ui.store).ClientStore,
        InventoryUtil = require(ReplicatedStorage.TS.inventory["inventory-util"]).InventoryUtil,
        ViewmodelController = Knit.Controllers.ViewmodelController,
        SwordController = Knit.Controllers.SwordController,
        AppController = Knit.Controllers.AppController,
        UILayers = require(ReplicatedStorage.rbxts_include.node_modules["@easy-games"]["game-core"].out).UILayers,
        MatchStates = require(ReplicatedStorage.TS.match["match-state"]),
        Animation = require(ReplicatedStorage.rbxts_include.node_modules["@easy-games"]["game-core"].out.shared.util["animation-util"]).AnimationUtil,
        AnimationType = require(ReplicatedStorage.TS.animation["animation-type"]).AnimationType,
        ProdAnimations = require(ReplicatedStorage.TS.animation.definitions["prod-animations"]).ProdAnimations,
        BlockEngine = BlockEngine.BlockEngine,
        BlockRemotes = BlockEngine.BlockEngineRemotes.Client,
        BlockBreaker = game.PlaceId == 6872265039 and Knit.Controllers.BlockBreakController and Knit.Controllers.BlockBreakController.blockBreaker,
        GameQuery = require(ReplicatedStorage.rbxts_include.node_modules["@easy-games"]["game-core"].out.shared["game-world-query"]["game-query-util"]).GameQueryUtil,
        Projectile = Knit.Controllers.ProjectileController,
        Sound = require(ReplicatedStorage.rbxts_include.node_modules["@easy-games"]["game-core"].out).SoundManager,
        ProjMeta = require(ReplicatedStorage.TS.projectile["projectile-meta"]).ProjectileMeta,
		Knockback = require(ReplicatedStorage.TS.damage["knockback-util"]).KnockbackUtil,
        Sprint = Knit.Controllers.SprintController,
        Chest = Knit.Controllers.ChestController,
        RavenController = Knit.Controllers.RavenController,
        FovController = Knit.Controllers.FovController,
        QueueController = Knit.Controllers.QueueController
    },
    Events = {
        Damage = Instance.new("BindableEvent"),
        Death = Instance.new("BindableEvent"),
        BedBreak = Instance.new("BindableEvent"),
        MatchEnd = Instance.new("BindableEvent")
    },
    Data = {
        KillAuraTarget = nil
    }
}
--
GameData.Utils.Network.EntityDamageEventZap.On(function(...)
    local Data = table.pack(...)
    GameData.Events.Damage:Fire({
        Damaged = Data[1],
        DamagedPlayer = Players:GetPlayerFromCharacter(Data[1]),
        Damage = Data[2],
        Type = {Value = GameData.Utils.DamageTypes[Data[3]], Number = Data[3]},
        Damager = Data[5],
        DamagerPlayer = Players:GetPlayerFromCharacter(Data[5])
    })
end)
--
task.spawn(function()
    GameData.Utils.Remotes:Get("EntityDeathEvent"):Connect(function(Data)
        GameData.Events.Death:Fire({
            RespawnTime = Data.respawnDuration,
            Type = {Value = GameData.Utils.DamageTypes[Data.damageType], Number = Data.damageType},
            Final = Data.finalKill,
            Killer = Data.fromEntity,
            Killed = Data.entityInstance,
            KilledPlayer = Players:GetPlayerFromCharacter(Data.entityInstance)
        })
    end)

    GameData.Utils.Remotes:Get("BedwarsBedBreak"):Connect(function(Data)
        if Data.player == LocalPlayer then
            GameData.Events.BedBreak:Fire({
                BedBlockPos = Data.bedBlockPosition,
                TeamName = Data.brokenBedTeam.displayName or "Unknown",
                TeamColor = Data.brokenBedTeam.colorHex or 0
            })
        end
    end)

    GameData.Utils.Remotes:Get("MatchEndEvent"):Connect(function(Data)
        GameData.Events.MatchEnd:Fire({
            TeamID = Data.winningTeamId,
            OldLeaderboard = Data.previousLeaderboardPosition,
            NewLeaderboard = Data.newLeaderboardPosition
        })
    end)
end)
--
local function IsAlive(Player, IsCharacter)
    if (not IsCharacter and Player and Player.Character) or IsCharacter then
        local Char = Player
        if not IsCharacter then
            Char = Char.Character
        end

        local Humanoid = Char:FindFirstChild("Humanoid")
        if Humanoid and (Humanoid:GetState() ~= Enum.HumanoidStateType.Dead or Humanoid.Health > 0.05) then
            if Char.PrimaryPart then
                return true
            end
        end
    end

    return false
end
--
local function GetDistanceFrom(pos1, pos2)
    return (pos1 - pos2).Magnitude
end
--
local function GetSpeedMultiplier()
    local Multiplier = 0
    for i,v in GameData.Utils.Sprint:getMovementStatusModifier().modifiers do
        if typeof(i) == "table" and i.moveSpeedMultiplier and v then
            Multiplier += (i.moveSpeedMultiplier - 0.05)
        end
    end
    return Multiplier
end
--
local function IsFeatureEnabled(toggleFlag, keybindFlag)
	local toggle = Library.Flags[toggleFlag]
	local keybind = Library.Flags[keybindFlag]
	
	if not toggle or not toggle:Get() then
		return false
	end
	
	if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" then
		return keybind:Active()
	end
	
	return true
end
--
local BlockList = CollectionService:GetTagged("block")
CollectionService:GetInstanceAddedSignal("block"):Connect(function(inst)
    table.insert(BlockList, inst)
end)
CollectionService:GetInstanceRemovedSignal("block"):Connect(function(inst)
    for i, v in next, BlockList do
        if v == inst then
            table.remove(BlockList, i)
            break
        end
    end
end)
--
local TPDownData = {
	Settings = {
		Running = false
	},
	Data = {
		Params = RaycastParams.new(),
		LastOnGround = os.clock(),
		TpToggle = true,
		OldY = nil,
		TpTick = 0,
		ShouldFreeze = false,
		FreezeEndTime = 0,
		PreFreezeActive = false,
		PreFreezeStartTime = 0
	}
}

TPDownData.Data.Params.FilterType = Enum.RaycastFilterType.Exclude
TPDownData.Data.Params.FilterDescendantsInstances = {}
TPDownData.Data.Params.RespectCanCollide = true

local function GetNearestGround(position)
	local basePos = position or (IsAlive(LocalPlayer) and LocalPlayer.Character.PrimaryPart.Position or Vector3.new(0, 0, 0))
	local rayStartY = basePos.Y < 50 and 2000 or (basePos.Y + 10)
	local startPos = Vector3.new(basePos.X, rayStartY, basePos.Z)
	
	if IsAlive(LocalPlayer) then
		TPDownData.Data.Params.FilterDescendantsInstances = {LocalPlayer.Character}
	end
	
	local RayCheck = workspace:Raycast(startPos, Vector3.new(0, -4000, 0), TPDownData.Data.Params)
	if RayCheck and RayCheck.Material ~= Enum.Material.Water then
		return RayCheck.Position
	end
	
	local searchRadii = {5, 10, 15, 20, 25, 30, 40, 50}
	local searchAngles = {0, 45, 90, 135, 180, 225, 270, 315}
	
	for _, radius in ipairs(searchRadii) do
		for _, angle in ipairs(searchAngles) do
			local radianAngle = math.rad(angle)
			local offsetX = math.cos(radianAngle) * radius
			local offsetZ = math.sin(radianAngle) * radius
			
			local searchPos = Vector3.new(basePos.X + offsetX, rayStartY, basePos.Z + offsetZ)
			local searchRay = workspace:Raycast(searchPos, Vector3.new(0, -4000, 0), TPDownData.Data.Params)
			
			if searchRay and searchRay.Material ~= Enum.Material.Water then
				return searchRay.Position
			end
		end
	end
	
	return nil
end

local function StartTPDownRaycast()
	if TPDownData.Settings.Running then
		return
	end
	
	TPDownData.Settings.Running = true
	task.spawn(function()
		repeat
			task.wait()
			if IsAlive(LocalPlayer) then
				local Root = LocalPlayer.Character.PrimaryPart
				local Humanoid = LocalPlayer.Character.Humanoid
				
				if Humanoid.FloorMaterial ~= Enum.Material.Air then
					TPDownData.Data.LastOnGround = os.clock()
				end
				
				local AirTime = os.clock() - TPDownData.Data.LastOnGround
                				
				if not TPDownData.Data.TpToggle and TPDownData.Data.TpTick > os.clock() then
					Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
				end
				
				if TPDownData.Data.TpToggle then
					local GroundPos = GetNearestGround(Root.Position)
					if GroundPos and Library and Library.Flags then
						local shouldTeleport = false
						
						if Library.Flags["FlyTpDown"] and Library.Flags["FlyTpDown"]:Get() then
							if Library.Flags["FlyTpDownAntivoid"] and Library.Flags["FlyTpDownAntivoid"]:Get() then
								if Library.Flags["FlyEnabled"] and Library.Flags["FlyEnabled"]:Get() then
									if not Library.Flags["FlyKeybind"] or not Library.Flags["FlyKeybind"].Keybind or Library.Flags["FlyKeybind"].Keybind == "[-]" or (Library.Flags["FlyKeybind"].Active and Library.Flags["FlyKeybind"]:Active()) then
										shouldTeleport = true
									end
								end
							end
						end
						
						if Library.Flags["AuraHardCounterTPDown"] and Library.Flags["AuraHardCounterTPDown"]:Get() then
							if Library.Flags["AuraHardCounterTPDownAntivoid"] and Library.Flags["AuraHardCounterTPDownAntivoid"]:Get() then
								if Library.Flags["AuraHardCounter"] and Library.Flags["AuraHardCounter"]:Get() then
									if not Library.Flags["AuraKeybind"] or not Library.Flags["AuraKeybind"].Keybind or Library.Flags["AuraKeybind"].Keybind == "[-]" or (Library.Flags["AuraKeybind"].Active and Library.Flags["AuraKeybind"]:Active()) then
										shouldTeleport = true
									end
								end
							end
						end
						
						if shouldTeleport then
							local horizontalDistance = math.sqrt((Root.Position.X - GroundPos.X)^2 + (Root.Position.Z - GroundPos.Z)^2)
							
							local freezeTime = 0
							if Library.Flags["FlyTpDown"] and Library.Flags["FlyTpDown"]:Get() and Library.Flags["FlyTpDownFreezeTime"] then
								freezeTime = Library.Flags["FlyTpDownFreezeTime"]:Get()
							elseif Library.Flags["AuraHardCounterTPDown"] and Library.Flags["AuraHardCounterTPDown"]:Get() and Library.Flags["AuraHardCounterTpDownFreezeTime"] then
								freezeTime = Library.Flags["AuraHardCounterTpDownFreezeTime"]:Get()
							end
							
							local maxTpDistance = 15
							if horizontalDistance > 3 and horizontalDistance <= maxTpDistance and freezeTime > 0 and not TPDownData.Data.PreFreezeActive then
								local preFreezeStartTime = 2 - freezeTime
								if AirTime >= preFreezeStartTime then
									ContextActionService:BindAction("PreFreezeMovement", function()
										return Enum.ContextActionResult.Sink
									end, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space, Enum.KeyCode.LeftShift)
									TPDownData.Data.PreFreezeActive = true
									TPDownData.Data.PreFreezeStartTime = os.clock()
								end
							end
							
							if (AirTime > 2) and horizontalDistance <= maxTpDistance then
								local canTeleport = true
								
								if TPDownData.Data.PreFreezeActive then
									local preFreezeElapsed = os.clock() - TPDownData.Data.PreFreezeStartTime
									if preFreezeElapsed < freezeTime then
										canTeleport = false
									else
										ContextActionService:UnbindAction("PreFreezeMovement")
										
										local keysToSimulate = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
										for _, key in ipairs(keysToSimulate) do
											if UserInputService:IsKeyDown(key) then
												VirtualInputManager:SendKeyEvent(false, key, false, game)
												VirtualInputManager:SendKeyEvent(true, key, false, game)
											end
										end
										
										TPDownData.Data.PreFreezeActive = false
										TPDownData.Data.PreFreezeStartTime = 0
									end
								end
								
								if canTeleport then
									TPDownData.Data.TpToggle = false
									TPDownData.Data.OldY = Root.Position.Y
									TPDownData.Data.TpTick = os.clock() + 0.11
									
									local safeY = GroundPos.Y + Humanoid.HipHeight + 1
									local safePos = Vector3.new(Root.Position.X, safeY, Root.Position.Z)
									
									if horizontalDistance > 0 then
										safePos = Vector3.new(GroundPos.X, safeY, GroundPos.Z)
									end
									if horizontalDistance > 3 then
										TPDownData.Data.ShouldFreeze = true
									end
									
									Root.CFrame = CFrame.lookAlong(safePos, Root.CFrame.LookVector)
								end
							end
						else
							if TPDownData.Data.PreFreezeActive then
								ContextActionService:UnbindAction("PreFreezeMovement")
								TPDownData.Data.PreFreezeActive = false
								TPDownData.Data.PreFreezeStartTime = 0
								
								local keysToSimulate = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
								for _, key in ipairs(keysToSimulate) do
									if UserInputService:IsKeyDown(key) then
										VirtualInputManager:SendKeyEvent(false, key, false, game)
										task.wait()
										VirtualInputManager:SendKeyEvent(true, key, false, game)
									end
								end
							end
							if TPDownData.Data.FreezeEndTime > 0 then
								ContextActionService:UnbindAction("FreezeMovement")
								TPDownData.Data.FreezeEndTime = 0
								
								local keysToSimulate = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
								for _, key in ipairs(keysToSimulate) do
									if UserInputService:IsKeyDown(key) then
										VirtualInputManager:SendKeyEvent(false, key, false, game)
										task.wait()
										VirtualInputManager:SendKeyEvent(true, key, false, game)
									end
								end
							end
						end
					end
				elseif not TPDownData.Data.TpToggle and TPDownData.Data.OldY and TPDownData.Data.TpTick < os.clock() then
					local NewPos = Vector3.new(Root.Position.X, TPDownData.Data.OldY, Root.Position.Z)
					Root.CFrame = CFrame.lookAlong(NewPos, Root.CFrame.LookVector)
					TPDownData.Data.TpToggle = true
					TPDownData.Data.OldY = nil
					
					if TPDownData.Data.ShouldFreeze then
						local freezeTime = 0
						if Library.Flags["FlyTpDown"] and Library.Flags["FlyTpDown"]:Get() and Library.Flags["FlyTpDownFreezeTime"] then
							freezeTime = Library.Flags["FlyTpDownFreezeTime"]:Get()
						elseif Library.Flags["AuraHardCounterTPDown"] and Library.Flags["AuraHardCounterTPDown"]:Get() and Library.Flags["AuraHardCounterTpDownFreezeTime"] then
							freezeTime = Library.Flags["AuraHardCounterTpDownFreezeTime"]:Get()
						end
						
						if freezeTime > 0 then
							ContextActionService:BindAction("FreezeMovement", function(actionName, inputState, inputObject)
								return Enum.ContextActionResult.Sink
							end, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space, Enum.KeyCode.LeftShift)
							TPDownData.Data.FreezeEndTime = os.clock() + freezeTime
						end
						TPDownData.Data.ShouldFreeze = false
					end
				end
				
				if TPDownData.Data.FreezeEndTime > 0 and os.clock() >= TPDownData.Data.FreezeEndTime then
					ContextActionService:UnbindAction("FreezeMovement")
					TPDownData.Data.FreezeEndTime = 0
					
					local keysToSimulate = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}
					for _, key in ipairs(keysToSimulate) do
						if UserInputService:IsKeyDown(key) then
							VirtualInputManager:SendKeyEvent(false, key, false, game)
							task.wait()
							VirtualInputManager:SendKeyEvent(true, key, false, game)
						end
					end
				end
			else
				if TPDownData.Data.PreFreezeActive then
					ContextActionService:UnbindAction("PreFreezeMovement")
					TPDownData.Data.PreFreezeActive = false
					TPDownData.Data.PreFreezeStartTime = 0
				end
				if TPDownData.Data.FreezeEndTime > 0 then
					ContextActionService:UnbindAction("FreezeMovement")
					TPDownData.Data.FreezeEndTime = 0
				end
			end
		until not (Library.Flags["FlyTpDown"] and Library.Flags["FlyTpDown"]:Get()) and not (Library.Flags["AuraHardCounterTPDown"] and Library.Flags["AuraHardCounterTPDown"]:Get())
		
		ContextActionService:UnbindAction("PreFreezeMovement")
		ContextActionService:UnbindAction("FreezeMovement")
		TPDownData.Settings.Running = false
	end)
end


local function GetInventory(Player)
    Player = Player or LocalPlayer
    return GameData.Utils.InventoryUtil.getInventory(Player)
end
--
local function GetSword()
    local Inventory = GetInventory()
    local Sword = {
        Item = nil,
        Damage = 0,
        AttackSpeed = 0,
        InvData = nil
    }
    --
    if Inventory then
        local Items = Inventory.items
        if Items then
            for i,v in Items do
                local ItemMeta = GameData.Utils.ItemMeta[v.itemType]
                if ItemMeta then
                    local SwordData = ItemMeta.sword
                    if SwordData then
                        local Value = (SwordData.damage / SwordData.attackSpeed)
                        local CurValue = (Sword.Damage / Sword.AttackSpeed)
                        if CurValue ~= CurValue then
                            CurValue = 0
                        end
                        --
                        if Value > CurValue then
                            Sword = {
                                Item = v.tool,
                                Damage = SwordData.damage,
                                AttackSpeed = SwordData.attackSpeed,
                                InvData = v,
                                Meta = ItemMeta
                            }
                        end
                    end
                end
            end
        end
    end
    --
    return Sword
end
--
local function SwitchItem(Item, SwitchBack)
    local SetInvItem = GameData.Utils.Remotes:Get("SetInvItem")
    local Inventory = GetInventory()
    local CurrentItem = nil
    if Inventory and Inventory.hand then
        CurrentItem = Inventory.hand.tool
        if CurrentItem == Item then
            return
        end
    end
    --
    local Completed = false
    SetInvItem:CallServerAsync({
        hand = Item
    }):andThen(function(suc)
        if CurrentItem and suc then
            Completed = true
        end
    end)
    --
    repeat task.wait() until Completed
end
--
local function GetEntities()
    local Entities = {}
    for i,v in CollectionService:GetTagged("entity") do
        local Humanoid = v:FindFirstChild("Humanoid")
        table.insert(Entities, {
            Entity = v,
            Player = Players:GetPlayerFromCharacter(v),
            Health = v:GetAttribute("Health") or Humanoid and Humanoid.Health,
            MaxHealth = v:GetAttribute("MaxHealth") or Humanoid and Humanoid.MaxHealth,
            Humanoid = Humanoid,
            Root = v.PrimaryPart,
            Type = CollectionService:GetTags(v)[3]
        })
    end
    --
    return Entities
end
--
local function GetNearestEntity(TeamCheck, TargetMode)
    local Entities = GetEntities()
    local Entity = {
        Entity = nil,
        Distance = math.huge,
        Data = {}
    }
    local Pool = {}
    TargetMode = TargetMode or "Distance"

    for i,v in Entities do
        if IsAlive(LocalPlayer) and (TeamCheck and v.Entity:GetAttribute("Team") ~= LocalPlayer.Character:GetAttribute("Team") or not TeamCheck) then
            if IsAlive(v.Entity, true) then
                local Distance = GetDistanceFrom(LocalPlayer.Character.PrimaryPart.Position, v.Root.Position)
                
                if TargetMode == "Health" then
                    local Health = v.Health or 0
                    if not Entity.Entity or Health < (Entity.Data.Health or math.huge) then
                        Entity = {
                            Entity = v.Entity,
                            Distance = Distance,
                            Data = v
                        }
                    end
                elseif TargetMode == "Threat" then
                    local Health = v.Health or 0
                    if not Entity.Entity then
                        Entity = {
                            Entity = v.Entity,
                            Distance = Distance,
                            Data = v
                        }
                    else
                        local CurHealth = Entity.Data.Health or 0
                        local CurDist = Entity.Distance
                        if CurDist >= 10 and CurDist <= 15 then
                            if Distance < CurDist and CurHealth >= 50 then
                                Entity = {
                                    Entity = v.Entity,
                                    Distance = Distance,
                                    Data = v
                                }
                            end
                        elseif CurDist > 15 then
                            if Health < CurHealth then
                                Entity = {
                                    Entity = v.Entity,
                                    Distance = Distance,
                                    Data = v
                                }
                            end
                        elseif Distance < CurDist then
                            Entity = {
                                Entity = v.Entity,
                                Distance = Distance,
                                Data = v
                            }
                        end
                    end
                else
                    if Entity.Distance >= Distance then
                        Entity = {
                            Entity = v.Entity,
                            Distance = Distance,
                            Data = v
                        }
                    end
                end
            end
        end
    end

    return Entity
end
--
local function IsPathClear(target, TargetPart, Param)
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return false end
    local Start = LocalPlayer.Character.PrimaryPart.Position
    if TargetPart then
        local Direction = (TargetPart.Position - Start)
        local Ray = workspace:Raycast(Start, Direction, Param)
        --
        if not Ray or (Ray.Instance and (Ray.Instance:IsDescendantOf(target) or GameData.Utils.GameQuery:isQueryIgnored(Ray.Instance))) then
            return true
        end
    end
    --
    return false
end
--
local function GetAngle(CFrame, TargetPos)
    local LookVector = CFrame.LookVector * Vector3.new(1, 0, 1)
    local Position = CFrame.Position
    --
    local ScaledVector = (TargetPos - Position) * Vector3.new(1, 0, 1)
    return math.acos(math.clamp(LookVector:Dot(ScaledVector.Unit), -1, 1))
end
--
local function GetItem(Name, Find)
    for i, v in GetInventory().items do
        if v.itemType == Name or (Find and v.itemType:find(Name)) then
            return v
        end
    end
    
    return
end
--
local Window = Library:Window({CloseBind = Enum.KeyCode.RightShift})
local Rage = Window:CreateTab({Icon = "rbxassetid://18248771514"})
local Movement = Window:CreateTab({Icon = "rbxassetid://15453313321"})
local Aimbot = Window:CreateTab({Icon = "rbxassetid://15453335745"})
local Visuals = Window:CreateTab({Icon = "rbxassetid://15453344494"})
local Settings = Window:CreateTab({Icon = "rbxassetid://15453349637"})
local Exploits = Window:CreateTab({Icon = "rbxassetid://15453354931"})
local PlayerList = Window:CreateTab({Icon = "rbxassetid://15453359751"})
local Configs = Window:CreateTab({Icon = "rbxassetid://15453364412"})
local Lua = Window:CreateTab({Icon = "rbxassetid://18240049800"})
local ActualPlayerList
local NamedSections = {}
--
Window:SetTab(1)
--
do -- Rage
    Rage:ImageDropdown({Name = "Weapon type", Flag = "RageWeaponType", Options = {["Global"] = {Icon = "rbxassetid://18657040454", Order = 1}, ["Snowball"] = {Icon = "rbxassetid://18205706952", Order = 2}, ["Arrow"] = {Icon = "rbxassetid://18205822505", Order = 3}, ["Raven"] = {Icon = "rbxassetid://18205704829", Order = 4} --[[, ["Double Barrel SG"] = {Icon = "rbxassetid://18205706952", Order = 2}, ["Revolver"] = {Icon = "rbxassetid://18205704829", Order = 3}, ["LMG"] = {Icon = "rbxassetid://18205822505", Order = 4}]]}, Default = "Global"})
    --
	local AuraSection = Rage:Section({Name = "Kill Aura", Side = "Right", Fill = true})
	table.insert(NamedSections, AuraSection)
	--
	local KillAuraData = {
		Settings = {
			Range = 27,
			Delay = 0,
			MaxAngle = 360,
			UpdateRate = 120,
			NoSwing = false,
			HandCheck = false,
			WallCheck = false,
			TargetMode = "Distance",
			MaxAngleEnabled = false,
			SwingRangeEnabled = false,
			SwingRange = 27,
			WhitelistAttack = false,
			WhitelistSwing = false,
			IgnoreNPCs = false,
			IgnoreWalls = false,
			IgnoreNPCsSwing = false,
			IgnoreWallsSwing = false,
			ClientTP = false,
			HardCounter = false,
			HardCounterRange = 15,
			HardCounterTPDown = false,
			CustomAnimation = false,
			AnimationMode = "Smooth"
		},
		Data = {
			Params = RaycastParams.new(),
			LastHit = 0,
			LastSwing = 0,
			Connection = nil,
			AnimationPlaying = false,
			OriginalWristCFrame = nil,
			CurrentAnimationTween = nil,
			OldViewmodelAnimation = nil
		},
		Animations = {
			Smooth = {
				{CFrame = CFrame.new(0.6, -2.2, 0.15) * CFrame.Angles(math.rad(300), math.rad(80), math.rad(300)), Time = 0.2},
				{CFrame = CFrame.new(0.65, -2.15, 0.2) * CFrame.Angles(math.rad(200), math.rad(60), math.rad(1)), Time = 0.15}
			}
		}
	}


	local AuraToggle = AuraSection:Toggle({
		Name = "Enabled",
		Default = false,
		Flag = "AuraEnabled",
		Callback = function(State)
			local keybind = Library.Flags["AuraKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["AuraEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>KillAura</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			if State then
				if KillAuraData.Settings.CustomAnimation then
					task.spawn(function()
						repeat task.wait() until GameData.Utils.ViewmodelController and GameData.Utils.ViewmodelController.playAnimation
						task.delay(0.1, function()
							if not KillAuraData.Data.OldViewmodelAnimation then
								KillAuraData.Data.OldViewmodelAnimation = GameData.Utils.ViewmodelController.playAnimation
							end
							
							GameData.Utils.ViewmodelController.playAnimation = function(self, animation, ...)
								if KillAuraData.Data.AnimationPlaying then
									local AnimationType = GameData.Utils.AnimationType[animation]
									if AnimationType and typeof(AnimationType) == "string" then
										if AnimationType:lower():find("swing_sword") then
											return
										end
									end
								end
								return KillAuraData.Data.OldViewmodelAnimation(self, animation, ...)
							end
						end)
					end)
					
					task.spawn(function()
						repeat task.wait() until Camera.Viewmodel and Camera.Viewmodel:FindFirstChild("RightHand")
						local RightHand = Camera.Viewmodel.RightHand
						local RightWrist = RightHand:FindFirstChild("RightWrist")
						if RightWrist and not KillAuraData.Data.OriginalWristCFrame then
							KillAuraData.Data.OriginalWristCFrame = RightWrist.C0
						end
					end)
				end
				
				task.spawn(function()
				repeat
                    task.wait(1 / KillAuraData.Settings.UpdateRate)
					
					if KillAuraData.Settings.Delay > (os.clock() - KillAuraData.Data.LastHit) then
						continue
					end

					local Sword = GetSword()
					if Sword.Item and GameData.Utils.Store:getState().Game.matchstate == GameData.Utils.MatchStates.RUNNING and IsAlive(LocalPlayer) then
						local NearestEntity = GetNearestEntity(true, KillAuraData.Settings.TargetMode)
						local SwingRangeToUse = KillAuraData.Settings.SwingRangeEnabled and KillAuraData.Settings.SwingRange or KillAuraData.Settings.Range
						
						if NearestEntity.Entity then
							if KillAuraData.Settings.WhitelistAttack and KillAuraData.Settings.IgnoreNPCs and not NearestEntity.Data.Player then
								NearestEntity.Entity = nil
							end
						end
							
						if NearestEntity.Entity and SwingRangeToUse >= NearestEntity.Distance and IsAlive(NearestEntity.Entity, true) then
								if KillAuraData.Settings.MaxAngleEnabled and GetAngle(LocalPlayer.Character.PrimaryPart.CFrame, NearestEntity.Entity.PrimaryPart.Position) > (KillAuraData.Settings.MaxAngle / 2 * math.pi / 180) then
									task.wait()
									continue
								end 

								if KillAuraData.Settings.CustomAnimation and not KillAuraData.Data.AnimationPlaying then
									task.spawn(function()
										pcall(function()
											if not Camera.Viewmodel then return end
											local RightHand = Camera.Viewmodel:FindFirstChild("RightHand")
											if not RightHand then return end
											local RightWrist = RightHand:FindFirstChild("RightWrist")
											if not RightWrist then return end
											
											if not KillAuraData.Data.OriginalWristCFrame then
												KillAuraData.Data.OriginalWristCFrame = RightWrist.C0
											end
											
											KillAuraData.Data.AnimationPlaying = true
											local SelectedAnimation = KillAuraData.Animations[KillAuraData.Settings.AnimationMode]
											
											for i, v in SelectedAnimation do
												if not IsFeatureEnabled("AuraEnabled", "AuraKeybind") then break end
												KillAuraData.Data.CurrentAnimationTween = TweenService:Create(RightWrist, TweenInfo.new(v.Time, Enum.EasingStyle.Linear), {C0 = KillAuraData.Data.OriginalWristCFrame * v.CFrame})
												KillAuraData.Data.CurrentAnimationTween:Play()
												KillAuraData.Data.CurrentAnimationTween.Completed:Wait()
											end
											
											KillAuraData.Data.AnimationPlaying = false
										end)
									end)
								end 

								local HandItem = GetInventory().hand
								if KillAuraData.Settings.HandCheck then
									if HandItem and HandItem.tool then
										local Meta = GameData.Utils.ItemMeta[HandItem.itemType]
										if not Meta or not Meta.sword then
											task.wait()
											continue
										end
									else
										task.wait()
										continue
									end
								end

								GameData.Data.KillAuraTarget = NearestEntity
							if not HandItem or HandItem and (not HandItem.tool or HandItem.tool ~= Sword.Item) then
								SwitchItem(Sword.Item, true)
							end

							local SkipSwing = false
							if KillAuraData.Settings.WhitelistSwing then
								if KillAuraData.Settings.IgnoreNPCsSwing and not NearestEntity.Data.Player then
									SkipSwing = true
								end
								KillAuraData.Data.Params.FilterType = Enum.RaycastFilterType.Exclude
								KillAuraData.Data.Params.FilterDescendantsInstances = CollectionService:GetTagged("entity")
								if KillAuraData.Settings.IgnoreWallsSwing and not IsPathClear(NearestEntity.Entity, NearestEntity.Entity.PrimaryPart, KillAuraData.Data.Params) then
									SkipSwing = true
								end
							end

							if not KillAuraData.Settings.NoSwing and not SkipSwing then
								if KillAuraData.Data.LastSwing <= os.clock() then
									KillAuraData.Data.LastSwing = os.clock() + (Sword.Meta.sword.respectAttackSpeedForEffects and Sword.Meta.sword.attackSpeed or math.max(KillAuraData.Settings.Delay, 0.11))
									GameData.Utils.SwordController:playSwordEffect(Sword.Meta, false)
								end
							end

							local SkipAttack = false
							if KillAuraData.Settings.WhitelistAttack then
								KillAuraData.Data.Params.FilterType = Enum.RaycastFilterType.Exclude
								KillAuraData.Data.Params.FilterDescendantsInstances = CollectionService:GetTagged("entity")
								if KillAuraData.Settings.IgnoreWalls and not IsPathClear(NearestEntity.Entity, NearestEntity.Entity.PrimaryPart, KillAuraData.Data.Params) then
									SkipAttack = true
								end
							end

							if KillAuraData.Settings.HardCounter and NearestEntity.Entity and KillAuraData.Settings.HardCounterRange >= NearestEntity.Distance and IsAlive(NearestEntity.Entity, true) then
								local TargetEntity = NearestEntity.Entity
								local TargetPos = NearestEntity.Data.Root.Position
								
								if LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
									local TeleportParams = RaycastParams.new()
									TeleportParams.FilterDescendantsInstances = {TargetEntity, LocalPlayer.Character}
									TeleportParams.FilterType = Enum.RaycastFilterType.Exclude
									
									local TargetLookVector = NearestEntity.Data.Root.CFrame.LookVector
									local TeleportOffset = not workspace:Raycast(TargetPos, TargetLookVector, TeleportParams) 
										and (TargetLookVector * 1.4) 
										or Vector3.zero
									
									LocalPlayer.Character.PrimaryPart.CFrame = NearestEntity.Data.Root.CFrame + TeleportOffset
									
									if KillAuraData.Settings.HardCounterTPDown then
										local GroundPos = GetNearestGround()
										if GroundPos then
											LocalPlayer.Character.PrimaryPart.CFrame = CFrame.lookAlong(Vector3.new(LocalPlayer.Character.PrimaryPart.Position.X, GroundPos.Y + LocalPlayer.Character.Humanoid.HipHeight, LocalPlayer.Character.PrimaryPart.Position.Z), LocalPlayer.Character.PrimaryPart.CFrame.LookVector)
										end
									else
										LocalPlayer.Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 
											LocalPlayer.Character.PrimaryPart.Size.Y / 2 + LocalPlayer.Character.Humanoid.HipHeight + 0.75, 0)
									end
								end
							end
							
							if not SkipAttack and NearestEntity.Entity and KillAuraData.Settings.Range >= NearestEntity.Distance then
								local TargetEntity = NearestEntity.Entity
								local TargetPos = NearestEntity.Data.Root.Position
								local HitPos = (math.clamp(NearestEntity.Distance - 14.4, 10, 30) * (TargetPos - LocalPlayer.Character.PrimaryPart.Position).Unit) + LocalPlayer.Character.PrimaryPart.Position
								
								GameData.Utils.Remotes:Get("SwordHit"):SendToServer({
									entityInstance = TargetEntity,
									chargedAttack = {chargeRatio = 0},
									validate = {
										targetPosition = {value = TargetPos},
										raycast = {
											cursorDirection = {value = CFrame.lookAlong(HitPos, TargetPos).LookVector},
											cameraPosition = {value = HitPos}
										},
										selfPosition = {value = HitPos}
									},
									weapon = Sword.Item
								})
								KillAuraData.Data.LastHit = os.clock()
							end
								else
									GameData.Data.KillAuraTarget = nil
									if KillAuraData.Settings.CustomAnimation and not KillAuraData.Data.AnimationPlaying then
										pcall(function()
											if Camera.Viewmodel and Camera.Viewmodel:FindFirstChild("RightHand") then
												local RightWrist = Camera.Viewmodel.RightHand:FindFirstChild("RightWrist")
												if RightWrist and KillAuraData.Data.OriginalWristCFrame then
													TweenService:Create(RightWrist, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {C0 = KillAuraData.Data.OriginalWristCFrame}):Play()
												end
											end
										end)
									end
								end
							end
					until not IsFeatureEnabled("AuraEnabled", "AuraKeybind")
					
					if KillAuraData.Settings.CustomAnimation then
						pcall(function()
							if Camera.Viewmodel and Camera.Viewmodel:FindFirstChild("RightHand") then
								local RightWrist = Camera.Viewmodel.RightHand:FindFirstChild("RightWrist")
								if RightWrist and KillAuraData.Data.OriginalWristCFrame then
									TweenService:Create(RightWrist, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {C0 = KillAuraData.Data.OriginalWristCFrame}):Play()
								end
							end
						end)
					end
			end)
			else
				GameData.Data.KillAuraTarget = nil
				if KillAuraData.Settings.CustomAnimation then
					pcall(function()
						if Camera.Viewmodel and Camera.Viewmodel:FindFirstChild("RightHand") then
							local RightWrist = Camera.Viewmodel.RightHand:FindFirstChild("RightWrist")
							if RightWrist and KillAuraData.Data.OriginalWristCFrame then
								TweenService:Create(RightWrist, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {C0 = KillAuraData.Data.OriginalWristCFrame}):Play()
							end
						end
					end)
				end
			end
		end
	})
	--
	AuraToggle:Keybind({
		Mode = "Toggle",
		Flag = "AuraKeybind",
		Callback = function() end
	})
	--
	AuraSection:Dropdown({
		Name = "",
		Default = "Distance",
		Content = {"Distance", "Health", "Threat"},
		Flag = "AuraTargetMode",
		Callback = function(Option)
			KillAuraData.Settings.TargetMode = Option
		end
	})
	--
	AuraSection:Slider({
		Name = "Attack Range",
		Min = 1,
		Max = 30,
		Default = 27,
		Decimal = 1,
        Ending = " studs",
		Flag = "AuraAttackRange",
		Callback = function(Value)
			KillAuraData.Settings.Range = Value
		end
	})
	--
	AuraSection:Slider({
		Name = "Swing Time",
		Min = 0,
		Max = 1,
		Default = 0,
		Decimal = 0.1,
        Ending = "s",
        OverrideLimit = true,
		Flag = "AuraSwingTime",
		Callback = function(Value)
			KillAuraData.Settings.Delay = Value
		end
	})
	--
	local AuraSwingRangeSlider
	local AuraSwingRangeToggle = AuraSection:Toggle({
		Name = "Swing Range",
		Default = false,
		Flag = "AuraSwingRangeToggle",
		Callback = function(State)
			KillAuraData.Settings.SwingRangeEnabled = State
			task.spawn(function()
				repeat task.wait() until AuraSwingRangeSlider
				AuraSwingRangeSlider:SetVisible(State)
			end)
		end
	})
	--
	AuraSwingRangeSlider = AuraSection:Slider({
		Name = "",
		Min = 1,
		Max = 30,
		Default = 27,
		Decimal = 0.1,
		Ending = " studs",
		Flag = "AuraSwingRange",
		Hidden = true,
		OverrideLimit = true,
		Callback = function(Value)
			KillAuraData.Settings.SwingRange = Value
		end
	})
	--
    local MaxAngleSlider = nil
	--
	local MaxAngleToggle = AuraSection:Toggle({
		Name = "Max Angle",
		Default = false,
		Flag = "AuraMaxAngleEnabled",
		Callback = function(State)
			KillAuraData.Settings.MaxAngleEnabled = State
			task.spawn(function()
				repeat task.wait() until MaxAngleSlider
				MaxAngleSlider:SetVisible(State)
			end)
		end
	})
	--
	MaxAngleSlider = AuraSection:Slider({
		Name = "",
		Min = 1,
		Max = 360,
		Default = 360,
		Decimal = 1,
        Ending = "°",
        UseIcons = false,
		Flag = "AuraMaxAngle",
		Hidden = true,
		Callback = function(Value)
			KillAuraData.Settings.MaxAngle = Value
		end
	})
	--
	AuraSection:Toggle({
		Name = "Hand Check",
		Default = false,
		Flag = "AuraHandCheck",
		Callback = function(State)
			KillAuraData.Settings.HandCheck = State
		end
	})
	--
	local AnimationModeDropdown
	--
	local CustomAnimationToggle = AuraSection:Toggle({
		Name = "Custom Animation",
		Default = false,
		Flag = "AuraCustomAnimation",
		Callback = function(State)
			KillAuraData.Settings.CustomAnimation = State
			if State then
				if Library.Flags["AuraEnabled"] and Library.Flags["AuraEnabled"]:Get() then
					Library.Flags["AuraEnabled"]:Set(true)
				end
				
				task.spawn(function()
					repeat task.wait() until Camera.Viewmodel and Camera.Viewmodel:FindFirstChild("RightHand")
					local RightHand = Camera.Viewmodel.RightHand
					local RightWrist = RightHand:FindFirstChild("RightWrist")
					if RightWrist and not KillAuraData.Data.OriginalWristCFrame then
						KillAuraData.Data.OriginalWristCFrame = RightWrist.C0
					end
				end)
			else
				pcall(function()
					if Camera.Viewmodel and Camera.Viewmodel:FindFirstChild("RightHand") then
						local RightWrist = Camera.Viewmodel.RightHand:FindFirstChild("RightWrist")
						if RightWrist and KillAuraData.Data.OriginalWristCFrame then
							TweenService:Create(RightWrist, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {C0 = KillAuraData.Data.OriginalWristCFrame}):Play()
						end
					end
				end)
			end
			
			task.spawn(function()
				repeat task.wait() until AnimationModeDropdown
				AnimationModeDropdown:SetVisible(State)
			end)
		end
	})
	AnimationModeDropdown = AuraSection:Dropdown({
		Name = "",
		Default = "Smooth",
		Content = {"Smooth"},
		Flag = "AuraAnimationMode",
		Hidden = true,
		Callback = function(Option)
			KillAuraData.Settings.AnimationMode = Option
		end
	})
	AuraSection:Toggle({
		Name = "No Swing",
		Default = false,
		Flag = "AuraNoSwing",
		Callback = function(State)
			KillAuraData.Settings.NoSwing = State
		end
	})
	--
	local AuraWhitelistAttackMultiBox, AuraWhitelistSwingMultiBox
	local AuraWhitelistAttackToggle, AuraWhitelistSwingToggle
	AuraSection:Toggle({
		Name = "Target Settings",
		Default = false,
		Flag = "AuraTargetSettings",
		Callback = function(State)
			task.spawn(function()
				repeat task.wait() until AuraWhitelistSwingToggle
				AuraWhitelistAttackToggle:SetVisible(State)
				AuraWhitelistSwingToggle:SetVisible(State)
			end)
		end
	})
	--
	AuraWhitelistAttackToggle = AuraSection:Toggle({
		Name = "Whitelist Attack",
		Default = false,
		Flag = "AuraWhitelistAttack",
		Hidden = true,
		Callback = function(State)
			KillAuraData.Settings.WhitelistAttack = State
			task.spawn(function()
				repeat task.wait() until AuraWhitelistAttackMultiBox
				AuraWhitelistAttackMultiBox:SetVisible(State)
			end)
		end
	})
	--
	AuraWhitelistAttackMultiBox = AuraSection:MultiBox({
		Name = "",
		Default = {},
		Content = {"Ignore NPCs", "Ignore Behind Walls"},
		Flag = "AuraWLAttackMultiBox",
		Hidden = true,
		Callback = function(Selected)
			KillAuraData.Settings.IgnoreNPCs = table.find(Selected, "Ignore NPCs")
			KillAuraData.Settings.IgnoreWalls = table.find(Selected, "Ignore Behind Walls")
		end
	})
	--
	AuraWhitelistSwingToggle = AuraSection:Toggle({
		Name = "Whitelist Swing",
		Default = false,
		Flag = "AuraWhitelistSwing",
		Hidden = true,
		Callback = function(State)
			KillAuraData.Settings.WhitelistSwing = State
			task.spawn(function()
				repeat task.wait() until AuraWhitelistSwingMultiBox
				AuraWhitelistSwingMultiBox:SetVisible(State)
			end)
		end
	})
	--
	AuraWhitelistSwingMultiBox = AuraSection:MultiBox({
		Name = "",
		Default = {},
		Content = {"Ignore NPCs", "Ignore Behind Walls"},
		Flag = "AuraWLSwingMultiBox",
		Hidden = true,
		Callback = function(Selected)
			KillAuraData.Settings.IgnoreNPCsSwing = table.find(Selected, "Ignore NPCs")
			KillAuraData.Settings.IgnoreWallsSwing = table.find(Selected, "Ignore Behind Walls")
		end
	})  
	--
	local HardCounterRangeSlider, HardCounterTPDownToggle, HardCounterFreezeTimeSlider
	local HardCounterToggle = AuraSection:Toggle({
		Name = "Hard Counter",
		Default = false,
		Flag = "AuraHardCounter",
		Callback = function(State)
			local keybind = Library.Flags["AuraHardCounterKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["AuraHardCounter"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Hard Counter</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			KillAuraData.Settings.HardCounter = State
			task.spawn(function()
				repeat task.wait() until HardCounterRangeSlider and HardCounterTPDownToggle
				HardCounterRangeSlider:SetVisible(State)
				HardCounterTPDownToggle:SetVisible(State)
				if not State then
					task.spawn(function()
						repeat task.wait() until HardCounterFreezeTimeSlider
						HardCounterFreezeTimeSlider:SetVisible(false)
					end)
				else
					if KillAuraData.Settings.HardCounterTPDown then
						task.spawn(function()
							repeat task.wait() until HardCounterFreezeTimeSlider
							HardCounterFreezeTimeSlider:SetVisible(true)
						end)
					end
				end
			end)
		end
	})
	--
	HardCounterToggle:Keybind({
		Mode = "Toggle",
		Flag = "AuraHardCounterKeybind",
		Callback = function() end
	})
	--
	HardCounterRangeSlider = AuraSection:Slider({
		Name = "",
		Min = 1,
		Max = 20,
		Default = 15,
		Decimal = 1,
		Ending = " studs",
		Flag = "AuraHardCounterRange",
		Hidden = true,
		Callback = function(Value)
			KillAuraData.Settings.HardCounterRange = Value
		end
	})
	--
	HardCounterTPDownToggle = AuraSection:Toggle({
		Name = "TP Down",
		Default = false,
		Flag = "AuraHardCounterTPDown",
		Hidden = true,
		Callback = function(State)
			KillAuraData.Settings.HardCounterTPDown = State
			task.spawn(function()
				repeat task.wait() until HardCounterFreezeTimeSlider and HardCounterTPDownAntivoidToggle
				HardCounterFreezeTimeSlider:SetVisible(State)
				HardCounterTPDownAntivoidToggle:SetVisible(State)
			end)
			if State then
				StartTPDownRaycast()
			end
		end
	})
	--
	HardCounterFreezeTimeSlider = AuraSection:Slider({
		Name = "",
		Min = 0,
		Max = 1,
		Default = 0.3,
		Decimal = 0.1,
		Ending = "s",
		Disable = {"Off", 0, 1.1},
		Flag = "AuraHardCounterTpDownFreezeTime",
		Hidden = true
	})
	--
	HardCounterTPDownAntivoidToggle = AuraSection:Toggle({
		Name = "Anti Void",
		Default = true,
		Flag = "AuraHardCounterTPDownAntivoid",
		Hidden = true
	})
	--
end
--
do
	local ProjectileAuraSection = Rage:Section({Name = "Projectile Aura", Fill = true})
	table.insert(NamedSections, ProjectileAuraSection)
	--
	local ProjectileAuraData = {
		Settings = {
			Range = 40,
			Speed = 200,
			Power = 70,
			Delay = 0,
			MaxAngle = 360,
			MaxAngleEnabled = false,
			TargetMode = "Distance",
			ShowProjectile = false,
			MultiAura = false,
			TargetSettings = false,
			IgnoreNPCs = false,
			IgnoreWalls = false,
			LastStand = false,
			LastStandHealth = 70
		},
		Data = {
			LastSetTarget = false,
			DelayProj = {},
			ProjNames = {arrow = true, snowball = true},
			Params = RaycastParams.new(),
			RavenTPCooldown = 0
		}
	}
	
	local function GetAmmo(Check)
		if not Check.ammoItemTypes then return nil end
		
		local Inv = GetInventory().items
		for i = 1, #Check.ammoItemTypes do
			local Type = Check.ammoItemTypes[i]
			for j = 1, #Inv do
				if Inv[j].itemType == Type then
					return Type
				end
			end
		end
		
		return nil
	end
	
	local function GetProjectileTools()
		local Found = {}
		local Inventory = GetInventory().items
		local WeaponType = Library.Flags["RageWeaponType"]:Get()
		local WeaponTypeValue = type(WeaponType) == "table" and WeaponType.Value or WeaponType
		
		local AllowedProj = {}
		if WeaponTypeValue == "Global" then
			AllowedProj = {arrow = true, snowball = true}
		elseif WeaponTypeValue == "Snowball" then
			AllowedProj = {snowball = true}
		elseif WeaponTypeValue == "Arrow" then
			AllowedProj = {arrow = true}
		elseif WeaponTypeValue == "Raven" then
			AllowedProj = {}
		else
			AllowedProj = {arrow = true, snowball = true}
		end
		
		for i = 1, #Inventory do
			local Item = Inventory[i]
			local Data = GameData.Utils.ItemMeta[Item.itemType]
			local Source = Data and Data.projectileSource
			if Source then
				local Ammo = GetAmmo(Source)
				if Ammo and AllowedProj[Ammo] then
					Found[#Found + 1] = {
						Item = Item,
						Ammo = Ammo,
						Proj = Source.projectileType(Ammo),
						Meta = Source
					}
				end
			end
		end
		
		return next(Found) and Found or {}
	end
	
	local function CheckProjectile(Fired, Obj)
		if not Fired then
			ProjectileAuraData.Data.DelayProj[Obj.Item.itemType] = os.clock()
		else
			local Sounds = Obj.Meta.launchSound
			if Sounds and Sounds[1] then
				GameData.Utils.Sound:playSound(Sounds[1])
			end
		end
	end
	
	local function AimProjectile(Start, LaunchVel, Gravity, TargetPos, TargetVel, HipHeight)
		if not (Start and TargetPos and LaunchVel > 1) then return end
		
		Gravity = Gravity or workspace.Gravity
		HipHeight = HipHeight or 0
		TargetPos = TargetPos + Vector3.new(0, HipHeight, 0)
		
		local Dist = TargetPos - Start
		local Vec = Vector3.new(Dist.X, 0, Dist.Z)
		local Mag = Vec.Magnitude
		local Time = Mag / LaunchVel
		
		local LastTime = 0
		local Iter = 0
		
		while math.abs(Time - LastTime) > 0.001 and Iter < 8 do
			Iter = Iter + 1
			LastTime = Time
			
			local DampFactor = math.clamp(0.4 + (100 / LaunchVel) * 0.1, 0.35, 0.55)
			local Velocity = Vector3.new(TargetVel.X, TargetVel.Y * DampFactor, TargetVel.Z)
			
			local Prediction = TargetPos + Velocity * Time
			local Dist2 = Prediction - Start
			local Horiz = Vector3.new(Dist2.X, 0, Dist2.Z)
			local HorizMag = Horiz.Magnitude
			
			local TimeNew = HorizMag / LaunchVel
			TimeNew = TimeNew + math.abs((Dist2.Y + 0.5 * Gravity * Time^2) / LaunchVel)
			
			Time = (Time + TimeNew) * 0.5
		end
		
		Time = Time + 0.1
		
		local Factor = math.clamp(0.42 + (100 / LaunchVel) * 0.1, 0.38, 0.5)
		local FinalPrediction = TargetPos + Vector3.new(TargetVel.X, TargetVel.Y * Factor, TargetVel.Z) * Time
		
		local DropFactor = math.clamp(0.22 + (80 / LaunchVel) * 0.06 + (Mag / 2000), 0.25, 0.38)
		FinalPrediction = FinalPrediction - Vector3.new(0, (DropFactor * Gravity * Time * Time) - 2.2, 0)
		
		return FinalPrediction
	end
	
	local ProjectileAuraToggle = ProjectileAuraSection:Toggle({
		Name = "Enabled",
		Default = false,
		Flag = "ProjectileAuraEnabled",
		Callback = function(State)
			local keybind = Library.Flags["ProjectileAuraKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["ProjectileAuraEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>ProjectileAura</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			if State then
				task.spawn(function()
					repeat
						if IsAlive(LocalPlayer) and GameData.Utils.Store:getState().Game.matchstate == GameData.Utils.MatchStates.RUNNING then
							local NearestEntity = GetNearestEntity(true, ProjectileAuraData.Settings.TargetMode)
							
							if NearestEntity.Entity then
								if ProjectileAuraData.Settings.TargetSettings and ProjectileAuraData.Settings.IgnoreNPCs and not NearestEntity.Data.Player then
									NearestEntity.Entity = nil
								end
							end
							
							if NearestEntity.Entity and ProjectileAuraData.Settings.Range >= NearestEntity.Distance and IsAlive(NearestEntity.Entity, true) then
								if ProjectileAuraData.Settings.MaxAngleEnabled and GetAngle(LocalPlayer.Character.PrimaryPart.CFrame, NearestEntity.Entity.PrimaryPart.Position) > (ProjectileAuraData.Settings.MaxAngle / 2 * math.pi / 180) then
									task.wait()
									continue
								end
								
								local Pos = LocalPlayer.Character.PrimaryPart.Position
								local WeaponType = Library.Flags["RageWeaponType"]:Get()
								local WeaponTypeValue = type(WeaponType) == "table" and WeaponType.Name or WeaponType
								
								if (WeaponTypeValue == "Raven" or WeaponTypeValue == "Global") and GameData.Utils.RavenController then
									if os.clock() > ProjectileAuraData.Data.RavenTPCooldown then
										local CanUseRaven = true
										if ProjectileAuraData.Settings.LastStand then
											local CurrentHealth = LocalPlayer.Character.Humanoid.Health
											CanUseRaven = CurrentHealth <= ProjectileAuraData.Settings.LastStandHealth
										end
										
										if CanUseRaven then
											local HasRaven = false
											local Inventory = GetInventory().items
											for i = 1, #Inventory do
												if Inventory[i].itemType == "raven" then
													HasRaven = true
													break
												end
											end
											
											if HasRaven and NearestEntity.Entity and NearestEntity.Entity.PrimaryPart then
											ProjectileAuraData.Data.RavenTPCooldown = os.clock() + 3
											
											GameData.Utils.Remotes:Get("SpawnRaven"):CallServerAsync():andThen(function(projectile)
												if projectile then
													local bodyforce = Instance.new('BodyForce')
													bodyforce.Force = Vector3.new(0, projectile.PrimaryPart.AssemblyMass * workspace.Gravity, 0)
													bodyforce.Parent = projectile.PrimaryPart
													
													if NearestEntity.Entity and NearestEntity.Entity.PrimaryPart then
														task.spawn(function()
															for _ = 1, 20 do
																if NearestEntity.Entity.PrimaryPart and projectile then
																	projectile:SetPrimaryPartCFrame(CFrame.lookAlong(NearestEntity.Entity.PrimaryPart.Position, CurrentCamera.CFrame.LookVector))
																end
																task.wait(0.05)
															end
														end)
														task.wait(0.3)
														GameData.Utils.RavenController:detonateRaven()
													end
												end
											end)
											end
										end
									end
								end
								
								local Tools = GetProjectileTools()
								if #Tools > 0 then
									GameData.Data.ProjectileAuraTarget = NearestEntity
									ProjectileAuraData.Data.LastSetTarget = true
									
									for i = 1, #Tools do
										local Obj = Tools[i]
										local ItemType = Obj.Item.itemType
										
										if (ProjectileAuraData.Data.DelayProj[ItemType] or 0) < os.clock() then
											local ProjData = GameData.Utils.ProjMeta[Obj.Proj]
											local LaunchVel = ProjData.launchVelocity
											local AimPos = AimProjectile(Pos, LaunchVel, ProjData.gravitationalAcceleration or 196.2, NearestEntity.Entity.PrimaryPart.Position, NearestEntity.Entity.PrimaryPart.Velocity, NearestEntity.Entity.Humanoid.HipHeight)
											
											if AimPos then
												if ProjectileAuraData.Settings.TargetSettings and ProjectileAuraData.Settings.IgnoreWalls then
													ProjectileAuraData.Data.Params.FilterType = Enum.RaycastFilterType.Exclude
													ProjectileAuraData.Data.Params.FilterDescendantsInstances = CollectionService:GetTagged("entity")
													if not IsPathClear(NearestEntity.Entity, NearestEntity.Entity.PrimaryPart, ProjectileAuraData.Data.Params) then
														task.wait()
														continue
													end
												end
												
												if not ProjectileAuraData.Settings.MultiAura and GameData.Data.KillAuraTarget then
													task.wait()
													continue
												end
												
												SwitchItem(Obj.Item.tool, true)
												coroutine.wrap(function()
													local LookVec = (CFrame.new(Pos, AimPos)).LookVector * LaunchVel
													
													if ProjectileAuraData.Settings.ShowProjectile then
														GameData.Utils.Projectile:createLocalProjectile(ProjData, Obj.Ammo, Obj.Proj, CFrame.new(Pos, AimPos).Position, HttpService:GenerateGUID(true), LookVec, {drawDurationSeconds = 1})
													end
													
													GameData.Utils.Remotes:Get("ProjectileFire"):CallServerAsync(
														Obj.Item.tool, Obj.Ammo, Obj.Proj,
														CFrame.new(Pos, AimPos).Position,
														Pos, LookVec,
														HttpService:GenerateGUID(true),
														{drawDurationSec = ProjectileAuraData.Settings.Speed / 100, shotId = HttpService:GenerateGUID(false)},
														workspace:GetServerTimeNow() - 0.01 * ((ProjectileAuraData.Settings.Power - 5) / 2)
													):andThen(function(Ammo)
														CheckProjectile(Ammo, Obj)
													end)
												end)()
												
												ProjectileAuraData.Data.DelayProj[ItemType] = os.clock() + (Obj.Meta.fireDelaySec - 0.15)
												if ProjectileAuraData.Settings.Delay > 0 then
													task.wait(ProjectileAuraData.Settings.Delay)
												end
											end
										end
									end
								end
							else
								if ProjectileAuraData.Data.LastSetTarget then
									GameData.Data.ProjectileAuraTarget = nil
									ProjectileAuraData.Data.LastSetTarget = false
								end
							end
							if ProjectileAuraData.Settings.Delay > 0 then
								task.wait(ProjectileAuraData.Settings.Delay)
							end
						end
						task.wait()
					until not IsFeatureEnabled("ProjectileAuraEnabled", "ProjectileAuraKeybind")
				end)
			else
				if ProjectileAuraData.Data.LastSetTarget then
					GameData.Data.ProjectileAuraTarget = nil
					ProjectileAuraData.Data.LastSetTarget = false
				end
			end
		end
	})
	--
	ProjectileAuraToggle:Keybind({
		Mode = "Toggle",
		Flag = "ProjectileAuraKeybind",
		Callback = function() end
	})
	--
	ProjectileAuraSection:Dropdown({
		Name = "",
		Default = "Distance",
		Content = {"Distance", "Health", "Threat"},
		Flag = "ProjectileAuraTargetMode",
		Callback = function(Option)
			ProjectileAuraData.Settings.TargetMode = Option
		end
	})
	--
	ProjectileAuraSection:Slider({
		Name = "Attack Range",
		Min = 1,
		Max = 50,
		Default = 40,
		Decimal = 1,
		Ending = " studs",
		OverrideLimit = true,
		Flag = "ProjectileAuraRange",
		Callback = function(Value)
			ProjectileAuraData.Settings.Range = Value
		end
	})
	--
	ProjectileAuraSection:Slider({
		Name = "Shoot Time",
		Min = 0,
		Max = 1,
		Default = 0.1,
		Decimal = 0.1,
		Ending = "s",
		OverrideLimit = true,
		Flag = "ProjectileAuraDelay",
		Callback = function(Value)
			ProjectileAuraData.Settings.Delay = Value
		end
	})
	--
	local MaxAngleProjSlider = nil
	--
	local MaxAngleProjToggle = ProjectileAuraSection:Toggle({
		Name = "Max Angle",
		Default = false,
		Flag = "ProjectileAuraMaxAngleEnabled",
		Callback = function(State)
			ProjectileAuraData.Settings.MaxAngleEnabled = State
			task.spawn(function()
				repeat task.wait() until MaxAngleProjSlider
				MaxAngleProjSlider:SetVisible(State)
			end)
		end
	})
	--
	MaxAngleProjSlider = ProjectileAuraSection:Slider({
		Name = "",
		Min = 1,
		Max = 360,
		Default = 360,
		Decimal = 1,
		Ending = "°",
		UseIcons = false,
		Flag = "ProjectileAuraMaxAngle",
		Hidden = true,
		Callback = function(Value)
			ProjectileAuraData.Settings.MaxAngle = Value
		end
	})
	--
	local ProjectileAuraTargetMultiBox
	local ProjectileAuraTargetToggle = ProjectileAuraSection:Toggle({
		Name = "Target Settings",
		Default = false,
		Flag = "ProjectileAuraTargetSettings",
		Callback = function(State)
			ProjectileAuraData.Settings.TargetSettings = State
			task.spawn(function()
				repeat task.wait() until ProjectileAuraTargetMultiBox
				ProjectileAuraTargetMultiBox:SetVisible(State)
			end)
		end
	})
	--
	ProjectileAuraTargetMultiBox = ProjectileAuraSection:MultiBox({
		Name = "",
		Default = {},
		Content = {"Ignore NPCs", "Ignore Behind Walls"},
		Flag = "ProjectileAuraTargetMultiBox",
		Hidden = true,
		Callback = function(Selected)
			ProjectileAuraData.Settings.IgnoreNPCs = table.find(Selected, "Ignore NPCs")
			ProjectileAuraData.Settings.IgnoreWalls = table.find(Selected, "Ignore Behind Walls")
		end
	})
	--
	ProjectileAuraSection:Toggle({
		Name = "Show Projectile",
		Default = false,
		Flag = "ProjectileAuraShowProjectile",
		Callback = function(State)
			ProjectileAuraData.Settings.ShowProjectile = State
		end
	})
	--
	local LastStandSlider = nil
	--
	local LastStandToggle = ProjectileAuraSection:Toggle({
		Name = "Last Stand",
		Default = false,
		Flag = "ProjectileAuraLastStand",
		Callback = function(State)
			ProjectileAuraData.Settings.LastStand = State
			task.spawn(function()
				repeat task.wait() until LastStandSlider
				LastStandSlider:SetVisible(State)
			end)
		end
	})
	--
	LastStandSlider = ProjectileAuraSection:Slider({
		Name = "",
		Min = 1,
		Max = 100,
		Default = 70,
		Decimal = 1,
		Ending = " hp",
		Flag = "ProjectileAuraLastStandHealth",
		Hidden = true,
		Callback = function(Value)
			ProjectileAuraData.Settings.LastStandHealth = Value
		end
	})
	--
	ProjectileAuraSection:Toggle({
		Name = "Multi Aura",
		Default = false,
		Flag = "ProjectileAuraMultiAura",
		Callback = function(State)
			ProjectileAuraData.Settings.MultiAura = State
		end
	})
	--
end
--
do -- Movement
    local MovementSubSection, MovementSubSection2, MovementSubSection3, MovementSubSection4 = Movement:SubSection({Name = "Category", Options = {"rbxassetid://18334627891", "rbxassetid://18334630306", "rbxassetid://18334626899", "rbxassetid://18334625304"}})
    --
    local SpeedSection = MovementSubSection:Section({Name = "Speed", Fill = true})
	table.insert(NamedSections, SpeedSection)
	--
	local SpeedData = {
		Settings = {
			Speed = 23,
			DamageBoostCooldown = 0.8,
			DamageBoost = false,
			AutoSprint = false,
			AutoJump = false,
			CustomJump = false,
			JumpHeight = 50,
			UseBoost = false,
			WallCheck = false
		},
		Data = {
			LastDamaged = os.clock(),
			DamageBoostSpeed = 50,
			DamageBoostTime = 0.4,
			OriginalSpeed = 16,
			OldStopSprinting = nil,
			OriginalJumpPower = 50
		}
	}
	--
	local SpeedToggle = SpeedSection:Toggle({
		Name = "Enabled",
		Default = false,
		Flag = "SpeedEnabled",
		Callback = function(State)
			local keybind = Library.Flags["SpeedKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["SpeedEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Speed</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			if State then
				task.spawn(function()
					repeat
						task.wait()
					until IsAlive(LocalPlayer)
					
					if SpeedData.Settings.AutoSprint then
						SpeedData.Data.OriginalSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
						if not SpeedData.Data.OldStopSprinting then
							SpeedData.Data.OldStopSprinting = GameData.Utils.Sprint.stopSprinting
							GameData.Utils.Sprint.stopSprinting = function()
								return
							end
							
							task.spawn(function()
								repeat
									if IsFeatureEnabled("SpeedEnabled", "SpeedKeybind") then
										if not GameData.Utils.Sprint:isSprinting() then
											GameData.Utils.Sprint:startSprinting()
										end
									end
									task.wait()
								until not SpeedData.Settings.AutoSprint or not IsFeatureEnabled("SpeedEnabled", "SpeedKeybind")
								
								if SpeedData.Data.OldStopSprinting then
									GameData.Utils.Sprint.stopSprinting = SpeedData.Data.OldStopSprinting
									GameData.Utils.Sprint:stopSprinting()
									SpeedData.Data.OldStopSprinting = nil
								end
							end)
						end
					end
				end)
				
				task.spawn(function()
					local DamageConnection = GameData.Events.Damage.Event:Connect(function(Values)
						if Values.Type.Value ~= "FALL" and Values.DamagedPlayer == LocalPlayer then
							local TimeSinceLastDamage = os.clock() - SpeedData.Data.LastDamaged
							if TimeSinceLastDamage > SpeedData.Data.DamageBoostTime + SpeedData.Settings.DamageBoostCooldown then
								SpeedData.Data.LastDamaged = os.clock()
								
								if Values.Type.Value == "TNT" then
									SpeedData.Data.DamageBoostSpeed = 55
									SpeedData.Data.DamageBoostTime = 0.8
								else
									SpeedData.Data.DamageBoostSpeed = 40
									SpeedData.Data.DamageBoostTime = 0.4
								end
							end
						end
					end)
					
					repeat
						task.wait()
						if IsAlive(LocalPlayer) and isnetworkowner(LocalPlayer.Character.PrimaryPart) then
							local Root = LocalPlayer.Character.PrimaryPart
							local Humanoid = LocalPlayer.Character.Humanoid
							
							if SpeedData.Settings.AutoJump and Humanoid.MoveDirection.Magnitude > 0 then
								if Humanoid.FloorMaterial ~= Enum.Material.Air then
									Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								end
							end
							
							if SpeedData.Settings.CustomJump then
								Humanoid.JumpPower = SpeedData.Settings.JumpHeight
							else
								Humanoid.JumpPower = SpeedData.Data.OriginalJumpPower
							end
							
							if Humanoid.MoveDirection.Magnitude > 0 then
								local Speed = SpeedData.Settings.Speed
								if SpeedData.Settings.DamageBoost and SpeedData.Data.DamageBoostTime > (os.clock() - SpeedData.Data.LastDamaged) then
									Speed = SpeedData.Data.DamageBoostSpeed
								end
								
								if SpeedData.Settings.UseBoost then
									local Multiplier = GetSpeedMultiplier()
									if Multiplier ~= 0 then
										Speed = math.clamp(Speed * Multiplier, 0, 46)
									end
								end
								
								if Speed > 0 then
									local CurrentVelocity = Root.AssemblyLinearVelocity
									local TargetVelocity = Vector3.new(Humanoid.MoveDirection.X * Speed, CurrentVelocity.Y, Humanoid.MoveDirection.Z * Speed)
									
									if SpeedData.Settings.WallCheck then
										local RayParams = RaycastParams.new()
										RayParams.FilterType = Enum.RaycastFilterType.Exclude
										RayParams.FilterDescendantsInstances = {LocalPlayer.Character}
										
										local RayDirection = Humanoid.MoveDirection * 2.5
										local CanMove = true
										
										local RightVector = Humanoid.MoveDirection:Cross(Vector3.new(0, 1, 0)).Unit
										
										local RayOffsets = {
											Vector3.new(0, 0, 0),           -- Center
											Vector3.new(0, -1.5, 0),        -- Bottom
											Vector3.new(0, 1, 0),           -- Top
											Vector3.new(0, 0.5, 0),         -- Mid-top
											Vector3.new(0, -1, 0),          -- Mid-bottom
											
											RightVector * 1.5,              -- Right
											RightVector * -1.5,             -- Left
											RightVector * 1,                -- Right close
											RightVector * -1,               -- Left close
											
											RightVector * 1.5 + Vector3.new(0, -1.5, 0),  -- Right bottom
											RightVector * -1.5 + Vector3.new(0, -1.5, 0), -- Left bottom
											RightVector * 1.5 + Vector3.new(0, 1, 0),     -- Right top
											RightVector * -1.5 + Vector3.new(0, 1, 0),    -- Left top
											RightVector * 1 + Vector3.new(0, -1, 0),      -- Right mid-bottom
											RightVector * -1 + Vector3.new(0, -1, 0)      -- Left mid-bottom
										}
										
										for _, Offset in ipairs(RayOffsets) do
											local RayOrigin = Root.Position + Offset
											local RayResult = workspace:Raycast(RayOrigin, RayDirection, RayParams)
											
											if RayResult and not (RayResult.Instance and GameData.Utils.GameQuery:isQueryIgnored(RayResult.Instance)) then
												CanMove = false
												break
											end
										end
										
										if CanMove then
											Root.AssemblyLinearVelocity = TargetVelocity
										end
									else
										Root.AssemblyLinearVelocity = TargetVelocity
									end
								end
							end
						end
					until not IsFeatureEnabled("SpeedEnabled", "SpeedKeybind")
					
					if DamageConnection then
						DamageConnection:Disconnect()
					end
				end)
			else
				if SpeedData.Data.OldStopSprinting then
					GameData.Utils.Sprint.stopSprinting = SpeedData.Data.OldStopSprinting
					GameData.Utils.Sprint:stopSprinting()
				end
			end
		end
	})
	--
	SpeedToggle:Keybind({
		Mode = "Toggle",
		Flag = "SpeedKeybind",
		Callback = function() end
	})
	--
	SpeedSection:Dropdown({
        Name = "",
        Default = "Velocity",
        Content = {"Velocity", "Impulse", "CFrame", "Walkspeed", "Tween"}, -- Make sure for walkspeed when its disabled, it goes back to the orginial speed
        Flag = "SpeedMode",
        Callback = function(Option)
        end
    })
    --
	SpeedSection:Slider({
		Name = "Speed",
		Min = 0,
		Max = 23,
		Default = 23,
		Decimal = 1,
		Ending = " studs",
		Flag = "SpeedValue",
		Disable = {"Off", 0, 24},
		Callback = function(Value)
			SpeedData.Settings.Speed = Value
		end
	})
	--
	local DamageBoostCooldownSlider = nil
	--
	local DamageBoostToggle = SpeedSection:Toggle({
		Name = "Damage Boost",
		Default = false,
		Flag = "SpeedDamageBoost",
		Callback = function(State)
			SpeedData.Settings.DamageBoost = State
			task.spawn(function()
				repeat task.wait() until DamageBoostCooldownSlider
				DamageBoostCooldownSlider:SetVisible(State)
			end)
		end
	})
	--
	DamageBoostCooldownSlider = SpeedSection:Slider({
		Name = "",
		Min = 0,
		Max = 3,
		Default = 0.8,
		Decimal = 0.1,
		Ending = "s",
		Hidden = true,
		Flag = "SpeedDamageBoostCooldown",
		Callback = function(Value)
			SpeedData.Settings.DamageBoostCooldown = Value
		end
	})
	--
	SpeedSection:Toggle({
		Name = "Wall Check",
		Default = false,
		Flag = "SpeedWallCheck",
		Callback = function(State)
			SpeedData.Settings.WallCheck = State
		end
	})
	--
	local AutoSprintToggle = SpeedSection:Toggle({
		Name = "Auto Sprint",
		Default = false,
		Flag = "SpeedAutoSprint",
		Callback = function(State)
			SpeedData.Settings.AutoSprint = State
			if State and IsFeatureEnabled("SpeedEnabled", "SpeedKeybind") and not SpeedData.Data.OldStopSprinting then
				SpeedData.Data.OldStopSprinting = GameData.Utils.Sprint.stopSprinting
				GameData.Utils.Sprint.stopSprinting = function()
					return
				end
				
				task.spawn(function()
					repeat
						if IsFeatureEnabled("SpeedEnabled", "SpeedKeybind") then
							if not GameData.Utils.Sprint:isSprinting() then
								GameData.Utils.Sprint:startSprinting()
							end
						end
						task.wait()
					until not SpeedData.Settings.AutoSprint or not IsFeatureEnabled("SpeedEnabled", "SpeedKeybind")
					
					if SpeedData.Data.OldStopSprinting then
						GameData.Utils.Sprint.stopSprinting = SpeedData.Data.OldStopSprinting
						GameData.Utils.Sprint:stopSprinting()
						SpeedData.Data.OldStopSprinting = nil
					end
				end)
			else
				if SpeedData.Data.OldStopSprinting then
					GameData.Utils.Sprint.stopSprinting = SpeedData.Data.OldStopSprinting
					GameData.Utils.Sprint:stopSprinting()
					SpeedData.Data.OldStopSprinting = nil
				end
			end
		end
	})
	--
	AutoSprintToggle:Keybind({
		Mode = "Toggle",
		Flag = "SpeedAutoSprintKeybind",
		Callback = function() end
	})
	--
	local JumpHeightSlider = nil
    local CustomJumpToggle = nil
    --
    local AutoJumpToggle = SpeedSection:Toggle({
        Name = "Auto Jump",
        Default = false,
        Flag = "AutoJumpEnabled",
        Callback = function(State)
            SpeedData.Settings.AutoJump = State
            task.spawn(function()
                repeat task.wait() until CustomJumpToggle
                CustomJumpToggle:SetVisible(State)
                if not State then
                    task.spawn(function()
                        repeat task.wait() until JumpHeightSlider
                        JumpHeightSlider:SetVisible(false)
                    end)
                else
                    if SpeedData.Settings.CustomJump then
                        task.spawn(function()
                            repeat task.wait() until JumpHeightSlider
                            JumpHeightSlider:SetVisible(true)
                        end)
                    end
                end
            end)
        end
    })
    --
    AutoJumpToggle:Keybind({
        Default = nil,
        Mode = "Toggle",
        UseMode = true,
        Flag = "AutoJumpKeybind",
        Callback = function() end
    })
    --
    CustomJumpToggle = SpeedSection:Toggle({
        Name = "Custom Jump",
        Default = false,
        Flag = "CustomJumpEnabled",
        Hidden = true,
        Callback = function(State)
            SpeedData.Settings.CustomJump = State
            
            if State and IsAlive(LocalPlayer) then
                SpeedData.Data.OriginalJumpPower = LocalPlayer.Character.Humanoid.JumpPower
                task.spawn(function()
                    repeat task.wait() until JumpHeightSlider
                    JumpHeightSlider:Set(SpeedData.Data.OriginalJumpPower)
                end)
            end
            
            task.spawn(function()
                repeat task.wait() until JumpHeightSlider
                JumpHeightSlider:SetVisible(State)
            end)
        end
    })
    --
    JumpHeightSlider = SpeedSection:Slider({
        Name = "",
        Min = 0,
        Max = 200,
        Default = 50,
        Decimal = 1,
		OverrideLimit = true,
        Flag = "JumpHeight",
        Hidden = true,
        Callback = function(Value)
            SpeedData.Settings.JumpHeight = Value
        end
    })
	--
	SpeedSection:Toggle({
		Name = "Consumable Boost",
		Default = false,
		Flag = "SpeedConsumableBoost",
		Callback = function(State)
			SpeedData.Settings.UseBoost = State
		end
	})
	--
	local FlySection = MovementSubSection:Section({Name = "Flight", Side = "Right", Fill = true})
	table.insert(NamedSections, FlySection)
	--
	local FlyData = {
		Settings = {
			Speed = 23,
			VerticalSpeed = 40,
			WallCheck = false,
			TpDown = false,
			UseBoost = false
		},
		Data = {
			Vertical = 0,
			UpPressed = false,
			DownPressed = false,
			Params = RaycastParams.new(),
			LastCFrame = nil
		}
	}
	--
	FlyData.Data.Params.FilterType = Enum.RaycastFilterType.Include
	FlyData.Data.Params.FilterDescendantsInstances = BlockList
	FlyData.Data.Params.RespectCanCollide = true
	--
	local FlyToggle = FlySection:Toggle({
		Name = "Enabled",
		Default = false,
		Flag = "FlyEnabled",
		Callback = function(State)
			local keybind = Library.Flags["FlyKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["FlyEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Flight</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			if State then
				local InputBeganConnection = UserInputService.InputBegan:Connect(function(Input, Processed)
					if UserInputService:GetFocusedTextBox() then return end
					if Input.KeyCode == Enum.KeyCode.Space then
						FlyData.Data.UpPressed = true
						if FlyData.Data.DownPressed then
							FlyData.Data.Vertical = 0
						else
							FlyData.Data.Vertical = 1
						end
					elseif Input.KeyCode == Enum.KeyCode.LeftShift then
						FlyData.Data.DownPressed = true
						if FlyData.Data.UpPressed then
							FlyData.Data.Vertical = 0
						else
							FlyData.Data.Vertical = -1
						end
					end
				end)
				
				local InputEndedConnection = UserInputService.InputEnded:Connect(function(Input, Processed)
					if UserInputService:GetFocusedTextBox() then return end
					if Input.KeyCode == Enum.KeyCode.Space then
						FlyData.Data.UpPressed = false
						if FlyData.Data.DownPressed then
							FlyData.Data.Vertical = -1
						else
							FlyData.Data.Vertical = 0
						end
					elseif Input.KeyCode == Enum.KeyCode.LeftShift then
						FlyData.Data.DownPressed = false
						if FlyData.Data.UpPressed then
							FlyData.Data.Vertical = 1
						else
							FlyData.Data.Vertical = 0
						end
					end
				end)
				
				FlyData.Data.LastOnGround = os.clock()
				FlyData.Data.TpToggle = true
				FlyData.Data.OldY = nil
				FlyData.Data.TpTick = 0
				
				task.spawn(function()
					repeat
						task.wait()
						
						if IsAlive(LocalPlayer) and isnetworkowner(LocalPlayer.Character.PrimaryPart) then
							local Root = LocalPlayer.Character.PrimaryPart
							local Humanoid = LocalPlayer.Character.Humanoid
							
							if Humanoid.Health <= 0 or Humanoid:GetState() == Enum.HumanoidStateType.Dead then
								TPDownData.Data.TpToggle = true
								TPDownData.Data.OldY = nil
								TPDownData.Data.TpTick = 0
								TPDownData.Data.LastOnGround = os.clock()
							end
							
							
							local RayCheck = workspace:Raycast(Root.Position, Vector3.new(0, -1000, 0), FlyData.Data.Params)
							if RayCheck then
								FlyData.Data.LastCFrame = Root.CFrame
							end
							
							local YValue = 0
							local Speed = FlyData.Settings.Speed
							local CurrentVelocity = Root.AssemblyLinearVelocity
							local SpeedVelocity = CurrentVelocity
							
							if FlyData.Data.Vertical ~= 0 then
								if FlyData.Data.Vertical == 1 then
									YValue = FlyData.Settings.VerticalSpeed
								elseif FlyData.Data.Vertical == -1 then
									YValue = -FlyData.Settings.VerticalSpeed
								end
							end
							
							local NewSpeed = Speed
							if FlyData.Settings.UseBoost then
								local Multiplier = GetSpeedMultiplier()
								if Multiplier ~= 0 then
									NewSpeed = math.clamp(Speed * Multiplier, 0, 46)
								end
							end
							
							if Humanoid.MoveDirection.Magnitude > 0 then
								SpeedVelocity = Vector3.new(Humanoid.MoveDirection.X * NewSpeed, 0, Humanoid.MoveDirection.Z * NewSpeed)
								
								if FlyData.Settings.WallCheck then
									local RayParams = RaycastParams.new()
									RayParams.FilterType = Enum.RaycastFilterType.Exclude
									RayParams.FilterDescendantsInstances = {LocalPlayer.Character}
									
									local RayDirection = Humanoid.MoveDirection * 2.5
									local CanMove = true
									
									local RightVector = Humanoid.MoveDirection:Cross(Vector3.new(0, 1, 0)).Unit
									
									local RayOffsets = {
										Vector3.new(0, 0, 0),           -- Center
										Vector3.new(0, -1.5, 0),        -- Bottom
										Vector3.new(0, 1, 0),           -- Top
										Vector3.new(0, 0.5, 0),         -- Mid-top
										Vector3.new(0, -1, 0),          -- Mid-bottom
										
										RightVector * 1.5,              -- Right
										RightVector * -1.5,             -- Left
										RightVector * 1,                -- Right close
										RightVector * -1,               -- Left close
										
										RightVector * 1.5 + Vector3.new(0, -1.5, 0),  -- Right bottom
										RightVector * -1.5 + Vector3.new(0, -1.5, 0), -- Left bottom
										RightVector * 1.5 + Vector3.new(0, 1, 0),     -- Right top
										RightVector * -1.5 + Vector3.new(0, 1, 0),    -- Left top
										RightVector * 1 + Vector3.new(0, -1, 0),      -- Right mid-bottom
										RightVector * -1 + Vector3.new(0, -1, 0)      -- Left mid-bottom
									}
									
									for _, Offset in ipairs(RayOffsets) do
										local RayOrigin = Root.Position + Offset
										local RayResult = workspace:Raycast(RayOrigin, RayDirection, RayParams)
										
										if RayResult and not (RayResult.Instance and GameData.Utils.GameQuery:isQueryIgnored(RayResult.Instance)) then
											CanMove = false
											break
										end
									end
									
									if not CanMove then
										SpeedVelocity = CurrentVelocity
									end
								end
							end
							
							if FlyData.Settings.WallCheck and YValue ~= 0 then
								local RayParams = RaycastParams.new()
								RayParams.FilterType = Enum.RaycastFilterType.Exclude
								RayParams.FilterDescendantsInstances = {LocalPlayer.Character}
								
								local VerticalDirection = Vector3.new(0, YValue > 0 and 3 or -3, 0)
								local CanMoveVertical = true
								
								local VerticalOffsets = {
									Vector3.new(0, 0, 0),      -- Center
									Vector3.new(1, 0, 0),      -- Right
									Vector3.new(-1, 0, 0),     -- Left
									Vector3.new(0, 0, 1),      -- Front
									Vector3.new(0, 0, -1),     -- Back
									Vector3.new(1, 0, 1),      -- Front-right
									Vector3.new(-1, 0, 1),     -- Front-left
									Vector3.new(1, 0, -1),     -- Back-right
									Vector3.new(-1, 0, -1)     -- Back-left
								}
								
								for _, Offset in ipairs(VerticalOffsets) do
									local RayOrigin = Root.Position + Offset
									local RayResult = workspace:Raycast(RayOrigin, VerticalDirection, RayParams)
									
									if RayResult then
										local IsWater = RayResult.Material == Enum.Material.Water
										local IsIgnored = RayResult.Instance and GameData.Utils.GameQuery:isQueryIgnored(RayResult.Instance)
										
										if not IsWater and not IsIgnored then
											CanMoveVertical = false
											break
										end
									end
								end
								
								if not CanMoveVertical then
									YValue = 0
								end
							end
							
							Root.AssemblyLinearVelocity = Vector3.new(
								SpeedVelocity.X,
								YValue ~= 0 and YValue or (CurrentVelocity.Y > 0 and 1 or -CurrentVelocity.Y),
								SpeedVelocity.Z
							)
						end
					until not IsFeatureEnabled("FlyEnabled", "FlyKeybind")
					
					InputBeganConnection:Disconnect()
					InputEndedConnection:Disconnect()
					FlyData.Data.Vertical = 0
					FlyData.Data.UpPressed = false
					FlyData.Data.DownPressed = false
				end)
			else
				if TPDownData.Data.PreFreezeActive then
					ContextActionService:UnbindAction("PreFreezeMovement")
					TPDownData.Data.PreFreezeActive = false
					TPDownData.Data.PreFreezeStartTime = 0
				end
				if TPDownData.Data.FreezeEndTime > 0 then
					ContextActionService:UnbindAction("FreezeMovement")
					TPDownData.Data.FreezeEndTime = 0
				end
			end
		end
	})
	--
	FlyToggle:Keybind({
		Mode = "Toggle",
		Flag = "FlyKeybind",
		Callback = function() end
	})
	--
	FlySection:Dropdown({
        Name = "",
        Default = "Velocity",
        Content = {"Velocity", "Impulse", "CFrame", "Walkspeed", "Tween"}, -- Make sure for walkspeed when its disabled, it goes back to the orginial speed
        Flag = "FlyMode",
        Callback = function(Option)
        end
    })
	--
	FlySection:Slider({
		Name = "Speed",
		Min = 0,
		Max = 23,
		Default = 23,
		Decimal = 1,
		Ending = " studs",
		Flag = "FlySpeed",
		Callback = function(Value)
			FlyData.Settings.Speed = Value
		end
	})
	--
	FlySection:Slider({
		Name = "Vertical Speed",
		Min = 0,
		Max = 100,
		Default = 40,
		Decimal = 1,
		Ending = " studs",
		OverrideLimit = true,
		Flag = "FlyVerticalSpeed",
		Callback = function(Value)
			FlyData.Settings.VerticalSpeed = Value
		end
	})
	--
	FlySection:Toggle({
		Name = "Wall Check",
		Default = false,
		Flag = "FlyWallCheck",
		Callback = function(State)
			FlyData.Settings.WallCheck = State
		end
	})
	--
	local FlyTpDownFreezeTimeSlider, FlyTpDownAntivoidToggle
	FlySection:Toggle({
		Name = "TP Down",
		Default = false,
		Flag = "FlyTpDown",
		Callback = function(State)
			FlyData.Settings.TpDown = State
			task.spawn(function()
				repeat task.wait() until FlyTpDownFreezeTimeSlider and FlyTpDownAntivoidToggle
				FlyTpDownFreezeTimeSlider:SetVisible(State)
				FlyTpDownAntivoidToggle:SetVisible(State)
			end)
			if State then
				StartTPDownRaycast()
			end
		end
	})
	--
	FlyTpDownFreezeTimeSlider = FlySection:Slider({
		Name = "",
		Min = 0,
		Max = 0.5,
		Default = 0.3,
		Decimal = 0.1,
		Ending = "s",
		Disable = {"Off", 0, 0.6},
		Flag = "FlyTpDownFreezeTime",
		Hidden = true
	})
	--
	FlyTpDownAntivoidToggle = FlySection:Toggle({
		Name = "Anti Void",
		Default = true,
		Flag = "FlyTpDownAntivoid",
		Hidden = true
	})
	--
	FlySection:Toggle({
		Name = "Consumable Boost",
		Default = false,
		Flag = "FlyConsumableBoost",
		Callback = function(State)
			FlyData.Settings.UseBoost = State
		end
	})
	--
	local function GetNearestChest(Ignore)
		local Data = {
			Chest = nil,
			Distance = math.huge
		}
		
		for i,v in CollectionService:GetTagged("chest") do
			if not table.find(Ignore, v) and v:FindFirstChild("ChestFolderValue") and v.ChestFolderValue.Value and IsAlive(LocalPlayer) then
				local Distance = GetDistanceFrom(LocalPlayer.Character.PrimaryPart.Position, v.Position)
				if Data.Distance > Distance then
					Data = {
						Chest = v,
						Distance = Distance,
						ChestFolder = v.ChestFolderValue.Value
					}
				end
			end
		end
		
		return Data
	end
	--
	local CharacterSection = MovementSubSection2:Section({Name = "Character", Side = "Right", Fill = true})
	table.insert(NamedSections, CharacterSection)
	--
	local ChestStealerData = {
		Settings = {
			Range = 20,
			Delay = 0,
			UICheck = false
		},
		Data = {
			Opened = {}
		}
	}
	--
	local ChestStealerRangeSlider, ChestStealerDelaySlider, ChestStealerUICheckToggle
	local ChestStealerToggle = CharacterSection:Toggle({
		Name = "Chest Stealer",
		Default = false,
		Flag = "ChestStealerEnabled",
		Callback = function(State)
			local keybind = Library.Flags["ChestStealerKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["ChestStealerEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Chest Stealer</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			task.spawn(function()
				repeat task.wait() until ChestStealerRangeSlider and ChestStealerDelaySlider and ChestStealerUICheckToggle
				ChestStealerRangeSlider:SetVisible(State)
				ChestStealerDelaySlider:SetVisible(State)
				ChestStealerUICheckToggle:SetVisible(State)
			end)
			
			if State then
				task.spawn(function()
					repeat
						local Chest = GetNearestChest(ChestStealerData.Data.Opened)
						if Chest.Chest and ChestStealerData.Settings.Range >= Chest.Distance and not table.find(ChestStealerData.Data.Opened, Chest.Chest) and #Chest.ChestFolder:GetChildren() > 0 then
							if ChestStealerData.Settings.UICheck and not GameData.Utils.App:isAppOpen(GameData.Utils.AppIds.CHEST_INVENTORY) then
								continue
							end
							
							local InsertValue = #ChestStealerData.Data.Opened + 1
							table.insert(ChestStealerData.Data.Opened, InsertValue, Chest.Chest)
							task.delay(0.5, table.remove, ChestStealerData.Data.Opened, InsertValue)
							
							GameData.Utils.Remotes:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(Chest.Chest)
							if not Chest.Chest:GetAttribute("ChestOpened") then
								coroutine.wrap(function()
									GameData.Utils.Chest:playChestOpenAnimation(Chest.Chest)
									Chest.Chest:SetAttribute("ChestOpened", true)
								end)()
							end
							
							task.delay(0.1, function()
								for i,v in Chest.ChestFolder:GetChildren() do
									GameData.Utils.Remotes:GetNamespace("Inventory"):Get("ChestGetItem"):CallServerAsync(Chest.ChestFolder, v)
									if ChestStealerData.Settings.Delay ~= 0 then
										task.wait(ChestStealerData.Settings.Delay)
									end
								end
								
								GameData.Utils.Remotes:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer()
							end)
						end
						task.wait(0.1)
					until not IsFeatureEnabled("ChestStealerEnabled", "ChestStealerKeybind")
				end)
			end
		end
	})
	--
	ChestStealerToggle:Keybind({
		Mode = "Toggle",
		Flag = "ChestStealerKeybind",
		Callback = function() end
	})
	--
	ChestStealerRangeSlider = CharacterSection:Slider({
		Name = "",
		Min = 1,
		Max = 20,
		Default = 20,
		Decimal = 1,
        Ending = " studs",
		Flag = "ChestStealerRange",
		Hidden = true,
		Callback = function(Value)
			ChestStealerData.Settings.Range = Value
		end
	})
	--
	ChestStealerDelaySlider = CharacterSection:Slider({
		Name = "Delay",
		Min = 0,
		Max = 1,
		Default = 0,
		Decimal = 0.1,
        Ending = "s",
		Flag = "ChestStealerDelay",
		Hidden = true,
		Callback = function(Value)
			ChestStealerData.Settings.Delay = Value
		end
	})
	--
	ChestStealerUICheckToggle = CharacterSection:Toggle({
		Name = "GUI Check",
		Default = false,
		Flag = "ChestStealerUICheck",
		Hidden = true,
		Callback = function(State)
			ChestStealerData.Settings.UICheck = State
		end
	})
	--
	local NoFallToggle = CharacterSection:Toggle({
		Name = "No Fall",
		Default = false,
		Flag = "NoFallEnabled",
		Callback = function(State)
			local keybind = Library.Flags["NoFallKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["NoFallEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>No Fall</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			if State then
				task.spawn(function()
					repeat
						if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('Humanoid') and LocalPlayer.Character.PrimaryPart then
							local velocity = LocalPlayer.Character.PrimaryPart.Velocity.Y
							if velocity < -86 then
								LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
							end
						end
						task.wait()
					until not IsFeatureEnabled("NoFallEnabled", "NoFallKeybind")
				end)
			end
		end
	})
	--
	NoFallToggle:Keybind({
		Mode = "Toggle",
		Flag = "NoFallKeybind",
		Callback = function() end
	})
	--
	local VelocityData = {
		Settings = {
			Horizontal = 0,
			Vertical = 0,
			Chance = 100
		},
		Data = {
			OldKnockback = nil
		}
	}
	--
	local VelocityHorizontalSlider, VelocityVerticalSlider, VelocityChanceSlider
	local VelocityToggle = CharacterSection:Toggle({
		Name = "Velocity",
		Default = false,
		Flag = "VelocityEnabled",
		Callback = function(State)
			local keybind = Library.Flags["VelocityKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["VelocityEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Velocity</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			task.spawn(function()
				repeat task.wait() until VelocityHorizontalSlider and VelocityVerticalSlider and VelocityChanceSlider
				VelocityHorizontalSlider:SetVisible(State)
				VelocityVerticalSlider:SetVisible(State)
				VelocityChanceSlider:SetVisible(State)
			end)
			
			if State then
				if not VelocityData.Data.OldKnockback then
					VelocityData.Data.OldKnockback = GameData.Utils.Knockback.applyKnockback
				end
				GameData.Utils.Knockback.applyKnockback = function(root, mass, dir, knockback, ...)
					if math.random(0, 100) > VelocityData.Settings.Chance then 
						return VelocityData.Data.OldKnockback(root, mass, dir, knockback, ...)
					end
					
					knockback = knockback or {}
					if VelocityData.Settings.Horizontal == 0 and VelocityData.Settings.Vertical == 0 then 
						return 
					end
					knockback.horizontal = (knockback.horizontal or 1) * (VelocityData.Settings.Horizontal / 100)
					knockback.vertical = (knockback.vertical or 1) * (VelocityData.Settings.Vertical / 100)
					
					return VelocityData.Data.OldKnockback(root, mass, dir, knockback, ...)
				end
			else
				if VelocityData.Data.OldKnockback then
					GameData.Utils.Knockback.applyKnockback = VelocityData.Data.OldKnockback
					VelocityData.Data.OldKnockback = nil
				end
			end
		end
	})
	--
	VelocityToggle:Keybind({
		Mode = "Toggle",
		Flag = "VelocityKeybind",
		Callback = function() end
	})
	--
	VelocityHorizontalSlider = CharacterSection:Slider({
		Name = "Horizontal",
		Min = 0,
		Max = 100,
		Default = 0,
		Decimal = 1,
		Ending = "%",
		Flag = "VelocityHorizontal",
		Hidden = true,
		Callback = function(Value)
			VelocityData.Settings.Horizontal = Value
		end
	})
	--
	VelocityVerticalSlider = CharacterSection:Slider({
		Name = "Vertical",
		Min = 0,
		Max = 100,
		Default = 0,
		Decimal = 1,
		Ending = "%",
		Flag = "VelocityVertical",
		Hidden = true,
		Callback = function(Value)
			VelocityData.Settings.Vertical = Value
		end
	})
	--
	VelocityChanceSlider = CharacterSection:Slider({
		Name = "Chance",
		Min = 0,
		Max = 100,
		Default = 100,
		Decimal = 1,
		Ending = "%",
		Flag = "VelocityChance",
		Hidden = true,
		Callback = function(Value)
			VelocityData.Settings.Chance = Value
		end
	})
	--
	local AutoConsumeData = {
		Settings = {
			Health = 60
		}
	}
	--
	local function GetInventory()
		return GameData.Utils.InventoryUtil.getInventory(LocalPlayer)
	end
	--
	local function getItem(itemName)
		local inventory = GetInventory()
		if not inventory or not inventory.items then return nil end
		for slot, item in pairs(inventory.items) do
			if item.itemType == itemName then
				return item
			end
		end
		return nil
	end
	--
	local function consumeCheck()
		if not IsAlive(LocalPlayer) then return end
		
		local speedpotion = getItem("speed_potion")
		if speedpotion and not LocalPlayer.Character:GetAttribute("StatusEffect_speed") then
			GameData.Utils.Remotes:Get("ConsumeItem"):CallServerAsync({
				item = speedpotion.tool
			})
		end
		
		if (LocalPlayer.Character:GetAttribute("Health") or 0) <= AutoConsumeData.Settings.Health then
			local apple = getItem("orange") or (not LocalPlayer.Character:GetAttribute("StatusEffect_golden_apple") and getItem("golden_apple")) or getItem("apple")
			if apple then
				GameData.Utils.Remotes:Get("ConsumeItem"):CallServerAsync({
					item = apple.tool
				})
			end
		end
		
		if (LocalPlayer.Character:GetAttribute("Shield_POTION") or 0) < 200 then
			local shield = getItem("big_shield") or getItem("mini_shield")
			if shield then
				GameData.Utils.Remotes:Get("ConsumeItem"):CallServerAsync({
					item = shield.tool
				})
			end
		end
	end
	--
	local AutoConsumeHealthSlider
	local AutoConsumeToggle = CharacterSection:Toggle({
		Name = "Auto Consume",
		Default = false,
		Flag = "AutoConsumeEnabled",
		Callback = function(State)
			local keybind = Library.Flags["AutoConsumeKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["AutoConsumeEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Auto Consume</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			task.spawn(function()
				repeat task.wait() until AutoConsumeHealthSlider
				AutoConsumeHealthSlider:SetVisible(State)
			end)
			
			if State then
				task.spawn(function()
					repeat
						consumeCheck()
						task.wait(0.1)
					until not IsFeatureEnabled("AutoConsumeEnabled", "AutoConsumeKeybind")
				end)
			end
		end
	})
	--
	AutoConsumeToggle:Keybind({
		Mode = "Toggle",
		Flag = "AutoConsumeKeybind",
		Callback = function() end
	})
	--
	AutoConsumeHealthSlider = CharacterSection:Slider({
		Name = "",
		Min = 1,
		Max = 100,
		Default = 60,
		Decimal = 1,
		Ending = " hp",
		Flag = "AutoConsumeHealth",
		Hidden = true,
		Callback = function(Value)
			AutoConsumeData.Settings.Health = Value
		end
	})
    --
	local LongJumpSection = MovementSubSection2:Section({Name = "Long Jump", Fill = true})
	table.insert(NamedSections, LongJumpSection)
	--
	local LongJumpData = {
		Settings = {
			Speed = 51,
			Time = 2.5,
			UseBoost = true,
			DirectionMode = "Single Direction",
			CameraDirection = false
		},
		Data = {
			JumpSpeed = 0,
			JumpTick = 0,
			Direction = nil,
			StartPos = nil
		}
	}
	--
	local LongJumpToggle = LongJumpSection:Toggle({
		Name = "Enabled",
		Default = false,
		Flag = "LongJumpEnabled",
		Callback = function(State)
			local keybind = Library.Flags["LongJumpKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["LongJumpEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Long Jump</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			if State then
				task.spawn(function()
					if not IsAlive(LocalPlayer) then
						return
					end
					
					local FireBall = GetItem("fireball")
					local CanLongJump = false
					local PrimaryPart = LocalPlayer.Character.PrimaryPart
					local Humanoid = LocalPlayer.Character.Humanoid
					
					LongJumpData.Data.StartPos = PrimaryPart.Position
					
					if FireBall then
						local TempCon
						TempCon = GameData.Events.Damage.Event:Connect(function(Values)
							if Values.Type.Value == "TNT" and Values.DamagedPlayer == LocalPlayer then
								CanLongJump = true
								
								local KnockbackBoost = GameData.Utils.Knockback.calculateKnockbackVelocity(Vector3.one, 1, {
									vertical = 0,
									horizontal = 1
								}).Magnitude * 1.1
								
								local Vec = (PrimaryPart.Position - PrimaryPart.Position + Vector3.new(0, -30, 0))
								LongJumpData.Data.JumpSpeed = math.max(KnockbackBoost, LongJumpData.Settings.Speed)
								LongJumpData.Data.JumpTick = os.clock() + LongJumpData.Settings.Time
								
								if LongJumpData.Settings.CameraDirection then
									local CamLook = CurrentCamera.CFrame.LookVector
									LongJumpData.Data.Direction = Vector3.new(CamLook.X, 0, CamLook.Z).Unit
								else
									LongJumpData.Data.Direction = Vector3.new(PrimaryPart.CFrame.LookVector.X, 0, PrimaryPart.CFrame.LookVector.Z).Unit
								end
								
								TempCon:Disconnect()
							end
						end)
						
						SwitchItem(FireBall.tool, true)
					local ShootPos = PrimaryPart.Position - PrimaryPart.CFrame.LookVector * 0.1 - Vector3.new(0, 2, 0)
					GameData.Utils.Remotes:Get("ProjectileFire"):CallServerAsync(
						FireBall.tool, FireBall.itemType, FireBall.itemType,
						ShootPos, ShootPos, Vector3.new(0, -30, 0),
						HttpService:GenerateGUID(false),
						{
							drawDurationSec = 0,
							shotId = HttpService:GenerateGUID(false)
						},
						workspace:GetServerTimeNow() - 0.325
					)
					end
					
					repeat task.wait() until CanLongJump or not IsFeatureEnabled("LongJumpEnabled", "LongJumpKeybind")
					
					if not CanLongJump then
						return
					end
					
					local Connection = RunService.PreSimulation:Connect(LPH_NO_VIRTUALIZE(function(dt)
						if not IsFeatureEnabled("LongJumpEnabled", "LongJumpKeybind") then
							return
						end
						
						local Root = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart
						if Root and isnetworkowner(Root) and IsAlive(LocalPlayer) then
							if LongJumpData.Data.JumpTick > os.clock() then
								local CurrentSpeed = (LongJumpData.Data.JumpTick - os.clock()) > 1.1 and LongJumpData.Data.JumpSpeed or 0
								
								if LongJumpData.Settings.UseBoost then
									local Multiplier = GetSpeedMultiplier()
									if Multiplier ~= 0 then
										CurrentSpeed = CurrentSpeed + (Multiplier * 10)
									end
								end
								
								if LongJumpData.Settings.DirectionMode == "Single Direction" then
									Root.AssemblyLinearVelocity = LongJumpData.Data.Direction * CurrentSpeed + Vector3.new(0, Root.AssemblyLinearVelocity.Y, 0)
								else
									local HorizontalVel = Vector3.new(Root.AssemblyLinearVelocity.X, 0, Root.AssemblyLinearVelocity.Z)
									if HorizontalVel.Magnitude > 0 then
										Root.AssemblyLinearVelocity = HorizontalVel.Unit * CurrentSpeed + Vector3.new(0, Root.AssemblyLinearVelocity.Y, 0)
									end
								end
								
								if LocalPlayer.Character.Humanoid.FloorMaterial == Enum.Material.Air and not LongJumpData.Data.StartPos then
									Root.AssemblyLinearVelocity += Vector3.new(0, dt * (workspace.Gravity - 23), 0)
								else
									Root.AssemblyLinearVelocity = Vector3.new(Root.AssemblyLinearVelocity.X, 15, Root.AssemblyLinearVelocity.Z)
								end
								
								LongJumpData.Data.StartPos = nil
							else
								if LongJumpData.Data.StartPos then
									Root.CFrame = CFrame.lookAlong(LongJumpData.Data.StartPos, Root.CFrame.LookVector)
								end
								Root.AssemblyLinearVelocity = Vector3.zero
								LongJumpData.Data.JumpSpeed = 0
								LongJumpData.Data.StartPos = nil
								Connection:Disconnect()
								return
							end
						else
							LongJumpData.Data.StartPos = nil
						end
					end))
					
					repeat task.wait() until not IsFeatureEnabled("LongJumpEnabled", "LongJumpKeybind")
					if Connection then
						Connection:Disconnect()
					end
				end)
			else
				LongJumpData.Data.JumpTick = os.clock()
				LongJumpData.Data.Direction = nil
				LongJumpData.Data.JumpSpeed = 0
				LongJumpData.Data.StartPos = nil
			end
		end
	})
	--
	LongJumpToggle:Keybind({
		Mode = "Toggle",
		Flag = "LongJumpKeybind",
		Callback = function() end
	})
	--
	LongJumpSection:Dropdown({
		Name = "",
		Default = "Single Direction",
		Content = {"Single Direction", "Multidirectional"},
		Flag = "LongJumpDirection",
		Callback = function(Option)
			LongJumpData.Settings.DirectionMode = Option
		end
	})
	--
	LongJumpSection:Slider({
		Name = "Speed",
		Min = 0,
		Max = 51,
		Default = 51,
		Decimal = 1,
		Ending = " studs",
		OverrideLimit = true,
		Flag = "LongJumpSpeed",
		Callback = function(Value)
			LongJumpData.Settings.Speed = Value
		end
	})
	--
	LongJumpSection:Slider({
		Name = "Time",
		Min = 0.5,
		Max = 3,
		Default = 2.5,
		Decimal = 0.1,
		Ending = "s",
		OverrideLimit = true,
		Flag = "LongJumpTime",
		Callback = function(Value)
			LongJumpData.Settings.Time = Value
		end
	})
	--
	LongJumpSection:Toggle({
		Name = "Camera Direction",
		Default = false,
		Flag = "LongJumpCameraDirection",
		Callback = function(State)
			LongJumpData.Settings.CameraDirection = State
		end
	})
	--
	LongJumpSection:Toggle({
		Name = "Consumable Boost",
		Default = true,
		Flag = "LongJumpConsumableBoost",
		Callback = function(State)
			LongJumpData.Settings.UseBoost = State
		end
	})
	--
	MovementSubSection3:Section({Fill = true})
	--
	MovementSubSection3:Section({Side = "Right", Fill = true})
	--
	MovementSubSection4:Section({Fill = true})
	--
	MovementSubSection4:Section({Side = "Right", Fill = true})
    --
	local AimbotSubSection, AimbotSubSection2, AimbotSubSection3, AimbotSubSection4 = Aimbot:SubSection({Name = "Category", Options = {"rbxassetid://18334627891", "rbxassetid://18334630306", "rbxassetid://18334626899", "rbxassetid://18334625304"}})
    --
    local ProjectileAimbotSection = AimbotSubSection:Section({Name = "Projectile Aimbot", Fill = true})
	table.insert(NamedSections, ProjectileAimbotSection)
	--
	local ProjectileAimbotData = {
		Settings = {
			FOVRadius = 500,
			Speed = 1,
			OtherProjectiles = false,
			DistanceCheck = false,
			Distance = 100,
			TargetPart = "HumanoidRootPart",
			TargetSettings = false,
			IgnoreNPCs = false,
			IgnoreWalls = false,
			RangeCircle = false,
			RangeCircleColor = Color3.fromRGB(255, 255, 255),
			RangeCircleTransparency = 0.7,
			RangeCircleFilled = false,
			Blacklisted = {}
		},
		Data = {
			RayParams = RaycastParams.new(),
			Target = nil,
			OldCalculate = nil,
			Circle = nil
		}
	}
	--
	ProjectileAimbotData.Data.RayParams.FilterType = Enum.RaycastFilterType.Include
	ProjectileAimbotData.Data.RayParams.FilterDescendantsInstances = BlockList
	--
	local function GetNearestToMouse(TeamCheck, TargetPlayers, TargetNPCs)
		local Entities = GetEntities()
		local AllEntities = {}
		
		for _, v in Entities do
			table.insert(AllEntities, v.Entity)
		end
		
		for _, player in Players:GetPlayers() do
			if player.Character and not table.find(AllEntities, player.Character) then
				table.insert(AllEntities, player.Character)
			end
		end
		
		local BestTarget = {
			Character = nil,
			Player = nil,
			DistanceFromMouse = math.huge,
			DistanceFromPlayer = math.huge
		}
		
		if not IsAlive(LocalPlayer) then return BestTarget end
		
		local MouseLocation = UserInputService:GetMouseLocation()
		
		for _, entity in AllEntities do
			if IsAlive(entity, true) and entity ~= LocalPlayer.Character then
				local Player = Players:GetPlayerFromCharacter(entity)
				
				if (TargetPlayers and Player) or (TargetNPCs and not Player) then
					if TeamCheck then
						local EntityTeam = entity:GetAttribute("Team")
						local LocalTeam = LocalPlayer.Character:GetAttribute("Team")
						if EntityTeam and LocalTeam and EntityTeam == LocalTeam then
							continue
						end
						if Player and Player.Team and Player.Team == LocalPlayer.Team then
							continue
						end
					end
					
					local Root = entity.PrimaryPart
					if Root then
						local ScreenPos, OnScreen = CurrentCamera:WorldToViewportPoint(Root.Position)
						if OnScreen then
							local MouseDistance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MouseLocation).Magnitude
							local PlayerDistance = GetDistanceFrom(LocalPlayer.Character.PrimaryPart.Position, Root.Position)
							
							if MouseDistance < BestTarget.DistanceFromMouse then
								BestTarget = {
									Character = entity,
									Player = Player,
									DistanceFromMouse = MouseDistance,
									DistanceFromPlayer = PlayerDistance
								}
							end
						end
					end
				end
			end
		end
		
		return BestTarget
	end
	--
	local ProjectileAimbotToggle = ProjectileAimbotSection:Toggle({
		Name = "Enabled",
		Default = false,
		Flag = "ProjectileAimbotEnabled",
		Callback = function(State)
			local keybind = Library.Flags["ProjectileAimbotKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["ProjectileAimbotEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Projectile Aimbot</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			if State then
				if ProjectileAimbotData.Settings.RangeCircle and not ProjectileAimbotData.Data.Circle then
					local Circle = Drawing.new("Circle")
					Circle.Visible = true
					Circle.Color = ProjectileAimbotData.Settings.RangeCircleColor
					Circle.Radius = ProjectileAimbotData.Settings.FOVRadius
					Circle.Thickness = 2
					Circle.Filled = ProjectileAimbotData.Settings.RangeCircleFilled
					Circle.Transparency = ProjectileAimbotData.Settings.RangeCircleTransparency
					ProjectileAimbotData.Data.Circle = Circle
				elseif ProjectileAimbotData.Data.Circle then
					ProjectileAimbotData.Data.Circle.Visible = ProjectileAimbotData.Settings.RangeCircle
				end
				
				task.spawn(function()
					local RenderConnection
					RenderConnection = RunService.PreRender:Connect(function()
						if not IsFeatureEnabled("ProjectileAimbotEnabled", "ProjectileAimbotKeybind") then
							return
						end
						
						if not IsAlive(LocalPlayer) then return end
						
						if ProjectileAimbotData.Data.Circle then
							ProjectileAimbotData.Data.Circle.Position = UserInputService:GetMouseLocation()
						end
						
						local NearestToMouse = GetNearestToMouse(
							true,
							true,
							not ProjectileAimbotData.Settings.IgnoreNPCs
						)
						
						if NearestToMouse.Character then
							local Target = NearestToMouse.Character
							local TargetPart = Target:FindFirstChild(ProjectileAimbotData.Settings.TargetPart) or Target.PrimaryPart
							
							if TargetPart then
								local Pos, OnScreen = CurrentCamera:WorldToViewportPoint(TargetPart.Position)
								local MousePos = UserInputService:GetMouseLocation()
								local DistToMouse = (Vector2.new(Pos.X, Pos.Y) - MousePos).Magnitude
								
								if OnScreen and DistToMouse <= ProjectileAimbotData.Settings.FOVRadius then
									if ProjectileAimbotData.Settings.DistanceCheck and NearestToMouse.DistanceFromPlayer >= ProjectileAimbotData.Settings.Distance then
										ProjectileAimbotData.Data.Target = nil
										return
									end
									
									if ProjectileAimbotData.Settings.IgnoreWalls then
										if not IsPathClear(Target, TargetPart, ProjectileAimbotData.Data.RayParams) then
											ProjectileAimbotData.Data.Target = nil
											return
										end
									end
									
									ProjectileAimbotData.Data.Target = Target
								else
									ProjectileAimbotData.Data.Target = nil
								end
							end
						else
							ProjectileAimbotData.Data.Target = nil
						end
					end)
					
					ProjectileAimbotData.Data.OldCalculate = GameData.Utils.Projectile.calculateImportantLaunchValues
					GameData.Utils.Projectile.calculateImportantLaunchValues = function(proj, data, line, start, pos)
						local Name = tostring(data.projectile or ""):lower()
						for _, Blacklisted in next, ProjectileAimbotData.Settings.Blacklisted do
							if Name:find(Blacklisted) then
								return ProjectileAimbotData.Data.OldCalculate(proj, data, line, start, pos)
							end
						end
						
						local Launch = pos or proj:getLaunchPosition(start)
						if not ProjectileAimbotData.Data.Target or not ProjectileAimbotData.Data.Target.PrimaryPart or not Launch then
							return ProjectileAimbotData.Data.OldCalculate(proj, data, line, start, pos)
						end
						
						local OriginalResult = ProjectileAimbotData.Data.OldCalculate(proj, data, line, start, pos)
						local OriginalVelocity = OriginalResult and OriginalResult.initialVelocity or Vector3.zero
						
						local PrimaryPart = ProjectileAimbotData.Data.Target.PrimaryPart
						local Humanoid = ProjectileAimbotData.Data.Target:FindFirstChildOfClass("Humanoid")
						local YLevel = Humanoid and PrimaryPart.Position.Y + Humanoid.HipHeight or PrimaryPart.Position.Y
						local StartPos = CFrame.new(Launch + (data.fromPositionOffset or Vector3.new()), Vector3.new(PrimaryPart.Position.X, YLevel, PrimaryPart.Position.Z)).Position
						local Disp = Vector3.new(PrimaryPart.Position.X, YLevel, PrimaryPart.Position.Z) - StartPos
						local Vel = PrimaryPart.Velocity or Vector3.new(0, 0, 0)
						local Meta = data:getProjectileMeta()
						local Gravity = (Meta and Meta.gravitationalAcceleration or 0) * (data.gravityMultiplier or 1)
						
						local IsArrow = type(data.projectile) == "string" and data.projectile:find("arrow")
						local IsOtherProj = Meta and (Meta.gravitationalAcceleration or 0) > 0
						local Calc = nil
						
						if (IsArrow or (ProjectileAimbotData.Settings.OtherProjectiles and IsOtherProj)) and Meta and Meta.launchVelocity and Meta.launchVelocity > 0 then
							local Time = Disp.Magnitude / Meta.launchVelocity
							if Time > 0 then
								Calc = StartPos + Vector3.new(
									(Disp.X + Vel.X * Time) / Time,
									(Disp.Y - (-0.5 * Gravity) * Time * Time) / Time,
									(Disp.Z + Vel.Z * Time) / Time
								)
							end
						end
						
						if not Calc then
							Calc = PrimaryPart.Position
						end
						
						local TargetVelocity = CFrame.new(StartPos, Calc).LookVector * ((Meta and Meta.launchVelocity) or 100)
						
						local LerpAlpha = math.clamp(ProjectileAimbotData.Settings.Speed, 0, 1)
						local FinalVelocity = OriginalVelocity:Lerp(TargetVelocity, LerpAlpha)
						
						return {
							initialVelocity = FinalVelocity,
							positionFrom = OriginalResult and OriginalResult.positionFrom or StartPos,
							deltaT = (Meta and (Meta.predictionLifetimeSec or Meta.lifetimeSec)) or 1,
							gravitationalAcceleration = Gravity
						}
					end
					
					repeat task.wait() until not IsFeatureEnabled("ProjectileAimbotEnabled", "ProjectileAimbotKeybind")
					
					RenderConnection:Disconnect()
					if ProjectileAimbotData.Data.OldCalculate then
						GameData.Utils.Projectile.calculateImportantLaunchValues = ProjectileAimbotData.Data.OldCalculate
					end
					ProjectileAimbotData.Data.Target = nil
					if ProjectileAimbotData.Data.Circle then
						ProjectileAimbotData.Data.Circle.Visible = false
					end
				end)
			else
				if ProjectileAimbotData.Data.OldCalculate then
					GameData.Utils.Projectile.calculateImportantLaunchValues = ProjectileAimbotData.Data.OldCalculate
				end
				ProjectileAimbotData.Data.Target = nil
				if ProjectileAimbotData.Data.Circle then
					ProjectileAimbotData.Data.Circle.Visible = false
				end
			end
		end
	})
	--
	ProjectileAimbotToggle:Keybind({
		Mode = "Toggle",
		Flag = "ProjectileAimbotKeybind",
		Callback = function() end
	})
	--
	ProjectileAimbotSection:Dropdown({
		Name = "",
		Default = "HumanoidRootPart",
		Content = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
		Flag = "ProjectileAimbotTargetPart",
		Callback = function(Option)
			ProjectileAimbotData.Settings.TargetPart = Option
		end
	})
	--
	ProjectileAimbotSection:Slider({
		Name = "FOV",
		Min = 50,
		Max = 1000,
		Default = 500,
		Decimal = 1,
		Ending = " px",
		Flag = "ProjectileAimbotFOVRadius",
		Callback = function(Value)
			ProjectileAimbotData.Settings.FOVRadius = Value
			if ProjectileAimbotData.Data.Circle then
				ProjectileAimbotData.Data.Circle.Radius = Value
			end
		end
	})
	--
	ProjectileAimbotSection:Slider({
		Name = "Speed",
		Min = 0.1,
		Max = 1,
		Default = 1,
		Decimal = 0.1,
		Ending = "x",
		Disable = {"Instant", 0, 1},
		Flag = "ProjectileAimbotSpeed",
		Callback = function(Value)
			ProjectileAimbotData.Settings.Speed = Value
		end
	})
	--
	local TargetSettingsMultiBox
	local TargetSettingsToggle = ProjectileAimbotSection:Toggle({
		Name = "Target Settings",
		Default = false,
		Flag = "ProjectileAimbotTargetSettings",
		Callback = function(State)
			ProjectileAimbotData.Settings.TargetSettings = State
			task.spawn(function()
				repeat task.wait() until TargetSettingsMultiBox
				TargetSettingsMultiBox:SetVisible(State)
			end)
		end
	})
	--
	TargetSettingsMultiBox = ProjectileAimbotSection:MultiBox({
		Name = "",
		Default = {},
		Content = {"Ignore NPCs", "Ignore Behind Walls"},
		Flag = "ProjectileAimbotTargetMultiBox",
		Hidden = true,
		Callback = function(Selected)
			ProjectileAimbotData.Settings.IgnoreNPCs = table.find(Selected, "Ignore NPCs") ~= nil
			ProjectileAimbotData.Settings.IgnoreWalls = table.find(Selected, "Ignore Behind Walls") ~= nil
		end
	})
    --
    local RangeCircleFilledToggle
	local RangeCircleToggle = ProjectileAimbotSection:Toggle({
		Name = "Range Circle",
		Default = false,
		Flag = "ProjectileAimbotRangeCircle",
		Callback = function(State)
			ProjectileAimbotData.Settings.RangeCircle = State
			task.spawn(function()
				repeat task.wait() until RangeCircleFilledToggle
				RangeCircleFilledToggle:SetVisible(State)
			end)
			
			if State and IsFeatureEnabled("ProjectileAimbotEnabled", "ProjectileAimbotKeybind") then
				if not ProjectileAimbotData.Data.Circle then
					local Circle = Drawing.new("Circle")
					Circle.Visible = true
					Circle.Color = ProjectileAimbotData.Settings.RangeCircleColor
					Circle.Radius = ProjectileAimbotData.Settings.FOVRadius
					Circle.Thickness = 2
					Circle.Filled = ProjectileAimbotData.Settings.RangeCircleFilled
					Circle.Transparency = ProjectileAimbotData.Settings.RangeCircleTransparency
					ProjectileAimbotData.Data.Circle = Circle
				else
					ProjectileAimbotData.Data.Circle.Visible = true
				end
			else
				if ProjectileAimbotData.Data.Circle then
					ProjectileAimbotData.Data.Circle.Visible = false
				end
			end
		end
	})
	--
	RangeCircleToggle:ColorPicker({
		Default = Color3.fromRGB(255, 255, 255),
		Alpha = 0.7,
		Flag = "ProjectileAimbotRangeCircleColor",
		Callback = function(Color, Alpha)
			ProjectileAimbotData.Settings.RangeCircleColor = Color
			ProjectileAimbotData.Settings.RangeCircleTransparency = 1 - (Alpha or 0)
			if ProjectileAimbotData.Data.Circle then
				ProjectileAimbotData.Data.Circle.Color = Color
				ProjectileAimbotData.Data.Circle.Transparency = 1 - (Alpha or 0)
			end
		end
	})
	--
	RangeCircleFilledToggle = ProjectileAimbotSection:Toggle({
		Name = "Circle Filled",
		Default = false,
		Flag = "ProjectileAimbotRangeCircleFilled",
		Hidden = true,
		Callback = function(State)
			ProjectileAimbotData.Settings.RangeCircleFilled = State
			if ProjectileAimbotData.Data.Circle then
				ProjectileAimbotData.Data.Circle.Filled = State
			end
		end
	})
    --
	local DistanceSlider
	local DistanceToggle = ProjectileAimbotSection:Toggle({
		Name = "Distance Check",
		Default = false,
		Flag = "ProjectileAimbotDistanceCheck",
		Callback = function(State)
			ProjectileAimbotData.Settings.DistanceCheck = State
			task.spawn(function()
				repeat task.wait() until DistanceSlider
				DistanceSlider:SetVisible(State)
			end)
		end
	})
	--
	DistanceSlider = ProjectileAimbotSection:Slider({
		Name = "",
		Min = 10,
		Max = 200,
		Default = 100,
		Decimal = 1,
		Ending = " studs",
		Flag = "ProjectileAimbotDistance",
		Hidden = true,
		Callback = function(Value)
			ProjectileAimbotData.Settings.Distance = Value
		end
	})
	--
	ProjectileAimbotSection:Toggle({
		Name = "Other Projectiles",
		Default = false,
		Flag = "ProjectileAimbotOtherProjectiles",
		Callback = function(State)
			ProjectileAimbotData.Settings.OtherProjectiles = State
		end
	})
	--
	AimbotSubSection:Section({Side = "Right", Fill = true})
    --
    AimbotSubSection2:Section({Fill = true})
    AimbotSubSection2:Section({Side = "Right", Fill = true})
    --
    AimbotSubSection3:Section({Fill = true})
    AimbotSubSection3:Section({Side = "Right", Fill = true})
    --
    AimbotSubSection4:Section({Fill = true})
    AimbotSubSection4:Section({Side = "Right", Fill = true})
end
--
do -- Visuals
    local VisualSubSection, VisualSubSection2, VisualSubSection3, VisualSubSection4 = Visuals:SubSection({Name = "Category", Options = {"rbxassetid://18334627891", "rbxassetid://18334630306", "rbxassetid://18334626899", "rbxassetid://18334625304"}})
    --
	local StorageESPSection = VisualSubSection:Section({Name = "Storage ESP", Fill = true})
	table.insert(NamedSections, StorageESPSection)
	--
	local StorageESPData = {
		Settings = {
			Scale = 1,
			Items = {"raven", "emerald", "speed"}
		},
		Data = {
			Reference = {},
			Folder = Instance.new("Folder")
		}
	}
	--
	StorageESPData.Data.Folder.Parent = game:GetService("CoreGui")
	--
	local function nearStorageItem(item)
		for _, v in StorageESPData.Settings.Items do
			if string.find(string.lower(item), string.lower(v)) then return v end
		end
	end
	--
	local function refreshAdornee(billboard)
		local chest = billboard.Adornee:FindFirstChild("ChestFolderValue")
		chest = chest and chest.Value or nil
		if not chest then
			billboard.Enabled = false
			return
		end
		
		local chestitems = chest:GetChildren()
		for _, obj in billboard.Frame:GetChildren() do
			if obj:IsA("ImageLabel") then
				obj:Destroy()
			end
		end
		
		billboard.Enabled = false
		local alreadygot = {}
		for _, item in chestitems do
			local itemName = item.Name
			local match = nearStorageItem(itemName)
			if not alreadygot[itemName] and (match or table.find(StorageESPData.Settings.Items, itemName)) then
				alreadygot[itemName] = true
				billboard.Enabled = true
				local blockimage = Instance.new("ImageLabel")
				local imageSize = 32 * StorageESPData.Settings.Scale
				blockimage.Size = UDim2.fromOffset(imageSize, imageSize)
				blockimage.BackgroundTransparency = 1
				blockimage.Image = GameData.Utils.ItemMeta[itemName].image or ""
				blockimage.Parent = billboard.Frame
			end
		end
	end
	--
	local function AddChest(v)
		local chest = v:WaitForChild("ChestFolderValue", 3)
		if not (chest and IsFeatureEnabled("StorageESPEnabled", "StorageESPKeybind")) then return end
		chest = chest.Value
		local billboard = Instance.new("BillboardGui")
		billboard.Parent = StorageESPData.Data.Folder
		billboard.Name = "chest"
		billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
		billboard.Size = UDim2.fromOffset(36 * StorageESPData.Settings.Scale, 36 * StorageESPData.Settings.Scale)
		billboard.AlwaysOnTop = true
		billboard.ClipsDescendants = false
		billboard.Adornee = v
		local frame = Instance.new("Frame")
		frame.Size = UDim2.fromScale(1, 1)
		frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		frame.BackgroundTransparency = 0.8
		frame.Parent = billboard
		local layout = Instance.new("UIListLayout")
		layout.FillDirection = Enum.FillDirection.Horizontal
		layout.Padding = UDim.new(0, 4)
		layout.VerticalAlignment = Enum.VerticalAlignment.Center
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			billboard.Size = UDim2.fromOffset(math.max(layout.AbsoluteContentSize.X + 4, 36) * StorageESPData.Settings.Scale, 36 * StorageESPData.Settings.Scale)
		end)
		layout.Parent = frame
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = frame
		StorageESPData.Data.Reference[v] = billboard
		
		local childAddedConn = chest.ChildAdded:Connect(function(item)
			local match = nearStorageItem(item.Name)
			if match or table.find(StorageESPData.Settings.Items, item.Name) then
				refreshAdornee(billboard)
			end
		end)
		
		local childRemovedConn = chest.ChildRemoved:Connect(function(item)
			local match = nearStorageItem(item.Name)
			if match or table.find(StorageESPData.Settings.Items, item.Name) then
				refreshAdornee(billboard)
			end
		end)
		
		billboard.AncestryChanged:Connect(function()
			if not billboard.Parent then
				childAddedConn:Disconnect()
				childRemovedConn:Disconnect()
			end
		end)
		
		task.spawn(refreshAdornee, billboard)
	end
	--
	local StorageESPToggle = StorageESPSection:Toggle({
		Name = "Enabled",
		Default = false,
		Flag = "StorageESPEnabled",
		Callback = function(State)
			local keybind = Library.Flags["StorageESPKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["StorageESPEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Storage ESP</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			if State then
				for _, v in CollectionService:GetTagged("chest") do
					task.spawn(AddChest, v)
				end
				
				local conn = CollectionService:GetInstanceAddedSignal("chest"):Connect(AddChest)
				
				repeat task.wait() until not IsFeatureEnabled("StorageESPEnabled", "StorageESPKeybind")
				
				conn:Disconnect()
				table.clear(StorageESPData.Data.Reference)
				StorageESPData.Data.Folder:ClearAllChildren()
			else
				table.clear(StorageESPData.Data.Reference)
				StorageESPData.Data.Folder:ClearAllChildren()
			end
		end
	})
	--
	StorageESPToggle:Keybind({
		Mode = "Toggle",
		Flag = "StorageESPKeybind",
		Callback = function() end
	})
	--
	StorageESPSection:Slider({
		Name = "",
		Min = 0.5,
		Max = 1.5,
		Default = 1,
		Decimal = 0.1,
        Ending = " px",
		Flag = "StorageESPScale",
		Callback = function(Value)
			StorageESPData.Settings.Scale = Value
			for _, v in StorageESPData.Data.Reference do
				refreshAdornee(v)
			end
		end
	})
    --
	local ItemList = StorageESPSection:List({
		Size = 100,
		MultiSelect = true,
		Flag = "StorageESPItems",
		Callback = function(Selected)
			if type(Selected) == "string" then
				StorageESPData.Settings.Items = {Selected}
			elseif type(Selected) == "table" then
				StorageESPData.Settings.Items = Selected
			else
				StorageESPData.Settings.Items = {}
			end
			for _, v in StorageESPData.Data.Reference do
				task.spawn(refreshAdornee, v)
			end
		end
	})
	--
	local ItemTextBox = StorageESPSection:TextBox({
		Name = "Item Name",
		Default = "",
		Flag = "StorageESPItemName"
	})
	--
	for _, item in ipairs({"raven", "emerald", "speed"}) do
		ItemList:AddValue(item)
	end
	--
	StorageESPSection:Button({
		Name = "Add Entry",
		Callback = function()
			local itemName = Library.Flags["StorageESPItemName"]:Get()
			if itemName ~= "" then
				ItemList:AddValue(itemName)
			end
		end
	})
	--
	StorageESPSection:Button({
		Name = "Delete Entry",
		Callback = function()
			local selectedItem = Library.Flags["StorageESPItems"]:Get()
			if selectedItem and selectedItem ~= "" then
				ItemList:RemoveValue(selectedItem)
				for _, v in StorageESPData.Data.Reference do
					task.spawn(refreshAdornee, v)
				end
			end
		end
	})
    --
	local NametagsSection = VisualSubSection:Section({Name = "Nametags", Side = "Right", Fill = true})
	table.insert(NamedSections, NametagsSection)
	--
	local NametagsData = {
		Settings = {
			Scale = 1,
			DistanceCheck = false,
			MaxDistance = 100
		},
		Data = {
			Folder = Instance.new("Folder"),
			Reference = {}
		}
	}
	--
	NametagsData.Data.Folder.Parent = game:GetService("CoreGui")
	--
	local function CreateNametag(player)
		if not player.Character or not player.Character.PrimaryPart then return end
		
		if NametagsData.Data.Reference[player] then
			if NametagsData.Data.Reference[player].Billboard then
				NametagsData.Data.Reference[player].Billboard:Destroy()
			end
			NametagsData.Data.Reference[player] = nil
		end
		
		local billboard = Instance.new("BillboardGui")
		billboard.Parent = NametagsData.Data.Folder
		billboard.Name = player.Name
		billboard.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
		billboard.Size = UDim2.fromOffset(200, 20)
		billboard.AlwaysOnTop = true
		billboard.Adornee = player.Character.PrimaryPart
		
		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		frame.BorderSizePixel = 0
		frame.Parent = billboard
		
		local gradient = Instance.new("UIGradient")
		gradient.Transparency = NumberSequence.new{
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.25, 0.6119999885559082),
			NumberSequenceKeypoint.new(0.5, 0.625),
			NumberSequenceKeypoint.new(0.75, 0.625),
			NumberSequenceKeypoint.new(1, 1)
		}
		gradient.Parent = frame
		
		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(0, 0, 0)
		stroke.Thickness = 1
		stroke.Parent = frame
		
		local strokeGradient = Instance.new("UIGradient")
		strokeGradient.Transparency = NumberSequence.new{
			NumberSequenceKeypoint.new(0, 1),
			NumberSequenceKeypoint.new(0.232, 0.4000000059604645),
			NumberSequenceKeypoint.new(0.5, 0.4000000059604645),
			NumberSequenceKeypoint.new(0.75, 0.4000000059604645),
			NumberSequenceKeypoint.new(1, 1)
		}
		strokeGradient.Parent = stroke
		
		local nameText = Instance.new("TextLabel")
		nameText.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
		nameText.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(208, 208, 208)
		nameText.BorderSizePixel = 0
		nameText.BackgroundTransparency = 1
		nameText.Size = UDim2.new(1, 0, 1, 0)
		nameText.TextSize = 14
		nameText.Text = player.DisplayName or player.Name
		nameText.RichText = true
		nameText.TextXAlignment = Enum.TextXAlignment.Left
		nameText.Parent = frame
		
		local textStroke = Instance.new("UIStroke")
		textStroke.LineJoinMode = Enum.LineJoinMode.Miter
		textStroke.Color = Color3.fromRGB(50, 50, 50)
		textStroke.Thickness = 1
		textStroke.Parent = nameText
		
		local padding = Instance.new("UIPadding")
		padding.PaddingRight = UDim.new(0, 22)
		padding.PaddingLeft = UDim.new(0, 22)
		padding.Parent = nameText
		
		local function updateSize()
			local textSize = nameText.TextBounds.X + 44
			billboard.Size = UDim2.fromOffset(textSize * NametagsData.Settings.Scale, 20 * NametagsData.Settings.Scale)
			nameText.TextSize = 14 * NametagsData.Settings.Scale
		end
		
		updateSize()
		
		NametagsData.Data.Reference[player] = {
			Billboard = billboard,
			NameText = nameText,
			UpdateSize = updateSize
		}
		
		return billboard
	end
	--
	local function UpdateNametag(player)
		local ref = NametagsData.Data.Reference[player]
		if not ref then return end
		local character = player.Character
		if not character or not character.PrimaryPart then
			ref.Billboard:Destroy()
			NametagsData.Data.Reference[player] = nil
			return
		end
		ref.Billboard.Adornee = character.PrimaryPart
		ref.NameText.TextColor3 = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(208, 208, 208)
		if NametagsData.Settings.DistanceCheck and IsAlive(LocalPlayer) then
			local distance = GetDistanceFrom(LocalPlayer.Character.PrimaryPart.Position, character.PrimaryPart.Position)
			if distance > NametagsData.Settings.MaxDistance then
				ref.Billboard.Enabled = false
				return
			end
		end
		ref.Billboard.Enabled = true
	end
	--
	local NametagsToggle = NametagsSection:Toggle({
		Name = "Enabled",
		Default = false,
		Flag = "NametagsEnabled",
		Callback = function(State)
			local keybind = Library.Flags["NametagsKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["NametagsEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Nametags</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			if State then
				task.spawn(function()
					for _, player in Players:GetPlayers() do
						if player ~= LocalPlayer and player.Character then
							CreateNametag(player)
						end
					end
					
					for _, player in Players:GetPlayers() do
						if player ~= LocalPlayer then
							player.CharacterAdded:Connect(function()
								task.wait(0.1)
								if IsFeatureEnabled("NametagsEnabled", "NametagsKeybind") then
									CreateNametag(player)
								end
							end)
						end
					end
					
					local playerAddedConn = Players.PlayerAdded:Connect(function(player)
						if player.Character then
							CreateNametag(player)
						end
						player.CharacterAdded:Connect(function()
							task.wait(0.1)
							if IsFeatureEnabled("NametagsEnabled", "NametagsKeybind") then
								CreateNametag(player)
							end
						end)
					end)
					
					repeat
						for player, ref in NametagsData.Data.Reference do
							UpdateNametag(player)
						end
						task.wait()
					until not IsFeatureEnabled("NametagsEnabled", "NametagsKeybind")
					
					playerAddedConn:Disconnect()
					table.clear(NametagsData.Data.Reference)
					NametagsData.Data.Folder:ClearAllChildren()
				end)
			else
				table.clear(NametagsData.Data.Reference)
				NametagsData.Data.Folder:ClearAllChildren()
			end
		end
	})
	--
	NametagsToggle:Keybind({
		Mode = "Toggle",
		Flag = "NametagsKeybind",
		Callback = function() end
	})
	--
	NametagsSection:Slider({
		Name = "",
		Min = 0.5,
		Max = 1.5,
		Default = 1,
		Decimal = 0.1,
		Ending = " px",
		Flag = "NametagsScale",
		Callback = function(Value)
			NametagsData.Settings.Scale = Value
			for player, ref in NametagsData.Data.Reference do
				ref.NameText.TextSize = 14 * Value
				ref.UpdateSize()
			end
		end
	})
	--
	--
	local MaxDistanceSlider = nil
	--
	local DistanceCheckToggle = NametagsSection:Toggle({
		Name = "Range",
		Default = false,
		Flag = "NametagsDistanceCheck",
		Callback = function(State)
			NametagsData.Settings.DistanceCheck = State
			task.spawn(function()
				repeat task.wait() until MaxDistanceSlider
				MaxDistanceSlider:SetVisible(State)
			end)
		end
	})
	--
	MaxDistanceSlider = NametagsSection:Slider({
		Name = "",
		Min = 10,
		Max = 200,
		Default = 100,
		Decimal = 1,
		Ending = " studs",
		Flag = "NametagsMaxDistance",
		Hidden = true,
		Callback = function(Value)
			NametagsData.Settings.MaxDistance = Value
		end
	})
	--
    --
	local EnvironmentSection = VisualSubSection2:Section({Name = "Environment", Fill = true})
	table.insert(NamedSections, EnvironmentSection)
	--
	local FOVData = {
		Settings = {
			FOV = 120
		},
		Data = {
			OldSetFOV = nil,
			OldGetFOV = nil
		}
	}
	--
	local FOVSlider
    --
	local FOVToggle = EnvironmentSection:Toggle({
		Name = "FOV",
		Default = false,
		Flag = "FOVEnabled",
		Callback = function(State)
			local keybind = Library.Flags["FOVKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["FOVEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>FOV</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			task.spawn(function()
				repeat task.wait() until FOVSlider
				FOVSlider:SetVisible(State)
			end)
			
			if State then
				if not FOVData.Data.OldSetFOV then
					FOVData.Data.OldSetFOV = GameData.Utils.FovController.setFOV
					FOVData.Data.OldGetFOV = GameData.Utils.FovController.getFOV
					
					GameData.Utils.FovController.setFOV = function(self)
						return FOVData.Data.OldSetFOV(self, FOVData.Settings.FOV)
					end
					
					GameData.Utils.FovController.getFOV = function()
						return FOVData.Settings.FOV
					end
				end
				
				FOVData.Data.OldSetFOV(GameData.Utils.FovController, FOVData.Settings.FOV)
			else
				if FOVData.Data.OldSetFOV then
					GameData.Utils.FovController.setFOV = FOVData.Data.OldSetFOV
					GameData.Utils.FovController.getFOV = FOVData.Data.OldGetFOV
					GameData.Utils.FovController:setFOV(GameData.Utils.Store:getState().Settings.fov)
					FOVData.Data.OldSetFOV = nil
					FOVData.Data.OldGetFOV = nil
				end
			end
		end
	})
	--
	FOVToggle:Keybind({
		Mode = "Toggle",
		Flag = "FOVKeybind",
		Callback = function() end
	})
	--
	FOVSlider = EnvironmentSection:Slider({
		Name = "",
		Min = 70,
		Max = 120,
		Default = 120,
		Decimal = 1,
		Ending = "°",
		Flag = "FOVValue",
		Hidden = true,
		Callback = function(Value)
			FOVData.Settings.FOV = Value
			if IsFeatureEnabled("FOVEnabled", "FOVKeybind") and FOVData.Data.OldSetFOV then
				FOVData.Data.OldSetFOV(GameData.Utils.FovController, FOVData.Settings.FOV)
			end
		end
	})
	--
	local AtmosphereData = {
		Settings = {
			Mode = "Blavish"
		},
		Data = {
			TimeConnection = nil,
			CloudCoroutine = nil,
			CurrentCloud = nil,
			StoreBlocks = {},
			CleanFunc = nil,
			CharacterAddedConnection = nil
		},
		NewObjects = {},
		OldObjects = {},
		OriginalSettings = {
			Ambient = nil,
			Brightness = nil,
			ColorShift_Bottom = nil,
			ColorShift_Top = nil,
			EnvironmentDiffuseScale = nil,
			EnvironmentSpecularScale = nil,
			GlobalShadows = nil,
			OutdoorAmbient = nil,
			ShadowSoftness = nil,
			Technology = nil,
			ClockTime = nil,
			GeographicLatitude = nil
		}
	}
	
	local function AtmosphereCleanup()
		for _, v in AtmosphereData.NewObjects do
			if v and v.Parent then
				v:Destroy()
			end
		end
		table.clear(AtmosphereData.NewObjects)
		
		for _, v in AtmosphereData.OldObjects do
			if v then
				v.Parent = Lighting
			end
		end
		table.clear(AtmosphereData.OldObjects)
		
		if AtmosphereData.Data.TimeConnection then
			AtmosphereData.Data.TimeConnection:Disconnect()
			AtmosphereData.Data.TimeConnection = nil
		end
		if AtmosphereData.Data.CharacterAddedConnection then
			AtmosphereData.Data.CharacterAddedConnection:Disconnect()
			AtmosphereData.Data.CharacterAddedConnection = nil
		end
		if AtmosphereData.Data.CurrentCloud then
			AtmosphereData.Data.CurrentCloud:Destroy()
			AtmosphereData.Data.CurrentCloud = nil
		end
		if AtmosphereData.Data.CleanFunc then
			AtmosphereData.Data.CleanFunc()
		end
		
		workspace.Terrain:Clear()
		
		if AtmosphereData.OriginalSettings.Ambient then
			Lighting.Ambient = AtmosphereData.OriginalSettings.Ambient
			Lighting.Brightness = AtmosphereData.OriginalSettings.Brightness
			Lighting.ColorShift_Bottom = AtmosphereData.OriginalSettings.ColorShift_Bottom
			Lighting.ColorShift_Top = AtmosphereData.OriginalSettings.ColorShift_Top
			Lighting.EnvironmentDiffuseScale = AtmosphereData.OriginalSettings.EnvironmentDiffuseScale
			Lighting.EnvironmentSpecularScale = AtmosphereData.OriginalSettings.EnvironmentSpecularScale
			Lighting.GlobalShadows = AtmosphereData.OriginalSettings.GlobalShadows
			Lighting.OutdoorAmbient = AtmosphereData.OriginalSettings.OutdoorAmbient
			Lighting.ShadowSoftness = AtmosphereData.OriginalSettings.ShadowSoftness
			Lighting.Technology = AtmosphereData.OriginalSettings.Technology
			Lighting.ClockTime = AtmosphereData.OriginalSettings.ClockTime
			Lighting.GeographicLatitude = AtmosphereData.OriginalSettings.GeographicLatitude
		end
	end
	
	local function RemoveOldLightingObject(v)
		if not table.find(AtmosphereData.NewObjects, v) then
			if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("SunRaysEffect") then
				if v.Parent then
					table.insert(AtmosphereData.OldObjects, v)
					v.Parent = game
				end
			end
		end
	end
	--
	local AtmosphereDropdown
	--
	local AtmosphereToggle = EnvironmentSection:Toggle({
		Name = "Atmosphere",
		Default = false,
		Flag = "AtmosphereEnabled",
		Callback = function(State)
			local keybind = Library.Flags["AtmosphereKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["AtmosphereEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Atmosphere</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			task.spawn(function()
				repeat task.wait() until AtmosphereDropdown
				AtmosphereDropdown:SetVisible(State)
			end)
			
			if State then
				if not AtmosphereData.OriginalSettings.Ambient then
					AtmosphereData.OriginalSettings.Ambient = Lighting.Ambient
					AtmosphereData.OriginalSettings.Brightness = Lighting.Brightness
					AtmosphereData.OriginalSettings.ColorShift_Bottom = Lighting.ColorShift_Bottom
					AtmosphereData.OriginalSettings.ColorShift_Top = Lighting.ColorShift_Top
					AtmosphereData.OriginalSettings.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
					AtmosphereData.OriginalSettings.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale
					AtmosphereData.OriginalSettings.GlobalShadows = Lighting.GlobalShadows
					AtmosphereData.OriginalSettings.OutdoorAmbient = Lighting.OutdoorAmbient
					AtmosphereData.OriginalSettings.ShadowSoftness = Lighting.ShadowSoftness
					AtmosphereData.OriginalSettings.Technology = Lighting.Technology
					AtmosphereData.OriginalSettings.ClockTime = Lighting.ClockTime
					AtmosphereData.OriginalSettings.GeographicLatitude = Lighting.GeographicLatitude
				end
				
				for _, v in Lighting:GetChildren() do
					RemoveOldLightingObject(v)
				end
				
				task.spawn(function()
					local mode = AtmosphereData.Settings.Mode
					
					if mode == "Blavish" then
						if workspace:FindFirstChild("Clouds") then
							for _, v in workspace.Clouds:GetChildren() do
								if v:IsA('Part') then
									v.Transparency = 1
								end
							end
						end
						
						for _, cloud in workspace:GetDescendants() do
							if cloud:IsA("Clouds") then
								cloud:Destroy()
							end
						end
						
						Lighting.ClockTime = 6.1
						
						local sky = Instance.new("Sky")
						sky.Parent = Lighting
						sky.SkyboxBk = "rbxassetid://8139677359"
						sky.SkyboxDn = "rbxassetid://8139677253"
						sky.SkyboxFt = "rbxassetid://8139677111"
						sky.SkyboxLf = "rbxassetid://8139676988"
						sky.SkyboxRt = "rbxassetid://8139676842"
						sky.SkyboxUp = "rbxassetid://8139676647"
						sky.SunTextureId = "rbxassetid://6196665106"
						sky.MoonTextureId = "rbxassetid://8139665943"
						sky.StarCount = 50
						sky.SunAngularSize = 0
						sky.MoonAngularSize = 0
						table.insert(AtmosphereData.NewObjects, sky)
						
						local colorCorrection = Instance.new("ColorCorrectionEffect")
						colorCorrection.Parent = Lighting
						colorCorrection.Enabled = false
						colorCorrection.Brightness = 0
						colorCorrection.Contrast = 0.1
						colorCorrection.Saturation = 0
						colorCorrection.TintColor = Color3.fromHSV(0.80625, 1, 1)
						table.insert(AtmosphereData.NewObjects, colorCorrection)
						
						local sunRays = Instance.new("SunRaysEffect")
						sunRays.Parent = Lighting
						sunRays.Enabled = false
						sunRays.Intensity = 0
						sunRays.Spread = 0
						table.insert(AtmosphereData.NewObjects, sunRays)
						
						local bloom = Instance.new("BloomEffect")
						bloom.Parent = Lighting
						bloom.Enabled = false
						bloom.Intensity = 0
						bloom.Size = 0
						bloom.Threshold = 0
						table.insert(AtmosphereData.NewObjects, bloom)
						
						local depthOfField = Instance.new("DepthOfFieldEffect")
						depthOfField.Parent = Lighting
						depthOfField.Enabled = false
						depthOfField.FarIntensity = 0
						depthOfField.FocusDistance = 0
						depthOfField.InFocusRadius = 0
						depthOfField.NearIntensity = 0
						table.insert(AtmosphereData.NewObjects, depthOfField)
						
						local atmosphere = Instance.new("Atmosphere")
						atmosphere.Parent = Lighting
						atmosphere.Density = 0.1
						atmosphere.Offset = 0
						atmosphere.Color = Color3.fromHSV(0.59375, 1, 1)
						atmosphere.Decay = Color3.fromHSV(0.44, 1, 1)
						atmosphere.Glare = 0.1
						atmosphere.Haze = 0
						table.insert(AtmosphereData.NewObjects, atmosphere)
					else
						local function collection(tags, module, customadd, customremove)
						local objs = {}
						local tagList = typeof(tags) == "string" and {tags} or tags
						for _, tag in tagList do
							for _, v in CollectionService:GetTagged(tag) do
								if customadd then
									customadd(objs, v, tag)
								else
									table.insert(objs, v)
								end
							end
							CollectionService:GetInstanceAddedSignal(tag):Connect(function(v)
								if not IsFeatureEnabled("AtmosphereEnabled", "AtmosphereKeybind") then return end
								if customadd then
									customadd(objs, v, tag)
								else
									table.insert(objs, v)
								end
							end)
							CollectionService:GetInstanceRemovedSignal(tag):Connect(function(v)
								if customremove then
									customremove(objs, v, tag)
								else
									for i, obj in objs do
										if obj == v then
											table.remove(objs, i)
											break
										end
									end
								end
							end)
						end
						local cleanFunc = function()
							table.clear(objs)
						end
						if module then
							module:Clean(cleanFunc)
						end
						return objs, cleanFunc
					end
					
					Lighting.Ambient = Color3.fromRGB(55, 55, 55)
					Lighting.Brightness = 2.5
					Lighting.ColorShift_Bottom = Color3.fromRGB(150, 100, 170)
					Lighting.ColorShift_Top = Color3.fromRGB(140, 120, 210)
					Lighting.EnvironmentDiffuseScale = 0.9
					Lighting.EnvironmentSpecularScale = 0.9
					Lighting.GlobalShadows = true
					Lighting.OutdoorAmbient = Color3.fromRGB(55, 55, 55)
					Lighting.ShadowSoftness = 0.15
					Lighting.Technology = Enum.Technology.ShadowMap
					Lighting.ClockTime = 6.47
					Lighting.GeographicLatitude = -7.00
					
					AtmosphereData.Data.TimeConnection = Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
						if not IsFeatureEnabled("AtmosphereEnabled", "AtmosphereKeybind") then return end
						if Lighting.ClockTime ~= 6.47 then
							Lighting.ClockTime = 6.47
						end
					end)
					
					local atmosphere = Instance.new("Atmosphere", Lighting)
					atmosphere.Density = 0.35
					atmosphere.Offset = 0.3
					atmosphere.Color = Color3.fromRGB(185, 185, 185)
					atmosphere.Decay = Color3.fromRGB(95, 102, 115)
					atmosphere.Glare = 0
					atmosphere.Haze = 0
					table.insert(AtmosphereData.NewObjects, atmosphere)
					
					local sky = Instance.new("Sky", Lighting)
					sky.MoonAngularSize = 0
					sky.MoonTextureId = ""
					sky.SkyboxBk = "rbxassetid://158422743"
					sky.SkyboxDn = "rbxassetid://158422584"
					sky.SkyboxFt = "rbxassetid://158423013"
					sky.SkyboxLf = "rbxassetid://158423239"
					sky.SkyboxRt = "rbxassetid://158422849"
					sky.SkyboxUp = "rbxassetid://158422277"
					sky.StarCount = 2800
					sky.SunAngularSize = 2
					sky.SunTextureId = ""
					table.insert(AtmosphereData.NewObjects, sky)
					
					local bloom = Instance.new("BloomEffect", Lighting)
					bloom.Enabled = true
					bloom.Intensity = 0.4
					bloom.Size = 22
					bloom.Threshold = 2.2
					table.insert(AtmosphereData.NewObjects, bloom)
					
					local depthOfField = Instance.new("DepthOfFieldEffect", Lighting)
					depthOfField.Enabled = false
					table.insert(AtmosphereData.NewObjects, depthOfField)
					
					for _, cloud in workspace:GetDescendants() do
						if cloud:IsA("Clouds") then
							cloud:Destroy()
						end
					end
					
					local function CreateCloud()
						local existingCloud = workspace.Terrain:FindFirstChild("MadeCloud")
						if existingCloud then
							existingCloud:Destroy()
						end
						local Cloud = Instance.new("Clouds", workspace.Terrain)
						Cloud.Name = "MadeCloud"
						Cloud.Enabled = true
						Cloud.Density = 0.9
						Cloud.Cover = 0.8
						Cloud.Color = Color3.new(1.1, 1.1, 1.1)
						return Cloud
					end
					
					AtmosphereData.Data.CurrentCloud = CreateCloud()
					
					local function cloudmodes()
						local weatherStates = {
							clear = { density = 0.6, cover = 0.8 },
							cloudy = { density = 0.7, cover = 0.9 },
							overcast = { density = 0.6, cover = 1 }
						}
						local function TransitionWeather(state)
							if not AtmosphereData.Data.CurrentCloud then return end
							local tweenInfo = TweenInfo.new(10)
							local cloudGoal = { Density = state.density, Cover = state.cover }
							local cloudTween = TweenService:Create(AtmosphereData.Data.CurrentCloud, tweenInfo, cloudGoal)
							cloudTween:Play()
						end
						while IsFeatureEnabled("AtmosphereEnabled", "AtmosphereKeybind") do
							local waitTime = math.random(15, 20)
							task.wait(waitTime)
							if not IsFeatureEnabled("AtmosphereEnabled", "AtmosphereKeybind") then break end
							local rand = math.random(1, 100)
							if rand <= 40 then
								TransitionWeather(weatherStates.clear)
							elseif rand <= 70 then
								TransitionWeather(weatherStates.cloudy)
							else
								TransitionWeather(weatherStates.overcast)
							end
						end
					end
					
					task.spawn(cloudmodes)
					
					AtmosphereData.Data.StoreBlocks, AtmosphereData.Data.CleanFunc = collection('block')
					
					local function water()
						local player = LocalPlayer
						if not (player and player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
							return
						end
						
						local hrp = player.Character.HumanoidRootPart
						local pos = hrp.Position
						local terrain = workspace.Terrain
						local waterpos = 0
						
						local attempts = 0
						while #AtmosphereData.Data.StoreBlocks == 0 and attempts < 50 do
							task.wait(0.1)
							attempts = attempts + 1
						end
						
						if #AtmosphereData.Data.StoreBlocks == 0 then
							return
						end
						
						if waterpos == 0 then
							local lowestypos = 99999
							for _, block in AtmosphereData.Data.StoreBlocks do
								if block and block.Position then
									local newray = workspace:Raycast(block.Position + Vector3.new(0, 800, 0), Vector3.new(0, -1000, 0))
									if newray and newray.Position.Y <= lowestypos then
										lowestypos = newray.Position.Y
									end
								end
							end
							waterpos = lowestypos
						end
						
						terrain:FillBlock(
							CFrame.new(pos.X, waterpos, pos.Z),
							Vector3.new(5000, 0.01, 5000),
							Enum.Material.Water
						)
						
						terrain.WaterColor = Color3.fromRGB(0, 50, 60)
						terrain.WaterReflectance = 0.7
						terrain.WaterTransparency = 0.25
						terrain.WaterWaveSize = 0.13
						terrain.WaterWaveSpeed = 8
						
						local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
						if humanoid then
							humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
						end
					end
					
					if game.PlaceId ~= 6872265039 then
						AtmosphereData.Data.CharacterAddedConnection = LocalPlayer.CharacterAdded:Connect(function(character)
							if not IsFeatureEnabled("AtmosphereEnabled", "AtmosphereKeybind") then return end
							local humanoid = character:WaitForChild("Humanoid")
							humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, false)
						end)
						
						water()
					end
					
					if workspace:FindFirstChild("Clouds") then
						for _, v in workspace.Clouds:GetChildren() do
							if v:IsA('Part') then
								v.Transparency = 1
							end
						end
					end
					end
				end)
			else
				AtmosphereCleanup()
				AtmosphereData.OriginalSettings.Ambient = nil
			end
		end
	})
	--
	AtmosphereToggle:Keybind({
		Mode = "Toggle",
		Flag = "AtmosphereKeybind",
		Callback = function() end
	})
	--
	AtmosphereDropdown = EnvironmentSection:Dropdown({
		Name = "",
		Default = "Blavish",
		Content = {"Blavish", "Realistic"},
		Flag = "AtmosphereMode",
		Hidden = true,
		Callback = function(Option)
			AtmosphereData.Settings.Mode = Option
			
			if IsFeatureEnabled("AtmosphereEnabled", "AtmosphereKeybind") then
				for _, v in AtmosphereData.NewObjects do
					if v and v.Parent then
						v:Destroy()
					end
				end
				table.clear(AtmosphereData.NewObjects)
				
				if AtmosphereData.Data.TimeConnection then
					AtmosphereData.Data.TimeConnection:Disconnect()
					AtmosphereData.Data.TimeConnection = nil
				end
				if AtmosphereData.Data.CharacterAddedConnection then
					AtmosphereData.Data.CharacterAddedConnection:Disconnect()
					AtmosphereData.Data.CharacterAddedConnection = nil
				end
				if AtmosphereData.Data.CurrentCloud then
					AtmosphereData.Data.CurrentCloud:Destroy()
					AtmosphereData.Data.CurrentCloud = nil
				end
				if AtmosphereData.Data.CleanFunc then
					AtmosphereData.Data.CleanFunc()
				end
				workspace.Terrain:Clear()
				
				if AtmosphereData.OriginalSettings.Ambient then
					Lighting.Ambient = AtmosphereData.OriginalSettings.Ambient
					Lighting.Brightness = AtmosphereData.OriginalSettings.Brightness
					Lighting.ColorShift_Bottom = AtmosphereData.OriginalSettings.ColorShift_Bottom
					Lighting.ColorShift_Top = AtmosphereData.OriginalSettings.ColorShift_Top
					Lighting.EnvironmentDiffuseScale = AtmosphereData.OriginalSettings.EnvironmentDiffuseScale
					Lighting.EnvironmentSpecularScale = AtmosphereData.OriginalSettings.EnvironmentSpecularScale
					Lighting.GlobalShadows = AtmosphereData.OriginalSettings.GlobalShadows
					Lighting.OutdoorAmbient = AtmosphereData.OriginalSettings.OutdoorAmbient
					Lighting.ShadowSoftness = AtmosphereData.OriginalSettings.ShadowSoftness
					Lighting.Technology = AtmosphereData.OriginalSettings.Technology
					Lighting.ClockTime = AtmosphereData.OriginalSettings.ClockTime
					Lighting.GeographicLatitude = AtmosphereData.OriginalSettings.GeographicLatitude
				end
				
				AtmosphereToggle:Set(true)
			end
		end
	})
	--
	local TexturePackSection = VisualSubSection2:Section({Name = "Texture Pack", Side = "Right", Fill = true})
	table.insert(NamedSections, TexturePackSection)
	--
	local TexturePackData = {
		Settings = {
			Pack = "Forest"
		},
		Data = {
			ImportFolder = nil,
			Connection = nil
		},
		Packs = {
			Forest = {
				AssetId = "rbxassetid://118888033167383",
				FirstPersonCFrame = CFrame.Angles(math.rad(0), math.rad(110), math.rad(60)),
				ThirdPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-45), math.rad(0)),
				ThirdPersonOffset = CFrame.new(0.3, -1.2, 0.25),
				Resources = {
					{name = "wood_sword", offset = CFrame.Angles(math.rad(0), math.rad(240), math.rad(15)), model = "Wood_Sword"},
					{name = "stone_sword", offset = CFrame.Angles(math.rad(0), math.rad(240), math.rad(15)), model = "Stone_Sword"},
					{name = "iron_sword", offset = CFrame.Angles(math.rad(0), math.rad(240), math.rad(15)), model = "Iron_Sword"},
					{name = "diamond_sword", offset = CFrame.Angles(math.rad(0), math.rad(240), math.rad(15)), model = "Diamond_Sword"},
					{name = "emerald_sword", offset = CFrame.Angles(math.rad(0), math.rad(240), math.rad(15)), model = "Emerald_Sword"}
				}
			},
			["Demon Slayer"] = {
				AssetId = "rbxassetid://14241215869",
				FirstPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-36), math.rad(0)),
				ThirdPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)),
				ThirdPersonOffset = CFrame.new(0, 0, -0.06),
				ThirdPersonOffsets = {
					{pattern = "rageblade", offset = CFrame.new(0.7, 0, -0.7)},
					{pattern = "sword", offset = CFrame.new(0.2, 0, -0.8)},
					{pattern = "blade", offset = CFrame.new(0.2, 0, -0.8)},
					{pattern = "dao", offset = CFrame.new(0.7, 0, -1.3)},
					{pattern = "diamond_axe", offset = CFrame.new(0.08, 0, 0), excludes = {"pickaxe"}},
					{pattern = "axe", offset = CFrame.new(-0.2, 0, -0.28), excludes = {"pickaxe", "diamond"}},
					{pattern = "diamond_pickaxe", offset = CFrame.new(0.2, 0, -0.26)},
					{pattern = "iron", offset = CFrame.new(0, -0.24, 0)},
					{pattern = "gold", offset = CFrame.new(0, 0.03, 0)},
					{pattern = "diamond", offset = CFrame.new(0, -0.03, 0)},
					{pattern = "emerald", offset = CFrame.new(0, -0.03, 0)},
					{pattern = "telepearl", offset = CFrame.new(0.1, 0, 0.1)},
					{pattern = "fireball", offset = CFrame.new(0.28, 0.1, 0)},
					{pattern = "bow", offset = CFrame.new(-0.2, 0.1, -0.05), excludes = {"crossbow"}},
					{pattern = "wood_crossbow", offset = CFrame.new(-0.5, 0, 0.05), excludes = {"tactical_crossbow"}},
					{pattern = "tactical_crossbow", offset = CFrame.new(-0.35, 0, -1.2), excludes = {"wood_crossbow"}}
				},
				Resources = {
					{name = "wood_sword", offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)), model = "Wood_Sword"},
					{name = "stone_sword", offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)), model = "Stone_Sword"},
					{name = "iron_sword", offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)), model = "Iron_Sword"},
					{name = "diamond_sword", offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)), model = "Diamond_Sword"},
					{name = "emerald_sword", offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)), model = "Emerald_Sword"},
					{name = "wood_pickaxe", offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)), model = "Wood_Pickaxe"},
					{name = "stone_pickaxe", offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)), model = "Stone_Pickaxe"},
					{name = "iron_pickaxe", offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)), model = "Iron_Pickaxe"},
					{name = "diamond_pickaxe", offset = CFrame.Angles(math.rad(0), math.rad(90), math.rad(-95)), model = "Diamond_Pickaxe"},
					{name = "fireball", offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)), model = "Fireball"},
					{name = "telepearl", offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)), model = "Telepearl"},
					{name = "diamond", offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-90)), model = "Diamond"},
					{name = "iron", offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)), model = "Iron"},
					{name = "gold", offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)), model = "Gold"},
					{name = "emerald", offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(-90)), model = "Emerald"},
					{name = "wood_bow", offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)), model = "Bow"},
					{name = "wood_crossbow", offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)), model = "Bow"},
					{name = "tactical_crossbow", offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)), model = "Bow"},
					{name = "wood_dao", offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)), model = "Wood_Sword"},
					{name = "stone_dao", offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)), model = "Stone_Sword"},
					{name = "iron_dao", offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)), model = "Iron_Sword"},
					{name = "diamond_dao", offset = CFrame.Angles(math.rad(0), math.rad(89), math.rad(-90)), model = "Diamond_Sword"}
				}
			},
			Exhibition = {
				AssetId = "rbxassetid://135803045271549",
				FirstPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)),
				ThirdPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)),
				ThirdPersonOffset = CFrame.new(0.36, 0, -0.75),
				Resources = {
					{name = "wood_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Wood_Sword"},
					{name = "stone_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Stone_Sword"},
					{name = "iron_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Iron_Sword"},
					{name = "diamond_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Diamond_Sword"},
					{name = "emerald_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Emerald_Sword"}
				}
			},
			["Cotton Candy"] = {
				AssetId = "rbxassetid://103316444229616",
				FirstPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)),
				ThirdPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)),
				ThirdPersonOffset = CFrame.new(0.2, 0, -0.2),
				ThirdPersonOffsets = {
					{pattern = "rageblade", offset = CFrame.new(0.7, 0, -1)},
					{pattern = "sword", offset = CFrame.new(0.6, 0, -1.2) - Vector3.new(0, 0, -0.3)},
					{pattern = "blade", offset = CFrame.new(0.6, 0, -1.2) - Vector3.new(0, 0, -0.3)},
					{pattern = "diamond_axe", offset = CFrame.new(0.08, 0, -1.1) - Vector3.new(0, 0, -1.1), excludes = {"pickaxe"}},
					{pattern = "axe", offset = CFrame.new(-0.2, 0, -2.4) + Vector3.new(0, 0, 2.12), excludes = {"pickaxe", "diamond"}},
					{pattern = "iron", offset = CFrame.new(0, -0.24, 0)},
					{pattern = "diamond", offset = CFrame.new(0, 0.027, 0)},
					{pattern = "emerald", offset = CFrame.new(0, 0.001, 0)},
					{pattern = "telepearl", offset = CFrame.new(0.1, 0, 0.1)},
					{pattern = "fireball", offset = CFrame.new(0.28, 0.1, 0)},
					{pattern = "bow", offset = CFrame.new(-0.29, 0.1, -0.2), excludes = {"crossbow"}},
					{pattern = "wood_crossbow", offset = CFrame.new(-0.6, 0, 0), excludes = {"tactical_crossbow"}},
					{pattern = "tactical_crossbow", offset = CFrame.new(-0.5, 0, -1.2), excludes = {"wood_crossbow"}}
				},
				Resources = {
					{name = "wood_sword", offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)), model = "Wood_Sword"},
					{name = "stone_sword", offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)), model = "Stone_Sword"},
					{name = "iron_sword", offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)), model = "Iron_Sword"},
					{name = "diamond_sword", offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)), model = "Diamond_Sword"},
					{name = "emerald_sword", offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-90)), model = "Emerald_Sword"},
					{name = "rageblade", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(90)), model = "Rageblade"},
					{name = "wood_pickaxe", offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)), model = "Wood_Pickaxe"},
					{name = "stone_pickaxe", offset = CFrame.Angles(math.rad(0), math.rad(-180), math.rad(-95)), model = "Stone_Pickaxe"},
					{name = "iron_pickaxe", offset = CFrame.Angles(math.rad(0), math.rad(-18033), math.rad(-95)), model = "Iron_Pickaxe"},
					{name = "diamond_pickaxe", offset = CFrame.Angles(math.rad(0), math.rad(80), math.rad(-95)), model = "Diamond_Pickaxe"},
					{name = "wood_axe", offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)), model = "Wood_Axe"},
					{name = "stone_axe", offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)), model = "Stone_Axe"},
					{name = "iron_axe", offset = CFrame.Angles(math.rad(0), math.rad(-10), math.rad(-95)), model = "Iron_Axe"},
					{name = "diamond_axe", offset = CFrame.Angles(math.rad(0), math.rad(-89), math.rad(-95)), model = "Diamond_Axe"},
					{name = "fireball", offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)), model = "Fireball"},
					{name = "telepearl", offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)), model = "Telepearl"},
					{name = "diamond", offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)), model = "Diamond"},
					{name = "iron", offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)), model = "Iron"},
					{name = "emerald", offset = CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90)), model = "Emerald"},
					{name = "wood_bow", offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)), model = "Bow"},
					{name = "wood_crossbow", offset = CFrame.Angles(math.rad(0), math.rad(0), math.rad(90)), model = "Bow"},
					{name = "tactical_crossbow", offset = CFrame.Angles(math.rad(0), math.rad(180), math.rad(-90)), model = "Bow"}
				}
			},
			["Holiday"] = {
				AssetId = "rbxassetid://115871883162606",
				FirstPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)),
				ThirdPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)),
				ThirdPersonOffset = CFrame.new(0.7, 0, -0.9),
				Resources = {
					{name = "wood_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Wood_Sword"},
					{name = "stone_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Stone_Sword"},
					{name = "iron_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Iron_Sword"},
					{name = "diamond_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Diamond_Sword"},
					{name = "emerald_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Emerald_Sword"}
				}
			},
			Modern = {
				AssetId = "rbxassetid://121408220714559",
				FirstPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)),
				ThirdPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)),
				ThirdPersonOffset = CFrame.new(0.55, 0, -0.8),
				Resources = {
					{name = "wood_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Wood_Sword"},
					{name = "stone_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Stone_Sword"},
					{name = "iron_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Iron_Sword"},
					{name = "diamond_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Diamond_Sword"},
					{name = "emerald_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Emerald_Sword"}
				}
			},
			Christmas = {
				AssetId = "rbxassetid://132243663640200",
				FirstPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)),
				ThirdPersonCFrame = CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0)),
				ThirdPersonOffset = CFrame.new(0.7, 0, -0.8),
				Resources = {
					{name = "wood_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Wood_Sword"},
					{name = "stone_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Stone_Sword"},
					{name = "iron_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Iron_Sword"},
					{name = "diamond_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Diamond_Sword"},
					{name = "emerald_sword", offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)), model = "Emerald_Sword"}
				}
			}
		}
	}
	--
	local function TexturePackCleanup()
		if TexturePackData.Data.Connection then
			TexturePackData.Data.Connection:Disconnect()
			TexturePackData.Data.Connection = nil
		end
		if TexturePackData.Data.ImportFolder then
			TexturePackData.Data.ImportFolder:Destroy()
			TexturePackData.Data.ImportFolder = nil
		end
	end
	--
	local function GetThirdPersonOffset(pack, itemName)
		if pack.ThirdPersonOffsets then
			for _, entry in ipairs(pack.ThirdPersonOffsets) do
				if itemName:match(entry.pattern) then
					local excluded = false
					if entry.excludes then
						for _, exclude in ipairs(entry.excludes) do
							if itemName:match(exclude) then
								excluded = true
								break
							end
						end
					end
					if not excluded then
						return entry.offset
					end
				end
			end
		end
		return pack.ThirdPersonOffset or CFrame.new()
	end
	--
	local function SetupTexturePack()
		if TexturePackData.Data.Connection then return end
		local SelectedPack = TexturePackData.Packs[TexturePackData.Settings.Pack]
		if not SelectedPack then return end
				
		local objs = game:GetObjects(SelectedPack.AssetId)
		local import = objs[1]
		import.Parent = ReplicatedStorage
		TexturePackData.Data.ImportFolder = import
		
		local index = {}
		for _, v in SelectedPack.Resources do
			table.insert(index, {
				name = v.name,
				offset = v.offset,
				model = import:WaitForChild(v.model)
			})
		end
		
		TexturePackData.Data.Connection = Camera.Viewmodel.ChildAdded:Connect(function(tool)
			if not tool:IsA("Accessory") then return end
			if not IsFeatureEnabled("TexturePackEnabled", "TexturePackKeybind") then return end
			
			for _, v in index do
				if v.name == tool.Name then
					for _, part in tool:GetDescendants() do
						if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
							part.Transparency = 1
						end
					end
					
					local model = v.model:Clone()
					model.CFrame = tool:WaitForChild("Handle").CFrame * v.offset * SelectedPack.FirstPersonCFrame
					model.Parent = tool
					
					local weld = Instance.new("WeldConstraint", model)
					weld.Part0 = model
					weld.Part1 = tool.Handle
					
					local tool2 = LocalPlayer.Character:WaitForChild(tool.Name)
					
					for _, part in tool2:GetDescendants() do
						if part:IsA("Part") or part:IsA("MeshPart") or part:IsA("UnionOperation") then
							part.Transparency = 1
						end
					end
					
					local model2 = v.model:Clone()
					model2.Anchored = false
					model2.CFrame = tool2:WaitForChild("Handle").CFrame * v.offset * SelectedPack.ThirdPersonCFrame * GetThirdPersonOffset(SelectedPack, v.name)
					model2.Parent = tool2
					
					local weld2 = Instance.new("WeldConstraint", model2)
					weld2.Part0 = model2
					weld2.Part1 = tool2.Handle
				end
			end
		end)
	end
	--
	local TexturePackToggle = TexturePackSection:Toggle({
		Name = "Enabled",
		Default = false,
		Flag = "TexturePackEnabled",
		Callback = function(State)
			local keybind = Library.Flags["TexturePackKeybind"]
			if keybind and keybind.Keybind and keybind.Keybind ~= "[-]" and Library.Flags["TexturePackEnabled"]:Get() then
				local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
				Library:Notify({
					Message = ("<font color='rgb(%d, %d, %d)'>Texture Pack</font> has been <font color='rgb(%d, %d, %d)'>%s</font>"):format(R, G, B, R, G, B, State and "enabled" or "disabled"),
					Position = "Top Left",
					Delay = 2
				})
			end
			
			if State then
				task.wait(0.1)
				task.spawn(SetupTexturePack)
			else
				TexturePackCleanup()
			end
		end
	})
	--
	TexturePackToggle:Keybind({
		Mode = "Toggle",
		Flag = "TexturePackKeybind",
		Callback = function() end
	})
	--
	TexturePackSection:Dropdown({
		Name = "",
		Default = "Forest",
		Content = {"Forest", "Demon Slayer", "Exhibition", "Cotton Candy", "Holiday", "Modern", "Christmas"},
		Flag = "TexturePackMode",
		Callback = function(Option)
			TexturePackData.Settings.Pack = Option
			if Library.Flags["TexturePackEnabled"] and Library.Flags["TexturePackEnabled"]:Get() then
				TexturePackCleanup()
				task.spawn(SetupTexturePack)
			end
		end
	})
	--
    VisualSubSection3:Section({Fill = true})
    VisualSubSection3:Section({Side = "Right", Fill = true})
    --
    VisualSubSection4:Section({Fill = true})
    VisualSubSection4:Section({Side = "Right", Fill = true})
end
--
do -- Settings
	Settings:Section({Fill = true})
	local SettingsSection = Settings:Section({Name = "Settings", Side = "Right", Fill = true})
	table.insert(NamedSections, SettingsSection)
	--
	do -- Settings
        SettingsSection:Label({Message = "Menu key"}):Keybind({Default = Enum.KeyCode.LeftAlt, UseMode = false, Callback = function(Key) 
			Library.UI.CloseBind = Key 			
		end})
		--
		SettingsSection:Label({Message = "Menu color"}):ColorPicker({Default = Library.Theme.Default.Accent, Callback = function(Color)
			Library:UpdateColor("Accent", Color)
			Library:UpdateColor("SecondAccent", Color3.fromRGB(math.max(math.floor(Color.R * 255) - 12, 0), math.max(math.floor(Color.G * 255) - 12, 0), math.max(math.floor(Color.B * 255) - 12, 0)))
		end})
		--
        SettingsSection:Toggle({
			Name = "Menu resize",
			Default = false,
			Flag = "MenuSectionCalculate",
			Callback = function(State)
				if State then
					task.spawn(function()
						task.wait(0.5)
						for _, Section in ipairs(NamedSections) do
							if Section and Section.Elements and Section.Elements.ContentHolder then
								local SectionScrolling = Section.Elements.ContentHolder
								local SectionOutline = SectionScrolling.Parent.Parent
								Section:CalculateHeight(SectionOutline, SectionScrolling)
								Library:Fade(false, Library:GetObjectsTable(SectionOutline, true), SectionOutline, 0.1)
								task.delay(Library.UI.TweenSpeed, function()
									Library:Fade(true, Library:GetObjectsTable(SectionOutline, true), SectionOutline, 0.1)
								end)
							end
						end
					end)
				end
			end
		})
        --
        local UIScaleInstance = nil
		local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
		local AutoScaleToggle = SettingsSection:Toggle({
			Name = "Menu autoscale",
			Default = IsMobile,
			Flag = "MenuAutoScale",
			Callback = function(State)
				if State then
                    -- sheesh your mobile bud
				end
			end
		})
        --
		SettingsSection:Slider({Name = "Menu animation speed", Min = 0, Max = 150, Default = 100, Ending = "%", Disable = {"Off", 0, 150}, Callback = function(Value)
			local MinSource, MaxSource = 1, 150
			local MinTarget, MaxTarget = 0.8, 0.1
			local NewValue = MinTarget + ((Value - MinSource) * (MaxTarget - MinTarget)) / (MaxSource - MinSource)
			--
			Library.UI.TweenSpeed = Value == (0 or 150) and 0 or NewValue
		end})
		--
		SettingsSection:Button({Name = "Unload", Callback = Library.Unload})
		SettingsSection:Button({Name = "Disable all", Callback = Library.Disable})
	end
end
--
do -- Exploits
    local ExploitSubSection, ExploitSubSection2, ExploitSubSection3, ExploitSubSection4 = Exploits:SubSection({Name = "Category", Options = {"rbxassetid://18334627891", "rbxassetid://18334630306", "rbxassetid://18334626899", "rbxassetid://18334625304"}})
    --
    local AutoQueueSection = ExploitSubSection:Section({Name = "Auto Queue", Fill = true})
    table.insert(NamedSections, AutoQueueSection)
    --
    local NukerSection = ExploitSubSection2:Section({Name = "Nuker", Fill = true})
    table.insert(NamedSections, NukerSection)
    --
    ExploitSubSection2:Section({Side = "Right", Fill = true})
    --
    ExploitSubSection3:Section({Fill = true})
    ExploitSubSection3:Section({Side = "Right", Fill = true})
    --
    ExploitSubSection4:Section({Fill = true})
    ExploitSubSection4:Section({Side = "Right", Fill = true})
    --
    do -- Auto Queue
        local AutoQueueData = {
            Settings = {
                Delay = 1
            },
            Data = {
                DeathConnection = nil,
                MatchEndConnection = nil,
                Sent = false
            }
        }
        
        local function JoinQueue()
            if AutoQueueData.Data.Sent then return end
            AutoQueueData.Data.Sent = true
            task.delay(AutoQueueData.Settings.Delay, GameData.Utils.QueueController.joinQueue, GameData.Utils.QueueController, GameData.Utils.Store:getState().Game.queueType)
        end
        
        local AutoQueueToggle = AutoQueueSection:Toggle({
            Name = "Enabled",
            Default = false,
            Flag = "AutoQueueEnabled",
            Callback = function(State)
                if State then
                    AutoQueueData.Data.Sent = false
                    
                    AutoQueueData.Data.DeathConnection = GameData.Events.Death.Event:Connect(function(Values)
                        if Values.Final and Values.KilledPlayer and Values.KilledPlayer == LocalPlayer then
                            JoinQueue()
                        end
                    end)
                    
                    AutoQueueData.Data.MatchEndConnection = GameData.Events.MatchEnd.Event:Connect(function()
                        JoinQueue()
                    end)
                else
                    if AutoQueueData.Data.DeathConnection then
                        AutoQueueData.Data.DeathConnection:Disconnect()
                        AutoQueueData.Data.DeathConnection = nil
                    end
                    if AutoQueueData.Data.MatchEndConnection then
                        AutoQueueData.Data.MatchEndConnection:Disconnect()
                        AutoQueueData.Data.MatchEndConnection = nil
                    end
                end
            end
        })
        --
        AutoQueueToggle:Keybind({
            Mode = "Toggle",
            Flag = "AutoQueueKeybind",
            Callback = function() end
        })
        --
        AutoQueueSection:Slider({
            Name = "",
            Min = 0,
            Max = 4,
            Default = 1,
            Decimal = 0.1,
            Ending = "s",
            Flag = "AutoQueueDelay",
            Callback = function(Value)
                AutoQueueData.Settings.Delay = Value
            end
        })
    end
    
    do -- Staff Detector
        local StaffDetectorSection = ExploitSubSection:Section({Name = "Staff Detector", Side = "Right", Fill = true})
        table.insert(NamedSections, StaffDetectorSection)
        
        local StaffDetectorData = {
            Settings = {
                Mode = "Disable All",
                Players = false,
                Clan = false,
                YouTuber = false,
                Party = false,
                Spectators = true
            },
            Data = {
                Clans = {"IPS", "L8R", "DV", "gg"},
                WatchedPlayers = {},
                Players = {},
                Friends = {},
                Active = {}
            }
        }
        
        local function CheckGroup(Player, ID)
            return pcall(Player.GetRankInGroup, Player, ID)
        end
        
        local function Notify(Player, Reason)
            local R, G, B = Library.Theme.Default.Accent.R * 255, Library.Theme.Default.Accent.G * 255, Library.Theme.Default.Accent.B * 255
            Library:Notify({
                Message = ("<font color='rgb(%d, %d, %d)'>Staff Detector</font>: %s (%s)"):format(R, G, B, Player.Name, Reason),
                Position = "Top Left",
                Delay = 60
            })
            
            if StaffDetectorData.Settings.Party and GameData.Utils.Store then
                pcall(function()
                    local PartyController = Knit.Controllers.PartyController
                    if PartyController then
                        PartyController:leaveParty()
                    end
                end)
            end
            
            if StaffDetectorData.Settings.Mode == "Disable All" then
                Library:Disable()
            end
        end
        
        local function GetFriends(ID)
            if StaffDetectorData.Data.Friends[ID] then return StaffDetectorData.Data.Friends[ID] end
            
            local Success, List = pcall(function()
                local Friends = {}
                local Pages = Players:GetFriendsAsync(ID)
                local PageCount = 0
                
                repeat
                    local CurrentPage = Pages:GetCurrentPage()
                    for _, FriendData in next, CurrentPage do
                        Friends[FriendData.Id] = FriendData.Username
                    end
                    
                    PageCount += 1
                    if not Pages.IsFinished and PageCount < 12 then
                        Pages:AdvanceToNextPageAsync()
                    end
                until Pages.IsFinished or PageCount >= 12
                
                return Friends
            end)
            
            if Success then
                StaffDetectorData.Data.Friends[ID] = List
                return List
            end
            
            return {}
        end
        
        local function FindMutual(Friends)
            for ID, Name in next, Friends do
                if StaffDetectorData.Data.Players[ID] then
                    return Name
                end
            end
            return nil
        end
        
        local function CheckSpectator(player)
            if not StaffDetectorData.Settings.Spectators then
                return false
            end
            
            if not player:GetAttribute("Spectator") or player:GetAttribute("Team") then
                return false
            end
            
            if GameData.Utils.Store and GameData.Utils.Store:getState().Game.customMatch then
                return false
            end
            
            local Friend = FindMutual(GetFriends(player.UserId))
            
            if not Friend then
                Notify(player, "Suspicious spectator")
                return true
            end
            
            return false
        end
        
        local function GroupRankCheck(player)
            local Success, Rank = CheckGroup(player, 5774246)
            return Success and Rank >= (StaffDetectorData.Settings.YouTuber and 20 or 100)
        end
        
        local function ClanCheck(player)
            local ClanTag = player:GetAttribute("ClanTag")
            if not ClanTag then return false end
            
            for _, BannedClan in next, StaffDetectorData.Data.Clans do
                if ClanTag == BannedClan then
                    return true
                end
            end
            
            return false
        end
        
        local function WatchedPlayerCheck(player)
            if not StaffDetectorData.Settings.Players then return false end
            for _, name in next, StaffDetectorData.Data.WatchedPlayers do
                if player.Name:lower() == name:lower() or player.DisplayName:lower() == name:lower() then
                    return true
                end
            end
            return false
        end
        
        local function CheckPlayer(player)
            if player == LocalPlayer then return end
            if not IsFeatureEnabled("StaffDetectorEnabled", "StaffDetectorKeybind") then return end
            
            StaffDetectorData.Data.Players[player.UserId] = player.Name
            StaffDetectorData.Data.Active[player.UserId] = StaffDetectorData.Data.Active[player.UserId] or {}
            
            if WatchedPlayerCheck(player) then
                Notify(player, "Watched player")
                return
            end
            
            if GroupRankCheck(player) then
                Notify(player, "Verified staff member")
                return
            end
            
            local SpectatorCon
            SpectatorCon = player:GetAttributeChangedSignal("Spectator"):Connect(function()
                if not IsFeatureEnabled("StaffDetectorEnabled", "StaffDetectorKeybind") then return end
                if CheckSpectator(player) then
                    SpectatorCon:Disconnect()
                    return
                end
            end)
            
            table.insert(StaffDetectorData.Data.Active[player.UserId], SpectatorCon)
            if CheckSpectator(player) or not StaffDetectorData.Settings.Clan then
                return
            end
            
            local function SeeClan()
                if not IsFeatureEnabled("StaffDetectorEnabled", "StaffDetectorKeybind") then return end
                if ClanCheck(player) then
                    Notify(player, "Restricted clan: " .. player:GetAttribute("ClanTag"))
                    if SpectatorCon then
                        SpectatorCon:Disconnect()
                    end
                end
            end
            
            if player:GetAttribute("ClanTag") then
                SeeClan()
            else
                local ClanCon = player:GetAttributeChangedSignal("ClanTag"):Connect(SeeClan)
                table.insert(StaffDetectorData.Data.Active[player.UserId], ClanCon)
            end
        end
        
        local function CleanConnection(player)
            if StaffDetectorData.Data.Active[player.UserId] then
                for _, v in next, StaffDetectorData.Data.Active[player.UserId] do
                    if v.Connected then
                        v:Disconnect()
                    end
                end
                StaffDetectorData.Data.Active[player.UserId] = nil
            end
            
            StaffDetectorData.Data.Players[player.UserId] = nil
            StaffDetectorData.Data.Friends[player.UserId] = nil
        end
        
        local function CleanupAll()
            if StaffDetectorData.Data.PlayerAddedConnection then
                StaffDetectorData.Data.PlayerAddedConnection:Disconnect()
                StaffDetectorData.Data.PlayerAddedConnection = nil
            end
            if StaffDetectorData.Data.PlayerRemovingConnection then
                StaffDetectorData.Data.PlayerRemovingConnection:Disconnect()
                StaffDetectorData.Data.PlayerRemovingConnection = nil
            end
            
            for _, v in next, StaffDetectorData.Data.Active do
                for _, conn in next, v do
                    if conn.Connected then
                        conn:Disconnect()
                    end
                end
            end
            
            table.clear(StaffDetectorData.Data.Active)
            table.clear(StaffDetectorData.Data.Players)
            table.clear(StaffDetectorData.Data.Friends)
        end
        
        local StaffDetectorToggle = StaffDetectorSection:Toggle({
            Name = "Enabled",
            Default = false,
            Flag = "StaffDetectorEnabled",
            Callback = function(State)
                if State then
                    task.spawn(function()
                        for _, player in next, Players:GetPlayers() do
                            task.defer(CheckPlayer, player)
                        end
                        
                        StaffDetectorData.Data.PlayerAddedConnection = Players.PlayerAdded:Connect(function(player)
                            if IsFeatureEnabled("StaffDetectorEnabled", "StaffDetectorKeybind") then
                                CheckPlayer(player)
                            end
                        end)
                        StaffDetectorData.Data.PlayerRemovingConnection = Players.PlayerRemoving:Connect(CleanConnection)
                        
                        repeat
                            task.wait(0.5)
                        until not IsFeatureEnabled("StaffDetectorEnabled", "StaffDetectorKeybind")
                        
                        CleanupAll()
                    end)
                else
                    CleanupAll()
                end
            end
        })
        --
        StaffDetectorToggle:Keybind({
            Mode = "Toggle",
            Flag = "StaffDetectorKeybind",
            Callback = function() end
        })
        --
        StaffDetectorSection:Dropdown({
            Name = "",
            Default = "Disable All",
            Content = {"Disable All", "Notify"},
            Flag = "StaffDetectorMode",
            Callback = function(Option)
                StaffDetectorData.Settings.Mode = Option
            end
        })
        --
        local PlayersList, PlayersTextBox, PlayersAddButton, PlayersDeleteButton
        
        local PlayersToggle = StaffDetectorSection:Toggle({
            Name = "Players",
            Default = false,
            Flag = "StaffDetectorPlayers",
            Callback = function(State)
                StaffDetectorData.Settings.Players = State
                task.spawn(function()
                    repeat task.wait() until PlayersList
                    PlayersList:SetVisible(State)
                    PlayersTextBox:SetVisible(State)
                    PlayersAddButton:SetVisible(State)
                    PlayersDeleteButton:SetVisible(State)
                end)
            end
        })
        --
        PlayersList = StaffDetectorSection:List({
            Size = 80,
            MultiSelect = false,
            Flag = "StaffDetectorPlayersList",
            Hidden = true
        })
        --
        PlayersTextBox = StaffDetectorSection:TextBox({
            Name = "Player Name",
            Default = "",
            Flag = "StaffDetectorPlayerName",
            Hidden = true
        })
        --
        PlayersAddButton = StaffDetectorSection:Button({
            Name = "Add Entry",
            Hidden = true,
            Callback = function()
                local playerName = Library.Flags["StaffDetectorPlayerName"]:Get()
                if playerName ~= "" then
                    PlayersList:AddValue(playerName)
                    table.insert(StaffDetectorData.Data.WatchedPlayers, playerName)
                end
            end
        })
        --
        PlayersDeleteButton = StaffDetectorSection:Button({
            Name = "Delete Entry",
            Hidden = true,
            Callback = function()
                local selectedPlayer = Library.Flags["StaffDetectorPlayersList"]:Get()
                if selectedPlayer and selectedPlayer ~= "" then
                    PlayersList:RemoveValue(selectedPlayer)
                    for i, v in StaffDetectorData.Data.WatchedPlayers do
                        if v == selectedPlayer then
                            table.remove(StaffDetectorData.Data.WatchedPlayers, i)
                            break
                        end
                    end
                end
            end
        })
        --
        local CustomClansToggle, ClansList, ClansTextBox, ClansAddButton, ClansDeleteButton
        
        local ClansToggle = StaffDetectorSection:Toggle({
            Name = "Clans",
            Default = false,
            Flag = "StaffDetectorClans",
            Callback = function(State)
                StaffDetectorData.Settings.Clan = State
                task.spawn(function()
                    repeat task.wait() until CustomClansToggle
                    CustomClansToggle:SetVisible(State)
                    if not State then
                        ClansList:SetVisible(false)
                        ClansTextBox:SetVisible(false)
                        ClansAddButton:SetVisible(false)
                        ClansDeleteButton:SetVisible(false)
                    end
                end)
            end
        })
        --
        CustomClansToggle = StaffDetectorSection:Toggle({
            Name = "Edit List",
            Default = false,
            Flag = "StaffDetectorCustomClans",
            Hidden = true,
            Callback = function(State)
                StaffDetectorData.Settings.CustomClans = State
                task.spawn(function()
                    repeat task.wait() until ClansList
                    ClansList:SetVisible(State)
                    ClansTextBox:SetVisible(State)
                    ClansAddButton:SetVisible(State)
                    ClansDeleteButton:SetVisible(State)
                end)
            end
        })
        --
        ClansList = StaffDetectorSection:List({
            Size = 80,
            MultiSelect = false,
            Flag = "StaffDetectorClansList",
            Hidden = true
        })
        --
        for _, clan in ipairs(StaffDetectorData.Data.Clans) do
            ClansList:AddValue(clan)
        end
        --
        ClansTextBox = StaffDetectorSection:TextBox({
            Name = "Clan Tag",
            Default = "",
            Flag = "StaffDetectorClanName",
            Hidden = true
        })
        --
        ClansAddButton = StaffDetectorSection:Button({
            Name = "Add Entry",
            Hidden = true,
            Callback = function()
                local clanName = Library.Flags["StaffDetectorClanName"]:Get()
                if clanName ~= "" then
                    ClansList:AddValue(clanName)
                    table.insert(StaffDetectorData.Data.Clans, clanName)
                end
            end
        })
        --
        ClansDeleteButton = StaffDetectorSection:Button({
            Name = "Delete Entry",
            Hidden = true,
            Callback = function()
                local selectedClan = Library.Flags["StaffDetectorClansList"]:Get()
                if selectedClan and selectedClan ~= "" then
                    ClansList:RemoveValue(selectedClan)
                    for i, v in StaffDetectorData.Data.Clans do
                        if v == selectedClan then
                            table.remove(StaffDetectorData.Data.Clans, i)
                            break
                        end
                    end
                end
            end
        })
        --
        StaffDetectorSection:Toggle({
            Name = "YouTubers",
            Default = false,
            Flag = "StaffDetectorYouTubers",
            Callback = function(State)
                StaffDetectorData.Settings.YouTuber = State
            end
        })
        --
        StaffDetectorSection:Toggle({
            Name = "Suspicious Spectators",
            Default = true,
            Flag = "StaffDetectorSpectators",
            Callback = function(State)
                StaffDetectorData.Settings.Spectators = State
            end
        })
        --
        StaffDetectorSection:Toggle({
            Name = "Leave Party",
            Default = false,
            Flag = "StaffDetectorParty",
            Callback = function(State)
                StaffDetectorData.Settings.Party = State
            end
        })
    end
    --
    do -- Nuker
        local NukerData = {
            Settings = {
                Distance = 28,
                HandCheck = false,
                AutoSwitch = true
            },
            Data = {
                LastHitNormal = Enum.NormalId.Top
            }
        }
        
        local function GetBlocksAroundPoint(StartPos, Exclude)
            local Store = GameData.Utils.BlockEngine:getStore()
            local Blocks = {}
            for _, v in Enum.NormalId:GetEnumItems() do
                if v == Enum.NormalId.Bottom then
                    continue
                end
                
                Blocks[v.Name] = {}
                for i2 = 0, 100 do
                    local OriginalPosition = StartPos + (Vector3.fromNormalId(v) * i2)
                    local Position = GameData.Utils.BlockEngine:getBlockPosition(OriginalPosition)
                    local Position2 = GameData.Utils.BlockEngine:getBlockPosition(OriginalPosition + Vector3.new(0, 3, 0))
                    
                    local Block = Store:getBlockAt(Position)
                    local Block2 = Store:getBlockAt(Position2)
                    local BlockExists = false
                    for _, blocks in Blocks do
                        if blocks.Block == Block then
                            BlockExists = true
                        end
                    end
                    
                    if Block then
                        if not BlockExists and (Exclude and not table.find(Exclude, Block) or not Exclude) then
                            table.insert(Blocks[v.Name], {
                                Block = Block,
                                OriginalPosition = OriginalPosition,
                                BlockPosition = Position,
                                HitNormal = v
                            })
                            
                            if not Block2 then
                                break
                            end
                        end
                    else
                        break
                    end
                end
            end
            
            return Blocks
        end
        
        local function FindWeakestSide(Bed)
            local BlocksA = GetBlocksAroundPoint(Bed.Position, {})
            local BlocksB = GetBlocksAroundPoint(Bed.Position + Vector3.new(0, 0, 3), {})
            local BlockASides, BlockBSides = {}, {}
            local Health, Side, ActualSide = math.huge, {}, {}
            local PlayerTeamId = LocalPlayer:GetAttribute("Team") or 0
            
            for i, v in BlocksA do
                BlockASides[i] = 0
                for _, v2 in v do
                    if not v2.Block:GetAttribute("NoBreak") and not v2.Block:GetAttribute("Team"..tostring(PlayerTeamId).."NoBreak") and v2.Block ~= Bed then
                        local BlockData = GameData.Utils.BlockEngine:getStore():getBlockData(v2.BlockPosition)
                        local BlockHealth = BlockData and BlockData:GetAttribute(GameData.Utils.BlockEngine:getDefaultHealthKey())
                        if not BlockData or not BlockHealth then
                            BlockHealth = v2.Block:GetAttribute("Health") or 0
                        end
                        
                        BlockASides[i] += BlockHealth
                    end
                end
            end
            
            for i, v in BlocksB do
                BlockBSides[i] = 0
                for _, v2 in v do
                    if not v2.Block:GetAttribute("NoBreak") and not v2.Block:GetAttribute("Team"..tostring(PlayerTeamId).."NoBreak") and v2.Block ~= Bed then
                        local BlockData = GameData.Utils.BlockEngine:getStore():getBlockData(v2.BlockPosition)
                        local BlockHealth = BlockData and BlockData:GetAttribute(GameData.Utils.BlockEngine:getDefaultHealthKey())
                        if not BlockData or not BlockHealth then
                            BlockHealth = v2.Block:GetAttribute("Health") or 0
                        end
                        
                        BlockBSides[i] += BlockHealth
                    end
                end
            end
            
            for i, v in BlockASides do
                if Health > v then
                    Health, Side, ActualSide = v, BlocksA, BlocksA[i]
                end
            end
            
            for i, v in BlockBSides do
                if Health > v then
                    Health, Side, ActualSide = v, BlocksB, BlocksB[i]
                end
            end
            
            return ActualSide, Side, Health
        end
        
        local function GetNearestBed()
            local PlayerTeamId = LocalPlayer:GetAttribute("Team") or 0
            local Data = {
                Bed = nil,
                Distance = math.huge
            }
            
            for _, v in CollectionService:GetTagged("bed") do
                local TeamId = v:GetAttribute("TeamId")
                if (TeamId and TeamId ~= PlayerTeamId or not TeamId) and not v:GetAttribute("Team"..tostring(PlayerTeamId).."NoBreak") and IsAlive(LocalPlayer) then
                    local Distance = GetDistanceFrom(LocalPlayer.Character.PrimaryPart.Position, v.Position)
                    if Data.Distance > Distance then
                        Data = {
                            Bed = v,
                            Distance = Distance
                        }
                    end
                end
            end
            
            return Data
        end
        
        local function GetBestItemToBreakBlock(Type)
            local Inventory = GetInventory()
            local Data = {
                Item = nil,
                Damage = 0
            }
            
            if Inventory and Inventory.items then
                for _, v in Inventory.items do
                    local Meta = GameData.Utils.ItemMeta[v.itemType]
                    if Meta and Meta.breakBlock then
                        for i2, v2 in Meta.breakBlock do
                            if Type:lower():find(i2:lower()) and v2 > Data.Damage then
                                Data = {
                                    Item = v.tool,
                                    Damage = v2
                                }
                            end
                        end
                    end
                end
            end
            
            return Data
        end
        
        local function DamageBlock(Block, Hit)
            local Position = GameData.Utils.BlockEngine:getBlockPosition(Block.Position)
            if Position then
                local Result, Response = GameData.Utils.BlockRemotes:Get("DamageBlock"):CallServerAsync({
                    blockRef = {blockPosition = Position},
                    hitPosition = Position,
                    hitNormal = Vector3.fromNormalId(Hit)
                }):awaitStatus()
                
                if Response == "damaged" then
                    local BlockData = GameData.Utils.BlockEngine:getStore():getBlockData(Block.Position)
                    local BlockHealth = BlockData and BlockData:GetAttribute(GameData.Utils.BlockEngine:getDefaultHealthKey())
                    if not BlockData or not BlockHealth and Block then
                        BlockHealth = Block:GetAttribute("Health")
                    end
                    
                    if BlockHealth then
                        local MaxHealth = Block:GetAttribute("MaxHealth")
                        if MaxHealth and GameData.Utils.BlockBreaker then
                            GameData.Utils.BlockBreaker:updateHealthbar({blockPosition = Position}, BlockHealth, MaxHealth, 2, Block)
                        end
                    end
                end
                
                return Response, Result
            end
            return
        end
        
        local NukerToggle = NukerSection:Toggle({
            Name = "Enabled",
            Default = false,
            Flag = "NukerEnabled",
            Callback = function(State)
                if State then
                    task.spawn(function()
                        repeat
                            if NukerData.Settings.HandCheck then
                                local CurrentHand = GetInventory().hand
                                if CurrentHand and CurrentHand.tool then
                                    local Meta = GameData.Utils.ItemMeta[CurrentHand.itemType]
                                    if not Meta or not Meta.breakBlock then
                                        task.wait()
                                        continue
                                    end
                                else
                                    task.wait()
                                    continue
                                end
                            end
                            
                            local Bed = GetNearestBed()
                            if Bed.Bed and NukerData.Settings.Distance >= Bed.Distance then
                                local BestSide = FindWeakestSide(Bed.Bed)
                                local Item = BestSide[#BestSide]
                                if Item then
                                    local ItemName = Item.Block.Name
                                    if table.find(CollectionService:GetTagged("bed"), Item.Block) then
                                        ItemName = "wood"
                                        Item.HitNormal = NukerData.Data.LastHitNormal
                                    else
                                        NukerData.Data.LastHitNormal = Item.HitNormal
                                    end
                                    
                                    local BestTool = GetBestItemToBreakBlock(ItemName)
                                    if BestTool.Item then
                                        SwitchItem(BestTool.Item, false)
                                    else
                                        if NukerData.Settings.AutoSwitch then
                                            BestTool = GetBestItemToBreakBlock("stone")
                                            if BestTool.Item then
                                                SwitchItem(BestTool.Item, false)
                                            end
                                        end
                                    end
                                    
                                    local Result = DamageBlock(Item.Block, NukerData.Data.LastHitNormal)
                                    if Result == "cancelled" then
                                        task.wait(0.15)
                                    end
                                    
                                    task.wait(0.05)
                                end
                            end
                            task.wait()
                        until not IsFeatureEnabled("NukerEnabled", "NukerKeybind")
                    end)
                end
            end
        })
        --
        NukerToggle:Keybind({
            Mode = "Toggle",
            Flag = "NukerKeybind",
            Callback = function() end
        })
        --
        NukerSection:Slider({
            Name = "",
            Min = 1,
            Max = 28,
            Default = 28,
            Decimal = 1,
            Ending = " studs",
            Flag = "NukerDistance",
            Callback = function(Value)
                NukerData.Settings.Distance = Value
            end
        })
        --
        NukerSection:Toggle({
            Name = "Hand check",
            Default = false,
            Flag = "NukerHandCheck",
            Callback = function(State)
                NukerData.Settings.HandCheck = State
            end
        })
    end
end
--
do -- PlayerList
        local PlayerSection = PlayerList:Section({Name = "Players", Fill = true})
        table.insert(NamedSections, PlayerSection)
        local PlayerAdjustments = PlayerList:Section({Name = "Adjustments", Fill = true, Side = "Right"})
        table.insert(NamedSections, PlayerAdjustments)
        --
        do -- Player Section
            ActualPlayerList = PlayerSection:List({Flag = "PlayerListCurrentPlayer", Size = 300})
            --
            PlayerSection:Button({Name = "View player", Callback = function()
                local Player = Players:FindFirstChild(Library.Flags["PlayerListCurrentPlayer"]:Get())
                --
                if Player then
                    Library:ViewPlayer(Player)
                end
            end})
            --
            task.spawn(function()
                for _, Player in Players:GetPlayers() do
                    ActualPlayerList:AddValue(Player.Name, {Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)})
                end
            end)
        end
	--
	do -- Adjustments
		PlayerAdjustments:Toggle({Name = "Whitelisted"})
	end
    end
    --
    do -- Configs
        local ConfigSection = Configs:Section({Name = "Configs", Fill = true})
        table.insert(NamedSections, ConfigSection)
        local LuaSection = Configs:Section({Name = "LUA", Side = "Right", Fill = true})
        table.insert(NamedSections, LuaSection)
        --
        do -- Configs
            local ConfigList = ConfigSection:List({Size = 200, Flag = "CurrentConfig"})
            --
            _G.ConfigListReference = ConfigList -- store reference globally
            
            task.spawn(function()
                Library:UpdateConfigList(ConfigList, "Add")
            end)
            --
            ConfigSection:Button({Name = "Update config", Callback = function()
                if Library.Flags["CurrentConfig"]:Get() then
                    writefile("gamesense/configs/" .. Library.Flags["CurrentConfig"]:Get() .. ".cfg", Library:GetConfig())
                end
            end})
            ConfigSection:Button({Name = "Load config", Callback = function()
                if Library.Flags["CurrentConfig"]:Get() then
                    Library:LoadConfig(readfile("gamesense/configs/" .. Library.Flags["CurrentConfig"]:Get() .. ".cfg"))
                end
            end})
            ConfigSection:TextBox({Flag = "ConfigName"})
            ConfigSection:Button({Name = "Create config", Callback = function()
                local ConfigName = Library.Flags["ConfigName"]:Get()
                --
                if Library.Flags["ConfigName"]:Get() ~= "" and not isfile("gamesense/configs/" .. ConfigName .. ".cfg") then
                    writefile("gamesense/configs/" .. ConfigName .. ".cfg", Library:GetConfig())
                    --
                    ConfigList:AddValue(ConfigName)
                end
            end})
            ConfigSection:Button({Name = "Refresh list", Callback = function()
                Library:UpdateConfigList(ConfigList, "Remove")
                Library:UpdateConfigList(ConfigList, "Add")
            end})
	end
	--
	do -- LUA
		LuaSection:List({Size = 75})
		--
		LuaSection:Button({Name = "Load script"})
		LuaSection:Button({Name = "Unload script"})
		LuaSection:Button({Name = "Refresh list"})
	end
end
--
do -- Lua
    local LuaSubSection, LuaSubSection2, LuaSubSection3, LuaSubSection4 = Lua:SubSection({Name = "Category", Options = {"rbxassetid://18334627891", "rbxassetid://18334630306", "rbxassetid://18334626899", "rbxassetid://18334625304"}})
    --
    LuaSubSection:Section({Fill = true})
    LuaSubSection:Section({Side = "Right", Fill = true})
    --
    LuaSubSection2:Section({Fill = true})
    LuaSubSection2:Section({Side = "Right", Fill = true})
    --
    LuaSubSection3:Section({Fill = true})
    LuaSubSection3:Section({Side = "Right", Fill = true})
    --
    LuaSubSection4:Section({Fill = true})
    LuaSubSection4:Section({Side = "Right", Fill = true})
end
--
do -- Connections
	Library:Connection(Players.PlayerAdded, function(Player)
		if not ActualPlayerList then return end
		--
		ActualPlayerList:AddValue(Player.Name, {Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)})
	end)
	--
	Library:Connection(Players.PlayerRemoving, function(Player)
		if not ActualPlayerList then return end
		--
		ActualPlayerList:AddValue(Player.Name, {Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)})
	end)
	--
	Library.UI.ToggleConnection = Library:Connection(UserInputService.InputBegan, function(Input, Processed)
		if Processed then return end
		if Input.KeyCode == Library.UI.CloseBind then
			Library:Toggle()
		end
	end)
end
--
local defaultConfigPath = "gamesense/configs/default.cfg"
if not isfile(defaultConfigPath) then
    if not isfolder("gamesense") then
        makefolder("gamesense")
    end
    if not isfolder("gamesense/configs") then
        makefolder("gamesense/configs")
    end
    
    local defaultConfig = [[{"JumpHeight":50,"SpeedMode":"Velocity","AuraWhitelistAttack":false,"ProjectileAuraMaxAngleEnabled":false,"SpeedKeybind":"Backspace","UnknownFlag309":false,"AtmosphereMode":"Blavish","LongJumpDirection":"Single Direction","NukerKeybind":"Backspace","AuraEnabled":true,"AuraAttackRange":30,"ProjectileAuraTargetSettings":true,"AuraSwingRangeToggle":false,"MenuSectionCalculate":true,"ConfigName":"","ProjectileAimbotRangeCircleColor":[0,0,1,0.7],"LongJumpSpeed":51,"ChestStealerUICheck":false,"AutoJumpKeybind":"Backspace","AuraWLSwingMultiBox":[],"AuraSwingTime":0,"RageWeaponTypeExtra":true,"AuraHardCounterRange":15,"AuraCustomAnimation":true,"SpeedConsumableBoost":true,"StorageESPScale":0.9,"FlyConsumableBoost":true,"StorageESPKeybind":"Backspace","UnknownFlag277":"","UnknownFlag308":false,"ProjectileAimbotKeybind":"Backspace","FlyMode":"Velocity","ProjectileAuraEnabled":true,"UnknownFlag316":false,"AuraTargetSettings":false,"UnknownFlag306":"","NametagsDistanceCheck":false,"UnknownFlag4":false,"ProjectileAuraLastStandHealth":70,"VelocityChance":100,"UnknownFlag6":false,"AuraMaxAngleEnabled":false,"UnknownFlag241":"LeftAlt","ProjectileAimbotDistance":100,"TexturePackKeybind":"Backspace","ProjectileAimbotEnabled":true,"CurrentConfig":"default","NukerHandCheck":false,"StaffDetectorParty":true,"FlyVerticalSpeed":80,"ProjectileAimbotRangeCircleFilled":false,"UnknownFlag3":false,"AutoQueueDelay":1,"VelocityEnabled":true,"AuraAnimationMode":"Smooth","AutoJumpEnabled":false,"ProjectileAuraLastStand":true,"AutoConsumeEnabled":true,"FOVValue":120,"ProjectileAimbotTargetPart":"HumanoidRootPart","UnknownFlag297":false,"SpeedWallCheck":true,"ChestStealerRange":20,"StaffDetectorClans":false,"LongJumpEnabled":"R","ProjectileAuraKeybind":"Backspace","NoFallEnabled":true,"AutoConsumeHealth":60,"MenuAutoScale":false,"NametagsKeybind":"Backspace","LongJumpConsumableBoost":true,"ProjectileAuraTargetMode":"Distance","VelocityHorizontal":0,"AuraMaxAngle":360,"StaffDetectorKeybind":"Backspace","SpeedAutoSprint":true,"SpeedValue":23,"FlyKeybind":"Q","AuraHardCounter":false,"StaffDetectorCustomClans":false,"SpeedEnabled":true,"ChestStealerEnabled":true,"NukerDistance":28,"SpeedDamageBoost":true,"FlyTpDownAntivoid":true,"AutoQueueEnabled":true,"StaffDetectorYouTubers":true,"NoFallKeybind":"Backspace","ProjectileAimbotFOVRadius":500,"AtmosphereEnabled":true,"ProjectileAuraMultiAura":false,"ProjectileAuraMaxAngle":360,"NametagsMaxDistance":100,"StaffDetectorPlayerName":"","FlyTpDown":true,"ChestStealerKeybind":"Backspace","SpeedAutoSprintKeybind":"Backspace","FOVKeybind":"Backspace","AuraNoSwing":false,"UnknownFlag5":true,"StaffDetectorPlayers":false,"AuraHardCounterTpDownFreezeTime":0.3,"ProjectileAuraTargetMultiBox":["Ignore NPCs","Ignore Behind Walls"],"ProjectileAimbotTargetSettings":false,"AuraWLAttackMultiBox":[],"ProjectileAuraShowProjectile":false,"LongJumpTime":2.5,"UnknownFlag311":false,"NukerEnabled":true,"ChestStealerDelay":0,"UnknownFlag310":false,"AuraHardCounterTPDown":false,"ProjectileAuraRange":40,"ProjectileAimbotTargetMultiBox":[],"UnknownFlag243":[0.6266666650772095,0.41999995708465578,0.6200000047683716,0],"ProjectileAimbotRangeCircle":false,"NametagsScale":0.9,"StaffDetectorClanName":"","AuraHardCounterKeybind":"Backspace","UnknownFlag301":"","StaffDetectorEnabled":true,"UnknownFlag249":100,"StaffDetectorSpectators":true,"ProjectileAimbotDistanceCheck":false,"FlySpeed":23,"TexturePackEnabled":true,"AuraTargetMode":"Distance","StorageESPItemName":"","TexturePackMode":"Cotton Candy","NametagsEnabled":true,"UnknownFlag268":"","AuraSwingRange":27,"FlyEnabled":"Q","FOVEnabled":true,"AuraHardCounterTPDownAntivoid":true,"LongJumpCameraDirection":false,"StorageESPEnabled":true,"AtmosphereKeybind":"Backspace","FlyWallCheck":true,"AuraKeybind":"Backspace","CustomJumpEnabled":false,"UnknownFlag314":false,"UnknownFlag296":"","StaffDetectorMode":"Disable All","UnknownFlag315":false,"UnknownFlag210":"","LongJumpKeybind":"R","ProjectileAimbotOtherProjectiles":true,"ProjectileAimbotSpeed":0.5,"RageWeaponType":{"Name":"Global","Value":true},"AutoConsumeKeybind":"Backspace","UnknownFlag313":false,"VelocityVertical":0,"FlyTpDownFreezeTime":0.3,"AuraWhitelistSwing":false,"AutoQueueKeybind":"Backspace","SpeedDamageBoostCooldown":0.8,"UnknownFlag317":false,"AuraHandCheck":false,"UnknownFlag312":false,"VelocityKeybind":"Backspace","ProjectileAuraDelay":0.1}]]
    writefile(defaultConfigPath, defaultConfig)
    
    if _G.ConfigListReference then
        Library:UpdateConfigList(_G.ConfigListReference, "Remove")
        Library:UpdateConfigList(_G.ConfigListReference, "Add")
    end
end

Library.UI.OnInitialized = function()
    task.wait(0.1)
    if Library.Flags["CurrentConfig"]:Get() then
        Library:LoadConfig(readfile("gamesense/configs/" .. Library.Flags["CurrentConfig"]:Get() .. ".cfg"))
    else
        if isfile(defaultConfigPath) then
            Library:LoadConfig(readfile(defaultConfigPath))
        end
    end
end

if queue_on_teleport then
    LocalPlayer.OnTeleport:Connect(function(State)
        if State == Enum.TeleportState.InProgress then
            queue_on_teleport([[
if not game:IsLoaded() then
    game.Loaded:Wait()
end
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
repeat
    task.wait()
until LocalPlayer
    and LocalPlayer.Character
    and LocalPlayer.Character:FindFirstChild("Humanoid")
    and LocalPlayer.Character.PrimaryPart

script_key = "]] .. script_key .. [["
loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/4deda013eaf169e1fb41e39611ab37f9.lua"))()
]])
        end
    end)
end

Library:Init()