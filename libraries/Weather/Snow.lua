local snow = {}

function snow:Enable(yLevel)
	local partsFolder = Instance.new("Folder", workspace.CurrentCamera)
	partsFolder.Name = "SnowParts"

	local mainPart = Instance.new("Part")
	mainPart.Name = "SnowWeatherPart"
	mainPart.Size = Vector3.new(128, yLevel and yLevel - 10 or 50, 128)
	mainPart.Anchored = true
	mainPart.Transparency = 1
	mainPart.CanCollide = false

	local snowNotMoving = Instance.new("ParticleEmitter")
	snowNotMoving.Texture = "rbxassetid://178107563"
	snowNotMoving.Size = NumberSequence.new {
		NumberSequenceKeypoint.new(0, 0.213, 0),
		NumberSequenceKeypoint.new(1, 0.509, 0),
	}
	snowNotMoving.Transparency = NumberSequence.new {
		NumberSequenceKeypoint.new(0, 10, 0),
		NumberSequenceKeypoint.new(0.05, 0, 0),
		NumberSequenceKeypoint.new(0.7, 0, 0),
		NumberSequenceKeypoint.new(1, 10, 0),
	}
	snowNotMoving.Speed = NumberRange.new(1, 5)
	snowNotMoving.Lifetime = NumberRange.new(70, 80)
	snowNotMoving.Rate = 600
	snowNotMoving.EmissionDirection = Enum.NormalId.Bottom
	snowNotMoving.Parent = mainPart

	for x = -2048, 2048, 128 do
		for z = -2048, 2048, 128 do
			local clone = mainPart:Clone()
			clone.Position = Vector3.new(x, yLevel or 60, z)
			clone.Parent = partsFolder
		end
	end
end

function snow:Disable()
	local folder = workspace.CurrentCamera:FindFirstChild("SnowParts")
	if folder then
		folder:Destroy()
	end
end

return snow
