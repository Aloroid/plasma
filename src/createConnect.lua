local Package = script.Parent

local useEventCallback = require(Package.Runtime.useEventCallback)

local function createConnect()
	local eventCallback = useEventCallback()

	return function(instance, eventName, handler)
		if eventCallback then
			return eventCallback(instance, eventName, handler)
		else
			return instance[eventName]:Connect(handler)
		end
	end
end

return createConnect
