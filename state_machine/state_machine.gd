extends Node

class_name StateMachine

var states: Array[State]
@export var active_state: State

func _ready():
	for child in get_children():
		if child is State:
			child.state_machine = self
			if child == active_state:
				child.enable()
			else:
				child.disable()

func change_state(state: State):
	if not states.has(state):
		states.append(state)
		state.state_machine = self
	
	active_state.disable()
	active_state = state
	active_state.enable()
