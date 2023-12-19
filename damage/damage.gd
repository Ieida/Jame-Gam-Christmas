extends Resource
class_name Damage


signal hi


@export var amount: float = 0
@export var status_effect: StatusEffect


func apply(to: Health):
	to.apply(self)
