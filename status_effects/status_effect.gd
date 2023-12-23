extends Node
class_name StatusEffect


signal expired(effect: StatusEffect)


var reciever: Node
var manager: StatusEffectManager
@export var duration: float
var elapsed_time: float = 0


func _on_timer_timeout():
	expired.emit()


func _process(delta):
	elapsed_time += delta
	if elapsed_time >= duration:
		process_mode = Node.PROCESS_MODE_DISABLED
		expire()


func add_to(effect: StatusEffect):
	effect.duration += duration


func expire():
	expired.emit(self)


func init():
	pass
