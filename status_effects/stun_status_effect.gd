extends StatusEffect
class_name StunStatusEffect


func _ready():
	if reciever.has_method("stun"):
		reciever.stun()


func expire():
	super.expire()
	if reciever.has_method("unstun"):
		reciever.unstun()
