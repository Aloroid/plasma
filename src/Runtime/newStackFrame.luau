local Package = script.Parent.Parent

local Types = require(Package.Types)

type StackFrame = Types.StackFrame
type Node = Types.Node

local function newStackFrame(node: Node): StackFrame
	return {
		node = node,
		contextValues = {},
		childrenCount = 0,
		effectCounts = {},
		stateCounts = {},
		childCounts = {},
	}
end

return newStackFrame
