extends Area2D

@onready var player = get_parent()
@onready var laser_hit_particles_scene = preload("res://Scenes/laser_hit_particles.tscn")

var damage := 0
var speed := 0
var travel_range := 0
var travelled_distance := 0

func move_laser(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta #Delta makes motion TIME dependent --> NOT frame dependent
	travelled_distance += speed * delta

func handle_laser_range():
	if travelled_distance > travel_range:
		queue_free()

func _physics_process(delta):
	move_laser(delta)
	handle_laser_range()
	
func spawn_laser_hit_particles():
	var laser_hit_particles_instance = laser_hit_particles_scene.instantiate()
	laser_hit_particles_instance.position = position
	laser_hit_particles_instance.rotation = rotation + PI
	player.add_child(laser_hit_particles_instance)
	laser_hit_particles_instance.emitting = true
	
func _on_body_entered(body: Node2D):
	if body.get_collision_layer() == 1:
		spawn_laser_hit_particles()
	elif body.get_collision_layer() == 8:
		body.get_parent().health.take_damage(damage)
	
	queue_free()
	
