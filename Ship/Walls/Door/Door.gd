class_name Door extends InteractableShipPart


@onready var walkway : StaticBody2D = $Hitbox/StaticBody2DWalkway
@onready var open_sound : AudioStreamPlayer2D = $Sound/DoorOpen
@onready var close_sound : AudioStreamPlayer2D = $Sound/DoorClose
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

@onready var mouse_hitbox : Node2D = $Hitbox/Area/MouseHitbox
@onready var door_area : Node2D = $Hitbox/Area/Area2D

var state := "closed"

var obstructed := false
var locked := false

var collision_layer = 1
var occluder_light_mask = 1

var interact_range = 300

var is_operating = false

func init(_ship, _coords : Vector2i, _durability : float = 100, _mass : float = 3):
	_ship.interactables.append(self)
	super(_ship, _coords, _durability, _mass)

func _ready() -> void:
	if direction == "vertical":
		rotation_degrees = 90
	animated_sprite.connect("frame_changed", _on_frame_changed)
	hitboxes_to_shift.append(mouse_hitbox)
	
func update_sprites():
	if state == "open":
		animated_sprite.play("open")
	else:
		animated_sprite.play_backwards("open")

func open():
	if locked:
		return
	state = "open"
	open_sound.pitch_scale = randf_range(0.9, 1.1)
	open_sound.play()
	update_sprites()
	
func close():
	state = "closed"
	close_sound.pitch_scale = randf_range(0.9, 1.1)
	close_sound.play()
	update_sprites()
	walkway.set_collision_layer_value(collision_layer, true)

func _on_frame_changed():

	match animated_sprite.frame:
		3: #  OTEVŘENO
			is_operating = state != "open"
			
			$"Hitbox/AnimatedOccluders/0left".occluder_light_mask = 0
			$"Hitbox/AnimatedOccluders/0right".occluder_light_mask = 0
			$"Hitbox/AnimatedOccluders/1left".occluder_light_mask = 0
			$"Hitbox/AnimatedOccluders/1right".occluder_light_mask = 0
			$"Hitbox/AnimatedOccluders/2center".occluder_light_mask = 0

			$"Hitbox/AnimatedHitbox/0left".set_collision_layer_value(collision_layer, false)
			$"Hitbox/AnimatedHitbox/0right".set_collision_layer_value(collision_layer, false)
			$"Hitbox/AnimatedHitbox/1left".set_collision_layer_value(collision_layer, false)
			$"Hitbox/AnimatedHitbox/1right".set_collision_layer_value(collision_layer, false)
		2:
			$"Hitbox/AnimatedOccluders/0left".occluder_light_mask = occluder_light_mask
			$"Hitbox/AnimatedOccluders/0right".occluder_light_mask = occluder_light_mask
			$"Hitbox/AnimatedOccluders/1left".occluder_light_mask = 0
			$"Hitbox/AnimatedOccluders/1right".occluder_light_mask = 0
			$"Hitbox/AnimatedOccluders/2center".occluder_light_mask = 0
			if state == "open":
				walkway.set_collision_layer_value(collision_layer, false)
				$"Hitbox/AnimatedHitbox/0left".set_collision_layer_value(collision_layer, true)
				$"Hitbox/AnimatedHitbox/0right".set_collision_layer_value(collision_layer, true)
				$"Hitbox/AnimatedHitbox/1left".set_collision_layer_value(collision_layer, false)
				$"Hitbox/AnimatedHitbox/1right".set_collision_layer_value(collision_layer, false)
		1:
			$"Hitbox/AnimatedOccluders/0left".occluder_light_mask = occluder_light_mask
			$"Hitbox/AnimatedOccluders/0right".occluder_light_mask = occluder_light_mask
			$"Hitbox/AnimatedOccluders/1left".occluder_light_mask = occluder_light_mask
			$"Hitbox/AnimatedOccluders/1right".occluder_light_mask = occluder_light_mask
			$"Hitbox/AnimatedOccluders/2center".occluder_light_mask = 0
			if state == "open":
				$"Hitbox/AnimatedHitbox/0left".set_collision_layer_value(collision_layer, true)
				$"Hitbox/AnimatedHitbox/0right".set_collision_layer_value(collision_layer, true)
				$"Hitbox/AnimatedHitbox/1left".set_collision_layer_value(collision_layer, true)
				$"Hitbox/AnimatedHitbox/1right".set_collision_layer_value(collision_layer, true)
		0: # ZAVŘENO
			$"Hitbox/AnimatedOccluders/0left".occluder_light_mask = occluder_light_mask
			$"Hitbox/AnimatedOccluders/0right".occluder_light_mask = occluder_light_mask
			$"Hitbox/AnimatedOccluders/1left".occluder_light_mask = occluder_light_mask
			$"Hitbox/AnimatedOccluders/1right".occluder_light_mask = occluder_light_mask
			$"Hitbox/AnimatedOccluders/2center".occluder_light_mask = occluder_light_mask
			is_operating = state != "closed"


func _interact():
	if ship.main_player.global_position.distance_to(global_position) > interact_range:
		return
	if is_operating:
		return

	# var tile = ship.get_tile(tilemap_coords + Vector2i(1, 0))
	# print(tile)
	# if tile != null:
	# 	tile.destroy()
	# ship.wall_tile_map.set_cell(0, tilemap_coords + Vector2i(1, 0), -1)

	if state == "open":
		if obstructed:
			return
		is_operating = true
		close()
	else:
		is_operating = true
		open()

# func _on_interact_area_body_entered(_body: Node2D):
# 	if _body.is_in_group("Player"):
# 		interactable = true

# func _on_interact_area_body_exited(_body: Node2D):
# 	if _body.is_in_group("Player"):
# 		interactable = false

func _on_hitbox_mouse_entered(): 
	ship.main_player.hovering_interactables.append(self)
	interactable = true

func _on_hitbox_mouse_exited():
	ship.main_player.hovering_interactables.erase(self)
	interactable = false


func _on_area_2d_area_entered(area:Area2D) -> void:
	if (area.is_in_group("PlayerInteractArea")):
		obstructed = true


func _on_area_2d_area_exited(area:Area2D) -> void:
	if (area.is_in_group("PlayerInteractArea")):
		obstructed = false
