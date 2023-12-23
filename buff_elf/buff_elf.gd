extends Node3D


@onready var health := $Health
@onready var animation_player := $AnimationPlayer
@onready var state_machine := $StateMachine


func _ready():
	# Set up health.
	health.applied_damage.connect(_on_health_applied_damage)
	health.reached_zero.connect(_on_health_reached_zero)
	$CharacterBody3D/Hitbox.health = health
	$StateMachine/Dying.died.connect(_on_died)


func _on_died():
	queue_free()


func _on_health_applied_damage():
	state_machine.change_state($StateMachine/Hit)


func _on_health_reached_zero():
	state_machine.change_state($StateMachine/Dying)
