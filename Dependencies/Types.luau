export type StateObject = {
	Changed : BindableEvent;
	Value : any;
	
	new : (initialValue : any) -> State;
	Set : (self : State, newValue : any) -> nil;
	Get : (self : State) -> any;
	BindTo : (iself : State, instance: VuxelUIInstance, property: string) -> nil;
}
export type State = typeof(
	setmetatable(
		{} :: StateObject, 
		{__index = {} :: StateObject}
	)
)

export type ScreenGuiInstance = ScreenGui & {
	[string]: any
}

export type VuxelUIInstances = Frame & ScreenGui & TextButton & TextBox & TextLabel
export type VuxelUIInstance = VuxelUIInstances & {
	[string] : any; -- this shouldnt give the same type check warning but it does
}
-- uhm, then there is no fix :)
return {}