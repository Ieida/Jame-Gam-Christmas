extends StatusEffect
class_name ExampleStatusEffect


func apply(to: Node):
	if to.has_method("example_status"):
		to.example_status()
