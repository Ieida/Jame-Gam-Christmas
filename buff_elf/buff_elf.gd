extends Node3D

@onready var health := $Health
@onready var state_machine := $StateMachine

func _ready():
	# Set up health.
	health.applied_damage.connect(_on_health_applied_damage)
	health.reached_zero.connect(_on_health_reached_zero)
	$CharacterBody3D/CandyHitbox.health = health
	$StateMachine/Dying.died.connect(_on_died)

func _on_died():
	queue_free()

func _on_health_applied_damage():
	if health.amount > 0:
		state_machine.change_state($StateMachine/Hit)

func _on_health_reached_zero():
	state_machine.change_state($StateMachine/Dying)

#region Status Effects
func freeze():
	state_machine.change_state($StateMachine/Frozen)

func unfreeze():
	state_machine.change_state($StateMachine/BuffElfIdleState)

func stun():
	state_machine.change_state($StateMachine/Stunned)

func unstun():
	state_machine.change_state($StateMachine/BuffElfIdleState)
#endregion
