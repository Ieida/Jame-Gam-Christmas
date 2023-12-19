extends Resource
class_name Health


@export var is_infinite = false
@export var amount: float = 0


signal applied_damage()
signal recieved_status(status: StatusEffect)
signal reached_zero
func apply(damage: Damage):
	amount -= damage.amount
	applied_damage.emit()
	recieved_status.emit(damage.status_effect)
	if is_infinite: return
	
	if amount <= 0:
		amount = 0
		
		reached_zero.emit()
