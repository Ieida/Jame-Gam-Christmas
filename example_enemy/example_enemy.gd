extends Node3D


@export var health: Health
@onready var animation_player := $AnimationPlayer


func _ready():
	health.applied_damage.connect(_on_health_applied_damage)
	health.recieved_status.connect(_on_status_recieved)
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


var has_example_status = false
func example_status():
	if has_example_status: return
	has_example_status = true
	
	animation_player.queue("freeze")
