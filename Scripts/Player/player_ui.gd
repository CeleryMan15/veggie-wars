extends Node2D

@export var player : Node2D
@onready var roll_progress_bar : TextureProgressBar = get_node("RollCooldownProgressBar")
@onready var roll_cooldown_timer : Timer = get_node("RollCooldownTimer")

func start_roll_cooldown():
	roll_progress_bar.max_value = roll_cooldown_timer.wait_time
	roll_cooldown_timer.start()

func update_roll_progress_bar():
	roll_progress_bar.value = roll_cooldown_timer.time_left

func _on_roll_cooldown_timer_timeout():
	player.can_roll = true
	roll_cooldown_timer.stop()

func update_progress_bars():
	update_roll_progress_bar()
