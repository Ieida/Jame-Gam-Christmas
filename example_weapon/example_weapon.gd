extends Weapon
class_name ExampleWeapon


@onready var animation_player := $AnimationPlayer


func _ready():
	animation_player.animation_finished.connect(_on_animation_finished)


func _on_animation_finished(anim_name: StringName):
	if anim_name == "swing":
		is_swinging = false


var is_swinging = false
func attack():
	if is_swinging: return
	is_swinging = true
	
	animation_player.play("swing")


func swing_damage():
	print(hurtbox.get_overlapping_areas())
	for area in hurtbox.get_overlapping_areas():
		if area is Hitbox:
			hit(area)


func swing_end():
	is_swinging = false
	animation_player.queue("idle")
