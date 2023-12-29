extends State

@export var animation_player: AnimationPlayer
@export var idle: State
@export var health: Health

func _ready():
	health.reached_zero.connect(_on_health_reached_zero)

func _on_health_reached_zero():
	if process_mode == Node.PROCESS_MODE_DISABLED:
		return

func enable():
	super.enable()
	
	animation_player.play("hit")
	if health.amount <= 0:
		animation_player.queue("die")

func end():
	state_machine.change_state(idle)
