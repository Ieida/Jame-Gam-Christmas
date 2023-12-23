extends Node

class_name StateMachine

@export var states: Array[State]
@export var active_state: State

func _ready():
	for child in get_children():
		if child is State:
			states.append(child)
			child.state_machine = self
			child.disable()
	
	active_state.state_machine = self
	active_state.enable()

func change_state(state: State):
	if not states.has(state):
		states.append(state)
		state.state_machine = self
	
	active_state.disable()
	active_state = state
	active_state.enable()
