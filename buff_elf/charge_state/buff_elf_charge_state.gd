extends State


@export var animation_player: AnimationPlayer
@export var navigation_agent: NavigationAgent3D
@export var body: CharacterBody3D
@export var speed: float = 6
@export var recover: State
@export var hurtbox: Area3D
@export var hitbox: Hitbox
@export var damage: Damage
@export var status_effect: PackedScene
@export var footsteps: AudioStreamPlayer3D
@export var hit_sfx: PackedScene


func _ready():
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)


func _physics_process(delta):
	var position = navigation_agent.get_next_path_position()
	var direction = body.global_position.direction_to(position)
	var distance = body.global_position.distance_to(position)
	var movement = direction * speed
	
	body.velocity = movement
	body.move_and_slide()
	
	if speed * delta > distance:
		state_machine.change_state(recover)


func _on_hurtbox_area_entered(area: Area3D):
	if area == hitbox or process_mode == PROCESS_MODE_DISABLED or not get_tree():
		return
		
	if area is Hitbox:
		damage.apply(area.health)
		var se = status_effect.instantiate()
		area.status_effect_manager.add_effect(se)
		
		# Hit sound
		var s = hit_sfx.instantiate()
		s.global_transform = area.global_transform
		get_tree().root.add_child(s)


func enable():
	super.enable()
	
	animation_player.play("charge")
	footsteps.play()

func disable():
	super.disable()
	
	footsteps.stop()
