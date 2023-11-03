extends Node2D

var direction := "horizontal"
var state := "closed"

var obstructed := false
var locked := false

@onready var walkway : StaticBody2D = $Hitbox/StaticBody2DWalkway
@onready var hitbox : Control = $Hitbox
@onready var walkway_light : LightOccluder2D = $Hitbox/WalkwayOccluder

var collision_layer = 1;
var occluder_light_mask = 1;

func _ready() -> void:
	if direction == "vertical":
		hitbox.rotation_degrees = 90;
		
	update_sprites()

func update_sprites():
	get_node("AnimatedSprite2D").set_animation(state + "_" + direction)

func open():
	if locked:
		return
	state = "open"
	walkway.set_collision_layer_value(collision_layer, false)
	walkway_light.occluder_light_mask = 0;
	update_sprites()
	
func close():
	if obstructed:
		return
	state = "closed"
	walkway.set_collision_layer_value(collision_layer, true)
	walkway_light.occluder_light_mask = occluder_light_mask;
	update_sprites()

func _on_button_pressed() -> void:
	if state == "open":
		close()
	else:
		open()

func _on_area_2d_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	obstructed = true


func _on_area_2d_body_shape_exited(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	obstructed = false
