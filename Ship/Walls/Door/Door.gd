class_name Door extends InteractableShipPart


@onready var walkway : StaticBody2D = $Hitbox/StaticBody2DWalkway
@onready var hitbox : Node2D = $Hitbox
@onready var open_sound : AudioStreamPlayer2D = $Sound/DoorOpen
@onready var close_sound : AudioStreamPlayer2D = $Sound/DoorClose
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

var direction := "horizontal"
var state := "closed"

var obstructed := false
var locked := false

var collision_layer = 1;
var occluder_light_mask = 1;


func init(_ship, _durability : float = 100, _mass : float = 3):
	super(_ship, _durability, _mass)

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
	open_sound.pitch_scale = randf_range(0.9, 1.1)
	open_sound.play()
	update_sprites()
	
func close():
	if obstructed:
		return
	state = "closed"
	close_sound.pitch_scale = randf_range(0.9, 1.1)
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

			$"Hitbox/AnimatedHitbox/0left".set_collision_layer_value(collision_layer, false)
			$"Hitbox/AnimatedHitbox/0right".set_collision_layer_value(collision_layer, false)
			$"Hitbox/AnimatedHitbox/1left".set_collision_layer_value(collision_layer, false)
			$"Hitbox/AnimatedHitbox/1right".set_collision_layer_value(collision_layer, false)
		2:
			$"Hitbox/AnimatedOccluders/0left".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/0right".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/1left".occluder_light_mask = 0;
			$"Hitbox/AnimatedOccluders/1right".occluder_light_mask = 0;
			$"Hitbox/AnimatedOccluders/2center".occluder_light_mask = 0;
			if state == "open":
				walkway.set_collision_layer_value(collision_layer, false)
				$"Hitbox/AnimatedHitbox/0left".set_collision_layer_value(collision_layer, true)
				$"Hitbox/AnimatedHitbox/0right".set_collision_layer_value(collision_layer, true)
				$"Hitbox/AnimatedHitbox/1left".set_collision_layer_value(collision_layer, false)
				$"Hitbox/AnimatedHitbox/1right".set_collision_layer_value(collision_layer, false)
		1:
			$"Hitbox/AnimatedOccluders/0left".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/0right".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/1left".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/1right".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/2center".occluder_light_mask = 0;
			if state == "open":
				$"Hitbox/AnimatedHitbox/0left".set_collision_layer_value(collision_layer, true)
				$"Hitbox/AnimatedHitbox/0right".set_collision_layer_value(collision_layer, true)
				$"Hitbox/AnimatedHitbox/1left".set_collision_layer_value(collision_layer, true)
				$"Hitbox/AnimatedHitbox/1right".set_collision_layer_value(collision_layer, true)
		0: # ZAVŘENO
			$"Hitbox/AnimatedOccluders/0left".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/0right".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/1left".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/1right".occluder_light_mask = occluder_light_mask;
			$"Hitbox/AnimatedOccluders/2center".occluder_light_mask = occluder_light_mask;

func _interact():
	if state == "open":
		close()
	else:
		open()

func _on_walkway_body_entered(_body: Node2D):
	obstructed = true

func _on_walkway_body_exited(_body: Node2D):
	obstructed = false

func _on_interact_area_body_entered(_body: Node2D):
	if _body.is_in_group("Player"):
		player_in_range = _body
		interactable = true

func _on_interact_area_body_exited(_body: Node2D):
	if _body.is_in_group("Player"):
		if self in _body.hovering_interactables: _body.hovering_interactables.erase(self)
		player_in_range = null
		interactable = false

func _on_hitbox_mouse_entered():
	if player_in_range != null:
		player_in_range.hovering_interactables.append(self)

func _on_hitbox_mouse_exited():
	if player_in_range != null && self in player_in_range.hovering_interactables:
		player_in_range.hovering_interactables.erase(self)
