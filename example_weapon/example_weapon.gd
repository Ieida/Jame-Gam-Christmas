extends Weapon
class_name ExampleWeapon


@onready var animation_player := $AnimationPlayer


var is_swinging = false
func attack():
	if is_swinging: return
	is_swinging = true
	
	animation_player.queue("swing")


func swing_damage():
	for body in $Area3D.get_overlapping_bodies():
		if body is Hitbox:
			hit(body)


func swing_end():
	is_swinging = false
