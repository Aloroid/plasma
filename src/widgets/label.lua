local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local useInstance = require(Package.Runtime.useInstance)
local create = require(Package.create)
local Style = require(Package.Style)
local automaticSize = require(Package.automaticSize)

--[=[
	@within Plasma
	@function label
	@param text string
	@tag widgets

	Text.
]=]
return widget(function(text: string)
	local refs = useInstance(function(ref)
		local style = Style.get()

		create("TextLabel", {
			[ref] = "label",
			BackgroundTransparency = 1,
			Font = style.font,
			TextColor3 = style.textColor,
			TextSize = 20,
			RichText = true,
		})

		automaticSize(ref.label)

		return ref.label
	end)

	refs.label.Text = text
end)
