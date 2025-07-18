extends Sprite2D

@onready var parent_body : CharacterBody2D = get_parent()
@export var damage_animation_timer : Timer
@export var damage_flash_time := 1.0
var run_bob_time_increment := 0.0

func update_flip_sprite(global_x_position : int):
	if global_x_position > global_position.x:
		flip_h = false
	else:
		flip_h = true

func get_run_bob_position():
	var sprite_position = Vector2.ZERO
	sprite_position.y = sin(parent_body.run_bob_vertical_frequency * run_bob_time_increment) * parent_body.run_bob_height
	return sprite_position
	
func get_run_bob_rotation():
	var sprite_rotation = 0.0
	sprite_rotation = sin(parent_body.run_bob_angular_frequency * run_bob_time_increment) * deg_to_rad(parent_body.run_bob_max_angle)
	return sprite_rotation

func update_run_bobbing(delta, velocity):
	run_bob_time_increment += delta * velocity.length()
	if velocity.length() == 0:
		run_bob_time_increment = 0
	
	position = get_run_bob_position()
	rotation = get_run_bob_rotation()

func end_damaged_animation():
	modulate = Color(1, 1, 1)

func play_damaged_animation(damage_ratio : float):
	#flash sprite as a red shade related to damage_ratio
	#scale the damage_flash_time relative to damage_ratio
	damage_animation_timer.wait_time = damage_flash_time * damage_ratio
	damage_animation_timer.start()
	modulate = Color(1.1 - (1 * damage_ratio), 0, 0)
	await damage_animation_timer.timeout
	end_damaged_animation()
