export type EventCallback = (Instance, string, (...any) -> ()) -> ()

export type Node = {
	instance: Instance?,
	refs: { [any]: Instance }?,
	containerInstance: Instance?,
	effects: {
		[TopoKey]: {
			lastDependencies: { any }?,
			lastDependenciesLength: number,
			destructor: (() -> ())?,
		},
	},
	states: { [TopoKey]: any },
	children: { [TopoKey]: Node },
	generation: number,
	eventCallback: EventCallback?,
}

export type TopoKey = string

export type StackFrame = {
	node: Node,
	contextValues: {
		[any]: any,
	},
	childrenCount: number,
	effectCounts: { [TopoKey]: number },
	stateCounts: { [TopoKey]: number },
	childCounts: { [TopoKey]: number },
	discriminator: (string | number)?,
}

return nil
