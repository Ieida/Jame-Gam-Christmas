extends Node
class_name Health


@export var is_infinite = false
@export var amount: float = 0


signal applied_damage
signal reached_zero
func subtract(amt: float):
	amount -= amt
	applied_damage.emit()
	if is_infinite: return
	
	if amount <= 0:
		amount = 0
		
		reached_zero.emit()
