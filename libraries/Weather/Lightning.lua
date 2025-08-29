local LightningBolt = loadfile('catrewrite/libraries/LightningLib/Bolt.lua')()
local LightningSparks = loadfile('catrewrite/libraries/LightningLib/Sparks/Init.lua')()

return {
	CreateLightning = function(pos: Vector3)
		local A1, A2 = {}, {}
		A1.WorldPosition, A1.WorldAxis = pos + Vector3.new(0, 100, 0), Vector3.new(0, -2, 0)
		A2.WorldPosition, A2.WorldAxis = pos, Vector3.new(0, -2, 0)

		local NewBolt = LightningBolt.new(A1, A2, 60)
		NewBolt.Enabled = true
		NewBolt.CurveSize0, NewBolt.CurveSize1 = 10, 15
		NewBolt.PulseSpeed = 5
		NewBolt.PulseLength = 1
		NewBolt.FadeLength = 0.25
		NewBolt.MaxRadius = 22
		NewBolt.Color = Color3.new(1, 1, 0)


		return LightningSparks.new(NewBolt)
	end
}