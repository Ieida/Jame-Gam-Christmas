extends State


@export var navigation_agent: NavigationAgent3D
@export var body: CharacterBody3D
@export var speed: float = 6
@export var recover_time: float = 2
@export var end_state: State
@export var hurtbox: Area3D
@export var hitbox: Hitbox
@export var damage: Damage
@export var status_effect: PackedScene


func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().physics_frame
	process_mode = Node.PROCESS_MODE_INHERIT
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)


func _physics_process(delta):
	var position = navigation_agent.get_next_path_position()
	var direction = body.global_position.direction_to(position)
	var distance = body.global_position.distance_to(position)
	var movement = direction * speed
	
	body.velocity = movement
	body.move_and_slide()
	
	if speed * delta > distance:
		process_mode = Node.PROCESS_MODE_DISABLED
		await get_tree().create_timer(recover_time).timeout
		state_machine.change_state(end_state)


func _on_hurtbox_area_entered(area: Area3D):
	if area == hitbox or process_mode == PROCESS_MODE_DISABLED:
		return
		
	if area is Hitbox:
		damage.apply(area.health)
		var se = status_effect.instantiate()
		area.status_effect_manager.add_effect(se)
