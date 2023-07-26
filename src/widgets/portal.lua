--[=[
	@within Plasma
	@function portal
	@tag widgets
	@param targetInstance Instance -- Where the portal goes to
	@param children () -> () -- Children

	The portal widget creates its children inside the specified `targetInstance`. For example, you could use this
	to create lighting effects in Lighting as a widget:


	```lua
	return function(size)
		portal(Lighting, function()
			useInstance(function()
				local blur = Instance.new("BlurEffect")
				blur.Size = size
				return blur
			end)
		end)
	end
	```
]=]

local Package = script.Parent.Parent

local widget = require(Package.Runtime.widget)
local scope = require(Package.Runtime.scopeRuntime)
local useInstance = require(Package.Runtime.useInstance)

return widget(function(targetInstance: Instance, children: () -> ())
	useInstance(function()
		return nil, targetInstance
	end)

	scope(children)
end)
