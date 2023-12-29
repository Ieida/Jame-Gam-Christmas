extends Node
class_name Candy

signal amount_changed(_new_amount: float)

@export var amount: float = 0

func add_amount(amt: float):
	amount += amt
	amount_changed.emit(amount)

func stick_to(candy: Candy):
	candy.add_amount(amount)
