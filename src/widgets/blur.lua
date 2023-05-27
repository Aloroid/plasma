--[=[
	@within Plasma
	@function blur
	@tag widgets
	@param size number -- The size of the blur

	A blur effect in the world. Created in Lighting.
]=]

local Lighting = game:GetService("Lighting")

local Package = script.Parent.Parent

local useInstance = require(Package.Runtime.useInstance)
local portal = require(script.Parent.portal)

return function(size: number)
	portal(Lighting, function()
		useInstance(function()
			local blur = Instance.new("BlurEffect")
			blur.Size = size
			return blur
		end)
	end)
end
