local Package = script.Parent.Parent

local Types = require(Package.Types)

type Node = Types.Node

local function destroyNode(node: Node)
	if node.instance ~= nil then
		node.instance:Destroy()
	end

	for _, effect in pairs(node.effects) do
		if effect.destructor ~= nil then
			effect.destructor()
		end
	end

	for _, child in pairs(node.children) do
		destroyNode(child)
	end
end

return destroyNode
