--!nolint LocalShadow
local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local useInstance = require(Package.Runtime.useInstance)
local create = require(Package.create)
local Style = require(Package.Style)

--[=[
	@within Plasma
	@function heading
	@param text string
	@tag widgets

	Text, but bigger!
]=]
return widget(function(text: string)
	local refs = useInstance(function(ref)
		local style = Style.get()

		return create("TextLabel", {
			[ref] = "heading",
			BackgroundTransparency = 1,
			Font = style.headerFont,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextColor3 = style.mutedTextColor,
			TextSize = 20,
			RichText = true,
		})
	end)

	local instance = refs.heading
	instance.Text = text
end)
