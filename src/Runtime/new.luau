local Package = script.Parent.Parent

local Types = require(Package.Types)
local newNode = require(script.Parent.newNode)

type Node = Types.Node

--[=[
	@within Plasma
	@param rootInstance Instance -- The root instance of which to mount all children. Likely a ScreenGui.
	@return Node -- An opaque object which holds persistent state about your UI.
]=]
local function new(rootInstance: Instance): Node
	local node = newNode()
	node.instance = rootInstance
	return node
end

return new
