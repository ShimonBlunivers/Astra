class_name Player extends Character


@onready var walk_sound : AudioStreamPlayer2D = $Sounds/Walk
@onready var camera : Camera2D = $"../Camera2D"
@onready var vision : PointLight2D = $Vision/Light

var _sprite_dir := 69

var ship_controlled = null

var normal_zoom : float = 1
var ship_zoom : float = 0.2

var normal_vision : float = 14
var driving_vision : float = 1

var suit = true;

var use_range : float = 1000

var acceleration = Vector2(0, 0)
var _old_position = Vector2(0, 0)

var hovering_interactables := []
var hovering_controllables := []


# TODO: ✅ Make player controling zoom out so it's in the center of ship and is scalable with the ship size

# TODO: ✅ Add floating velocity

# TODO: ✅ Edit player vision so object that are in the dark cannot be seen (Using lights as mask)

# TODO: ✅ Add Damage & Death

# TODO: ✅  Fix wrong hitbox while ship moving

# TODO: Fix Michael Jackson walking
	
# TODO: Make walking up & down animations
	
# TODO: Change sounds according to walking terrain

# TODO: Add NPCs

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("debug_die"):
		damage(10)

	if event.is_action_pressed("debug_spawn"):
		spawn()

	if alive:
		if event.is_action_pressed("game_mb_left") && hovering_interactables.size() != 0:
			hovering_interactables[0].interact()

		if event.is_action_pressed("game_control") && hovering_controllables.size() != 0:
			hovering_controllables[0].interact()

func spawn():
	animated_sprite.play("Idle")
	alive = true
	health = max_health
	position = spawn_point
	health_updated_signal.emit()

func _ready():
	spawn_point = Vector2(280, 880)
	alive = true
	health = max_health
	position = spawn_point
	_old_position = position
	nickname = "Player_Samuel"
	

func kill():
	if !alive: return
	health = 0
	alive = false

	if ship_controlled != null: control_ship(ship_controlled)

	animated_sprite.play("Death")
	health_updated_signal.emit()
	died_signal.emit()


func _in_physics(delta: float) -> void:
	# print("Player position: ", position)
	if ship_controlled == null: 
		_move(delta)


func control_ship(ship):
	if ship != null:
		ship_controlled = ship
		walk_sound.stop()
		_sprite_dir = 0
		animated_sprite.flip_h = false
		animated_sprite.play("Idle")
		
		ship.start_controlling(self)
		change_view(0)
	else:
		change_view(1)
		if ship_controlled != null: ship_controlled.stop_controlling()
		ship_controlled = null


func _move(_delta: float) -> void:

	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var running := Input.get_action_strength("game_run")
	var _sound_pitch_range := [0.9, 1.1]
	
	if !alive: direction = Vector2.ZERO

	acceleration = (position - _old_position) /_delta
	var _before_move = _old_position
	_old_position = position

	if abs(acceleration.x) > Limits.VELOCITY_MAX or abs(acceleration.y) > Limits.VELOCITY_MAX:
		var new_speed = acceleration.normalized()
		new_speed *= Limits.VELOCITY_MAX
		acceleration = new_speed

	velocity = direction * (SPEED + RUN_SPEED_MODIFIER * running)

	# if floating(): 	return;


	if direction.x < 0:
		if !walk_sound.playing && !floating(): 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 1:
			_sprite_dir = 1
			animated_sprite.flip_h = true
			animated_sprite.play("WalkToSide")
		
	elif direction.x > 0:
		if !walk_sound.playing && !floating(): 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 2:
			_sprite_dir = 2
			animated_sprite.flip_h = false
			animated_sprite.play("WalkToSide")
		
	elif direction.y > 0: 
		if !walk_sound.playing && !floating(): 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 3:
			_sprite_dir = 3
			animated_sprite.flip_h = false
			animated_sprite.play("WalkDown")
			
	elif direction.y < 0: 
		if !walk_sound.playing && !floating(): 
			walk_sound.pitch_scale = randf_range(_sound_pitch_range[0], _sound_pitch_range[1])
			walk_sound.play()
		if _sprite_dir != 4:
			_sprite_dir = 4
			animated_sprite.flip_h = false
			animated_sprite.play("WalkUp")
		
	else:
		if alive && _sprite_dir != 0:
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
