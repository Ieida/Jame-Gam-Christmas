extends Node

class_name State

var state_machine: StateMachine

func enable():
	process_mode = Node.PROCESS_MODE_INHERIT

func disable():
	process_mode = Node.PROCESS_MODE_DISABLED
