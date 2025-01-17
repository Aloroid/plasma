--[=[
	@within Plasma
	@function row
	@tag widgets
	@param options {padding: Vector2}
	@param children () -> () -- Children

	Lays out children horizontally
]=]

local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local scope = require(Package.Runtime.scopeRuntime)
local useInstance = require(Package.Runtime.useInstance)
local automaticSize = require(Package.automaticSize)

type RowOptions = {
	padding: Vector2?,
}

return widget(function(options, fn)
	if type(options) == "function" and fn == nil then
		fn = options
		options = {}
	end

	if options.padding then
		if type(options.padding) == "number" then
			options.padding = UDim.new(0, options.padding)
		end
	else
		options.padding = UDim.new(0, 10)
	end

	local refs = useInstance(function(ref)
		local Frame = Instance.new("Frame")
		Frame.BackgroundTransparency = 1

		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.Padding = options.padding
		UIListLayout.Parent = Frame

		ref.frame = Frame

		automaticSize(Frame)

		return Frame
	end)

	local frame = refs.frame

	frame.UIListLayout.HorizontalAlignment = options.alignment or Enum.HorizontalAlignment.Left

	scope(fn)
end) :: ((options: RowOptions?, children: () -> ()) -> ()) & ((children: () -> ()) -> ())
