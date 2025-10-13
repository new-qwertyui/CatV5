--!strict

--[[
Move script to:
	StarterCharacterScripts
	
Made by:
	@isPauI
	YT: @Paul1Rb


Updated: 10.07.2023 - 10:35 CET
Log:
	- Changed the Sway effect to work on CameraOffset because it caused the player to rotate on Y axis since they were in first person.
	
	- Changed line 65 [Cam.CameraType = Enum.CameraType.Scriptable] to .Custom
]]

local Settings : SettingsType = {
	--static
	BaseRot = 2.5, -- rotation speed
	SetRot = 0.4, -- rotation strenght
	BaseFreq = 15, -- view bobbing frequency
	SetFreq = 0.16, -- view bobbing strenght
	BaseMult = 12, -- base multiplier: less -> stronger effects
	BaseNumLerp = 0.25, -- lerp time value
	
	--sway settings
	SwayStrenght = 0.2, -- effect strenght
	BaseSway = 2.3, -- axis strenght
	SetSway = 0.5, -- axis multiplier
	CustomSwayZVal = -10, -- vector z value
	
	--drift min/max
	DriftMin = -3,
	DriftMax = 1,
	
	--fps
	Rate = 60,
	
	--blur
	MaxBlur = 6, -- max blur value
	BlurMult = 3, -- blur multiplier
}

type SettingsType = {
	BaseRot : number,
	SetRot : number,
	BaseFreq : number,
	SetFreq : number,
	BaseMult : number,
	BaseNumLerp: number,
	SwayStrenght : number,
	BaseSway : number,
	SetSway : number,
	CustomSwayZVal : number,
	DriftMin : number,
	DriftMax : number,
	Rate : number,
	MaxBlur : number,
	BlurMult : number,
}

local sway : CFrame
local MouseDelta : Vector2
local Vel,t,x,y : number

local sin = math.sin
local cos = math.cos
local rad = math.rad
local abs = math.abs
local sqrt = math.sqrt
local clamp = math.clamp
local round = math.round
local clock = os.clock

local CurrentVel = 0
local Drift = 0
local Limiter = 0

local RunServ = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local PlrServ = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LightingServ = game:GetService("Lighting")

local LocalPlr : Player = PlrServ.LocalPlayer

local Cam : Camera = Workspace.CurrentCamera
local BaseFov = Cam.FieldOfView

Cam.CameraType = Enum.CameraType.Custom
LocalPlr.CameraMode = Enum.CameraMode.LockFirstPerson

local char : Model = LocalPlr.Character or LocalPlr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid") :: Humanoid
local HRP = char:WaitForChild("HumanoidRootPart") :: BasePart

function NumLerp(num1: number, num2: number, rate: number) : number
	return num1 + (num2-num1)*rate
end

function CalculateCurve(Base : number, Set : number) : number
	return sin(clock() * Base) * Set
end

function GetVelMag() : number
	return round(Vector3.new(HRP.AssemblyLinearVelocity.X, HRP.AssemblyLinearVelocity.Y, HRP.AssemblyLinearVelocity.Z).Magnitude)
end

function GetMouseDrift(Drift : number, MouseDelta : Vector2, dt : number) : number
	return NumLerp(Drift, clamp(MouseDelta.X, Settings.DriftMin, Settings.DriftMax), (Settings.BaseMult * dt))
end

function GetSwayVal(x:number, y:number) : CFrame
	return CFrame.new(Vector3.new(x, y, 0), Vector3.new(x*.95, y*.95, Settings.CustomSwayZVal)) + Cam.CFrame.Position
end

local function setBlur() : BlurEffect
	local MotionBlur : BlurEffect = LightingServ:FindFirstChild("MotionBlur")
	
	if not MotionBlur then
		local newMotionBlur = Instance.new("BlurEffect")
		newMotionBlur.Size = 0
		newMotionBlur.Name = 'MotionBlur'
		newMotionBlur.Enabled = true
		newMotionBlur.Parent = LightingServ
		
		MotionBlur = newMotionBlur
	end
	
	return MotionBlur
end

local MotionBlur = setBlur()

function ConvCFrameToOrientation(_CFrame: CFrame)
	local setX, setY, setZ = _CFrame:ToOrientation()
	return Vector3.new(math.deg(setX), math.deg(setY), math.deg(setZ))
end

local function CameraUpdt(dt)
	Limiter += dt
	if Limiter >= 1/Settings.Rate then
		t = clock()
		MouseDelta = UIS:GetMouseDelta()
		
		Vel = NumLerp(CurrentVel, GetVelMag(), Settings.BaseNumLerp)
		
		x = cos(t * Settings.BaseSway) * Settings.SetSway
		y = sin(t * Settings.BaseSway) * Settings.SetSway 
		sway = GetSwayVal(x,y)
		
		Drift = GetMouseDrift(Drift, MouseDelta, dt)

		Cam.FieldOfView = BaseFov + sqrt(Vel)
		
		MotionBlur.Size = clamp(abs(Drift*Settings.BlurMult) --[[ & Vel with lower mult]], 0, Settings.MaxBlur)
		
		CurrentVel = Vel
		
		Cam.CFrame = Cam.CFrame--:Lerp(sway * Cam.CFrame.Rotation, Settings.SwayStrenght)
			* CFrame.new(0, CalculateCurve(Settings.BaseFreq, Settings.SetFreq) * Vel / Settings.BaseMult, 0)
			* CFrame.Angles(0, 0, rad(CalculateCurve(Settings.BaseRot, Settings.SetRot) * Vel / Settings.BaseMult) + rad(Drift))
		
		hum.CameraOffset = ConvCFrameToOrientation(sway)
		
		Limiter -= 1/Settings.Rate
	end
end

return {
    start = function()
        RunServ:BindToRenderStep("CamEffect", Enum.RenderPriority.Camera.Value, CameraUpdt)
    end,
    stop = function()
        RunServ:UnbindFromRenderStep("CamEffect")
        LocalPlr.CameraMode = Enum.CameraMode.Classic
    end
}
