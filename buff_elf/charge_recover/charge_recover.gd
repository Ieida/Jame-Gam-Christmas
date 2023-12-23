extends State

@export var animation_player: AnimationPlayer
@export var idle: State

func enable():
	super.enable()
	
	animation_player.play("charge_recover")

func end():
	state_machine.change_state(idle)
