local Package = script.Parent.Parent

local Types = require(Package.Types)

type StackFrame = Types.StackFrame

return {

	stack = {} :: { StackFrame },
	recentErrors = {},
	recentErrorLastTime = 0,
}
