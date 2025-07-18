extends "res://Scripts/character_animations.gd"

@export var roll_particles : GPUParticles2D
var roll_time_increment := 0.0
	
#func emit_directional_roll_particles(input_direction):
	#roll_particles.position = Vector2(global_position.x, global_position.y + 23)
	#roll_particles.rotation = input_direction.angle() + PI
	#roll_particles.emitting = true
	
func emit_roll_particles(x_direction):
	x_direction = round(x_direction)
	x_direction = 1 * pow(-1, float(flip_h)) if x_direction == 0 else x_direction #Case player moves directly up or down
	roll_particles.position = Vector2(global_position.x, global_position.y + 23)
	roll_particles.scale.x = x_direction * -1
	roll_particles.emitting = true
	
func update_rolling(delta, x_direction):
	x_direction = round(x_direction)
	x_direction = 1 * pow(-1, float(flip_h)) if x_direction == 0 else x_direction #Case player moves directly up or down
	if parent_body.parent.animating_roll:
		roll_time_increment += delta
		#rotation = deg_to_rad(360) * x_direction * (roll_time_increment/parent_body.parent.roll_time)
		rotation = lerp(0.0, deg_to_rad(360) * x_direction, roll_time_increment/parent_body.parent.roll_time)
