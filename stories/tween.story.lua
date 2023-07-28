local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Plasma = require(ReplicatedStorage.Plasma)

return function(target)
	local root = Plasma.new(target)

	local connection = RunService.Heartbeat:Connect(function()
		Plasma.start(root, function()
			local target, updateValue = Plasma.useState(0)
			local value, updateTarget =
				Plasma.useTween(0, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1, true, 1))

			Plasma.window("Button", function()
				if Plasma.button("tween"):clicked() then
					print(1 - target)
					updateTarget(math.abs(1 - target))
					updateValue(math.abs(1 - target))
				end
			end)

			Plasma.anchor({
				position = UDim2.fromScale(value, 0.5),
				size = UDim2.fromScale(0.1, 0.1),
				anchorPoint = Vector2.new(value),
			}, function()
				Plasma.label("hi")
				Plasma.label("hi")
				Plasma.label("hi")
				Plasma.label("hi")
			end)
		end)
	end)

	return function()
		connection:Disconnect()
		Plasma.start(root, function() end)
	end
end
