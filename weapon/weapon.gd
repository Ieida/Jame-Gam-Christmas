extends Node3D
class_name Weapon


@export var damage: Damage
@export var status_effect: PackedScene
@export var hurtbox: Hurtbox
var damage_exceptions: Array[Hitbox]


func add_damage_exception_with(hitbox: Hitbox):
	damage_exceptions.append(hitbox)


func remove_damage_exception_with(hitbox: Hitbox):
	damage_exceptions.erase(hitbox)


func clear_damage_exceptions():
	damage_exceptions.clear()


func attack():
	pass


func hit(hitbox: Hitbox):
	if damage_exceptions.has(hitbox): return
	
	damage.apply(hitbox.health)
	var se = status_effect.instantiate()
	hitbox.status_effect_manager.add_effect(se as StatusEffect)
