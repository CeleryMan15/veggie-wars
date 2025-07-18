extends Node

@export var sprite : Sprite2D
@export var health : Node2D
@export var guns : Node2D

var target : Node2D

@export_group("Weapons")
var guns_array : Array = []
var current_gun : Node2D

var animating_equip

func _ready():
	initialize_guns()

func initialize_guns():
	var i = 0
	for gun in guns.get_children():
		guns_array.append(gun)
		guns_array[i].hide()
		i += 1
		
	current_gun = guns_array[0]
	current_gun.show()
	
func equip_gun(gun_index):
	current_gun.hide()
	current_gun = guns_array[gun_index-1]
	current_gun.show()
	
	
func set_new_target(body):
	target = body

func _on_area_2d_body_entered(body: Node2D):
	if body.get_collision_layer() == 2:
		set_new_target(body)

func _physics_process(delta):
	if target != null:
		sprite.update_flip_sprite(target.global_position.x)
		current_gun.update_transform_status(delta, target.global_position, sprite.flip_h)
