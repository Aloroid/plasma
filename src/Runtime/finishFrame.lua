local Package = script.Parent.Parent

local Types = require(Package.Types)
local destroyNode = require(Package.Runtime.destroyNode)

type Node = Types.Node

--[=[
	Finishes a continuable Plasma frame, cleaning up any objects that have been removed since the last frame.
	@within Plasma
	@param rootNode Node -- A node created by `Plasma.new`.
]=]
local function finishFrame(rootNode: Node)
	for childKey, childNode in pairs(rootNode.children) do
		if childNode.generation ~= rootNode.generation then
			destroyNode(childNode)
			rootNode.children[childKey] = nil
		end
	end
end

return finishFrame
