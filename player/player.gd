extends Node3D
class_name Player


@export_category("Movement")
@onready var controller := $CharacterBody3D
@export var gravity: float = 9.8 ## The gravity applied over time.
@export var base_speed: float = 5 ## The max speed.
var speed: float = 0
@export_range(0, 1) var acceleration: float = 0.5 ## The percentage of base_speed added over time until base_speed is reached.
@export_range(0, 1) var deceleration: float = 0.5 ## The percentage of base_speed subtracted over time until zero is reached.
var input_vector: Vector3 = Vector3.ZERO
@export_category("Looking")
@onready var camera := $CharacterBody3D/Camera3D
@export var sensitivity: float = 0.1 ## Mouse sensitivity. Multiplied by the mouse input.
@export var joystick_sensitivity: float = 0.1 ## Joystick sensitivity. Multiplied by the joystick input and delta.
var look_input: Vector2 = Vector2.ZERO
@export_category("Stats")
@export var health: Health
@export_category("Weapon")
@export var weapon: Weapon
@export var candy: Candy

@onready var hitbox: Hitbox = $CharacterBody3D/Hitbox
@onready var feet: Node3D = $CharacterBody3D/Feet
@onready var eyes: Node3D = $CharacterBody3D/Eyes
@onready var footsteps: AudioStreamPlayer3D = $CharacterBody3D/Feet/Footsteps


func _input(event):
	if event is InputEventMouseMotion:
		look_input += event.relative


func _ready():
	# Set up health.
	$CharacterBody3D/Hitbox.health = health
	health.applied_damage.connect(_on_health_applied_damage)
	health.reached_zero.connect(_on_health_reached_zero)
	
	# Capture mouse.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	# Set up health.
	hitbox.health = health
	
	# Set up weapon.
	call_deferred("setup_weapon")
	
	# Set up HUD.
	candy.amount_changed.connect(_on_candy_amount_changed)


func setup_weapon():
	weapon.add_damage_exception_with($CharacterBody3D/Hitbox)
	weapon.global_transform = camera.global_transform
	weapon.reparent(camera)
	weapon.hit_hitbox.connect(_on_weapon_hit_hitbox)


func _process(delta):
	look(delta)
	
	# Attack.
	if Input.is_action_just_pressed("attack"):
		attack()


func _physics_process(delta):
	# Add gravity.
	if not controller.is_on_floor():
		controller.velocity.y -= gravity * delta
	
	move(delta)


func _on_candy_amount_changed(new_amount: float):
	$HUD/CandyLabel.text = "CANDY: %s" % new_amount


func _on_health_applied_damage():
	print("player applied damage")


func _on_status_recieved(status: StatusEffect):
	print("player recieved status effect")
	status.apply(self)


func _on_health_reached_zero():
	print("player health reached zero")
	get_tree().paused = true
	get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")


func _on_weapon_hit_hitbox(hitbox: Hitbox):
	if hitbox is AnvilHitbox:
		var st_ef = hitbox.anvil.buy(candy)
		if st_ef:
			weapon.add_status_effect(st_ef)
	elif hitbox is CandyHitbox:
		hitbox.candy.stick_to(candy)


func replace_weapon(with: Weapon):
	if weapon:
		weapon.queue_free()
	
	weapon = with
	weapon.add_damage_exception_with($CharacterBody3D/Hitbox)
	weapon.global_transform = camera.global_transform
	camera.add_child(weapon)
	weapon.hit_hitbox.connect(_on_weapon_hit_hitbox)


func attack():
	weapon.attack()


func look(delta: float):
	var horizontal = -look_input.x * sensitivity
	var vertical = -look_input.y * sensitivity
	# Add joystick input.
	var joystick_input = Input.get_vector("look_right", "look_left", "look_down", "look_up")
	horizontal += joystick_input.x * joystick_sensitivity * delta
	vertical += joystick_input.y * joystick_sensitivity * delta
	
	look_input = Vector2.ZERO
	camera.rotate_y(deg_to_rad(horizontal))
	camera.rotate_object_local(Vector3.RIGHT, deg_to_rad(vertical))


func move(delta: float):
	var input_x = Input.get_axis("move_left", "move_right")
	var input_z = Input.get_axis("move_forward", "move_backward")
	var new_input_vector = (camera.global_basis.x * input_x + camera.global_basis.x.cross(controller.global_basis.y) * input_z).normalized()
	if new_input_vector:
		input_vector = new_input_vector
		if not footsteps.playing:
			footsteps.play()
	elif footsteps.playing:
		footsteps.stop()
	
	# Acceleration and deceleration.
	var target_speed = base_speed if new_input_vector else 0.0
	var accel = acceleration if new_input_vector else deceleration
	speed = move_toward(speed, target_speed, (base_speed * accel) * delta)
	
	var movement = input_vector * speed
	movement.y = controller.velocity.y
	controller.velocity = movement
	controller.move_and_slide()


func stun():
	process_mode = Node.PROCESS_MODE_DISABLED
	$HUD/StatusEffectLabel.text = "STUNNED!"
	$HUD/StatusEffectLabel.show()
	print("player stunned")
	if footsteps.playing: footsteps.stop()


func unstun():
	print("player unstunned")
	process_mode = Node.PROCESS_MODE_INHERIT
	$HUD/StatusEffectLabel.hide()
