extends Node2D

@export_group("References")
@export var character : Node2D
@export var laser_scene : PackedScene
@export var gun_sprite : Sprite2D
@export var cooldown_timer : Timer
@export var fire_point : Node2D
@export var hand_1_point : Node2D
@export var hand_2_point : Node2D
@export var hand_1 : Sprite2D
@export var hand_2 : Sprite2D

@export_group("Stats")
@export var autofire := false
@export var laser_speed := 1000
@export var laser_range := 1200
@export var recoil_amplitude := 10
@export var damage := 10
@export var equip_time := 0.4

var equip_time_increment := 0.0

var can_fire := true
var is_firing := false

func relocate_hands():
	hand_1.reparent(hand_1_point)
	hand_2.reparent(hand_2_point)
	hand_1.position = Vector2.ZERO
	hand_2.position = Vector2.ZERO
	hand_1.rotation = 0
	hand_2.rotation = 0

func end_equip_animation():
	equip_time_increment = 0
	gun_sprite.rotation = 0
	gun_sprite.position.x -= 5
	relocate_hands()
	gun_sprite.modulate.a = 1.0
	gun_sprite.modulate.r = 1.0
	gun_sprite.modulate.b = 1.0
	gun_sprite.modulate.g = 1.0

func update_equip_animation(delta, flipped):
	if character.animating_equip:
		equip_time_increment += delta
		#gun_sprite.rotation = deg_to_rad(360) * -1 * (equip_time_increment/equip_time)
		gun_sprite.modulate.a = lerp(0.0, 1.0, equip_time_increment/equip_time)
		gun_sprite.modulate.g = lerp(16.0, 1.0, equip_time_increment/equip_time)
		gun_sprite.modulate.b = lerp(36.0, 1.0, equip_time_increment/equip_time)
		gun_sprite.rotation = lerp(0.0, deg_to_rad(360) * -1, equip_time_increment/equip_time) #A + (B-A) * t

func update_aim(target_position : Vector2, flipped):
	look_at(target_position)
	scale.y = pow(-1, float(flipped))

func spawn_laser():
	var laser_instance = laser_scene.instantiate()
	laser_instance.position = fire_point.global_position
	laser_instance.rotation = rotation
	laser_instance.speed = laser_speed
	laser_instance.travel_range = laser_range
	laser_instance.damage = damage
	character.add_child(laser_instance)

func update_recoil(delta):
	gun_sprite.position.x = lerp(gun_sprite.position.x, position.x + 22.0, 10 * delta)

func initiate_recoil(look_direction):
	gun_sprite.position.x -= look_direction.length() * recoil_amplitude

func fire(look_direction):
	cooldown_timer.start()
	is_firing = true #Need this for only firing 
	can_fire = false #Need this for when not firing, but cannot fire
	spawn_laser()
	initiate_recoil(look_direction)

func _on_fire_cooldown_timer_timeout():
	is_firing = false

func update_firing_status():
	if !is_firing and !character.animating_equip:
		can_fire = true

func update_transform_status(delta, target_position, flipped):
	update_equip_animation(delta, flipped)
	update_aim(target_position, flipped)
	update_recoil(delta)
