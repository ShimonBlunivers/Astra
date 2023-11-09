extends Node2D


@onready var walkway : StaticBody2D = $Hitbox/StaticBody2DWalkway
@onready var hitbox : Control = $Hitbox
@onready var open_sound : AudioStreamPlayer2D = $Sound/DoorOpen
@onready var close_sound : AudioStreamPlayer2D = $Sound/DoorClose
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var direction := "horizontal"
var state := "closed"

var obstructed := false
var locked := false

var collision_layer = 1;
var occluder_light_mask = 1;


func _ready() -> void:
	if direction == "vertical":
		hitbox.rotation_degrees = 90;
		animated_sprite.rotation_degrees = 90
	animated_sprite.connect("frame_changed", _on_frame_changed)
	
func update_sprites():
	if state == "open":
		animated_sprite.play("open")
	else:
		animated_sprite.play_backwards("open")

func open():
	if locked:
		return
	state = "open"
	open_sound.play()
	update_sprites()
	
func close():
	if obstructed:
		return
	state = "closed"
	close_sound.play()
	update_sprites()
	walkway.set_collision_layer_value(collision_layer, true)

func _on_frame_changed():
	match animated_sprite.frame:
		3: #  OTEVŘENO
			$"Hitbox/AnimatedOccluders/0left".occluder_light_mask = 0;
			$"Hitbox/AnimatedOccluders/0right".occluder_light_mask = 0;
			$"Hitbox/AnimatedOccluders/1left".occluder_light_mask = 0;
			$"Hitbox/AnimatedOccluders/1right".occluder_light_mask = 0;
			$"Hitbox/AnimatedOccluders/2center".occluder_light_mask = 0;
		2:
			$"Hitbox/AnimatedOccluders/0left".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/0right".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/1left".occluder_light_mask = 0;
			$"Hitbox/AnimatedOccluders/1right".occluder_light_mask = 0;
			$"Hitbox/AnimatedOccluders/2center".occluder_light_mask = 0;
			if state == "open":
				walkway.set_collision_layer_value(collision_layer, false)
		1:
			$"Hitbox/AnimatedOccluders/0left".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/0right".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/1left".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/1right".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/2center".occluder_light_mask = 0;
		0: # ZAVŘENO
			$"Hitbox/AnimatedOccluders/0left".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/0right".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/1left".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/1right".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/2center".occluder_light_mask = occluder_light_mask;
			
func _on_button_pressed() -> void:
	if state == "open":
		close()
	else:
		open()

func _on_area_2d_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	obstructed = true


func _on_area_2d_body_shape_exited(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	obstructed = false
