extends StatusEffect
class_name  FreezeStatusEffect


func _ready():
	if reciever.has_method("freeze"):
		reciever.freeze()


func expire():
	super.expire()
	if reciever.has_method("unfreeze"):
		reciever.unfreeze()
