local Package = script.Parent.Parent

local Types = require(Package.Types)

type Node = Types.Node

local function newNode(state: {}?): Node
	if state == nil then
		state = {}
	end

	return {
		instance = nil,
		containerInstance = nil,
		effects = {},
		states = {},
		children = {},
		generation = 0,
	}
end

return newNode
