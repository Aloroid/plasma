local Package = script.Parent.Parent

local Types = require(Package.Types)
local sharedState = require(Package.Runtime.sharedState)

local stack = sharedState.stack

type EventCallback = Types.EventCallback

local function useEventCallback(): EventCallback?
	local frame = stack[1]

	if not frame then
		return nil
	end

	return frame.node.eventCallback
end

return useEventCallback