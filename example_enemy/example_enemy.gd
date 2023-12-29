extends Node3D


@export var health: Health
@onready var animation_player := $AnimationPlayer


func _ready():
	health.applied_damage.connect(_on_health_applied_damage)
	health.reached_zero.connect(_on_health_reached_zero)
	$Hitbox.health = health


func _on_health_applied_damage():
	animation_player.queue("hit")


func _on_health_reached_zero():
	animation_player.queue("crumble")
	$Hitbox.disable()


func _on_status_recieved(status: StatusEffect):
	status.apply(self)


func died():
	queue_free()


func freeze():
	animation_player.queue("freeze")
	print("freezing")


func unfreeze():
	animation_player.play_backwards("freeze")
	print("unfreezing")
