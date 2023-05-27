--[=[
	@within Plasma
	@function button
	@tag widgets
	@param label string -- The label for the checkbox
	@return ButtonWidgetHandle

	A text button.

	Returns a widget handle, which has the field:

	- `clicked`, a function you can call to check if the checkbox was clicked this frame

	![A button](https://i.eryn.io/2150/RobloxStudioBeta-iwRM0RMx.png)

	```lua
	Plasma.window("Button", function()
		if Plasma.button("button text"):clicked() then
			print("clicked!")
		end
	end)
	```
]=]

local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local useState = require(Package.Runtime.useState)
local useInstance = require(Package.Runtime.useInstance)
local Style = require(Package.Style)
local create = require(Package.create)

return widget(function(text: string)
	local clicked, setClicked = useState(false)
	local refs = useInstance(function(ref)
		local style = Style.get()

		return create("TextButton", {
			[ref] = "button",
			BackgroundColor3 = style.bg3,
			BorderSizePixel = 0,
			Font = Enum.Font.SourceSans,
			Size = UDim2.new(0, 100, 0, 40),
			TextColor3 = style.textColor,
			AutomaticSize = Enum.AutomaticSize.X,
			TextSize = 21,

			create("UIPadding", {
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10),
			}),

			create("UICorner"),

			Activated = function()
				setClicked(true)
			end,
		})
	end)

	local instance = refs.button

	instance.Text = text

	local handle = {
		clicked = function()
			if clicked then
				setClicked(false)
				return true
			end

			return false
		end,
	}

	return handle
end)
