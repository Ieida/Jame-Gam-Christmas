extends Node
class_name StatusEffectManager


signal effect_added(effect: StatusEffect)
signal effect_removed(effect: StatusEffect)


@export var reciever: Node
var effects = {}


func _on_effect_expired(effect: StatusEffect):
	effects.erase(effect.get_script())
	effect_removed.emit(effect)


func add_effect(effect: StatusEffect):
	if effects.has(effect.get_script()):
		effect.add_to(effects[effect.get_script()])
	else:
		effect.reciever = reciever
		effect.manager = self
		effects[effect.get_script()] = effect
		effect.expired.connect(_on_effect_expired)
		add_child(effect)
		effect_added.emit(effect)
