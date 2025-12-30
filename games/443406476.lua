local cloneref = cloneref or function(obj)
	return obj
end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local collectionService = cloneref(game:GetService('CollectionService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local starterGui = cloneref(game:GetService('StarterGui'))

local performanceStats = game:GetService('Stats'):FindFirstChild('PerformanceStats')

local isnetworkowner = not inputService.TouchEnabled and not table.find({'Velocity', 'Xeno', 'Volcano'}, ({identifyexecutor()})[1]) and isnetworkowner or function(base)
	if identifyexecutor() == 'Volcano' then
		local suc, res = pcall(isnetworkowner, base)
		return suc and res or false
	end
	return true
end

local gameCamera = workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local assetfunction = getcustomasset

local vape = shared.vape
local entitylib = vape.Libraries.entity
local targetinfo = vape.Libraries.targetinfo
local sessioninfo = vape.Libraries.sessioninfo
local uipallet = vape.Libraries.uipallet
local tween = vape.Libraries.tween
local color = vape.Libraries.color
local whitelist = vape.Libraries.whitelist
local prediction = vape.Libraries.prediction
local getfontsize = vape.Libraries.getfontsize
local getcustomasset = vape.Libraries.getcustomasset

local run = function(func)
	func()
end

local function notif(...)
	return vape:CreateNotification(...)
end

run(function()
    local function addEntity(ent)
        warn('added!')
        entitylib.addEntity(ent, nil, function()
            return true
        end)
    end

    for _, v in workspace.Baddies:GetChildren() do
        addEntity(v)
    end

    vape:Clean(workspace.Baddies.ChildAdded:Connect(addEntity))
    vape:Clean(workspace.Baddies.ChildRemoved:Connect(function(ent)
        entitylib.removeEntity(ent)
    end))
end)    