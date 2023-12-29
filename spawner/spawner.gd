extends Node3D

@export var scene: PackedScene

func spawn():
	var s = scene.instantiate()
	add_child(s)
	s.global_transform = global_transform
