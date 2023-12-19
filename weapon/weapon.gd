extends Node3D
class_name Weapon


@export var damage: Damage


func attack():
	pass


func hit(hitbox: Hitbox):
	hitbox.take(damage)
