extends CharacterBody2D

@onready var parent = get_parent()
@onready var sprite : Sprite2D = get_node("Sprite")

@export var run_bob_vertical_frequency := 2.0
@export var run_bob_height := 2.5

@export var run_bob_angular_frequency := 0.06
@export var run_bob_max_angle := 10.0

func set_body_velocity(input_direction, move_speed):
	velocity = input_direction * move_speed

func animate_move(delta, x_direction):
	sprite.update_run_bobbing(delta, velocity)
	sprite.update_rolling(delta, x_direction)

func move(input_direction, move_speed):
	set_body_velocity(input_direction, move_speed)
	move_and_slide()
