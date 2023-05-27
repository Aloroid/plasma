local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local useEffect = require(Package.Runtime.useEffect)
local useInstance = require(Package.Runtime.useInstance)
local create = require(Package.create)

--[=[
	@within Plasma
	@function space
	@param size number

	Blank space of a certain size.

]=]
return widget(function(size: number)
	local refs = useInstance(function(ref)
		return create("Frame", {
			[ref] = "space",
			BackgroundTransparency = 1,
		})
	end)

	useEffect(function()
		refs.space.Size = UDim2.new(0, size, 0, size)
	end, size)
end)
