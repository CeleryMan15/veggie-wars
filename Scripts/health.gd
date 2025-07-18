extends Node

@onready var parent : Node2D = get_parent()
@export var total_health := 100

var current_health := total_health

func die():
	parent.queue_free()

func take_damage(damage : float):
	current_health -= damage
	parent.sprite.play_damaged_animation(damage/total_health)
	if current_health <= 0:
		print("DIED")
		die()
