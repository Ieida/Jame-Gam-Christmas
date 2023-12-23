extends State

@export var animation_player: AnimationPlayer
@export var idle: State

func enable():
	super.enable()
	
	print("recovering")
	animation_player.play("charge_recover")

func end():
	print("recovered")
	state_machine.change_state(idle)
