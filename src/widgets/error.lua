local Package = script.Parent.Parent

local useInstance = require(Package.Runtime.useInstance)
local create = require(Package.create)

return function(text)
	local refs = useInstance(function(ref)
		return create("Frame", {
			[ref] = "error",
			BackgroundTransparency = 0,
			BackgroundColor3 = Color3.fromRGB(231, 76, 60),
			Name = "Error",
			Size = UDim2.new(0, 100, 0, 75),
			AutomaticSize = Enum.AutomaticSize.XY,

			create("UIPadding", {
				PaddingBottom = UDim.new(0, 20),
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20),
				PaddingTop = UDim.new(0, 20),
			}),

			create("UIListLayout", {}),

			create("TextLabel", {
				Font = Enum.Font.GothamBold,
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 25,
				AutomaticSize = Enum.AutomaticSize.X,
				Text = "⚠️  An Error Occurred",
				Size = UDim2.fromOffset(0, 75),
			}),

			create("TextLabel", {
				Name = "error",
				Font = Enum.Font.GothamMedium,
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				TextSize = 20,
				LineHeight = 1.2,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.fromOffset(100, 75),
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			}),
		})
	end)

	local instance = refs.error

	instance.error.Text = text
end
