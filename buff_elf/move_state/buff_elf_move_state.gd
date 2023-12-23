extends State


@export var navigation_agent: NavigationAgent3D
@export var body: CharacterBody3D
@export var speed: float = 2
@export var target: Node3D
@export var charge_range = 10
@export var charge_state: State


func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	NavigationServer3D.map_changed.connect(_on_navigation_map_changed)
	navigation_agent.velocity_computed.connect(_on_velocity_computed)


func _on_navigation_map_changed(map: RID):
	if map == navigation_agent.get_navigation_map():
		process_mode = Node.PROCESS_MODE_INHERIT


func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return
	
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var new_velocity: Vector3 = body.global_position.direction_to(next_path_position) * speed
	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)


func _on_velocity_computed(safe_velocity: Vector3):
	body.velocity = safe_velocity
	body.move_and_slide()
	
	if navigation_agent.get_next_path_position().distance_to(navigation_agent.get_final_position()) < 1 and body.global_position.distance_to(target.global_position) <= charge_range:
		state_machine.change_state(charge_state)


func enable():
	super.enable()
	
	while process_mode != Node.PROCESS_MODE_DISABLED:
		set_movement_target(target.global_position)
		await get_tree().create_timer(0.5).timeout


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)
