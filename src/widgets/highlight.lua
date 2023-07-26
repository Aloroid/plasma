--!nolint LocalShadow
local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local useEffect = require(Package.Runtime.useEffect)
local useInstance = require(Package.Runtime.useInstance)
local create = require(Package.create)

type HighlightOptions = {
	outlineColor: Color3?,
	fillColor: Color3?,
	fillTransparency: Color3?,
	outlineTransparency: Color3?,
	depthMode: Enum.HighlightDepthMode?,
}

--[=[
	@interface HighlightOptions
	@within Plasma

	.outlineColor?: Color3
	.fillColor?: Color3
	.fillTransparency?: number
	.outlineTransparency?: number
	.fillMode?: HighlightFillMode
]=]

--[=[
	@within Plasma
	@function highlight
	@param adornee Instance
	@param options? HighlightOptions


	Creates a highlight over an instance with the specified options, using the Roblox [Highlight] instance
]=]
return widget(function(adornee: PVInstance, options: HighlightOptions?)
	local options = options or {}

	local refs = useInstance(function(ref)
		return create("Highlight", {
			[ref] = "highlight",
		})
	end)

	refs.highlight.Adornee = adornee

	useEffect(function()
		refs.highlight.OutlineColor = options.outlineColor or Color3.new(1, 1, 1)
		refs.highlight.FillColor = options.fillColor or Color3.new(1, 0, 0)
	end, options.fillColor, options.outlineColor)

	refs.highlight.FillTransparency = options.fillTransparency or 0.5
	refs.highlight.OutlineTransparency = options.outlineTransparency or 0
	refs.highlight.DepthMode = options.depthMode or Enum.HighlightDepthMode.AlwaysOnTop
end)
