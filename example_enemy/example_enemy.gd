extends Node3D


@export var health: Health
@onready var animation_player := $AnimationPlayer


func _ready():
	health.applied_damage.connect(_on_health_applied_damage)
	health.recieved_status.connect(_on_status_recieved)
	health.reached_zero.connect(_on_health_reached_zero)


func _on_health_applied_damage():
	animation_player.queue("hit")


func _on_health_reached_zero():
	animation_player.queue("crumble")
	$Hitbox.disable()


func _on_status_recieved(status: StatusEffect):
	status.apply(self)


func died():
	queue_free()


func example_status():
	animation_player.queue("freeze")
