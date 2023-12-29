extends Node3D
class_name Weapon

signal hit_hitbox(hitbox: Hitbox)

@export var damage: Damage
@export var status_effects: Array[PackedScene]
@export var hurtbox: Hurtbox
var damage_exceptions: Array[Hitbox]
@export var hit_sfx: PackedScene

func add_damage_exception_with(hitbox: Hitbox):
	damage_exceptions.append(hitbox)

func remove_damage_exception_with(hitbox: Hitbox):
	damage_exceptions.erase(hitbox)

func clear_damage_exceptions():
	damage_exceptions.clear()

func add_status_effect(status_effect: PackedScene):
	status_effects.append(status_effect)

func remove_status_effect(status_effect: PackedScene):
	status_effects.erase(status_effect)

func clear_status_effects():
	status_effects.clear()


func attack():
	pass


func hit(hitbox: Hitbox):
	if damage_exceptions.has(hitbox): return
	
	# Apply damage and status effects.
	damage.apply(hitbox.health)
	for effect in status_effects:
		var se = effect.instantiate()
		hitbox.status_effect_manager.add_effect(se as StatusEffect)
		
	# Hit sound.
	var s = hit_sfx.instantiate()
	s.global_transform = hitbox.global_transform
	get_tree().root.add_child(s)
	
	hit_hitbox.emit(hitbox)
