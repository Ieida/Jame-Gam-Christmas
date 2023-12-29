extends Node
class_name Damage


@export var amount: float = 0


func apply(to: Health):
	to.subtract(amount)
