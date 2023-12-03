extends CharacterBody2D


@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var walk_sound : AudioStreamPlayer2D = $Sounds/Walk
@onready var camera : Camera2D = $"../Camera2D"
@onready var vision : PointLight2D = $Vision/Light

const SPEED = 400.0
const RUN_SPEED_MODIFIER = 100.0

var _sprite_dir := 69

var ship_controlled = null

var normal_zoom : float = 1
var ship_zoom : float = 0.2

var normal_vision : float = 14
var driving_vision : float = 1

var suit = true;

var use_range : float = 1000


var _acceleration = Vector2(0, 0)
var _old_position = Vector2(0, 0)

var passenger_on := []


# TODO: ✅ Make player controling zoom out so it's in the center of ship and is scalable with the ship size

# TODO: ✅ Add floating velocity

# TODO: ✅ Edit player vision so object that are in the dark cannot be seen (Using lights as mask)

# TODO: Make walking up & down animations

# TODO: Add Damage & Death
	
# TODO: Change sounds according to walking terrain

# TODO: Add NPCs

# TODO: Fix wrong hitbox while ship moving

var _control_position = Vector2(0, 0);

func _ready():
	_old_position = position

func floating():
	return passenger_on.size() == 0

func _physics_process(delta: float) -> void:
	# print("Player position: ", position)
	if ship_controlled == null: 
		_move(delta)	
	_control_position = position

func control_ship(ship):

	if ship != null:
		ship_controlled = ship
		walk_sound.stop()
		_sprite_dir = 0
		animated_sprite.flip_h = false
		animated_sprite.play("Idle")
		
		ship.start_controlling()
		change_view(0)
	else:
		change_view(1)
		if ship_controlled != null: ship_controlled.stop_controlling()
		ship_controlled = null

func move(by: Vector2):
	position += by;

func get_in(ship:):
	passenger_on.append(ship)

func get_off(ship):
	passenger_on.erase(ship)


func _move(_delta: float) -> void:

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var running := Input.get_action_strength("ui_run")
	var _sound_pitch_range := [0.9, 1.1]

	_acceleration = position - _old_position
	var _before_move = _old_position
	_old_position = position

	velocity = direction * (SPEED + RUN_SPEED_MODIFIER * running)

	if floating(): 	
		if (_control_position == position): 
			position += _acceleration
		else:
			_old_position = _before_move
		if suit == false: 
			velocity = Vector2(0, 0)
		else: 
			velocity *= .01
			

	if direction.x < 0:
		if !walk_sound.playing: 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 1:
			_sprite_dir = 1
			animated_sprite.flip_h = true
			animated_sprite.play("WalkToSide")
		
	elif direction.x > 0:
		if !walk_sound.playing: 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 2:
			_sprite_dir = 2
			animated_sprite.flip_h = false
			animated_sprite.play("WalkToSide")
		
	elif direction.y > 0: 
		if !walk_sound.playing: 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 3:
			_sprite_dir = 3
			animated_sprite.flip_h = false
			animated_sprite.play("WalkDown")
			
	elif direction.y < 0: 
		if !walk_sound.playing: 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 4:
			_sprite_dir = 4
			animated_sprite.flip_h = false
			animated_sprite.play("WalkUp")
		
	else:
		if _sprite_dir != 0:
			_sprite_dir = 0
			animated_sprite.flip_h = false
			animated_sprite.play("Idle")
 

	move_and_slide()

func change_view(view: int) -> void:
	var tween = create_tween()

	var difference_between_ship_center = position - ship_controlled.position
	var ship_offset : Vector2 = (Vector2(ship_controlled.get_rect().position) * Vector2(ship_controlled.get_tile_size())) + (Vector2(ship_controlled.get_rect().size) * ship_controlled.get_tile_size()/2)
	var duration = 1
	
	match view:
		0: 
			tween.parallel().tween_property(camera, "zoom", Vector2(ship_zoom, ship_zoom), duration).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(camera, "offset", -difference_between_ship_center + ship_offset, duration).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(vision, "texture_scale", driving_vision, duration).set_ease(Tween.EASE_OUT)
		1: 
			tween.parallel().tween_property(camera, "zoom", Vector2(normal_zoom, normal_zoom), duration).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(camera, "offset", Vector2.ZERO, duration).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(vision, "texture_scale", normal_vision, duration).set_ease(Tween.EASE_OUT)
