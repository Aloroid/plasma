--!nolint LocalShadow
local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local useInstance = require(Package.Runtime.useInstance)
local create = require(Package.create)
local Style = require(Package.Style)

type HeaderOptions = {
	font: Enum.Font,
}

--[=[
	@within Plasma
	@function heading
	@param text string
	@param options? {font: Font}
	@tag widgets

	Text, but bigger!
]=]
return widget(function(text: string, options: HeaderOptions?)
	local options = options or {}
	local refs = useInstance(function(ref)
		local style = Style.get()

		return create("TextLabel", {
			[ref] = "heading",
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			AutomaticSize = Enum.AutomaticSize.XY,
			TextColor3 = style.mutedTextColor,
			TextSize = 20,
			RichText = true,
		})
	end)

	local instance = refs.heading
	instance.Text = text
	instance.Font = options.font or Enum.Font.GothamBold
end)
