--!nolint LocalShadow
--[=[
	@within Plasma
	@function checkbox
	@tag widgets
	@param label string -- The label for the checkbox
	@param options {disabled: boolean, checked: boolean}
	@return CheckboxWidgetHandle

	A checkbox. A checkbox may either be controlled or uncontrolled.

	By passing the `checked` field in `options`, you make the checkbox controlled. Controlling the checkbox means that
	the checked state is controlled by your code. Otherwise, the controlled state is controlled by the widget itself.

	Returns a widget handle, which has the fields:

	- `checked`, a function you can call to check if the checkbox is checked
	- `clicked`, a function you can call to check if the checkbox was clicked this frame

	![Checkboxes](https://i.eryn.io/2150/9Yg31gc8.png)

	```lua
	Plasma.window("Checkboxes", function()
		if Plasma.checkbox("Controlled checkbox", {
			checked = checked,
		}):clicked() then
			checked = not checked
		end

		Plasma.checkbox("Disabled checkbox", {
			checked = checked,
			disabled = true,
		})

		Plasma.checkbox("Uncontrolled checkbox")
	end)
	```
]=]

local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local useState = require(Package.Runtime.useState)
local useEffect = require(Package.Runtime.useEffect)
local useInstance = require(Package.Runtime.useInstance)
local create = require(Package.create)
local style = require(Package.Style)

type CheckboxOptions = {
	disabled: boolean?,
	checked: boolean?,
}

return widget(function(text: string, options: CheckboxOptions?)
	local options = options or {}

	local checked, setChecked = useState(false)
	local clicked, setClicked = useState(false)

	local refs = useInstance(function(ref)
		local style = style.get()
		local Checkbox = create("Frame", {
			[ref] = "checkbox",
			BackgroundTransparency = 1,
			Name = "Checkbox",
			Size = UDim2.new(0, 30, 0, 30),
			AutomaticSize = Enum.AutomaticSize.X,

			create("TextButton", {
				BackgroundColor3 = Color3.fromRGB(54, 54, 54),
				BorderSizePixel = 0,
				Font = Enum.Font.SourceSansBold,
				Size = UDim2.new(0, 30, 0, 30),
				TextColor3 = Color3.fromRGB(153, 153, 153),
				TextSize = 24,

				create("UICorner", {
					CornerRadius = UDim.new(0, 8),
				}),

				Activated = function()
					setClicked(true)
					setChecked(function(currentlyChecked)
						return not currentlyChecked
					end)
				end,
			}),

			create("TextLabel", {
				BackgroundColor3 = Color3.fromRGB(255, 255, 255),
				Font = style.font,
				TextColor3 = Color3.fromRGB(203, 203, 203),
				TextSize = 18,
				AutomaticSize = Enum.AutomaticSize.X,
				RichText = true,
			}),

			create("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				Padding = UDim.new(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
			}),
		})

		return Checkbox
	end)

	local instance = refs.checkbox

	instance.TextLabel.Text = text
	instance.TextButton.AutoButtonColor = not options.disabled

	useEffect(function()
		local isChecked
		if options.checked ~= nil then
			isChecked = options.checked
		else
			isChecked = checked
		end

		instance.TextButton.Text = isChecked and "✓" or ""
	end, options.checked, checked)

	useEffect(function()
		instance.TextButton.BackgroundColor3 = options.disabled and Color3.fromRGB(112, 112, 112)
			or Color3.fromRGB(54, 54, 54)
	end, options.disabled)

	local handle = {
		checked = function()
			if options.checked or checked then
				return true
			end

			return false
		end,
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
