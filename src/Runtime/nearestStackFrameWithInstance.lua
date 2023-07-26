local Package = script.Parent.Parent

local Types = require(Package.Types)
local sharedState = require(script.Parent.sharedState)

local stack = sharedState.stack

type StackFrame = Types.StackFrame

local function nearestStackFrameWithInstance(): StackFrame?
	for i = #stack - 1, 1, -1 do
		local frame = stack[i]

		if frame.node.containerInstance ~= nil or frame.node.instance ~= nil then
			return frame
		end
	end

	return nil
end

return nearestStackFrameWithInstance
