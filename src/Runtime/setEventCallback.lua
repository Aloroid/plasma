local Package = script.Parent.Parent

local Types = require(Package.Types)
local sharedState = require(Package.Runtime.sharedState)

local stack = sharedState.stack

type EventCallback = Types.EventCallback

local function setEventCallback(callback: EventCallback)
	stack[1].node.eventCallback = callback
end

return setEventCallback
