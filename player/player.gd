extends Node3D


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
@export_category("Weapon")
@export var weapon: Weapon


func _input(event):
	if event is InputEventMouseMotion:
		look_input += event.relative


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta):
	# Mouse mode
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	look(delta)
	
	# Attack.
	if Input.is_action_just_pressed("attack"):
		attack()


func _physics_process(delta):
	# Add gravity.
	if not controller.is_on_floor():
		controller.velocity.y -= gravity * delta
	
	move(delta)


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
	if new_input_vector: input_vector = new_input_vector
	
	# Acceleration and deceleration.
	var target_speed = base_speed if new_input_vector else 0.0
	var accel = acceleration if new_input_vector else deceleration
	speed = move_toward(speed, target_speed, (base_speed * accel) * delta)
	
	var movement = input_vector * speed
	movement.y = controller.velocity.y
	controller.velocity = movement
	controller.move_and_slide()
