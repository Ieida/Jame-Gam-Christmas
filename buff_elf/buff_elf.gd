extends Node3D


@export var health: Health
@onready var animation_player := $AnimationPlayer


func _ready():
	# Set up health.
	$CharacterBody3D/Hitbox.health = health
	health.applied_damage.connect(_on_health_applied_damage)
	health.reached_zero.connect(_on_health_reached_zero)


func _on_health_applied_damage():
	animation_player.play("hit")


func _on_health_reached_zero():
	animation_player.play("crumble")
	$Hitbox.disable()


func _on_status_recieved(status: StatusEffect):
	status.apply(self)
