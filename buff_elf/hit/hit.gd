extends State

@export var animation_player: AnimationPlayer
@export var idle: State

func enable():
	super.enable()
	
	animation_player.play("hit")
	await animation_player.animation_finished
	state_machine.change_state(idle)
