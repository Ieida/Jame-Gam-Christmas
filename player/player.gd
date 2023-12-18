extends Node3D


@export var speed: float = 5
@export var sensitivity: float = 0.2
var look_input: Vector2 = Vector2.ZERO
@onready var camera := $CharacterBody3D/Camera3D
@onready var controller := $CharacterBody3D
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _input(event):
	if event is InputEventMouseMotion:
		look_input += event.relative


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta):
	# Mouse mode
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	look()


func _physics_process(delta):
	# Add gravity.
	if not controller.is_on_floor():
		controller.velocity.y -= gravity * delta
		
	move()


func look():
	var horizontal = -look_input.x * sensitivity
	var vertical = -look_input.y * sensitivity
	look_input = Vector2.ZERO
	camera.rotate_y(deg_to_rad(horizontal))
	camera.rotate_object_local(Vector3.RIGHT, deg_to_rad(vertical))


func move():
	var input_x = Input.get_axis("move_left", "move_right")
	var input_z = Input.get_axis("move_forward", "move_backward")
	var input_vector = (camera.global_basis.x * input_x + camera.global_basis.x.cross(controller.global_basis.y) * input_z).normalized()
	var movement = input_vector * speed
	movement.y = controller.velocity.y
	controller.velocity = movement
	controller.move_and_slide()
