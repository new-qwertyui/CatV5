local vape = vape
local GuiLibrary = vape.gui
local cloneref = cloneref or function(...) return (...) end
local players = cloneref(game.GetService(game, 'Players'))
local textservice = cloneref(game.GetService(game, 'TextService'))
local lighting = cloneref(game.GetService(game, 'Lighting'))
local textchat = cloneref(game.GetService(game, 'TextChatService'))
local inputservice = cloneref(game.GetService(game, 'UserInputService'))
local runservice = cloneref(game.GetService(game, 'RunService'))
local runService = runservice
local tweenservice = cloneref(game.GetService(game, 'TweenService'))
local collection = cloneref(game.GetService(game, 'CollectionService'))
local replicatedstorage = cloneref(game.GetService(game, 'ReplicatedStorage'))
local vapeconnections = {}
local camera = workspace.CurrentCamera or Instance.new('Camera', workspace)
local lplr = players.LocalPlayer
local vapeInjected = true

table.insert(vapeconnections, workspace:GetPropertyChangedSignal('CurrentCamera'):Connect(function()
	camera = workspace.CurrentCamera or Instance.new('Camera', workspace)
end))

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = runService.RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = runService.Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = runService.Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

local getTarget = function(range)
    for i,v in players:GetPlayers() do
        if v ~= lplr and isAlive(v) then
          --print('yes')
            local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
            --print('checking mag ', mag)
            if mag < (range or math.huge) then
                return v
            end
        end
    end
    return nil
end

local getAllTargets = function(range)
    local ents = {}
    for i,v in players:GetPlayers() do
        if v ~= lplr and isAlive(v) then
            local mag = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
            --print('checking mag & no error')
            if mag < (range or math.huge) then
                table.insert(ents, v)
            end
        end
    end
    return ents
end

local store = {
	AttackRemote = replicatedstorage:WaitForChild("meleeEvent"),
	Remotes = workspace:WaitForChild("Remote"),
	SwitchTeam = workspace.Remote:WaitForChild("TeamEvent"),
	ShootGun = replicatedstorage:WaitForChild("ShootEvent"),
	Guns = {
	    M9 = 10,
	    ['Remington 870'] = 15,
	    ['AK-47'] = 30,
	    ['M431'] = 35
	}
}
store["getGunDamage"] = function(w)
	local dmg = 0
	for i,v in store.Guns do
		if v > dmg then
			dmg = v
		end
	end
	return dmg
end

store["getAllItems"] = function(onlyequipped)
    local items = {}
    if not onlyequipped then
        for i,v in lplr.Backpack:GetChildren() do
            table.insert(items, v)
        end
    end
    if isAlive() then
        for i,v in lplr.Character:GetChildren() do
            if v.ClassName == 'Tool' then
                table.insert(items, v)
            end
        end
    end
    return items
end

store["getBestWeapon"] = function()
    local weapon = nil
    local damage = 0
    for i,v in store.getAllItems(true) do
        if v:FindFirstChild('GunStates') and store.getGunDamage(v.Name) > damage then
            damage = store.getGunDamage(v.Name)
            weapon = v
        end
    end
    return weapon
end

GuiLibrary.RemoveObject("KillauraOptionsButton")
run(function()
    local killaura = {}
    local killaurarange = {}
    local killauramode = {}
    local killauranoanimation = {}
    local killaurabox = {}
    local killauraboxcolor = Color3.fromHSV(0, 0, 0)
    local killauramodes = {
        Single = function()
            return getTarget(killaurarange.Value)
        end,
        Multi = function()
            return getAllTargets(killaurarange.Value)
        end
    }
    local attackent = function(ent)
        if not killaura.Enabled then return end
        local root = ent.Character.HumanoidRootPart
            local weapon = getBestWeapon()
            if weapon then
	            store.ShootGun:FireServer({
	                [1] = {
	                    RayObject = Ray.new(camera.CFrame.Position, root.CFrame.Position).Unit.Direction,
	                    Distance = 10,
	                    Cframe = root.CFrame,
	                    Hit = root
	                },
	                [2] = weapon
	            })
            else
                store.AttackRemote:FireServer(ent)
            end
            vapeTargetInfo.Targets.Killaura = {
                Humanoid = {
                    Health = ent.Character.Humanoid.Health,
                    MaxHealth = ent.Character.Humanoid.MaxHealth
                },
                Player = ent
            }
    end
    local kabox
    killaura = vape.windows.blatant.CreateOptionsButton({
        Name = 'Killaura', 
        Function = function(call)
            if call then
                kabox = Instance.new('Part', workspace)
                kabox.Anchored = true
                kabox.Transparency = 0.4
                kabox.Material = Enum.Material.Neon
                kabox.CanCollide = false
                kabox.Size = Vector3.new(3, 6, 3)
                kabox.Color = Color3.fromHSV(killauraboxcolor.Hue, killauraboxcolor.Sat, killauraboxcolor.Value)
                table.insert(killaura.Connections, runservice.Stepped:Connect(function()
                    if kabox and killaurabox.Enabled then
                        local ent = getTarget(killaurarange.Value)
                        if ent then
                            kabox.Parent = ent.Character
                            kabox.CFrame = ent.Character.HumanoidRootPart.CFrame
                        end
                    end
                end))
                RunLoops:BindToHeartbeat("aura", function()
                    local ent = killauramodes[killauramode.Value]()
                    if type(ent) == 'table' then
                        for i, plr in ent do
                            task.spawn(pcall, attackent, plr)
                        end
                    else
                        task.spawn(pcall, attackent, ent)
                    end
                end)
            else
                -- lol
                kabox:Destroy()
                kabox = nil
                RunLoops:UnbindFromHeartbeat("aura")
            end
        end,
        ExtraText = function()
            return 'Switch'
        end
    })
    killaurarange = killaura.CreateSlider({
        Name = 'Range',
        Min = 1,
        Max = 16,
        Default = 16,
        Function = void
    })
    killauramode = killaura.CreateDropdown({
        Name = 'Mode',
        List = {'Single', 'Multi'},
        Function = void
    })
    killaurabox = killaura.CreateToggle({
        Name = 'Box',
        Function = function(call)
            killauraboxcolor.Object.Visible = call
        end
    })
    killauraboxcolor = killaura.CreateColorSlider({
        Name = 'Color',
        Function = function(h, s, v)
            if kabox then
                kabox.Color = Color3.fromHSV(h, s, v)
            end
        end
    })
    killauraboxcolor.Object.Visible = false
end)

run(function()
	local InstantRespawn = {}
	local backpack = {}
	local guns = { -- doesnt have the tools :(
		["Remington 870"] = 1,
		M9 = 2,
		M4A1 = 3,
		["AK-41"] = 4
	}
	local items = {
		["Crude Knife"] = 1,
		Hammer = 2
	}
	local pos
	
	local function getItem(item)
		local thing = nil
		if guns[item] ~= nil then
			thing = workspace.Prison_ITEMS.giver[item]
			--genre = "giver"
		elseif items[item] ~= nil then
			thing = replicatedstorage.Tools[item]
			--genre = "Tools"
		end
		print(thing)
		return thing
	end
	
	InstantRespawn = vape.windows.utility.CreateOptionsButton({
		Name = "RespawnGodmode",
		Function = function(callback)
			if callback then
				repeat
					--print("yea")
					pcall(function()
						if lplr.Character.Humanoid.Health < 1 then
							store.SwitchTeam:FireServer(tostring(lplr.TeamColor))
							task.wait(0.25)
							lplr.Character.HumanoidRootPart.CFrame = pos
							for i,v in backpack do
								print(v)
								local item = getItem(v)
								print(item)
								local newItem = item:Clone()
								newItem.Parent = lplr.Backpack
							end
							print("respawn")
						else
							pos = lplr.Character.HumanoidRootPart.CFrame
							for i,v in lplr.Backpack:GetChildren() do
								backpack[i] = v.Name
							end
						end
					end)
					task.wait()
				until (not InstantRespawn.Enabled)
			end
		end
	})
end)

run(function()
	local noslow = {}
	
	noslow = vape.windows.blatant.CreateOptionsButton({
		Name = "NoSlowdown",
		Function = function(callback)
			if callback then
				RunLoops:BindToHeartbeat("ns", function()
					if lplr.Character.Humanoid.WalkSpeed < 16 then
						lplr.Character.Humanoid.WalkSpeed = 16
					end
				end)
			else
				RunLoops:UnbindFromHeartbeat("ns")
			end
		end,
		ExtraText = function() return "Spoof" end
	})
end)
