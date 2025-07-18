extends Node2D

@onready var character_body : CharacterBody2D = get_node("CharacterBody2D")
@export var sprite : Sprite2D
@export var health : Node2D
@export var guns : Node2D
@export var ui : Node2D
@export var dodge_roll_timer : Timer

@export_group("Moving")
@export var move_speed := 200
@export var roll_time := 0.25
var original_move_speed = move_speed
var input_direction := Vector2.ZERO
var look_direction := Vector2.ZERO

var roll_animation_timer : Timer
var can_move := true
var can_roll := true
var animating_roll := false

@export_group("Weapons")
@export var equip_animation_timer : Timer
var guns_array : Array = []
var current_gun : Node2D
var current_gun_index := 0

var animating_equip := false
var can_equip := true

func initialize_guns():
	var i = 0
	for gun in guns.get_children():
		guns_array.append(gun)
		guns_array[i].hide()
		i += 1
		
	current_gun = guns_array[0]
	equip_new_gun()
	
func _ready():
	initialize_guns()
	dodge_roll_timer.wait_time = roll_time

#Equipping
func _on_equip_animation_timer_timeout():
	current_gun.end_equip_animation()
	animating_equip = false
	can_equip = true
	current_gun.can_fire = true
	equip_animation_timer.stop()

func start_equip_animation():
	current_gun.can_fire = false
	animating_equip = true
	can_equip = false
	equip_animation_timer.wait_time = current_gun.equip_time	
	equip_animation_timer.start()

func equip_new_gun():
	current_gun.hide()
	current_gun = guns_array[current_gun_index]
	start_equip_animation()
	current_gun.show()
	
func equip_next_gun():
	if current_gun_index == guns_array.size() - 1:
		current_gun_index = 0
	else:
		current_gun_index += 1
	equip_new_gun()
		
func equip_previous_gun():
	if current_gun_index == 0:
		current_gun_index = guns_array.size() - 1
	else:
		current_gun_index -= 1
	equip_new_gun()

#Rolling
func set_roll_booleans(_animating_roll, _can_move, _can_roll):
	animating_roll = _animating_roll
	can_move = _can_move
	can_roll = _can_roll

func roll_body():
	move_speed *= 2
	if input_direction.length() == 0:
		input_direction = -1 * look_direction

func _on_dodge_roll_timer_timeout():
	set_roll_booleans(false, true, false)
	move_speed = original_move_speed
	sprite.roll_time_increment = 0
	dodge_roll_timer.stop()

func start_dodge_roll():
	ui.start_roll_cooldown()
	set_roll_booleans(true, false, false)
	roll_body()
	sprite.emit_roll_particles(input_direction.x)
	dodge_roll_timer.start()

#Input
func check_gun_autofire():
	if Input.is_action_pressed("Fire") and current_gun.autofire and current_gun.can_fire:
		current_gun.fire(look_direction)

func _input(event):
	if event.is_action_pressed("Roll") and can_roll:
		start_dodge_roll()
	elif event.is_action_pressed("Fire") and !current_gun.autofire and current_gun.can_fire:
		current_gun.fire(look_direction)
	
	if can_equip:
		if event.is_action_pressed("Equip0") and current_gun_index != 0:
			current_gun_index = 0
			equip_new_gun()
		elif event.is_action_pressed("Equip1") and current_gun_index != 1:
			current_gun_index = 1
			equip_new_gun()
		
		if event.is_action_pressed("EquipNext"):
			equip_next_gun()
				
		if event.is_action_pressed("EquipPrevious"):
			equip_previous_gun()
		
func get_move_velocity_input():
	look_direction = character_body.position.direction_to(get_global_mouse_position())
	if can_move:
		input_direction = Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	
func _physics_process(delta):
	var mouse_position = get_global_mouse_position()
	get_move_velocity_input()
	
	character_body.move(input_direction, move_speed)
	character_body.animate_move(delta, input_direction.x)
	
	sprite.update_flip_sprite(mouse_position.x)
	
	check_gun_autofire()
	current_gun.update_transform_status(delta, mouse_position, sprite.flip_h)
	current_gun.update_firing_status()
	
	ui.update_progress_bars()
