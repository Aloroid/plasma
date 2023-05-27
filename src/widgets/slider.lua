--!nolint LocalShadow
local UserInputService = game:GetService("UserInputService")

local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local useState = require(Package.Runtime.useState)
local useInstance = require(Package.Runtime.useInstance)
local createConnect = require(Package.createConnect)
local Style = require(Package.Style)
local create = require(Package.create)

type SliderOptions = {
	max: number?,
	min: number?,
	initial: number?,
}

return widget(function(options: SliderOptions | number)
	if type(options) == "number" then
		options = {
			max = options,
		}
	end
	local options = options :: SliderOptions

	local min = options.min or 0
	local max = options.max or 1
	local value, setValue = useState(options.initial or 0)

	local refs = useInstance(function(ref)
		local connect = createConnect()

		local style = Style.get()

		local connection

		local frame = create("Frame", {
			[ref] = "frame",
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 200, 0, 30),

			create("Frame", {
				Name = "line",
				Size = UDim2.new(1, 0, 0, 2),
				BackgroundColor3 = style.mutedTextColor,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0.5, 0),
			}),

			create("TextButton", {
				Name = "dot",
				[ref] = "dot",
				Size = UDim2.new(0, 15, 0, 15),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = style.textColor,
				Position = UDim2.new(0, 0, 0.5, 0),
				Text = "",

				create("UICorner", {
					CornerRadius = UDim.new(1, 0),
				}),

				InputBegan = function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end

					if connection then
						connection:Disconnect()
					end

					connection = connect(UserInputService, "InputChanged", function(moveInput)
						if moveInput.UserInputType ~= Enum.UserInputType.MouseMovement then
							return
						end

						local x = moveInput.Position.X

						local maxPos = ref.frame.AbsoluteSize.X - ref.dot.AbsoluteSize.X
						x -= ref.frame.AbsolutePosition.X + ref.dot.AbsoluteSize.X / 2
						x = math.clamp(x, 0, maxPos)

						local percent = x / maxPos

						setValue(percent * (max - min) + min)
					end)
				end,

				InputEnded = function(input)
					if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
						return
					end

					if connection then
						connection:Disconnect()
						connection = nil
					end
				end,
			}),
		})

		return frame
	end)

	local maxPos = refs.frame.AbsoluteSize.X - refs.frame.dot.AbsoluteSize.X
	local percent = (value - min) / (max - min)
	refs.frame.dot.Position = UDim2.new(0, percent * maxPos + refs.frame.dot.AbsoluteSize.X / 2, 0.5, 0)

	return value
end)
