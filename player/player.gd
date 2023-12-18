extends Node3D


@export_category("Movement")
@onready var controller := $CharacterBody3D
@export var gravity:float = 9.8
@export var base_speed: float = 5
var speed: float = 0
@export_range(0, 1) var acceleration: float = 0.5
@export_range(0, 1) var deceleration: float = 0.5
var input_vector: Vector3 = Vector3.ZERO
@export_category("Looking")
@onready var camera := $CharacterBody3D/Camera3D
@export var sensitivity: float = 0.1
@export var joystick_sensitivity: float = 0.1
var look_input: Vector2 = Vector2.ZERO


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


func _physics_process(delta):
	# Add gravity.
	if not controller.is_on_floor():
		controller.velocity.y -= gravity * delta
	
	move(delta)


func look(delta: float):
	var horizontal = -look_input.x * sensitivity
	horizontal += Input.get_axis("look_right", "look_left") * joystick_sensitivity * delta
	var vertical = -look_input.y * sensitivity
	vertical += Input.get_axis("look_up", "look_down") * joystick_sensitivity * delta
	look_input = Vector2.ZERO
	camera.rotate_y(deg_to_rad(horizontal))
	camera.rotate_object_local(Vector3.RIGHT, deg_to_rad(vertical))


func move(delta: float):
	var input_x = Input.get_axis("move_left", "move_right")
	var input_z = Input.get_axis("move_forward", "move_backward")
	var new_input_vector = (camera.global_basis.x * input_x + camera.global_basis.x.cross(controller.global_basis.y) * input_z).normalized()
	if new_input_vector: input_vector = new_input_vector
	
	# Acceleration.
	var target_speed = base_speed if new_input_vector else 0
	var accel = acceleration if new_input_vector else deceleration
	speed = move_toward(speed, target_speed, (base_speed * accel) * delta)
	
	# Deceleration.
	
	var movement = input_vector * speed
	movement.y = controller.velocity.y
	controller.velocity = movement
	controller.move_and_slide()
