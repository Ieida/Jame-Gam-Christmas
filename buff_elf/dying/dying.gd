extends State

signal died

@export var animation_player: AnimationPlayer

func enable():
	super.enable()
	
	animation_player.play("die")
	await animation_player.animation_finished
	died.emit()
