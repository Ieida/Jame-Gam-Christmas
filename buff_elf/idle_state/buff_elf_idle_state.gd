extends State


@export var animation_player: AnimationPlayer
@export var raycast: RayCast3D
@export var target: Node3D
@export var chase_state: State


func _physics_process(delta):
	raycast.target_position = target.global_position - raycast.global_position
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		state_machine.change_state(chase_state)


func enable():
	super.enable()
	
	animation_player.play("idle")
