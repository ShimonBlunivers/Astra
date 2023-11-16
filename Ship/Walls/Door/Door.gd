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


func _init() -> void:
	super(100)

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
	interact()

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
	if _body.name == "Player":
		interactable = true


func _on_interact_area_body_exited(_body: Node2D):
	if _body.name == "Player":
		interactable = false
