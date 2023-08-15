--[=[
	@within Plasma
	@function anchor
	@tag widgets
	@param options {position: UDim2, size: UDim2, anchorPoint: Vector2} -- The options for the anchor
	@param children () -> () -- Children

	A element which can be used to position other ui elements

]=]

local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local useEffect = require(Package.Runtime.useEffect)
local useInstance = require(Package.Runtime.useInstance)
local scope = require(Package.Runtime.scopeRuntime)
local create = require(Package.create)

type AnchorOptions = {

	position: UDim2?,
	size: UDim2?,
	anchorPoint: Vector2?,

	horizontalAlignment: Enum.HorizontalAlignment?,
	verticalAlignment: Enum.VerticalAlignment?,
	fillDirection: Enum.FillDirection?,
}

return widget(function(options: AnchorOptions, fn: () -> ())
	local refs = useInstance(function(ref)
		return create("Frame", {
			[ref] = "anchor",

			BackgroundTransparency = 1,

			create("UIListLayout", {
				[ref] = "list",
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 4),
			}),
		})
	end)

	local anchor: Frame = refs.anchor
	local list: UIListLayout = refs.list

	useEffect(function()
		anchor.Position = options.position or UDim2.new()
		anchor.Size = options.size or UDim2.new(1, 0, 1, 0)
		anchor.AnchorPoint = options.anchorPoint or Vector2.zero
	end, options.position, options.size, options.anchorPoint)

	useEffect(function()
		list.HorizontalAlignment = options.horizontalAlignment or Enum.HorizontalAlignment.Left
		list.VerticalAlignment = options.verticalAlignment or Enum.VerticalAlignment.Top
		list.FillDirection = options.fillDirection or Enum.FillDirection.Vertical
	end, options.horizontalAlignment, options.verticalAlignment, options.fillDirection)

	scope(fn)
end)
