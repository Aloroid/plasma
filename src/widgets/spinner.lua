--[=[
	@within Plasma
	@function spinner
	@tag widgets

	A spinner widget, indicating loading.

	![A spinner](https://i.eryn.io/2150/RobloxStudioBeta-sEyci8qy.png)
]=]

local RunService = game:GetService("RunService")

local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local useEffect = require(Package.Runtime.useEffect)
local useInstance = require(Package.Runtime.useInstance)

return widget(function()
	local refs = useInstance(function(ref)
		local Frame = Instance.new("Frame")
		Frame.BackgroundTransparency = 1
		Frame.Size = UDim2.new(0, 100, 0, 100)

		local ImageLabel = Instance.new("ImageLabel")
		ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageLabel.BackgroundTransparency = 1
		ImageLabel.Image = "rbxassetid://2689141406"
		ImageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ImageLabel.Size = UDim2.new(0, 100, 0, 100)
		ImageLabel.Parent = Frame

		ref.frame = Frame

		return Frame
	end)

	useEffect(function()
		local connection = RunService.RenderStepped:Connect(function()
			refs.frame.ImageLabel.Rotation = os.clock() * 100 % 360
		end)

		return function()
			connection:Disconnect()
		end
	end)
end)
