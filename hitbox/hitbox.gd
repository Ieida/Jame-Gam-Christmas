extends Area3D
class_name Hitbox


@export var health: Health
@export var status_effect_manager: StatusEffectManager


func disable():
	set_collision_layer_value(5, false)


func enable():
	set_collision_layer_value(5, true)
