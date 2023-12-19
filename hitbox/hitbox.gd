extends StaticBody3D
class_name Hitbox


@export var health: Health


func disable():
	set_collision_layer_value(5, false)


func enable():
	set_collision_layer_value(5, true)


func take(damage: Damage):
	health.apply(damage)
