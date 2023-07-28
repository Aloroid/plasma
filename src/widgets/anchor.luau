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

return widget(function(options: { position: UDim2?, size: UDim2?, anchorPoint: Vector2? }, fn: () -> ())
	local refs = useInstance(function(ref)
		return create("Frame", {
			[ref] = "anchor",

			BackgroundTransparency = 1,

			create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 10),
			}),
		})
	end)

	local anchor: Frame = refs.anchor

	useEffect(function()
		anchor.Position = options.position or UDim2.new()
		anchor.Size = options.size or UDim2.new()
		anchor.AnchorPoint = options.anchorPoint or Vector2.zero
	end, options.position, options.size, options.anchorPoint)

	scope(fn)
end)
